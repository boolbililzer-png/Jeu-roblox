-- HUD de combat : jauge de % (rouge à 150 %), vies, passif, statuts, chrono, bannières, résultats.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Knockback = require(Shared.Knockback)
local GameData = require(Shared.GameData)
local Fighters = require(Shared.Fighters)

local Hud = {}
local player = Players.LocalPlayer
local gui: ScreenGui
local cards: { [Model]: Frame } = {}
local row: Frame
local banner: TextLabel
local timer: TextLabel
local arenaLbl: TextLabel
local blind: Frame
local results: Frame
local metronome: Frame
local blackoutUntil = 0

local INK = Color3.fromRGB(20, 18, 58)
local AMBER = Color3.fromRGB(245, 158, 11)

local function label(parent: Instance, props): TextLabel
	local t = Instance.new("TextLabel")
	t.BackgroundTransparency = 1
	t.Font = Enum.Font.FredokaOne
	t.TextColor3 = Color3.new(1, 1, 1)
	t.TextScaled = true
	for k, v in props do
		(t :: any)[k] = v
	end
	t.Parent = parent
	return t
end

local function corner(parent: Instance, r: number)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = parent
end

local function stroke(parent: Instance, color: Color3, th: number)
	local s = Instance.new("UIStroke")
	s.Color = color
	s.Thickness = th
	s.Parent = parent
	return s
end

function Hud.banner(text: string, color: Color3?, dur: number?)
	banner.Text = text
	banner.TextColor3 = color or Color3.new(1, 1, 1)
	banner.TextTransparency = 0
	banner.TextStrokeTransparency = 0
	banner.Size = UDim2.fromScale(0.9, 0.16)
	TweenService:Create(banner, TweenInfo.new(0.25, Enum.EasingStyle.Back), { Size = UDim2.fromScale(0.8, 0.12) }):Play()
	local token = os.clock()
	banner:SetAttribute("Token", token)
	task.delay(dur or 1.2, function()
		if banner:GetAttribute("Token") == token then
			TweenService:Create(banner, TweenInfo.new(0.3), { TextTransparency = 1, TextStrokeTransparency = 1 }):Play()
		end
	end)
end

function Hud.blackout(dur: number)
	blackoutUntil = math.max(blackoutUntil, os.clock() + dur)
end

local function makeCard(model: Model): Frame
	local key = model:GetAttribute("Fighter")
	local data = Fighters.get(key)
	local f = Instance.new("Frame")
	f.Size = UDim2.new(0, 210, 1, 0)
	f.BackgroundColor3 = INK
	f.BackgroundTransparency = 0.15
	corner(f, 12)
	local st = stroke(f, Color3.fromRGB(60, 58, 130), 2)
	st.Name = "Stroke"
	local sw = Instance.new("Frame")
	sw.Name = "Swatch"
	sw.Size = UDim2.new(0, 52, 0, 52)
	sw.Position = UDim2.fromOffset(8, 10)
	sw.BackgroundColor3 = Color3.fromHex(data.look.body.torso)
	corner(sw, 10)
	stroke(sw, Color3.fromHex(data.look.body.head), 3)
	sw.Parent = f
	label(sw, { Text = tostring(data.num), Size = UDim2.fromScale(0.6, 0.6), Position = UDim2.fromScale(0.2, 0.2), TextStrokeTransparency = 0.2 })
	label(f, { Name = "Name", Text = model:GetAttribute("DisplayName") or data.name, Size = UDim2.new(1, -70, 0, 18), Position = UDim2.fromOffset(66, 6), TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamBold })
	label(f, { Name = "Pct", Text = "0 %", Size = UDim2.new(0, 96, 0, 40), Position = UDim2.fromOffset(66, 22), TextXAlignment = Enum.TextXAlignment.Left, TextStrokeTransparency = 0 })
	label(f, { Name = "Stocks", Text = "●●●", Size = UDim2.new(0, 46, 0, 18), Position = UDim2.new(1, -52, 0, 34), TextColor3 = AMBER, TextXAlignment = Enum.TextXAlignment.Right })
	local bar = Instance.new("Frame")
	bar.Name = "Bar"
	bar.Size = UDim2.new(1, -16, 0, 6)
	bar.Position = UDim2.new(0, 8, 1, -24)
	bar.BackgroundColor3 = Color3.fromRGB(45, 43, 100)
	bar.BorderSizePixel = 0
	corner(bar, 3)
	bar.Parent = f
	local fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.Size = UDim2.fromScale(0, 1)
	fill.BackgroundColor3 = AMBER
	fill.BorderSizePixel = 0
	corner(fill, 3)
	fill.Parent = bar
	label(f, { Name = "Passive", Text = "", Size = UDim2.new(1, -16, 0, 14), Position = UDim2.new(0, 8, 1, -17), TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamMedium, TextColor3 = Color3.fromRGB(200, 202, 240) })
	label(f, { Name = "Weapon", Text = "", Size = UDim2.new(0, 46, 0, 16), Position = UDim2.new(1, -52, 0, 52), TextXAlignment = Enum.TextXAlignment.Right })
	f.Parent = row
	return f
