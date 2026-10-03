-- Animation par code de tous les combattants (joueurs et mannequin), calculée sur chaque client.
-- Le calcul des poses est dans shared/AnimCore (sans API Roblox, donc testable hors de Roblox).
-- Ici on lui donne l'état de chaque perso (au sol, vitesse, coup en cours…) puis on écrit le
-- résultat dans Motor6D.Transform. Aucune animation n'a besoin d'être importée dans Roblox.
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared:WaitForChild("Config"))
local Poses = require(Shared:WaitForChild("Poses"))
local AnimCore = require(Shared:WaitForChild("AnimCore"))
local CharacterList = require(Shared:WaitForChild("CharacterList"))

AnimCore.DODGE_DURATION = Config.DODGE_DURATION
AnimCore.SMASH_MAX_TIME = Config.SMASH_MAX_TIME
AnimCore.WALK_SPEED = Config.WALK_SPEED

local Animator = {}

-- Appelé au lancement de chaque coup (branché par Fx) : function(model, key, move, startClock, power)
-- power = charge de 0 à 1 pour une frappe chargée, 0 sinon
Animator.onMoveStart = nil
-- Appelé quand un perso se retourne (branché par Fx pour changer la bouteille de main) : function(model, mirrored)
Animator.onMirror = nil
-- Appelé avec le diagnostic des articulations : function(model, text, ok)
Animator.onReport = nil

local rigs = {}
local localCharacter = nil
local localCharging = false -- recharge du joueur local, sans attendre la réponse du serveur
local rad = math.rad

local function toCFrame(v)
	return CFrame.new(v[4] or 0, v[5] or 0, v[6] or 0) * CFrame.Angles(rad(v[1] or 0), rad(v[2] or 0), rad(v[3] or 0))
end

local function serverToClock(serverTime)
	return os.clock() - (workspace:GetServerTimeNow() - serverTime)
end

-- Convertit une heure os.clock() en heure interne du moteur d'animation de ce perso
local function toRigTime(rig, clock)
	return rig.core.time - (os.clock() - (clock or os.clock()))
end

local function characterData(model)
	return CharacterList[model:GetAttribute("Character") or Config.DEFAULT_CHARACTER]
end

-- Pièce du corps que chaque articulation fait bouger (rig R15)
local PART_TO_KEY = {
	LowerTorso = "Root", UpperTorso = "Waist", Head = "Neck",
	RightUpperArm = "RS", RightLowerArm = "RE", RightHand = "RW",
	LeftUpperArm = "LS", LeftLowerArm = "LE", LeftHand = "LW",
	RightUpperLeg = "RH", RightLowerLeg = "RK", RightFoot = "RA",
	LeftUpperLeg = "LH", LeftLowerLeg = "LK", LeftFoot = "LA",
}
local NAME_TO_KEY = {}
for key, name in pairs(Poses.JOINTS) do
	NAME_TO_KEY[name] = key
end

-- Retrouve les articulations du perso. Selon les réglages du jeu, Roblox utilise des Motor6D
-- (rig classique) ou des AnimationConstraint (« Avatar Joint Upgrade ») : les deux ont une
-- propriété Transform, on accepte donc les deux, reconnues par la pièce qu'elles font bouger.
local function findMotors(model)
	local motors, kinds = {}, {}
	for _, d in ipairs(model:GetDescendants()) do
		local child
		if d:IsA("Motor6D") then
			child = d.Part1
		elseif d:IsA("AnimationConstraint") then
			child = d.Attachment1 and d.Attachment1.Parent
		end
		if child or d:IsA("Motor6D") then
			local key = (child and PART_TO_KEY[child.Name]) or NAME_TO_KEY[d.Name]
			local inCostume = d:FindFirstAncestor("Costume") ~= nil
			if key and not inCostume then
				-- si les deux existent, l'AnimationConstraint active est celle qui commande vraiment
				local current = motors[key]
				local better = not current or (d:IsA("AnimationConstraint") and d.Enabled) or (current:IsA("Motor6D") and not current.Enabled)
				if better then
					motors[key] = d
					kinds[key] = d.ClassName
				end
			end
		end
	end
	return motors, kinds
end

local function countMotors(motors)
	local n = 0
	for _ in pairs(motors) do
		n += 1
	end
	return n
end

-- Diagnostic visible à l'écran (Config.ANIM_DEBUG) et dans la fenêtre Output de Studio
local function report(model, motors, kinds)
	local humanoid = model:FindFirstChildOfClass("Humanoid")
	local rigType = humanoid and humanoid.RigType.Name or "?"
	local count = countMotors(motors)
	local kind = kinds.Root or kinds.RS or "aucune"
	local text = string.format("Animation de %s : %d/15 articulations (%s), rig %s", model.Name, count, kind, rigType)
	if count < 15 or rigType ~= "R15" then
		warn("[Animation] " .. text .. " → les membres ne pourront pas bouger correctement")
	else
		print("[Animation] " .. text)
	end
	if Animator.onReport then
		Animator.onReport(model, text, count == 15 and rigType == "R15")
	end
end

