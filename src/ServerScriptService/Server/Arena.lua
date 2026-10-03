-- Arène de test : « Le Bar-Tabac Chez Gégé », construite par code (aucun modèle à importer).
--
-- Disposition (de bas en haut) :
--   rebords bas à gauche et à droite (pleins, avec un geyser de soda chacun)
--   sol principal (plein, on ne passe pas au travers)
--   plateformes fines « Traversables » : on saute au travers par en dessous, ↓ maintenu pour redescendre
--     - deux tables de bar à mi-hauteur, une étagère en haut au centre, deux balcons sur les côtés
--     - un plateau de serveur qui va et vient tout en haut
-- Murs invisibles devant et derrière : le combat reste sur un seul plan.
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config"))

local Arena = {}
Arena.SOFT_TAG = "Traversable" -- plateformes fines (chaque client les rend traversables pour son perso)

local WOOD = Color3.fromRGB(120, 80, 50)
local DARK_WOOD = Color3.fromRGB(85, 55, 35)
local ZINC = Color3.fromRGB(170, 175, 180)
local WALL = Color3.fromRGB(150, 60, 50)
local NEON = Color3.fromRGB(255, 120, 200)
local SODA = Color3.fromRGB(170, 220, 60)

local function part(parent, name, size, position, color, props)
	local p = Instance.new("Part")
	p.Name = name
	p.Anchored = true
	p.Size = size
	p.Position = position
	p.Color = color
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	for key, value in pairs(props or {}) do
		p[key] = value
	end
	p.Parent = parent
	return p
end

local function sign(parent, text, position, size, color)
	local board = part(parent, "Enseigne", size, position, Color3.fromRGB(30, 20, 30), { CanCollide = false, CanQuery = false })
	local gui = Instance.new("SurfaceGui")
	gui.Face = Enum.NormalId.Back -- face tournée vers la caméra
	gui.LightInfluence = 0
	gui.Parent = board
	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextScaled = true
	label.Font = Enum.Font.FredokaOne
	label.TextColor3 = color or NEON
	label.Parent = gui
end

-- Plateforme fine (traversable), avec un liseré lumineux sur la tranche pour la reconnaître
local function softPlatform(parent, name, width, center, color, material)
	local top = part(parent, name, Vector3.new(width, 1, 12), center, color, { Material = material or Enum.Material.Metal })
	CollectionService:AddTag(top, Arena.SOFT_TAG)
	local edge = part(top, "Lisere", Vector3.new(width, 0.25, 0.3), center + Vector3.new(0, 0.3, 4), NEON, { Anchored = false, CanCollide = false, CanQuery = false, Massless = true, Material = Enum.Material.Neon })
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = top
	weld.Part1 = edge
	weld.Parent = edge
	return top
end

