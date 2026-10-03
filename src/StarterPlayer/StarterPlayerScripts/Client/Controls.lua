-- Commandes : joystick tactile flottant + 6 boutons, et clavier pour tester sur PC.
-- Jamais deux boutons en même temps : une direction (pouce gauche) + un bouton (pouce droit).
--
-- Clavier : Roblox lit la POSITION des touches (disposition QWERTY), pas la lettre imprimée.
-- Les mêmes touches physiques donnent donc ZQSD sur un clavier AZERTY et WASD sur un QWERTY.
--   Direction : ZQSD (AZERTY) / WASD (QWERTY) ou flèches
--   J = P, K = K, L = S (maintenir = S chargé), Espace = SAUT, Maj gauche = ESQUIVE, Y = SUPER, T = recharge ⚡
--   O maintenu = recharge d'énergie (bouton ⚡ sur téléphone)
--   U = MAIN (✋) : ramasser un objet, lancer l'objet tenu, saisir puis projeter l'adversaire
--   H = afficher / cacher l'aide des touches
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config"))

local Controls = {}
Controls.__index = Controls

local JOYSTICK_RADIUS = 60

local DIRECTION_KEYS = {
	[Enum.KeyCode.A] = Vector2.new(-1, 0),
	[Enum.KeyCode.Left] = Vector2.new(-1, 0),
	[Enum.KeyCode.D] = Vector2.new(1, 0),
	[Enum.KeyCode.Right] = Vector2.new(1, 0),
	[Enum.KeyCode.W] = Vector2.new(0, 1),
	[Enum.KeyCode.Up] = Vector2.new(0, 1),
	[Enum.KeyCode.S] = Vector2.new(0, -1),
	[Enum.KeyCode.Down] = Vector2.new(0, -1),
}

local BUTTON_KEYS = {
	[Enum.KeyCode.J] = "P",
	[Enum.KeyCode.K] = "K",
	[Enum.KeyCode.L] = "S",
	[Enum.KeyCode.Space] = "SAUT",
	[Enum.KeyCode.LeftShift] = "ESQUIVE",
	[Enum.KeyCode.Y] = "SUPER",
	[Enum.KeyCode.T] = "CHARGE",
	[Enum.KeyCode.U] = "MAIN",
	-- emotes (à part des attaques)
	[Enum.KeyCode.One] = "EMOTE_1",
	[Enum.KeyCode.Two] = "EMOTE_2",
	[Enum.KeyCode.Three] = "EMOTE_3",
	[Enum.KeyCode.Four] = "EMOTE_4",
}

-- Les 4 emotes du bouton 😀 (voir shared/CommonMoves.lua)
local EMOTES = { { "EMOTE_1", "👋" }, { "EMOTE_2", "💃" }, { "EMOTE_3", "😂" }, { "EMOTE_4", "💪" } }

