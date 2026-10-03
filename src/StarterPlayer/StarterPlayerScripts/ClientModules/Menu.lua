-- Salon : choix du combattant (aperçu 3D qui tourne), liste des coups, réglages, bouton PRÊT.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local GameData = require(Shared.GameData)
local Fighters = require(Shared.Fighters)
local CharacterBuilder = require(Shared.CharacterBuilder)
local Pose = require(Shared.Pose)
local Net = require(Shared.Net)

local Menu = {}
local player = Players.LocalPlayer
local ToServer = Net.get("ToServer")

local INK = Color3.fromRGB(20, 18, 58)
local PANEL = Color3.fromRGB(32, 30, 84)
local AMBER = Color3.fromRGB(245, 158, 11)
local SLOT_COLOR = {
	P = Color3.fromRGB(239, 68, 68), S = Color3.fromRGB(59, 130, 246),
	Sup = Color3.fromRGB(16, 185, 129), air = Color3.fromRGB(139, 92, 246),
}

local gui: ScreenGui
local selected = "gege"
local ready = false
local preview: Model? = nil
local previewMotors = {}
local world: WorldModel
local vpCam: Camera
local info: Frame
local readyBtn: TextButton
local lobbyLbl: TextLabel
local botsLbl: TextLabel
local trapsBtn: TextButton
local gridButtons: { [string]: TextButton } = {}

local function corner(p: Instance, r: number)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = p
end

local function text(parent: Instance, props): TextLabel
	local t = Instance.new("TextLabel")
	t.BackgroundTransparency = 1
	t.TextColor3 = Color3.new(1, 1, 1)
	t.Font = Enum.Font.GothamMedium
	t.TextWrapped = true
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.TextYAlignment = Enum.TextYAlignment.Top
	for k, v in props do
		(t :: any)[k] = v
	end
	t.Parent = parent
	return t
end

local function button(parent: Instance, props): TextButton
	local b = Instance.new("TextButton")
	b.AutoButtonColor = true
	b.TextColor3 = Color3.new(1, 1, 1)
	b.Font = Enum.Font.FredokaOne
	b.TextScaled = true
	for k, v in props do
		(b :: any)[k] = v
	end
	corner(b, 10)
	b.Parent = parent
	return b
end

local function slotColor(slot: string): Color3
	if slot == "Sup" then
		return SLOT_COLOR.Sup
	elseif slot == "SairD" or string.sub(slot, 1, 4) == "Pair" then
		return SLOT_COLOR.air
	end
	return SLOT_COLOR[string.sub(slot, 1, 1)]
end

local function showPreview(key: string)
	if preview then
		preview:Destroy()
	end
	local m = CharacterBuilder.build(key, CFrame.new())
	CharacterBuilder.setArmed(m, true)
	local hum = m:FindFirstChildOfClass("Humanoid")
	if hum then
		hum:Destroy() -- inutile dans l'aperçu
	end
	for _, p in m:GetDescendants() do
		if p:IsA("BasePart") then
			p.Anchored = p.Name == "HumanoidRootPart"
		end
	end
	m.Parent = world
	preview = m
	previewMotors = CharacterBuilder.motors(m)
	local h = m:GetAttribute("ScaleH") or 1
	local w = m:GetAttribute("ScaleW") or 1
	local size = math.max(h, w * 0.8)
	vpCam.CFrame = CFrame.lookAt(Vector3.new(0, 3.2 * size, -14 * size), Vector3.new(0, 2.6 * size, 0))
end

local function renderInfo(key: string)
	local f = Fighters.get(key)
	for _, c in info:GetChildren() do
		if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then
			c:Destroy()
		end
	end
	text(info, { Text = f.name, Font = Enum.Font.FredokaOne, TextSize = 26, Size = UDim2.new(1, 0, 0, 30), LayoutOrder = 1 })
	text(info, {
		Text = ("%s · %s%s · Arène : %s"):format(f.style, string.rep("★", f.diff), string.rep("☆", 3 - f.diff), GameData.Arenas[f.arena].name),
		TextSize = 14, TextColor3 = Color3.fromRGB(190, 192, 235), Size = UDim2.new(1, 0, 0, 18), LayoutOrder = 2,
	})
	text(info, { Text = "🥊 Arme : " .. f.weapon, TextSize = 15, Size = UDim2.new(1, 0, 0, 20), LayoutOrder = 3 })
	text(info, { Text = "✨ " .. f.passiveName .. " — " .. f.passiveDesc, TextSize = 14, Size = UDim2.new(1, 0, 0, 40), LayoutOrder = 4 })
	local order = 5
	for _, slot in GameData.Slots do
		local mv = f.moves[slot]
		local row = Instance.new("Frame")
		row.BackgroundTransparency = 1
		row.Size = UDim2.new(1, 0, 0, 22)
		row.LayoutOrder = order
		order += 1
		row.Parent = info
		local tag = text(row, {
			Text = GameData.SlotLabel[slot], TextSize = 11, Font = Enum.Font.Code, TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center, BackgroundTransparency = 0, BackgroundColor3 = slotColor(slot),
			Size = UDim2.new(0, 150, 1, -4),
		})
		corner(tag, 5)
		text(row, { Text = mv.name, TextSize = 14, Font = Enum.Font.GothamBold, Position = UDim2.new(0, 158, 0, 2), Size = UDim2.new(1, -158, 1, 0) })
	end
	showPreview(key)
	for k, b in gridButtons do
		local st = b:FindFirstChildOfClass("UIStroke")
		if st then
			st.Color = if k == key then AMBER else Color3.fromRGB(60, 58, 130)
			st.Thickness = if k == key then 3 else 1
		end
	end