-- Position et vitesse du plateau qui va et vient (même calcul sur les clients, à partir de l'heure du serveur)
function Arena.movingState(t)
	local m = Config.MOVING_PLATFORM
	local x = m.amplitude * math.sin(t * m.speed)
	local vx = m.amplitude * m.speed * math.cos(t * m.speed)
	return CFrame.new(x, m.y, 0), Vector3.new(vx, 0, 0)
end

function Arena.build()
	-- Le modèle « Baseplate » de Roblox Studio gênerait les chutes dans le vide
	local baseplate = workspace:FindFirstChild("Baseplate")
	if baseplate then
		baseplate:Destroy()
	end

	local folder = Instance.new("Folder")
	folder.Name = "Arena"

	-- Sols pleins
	part(folder, "SolPrincipal", Vector3.new(90, 4, 12), Vector3.new(0, 0, 0), WOOD, { Material = Enum.Material.WoodPlanks })
	part(folder, "RebordGauche", Vector3.new(16, 3, 12), Vector3.new(-63, -8, 0), DARK_WOOD, { Material = Enum.Material.WoodPlanks })
	part(folder, "RebordDroit", Vector3.new(16, 3, 12), Vector3.new(63, -8, 0), DARK_WOOD, { Material = Enum.Material.WoodPlanks })

	-- Plateformes fines
	softPlatform(folder, "TableGauche", 20, Vector3.new(-28, 15, 0), ZINC)
	softPlatform(folder, "TableDroite", 20, Vector3.new(28, 15, 0), ZINC)
	softPlatform(folder, "Etagere", 16, Vector3.new(0, 29, 0), WOOD, Enum.Material.WoodPlanks)
	softPlatform(folder, "BalconGauche", 14, Vector3.new(-56, 26, 0), ZINC)
	softPlatform(folder, "BalconDroit", 14, Vector3.new(56, 26, 0), ZINC)
	local moving = softPlatform(folder, "PlateauServeur", Config.MOVING_PLATFORM.width, Vector3.new(0, Config.MOVING_PLATFORM.y, 0), Color3.fromRGB(200, 200, 210))
	moving:SetAttribute("Moving", true)

	-- Murs invisibles : le combat reste sur un seul plan
	part(folder, "MurAvant", Vector3.new(500, 500, 1), Vector3.new(0, 50, 3.5), Color3.new(), { Transparency = 1, CanQuery = false })
	part(folder, "MurArriere", Vector3.new(500, 500, 1), Vector3.new(0, 50, -3.5), Color3.new(), { Transparency = 1, CanQuery = false })

	-- Décor du bar
	local decor = Instance.new("Folder")
	decor.Name = "Decor"
	decor.Parent = folder
	local noCollide = { CanCollide = false, CanQuery = false }
	part(decor, "MurDuBar", Vector3.new(220, 110, 2), Vector3.new(0, 25, -30), WALL, { CanCollide = false, CanQuery = false, Material = Enum.Material.Brick })
	part(decor, "Comptoir", Vector3.new(50, 8, 6), Vector3.new(-10, -6, -22), ZINC, { CanCollide = false, CanQuery = false, Material = Enum.Material.DiamondPlate })
	part(decor, "JukeBox", Vector3.new(8, 14, 4), Vector3.new(30, -3, -24), NEON, { CanCollide = false, CanQuery = false, Material = Enum.Material.Neon })
	part(decor, "DistributeurDeSoda", Vector3.new(7, 16, 4), Vector3.new(-40, -2, -24), SODA, noCollide)
	for i, x in ipairs({ -28, 28 }) do
		part(decor, "PiedDeTable" .. i, Vector3.new(1.5, 13, 1.5), Vector3.new(x, 8, -3), DARK_WOOD, noCollide)
	end
	for i, x in ipairs({ -56, 56 }) do
		part(decor, "Rambarde" .. i, Vector3.new(14, 2.5, 0.4), Vector3.new(x, 27.8, -5.5), ZINC, noCollide)
	end
	sign(decor, "CHEZ GÉGÉ", Vector3.new(0, 66, -28.5), Vector3.new(50, 10, 1))
	sign(decor, "HAPPY HOUR", Vector3.new(-62, 44, -28.5), Vector3.new(28, 6, 1), SODA)
	sign(decor, "SODA DOUTEUX 1€", Vector3.new(62, 44, -28.5), Vector3.new(30, 6, 1), Color3.fromRGB(255, 200, 60))

	folder.Parent = workspace

	local projectiles = Instance.new("Folder")
	projectiles.Name = "Projectiles"
	projectiles.Parent = workspace

	-- Le plateau va et vient. Les clients font le même calcul pour que les joueurs posés dessus soient
	-- emportés sans saccade ; la version du serveur sert au mannequin et aux objets.
	RunService.Heartbeat:Connect(function()
		local cframe, velocity = Arena.movingState(workspace:GetServerTimeNow())
		moving.CFrame = cframe
		moving.AssemblyLinearVelocity = velocity
	end)

	local lighting = game:GetService("Lighting")
	lighting.ClockTime = 20
	lighting.Ambient = Color3.fromRGB(120, 90, 110)
	lighting.OutdoorAmbient = Color3.fromRGB(140, 110, 130)
end

-- Geysers de soda (piège de l'arène, coupé avec Config.ARENA_HAZARDS) : de temps en temps un rebord
-- bouillonne puis crache un jet qui envoie en l'air ceux qui sont dessus. onErupt(position) applique l'éjection.
function Arena.startHazards(fxRemote, onErupt)
	if not Config.ARENA_HAZARDS then
		return
	end
	local spots = { Vector3.new(-63, -6.5, 0), Vector3.new(63, -6.5, 0) }
	task.spawn(function()
		task.wait(15)
		while true do
			local spot = spots[math.random(#spots)]
			if fxRemote then
				fxRemote:FireAllClients("GeyserWarn", { position = spot })
			end
			task.wait(1.3)
			if fxRemote then
				fxRemote:FireAllClients("Geyser", { position = spot })
			end
			onErupt(spot)
			task.wait(math.random(9, 14))
		end
	end)
end

return Arena