-- name, texte, couleur, position (part de l'écran), taille (part de la hauteur)
local BUTTONS = {
	{ "SAUT", "SAUT", Color3.fromRGB(235, 235, 235), Vector2.new(0.91, 0.8), 0.2 },
	{ "P", "P", Color3.fromRGB(230, 60, 60), Vector2.new(0.77, 0.86), 0.17 },
	{ "K", "K", Color3.fromRGB(60, 110, 230), Vector2.new(0.8, 0.63), 0.17 },
	{ "S", "S", Color3.fromRGB(240, 200, 40), Vector2.new(0.92, 0.55), 0.17 },
	{ "ESQUIVE", "ESQ", Color3.fromRGB(60, 190, 90), Vector2.new(0.66, 0.7), 0.14 },
	{ "SUPER", "⭐", Color3.fromRGB(255, 170, 0), Vector2.new(0.67, 0.46), 0.15 },
	{ "CHARGE", "⚡", Color3.fromRGB(70, 170, 255), Vector2.new(0.555, 0.88), 0.13 },
	{ "MAIN", "✋", Color3.fromRGB(170, 90, 220), Vector2.new(0.8, 0.42), 0.14 },
	{ "EMOTE", "😀", Color3.fromRGB(90, 90, 110), Vector2.new(0.95, 0.12), 0.1 },
}

function Controls.new()
	local self = setmetatable({}, Controls)
	self.keysDown = {}
	self.touchVector = Vector2.zero
	self.joystickTouch = nil
	self.sPressedAt = nil
	self.buttons = {}
	local pressedEvent = Instance.new("BindableEvent")
	self.Pressed = pressedEvent.Event -- envoie : "P", "K", "P_RELEASE", "K_RELEASE", "S", "S_HOLD", "SAUT", "ESQUIVE", "SUPER", "CHARGE", "CHARGE_END", "MAIN"
	self._fire = function(name)
		pressedEvent:Fire(name)
	end

	self:_bindKeyboard()
	if UserInputService.KeyboardEnabled then
		self:_buildKeyboardHelp()
	end
	if UserInputService.TouchEnabled or Config.FORCE_TOUCH_UI then
		self:_buildTouchUi()
	end
	return self
end

-- S part au relâchement : tap = S, maintenu = S_HOLD. CHARGE dure tant que la touche est maintenue.
-- P et K partent à l'appui ; leur relâchement est aussi signalé (frappe chargée façon Smash).
function Controls:_press(name)
	if name == "EMOTE" then
		-- le bouton 😀 ouvre ou ferme la petite roue des emotes
		if self.emotePanel then
			self.emotePanel.Visible = not self.emotePanel.Visible
		end
		return
	end
	self.held = self.held or {}
	self.held[name] = true
	if name == "S" then
		self.sPressedAt = os.clock()
	else
		self._fire(name)
	end
end

-- Bouton maintenu (SAUT maintenu = plané du Capitaine Canard)
function Controls:isHeld(name)
	return self.held ~= nil and self.held[name] == true
end

function Controls:_release(name)
	if self.held then
		self.held[name] = false
	end
	if name == "S" and self.sPressedAt then
		local held = os.clock() - self.sPressedAt
		self.sPressedAt = nil
		self._fire(held >= Config.HOLD_TIME and "S_HOLD" or "S")
	elseif name == "CHARGE" then
		self._fire("CHARGE_END")
	elseif name == "P" or name == "K" then
		self._fire(name .. "_RELEASE")
	end
end

function Controls:_bindKeyboard()
	UserInputService.InputBegan:Connect(function(input, processed)
		-- Maj sert au verrouillage de caméra Roblox par défaut (et d'autres touches à Roblox) : Roblox les marque
		-- « déjà traitées » alors que notre caméra est scriptée. On ne les ignore que si l'on tape dans un champ texte.
		if processed and (UserInputService:GetFocusedTextBox() ~= nil or not (BUTTON_KEYS[input.KeyCode] or DIRECTION_KEYS[input.KeyCode])) then
			return
		end
		if input.KeyCode == Enum.KeyCode.H and self.helpPanel then
			self.helpToggled = true
			self.helpPanel.Visible = not self.helpPanel.Visible
		elseif DIRECTION_KEYS[input.KeyCode] then
			self.keysDown[input.KeyCode] = true
		elseif BUTTON_KEYS[input.KeyCode] then
			self:_press(BUTTON_KEYS[input.KeyCode])
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if DIRECTION_KEYS[input.KeyCode] then
			self.keysDown[input.KeyCode] = nil
		elseif BUTTON_KEYS[input.KeyCode] then
			self:_release(BUTTON_KEYS[input.KeyCode])
		end
	end)
end

function Controls:_buildTouchUi()
	local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
	local gui = Instance.new("ScreenGui")
	gui.Name = "Commandes"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.Parent = playerGui

	-- Joystick flottant : il apparaît là où le pouce gauche se pose
	local base = Instance.new("Frame")
	base.Name = "Joystick"
	base.AnchorPoint = Vector2.new(0.5, 0.5)
	base.Size = UDim2.fromOffset(JOYSTICK_RADIUS * 2, JOYSTICK_RADIUS * 2)
	base.Position = UDim2.fromScale(0.15, 0.75)
	base.BackgroundColor3 = Color3.new(1, 1, 1)
	base.BackgroundTransparency = 0.75
	base.Parent = gui
	Instance.new("UICorner", base).CornerRadius = UDim.new(1, 0)
	local knob = Instance.new("Frame")
	knob.AnchorPoint = Vector2.new(0.5, 0.5)
	knob.Size = UDim2.fromScale(0.5, 0.5)
	knob.Position = UDim2.fromScale(0.5, 0.5)
	knob.BackgroundColor3 = Color3.new(1, 1, 1)
	knob.BackgroundTransparency = 0.3
	knob.Parent = base
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

	local center = Vector2.zero
	UserInputService.TouchStarted:Connect(function(touch, processed)
		if processed or self.joystickTouch then
			return
		end
		local screen = gui.AbsoluteSize
		if touch.Position.X > screen.X * 0.45 then
			return
		end
		self.joystickTouch = touch
		center = Vector2.new(touch.Position.X, touch.Position.Y)
		base.Position = UDim2.fromOffset(center.X, center.Y)
	end)
	UserInputService.TouchMoved:Connect(function(touch)
		if touch ~= self.joystickTouch then
			return
		end
		local delta = Vector2.new(touch.Position.X, touch.Position.Y) - center
		if delta.Magnitude > JOYSTICK_RADIUS then
			delta = delta.Unit * JOYSTICK_RADIUS
		end
		knob.Position = UDim2.new(0.5, delta.X, 0.5, delta.Y)
		self.touchVector = Vector2.new(delta.X, -delta.Y) / JOYSTICK_RADIUS
	end)
	UserInputService.TouchEnded:Connect(function(touch)
		if touch ~= self.joystickTouch then
			return
		end
		self.joystickTouch = nil
		self.touchVector = Vector2.zero
		knob.Position = UDim2.fromScale(0.5, 0.5)
	end)

	for _, spec in ipairs(BUTTONS) do
		local name, text, color, position, size = spec[1], spec[2], spec[3], spec[4], spec[5]
		local button = Instance.new("TextButton")
		button.Name = name
		button.AnchorPoint = Vector2.new(0.5, 0.5)
		button.SizeConstraint = Enum.SizeConstraint.RelativeYY
		button.Size = UDim2.fromScale(size, size)
		button.Position = UDim2.fromScale(position.X, position.Y)
		button.BackgroundColor3 = color
		button.BackgroundTransparency = 0.2
		button.Text = text
		button.TextScaled = true
		button.Font = Enum.Font.FredokaOne
		button.TextColor3 = Color3.new(1, 1, 1)
		button.TextStrokeTransparency = 0.3
		button.AutoButtonColor = false
		button.Parent = gui
		Instance.new("UICorner", button).CornerRadius = UDim.new(1, 0)
		if name == "CHARGE" then
			-- pas de marge intérieure ici : elle décalerait la jauge accrochée sous le bouton
			button.Text = ""
			local icon = Instance.new("TextLabel")
			icon.BackgroundTransparency = 1
			icon.AnchorPoint = Vector2.new(0.5, 0.5)
			icon.Position = UDim2.fromScale(0.5, 0.5)
			icon.Size = UDim2.fromScale(0.56, 0.56)
			icon.Text = text
			icon.TextScaled = true
			icon.Font = Enum.Font.FredokaOne
			icon.TextColor3 = Color3.new(1, 1, 1)
			icon.Parent = button
		else
			local padding = Instance.new("UIPadding", button)
			padding.PaddingTop = UDim.new(0.22, 0)
			padding.PaddingBottom = UDim.new(0.22, 0)
		end

		button.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
				button.BackgroundTransparency = 0
				button:SetAttribute("Held", true)
				self:_press(name)
			end
		end)
		button.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
				button.BackgroundTransparency = 0.2
				button:SetAttribute("Held", false)
				self:_release(name)
			end
		end)
		self.buttons[name] = button
	end
	self.buttons.SUPER.Visible = false

	-- roue des emotes : 4 boutons sous le bouton 😀
	local panel = Instance.new("Frame")
	panel.Name = "Emotes"
	panel.BackgroundTransparency = 1
	panel.AnchorPoint = Vector2.new(1, 0)
	panel.Position = UDim2.fromScale(0.99, 0.19)
	panel.SizeConstraint = Enum.SizeConstraint.RelativeYY
	panel.Size = UDim2.fromScale(0.42, 0.11)
	panel.Visible = false
	panel.Parent = gui
	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	layout.Padding = UDim.new(0.02, 0)
	layout.Parent = panel
	for _, emote in ipairs(EMOTES) do
		local b = Instance.new("TextButton")
		b.SizeConstraint = Enum.SizeConstraint.RelativeYY
		b.Size = UDim2.fromScale(1, 1)
		b.BackgroundColor3 = Color3.fromRGB(90, 90, 110)
		b.Text = emote[2]
		b.TextScaled = true
		b.Parent = panel
		Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
		b.Activated:Connect(function()
			panel.Visible = false
			self._fire(emote[1])
		end)
	end
	self.emotePanel = panel

	-- ⚡ : petite jauge d'énergie sous le bouton, et contour qui pulse pendant la recharge
	local charge = self.buttons.CHARGE
	local gauge = Instance.new("Frame")
	gauge.Name = "Jauge"
	gauge.AnchorPoint = Vector2.new(0.5, 0)
	gauge.Position = UDim2.fromScale(0.5, 1.06)
	gauge.Size = UDim2.fromScale(0.9, 0.14)
	gauge.BackgroundColor3 = Color3.fromRGB(30, 40, 60)
	gauge.BorderSizePixel = 0
	gauge.Parent = charge
	Instance.new("UICorner", gauge).CornerRadius = UDim.new(1, 0)
	local fill = Instance.new("Frame")
	fill.Name = "Remplissage"
	fill.Size = UDim2.fromScale(1, 1)
	fill.BackgroundColor3 = Color3.fromRGB(110, 210, 255)
	fill.BorderSizePixel = 0
	fill.Parent = gauge
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(200, 245, 255)
	stroke.Thickness = 4
	stroke.Transparency = 1
	stroke.Parent = charge
