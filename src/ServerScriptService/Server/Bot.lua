-- IA des bots (indispensable au lancement pour éviter les files d'attente vides).
-- Elle produit les mêmes entrées qu'un joueur : déplacement, saut, esquive, P, S, ✋.
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameData = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("GameData"))
local Fighter = require(script.Parent.Fighter)
local Combat = require(script.Parent.Combat)
local Crates = require(script.Parent.Crates)

local Bot = {}
Bot.__index = Bot

local function now(): number
	return workspace:GetServerTimeNow()
end

function Bot.new(f, level: number?)
	local self = setmetatable({}, Bot)
	self.f = f
	self.level = level or 0.6 -- 0 = facile, 1 = difficile
	self.think = 0
	self.input = { moveX = 0, moveY = 0, jump = false, jumpHeld = false, dodge = false }
	self.prevJump = false
	self.holdS = 0
	return self
end

local function nearestEnemy(f)
	local best, bd = nil, math.huge
	for _, o in Fighter.list do
		if o ~= f and o:alive() then
			local d = (o:position() - f:position()).Magnitude
			if d < bd then
				best, bd = o, d
			end
		end
	end
	return best, bd
end

function Bot:step(dt: number)
	local f = self.f
	if not f:alive() or not f.mc then
		return
	end
	local inp = self.input
	inp.jump = false
	inp.dodge = false
	self.think -= dt
	local pos = f:position()
	local L = GameData.Layout
	local half = L.stage.width / 2
	local offStage = math.abs(pos.X - L.stage.x) > half + 1 or pos.Y < L.stage.top - 1
	local grounded = f.mc:isGrounded()

	-- Retour sur le terrain (priorité absolue)
	if offStage then
		inp.moveX = if pos.X > L.stage.x then -1 else 1
		inp.moveY = 0
		local vy = f.hrp.AssemblyLinearVelocity.Y
		if vy < 4 and f.mc.airJumps > 0 then
			inp.jump = true
		elseif vy < -5 and f.mc.airJumps == 0 and not f.recoveryUsed and pos.Y < L.stage.top + 4 then
			Combat.onAction(f, "attack", { btn = "S", phase = "down", dirX = inp.moveX, dirY = 1, air = true })
		end
		f.mc:step(dt, inp)
		return
	end

	if self.think <= 0 then
		self.think = 0.12 + (1 - self.level) * 0.25 + math.random() * 0.1
		local target, dist = nearestEnemy(f)
		inp.moveY = 0
		if not f.armed then
			-- aller ramasser une caisse proche
			for _, c in Crates.list do
				if c.Parent and math.abs(c.Position.X - pos.X) < 18 and math.abs(c.Position.Y - pos.Y) < 6 then
					if (c.Position - pos).Magnitude < 5 then
						Combat.onAction(f, "grab", { dirX = 0, dirY = 0 })
					else
						inp.moveX = if c.Position.X > pos.X then 1 else -1
						f.mc:step(dt, inp)
						return
					end
				end
			end
		end
		if target then
			local d = target:position() - pos
			local adx = math.abs(d.X)
			inp.moveX = if adx > 3.5 then (if d.X > 0 then 1 else -1) else 0
			-- ne pas se jeter dans le vide
			local nextX = pos.X + inp.moveX * 4
			if math.abs(nextX - L.stage.x) > half - 2 and pos.Y < L.stage.top + 3 and grounded then
				inp.moveX = 0
			end
			if d.Y > 6 and grounded and math.random() < 0.6 then
				inp.jump = true
			end
			-- esquive réactive si l'adversaire attaque tout près
			if dist < 7 and target.busyUntil > now() and math.random() < 0.25 * self.level then
				inp.dodge = true
			end
			-- attaques
			if adx < 5.5 and math.abs(d.Y) < 5 and now() >= f.busyUntil then
				local dirX = if d.X > 0 then 1 else -1
				local air = not grounded
				local r = math.random()
				local heavyWanted = target.damage > 90 and r < 0.55
				if heavyWanted or r < 0.25 then
					local dirY = 0
					if d.Y > 3 then
						dirY = 0 -- signature neutre (souvent anti-air)
					elseif math.random() < 0.3 then
						dirY = -1
					end
					Combat.onAction(f, "attack", { btn = "S", phase = "down", dirX = if math.random() < 0.6 then dirX else 0, dirY = dirY, air = air })
					self.holdS = math.random() * 0.5 * self.level
				elseif r < 0.32 and adx < 4 then
					Combat.onAction(f, "grab", { dirX = dirX, dirY = 0 })
				else
					local dirY = if math.random() < 0.25 then -1 else 0
					Combat.onAction(f, "attack", { btn = "P", phase = "down", dirX = if math.random() < 0.5 then dirX else 0, dirY = dirY, air = air })
				end
			elseif adx < 26 and adx > 10 and math.random() < 0.1 * self.level and now() >= f.busyUntil then
				-- projectile ou dash à distance
				Combat.onAction(f, "attack", { btn = "S", phase = "down", dirX = if d.X > 0 then 1 else -1, dirY = 0, air = not grounded })
				self.holdS = 0.05
			end
		end
	end
	if f.charging then
		self.holdS -= dt
		if self.holdS <= 0 then
			Combat.onAction(f, "attack", { btn = "S", phase = "up" })
		end
	end
	f.mc:step(dt, inp)
end

return Bot