end

local function choose(key: string)
	selected = key
	ready = false
	ToServer:FireServer("select", key)
	renderInfo(key)
end

function Menu.start()
	gui = Instance.new("ScreenGui")
	gui.Name = "BBMenu"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.Parent = player:WaitForChild("PlayerGui")

	local root = Instance.new("Frame")
	root.Size = UDim2.fromScale(1, 1)
	root.BackgroundColor3 = INK
	root.BackgroundTransparency = 0.12
	root.Parent = gui

	local title = text(root, { Text = "BAGARRE BIZARRE", Font = Enum.Font.FredokaOne, TextScaled = true, TextXAlignment = Enum.TextXAlignment.Center, Position = UDim2.fromScale(0.25, 0.015), Size = UDim2.fromScale(0.5, 0.07), TextColor3 = AMBER })
	title.TextStrokeTransparency = 0.5

	-- Grille des 20 combattants
	local grid = Instance.new("ScrollingFrame")
	grid.Position = UDim2.fromScale(0.02, 0.1)
	grid.Size = UDim2.fromScale(0.44, 0.74)
	grid.BackgroundTransparency = 1
	grid.ScrollBarThickness = 6
	grid.AutomaticCanvasSize = Enum.AutomaticSize.Y
	grid.CanvasSize = UDim2.new()
	grid.Parent = root
	local gl = Instance.new("UIGridLayout")
	gl.CellSize = UDim2.new(0.235, 0, 0, 74)
	gl.CellPadding = UDim2.new(0.015, 0, 0, 8)
	gl.SortOrder = Enum.SortOrder.LayoutOrder
	gl.Parent = grid
	for _, f in GameData.Fighters do
		local b = button(grid, {
			Text = "", BackgroundColor3 = PANEL, LayoutOrder = (if f.launch then 0 else 100) + f.num,
		})
		local st = Instance.new("UIStroke")
		st.Color = Color3.fromRGB(60, 58, 130)
		st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		st.Parent = b
		local sw = Instance.new("Frame")
		sw.Size = UDim2.new(1, -12, 0, 26)
		sw.Position = UDim2.fromOffset(6, 6)
		sw.BackgroundColor3 = Color3.fromHex(f.look.body.torso)
		corner(sw, 6)
		sw.Parent = b
		local head = Instance.new("Frame")
		head.Size = UDim2.fromOffset(18, 18)
		head.AnchorPoint = Vector2.new(0.5, 0.5)
		head.Position = UDim2.fromScale(0.5, 0.5)
		head.BackgroundColor3 = Color3.fromHex(f.look.body.head)
		corner(head, 4)
		head.Parent = sw
		text(b, { Text = f.name, TextScaled = true, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Center, Position = UDim2.fromOffset(4, 36), Size = UDim2.new(1, -8, 0, 32) })
		if f.launch then
			text(b, { Text = "★", TextColor3 = AMBER, TextSize = 14, Position = UDim2.new(1, -16, 0, 2), Size = UDim2.fromOffset(14, 14) })
		end
		b.Activated:Connect(function()
			choose(f.key)
		end)
		gridButtons[f.key] = b
	end

	-- Aperçu 3D
	local vp = Instance.new("ViewportFrame")
	vp.Position = UDim2.fromScale(0.48, 0.1)
	vp.Size = UDim2.fromScale(0.22, 0.5)
	vp.BackgroundColor3 = PANEL
	vp.Ambient = Color3.fromRGB(200, 200, 220)
	vp.LightColor = Color3.new(1, 1, 1)
	vp.LightDirection = Vector3.new(0.5, -1, 0.6)
	corner(vp, 14)
	vp.Parent = root
	world = Instance.new("WorldModel")
	world.Parent = vp
	vpCam = Instance.new("Camera")
	vpCam.FieldOfView = 35
	vpCam.Parent = vp
	vp.CurrentCamera = vpCam

	-- Fiche + coups
	info = Instance.new("ScrollingFrame") :: any
	local infoS = info :: any
	infoS.Position = UDim2.fromScale(0.72, 0.1)
	infoS.Size = UDim2.fromScale(0.26, 0.74)
	infoS.BackgroundColor3 = PANEL
	infoS.ScrollBarThickness = 6
	infoS.AutomaticCanvasSize = Enum.AutomaticSize.Y
	infoS.CanvasSize = UDim2.new()
	corner(info, 14)
	info.Parent = root
	local pad = Instance.new("UIPadding")
	pad.PaddingLeft, pad.PaddingRight, pad.PaddingTop = UDim.new(0, 12), UDim.new(0, 12), UDim.new(0, 10)
	pad.Parent = info
	local il = Instance.new("UIListLayout")
	il.Padding = UDim.new(0, 4)
	il.SortOrder = Enum.SortOrder.LayoutOrder
	il.Parent = info

	-- Réglages + prêt
	local controls = Instance.new("Frame")
	controls.Position = UDim2.fromScale(0.48, 0.62)
	controls.Size = UDim2.fromScale(0.22, 0.22)
	controls.BackgroundTransparency = 1
	controls.Parent = root
	text(controls, { Text = "Bots", TextSize = 16, Font = Enum.Font.GothamBold, Size = UDim2.new(0.3, 0, 0.22, 0) })
	local minus = button(controls, { Text = "−", BackgroundColor3 = PANEL, Position = UDim2.fromScale(0.32, 0), Size = UDim2.fromScale(0.16, 0.22) })
	botsLbl = text(controls, { Text = "1", TextSize = 20, Font = Enum.Font.FredokaOne, TextXAlignment = Enum.TextXAlignment.Center, Position = UDim2.fromScale(0.5, 0), Size = UDim2.fromScale(0.16, 0.22) })
	local plus = button(controls, { Text = "+", BackgroundColor3 = PANEL, Position = UDim2.fromScale(0.68, 0), Size = UDim2.fromScale(0.16, 0.22) })
	trapsBtn = button(controls, { Text = "Pièges : ON", BackgroundColor3 = PANEL, Position = UDim2.fromScale(0, 0.28), Size = UDim2.fromScale(1, 0.2) })
	readyBtn = button(controls, { Text = "PRÊT !", BackgroundColor3 = AMBER, TextColor3 = INK, Position = UDim2.fromScale(0, 0.55), Size = UDim2.fromScale(1, 0.42) })

	local state = ReplicatedStorage:WaitForChild("GameState")
	minus.Activated:Connect(function()
		ToServer:FireServer("settings", { bots = (state:GetAttribute("BotsToFill") or 1) - 1 })
	end)
	plus.Activated:Connect(function()
		ToServer:FireServer("settings", { bots = (state:GetAttribute("BotsToFill") or 1) + 1 })
	end)
	trapsBtn.Activated:Connect(function()
		ToServer:FireServer("settings", { traps = not state:GetAttribute("Traps") })
	end)
	readyBtn.Activated:Connect(function()
		-- on envoie le perso et l'état « prêt » dans un seul message
		ready = not (player:GetAttribute("Ready") == true)
		ToServer:FireServer("ready", { key = selected, ready = ready })
	end)

	lobbyLbl = text(root, { Text = "", TextSize = 14, Position = UDim2.fromScale(0.02, 0.86), Size = UDim2.fromScale(0.44, 0.12), TextColor3 = Color3.fromRGB(200, 202, 240) })
	local help = if UserInputService.TouchEnabled
		then "Joystick : se déplacer · SAUT · P attaque légère · S signature (maintenir = charger) · ✋ ramasser / lancer / saisir · ESQ esquive"
		else "ZQSD/flèches : se déplacer · Espace : saut · J : P (léger) · K : S (signature, maintenir = charger) · L/Maj : esquive · E : ✋ ramasser / lancer / saisir"
	text(root, { Text = help, TextSize = 13, Position = UDim2.fromScale(0.48, 0.86), Size = UDim2.fromScale(0.5, 0.12), TextColor3 = Color3.fromRGB(200, 202, 240) })

	choose(selected)

	RunService.RenderStepped:Connect(function()
		local phase = state:GetAttribute("Phase")
		gui.Enabled = phase == "Lobby"
		if not gui.Enabled then
			ready = false
			return
		end
		if preview and preview.PrimaryPart then
			preview:PivotTo(CFrame.new(0, 2.8 * (preview:GetAttribute("ScaleH") or 1), 0) * CFrame.Angles(0, os.clock() * 0.8, 0))
			Pose.apply(previewMotors, Pose.Garde, preview:GetAttribute("ScaleW") or 1, preview:GetAttribute("ScaleH") or 1)
		end
		botsLbl.Text = tostring(state:GetAttribute("BotsToFill") or 1)
		trapsBtn.Text = if state:GetAttribute("Traps") then "Pièges : ON" else "Pièges : OFF"
		ready = player:GetAttribute("Ready") == true -- état confirmé par le serveur
		readyBtn.Text = if ready then "EN ATTENTE… (annuler)" else "PRÊT !"
		readyBtn.BackgroundColor3 = if ready then Color3.fromRGB(16, 185, 129) else AMBER
		local lines = {}
		for entry in string.gmatch(state:GetAttribute("Lobby") or "", "[^;]+") do
			local name, key, rd = string.match(entry, "^(.-):(.-):(%d)$")
			if name then
				local f = Fighters.get(key)
				table.insert(lines, ("%s %s — %s"):format(if rd == "1" then "✅" else "⏳", name, if f then f.name else "choisit…"))
			end
		end
		lobbyLbl.Text = "Joueurs : " .. table.concat(lines, "   ")
	end)
end

return Menu
