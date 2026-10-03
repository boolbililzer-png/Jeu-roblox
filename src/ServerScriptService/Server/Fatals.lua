-- Mises en scène des coups fatals (100 % cartoon). Chaque fonction se termine quand l'animation est finie.
local Fatals = {}

local function shrink(model, toScale, steps, stepTime)
	local from = model:GetScale()
	for i = 1, steps do
		model:ScaleTo(from + (toScale - from) * i / steps)
		task.wait(stepTime)
	end
end

local function label(parent, text)
	local gui = Instance.new("BillboardGui")
	gui.Size = UDim2.fromOffset(200, 50)
	gui.StudsOffset = Vector3.new(0, 4, 0)
	gui.AlwaysOnTop = true
	local l = Instance.new("TextLabel")
	l.Size = UDim2.fromScale(1, 1)
	l.BackgroundTransparency = 1
	l.Text = text
	l.TextScaled = true
	l.Font = Enum.Font.FredokaOne
	l.TextColor3 = Color3.fromRGB(255, 230, 120)
	l.TextStrokeTransparency = 0
	l.Parent = gui
	gui.Parent = parent
end

-- Gégé : l'adversaire rétrécit, finit dans la bouteille, bouchonnée, étiquette « Cuvée 2026 »
Fatals.derniere_tournee = function(attacker, target)
	local root = target:FindFirstChild("HumanoidRootPart")
	local attackerRoot = attacker:FindFirstChild("HumanoidRootPart")
	if not root or not attackerRoot then
		return
	end
	local base = Vector3.new((root.Position.X + attackerRoot.Position.X) / 2, root.Position.Y, 0)

	local bottle = Instance.new("Part")
	bottle.Name = "BouteilleFatale"
	bottle.Shape = Enum.PartType.Cylinder
	bottle.Size = Vector3.new(7, 4, 4)
	bottle.CFrame = CFrame.new(base + Vector3.new(0, 1, 0)) * CFrame.Angles(0, 0, math.rad(90))
	bottle.Color = Color3.fromRGB(40, 140, 60)
	bottle.Material = Enum.Material.Glass
	bottle.Transparency = 0.4
	bottle.Anchored = true
	bottle.CanCollide = false
	bottle.CanQuery = false
	bottle.Parent = workspace

	shrink(target, 0.25, 12, 0.06)
	root.CFrame = CFrame.new(base + Vector3.new(0, 1, 0))
	task.wait(0.3)

	local cork = Instance.new("Part")
	cork.Name = "Bouchon"
	cork.Size = Vector3.new(1.4, 1, 1.4)
	cork.Position = base + Vector3.new(0, 5, 0)
	cork.Color = Color3.fromRGB(150, 100, 60)
	cork.Anchored = true
	cork.CanCollide = false
	cork.CanQuery = false
	cork.Parent = workspace
	label(bottle, "Cuvée 2026")
	task.wait(1.5)

	task.delay(3, function()
		bottle:Destroy()
		cork:Destroy()
	end)
end

-- Mise en scène par défaut si un fatal n'a pas encore la sienne : envoi en orbite
Fatals.default = function(_attacker, target)
	local root = target:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end
	for _ = 1, 20 do
		root.CFrame += Vector3.new(0, 4, 0)
		task.wait(0.03)
	end
end

------------------------------------------------------------------------ Scènes décrites dans les fiches
-- fatal.scene = liste d'étapes jouées dans l'ordre (la victime est figée pendant toute la scène) :
--   { "text", "LE PULL DE NOËL !" }                 bulle au-dessus de la victime
--   { "wait", 0.5 }
--   { "shrink", 0.3, time = 0.6 } / { "grow", 2 }   la victime rapetisse / grossit (échelle finale)
--   { "spawn", pieces = { … }, at = "target", offset = Vector3 (X compté vers la victime), life = 4 }
--        décor construit en pièces (même format que look.parts) ; at = "target", "attacker", "between", "above"
--   { "move", to = "attacker" / "between" / "above", offset = Vector3, time = 0.5 }  la victime glisse jusque-là
--   { "lift", 6, time = 0.6 }                       la victime monte de n studs
--   { "launch", Vector3.new(avant, haut, 0), time = 1 }  envoyée au loin (avant = loin du perso)
--   { "spin", 720, time = 0.8, axis = "y" }         la victime tourne sur elle-même
--   { "orbit", 6, turns = 2, time = 1.2 }           elle tourne autour du perso
--   { "color", Color3 } / { "material", "Slate" }   repeinte (statue, pull, glaçon…)
--   { "squash", 0.3 }                               aplatie comme une crêpe
--   { "hide" } / { "show" }                         disparaît / réapparaît
--   { "fx", { "burst", color = … } }                effet client (voir client/Fx.lua), joué sur la victime
--   { "fxAttacker", { "symbols", … } }              effet client joué sur le perso
local Costumes = require(script.Parent:WaitForChild("Costumes"))

