-- Menu du salon (voir server/Lobby.lua) : mode de jeu, choix du perso (gratuits, rotation de la semaine, achat en
-- pièces, niveau de maîtrise et fatals débloqués), arène et pièges ON/OFF (choisis par l'hôte), bouton PRÊT,
-- puis écran de résultats (pièces et XP gagnées). Pendant une partie : bandeau des spectateurs et bouton QUITTER
-- de l'Entraînement. Tout est en proportions de l'écran pour tenir sur téléphone.
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local CharacterList = require(Shared:WaitForChild("CharacterList"))
local Roster = require(Shared:WaitForChild("Roster"))
local Arenas = require(Shared:WaitForChild("Arenas"))

local Menu = {}

local player = Players.LocalPlayer
local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Menu")

local BG = Color3.fromRGB(28, 20, 38)
local PANEL = Color3.fromRGB(48, 36, 64)
local ACCENT = Color3.fromRGB(255, 200, 60)
local GOOD = Color3.fromRGB(90, 210, 120)
local LOCKED = Color3.fromRGB(90, 80, 100)
local WHITE = Color3.new(1, 1, 1)

local function new(class, props, parent)
	local i = Instance.new(class)
	for k, v in pairs(props) do
		i[k] = v
	end
	i.Parent = parent
	return i
end

local function corner(parent, radius)
	new("UICorner", { CornerRadius = UDim.new(0, radius or 10) }, parent)
end

local function label(parent, text, size, position, props)
	local l = new("TextLabel", {
		BackgroundTransparency = 1, Size = size, Position = position or UDim2.new(), Text = text,
		TextScaled = true, Font = Enum.Font.FredokaOne, TextColor3 = WHITE, TextStrokeTransparency = 0.6,
	}, parent)
	for k, v in pairs(props or {}) do
		l[k] = v
	end
	return l
end

local function button(parent, text, size, position, color)
	local b = new("TextButton", {
		Size = size, Position = position or UDim2.new(), Text = text, TextScaled = true, Font = Enum.Font.FredokaOne,
		TextColor3 = WHITE, BackgroundColor3 = color or PANEL, AutoButtonColor = true, TextStrokeTransparency = 0.5,
	}, parent)
	corner(b, 10)
	new("UITextSizeConstraint", { MaxTextSize = 28 }, b)
	return b
end

local decoded = {} -- texte JSON -> table (le menu se redessine à chaque image)
local function decode(attribute)
	local raw = player:GetAttribute(attribute)
	if typeof(raw) ~= "string" or raw == "" then
		return {}
	end
	if not decoded[raw] then
		local ok, value = pcall(HttpService.JSONDecode, HttpService, raw)
		decoded[raw] = ok and type(value) == "table" and value or {}
	end
	return decoded[raw]
end

-- Fatals débloqués pour ce perso (niveau de maîtrise), utilisé aussi par le HUD et les commandes
function Menu.fatalsUnlocked(characterId)
	return Roster.fatalsUnlocked(Roster.levelFromXp(decode("Mastery")[characterId] or 0))
end

local function rotationSet()
	local set = {}
	for id in string.gmatch(player:GetAttribute("Rotation") or "", "[^,]+") do
		set[id] = true
	end
	return set
end

local function availability(id)
	if Roster.FREE[id] or Roster.UNLOCK_ALL then
		return "free"
	elseif decode("Owned")[id] then
		return "owned"
	elseif rotationSet()[id] then
		return "rotation"
	end
	return "locked"
end

local function levelOf(id)
	return Roster.levelFromXp(decode("Mastery")[id] or 0)
end

------------------------------------------------------------------------ Construction
function Menu.start()
	local gui = new("ScreenGui", { Name = "Menu", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 10, ZIndexBehavior = Enum.ZIndexBehavior.Sibling }, player:WaitForChild("PlayerGui"))

	-- Salon (plein écran)
	local lobby = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = BG, BackgroundTransparency = 0.12, Active = true }, gui)
	new("UIGradient", { Color = ColorSequence.new(Color3.fromRGB(70, 30, 90), Color3.fromRGB(20, 15, 30)), Rotation = 90 }, lobby)
	label(lobby, "BAGARRE BIZARRE", UDim2.fromScale(0.5, 0.08), UDim2.fromScale(0.02, 0.015), { TextColor3 = ACCENT, Font = Enum.Font.LuckiestGuy, TextXAlignment = Enum.TextXAlignment.Left })
	local coins = label(lobby, "🪙 0", UDim2.fromScale(0.25, 0.06), UDim2.fromScale(0.73, 0.025), { TextXAlignment = Enum.TextXAlignment.Right })

	-- Colonne MODE
	local modeCol = new("Frame", { Size = UDim2.fromScale(0.22, 0.72), Position = UDim2.fromScale(0.015, 0.11), BackgroundColor3 = PANEL, BackgroundTransparency = 0.3 }, lobby)
	corner(modeCol, 12)
	label(modeCol, "MODE", UDim2.fromScale(1, 0.08), UDim2.fromScale(0, 0.01), { TextColor3 = ACCENT })
	local modeButtons = {}
	for i, mode in ipairs(Roster.MODES) do
		local b = button(modeCol, "", UDim2.fromScale(0.92, 0.16), UDim2.fromScale(0.04, 0.1 + (i - 1) * 0.177))
		label(b, mode.icon .. " " .. mode.name, UDim2.fromScale(0.94, 0.5), UDim2.fromScale(0.03, 0.05))
		label(b, mode.text, UDim2.fromScale(0.94, 0.36), UDim2.fromScale(0.03, 0.58), { TextColor3 = Color3.fromRGB(210, 200, 220) })
		b.MouseButton1Click:Connect(function()
			remote:FireServer("mode", mode.id)
		end)
		modeButtons[mode.id] = b
	end

	-- Grille des PERSOS
	local charCol = new("Frame", { Size = UDim2.fromScale(0.5, 0.72), Position = UDim2.fromScale(0.245, 0.11), BackgroundColor3 = PANEL, BackgroundTransparency = 0.3 }, lobby)
	corner(charCol, 12)
	label(charCol, "PERSO", UDim2.fromScale(1, 0.07), UDim2.fromScale(0, 0.01), { TextColor3 = ACCENT })
	local grid = new("ScrollingFrame", { Size = UDim2.fromScale(0.96, 0.52), Position = UDim2.fromScale(0.02, 0.085), BackgroundTransparency = 1,
		ScrollBarThickness = 6, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y }, charCol)
	new("UIGridLayout", { CellSize = UDim2.fromScale(0.185, 0.3), CellPadding = UDim2.fromScale(0.012, 0.02), SortOrder = Enum.SortOrder.LayoutOrder }, grid)
	local tiles = {}
	for order, id in ipairs(Roster.ORDER) do
		local data = CharacterList[id]
		if data then
			local info = Roster.INFO[id] or {}
			local tile = new("TextButton", { Text = "", LayoutOrder = order, BackgroundColor3 = info.color or PANEL, AutoButtonColor = true }, grid)
			corner(tile, 10)
			local stroke = new("UIStroke", { Thickness = 3, Color = ACCENT, Enabled = false }, tile)
			label(tile, info.icon or "?", UDim2.fromScale(1, 0.5), UDim2.fromScale(0, 0.04))
			label(tile, data.name or id, UDim2.fromScale(0.96, 0.22), UDim2.fromScale(0.02, 0.54), { TextStrokeTransparency = 0 })
			local badge = label(tile, "", UDim2.fromScale(0.96, 0.2), UDim2.fromScale(0.02, 0.78), { TextStrokeTransparency = 0 })
			local shade = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.55, Visible = false }, tile)
			corner(shade, 10)
			tile.MouseButton1Click:Connect(function()
				Menu.selected = id
				if availability(id) ~= "locked" then
					remote:FireServer("choose", id)
				end
			end)
			tiles[id] = { tile = tile, stroke = stroke, badge = badge, shade = shade }
		end
	end
	-- fiche du perso sélectionné
	local detail = new("Frame", { Size = UDim2.fromScale(0.96, 0.34), Position = UDim2.fromScale(0.02, 0.63), BackgroundColor3 = BG, BackgroundTransparency = 0.25 }, charCol)
	corner(detail, 10)
	local dName = label(detail, "", UDim2.fromScale(0.62, 0.2), UDim2.fromScale(0.02, 0.02), { TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = ACCENT })
	local dInfo = label(detail, "", UDim2.fromScale(0.62, 0.32), UDim2.fromScale(0.02, 0.23), { TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true })
	local dFatals = label(detail, "", UDim2.fromScale(0.62, 0.42), UDim2.fromScale(0.02, 0.56), { TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, TextColor3 = Color3.fromRGB(220, 210, 230) })
	local dLevel = label(detail, "", UDim2.fromScale(0.33, 0.25), UDim2.fromScale(0.65, 0.05))
	local buy = button(detail, "", UDim2.fromScale(0.33, 0.32), UDim2.fromScale(0.65, 0.6), GOOD)
	buy.MouseButton1Click:Connect(function()
		if Menu.selected then
			remote:FireServer("buy", Menu.selected)
		end
	end)

	-- Colonne ARÈNE
	local arenaCol = new("Frame", { Size = UDim2.fromScale(0.235, 0.72), Position = UDim2.fromScale(0.75, 0.11), BackgroundColor3 = PANEL, BackgroundTransparency = 0.3 }, lobby)
	corner(arenaCol, 12)
	label(arenaCol, "ARÈNE", UDim2.fromScale(1, 0.07), UDim2.fromScale(0, 0.01), { TextColor3 = ACCENT })
	local list = new("ScrollingFrame", { Size = UDim2.fromScale(0.94, 0.72), Position = UDim2.fromScale(0.03, 0.085), BackgroundTransparency = 1,
		ScrollBarThickness = 6, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y }, arenaCol)
	new("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }, list)
	local arenaButtons = {}
	local function arenaButton(id, text, order)
		local b = button(list, text, UDim2.new(1, -8, 0, 34), nil)
		b.LayoutOrder = order
		b.TextXAlignment = Enum.TextXAlignment.Left
		b.MouseButton1Click:Connect(function()
			remote:FireServer("arena", id)
		end)
		arenaButtons[id] = b
	end
	arenaButton("random", "🎲 Au hasard", 0)
	for i, arena in ipairs(Arenas.LIST) do
		arenaButton(arena.id, " " .. arena.name, i)
	end
	local traps = button(arenaCol, "", UDim2.fromScale(0.94, 0.08), UDim2.fromScale(0.03, 0.82))
	traps.MouseButton1Click:Connect(function()
		remote:FireServer("traps", not (workspace:GetAttribute("TrapsChoice") ~= false))
	end)
	label(arenaCol, "L'hôte (1er prêt) choisit l'arène", UDim2.fromScale(0.94, 0.06), UDim2.fromScale(0.03, 0.92), { TextColor3 = Color3.fromRGB(190, 180, 200) })

	-- PRÊT
	local ready = button(lobby, "PRÊT !", UDim2.fromScale(0.3, 0.1), UDim2.fromScale(0.35, 0.86), GOOD)
	ready.Font = Enum.Font.LuckiestGuy
	ready.MouseButton1Click:Connect(function()
		remote:FireServer("ready", not player:GetAttribute("Ready"))
	end)
	local status = label(lobby, "", UDim2.fromScale(0.3, 0.05), UDim2.fromScale(0.02, 0.885), { TextXAlignment = Enum.TextXAlignment.Left })
	local countdown = label(lobby, "", UDim2.fromScale(0.3, 0.07), UDim2.fromScale(0.68, 0.875), { TextColor3 = ACCENT })

	-- Bandeau des spectateurs et bouton QUITTER (Entraînement)
	local banner = label(gui, "", UDim2.fromScale(0.6, 0.05), UDim2.fromScale(0.2, 0.93), { Visible = false, TextColor3 = ACCENT, TextStrokeTransparency = 0 })
	local leave = button(gui, "⏏ QUITTER", UDim2.fromScale(0.13, 0.06), UDim2.fromScale(0.01, 0.92), Color3.fromRGB(200, 70, 70))
	leave.Visible = false
	leave.MouseButton1Click:Connect(function()
		remote:FireServer("leave")
	end)

	-- Résultats
	local results = new("Frame", { Size = UDim2.fromScale(0.5, 0.56), Position = UDim2.fromScale(0.25, 0.2), BackgroundColor3 = BG, BackgroundTransparency = 0.05, Visible = false, ZIndex = 20 }, gui)
	corner(results, 16)
	new("UIStroke", { Thickness = 4, Color = ACCENT }, results)
	local rTitle = label(results, "", UDim2.fromScale(0.9, 0.18), UDim2.fromScale(0.05, 0.04), { TextColor3 = ACCENT, Font = Enum.Font.LuckiestGuy, ZIndex = 21 })
	local rBody = label(results, "", UDim2.fromScale(0.9, 0.55), UDim2.fromScale(0.05, 0.24), { TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, ZIndex = 21 })
	local rOk = button(results, "OK", UDim2.fromScale(0.3, 0.13), UDim2.fromScale(0.35, 0.83), GOOD)
	rOk.ZIndex = 21
	rOk.MouseButton1Click:Connect(function()
		results.Visible = false
	end)

	-- Messages courts (achat, perso verrouillé…)
	local toast = label(gui, "", UDim2.fromScale(0.6, 0.06), UDim2.fromScale(0.2, 0.12), { Visible = false, TextStrokeTransparency = 0, ZIndex = 30 })
	local toastToken = 0
	remote.OnClientEvent:Connect(function(kind, data)
		if kind == "toast" then
			toastToken += 1
			local token = toastToken
			toast.Text = tostring(data)
			toast.Visible = true
			task.delay(2.5, function()
				if toastToken == token then
					toast.Visible = false
				end
			end)
		elseif kind == "results" and type(data) == "table" then
			local data2 = CharacterList[data.character or ""]
			local title
			if data.mode == "training" then
				title = "FIN DE L'ENTRAÎNEMENT"
			elseif data.mode == "adventure" then
				title = data.won and "AVENTURE TERMINÉE !" or ("AVENTURE : COMBAT " .. tostring(data.stage or 1) .. " PERDU")
			else
				title = data.won and "VICTOIRE !" or "BIEN JOUÉ !"
			end
			rTitle.Text = title
			local lines = {
				"+" .. tostring(data.coins or 0) .. " 🪙   (total : " .. tostring(data.total or 0) .. ")",
				"+" .. tostring(data.xp or 0) .. " XP avec " .. (data2 and data2.name or "?") .. " — niveau " .. tostring(data.level or 1),
			}
			if data.levelUp then
				table.insert(lines, "⬆️ NIVEAU SUPÉRIEUR !")
			end
			for _, line in ipairs(data.unlocked or {}) do
				table.insert(lines, "🔓 " .. line)
			end
			rBody.Text = table.concat(lines, "\n")
			results.Visible = true
		end
	end)

	------------------------------------------------------------------------ Mise à jour
	RunService.RenderStepped:Connect(function()
		local phase = workspace:GetAttribute("Phase") or "lobby"
		local character = player.Character
		local fighting = character ~= nil and CollectionService:HasTag(character, "Fighter")
		lobby.Visible = phase == "lobby" or phase == "results"
		coins.Text = "🪙 " .. tostring(player:GetAttribute("Coins") or 0)

		-- modes
		local vote = player:GetAttribute("VoteMode") or "brawl"
		for id, b in pairs(modeButtons) do
			b.BackgroundColor3 = id == vote and Color3.fromRGB(150, 90, 200) or PANEL
		end

		-- persos
		local choice = player:GetAttribute("Choice")
		Menu.selected = Menu.selected or choice
		for id, t in pairs(tiles) do
			local state = availability(id)
			t.stroke.Enabled = id == choice
			t.shade.Visible = state == "locked"
			if state == "locked" then
				t.badge.Text = "🔒 " .. Roster.PRICE
				t.badge.TextColor3 = Color3.fromRGB(255, 220, 120)
			elseif state == "rotation" then
				t.badge.Text = "🔄 Cette semaine"
				t.badge.TextColor3 = Color3.fromRGB(150, 230, 255)
			else
				t.badge.Text = "Niv. " .. levelOf(id)
				t.badge.TextColor3 = WHITE
			end
		end
		local id = Menu.selected
		local data = id and CharacterList[id]
		if data then
			local info = Roster.INFO[id] or {}
			local state = availability(id)
			local level = levelOf(id)
			dName.Text = (info.icon or "") .. " " .. (data.name or id)
			local weapons = {}
			for _, weapon in ipairs(data.weapons or {}) do
				table.insert(weapons, (weapon.icon or "") .. " " .. weapon.name)
			end
			dInfo.Text = string.format("%s %s\n📦 Armes : %s\n⚙️ %s", info.title or "", string.rep("★", info.stars or 1),
				#weapons > 0 and table.concat(weapons, " · ") or (info.weapon or "?"), data.passive and data.passive.name or "")
			local fatals = {}
			local unlocked = Roster.fatalsUnlocked(level)
			for i, f in ipairs(data.fatals or {}) do
				local need = Roster.FATAL_LEVELS[i] or 1
				table.insert(fatals, (i <= unlocked and "🔓 " or ("🔒 niv. " .. need .. " · ")) .. f.label)
			end
			dFatals.Text = "Fatals :\n" .. table.concat(fatals, "\n")
			dLevel.Text = "Maîtrise\nniv. " .. level .. " / " .. Roster.MASTERY_MAX
			buy.Visible = state == "locked"
			buy.Text = "Acheter " .. Roster.PRICE .. " 🪙"
			buy.BackgroundColor3 = (player:GetAttribute("Coins") or 0) >= Roster.PRICE and GOOD or LOCKED
		end

		-- arènes
		local arenaChoice = workspace:GetAttribute("ArenaChoice") or "random"
		for aid, b in pairs(arenaButtons) do
			b.BackgroundColor3 = aid == arenaChoice and Color3.fromRGB(150, 90, 200) or PANEL
		end
		local trapsOn = workspace:GetAttribute("TrapsChoice") ~= false
		traps.Text = trapsOn and "⚠️ Pièges : ON" or "🚫 Pièges : OFF"
		traps.BackgroundColor3 = trapsOn and Color3.fromRGB(200, 120, 40) or LOCKED

		-- prêt et compte à rebours
		local isReady = player:GetAttribute("Ready") == true
		ready.Text = isReady and "✔ PRÊT (annuler)" or "PRÊT !"
		ready.BackgroundColor3 = isReady and Color3.fromRGB(60, 140, 80) or GOOD
		status.Text = workspace:GetAttribute("LobbyText") or ""
		local at = workspace:GetAttribute("Countdown") or 0
		local left = at - workspace:GetServerTimeNow()
		countdown.Text = left > 0 and ("Départ dans " .. math.ceil(left) .. " s") or ""

		-- pendant une partie
		banner.Visible = phase == "match" and not fighting
		if banner.Visible then
			local mode = workspace:GetAttribute("Mode") or ""
			local name = mode
			for _, m in ipairs(Roster.MODES) do
				if m.id == mode then
					name = m.name
				end
			end
			banner.Text = "👀 Partie en cours (" .. name .. ") — tu joues à la prochaine !"
		end
		leave.Visible = phase == "match" and fighting and workspace:GetAttribute("Mode") == "training"
	end)
end

return Menu
