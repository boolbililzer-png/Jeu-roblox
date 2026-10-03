-- Déplacements façon Brawlhalla, partagés entre le client (son perso) et le serveur (bots).
-- 2.5D : axe X uniquement (Z verrouillé). Saut au sol + 2 sauts aériens, chute rapide,
-- glissade / saut mural, esquive (sol / air directionnelle), plateformes traversables,
-- éjection via AssemblyLinearVelocity + hitstun (contrôles coupés).
local Config = require(script.Parent.Config)

local MotorController = {}
MotorController.__index = MotorController

local function now(): number
	return workspace:GetServerTimeNow()
end

local function sign(x: number): number
	if x > 0 then
		return 1
	elseif x < 0 then
		return -1
	end
	return 0
end

export type Input = {
	moveX: number,
	moveY: number,
	jump: boolean,
	jumpHeld: boolean,
	dodge: boolean,
}

function MotorController.new(model: Model, opts: { extraAirJumps: number?, glide: boolean? }?)
	local self = setmetatable({}, MotorController)
	self.model = model
	self.hrp = model:WaitForChild("HumanoidRootPart") :: BasePart
	self.hum = model:WaitForChild("Humanoid") :: Humanoid
	self.scaleW = model:GetAttribute("ScaleW") or 1
	self.scaleH = model:GetAttribute("ScaleH") or 1
	self.maxAirJumps = Config.AirJumps + ((opts and opts.extraAirJumps) or 0)
	self.canGlide = (opts and opts.glide) or false
	self.airJumps = self.maxAirJumps
	self.facing = 1
	self.lockUntil = 0
	self.hitstunUntil = 0
	self.hitT = 0
	self.inPhysics = false
	self.motion = nil
	self.dodgeUntil = 0
	self.dodgeCdUntil = 0
	self.airDodgeUsed = false
	self.passUntil = 0
	self.passing = false
	self.slideX = 0
	self.glideUntil = 0
	self.wallDir = 0
	self.downHeld = 0
	self.onDodge = nil :: ((dir: Vector3) -> ())?

	local hum = self.hum
	hum.AutoRotate = false
	for _, st in
		{
			Enum.HumanoidStateType.FallingDown,
			Enum.HumanoidStateType.Ragdoll,
			Enum.HumanoidStateType.Climbing,
			Enum.HumanoidStateType.Swimming,
			Enum.HumanoidStateType.Seated,
			Enum.HumanoidStateType.Jumping,
			Enum.HumanoidStateType.Dead,
		}
	do
		hum:SetStateEnabled(st, false)
	end

	local att = self.hrp:FindFirstChild("BBAlignAtt") :: Attachment?
	if not att then
		att = Instance.new("Attachment")
		att.Name = "BBAlignAtt"
		att.Parent = self.hrp
	end
	local ao = self.hrp:FindFirstChild("BBAlign") :: AlignOrientation?
	if not ao then
		ao = Instance.new("AlignOrientation")
		ao.Name = "BBAlign"
		ao.Mode = Enum.OrientationAlignmentMode.OneAttachment
		ao.Attachment0 = att
		ao.RigidityEnabled = true
		ao.Parent = self.hrp
	end
	self.align = ao
	self:setFacing(1)
	return self
end

function MotorController:has(status: string): boolean
	local t = self.model:GetAttribute("St_" .. status)
	return t ~= nil and t > now()
end

function MotorController:setFacing(f: number)
	if f == 0 then
		return
	end
	self.facing = f
	self.align.CFrame = CFrame.lookAt(Vector3.zero, Vector3.new(f, 0, 0))
end

function MotorController:isGrounded(): boolean
	return self.hum.FloorMaterial ~= Enum.Material.Air
end

function MotorController:locked(): boolean
	return now() < self.lockUntil
end

function MotorController:isInvulnerable(): boolean
	return now() < self.dodgeUntil
end

-- Verrouille les contrôles pendant un coup (prédiction côté client)
function MotorController:setLock(duration: number)
	self.lockUntil = math.max(self.lockUntil, now() + duration)
end

function MotorController:applyKnockback(vel: Vector3, hitstun: number)
	self.motion = nil
	self.lockUntil = 0
	self.hitstunUntil = now() + hitstun
	self.hitT = now()
	self.hrp.AssemblyLinearVelocity = Vector3.new(vel.X, vel.Y, 0)
	if vel.Magnitude > 2 then
		self.hum:ChangeState(Enum.HumanoidStateType.Physics)
		self.inPhysics = true
	end
end

