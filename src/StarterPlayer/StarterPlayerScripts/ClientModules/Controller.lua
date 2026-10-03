-- Contrôles du joueur local. Règle d'or mobile : un seul bouton à la fois.
--   Déplacement : joystick / ZQSD / WASD / flèches     Saut : Espace / bouton SAUT / A (manette)
--   P (attaque légère) : J / X manette                  S (signature, maintenir = charger) : K / Y manette
--   Esquive : L ou Maj / B manette                      ✋ ramasser-lancer-saisir : E ou H / R1 manette
-- L'animation part immédiatement chez le joueur (prédiction), le serveur valide les touches.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared.Config)
local Fighters = require(Shared.Fighters)
local MotorController = require(Shared.MotorController)
local Net = require(Shared.Net)

local Animator = require(script.Parent.Animator)

local ToServer = Net.get("ToServer")
local ToClient = Net.get("ToClient")

local Controller = {}
local player = Players.LocalPlayer
local mc = nil
local model: Model? = nil
local controls = nil
local jumpPressed = false
local lastJumpReq = 0
local dodgePressed = false
local buffered: { btn: string, untilT: number }? = nil
local sHeld: string? = nil
local recoveryUsed = false

local INSTANT = { recovery = true, groundpound = true, counter = true, wall = true }

local function now(): number
	return workspace:GetServerTimeNow()
end

local function moveVector(): (number, number)
	local mv = Vector3.zero
	if controls then
		local ok, v = pcall(function()
			return controls:GetMoveVector()
		end)
		if ok and v then
			mv = v
		end
	end
	local x, y = mv.X, -mv.Z
	if math.abs(x) < 0.25 then
		x = 0
	end
	if math.abs(y) < 0.35 then
		y = 0
	end
	return x, y
end

local function canAct(): boolean
	if not mc or not model then
		return false
	end
	local t = now()
	return not mc:locked() and t >= mc.hitstunUntil and not mc:has("stun") and (model:GetAttribute("Grabbed") or 0) < t
end

local function fireAttack(btn: string, phase: string, dx: number, dy: number, air: boolean)
	ToServer:FireServer("attack", { btn = btn, phase = phase, dirX = dx, dirY = dy, air = air })
end

local function predict(slot: string, armed: boolean)
	local key = model and model:GetAttribute("Fighter")
	if not key or not model then
		return nil
	end
	local move = Fighters.move(key, armed, slot)
	Animator.play(model, { anim = move.anim, s = move.startup, a = move.active, r = move.recovery, hits = move.hits }, true)
	mc.lockUntil = now() + move.startup + move.active + move.recovery
	return move
end

local function tryPress(btn: string): boolean
	if not mc or not model then
		return false
	end
	local dx, dy = moveVector()
	local air = not mc:isGrounded()
	local armed = model:GetAttribute("Armed") == true
	if btn == "P" then
		if not canAct() then
			return false
		end
		if dx ~= 0 then
			mc:setFacing(if dx > 0 then 1 else -1)
		end
		predict(Fighters.resolveSlot("P", dx, dy, air), armed)
		fireAttack("P", "down", dx, dy, air)
		return true
	elseif btn == "S" then
		if not canAct() or mc:has("laugh") then
			return false
		end
		local slot = Fighters.resolveSlot("S", dx, dy, air)
		if slot == "Sup" then
			if recoveryUsed and air then
				return true -- remontée déjà utilisée : on ignore
			end
			recoveryUsed = air
		end
		if dx ~= 0 then
			mc:setFacing(if dx > 0 then 1 else -1)
		end
		local move = Fighters.move(model:GetAttribute("Fighter"), armed, slot)
		fireAttack("S", "down", dx, dy, air)
		if INSTANT[move.kind] or slot == "Sup" or slot == "SairD" then
			predict(slot, armed)
		else
			sHeld = slot
			mc.lockUntil = now() + Config.ChargeMaxTime + 0.4
		end
		return true
	end
	return false
end