function Animator.playMove(model, key, startClock, power)
	local rig = rigs[model]
	local data = characterData(model)
	local move = data and data.moves[key]
	if not rig or not move then
		return
	end
	startClock = startClock or os.clock()
	AnimCore.playMove(rig.core, key, move, toRigTime(rig, startClock))
	if Animator.onMoveStart then
		Animator.onMoveStart(model, key, move, startClock, power or 0)
	end
end

-- Frappe chargée : le perso reste en élan jusqu'au relâchement (puis playMove du même coup)
function Animator.holdMove(model, key, startClock)
	local rig = rigs[model]
	local data = characterData(model)
	local move = data and data.moves[key]
	if rig and move then
		AnimCore.holdMove(rig.core, key, move, toRigTime(rig, startClock or os.clock()))
		rig.holdStart = startClock or os.clock()
	end
end

function Animator.cancelHold(model)
	local rig = rigs[model]
	if rig and rig.core.move and rig.core.move.holding then
		rig.core.move = nil
	end
end

-- Charge en cours (0 à 1) d'une frappe chargée, ou nil
function Animator.holdCharge(model)
	local rig = rigs[model]
	if rig and rig.core.move and rig.core.move.holding then
		return math.clamp((os.clock() - (rig.holdStart or os.clock())) / Config.SMASH_MAX_TIME, 0, 1)
	end
	return nil
end

-- Dash : le perso se penche en avant le temps de la ruée
-- Appelé quand un autre joueur fait un dash (Fx branche ici la traînée de poussière)
Animator.onDash = nil

function Animator.playDash(model, startClock)
	local rig = rigs[model]
	if rig then
		rig.dashUntil = (startClock or os.clock()) + Config.DASH_TIME
	end
end

function Animator.playDodge(model, startClock)
	local rig = rigs[model]
	if rig then
		local root = model:FindFirstChild("HumanoidRootPart")
		local moving = root ~= nil and math.abs(root.AssemblyLinearVelocity.X) > 8
		AnimCore.playDodge(rig.core, toRigTime(rig, startClock), moving)
	end
end

-- Micro-arrêt sur image à l'impact : la pose reste figée un court instant
function Animator.freeze(model, duration)
	local rig = rigs[model]
	if rig and Config.HITSTOP then
		rig.freezeUntil = math.max(rig.freezeUntil, os.clock() + duration)
	end
end

function Animator.setLocalCharacter(model)
	localCharacter = model
end

function Animator.setLocalCharging(on)
	localCharging = on
end

-- Recharge d'énergie en cours (prédite pour le joueur local, lue sur le serveur pour les autres)
function Animator.isCharging(model)
	if model == localCharacter then
		return localCharging
	end
	return model:GetAttribute("Charging") == true
end

function Animator.isMirrored(model)
	local rig = rigs[model]
	return rig ~= nil and rig.mirrored
end

local function track(model)
	if rigs[model] then
		return
	end
	local motors = findMotors(model)
	local rig = {
		motors = motors,
		core = AnimCore.newRig(math.random() * 10),
		freezeUntil = 0,
		mirrored = false,
	}
	rigs[model] = rig
	task.delay(1.5, function()
		if rigs[model] then
			report(model, findMotors(model))
		end
	end)

	-- Le costume ou le changement de taille peut recréer les articulations
	local function refresh(d)
		if d:IsA("Motor6D") or d:IsA("AnimationConstraint") then
			task.defer(function()
				rig.motors = findMotors(model)
			end)
		end
	end
	model.DescendantAdded:Connect(refresh)
	-- Costume arrivé après coup : on remet la bouteille dans la bonne main
	model.ChildAdded:Connect(function(child)
		if child.Name == "Costume" and Animator.onMirror then
			task.delay(0.5, function()
				Animator.onMirror(model, rig.mirrored)
			end)
		end
	end)
	if Animator.onMirror then
		task.defer(Animator.onMirror, model, false)
	end
	model.DescendantRemoving:Connect(refresh)

	-- Coups et esquives des autres joueurs (le joueur local les lance lui-même sans attendre le serveur)
	model:GetAttributeChangedSignal("MoveStart"):Connect(function()
		-- (sauf un coup décidé par le serveur, comme la projection automatique : le joueur local la joue aussi)
		if model ~= localCharacter or model:GetAttribute("MoveForced") then
			Animator.playMove(model, model:GetAttribute("MoveKey"), serverToClock(model:GetAttribute("MoveStart")), model:GetAttribute("MovePower"))
		end
	end)
	-- Frappe chargée des autres joueurs : élan tenu, puis le coup part quand MoveStart change
	model:GetAttributeChangedSignal("SmashKey"):Connect(function()
		if model == localCharacter then
			return
		end
		local key = model:GetAttribute("SmashKey")
		if key and key ~= "" then
			Animator.holdMove(model, key, os.clock())
		else
			-- relâchement : le coup arrive juste après ; sinon (coup reçu…) on abandonne l'élan
			task.delay(0.25, function()
				if model:GetAttribute("SmashKey") == "" then
					Animator.cancelHold(model)
				end
			end)
		end
	end)
	model:GetAttributeChangedSignal("DashStart"):Connect(function()
		if model ~= localCharacter then
			Animator.playDash(model, serverToClock(model:GetAttribute("DashStart")))
			if Animator.onDash then
				Animator.onDash(model)
			end
		end
	end)
	model:GetAttributeChangedSignal("DodgeStart"):Connect(function()
		if model ~= localCharacter then
			Animator.playDodge(model, serverToClock(model:GetAttribute("DodgeStart")))
		end
	end)
	model:GetAttributeChangedSignal("HitstunUntil"):Connect(function()
		AnimCore.playHit(rig.core, rig.core.time, model:GetAttribute("HitPower") or 50)
	end)
	model.Destroying:Connect(function()
		rigs[model] = nil
	end)