-- Mouvements imposés par un coup : dash, impulsion (remontée), plongeon, téléport
function MotorController:applyMotion(m)
	local t = now()
	if m.mode == "teleport" then
		self.hrp.CFrame = self.hrp.CFrame + m.offset
		return
	end
	if m.mode == "impulse" then
		self.hrp.AssemblyLinearVelocity = Vector3.new(m.vel.X, m.vel.Y, 0)
		if m.vel.Y > 0 then
			self.hum:ChangeState(Enum.HumanoidStateType.Freefall)
		end
	end
	if m.glide then
		self.glideUntil = t + 1.6
	end
	self.motion = {
		mode = m.mode,
		vel = m.vel,
		startT = t,
		untilT = t + (m.dur or 0.3),
		untilGround = m.untilGround,
	}
	if m.mode == "dive" and m.vel.Y > 0 then
		self.hum:ChangeState(Enum.HumanoidStateType.Freefall)
	end
end

function MotorController:reset()
	self.motion = nil
	self.lockUntil = 0
	self.hitstunUntil = 0
	self.airJumps = self.maxAirJumps
	self.airDodgeUsed = false
	self.dodgeUntil = 0
	self.hrp.AssemblyLinearVelocity = Vector3.zero
	if self.inPhysics then
		self.hum:ChangeState(Enum.HumanoidStateType.Freefall)
		self.inPhysics = false
	end
end

local wallParams = RaycastParams.new()
wallParams.FilterType = Enum.RaycastFilterType.Include
local wallArena = nil

local function solids()
	local arena = workspace:FindFirstChild("Arena")
	local solid = arena and arena:FindFirstChild("Solid")
	if solid ~= wallArena then
		wallArena = solid
		wallParams.FilterDescendantsInstances = if solid then { solid } else {}
	end
	return solid
end

local softOverlap = OverlapParams.new()
softOverlap.FilterType = Enum.RaycastFilterType.Include

function MotorController:updatePassThrough(wantPass: boolean)
	if wantPass == self.passing then
		return
	end
	if not wantPass then
		-- ne redevient solide que si on n'est pas à l'intérieur d'une plateforme
		local arena = workspace:FindFirstChild("Arena")
		local soft = arena and arena:FindFirstChild("Soft")
		if soft then
			softOverlap.FilterDescendantsInstances = { soft }
			if #workspace:GetPartsInPart(self.hrp, softOverlap) > 0 then
				return
			end
		end
	end
	self.passing = wantPass
	self.hrp.CollisionGroup = if wantPass then "FighterPass" else "Fighter"
end

function MotorController:lockZ()
	local p = self.hrp.Position
	if math.abs(p.Z) > 0.03 then
		self.hrp.CFrame = self.hrp.CFrame - Vector3.new(0, 0, p.Z)
	end
	local v = self.hrp.AssemblyLinearVelocity
	if math.abs(v.Z) > 0.01 then
		self.hrp.AssemblyLinearVelocity = Vector3.new(v.X, v.Y, 0)
	end
end

