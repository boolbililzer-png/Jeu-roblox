-- Profil de chaque joueur : pièces, persos achetés, expérience de maîtrise par perso.
-- Sauvegardé dans un DataStore (si le jeu y a accès : publier le jeu et activer « Studio Access to API
-- Services » pour tester dans Studio). Sans accès, le profil vit le temps de la session.
-- Les clients le lisent dans les attributs du joueur : Coins, Owned (JSON), Mastery (JSON).
-- Rien de ce qui s'achète ou se débloque ne rend plus fort (voir docs/gameplay-progression.md).
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roster = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Roster"))

local Profile = {}

local STORE_NAME = "BagarreBizarre_Profils_v1"
local store = nil
do
	local ok, result = pcall(function()
		return DataStoreService:GetDataStore(STORE_NAME)
	end)
	if ok then
		store = result
	else
		warn("[Profil] DataStore indisponible, les profils ne seront pas sauvegardés :", result)
	end
end

local profiles = {} -- player -> { coins, owned = { id = true }, xp = { id = n } }

local function default()
	return { coins = 0, owned = {}, xp = {}, version = 1 }
end

local function publish(player)
	local p = profiles[player]
	if not p then
		return
	end
	player:SetAttribute("Coins", p.coins)
	player:SetAttribute("Owned", HttpService:JSONEncode(p.owned))
	player:SetAttribute("Mastery", HttpService:JSONEncode(p.xp))
end

function Profile.load(player)
	local data = nil
	if store then
		local ok, result = pcall(function()
			return store:GetAsync("joueur_" .. player.UserId)
		end)
		if ok then
			data = result
		else
			warn("[Profil] lecture impossible pour " .. player.Name .. " :", result)
		end
	end
	local p = default()
	if type(data) == "table" then
		p.coins = tonumber(data.coins) or 0
		p.owned = type(data.owned) == "table" and data.owned or {}
		p.xp = type(data.xp) == "table" and data.xp or {}
	end
	profiles[player] = p
	publish(player)
	return p
end

function Profile.save(player)
	local p = profiles[player]
	if not p or not store then
		return
	end
	local ok, err = pcall(function()
		store:SetAsync("joueur_" .. player.UserId, p)
	end)
	if not ok then
		warn("[Profil] sauvegarde impossible pour " .. player.Name .. " :", err)
	end
end

function Profile.get(player)
	return profiles[player]
end

-- Un perso est jouable s'il est gratuit, dans la rotation de la semaine, ou acheté
function Profile.canPlay(player, characterId)
	local p = profiles[player]
	return Roster.FREE[characterId] == true or Roster.rotation()[characterId] == true or (p ~= nil and p.owned[characterId] == true)
end

function Profile.buy(player, characterId)
	local p = profiles[player]
	if not p or Roster.FREE[characterId] or p.owned[characterId] or not table.find(Roster.ORDER, characterId) then
		return false, "Déjà disponible"
	end
	if p.coins < Roster.PRICE then
		return false, "Pas assez de pièces"
	end
	p.coins -= Roster.PRICE
	p.owned[characterId] = true
	publish(player)
	task.spawn(Profile.save, player)
	return true
end

function Profile.level(player, characterId)
	local p = profiles[player]
	return Roster.levelFromXp(p and p.xp[characterId] or 0)
end

-- Fin de partie : pièces et XP de maîtrise du perso joué. Renvoie le détail pour l'écran de résultats.
function Profile.reward(player, characterId, coins, xp)
	local p = profiles[player]
	if not p then
		return nil
	end
	local before = Roster.levelFromXp(p.xp[characterId] or 0)
	p.coins += coins
	p.xp[characterId] = (p.xp[characterId] or 0) + xp
	local after = Roster.levelFromXp(p.xp[characterId])
	local unlocked = {}
	for level = before + 1, after do
		if Roster.MASTERY_REWARDS[level] then
			table.insert(unlocked, "Niveau " .. level .. " : " .. Roster.MASTERY_REWARDS[level])
		end
	end
	publish(player)
	task.spawn(Profile.save, player)
	return { coins = coins, xp = xp, level = after, levelUp = after > before, unlocked = unlocked, total = p.coins }
end

Players.PlayerRemoving:Connect(function(player)
	Profile.save(player)
	profiles[player] = nil
end)

game:BindToClose(function()
	for _, player in ipairs(Players:GetPlayers()) do
		Profile.save(player)
	end
end)

return Profile
