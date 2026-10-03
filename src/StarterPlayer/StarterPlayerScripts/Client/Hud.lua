-- Affichage : % de dégâts, points (ou vies), jauge Super, barre d'énergie et statut de chaque combattant,
-- objet tenu (avec le compte à rebours de la bombe), couleur d'équipe, chrono de la manche, message central (COMBAT !, victoire…) et invite « TERMINE-LE ! ».
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared:WaitForChild("Config"))
local CharacterList = require(Shared:WaitForChild("CharacterList"))
local Items = require(Shared:WaitForChild("Items"))
local Statuses = require(Shared:WaitForChild("Statuses"))

local Hud = {}

local STATUS_TEXT = {
	inverted = "🔄 Commandes inversées",
	stunned = "💫 Étourdi",
}
for name, info in pairs(Statuses.LIST) do
	STATUS_TEXT[name] = STATUS_TEXT[name] or (info.icon .. " " .. string.lower(info.text))
end
local TRACK_TEXT = { rap = "🎤 Rap", slow = "💕 Slow", techno = "🎛️ Techno" }

-- Jauge propre au perso (Likes de Lola, Rage de Jordan, Pression du Canard…), voir server/Mechanics.lua
local function meterText(model)
	local parts = {}
	local max = model:GetAttribute("MeterMax") or 0
	local icon = model:GetAttribute("MeterIcon") or ""
	if max > 0 then
		local value = model:GetAttribute("Meter") or 0
		if max <= 6 then
			table.insert(parts, icon .. " " .. math.floor(value + 0.001) .. "/" .. max)
		else
			table.insert(parts, icon .. " " .. math.floor(value / max * 100) .. "%")
		end
	end
	local track = TRACK_TEXT[model:GetAttribute("Track") or ""]
	if track then
		table.insert(parts, track)
	end
	local trick = model:GetAttribute("NextTrick") or 0
	if trick > 0 then
		local data = CharacterList[model:GetAttribute("Character") or ""]
		local icons = data and data.passive and data.passive.icons or { "✨", "💥", "🐇" }
		table.insert(parts, "🎩→" .. (icons[trick] or "?"))
	end
	local forms = model:GetAttribute("Forms") or 0
	if forms > 0 then
		table.insert(parts, "📋x" .. forms)
	end
	return table.concat(parts, "  ")
end
local ARROWS = { up = "↑", down = "↓", left = "←", right = "→" }
local ENERGY_COLOR = Color3.fromRGB(70, 180, 255)
local ENERGY_LOW = Color3.fromRGB(120, 120, 150)
local TEAM_COLORS = { Rouge = Color3.fromRGB(235, 60, 60), Bleu = Color3.fromRGB(60, 120, 240) }

local function damageColor(damage)
	if damage < 75 then
		return Color3.new(1, 1, 1):Lerp(Color3.fromRGB(255, 220, 60), damage / 75)
	end
	return Color3.fromRGB(255, 220, 60):Lerp(Color3.fromRGB(230, 30, 30), math.clamp((damage - 75) / (Config.RED_DAMAGE - 75), 0, 1))
end

local function textLabel(parent, size, position, textSize)
	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = size
	label.Position = position
	label.Font = Enum.Font.FredokaOne
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextStrokeTransparency = 0.2
	label.TextScaled = textSize == nil
	if textSize then
		label.TextSize = textSize
	end
	label.Parent = parent
	return label
end

