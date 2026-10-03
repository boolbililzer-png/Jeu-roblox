-- Caisses Bizarres : tombent du ciel, se ramassent avec ✋ et équipent l'arme emblématique
-- (le moveset passe des « mains nues » au moveset 100 % unique du perso).
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config"))

local Crates = {}
Crates.list = {} :: { BasePart }
local nextSpawn = 0

local function now(): number
	return workspace:GetServerTimeNow()
end

local function makeCrate(pos: Vector3): BasePart
	local p = Instance.new("Part")
	p.Name = "CaisseBizarre"
	p.Size = Vector3.new(3, 3, 3)
	p.Color = Color3.fromRGB(176, 112, 52)
	p.Material = Enum.Material.WoodPlanks
	p.CFrame = CFrame.new(pos)
	p.CollisionGroup = "Crate"
	p.CanTouch = false
	p.CustomPhysicalProperties = PhysicalProperties.new(2, 0.6, 0.1)
	for _, face in { Enum.NormalId.Front, Enum.NormalId.Back } do
		local gui = Instance.new("SurfaceGui")
		gui.Face = face
		gui.PixelsPerStud = 40
		local t = Instance.new("TextLabel")
		t.Size = UDim2.fromScale(1, 1)
		t.BackgroundTransparency = 1
		t.Text = "?"
		t.TextScaled = true
		t.Font = Enum.Font.FredokaOne
		t.TextColor3 = Color3.fromRGB(255, 214, 10)
		t.TextStrokeTransparency = 0
		t.Parent = gui
		gui.Parent = p
	end
	local light = Instance.new("PointLight")
	light.Color = Color3.fromRGB(255, 214, 10)
	light.Range = 10
	light.Brightness = 2
	light.Parent = p
	p:SetAttribute("Born", now())
	return p
end

function Crates.reset()
	for _, c in Crates.list do
		if c.Parent then
			c:Destroy()
		end
	end
	table.clear(Crates.list)
	nextSpawn = now() + Config.CrateFirstDelay
end

function Crates.tick(layout)
	local t = now()
	for i = #Crates.list, 1, -1 do
		local c = Crates.list[i]
		if not c.Parent or t - (c:GetAttribute("Born") or t) > Config.CrateLife or c.Position.Y < layout.blast.bottom then
			if c.Parent then
				c:Destroy()
			end
			table.remove(Crates.list, i)
		end
	end
	if t >= nextSpawn then
		nextSpawn = t + math.random(Config.CrateInterval[1], Config.CrateInterval[2])
		if #Crates.list < Config.CrateMax then
			-- au-dessus du sol principal ou d'une plateforme
			local spots = { { layout.stage.x, layout.stage.width * 0.8 } }
			for _, p in layout.platforms do
				table.insert(spots, { p[1], p[3] * 0.8 })
			end
			local s = spots[math.random(1, #spots)]
			local x = s[1] + (math.random() - 0.5) * s[2]
			local c = makeCrate(Vector3.new(x, 60, 0))
			c.Parent = workspace:FindFirstChild("Fx") or workspace
			table.insert(Crates.list, c)
		end
	end
end

function Crates.tryPickup(f): boolean
	local pos = f:position()
	for i, c in Crates.list do
		if c.Parent and (c.Position - pos).Magnitude <= Config.PickupRange then
			c:Destroy()
			table.remove(Crates.list, i)
			return true
		end
	end
	return false
end

return Crates
