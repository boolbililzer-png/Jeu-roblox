-- Construit l'arène : sol principal suspendu + 3 plateformes traversables (disposition commune)
-- et le décor 3D en arrière-plan propre à chaque perso (peu de polygones, priorité mobile).
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameData = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("GameData"))

local ArenaBuilder = {}

local function mat(name: string?): Enum.Material
	local ok, m = pcall(function()
		return (Enum.Material :: any)[name or "SmoothPlastic"]
	end)
	return if ok and m then m else Enum.Material.SmoothPlastic
end

local function part(parent: Instance, size: Vector3, cf: CFrame, color: Color3, material: Enum.Material?): Part
	local p = Instance.new("Part")
	p.Anchored = true
	p.Size = size
	p.CFrame = cf
	p.Color = color
	p.Material = material or Enum.Material.SmoothPlastic
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent
	return p
end

local function folder(name: string, parent: Instance): Folder
	local f = Instance.new("Folder")
	f.Name = name
	f.Parent = parent
	return f
end

function ArenaBuilder.build(arenaKey: string): Model
	local old = workspace:FindFirstChild("Arena")
	if old then
		old:Destroy()
	end
	local def = GameData.Arenas[arenaKey] or GameData.Arenas.bar
	local L = GameData.Layout
	local model = Instance.new("Model")
	model.Name = "Arena"
	model:SetAttribute("Key", arenaKey)
	model:SetAttribute("DisplayName", def.name)
	local solid = folder("Solid", model)
	local soft = folder("Soft", model)
	local decor = folder("Decor", model)

	local floorC = Color3.fromHex(def.floor)
	local trimC = Color3.fromHex(def.trim)
	local skyC = Color3.fromHex(def.sky)

	-- Sol principal (bords = murs où l'on peut glisser et rebondir)
	local st = L.stage
	part(solid, Vector3.new(st.width, st.thickness, 14), CFrame.new(st.x, st.top - st.thickness / 2, 0), floorC, Enum.Material.SmoothPlastic)
	local trim = part(solid, Vector3.new(st.width + 0.4, 0.6, 14.4), CFrame.new(st.x, st.top - 0.3, 0), trimC)
	trim.Name = "Trim"
	part(solid, Vector3.new(st.width * 0.6, 8, 12), CFrame.new(st.x, st.top - st.thickness - 4, 0), floorC:Lerp(Color3.new(0, 0, 0), 0.3))

	-- Plateformes traversables par le dessous
	for i, p in L.platforms do
		local x, y, w = p[1], p[2], p[3]
		local pl = part(soft, Vector3.new(w, 1, 10), CFrame.new(x, y - 0.5, 0), trimC:Lerp(floorC, 0.35))
		pl.Name = "Plateforme" .. i
		pl.CollisionGroup = "Soft"
	end

	-- Décor (derrière les combattants : Z négatif, la caméra est côté +Z)
	for _, d in def.decor do
		local cf = CFrame.new(d.pos[1], d.pos[2], -d.pos[3])
			* CFrame.Angles(math.rad(d.rot[1]), math.rad(d.rot[2]), math.rad(d.rot[3]))
		local p = part(decor, Vector3.new(d.size[1], d.size[2], d.size[3]), cf, Color3.fromHex(d.color), mat(d.mat))
		p.CanCollide = false
		p.CanQuery = false
		p.CanTouch = false
		p.Transparency = d.tr or 0
		if d.shape == "Ball" then
			p.Shape = Enum.PartType.Ball
		elseif d.shape == "Cyl" then
			p.Shape = Enum.PartType.Cylinder
		end
	end

	-- Fond de ciel
	local sky = part(decor, Vector3.new(600, 300, 2), CFrame.new(0, 40, -80), skyC, Enum.Material.SmoothPlastic)
	sky.CanCollide, sky.CanQuery, sky.CanTouch, sky.CastShadow = false, false, false, false

	-- Public : figurants sur des gradins
	local crowd = folder("Crowd", decor)
	local crowdC = Color3.fromHex(def.crowd)
	for i = 1, 14 do
		local x = -52 + i * 7 + (math.random() - 0.5) * 2
		local z = -14 - (i % 2) * 4
		local y = -2 + (i % 2) * 3
		local body = part(crowd, Vector3.new(2, 3, 1.4), CFrame.new(x, y, z), crowdC:Lerp(Color3.new(math.random(), math.random(), math.random()), 0.3))
		local head = part(crowd, Vector3.new(1.4, 1.4, 1.4), CFrame.new(x, y + 2.3, z), Color3.fromRGB(240, 200, 160))
		for _, p in { body, head } do
			p.CanCollide, p.CanQuery, p.CanTouch = false, false, false
		end
		body:SetAttribute("CrowdPhase", math.random() * 6)
		head:SetAttribute("CrowdPhase", body:GetAttribute("CrowdPhase"))
	end
	part(decor, Vector3.new(110, 3, 10), CFrame.new(0, -5, -17), floorC:Lerp(Color3.new(0, 0, 0), 0.5)).CanCollide = false

	-- Lumière d'ambiance
	Lighting.Ambient = skyC:Lerp(Color3.new(1, 1, 1), 0.55)
	Lighting.OutdoorAmbient = skyC:Lerp(Color3.new(1, 1, 1), 0.6)
	Lighting.FogEnd = 100000

	model.Parent = workspace
	return model
end

return ArenaBuilder
