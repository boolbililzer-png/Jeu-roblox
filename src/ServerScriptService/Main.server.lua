-- Bagarre Bizarre — point d'entrée serveur.
local Players = game:GetService("Players")
local PhysicsService = game:GetService("PhysicsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared.Config)
local Net = require(Shared.Net)

local ServerFolder = script.Parent:WaitForChild("Server")

-- Monde
workspace.Gravity = Config.Gravity
Players.CharacterAutoLoads = false
for _, name in { "Fighters", "Fx" } do
	if not workspace:FindFirstChild(name) then
		local f = Instance.new("Folder")
		f.Name = name
		f.Parent = workspace
	end
end

-- Groupes de collision :
--   Fighter      : les combattants se traversent entre eux (comme Brawlhalla)
--   FighterPass  : en montant / en descendant volontairement, on traverse les plateformes « Soft »
--   Wall         : murs invisibles / de glace / d'enceintes qui bloquent les combattants
--   Crate        : les caisses tombent sur le décor mais ne bloquent personne
for _, g in { "Fighter", "FighterPass", "Soft", "Wall", "Crate" } do
	pcall(function()
		PhysicsService:RegisterCollisionGroup(g)
	end)
end
local function rule(a: string, b: string, collide: boolean)
	PhysicsService:CollisionGroupSetCollidable(a, b, collide)
end
rule("Fighter", "Fighter", false)
rule("Fighter", "FighterPass", false)
rule("FighterPass", "FighterPass", false)
rule("FighterPass", "Soft", false)
rule("Crate", "Fighter", false)
rule("Crate", "FighterPass", false)
rule("Crate", "Wall", false)

local Fighter = require(ServerFolder.Fighter)
local Combat = require(ServerFolder.Combat)
local Match = require(ServerFolder.Match)

local ToServer = Net.get("ToServer")
Net.get("ToClient")

local LOBBY_ACTIONS = { select = true, ready = true, settings = true }
local FIGHT_ACTIONS = { attack = true, dodge = true, grab = true }

-- limite anti-spam simple
local lastAction: { [Player]: number } = {}

ToServer.OnServerEvent:Connect(function(player: Player, action: any, data: any)
	if type(action) ~= "string" then
		return
	end
	local t = os.clock()
	if (lastAction[player] or 0) > t - 0.02 and action ~= "attack" then
		return
	end
	lastAction[player] = t
	if LOBBY_ACTIONS[action] then
		Match.onLobbyAction(player, action, data)
	elseif FIGHT_ACTIONS[action] then
		local f = Match.fighterOf(player)
		if f then
			Combat.onAction(f, action, data)
		end
	end
end)

Players.PlayerRemoving:Connect(function(p)
	lastAction[p] = nil
end)

Match.init()
local _ = Fighter
print("[Bagarre Bizarre] serveur prêt")