local fxRemote = nil
function Fatals.setFxRemote(remote)
	fxRemote = remote
end

local function anchorPoint(at, attacker, target)
	local a = attacker:FindFirstChild("HumanoidRootPart")
	local t = target:FindFirstChild("HumanoidRootPart")
	if not a or not t then
		return Vector3.zero
	end
	if at == "attacker" then
		return a.Position
	elseif at == "between" then
		return (a.Position + t.Position) / 2
	elseif at == "above" then
		return t.Position + Vector3.new(0, 6, 0)
	end
	return t.Position
end

local function setParts(model, fn)
	for _, p in ipairs(model:GetDescendants()) do
		if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
			fn(p)
		end
	end
end

local function tweenRoot(root, toCFrame, time)
	local from = root.CFrame
	local steps = math.max(1, math.floor(time / 0.03))
	for i = 1, steps do
		root.CFrame = from:Lerp(toCFrame, i / steps)
		task.wait(0.03)
	end
end

local STEPS = {}

STEPS.text = function(step, _attacker, target)
	local head = target:FindFirstChild("Head") or target:FindFirstChild("HumanoidRootPart")
	if head then
		label(head, step[2])
	end
end

STEPS.wait = function(step)
	task.wait(step[2] or 0.5)
end

STEPS.shrink = function(step, _attacker, target)
	local time = step.time or 0.6
	shrink(target, step[2] or 0.3, math.max(1, math.floor(time / 0.05)), 0.05)
end
STEPS.grow = STEPS.shrink

STEPS.spawn = function(step, attacker, target, props)
	local model = Instance.new("Model")
	model.Name = step.name or "DecorFatal"
	-- les décalages en X sont comptés vers la victime (le décor se retourne avec le perso)
	local dir = 1
	local a, t = attacker:FindFirstChild("HumanoidRootPart"), target:FindFirstChild("HumanoidRootPart")
	if a and t and t.Position.X < a.Position.X then
		dir = -1
	end
	local offset = step.offset or Vector3.zero
	local base = anchorPoint(step.at or "target", attacker, target) + Vector3.new(offset.X * dir, offset.Y, offset.Z)
	for _, piece in ipairs(step.pieces or {}) do
		local part, offset = Costumes.buildPiece(piece)
		part.Anchored = true
		part.CanCollide = false
		part.CFrame = CFrame.new(base) * CFrame.new(offset.Position.X * dir, offset.Position.Y, offset.Position.Z) * (offset - offset.Position)
		part.Parent = model
	end
	model.Parent = workspace
	table.insert(props, model)
	task.delay(step.life or 5, function()
		model:Destroy()
	end)
end

STEPS.move = function(step, attacker, target)
	local root = target:FindFirstChild("HumanoidRootPart")
	if root then
		local a = attacker:FindFirstChild("HumanoidRootPart")
		local dir = (a and root.Position.X < a.Position.X) and -1 or 1
		local offset = step.offset or Vector3.zero
		local to = anchorPoint(step.to or "between", attacker, target) + Vector3.new(offset.X * dir, offset.Y, offset.Z)
		tweenRoot(root, CFrame.new(to) * (root.CFrame - root.Position), step.time or 0.5)
	end
end

STEPS.lift = function(step, _attacker, target)
	local root = target:FindFirstChild("HumanoidRootPart")
	if root then
		tweenRoot(root, root.CFrame + Vector3.new(0, step[2] or 6, 0), step.time or 0.6)
	end
end