function Controller.press(btn: string)
	if btn == "dodge" then
		dodgePressed = true
		return
	end
	if btn == "grab" then
		if canAct() then
			local dx, dy = moveVector()
			ToServer:FireServer("grab", { dirX = dx, dirY = dy })
		end
		return
	end
	if not tryPress(btn) then
		buffered = { btn = btn, untilT = os.clock() + Config.InputBuffer }
	end
end

function Controller.release(btn: string)
	if btn == "S" and sHeld then
		local slot = sHeld
		sHeld = nil
		local dx, dy = moveVector()
		fireAttack("S", "up", dx, dy, false)
		if model then
			predict(slot, model:GetAttribute("Armed") == true)
		end
	end
end

function Controller.model(): Model?
	return model
end

function Controller.motor()
	return mc
end

local function attach(m: Model?)
	model = nil
	mc = nil
	Animator.setLocal(m)
	if not m or not m:GetAttribute("Fighter") then
		return
	end
	m:WaitForChild("HumanoidRootPart")
	m:WaitForChild("Humanoid")
	local data = Fighters.get(m:GetAttribute("Fighter"))
	local passive = data and data.passive
	mc = MotorController.new(m, {
		extraAirJumps = if passive == "flottaison" then 1 else 0,
		glide = passive == "flottaison",
	})
	mc.onDodge = function()
		ToServer:FireServer("dodge", {})
	end
	model = m
	recoveryUsed = false
	sHeld = nil
end

local KEYS = {
	[Enum.KeyCode.J] = "P", [Enum.KeyCode.ButtonX] = "P",
	[Enum.KeyCode.K] = "S", [Enum.KeyCode.ButtonY] = "S",
	[Enum.KeyCode.L] = "dodge", [Enum.KeyCode.LeftShift] = "dodge", [Enum.KeyCode.ButtonB] = "dodge",
	[Enum.KeyCode.E] = "grab", [Enum.KeyCode.H] = "grab", [Enum.KeyCode.ButtonR1] = "grab",
}

function Controller.start()
	local ok, pm = pcall(function()
		return require(player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))
	end)
	if ok and pm then
		controls = pm:GetControls()
	end

	UserInputService.InputBegan:Connect(function(input, processed)
		if processed then
			return
		end
		local btn = KEYS[input.KeyCode]
		if btn then
			Controller.press(btn)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		local btn = KEYS[input.KeyCode]
		if btn then
			Controller.release(btn)
		end
	end)
	UserInputService.JumpRequest:Connect(function()
		local t = os.clock()
		if t - lastJumpReq > 0.12 then
			jumpPressed = true
		end
		lastJumpReq = t
	end)

	ToClient.OnClientEvent:Connect(function(kind, a, b)
		if not mc then
			return
		end
		if kind == "Hit" then
			sHeld = nil
			mc:applyKnockback(a, b)
		elseif kind == "Motion" then
			if a.vel then
				a.vel = Vector3.new(a.vel.X, a.vel.Y, 0)
			end
			mc:applyMotion(a)
		elseif kind == "Reset" then
			mc:reset()
			recoveryUsed = false
		end
	end)

	player:GetPropertyChangedSignal("Character"):Connect(function()
		attach(player.Character)
	end)
	attach(player.Character)

	-- après le ControlModule (qui appelle Humanoid:Move) pour garder la main sur le déplacement
	RunService:BindToRenderStep("BBController", Enum.RenderPriority.Input.Value + 1, function(dt)
		if not mc or not model or not model.Parent then
			jumpPressed, dodgePressed = false, false
			return
		end
		if buffered then
			if os.clock() > buffered.untilT then
				buffered = nil
			elseif tryPress(buffered.btn) then
				buffered = nil
			end
		end
		local dx, dy = moveVector()
		if mc:isGrounded() then
			recoveryUsed = false
		end
		local held = UserInputService:IsKeyDown(Enum.KeyCode.Space)
			or UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA)
			or (os.clock() - lastJumpReq) < 0.15
		mc:step(dt, { moveX = dx, moveY = dy, jump = jumpPressed, jumpHeld = held, dodge = dodgePressed })
		jumpPressed, dodgePressed = false, false
	end)
end

return Controller