end

-- Lettre réellement imprimée sur la touche du joueur (ex. KeyCode.W -> « Z » sur AZERTY)
local function keyLabel(keyCode)
	local ok, text = pcall(UserInputService.GetStringForKeyCode, UserInputService, keyCode)
	if ok and text and text ~= "" then
		return string.upper(text)
	end
	return keyCode.Name
end

-- action, touches AZERTY, touches QWERTY
local HELP_ROWS = {
	{ "Gauche / Droite", "Q / D", "A / D" },
	{ "Haut / Bas", "Z / S", "W / S" },
	{ "Coup de poing (P)", "J", "J" },
	{ "Coup de pied (K)", "K", "K" },
	{ "Frappe chargée", "maintenir J ou K au sol", "hold J or K on ground" },
	{ "Spécial (S)", "L, ↑L, →L, ↓L", "L, ↑L, →L, ↓L" },
	{ "Spécial chargé", "maintenir L", "hold L" },
	{ "Saut / double saut", "Espace", "Space" },
	{ "Esquive", "Maj gauche", "Left Shift" },
	{ "Main ✋ : ramasser / lancer", "U (+ flèche pour viser)", "U (+ arrow to aim)" },
	{ "Passer sous une plateforme", "maintenir bas", "hold down" },
	{ "3 Supers / fatal", "↑Y, →Y (ou Y), ↓Y", "↑Y, →Y (or Y), ↓Y" },
	{ "Recharge énergie", "maintenir T", "hold T" },
	{ "Dash", "2× gauche ou droite", "2× left or right" },
	{ "Combos J / K", "J J J, J K J, K J K, K K J…", "J J J, J K J, K J K, K K J…" },
	{ "Combos fléchés", "flèche + J ou K, puis J / K", "arrow + J or K, then J / K" },
	{ "Finir un combo", "… puis L (coûte de l'énergie)", "… then L (uses energy)" },
	{ "En l'air", "saut puis J K J…, L ou ↓ L", "jump then J K J…, L or ↓ L" },
	{ "Attaque en course", "J, K ou L pendant le dash", "J, K or L while dashing" },
	{ "Emotes", "1, 2, 3, 4", "1, 2, 3, 4" },
	{ "Victoire", "le plus de points : +1 éjection, -1 chute", "most points: +1 KO, -1 fall" },
}

