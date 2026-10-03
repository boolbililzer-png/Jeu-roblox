-- Point d'entrée serveur : crée les canaux réseau, l'arène, et lance le match.
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Players = game:GetService("Players")
local StarterPlayer = game:GetService("StarterPlayer")

-- Les persos portent leur costume de combattant, pas l'avatar Roblox du joueur
StarterPlayer.LoadCharacterAppearance = false

-- Les animations ont besoin d'un corps R15 (15 articulations). Si le jeu est réglé en R6 ou
-- « au choix du joueur », un avatar R6 n'a que 6 articulations et rien ne bouge : on impose donc
-- un modèle R15 à tout le monde via StarterCharacter.
if not StarterPlayer:FindFirstChild("StarterCharacter") then
	local ok, model = pcall(function()
		return Players:CreateHumanoidModelFromDescription(Instance.new("HumanoidDescription"), Enum.HumanoidRigType.R15)
	end)
	if ok and model then
		local defaultAnimate = model:FindFirstChild("Animate")
		if defaultAnimate then
			defaultAnimate:Destroy()
		end
		model.Name = "StarterCharacter"
		-- marque recopiée sur chaque perso : un perso sans elle a été créé avant ce script (avatar du joueur)
		model:SetAttribute("BagarreBody", true)
		model.Parent = StarterPlayer
	else
		warn("Impossible de créer le corps R15 :", model)
	end
end
-- Joueur déjà apparu avant ce script avec un autre corps : on le refait apparaître en R15
local function ensureR15(player)
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if humanoid and humanoid.RigType ~= Enum.HumanoidRigType.R15 then
		player:LoadCharacter()
	end
end
for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(ensureR15, player)
end

local Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config"))

local remotes = Instance.new("Folder")
remotes.Name = "Remotes"
local actionRemote = Instance.new("RemoteEvent")
actionRemote.Name = "Action"
actionRemote.Parent = remotes
local knockbackRemote = Instance.new("RemoteEvent")
knockbackRemote.Name = "Knockback"
knockbackRemote.Parent = remotes
local fxRemote = Instance.new("RemoteEvent")
fxRemote.Name = "Fx"
fxRemote.Parent = remotes
remotes.Parent = ReplicatedStorage

local Fighters = require(script.Parent:WaitForChild("Fighters"))
local Arena = require(script.Parent:WaitForChild("Arena"))
local Combat = require(script.Parent:WaitForChild("Combat"))
local Match = require(script.Parent:WaitForChild("Match"))
local Dummy = require(script.Parent:WaitForChild("Dummy"))
local Mechanics = require(script.Parent:WaitForChild("Mechanics"))
local Specials = require(script.Parent:WaitForChild("Specials"))

Fighters.init({ Knockback = knockbackRemote, Fx = fxRemote })
Fighters.mechanics = Mechanics
Mechanics.setFxRemote(fxRemote)
Specials.setFxRemote(fxRemote)
require(script.Parent:WaitForChild("Fatals")).setFxRemote(fxRemote)
Arena.build()
Combat.setFatalHandler(Match.tryFatal)
Combat.setActionHook(Match.onFighterAction)
Combat.setFxRemote(fxRemote)
Match.setFxRemote(fxRemote)

actionRemote.OnServerEvent:Connect(function(player, action, extra)
	if typeof(action) ~= "string" then
		return
	end
	Combat.handleAction(player, action, extra)
end)

Match.start()

-- Geysers de soda des rebords : ils envoient en l'air ceux qui sont dessus
local GEYSER = { damage = 4, kbBase = 90, kbGrowth = 20, kbAngle = 90, hitText = "PSCHHHT !" }
Arena.startHazards(fxRemote, function(spot)
	for _, model in ipairs(Fighters.all()) do
		local root = Fighters.root(model)
		if root and not root.Anchored then
			local offset = root.Position - spot
			if math.abs(offset.X) < 5 and offset.Y > -1 and offset.Y < 16 then
				Fighters.hit(nil, model, GEYSER, 1, offset.X >= 0 and 1 or -1)
			end
		end
	end
end)

if Config.SPAWN_DUMMY then
	Dummy.spawn()
end