local function createCard(parent)
	local card = Instance.new("Frame")
	card.Size = UDim2.new(0, 170, 1, 0)
	card.BackgroundColor3 = Color3.fromRGB(20, 15, 25)
	card.BackgroundTransparency = 0.35
	card.Parent = parent
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)
	local refs = {}
	refs.card = card
	refs.name = textLabel(card, UDim2.new(1, -56, 0.2, 0), UDim2.new(0, 5, 0, 2))
	-- objet tenu : icône + touches restantes, ou secondes avant que la bombe explose
	refs.held = textLabel(card, UDim2.new(0, 50, 0.24, 0), UDim2.new(1, -52, 0, 0))
	refs.held.TextXAlignment = Enum.TextXAlignment.Right
	refs.damage = textLabel(card, UDim2.new(0.6, 0, 0.38, 0), UDim2.new(0, 5, 0.2, 0))
	refs.stocks = textLabel(card, UDim2.new(0.4, -5, 0.26, 0), UDim2.new(0.6, 0, 0.26, 0))
	local function gauge(y, color, icon)
		local label = textLabel(card, UDim2.new(0, 16, 0.1, 0), UDim2.new(0, 3, y - 0.01, 0))
		label.Text = icon
		local bar = Instance.new("Frame")
		bar.Size = UDim2.new(1, -26, 0.08, 0)
		bar.Position = UDim2.new(0, 21, y, 0)
		bar.BackgroundColor3 = Color3.fromRGB(60, 50, 60)
		bar.BorderSizePixel = 0
		bar.Parent = card
		local fill = Instance.new("Frame")
		fill.Size = UDim2.fromScale(0, 1)
		fill.BackgroundColor3 = color
		fill.BorderSizePixel = 0
		fill.Parent = bar
		return fill
	end
	refs.super = gauge(0.61, Color3.fromRGB(255, 170, 0), "⭐")
	refs.energy = gauge(0.73, ENERGY_COLOR, "⚡")
	if Config.INFINITE_SPECIALS then
		-- plus de jauges : les L et les Y se font à l'infini
		for _, fill in ipairs({ refs.super, refs.energy }) do
			fill.Parent.Visible = false
		end
		for _, child in ipairs(card:GetChildren()) do
			if child:IsA("TextLabel") and (child.Text == "⭐" or child.Text == "⚡") then
				child.Visible = false
			end
		end
	end
	refs.status = textLabel(card, UDim2.new(1, -10, 0.15, 0), UDim2.new(0, 5, 0.84, 0))
	refs.stroke = Instance.new("UIStroke")
	refs.stroke.Thickness = 3
	refs.stroke.Enabled = false
	refs.stroke.Parent = card
	return refs
end

-- Flèches de la séquence fatale, orientées vers l'adversaire (dir = 1 s'il est à droite)
function Hud.sequenceText(sequence, dir)
	local parts = {}
	for _, step in ipairs(sequence) do
		local arrow = step
		if step == "forward" then
			arrow = dir == 1 and "right" or "left"
		elseif step == "back" then
			arrow = dir == 1 and "left" or "right"
		end
		table.insert(parts, ARROWS[arrow] or "?")
	end
	table.insert(parts, "⭐")
	return table.concat(parts, " ")
end

-- Renvoie l'adversaire achevable le plus proche (ou nil)
function Hud.findFinishable(myModel)
	local myRoot = myModel and myModel:FindFirstChild("HumanoidRootPart")
	if not myRoot or myModel:GetAttribute("Eliminated") then
		return nil
	end
	local best, bestDistance = nil, Config.FATAL_RANGE
	for _, model in ipairs(CollectionService:GetTagged("Fighter")) do
		local root = model:FindFirstChild("HumanoidRootPart")
		if model ~= myModel and root and model:GetAttribute("Finishable") then
			local distance = (root.Position - myRoot.Position).Magnitude
			if distance <= bestDistance then
				best, bestDistance = model, distance
			end
		end
	end
	return best
end