end

local function update()
	local state = ReplicatedStorage:FindFirstChild("GameState")
	local phase = state and state:GetAttribute("Phase") or "Lobby"
	local fighting = phase ~= "Lobby"
	row.Visible = fighting
	timer.Visible = fighting
	arenaLbl.Visible = fighting
	results.Visible = phase == "End"

	-- cartes des combattants
	local folder = workspace:FindFirstChild("Fighters")
	local seen = {}
	if folder and fighting then
		for _, m in folder:GetChildren() do
			if m:IsA("Model") and m:GetAttribute("Fighter") then
				seen[m] = true
				local card = cards[m] or makeCard(m)
				cards[m] = card
				local pct = m:GetAttribute("Damage") or 0
				local pctL = card:FindFirstChild("Pct") :: TextLabel
				pctL.Text = ("%d %%"):format(math.floor(pct))
				pctL.TextColor3 = Knockback.percentColor(pct)
				local stocks = m:GetAttribute("Stocks") or 0
				local stL = card:FindFirstChild("Stocks") :: TextLabel
				stL.Text = string.rep("●", stocks)
				local fill = card:FindFirstChild("Bar"):FindFirstChild("Fill") :: Frame
				fill.Size = UDim2.fromScale(m:GetAttribute("PassiveValue") or 0, 1)
				fill.BackgroundColor3 = if m:GetAttribute("PassiveHot") then Color3.fromRGB(255, 70, 70) else AMBER
				local pl = card:FindFirstChild("Passive") :: TextLabel
				pl.Text = m:GetAttribute("PassiveText") or ""
				local wl = card:FindFirstChild("Weapon") :: TextLabel
				wl.Text = if m:GetAttribute("Armed") then "🥊" else ""
				local stk = card:FindFirstChild("Stroke") :: UIStroke
				stk.Color = if m == player.Character then AMBER else Color3.fromRGB(60, 58, 130)
				card.BackgroundTransparency = if m:GetAttribute("Eliminated") then 0.6 else 0.15
			end
		end
	end
	for m, card in cards do
		if not seen[m] then
			card:Destroy()
			cards[m] = nil
		end
	end

	if state then
		local tl = state:GetAttribute("TimeLeft") or 0
		timer.Text = ("%d:%02d"):format(tl // 60, tl % 60)
		local arena = GameData.Arenas[state:GetAttribute("Arena") or "bar"]
		arenaLbl.Text = if arena then arena.name else ""
		local cd = state:GetAttribute("Countdown") or 0
		if phase == "Countdown" and cd > 0 and banner:GetAttribute("CD") ~= cd then
			banner:SetAttribute("CD", cd)
			Hud.banner(tostring(cd), AMBER, 0.8)
		elseif phase == "Fight" and banner:GetAttribute("CD") ~= 0 then
			banner:SetAttribute("CD", 0)
			Hud.banner("BAGARRE !", Color3.fromRGB(255, 80, 80), 1)
		end
		if phase == "End" then
			local w = state:GetAttribute("Winner") or ""
			local title = results:FindFirstChild("Title") :: TextLabel
			title.Text = "🏆 " .. w .. " gagne !"
			local body = results:FindFirstChild("Body") :: TextLabel
			body.Text = state:GetAttribute("Results") or ""
		elseif phase == "Lobby" then
			banner:SetAttribute("CD", nil)
		end
	end

	-- aveuglement (statut, piège d'arène)
	local me = player.Character
	local t = workspace:GetServerTimeNow()
	local blinded = os.clock() < blackoutUntil or (me and (me:GetAttribute("St_blind") or 0) > t)
	blind.BackgroundTransparency = if blinded then 0.08 else 1

	-- métronome de Gloria Zumba
	local isGloria = me and me:GetAttribute("Fighter") == "gloria"
	metronome.Visible = isGloria == true and fighting
	if metronome.Visible then
		local ph = t % 0.6
		local on = ph < 0.12 or ph > 0.48
		metronome.BackgroundColor3 = if on then Color3.fromRGB(57, 255, 20) else Color3.fromRGB(60, 60, 90)
		metronome.Size = if on then UDim2.fromOffset(34, 34) else UDim2.fromOffset(24, 24)
	end
end

function Hud.start()
	gui = Instance.new("ScreenGui")
	gui.Name = "BBHud"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = player:WaitForChild("PlayerGui")

	blind = Instance.new("Frame")
	blind.Size = UDim2.fromScale(1, 1)
	blind.BackgroundColor3 = Color3.new(0, 0, 0)
	blind.BackgroundTransparency = 1
	blind.ZIndex = 0
	blind.Parent = gui

	row = Instance.new("Frame")
	row.BackgroundTransparency = 1
	row.AnchorPoint = Vector2.new(0.5, 1)
	row.Position = UDim2.new(0.5, 0, 1, -10)
	row.Size = UDim2.new(1, -20, 0, 92)
	row.Parent = gui
	local list = Instance.new("UIListLayout")
	list.FillDirection = Enum.FillDirection.Horizontal
	list.HorizontalAlignment = Enum.HorizontalAlignment.Center
	list.Padding = UDim.new(0, 10)
	list.Parent = row
	local scale = Instance.new("UIScale")
	scale.Parent = row
	local function rescale()
		local w = workspace.CurrentCamera.ViewportSize.X
		scale.Scale = math.clamp(w / 1000, 0.55, 1)
	end
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(rescale)
	rescale()

	timer = label(gui, { Text = "5:00", AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 8), Size = UDim2.fromOffset(120, 40), TextStrokeTransparency = 0 })
	arenaLbl = label(gui, { Text = "", AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 48), Size = UDim2.fromOffset(360, 20), Font = Enum.Font.GothamBold, TextColor3 = Color3.fromRGB(220, 220, 255), TextStrokeTransparency = 0.4 })
	banner = label(gui, { Text = "", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.32), Size = UDim2.fromScale(0.8, 0.12), TextTransparency = 1, TextStrokeTransparency = 1, ZIndex = 5 })

	metronome = Instance.new("Frame")
	metronome.AnchorPoint = Vector2.new(0.5, 0.5)
	metronome.Position = UDim2.new(0.5, 0, 0, 90)
	metronome.Size = UDim2.fromOffset(24, 24)
	corner(metronome, 20)
	metronome.Visible = false
	metronome.Parent = gui

	results = Instance.new("Frame")
	results.AnchorPoint = Vector2.new(0.5, 0.5)
	results.Position = UDim2.fromScale(0.5, 0.45)
	results.Size = UDim2.fromScale(0.6, 0.45)
	results.BackgroundColor3 = INK
	results.BackgroundTransparency = 0.1
	results.Visible = false
	corner(results, 16)
	stroke(results, AMBER, 3)
	results.Parent = gui
	label(results, { Name = "Title", Text = "", Size = UDim2.new(1, -20, 0.25, 0), Position = UDim2.new(0, 10, 0, 10), TextColor3 = AMBER })
	label(results, { Name = "Body", Text = "", Size = UDim2.new(1, -40, 0.6, 0), Position = UDim2.new(0, 20, 0.32, 0), TextScaled = false, TextSize = 18, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top })

	RunService.RenderStepped:Connect(update)
end

return Hud
