-- Construit le modèle 3D d'un combattant à partir de GameData (rig R15 commun + accessoires).
-- Même calcul que la visionneuse : C0 = pivot - centre(Part0), C1 = pivot - centre(Part1).
local GameData = require(script.Parent.GameData)

local CharacterBuilder = {}

local function v3(t, w: number, h: number): Vector3
	return Vector3.new(t[1] * w, t[2] * h, t[3] * w)
end

local function color(hex: string): Color3
	return Color3.fromHex(hex)
end

local function material(name: string?): Enum.Material
	local ok, m = pcall(function()
		return (Enum.Material :: any)[name or "SmoothPlastic"]
	end)
	return if ok and m then m else Enum.Material.SmoothPlastic
end

local function makePart(name: string, size: Vector3): Part
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.CanCollide = false
	p.CanTouch = false
	p.CanQuery = false
	p.Massless = true
	return p
end

-- Renvoie le Model prêt à être placé dans workspace (non parenté).
function CharacterBuilder.build(key: string, origin: CFrame?): Model
	local fighter
	for _, f in GameData.Fighters do
		if f.key == key then
			fighter = f
		end
	end
	assert(fighter, "Combattant inconnu : " .. tostring(key))
	local look = fighter.look
	local h, w = look.scale[1], look.scale[2]
	local base = origin or CFrame.new()
	local rigParts = GameData.Rig.Parts

	local model = Instance.new("Model")
	model.Name = fighter.name

	local parts: { [string]: BasePart } = {}
	for name, def in rigParts do
		local p = makePart(name, v3(def.size, w, h))
		p.CFrame = base * CFrame.new(v3(def.center, w, h))
		if name == "HumanoidRootPart" then
			p.Transparency = 1
			p.CanCollide = true
			p.CanQuery = true
			p.Massless = false
			p.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0, 1, 1)
		else
			local grp = GameData.Rig.ColorGroup[name]
			p.Color = color(look.body[grp])
			p.Material = material(look.materials[grp])
			p.Transparency = look.transparency[grp] or 0
		end
		p.Parent = model
		parts[name] = p
	end
	model.PrimaryPart = parts.HumanoidRootPart

	for _, j in GameData.Rig.Joints do
		local m = Instance.new("Motor6D")
		m.Name = j.name
		local c0 = rigParts[j.part0].center
		local c1 = rigParts[j.part1].center
		local pv = j.pivot
		m.Part0 = parts[j.part0]
		m.Part1 = parts[j.part1]
		m.C0 = CFrame.new(v3({ pv[1] - c0[1], pv[2] - c0[2], pv[3] - c0[3] }, w, h))
		m.C1 = CFrame.new(v3({ pv[1] - c1[1], pv[2] - c1[2], pv[3] - c1[3] }, w, h))
		m.Parent = parts[j.part1]
	end

	for i, a in look.acc do
		local target = parts[a.attach]
		local size = v3(a.size, w, h)
		local p = makePart("Acc" .. i, size)
		if a.shape == "Ball" then
			local mesh = Instance.new("SpecialMesh")
			mesh.MeshType = Enum.MeshType.Sphere
			mesh.Parent = p
		elseif a.shape == "Cyl" then
			p.Shape = Enum.PartType.Cylinder
		end
		p.Color = color(a.color)
		p.Material = material(a.mat)
		p.Transparency = a.tr or 0
		p.CFrame = target.CFrame
			* CFrame.new(v3(a.pos, w, h))
			* CFrame.Angles(math.rad(a.rot[1]), math.rad(a.rot[2]), math.rad(a.rot[3]))
		local weld = Instance.new("WeldConstraint")
		weld.Part0 = target
		weld.Part1 = p
		weld.Parent = p
		if a.weapon then
			p:SetAttribute("Weapon", true)
			p:SetAttribute("BaseTr", a.tr or 0)
			p.Transparency = 1
		end
		p.Parent = model
	end

	local hum = Instance.new("Humanoid")
	hum.RigType = Enum.HumanoidRigType.R15
	hum.HipHeight = GameData.Rig.HipHeight * h
	hum.AutoRotate = false
	hum.BreakJointsOnDeath = false
	hum.RequiresNeck = false
	hum.MaxHealth = math.huge
	hum.Health = math.huge
	hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	hum.UseJumpPower = true
	hum.JumpPower = 0
	hum.Parent = model

	model:SetAttribute("Fighter", key)
	model:SetAttribute("ScaleW", w)
	model:SetAttribute("ScaleH", h)
	return model
end

-- Affiche ou cache l'arme (Caisse Bizarre)
function CharacterBuilder.setArmed(model: Model, armed: boolean)
	for _, d in model:GetChildren() do
		if d:IsA("BasePart") and d:GetAttribute("Weapon") then
			d.Transparency = if armed then (d:GetAttribute("BaseTr") or 0) else 1
		end
	end
end

function CharacterBuilder.motors(model: Model): { [string]: Motor6D }
	local out = {}
	for _, d in model:GetDescendants() do
		if d:IsA("Motor6D") then
			out[d.Name] = d
		end
	end
	return out
end

return CharacterBuilder