function MotorController:step(dt: number, input: Input)
	local t = now()
	local hrp, hum = self.hrp, self.hum
	local vel = hrp.AssemblyLinearVelocity
	local grounded = self:isGrounded()
	if grounded and vel.Y < 8 then
		self.airJumps = self.maxAirJumps
		self.airDodgeUsed = false
	end

	-- 1) Hitstun : plus aucun contrôle, l'éjection ralentit doucement
	if t < self.hitstunUntil and vel.Y <= 0 and t - self.hitT > 0.12 and solids() then
		-- atterrit pendant l'éjection : on se relève (évite de rester enfoncé dans le sol)
		local down = self.hrp.Size.Y / 2 + hum.HipHeight + 0.4
		if workspace:Raycast(hrp.Position, Vector3.new(0, -down, 0), wallParams) then
			self.hitstunUntil = math.min(self.hitstunUntil, t + 0.08)
		end
	end
	if t < self.hitstunUntil then
		if hum:GetState() ~= Enum.HumanoidStateType.Physics and vel.Magnitude > 2 then
			hum:ChangeState(Enum.HumanoidStateType.Physics)
			self.inPhysics = true
		end
		local vx = vel.X * math.exp(-Config.KnockbackDrag * dt)
		hrp.AssemblyLinearVelocity = Vector3.new(vx, math.max(vel.Y, -Config.MaxFallSpeed * 1.3), 0)
		hum:Move(Vector3.zero)
		self:updatePassThrough(vel.Y > 1)
		self:lockZ()
		return
	elseif self.inPhysics then
		self.inPhysics = false
		hum:ChangeState(Enum.HumanoidStateType.Freefall)
	end

	-- 2) Étourdi / figé (statuts)
	if self:has("stun") then
		hum:Move(Vector3.zero)
		self:lockZ()
		return
	end

	-- 3) Mouvement imposé par un coup
	local m = self.motion
	if m then
		local landed = m.untilGround and grounded and (t - m.startT) > 0.08
		if t > m.untilT or landed then
			self.motion = nil
		else
			if m.mode == "dash" then
				local vy = if grounded then vel.Y else 0
				hrp.AssemblyLinearVelocity = Vector3.new(m.vel.X, vy, 0)
			elseif m.mode == "dive" then
				hrp.AssemblyLinearVelocity = Vector3.new(m.vel.X, m.vel.Y, 0)
			end
			self:updatePassThrough(m.vel.Y > 1)
			hum:Move(Vector3.zero)
			self:lockZ()
			return
		end
	end

	local moveX, moveY = input.moveX, input.moveY
	local locked = t < self.lockUntil
	local jump, dodge = input.jump, input.dodge

	if locked then
		jump, dodge = false, false
		moveX = if grounded then 0 else moveX * 0.6
	end

	-- 4) Statuts de contrôle
	if self:has("invert") then
		moveX = -moveX
	end
	if self:has("root") then
		moveX, jump = 0, false
	end
	if self:has("slip") and grounded then
		if self.slideX == 0 then
			self.slideX = if moveX ~= 0 then sign(moveX) else self.facing
		end
		moveX = self.slideX
	else
		self.slideX = 0
	end
	local speedMult = (self.model:GetAttribute("SpeedMult") or 1) * (if self:has("slow") then 0.55 else 1)

	-- 5) Esquive
	if dodge and t >= self.dodgeCdUntil and not self.model:GetAttribute("NoDodge") then
		local dir = Vector3.new(moveX, moveY, 0)
		if grounded then
			self.dodgeCdUntil = t + Config.DodgeInvuln + Config.DodgeCooldownGround
			self.dodgeUntil = t + Config.DodgeInvuln
			if math.abs(moveX) > 0.2 then
				self:applyMotion({ mode = "dash", vel = Vector3.new(sign(moveX) * Config.DodgeSpeed, 0, 0), dur = Config.DodgeDuration })
			end
			if self.onDodge then
				self.onDodge(dir)
			end
		elseif not self.airDodgeUsed then
			self.airDodgeUsed = true
			self.dodgeCdUntil = t + Config.DodgeInvuln + Config.DodgeCooldownAir
			self.dodgeUntil = t + Config.DodgeInvuln
			local v = if dir.Magnitude > 0.2 then dir.Unit * Config.DodgeSpeed else Vector3.zero
			self:applyMotion({ mode = "dive", vel = v, dur = Config.DodgeDuration })
			if self.onDodge then
				self.onDodge(dir)
			end
		end
	end

	-- 6) Mur : glissade et saut mural
	self.wallDir = 0
	if not grounded and moveX ~= 0 and solids() then
		local dirX = sign(moveX)
		local hit = workspace:Raycast(hrp.Position, Vector3.new(dirX * (1.2 * self.scaleW + 0.6), 0, 0), wallParams)
		if hit then
			self.wallDir = dirX
		end
	end

	-- 7) Sauts
	local vy = vel.Y
	local vx = vel.X
	if jump then
		if grounded then
			vy = Config.JumpVelocity
			hum:ChangeState(Enum.HumanoidStateType.Freefall)
		elseif self.wallDir ~= 0 then
			vy = Config.JumpVelocity
			vx = -self.wallDir * Config.WallJumpPush
			self.airJumps = math.max(self.airJumps, 1)
		elseif self.airJumps > 0 then
			self.airJumps -= 1
			vy = Config.AirJumpVelocity
		end
	end

	-- 8) Chute rapide, plané, glissade murale, vitesse de chute max
	if not grounded then
		if moveY < -0.7 and vy < 12 and not locked then
			vy = -Config.FastFallSpeed
		else
			local parachute = (self.model:GetAttribute("Parachute") or 0) > t
			local glide = parachute or (input.jumpHeld and (self.canGlide or t < self.glideUntil))
			if glide and vy < -Config.GlideFallSpeed then
				vy = -Config.GlideFallSpeed
			end
			if self.wallDir ~= 0 and vy < -Config.WallSlideSpeed then
				vy = -Config.WallSlideSpeed
			end
			vy = math.max(vy, -Config.MaxFallSpeed)
		end
	end
	if vy ~= vel.Y or vx ~= vel.X then
		hrp.AssemblyLinearVelocity = Vector3.new(vx, vy, 0)
	end

	-- 9) Course
	hum.WalkSpeed = (if grounded then Config.WalkSpeed else Config.AirSpeed) * speedMult
	hum:Move(Vector3.new(moveX, 0, 0))
	if not locked and math.abs(moveX) > 0.1 then
		self:setFacing(sign(moveX))
	end

	-- 10) Plateformes traversables : en montant, ou bas maintenu pour descendre
	if grounded and moveY < -0.8 and not locked then
		self.downHeld += dt
		if self.downHeld > 0.16 then
			self.passUntil = t + 0.3
		end
	else
		self.downHeld = 0
	end
	self:updatePassThrough(vy > 1 or t < self.passUntil)
	self:lockZ()
end

return MotorController