-- Panneau d'aide clavier : la colonne de la disposition détectée est mise en avant
function Controls:_buildKeyboardHelp()
	local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
	local gui = Instance.new("ScreenGui")
	gui.Name = "AideClavier"
	gui.ResetOnSpawn = false
	gui.DisplayOrder = 5
	gui.Parent = playerGui

	-- La touche physique « A » d'un QWERTY s'appelle « Q » sur un AZERTY
	local azerty = keyLabel(Enum.KeyCode.A) == "Q"
	local layoutName = azerty and "AZERTY" or "QWERTY"

	local hint = Instance.new("TextLabel")
	hint.Name = "Astuce"
	hint.AnchorPoint = Vector2.new(0, 1)
	hint.Position = UDim2.new(0, 10, 1, -10)
	hint.Size = UDim2.fromOffset(260, 22)
	hint.BackgroundTransparency = 0.5
	hint.BackgroundColor3 = Color3.new(0, 0, 0)
	hint.TextColor3 = Color3.new(1, 1, 1)
	hint.Font = Enum.Font.GothamBold
	hint.TextSize = 14
	hint.Text = "H : touches (clavier " .. layoutName .. ")"
	hint.Parent = gui
	Instance.new("UICorner", hint).CornerRadius = UDim.new(0, 6)

	local panel = Instance.new("Frame")
	panel.Name = "Panneau"
	panel.AnchorPoint = Vector2.new(0.5, 0.5)
	panel.Position = UDim2.fromScale(0.5, 0.45)
	panel.Size = UDim2.fromOffset(720, 70 + #HELP_ROWS * 23)
	panel.BackgroundColor3 = Color3.fromRGB(25, 20, 35)
	panel.BackgroundTransparency = 0.1
	panel.Parent = gui
	Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 12)
	local stroke = Instance.new("UIStroke", panel)
	stroke.Color = Color3.fromRGB(255, 170, 0)
	stroke.Thickness = 3

	local function cell(text, x, y, width, bold, highlight)
		local label = Instance.new("TextLabel")
		label.BackgroundTransparency = 1
		label.Position = UDim2.fromOffset(x, y)
		label.Size = UDim2.fromOffset(width, 24)
		label.Font = bold and Enum.Font.GothamBlack or Enum.Font.Gotham
		label.TextSize = bold and 16 or 15
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextColor3 = highlight and Color3.fromRGB(255, 200, 60) or Color3.fromRGB(230, 230, 230)
		label.Text = text
		label.Parent = panel
	end
	cell("TOUCHES (H pour fermer) — ton clavier : " .. layoutName, 18, 10, 690, true, false)
	cell("Action", 18, 40, 190, true, false)
	cell("AZERTY", 210, 40, 250, true, azerty)
	cell("QWERTY", 465, 40, 250, true, not azerty)
	for i, row in ipairs(HELP_ROWS) do
		local y = 40 + i * 23
		cell(row[1], 18, y, 190, false, false)
		cell(row[2], 210, y, 250, azerty, azerty)
		cell(row[3], 465, y, 250, not azerty, not azerty)
	end

	self.helpPanel = panel
	-- ouvert au lancement, puis se range tout seul
	task.delay(10, function()
		if not self.helpToggled then
			panel.Visible = false
		end
	end)
