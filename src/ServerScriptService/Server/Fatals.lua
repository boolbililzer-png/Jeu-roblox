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

function Fatals.play(fatalId, attacker, target)
	local scene = Fatals[fatalId] or Fatals.default
	scene(attacker, target)
end

return Fatals