end

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Include

local function isGrounded(model, root)
	local humanoid = model:FindFirstChildOfClass("Humanoid")
	if humanoid and humanoid.FloorMaterial ~= Enum.Material.Air then
		return true
	end
	local arena = workspace:FindFirstChild("Arena")
	if not arena then
		return humanoid == nil
	end
	rayParams.FilterDescendantsInstances = { arena }
	return workspace:Raycast(root.Position, Vector3.new(0, -3.4 * (root.Size.Y / 2), 0), rayParams) ~= nil
end

local function applyPose(rig, pose)
	for key, motor in pairs(rig.motors) do
		local v = pose[key]
		if v then
			motor.Transform = toCFrame(v)
		end
	end
end

local reportedErrors = {}

local function stepModel(model, rig, dt, now, serverNow)
	local root = model:FindFirstChild("HumanoidRootPart")
	if root then
		-- Si une animation Roblox tourne quand même (script Animate par défaut), on la coupe
		local humanoid = model:FindFirstChildOfClass("Humanoid")
		local robloxAnimator = humanoid and humanoid:FindFirstChildOfClass("Animator")
		if robloxAnimator then
			for _, playing in ipairs(robloxAnimator:GetPlayingAnimationTracks()) do
				playing:Stop(0)
			end
		end
		local pose = rig.core.lastPose
		if now >= rig.freezeUntil or not pose then
			local data = characterData(model)
			local held = model:GetAttribute("Held") or ""
			local velocity = root.AssemblyLinearVelocity
			local mirrored = root.CFrame.LookVector.X < 0
			local armed = model:GetAttribute("Armed") == true
			if mirrored ~= rig.mirrored or armed ~= rig.armed or held ~= rig.heldId then
				rig.mirrored, rig.armed, rig.heldId = mirrored, armed, held
				if Animator.onMirror then
					Animator.onMirror(model, mirrored)
				end
			end
			pose = AnimCore.step(rig.core, {
				dt = dt,
				grounded = isGrounded(model, root),
				speed = math.abs(velocity.X),
				velY = velocity.Y,
				hitstun = serverNow < (model:GetAttribute("HitstunUntil") or 0),
				frozen = (root.Anchored and not model:GetAttribute("Grabbed")) or model:GetAttribute("Eliminated") == true,
				style = data and data.style,
				bottle = data ~= nil and data.holdsBottle == true and armed, -- la bouteille sort de la Caisse Bizarre
				drunk = model:GetAttribute("Bulles") or 0,
				mirror = mirrored,
				charging = Animator.isCharging(model),
				charge = data and data.charge,
				respawnElapsed = serverNow - (model:GetAttribute("RespawnStart") or -100),
				respawn = data and data.respawn,
				weapon = held ~= "" and held or nil,
				held = model:GetAttribute("Grabbed") == true,
				holding = model:GetAttribute("Holding") == true,
				grabHold = data and data.grabHold,
				obese = (model:GetAttribute("ObeseUntil") or 0) > serverNow,
				dashing = now < (rig.dashUntil or 0),
			})
		end
		applyPose(rig, pose)
	end
end

local function step(dt)
	local now = os.clock()
	local serverNow = workspace:GetServerTimeNow()
	for _, model in ipairs(CollectionService:GetTagged("Fighter")) do
		track(model)
	end
	for model, rig in pairs(rigs) do
		-- une erreur sur un perso ne bloque pas les autres, et elle est signalée une seule fois
		local ok, err = pcall(stepModel, model, rig, dt, now, serverNow)
		if not ok and not reportedErrors[err] then
			reportedErrors[err] = true
			warn("[Animation] erreur : " .. tostring(err))
			if Animator.onReport then
				Animator.onReport(model, "Erreur d'animation : " .. tostring(err), false)
			end
		end
	end
end

function Animator.start()
	-- PreSimulation passe après l'Animator de Roblox : nos poses ont le dernier mot
	RunService.PreSimulation:Connect(step)
	-- et on réapplique la dernière pose juste avant l'affichage, au cas où autre chose l'aurait écrasée
	RunService.PreRender:Connect(function()
		for _, rig in pairs(rigs) do
			if rig.core.lastPose then
				pcall(applyPose, rig, rig.core.lastPose)
			end
		end
	end)
end

return Animator