function Hud.start()
	local player = Players.LocalPlayer
	local gui = Instance.new("ScreenGui")
	gui.Name = "Hud"
	gui.ResetOnSpawn = false
	gui.Parent = player:WaitForChild("PlayerGui")

	local row = Instance.new("Frame")
	row.BackgroundTransparency = 1
	row.AnchorPoint = Vector2.new(0.5, 0)
	row.Position = UDim2.new(0.5, 0, 0, 8)
	row.Size = UDim2.new(1, -20, 0, 104)
	row.Parent = gui
	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.Padding = UDim.new(0, 8)
	layout.Parent = row

	local message = textLabel(gui, UDim2.fromScale(0.8, 0.12), UDim2.fromScale(0.1, 0.3))
	message.TextColor3 = Color3.fromRGB(255, 230, 120)
	local finishPrompt = textLabel(gui, UDim2.fromScale(0.5, 0.14), UDim2.fromScale(0.25, 0.42))
	finishPrompt.TextColor3 = Color3.fromRGB(255, 60, 60)
	-- chrono sous les cartes (mode « temps » façon Smash)
	local timer = textLabel(gui, UDim2.fromOffset(220, 34), UDim2.new(0.5, -110, 0, 116))

	-- aveuglé (statut « blinded ») : l'écran s'assombrit pour le joueur touché
	local blind = Instance.new("Frame")
	blind.Size = UDim2.fromScale(1, 1)
	blind.BackgroundColor3 = Color3.new(0, 0, 0)
	blind.BackgroundTransparency = 1
	blind.BorderSizePixel = 0
	blind.ZIndex = 0
	blind.Parent = gui

	local cards = {}
	RunService.RenderStepped:Connect(function()
		local me = player.Character
		blind.BackgroundTransparency = (me and Statuses.flags(me).blind) and 0.25 or 1
		local now = workspace:GetServerTimeNow()
		local seen = {}
		for _, model in ipairs(CollectionService:GetTagged("Fighter")) do
			seen[model] = true
			local refs = cards[model]
			if not refs then
				refs = createCard(row)
				cards[model] = refs
			end
			local damage = model:GetAttribute("Damage") or 0
			local stocks = model:GetAttribute("Stocks") or 0
			refs.name.Text = model:GetAttribute("DisplayName") or model.Name
			refs.damage.Text = math.floor(damage) .. " %"
			refs.damage.TextColor3 = damageColor(damage)
			-- mode temps : on affiche les points ; mode vies (ou mort subite) : les pastilles
			local timeMode = workspace:GetAttribute("MatchMode") == "time" and not workspace:GetAttribute("SuddenDeath")
			if timeMode then
				local score = model:GetAttribute("Score") or 0
				refs.stocks.Text = (score > 0 and "+" or "") .. score
				refs.stocks.TextColor3 = score > 0 and Color3.fromRGB(120, 255, 120)
					or score < 0 and Color3.fromRGB(255, 110, 110)
					or Color3.new(1, 1, 1)
			else
				refs.stocks.Text = string.rep("●", stocks) .. string.rep("○", math.max(0, Config.STOCKS - stocks))
				refs.stocks.TextColor3 = Color3.new(1, 1, 1)
			end
			local team = TEAM_COLORS[model:GetAttribute("Team") or ""]
			refs.stroke.Enabled = team ~= nil
			if team then
				refs.stroke.Color = team
			end
			refs.super.Size = UDim2.fromScale((model:GetAttribute("Super") or 0) / Config.MAX_SUPER, 1)
			-- énergie : grisée quand elle ne suffit plus pour un spécial, elle clignote pendant la recharge
			local energy = model:GetAttribute("Energy") or 0
			refs.energy.Size = UDim2.fromScale(energy / Config.ENERGY_MAX, 1)
			if model:GetAttribute("Charging") then
				refs.energy.BackgroundColor3 = ENERGY_COLOR:Lerp(Color3.new(1, 1, 1), 0.5 + 0.5 * math.sin(os.clock() * 14))
			else
				refs.energy.BackgroundColor3 = energy >= Config.ENERGY_S_COST and ENERGY_COLOR or ENERGY_LOW
			end
			local status = model:GetAttribute("Status")
			local active = (model:GetAttribute("StatusUntil") or 0) > now
			local bulles = model:GetAttribute("Bulles") or 0
			local statusText = active and STATUS_TEXT[status] or ""
			if model:GetAttribute("Away") then
				statusText = "💥 Éjecté !"
			elseif model:GetAttribute("Protected") or (model:GetAttribute("ProtectedUntil") or 0) > now then
				statusText = "🛡️ Protégé  " .. statusText
			end
			if bulles > 0 then
				statusText = "Bulles x" .. bulles .. "  " .. statusText
			end
			local buff = model:GetAttribute("Buff") or ""
			if not active and buff ~= "" and (model:GetAttribute("BuffUntil") or 0) > now and Statuses.BUFFS[buff] then
				statusText = Statuses.BUFFS[buff].icon .. " " .. Statuses.BUFFS[buff].text .. "  " .. statusText
			end
			local meter = meterText(model)
			if meter ~= "" then
				statusText = meter .. "  " .. statusText
			end
			if model:GetAttribute("Grabbed") then
				statusText = "✋ Saisi !  " .. statusText
			elseif (model:GetAttribute("ObeseUntil") or 0) > now then
				statusText = "🍗 Gavé !  " .. statusText
			elseif (model:GetAttribute("FragileUntil") or 0) > now then
				statusText = "💥 Fragile  " .. statusText
			end
			refs.status.Text = statusText
			local heldId = model:GetAttribute("Held") or ""
			local item = Items.LIST[heldId]
			if not item then
				-- Caisse Bizarre ouverte : le perso a sorti son arme
				refs.held.Text = model:GetAttribute("Armed") and "📦" or ""
				refs.held.TextColor3 = Color3.fromRGB(255, 220, 120)
			elseif heldId == "bomb" then
				local left = math.max(0, Config.BOMB_FUSE - (now - (model:GetAttribute("HeldSince") or now)))
				refs.held.Text = item.icon .. math.ceil(left)
				refs.held.TextColor3 = Color3.new(1, 1, 1):Lerp(Color3.fromRGB(255, 40, 30), 1 - left / Config.BOMB_FUSE)
			else
				local uses = model:GetAttribute("HeldUses") or -1
				refs.held.Text = uses >= 0 and (item.icon .. uses) or item.icon
				refs.held.TextColor3 = Color3.new(1, 1, 1)
			end
			refs.card.BackgroundTransparency = model:GetAttribute("Eliminated") and 0.8 or 0.35
		end
		for model, refs in pairs(cards) do
			if not seen[model] then
				refs.card:Destroy()
				cards[model] = nil
			end
		end

		message.Text = workspace:GetAttribute("Message") or ""

		local endsAt = workspace:GetAttribute("MatchEndsAt") or 0
		if workspace:GetAttribute("SuddenDeath") then
			timer.Text = "MORT SUBITE"
			timer.TextColor3 = Color3.fromRGB(255, 70, 70)
		elseif workspace:GetAttribute("MatchMode") == "time" and endsAt > now then
			local left = math.ceil(endsAt - now)
			timer.Text = string.format("%d:%02d", left // 60, left % 60)
			timer.TextColor3 = left <= 10 and Color3.fromRGB(255, 70, 70) or Color3.new(1, 1, 1)
		else
			timer.Text = ""
		end

		local myModel = player.Character
		local target = Hud.findFinishable(myModel)
		if target then
			local character = CharacterList[myModel:GetAttribute("Character")]
			local dir = target.HumanoidRootPart.Position.X >= myModel.HumanoidRootPart.Position.X and 1 or -1
			-- les fatals débloqués par la maîtrise s'affichent tous (pas besoin de les mémoriser)
			local unlocked = Hud.fatalsUnlocked and Hud.fatalsUnlocked(myModel:GetAttribute("Character") or "") or 1
			local sequences = {}
			for index, fatal in ipairs(character and character.fatals or {}) do
				if index <= unlocked then
					table.insert(sequences, Hud.sequenceText(fatal.sequence, dir))
				end
			end
			finishPrompt.Text = "TERMINE-LE !  " .. table.concat(sequences, "   |   ")
		else
			finishPrompt.Text = ""
		end
	end)
end

return Hud
