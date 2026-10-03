-- Arène construite par code (aucun modèle à importer), au thème choisi dans shared/Arenas.lua.
--
-- Disposition (de bas en haut) :
--   rebords bas à gauche et à droite (pleins, avec un geyser de soda chacun)
--   sol principal (plein, on ne passe pas au travers)
--   plateformes fines « Traversables » : on saute au travers par en dessous, ↓ maintenu pour redescendre
--     - deux plateformes à mi-hauteur, une en haut au centre, deux balcons sur les côtés
--     - un plateau qui va et vient tout en haut
-- Le piège de chaque arène est dans server/Hazards.lua.
-- Murs invisibles devant et derrière : le combat reste sur un seul plan.
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config"))

local Arena = {}
Arena.SOFT_TAG = "Traversable" -- plateformes fines (chaque client les rend traversables pour son perso)

local NEON = Color3.fromRGB(255, 120, 200) -- liseré des plateformes fines (couleur de l'arène)

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

local function material(name, fallback)
	local ok, value = pcall(function()
		return Enum.Material[name]
	end)
	return ok and value or fallback or Enum.Material.SmoothPlastic
end

local function decorPiece(parent, spec)
	local name, shape, size, position, color, mat, options = spec[1], spec[2], spec[3], spec[4], spec[5], spec[6], spec[7] or {}
	local p
	if shape == "wedge" then
		p = Instance.new("WedgePart")
		p.Anchored = true
		p.Size = size
		p.Position = position
		p.Color = color
		p.Name = name
		p.Parent = parent
	else
		p = part(parent, name, size, position, color)
		if shape == "ball" then
			p.Shape = Enum.PartType.Ball
		elseif shape == "cyl" then
			p.Shape = Enum.PartType.Cylinder
			-- un cylindre Roblox est couché sur X ; axis = "y" (par défaut) le dresse, "z" le tourne vers la caméra
			local axis = options.axis or "y"
			local length = axis == "x" and size.X or axis == "z" and size.Z or size.Y
			local diameter = axis == "x" and size.Y or math.max(size.X, axis == "z" and size.Y or size.Z)
			p.Size = Vector3.new(length, diameter, diameter)
			if axis == "y" then
				p.CFrame = CFrame.new(position) * CFrame.Angles(0, 0, math.rad(90))
			elseif axis == "z" then
				p.CFrame = CFrame.new(position) * CFrame.Angles(0, math.rad(90), 0)
			end
		end
	end
	p.Material = material(mat)
	p.CanCollide = false
	p.CanQuery = false
	p.CanTouch = false
	p.Transparency = options.transparency or 0
	p.Reflectance = options.reflect or 0
	return p
end

-- Public : figurants simples (corps + tête) ; chaque client les fait se balancer (client/Fx.lua)
local function buildCrowd(parent, crowd)
	if not crowd then
		return
	end
	for i, place in ipairs(crowd.places or {}) do
		local color = crowd.colors[(i - 1) % #crowd.colors + 1]
		local model = Instance.new("Model")
		model.Name = "Figurant" .. i
		local body = part(model, "Corps", Vector3.new(3, 4, 2), place, color, { CanCollide = false, CanQuery = false, CanTouch = false })
		local head = part(model, "Tete", Vector3.new(2.2, 2.2, 2.2), place + Vector3.new(0, 3.2, 0), Color3.fromRGB(235, 190, 150), { CanCollide = false, CanQuery = false, CanTouch = false, Shape = Enum.PartType.Ball })
		model.PrimaryPart = body
		model:SetAttribute("Phase", (i * 0.37) % 1)
		CollectionService:AddTag(model, "Public")
		model.Parent = parent
		local _ = head
	end
end

local current = nil

-- Construit l'arène (theme = id de shared/Arenas.lua). La disposition de combat ne change jamais.
function Arena.build(themeId)
	local Arenas = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Arenas"))
	local theme = Arenas.BY_ID[themeId or ""] or Arenas.BY_ID[Arenas.DEFAULT]
	-- Le modèle « Baseplate » de Roblox Studio gênerait les chutes dans le vide
	local baseplate = workspace:FindFirstChild("Baseplate")
	if baseplate then
		baseplate:Destroy()
	end
	local old = workspace:FindFirstChild("Arena")
	if old then
		old:Destroy()
	end
	current = theme
	workspace:SetAttribute("ArenaId", theme.id)
	workspace:SetAttribute("ArenaName", theme.name)

	local folder = Instance.new("Folder")
	folder.Name = "Arena"
	local softColor, softMaterial = theme.soft[1], material(theme.soft[2], Enum.Material.Metal)
	NEON = theme.edge or NEON

	-- Sols pleins
	part(folder, "SolPrincipal", Vector3.new(90, 4, 12), Vector3.new(0, 0, 0), theme.floor[1], { Material = material(theme.floor[2]) })
	part(folder, "RebordGauche", Vector3.new(16, 3, 12), Vector3.new(-63, -8, 0), theme.ledge[1], { Material = material(theme.ledge[2]) })
	part(folder, "RebordDroit", Vector3.new(16, 3, 12), Vector3.new(63, -8, 0), theme.ledge[1], { Material = material(theme.ledge[2]) })

	-- Plateformes fines
	softPlatform(folder, "PlateformeGauche", 20, Vector3.new(-28, 15, 0), softColor, softMaterial)
	softPlatform(folder, "PlateformeDroite", 20, Vector3.new(28, 15, 0), softColor, softMaterial)
	softPlatform(folder, "PlateformeHaute", 16, Vector3.new(0, 29, 0), softColor, softMaterial)
	softPlatform(folder, "BalconGauche", 14, Vector3.new(-56, 26, 0), softColor, softMaterial)
	softPlatform(folder, "BalconDroit", 14, Vector3.new(56, 26, 0), softColor, softMaterial)
	local moving = softPlatform(folder, "PlateauMobile", Config.MOVING_PLATFORM.width, Vector3.new(0, Config.MOVING_PLATFORM.y, 0), softColor, softMaterial)
	moving:SetAttribute("Moving", true)

	-- Murs invisibles : le combat reste sur un seul plan
	part(folder, "MurAvant", Vector3.new(500, 500, 1), Vector3.new(0, 50, 3.5), Color3.new(), { Transparency = 1, CanQuery = false })
	part(folder, "MurArriere", Vector3.new(500, 500, 1), Vector3.new(0, 50, -3.5), Color3.new(), { Transparency = 1, CanQuery = false })

	-- Décor (fond seulement)
	local decor = Instance.new("Folder")
	decor.Name = "Decor"
	decor.Parent = folder
	part(decor, "MurDuFond", Vector3.new(220, 110, 2), Vector3.new(0, 25, -30), theme.wall[1], { CanCollide = false, CanQuery = false, Material = material(theme.wall[2]) })
	for _, spec in ipairs(theme.decor or {}) do
		decorPiece(decor, spec)
	end
	for _, s in ipairs(theme.signs or {}) do
		sign(decor, s[1], s[2], s[3], s[4])
	end
	buildCrowd(decor, theme.crowd)

	folder.Parent = workspace

	if not workspace:FindFirstChild("Projectiles") then
		local projectiles = Instance.new("Folder")
		projectiles.Name = "Projectiles"
		projectiles.Parent = workspace
	end

	-- Le plateau va et vient. Les clients font le même calcul pour que les joueurs posés dessus soient
	-- emportés sans saccade ; la version du serveur sert aux bots, au mannequin et aux objets.
	if Arena.movingConnection then
		Arena.movingConnection:Disconnect()
	end
	Arena.movingConnection = RunService.Heartbeat:Connect(function()
		local cframe, velocity = Arena.movingState(workspace:GetServerTimeNow())
		moving.CFrame = cframe
		moving.AssemblyLinearVelocity = velocity
	end)

	local lighting = game:GetService("Lighting")
	lighting.ClockTime = theme.sky[1]
	lighting.Ambient = theme.sky[2]
	lighting.OutdoorAmbient = theme.sky[3]
	return theme
end

function Arena.current()
	return current
end

return Arena