end

-- Le bouton ✋ dit ce qu'il va faire : PRENDS (caisse ou objet au sol), ou l'icône de l'objet tenu à lancer
function Controls:setHandLabel(text, color)
	local button = self.buttons.MAIN
	if button and button:GetAttribute("Label") ~= text then
		button:SetAttribute("Label", text)
		button.Text = text
		button.TextScaled = true
		button.BackgroundColor3 = color or Color3.fromRGB(170, 90, 220)
	end
end

-- Le bouton ⭐ n'apparaît que lorsque la jauge Super est pleine
function Controls:setSuperReady(ready)
	if self.buttons.SUPER then
		self.buttons.SUPER.Visible = ready
	end
end

-- Énergie : le bouton S se grise s'il n'y a plus assez d'énergie, le bouton ⚡ se remplit et pulse en recharge
function Controls:setEnergy(fraction, enough, charging)
	local s = self.buttons.S
	if s then
		s.BackgroundTransparency = enough and (s:GetAttribute("Held") and 0 or 0.2) or 0.65
		s.TextTransparency = enough and 0 or 0.5
	end
	local charge = self.buttons.CHARGE
	if charge then
		local fill = charge:FindFirstChild("Remplissage", true)
		if fill then
			fill.Size = UDim2.fromScale(math.clamp(fraction, 0, 1), 1)
		end
		local stroke = charge:FindFirstChildOfClass("UIStroke")
		if stroke then
			stroke.Transparency = charging and (0.5 + 0.5 * math.sin(os.clock() * 12)) or 1
		end
	end
end

-- Vecteur de direction : X vers la droite, Y vers le haut, longueur max 1
function Controls:getMoveVector()
	if self.joystickTouch then
		return self.touchVector
	end
	local v = Vector2.zero
	for key in pairs(self.keysDown) do
		v += DIRECTION_KEYS[key]
	end
	if v.Magnitude > 1 then
		v = v.Unit
	end
	return v
end

return Controls