STEPS.launch = function(step, attacker, target)
	local root = target:FindFirstChild("HumanoidRootPart")
	local a = attacker:FindFirstChild("HumanoidRootPart")
	if root and a then
		local dir = root.Position.X >= a.Position.X and 1 or -1
		local v = step[2] or Vector3.new(60, 60, 0)
		tweenRoot(root, root.CFrame + Vector3.new(v.X * dir, v.Y, v.Z), step.time or 1)
	end
end

STEPS.spin = function(step, _attacker, target)
	local root = target:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end
	local time = step.time or 0.8
	local steps = math.max(1, math.floor(time / 0.03))
	local per = math.rad(step[2] or 720) / steps
	for _ = 1, steps do
		if step.axis == "x" then
			root.CFrame *= CFrame.Angles(per, 0, 0)
		elseif step.axis == "z" then
			root.CFrame *= CFrame.Angles(0, 0, per)
		else
			root.CFrame *= CFrame.Angles(0, per, 0)
		end
		task.wait(0.03)
	end
end

STEPS.orbit = function(step, attacker, target)
	local root = target:FindFirstChild("HumanoidRootPart")
	local a = attacker:FindFirstChild("HumanoidRootPart")
	if not root or not a then
		return
	end
	local time = step.time or 1.2
	local steps = math.max(1, math.floor(time / 0.03))
	local radius = step[2] or 6
	for i = 1, steps do
		local angle = (i / steps) * math.pi * 2 * (step.turns or 2)
		root.CFrame = CFrame.new(a.Position + Vector3.new(math.cos(angle) * radius, 2 + math.sin(angle) * radius * 0.6, 0))
		task.wait(0.03)
	end
end

STEPS.color = function(step, _attacker, target)
	setParts(target, function(p)
		p.Color = step[2]
	end)
end

STEPS.material = function(step, _attacker, target)
	setParts(target, function(p)
		p.Material = Enum.Material[step[2]] or Enum.Material.SmoothPlastic
	end)
end

STEPS.squash = function(step, _attacker, target)
	local root = target:FindFirstChild("HumanoidRootPart")
	if root then
		local scale = target:GetScale()
		target:ScaleTo(scale * 0.98)
		-- aplatie : on la couche au sol
		tweenRoot(root, root.CFrame * CFrame.Angles(math.rad(-90), 0, 0) - Vector3.new(0, 2.2, 0), step.time or 0.25)
	end
end

STEPS.hide = function(_step, _attacker, target)
	setParts(target, function(p)
		p:SetAttribute("FatalTransparency", p.Transparency)
		p.Transparency = 1
	end)
end

STEPS.show = function(_step, _attacker, target)
	setParts(target, function(p)
		p.Transparency = p:GetAttribute("FatalTransparency") or 0
	end)
end

STEPS.fx = function(step, _attacker, target)
	if fxRemote then
		fxRemote:FireAllClients("FatalFx", { model = target, fx = step[2] })
	end
end

STEPS.fxAttacker = function(step, attacker)
	if fxRemote then
		fxRemote:FireAllClients("FatalFx", { model = attacker, fx = step[2] })
	end
end

local function playScene(scene, attacker, target)
	local props = {}
	-- apparence d'origine, rendue à la fin (repeinte en statue, pull…)
	local saved = {}
	setParts(target, function(p)
		saved[p] = { p.Color, p.Material, p.Transparency }
	end)
	for _, step in ipairs(scene) do
		if not target.Parent or not attacker.Parent then
			break
		end
		local fn = STEPS[step[1]]
		if fn then
			local ok, err = pcall(fn, step, attacker, target, props)
			if not ok then
				warn("[Fatal] étape " .. tostring(step[1]) .. " : " .. tostring(err))
			end
		end
	end
	-- la victime retrouve son apparence (elle repart de toute façon au retour)
	for p, look in pairs(saved) do
		if p.Parent then
			p.Color, p.Material, p.Transparency = look[1], look[2], look[3]
		end
	end
end

function Fatals.play(fatalId, attacker, target, fatal)
	if fatal and fatal.scene then
		playScene(fatal.scene, attacker, target)
		return
	end
	local scene = Fatals[fatalId] or Fatals.default
	scene(attacker, target)
end

return Fatals
