-- Moteur de combat (serveur autoritaire).
--   * Résolution des coups (grille P / S + direction + air), charge des Signatures (x1.0 -> x1.5)
--   * Hitbox par requêtes spatiales (GetPartBoundsInBox / InRadius), jamais .Touched
--   * Éjection : Force = Base + % * Scaling, appliquée en vitesse, hitstun dynamique
--   * Effets : projectiles, pièges, murs, auras, dashs, remontées, plongeons, contres, aspiration
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared.Config)
local Fighters = require(Shared.Fighters)
local Knockback = require(Shared.Knockback)
local Net = require(Shared.Net)

local Fighter = require(script.Parent.Fighter)
local Passives = require(script.Parent.Passives)
local Crates = require(script.Parent.Crates)

local ToClient = Net.get("ToClient")

local Combat = {}
Combat.projectiles = {} :: { any }
Combat.traps = {} :: { any }
Combat.enabled = false

local function now(): number
	return workspace:GetServerTimeNow()
end

local function sign(x: number): number
	return if x < 0 then -1 else 1
end

local function fxFolder(): Folder
	local f = workspace:FindFirstChild("Fx")
	if not f then
		f = Instance.new("Folder")
		f.Name = "Fx"
		f.Parent = workspace
	end
	return f :: Folder
end

function Combat.broadcast(...)
	ToClient:FireAllClients(...)
end

local function scale(f): (number, number)
	local m = f.model
	return (m and m:GetAttribute("ScaleW") or 1), (m and m:GetAttribute("ScaleH") or 1)
end

---------------------------------------------------------------------------
-- Requêtes spatiales
---------------------------------------------------------------------------
local overlap = OverlapParams.new()
overlap.FilterType = Enum.RaycastFilterType.Include

local function refreshOverlap()
	overlap.FilterDescendantsInstances = { workspace:WaitForChild("Fighters") }
end

local function collect(parts: { BasePart }, exclude): { any }
	local out, seen = {}, {}
	for _, p in parts do
		local f = Fighter.fromPart(p)
		if f and f ~= exclude and not seen[f] and f:alive() then
			seen[f] = true
			table.insert(out, f)
		end
	end
	return out
end

function Combat.inBox(cf: CFrame, size: Vector3, exclude): { any }
	refreshOverlap()
	return collect(workspace:GetPartBoundsInBox(cf, size, overlap), exclude)
end

function Combat.inRadius(pos: Vector3, r: number, exclude): { any }
	refreshOverlap()
	return collect(workspace:GetPartBoundsInRadius(pos, r, overlap), exclude)
end

local function hitboxFor(f, move, facing: number): (CFrame, Vector3)
	local w, h = scale(f)
	local dog = if f:hasStatus("dog") then 0.7 else 1
	local size = Vector3.new(move.hb[1] * w * dog, move.hb[2] * h, 10)
	local center = f:position() + Vector3.new(facing * move.off[1] * w * dog, move.off[2] * h, 0)
	if Config.DebugHitboxes then
		local p = Instance.new("Part")
		p.Anchored, p.CanCollide, p.CanQuery, p.CanTouch = true, false, false, false
		p.Transparency, p.Color, p.Size, p.CFrame = 0.7, Color3.new(1, 0, 0), size, CFrame.new(center)
		p.Parent = fxFolder()
		game:GetService("Debris"):AddItem(p, 0.15)
	end
	return CFrame.new(center), size
end

---------------------------------------------------------------------------
-- Application d'un coup
---------------------------------------------------------------------------
-- ctx : { charge, mult, dirX, attackerPos }
function Combat.applyHit(att, victim, move, ctx): boolean
	if not victim or not victim:alive() or victim == att then
		return false
	end
	local t = now()
	if victim:invulnerable() or (victim.mc and victim.mc:isInvulnerable()) then
		return false
	end
	-- Contre silencieux / parades
	local c = victim.counter
	if c and t < c.untilT and att then
		victim.counter = nil
		Combat.broadcast("Fx", "counter", victim:position())
		local dir = sign(att:position().X - victim:position().X)
		victim.busyUntil = t + 0.35
		Combat.broadcast("Move", victim.model, { slot = "Sd", anim = "counter", s = 0.01, a = 0.1, r = 0.3, hits = 1 })
		Combat.applyHit(victim, att, c.move, { charge = c.charge, mult = c.mult, dirX = dir })
		return false
	end

	local charge = ctx.charge or 1
	local mult = (ctx.mult or 1) * charge
	local dmg = (move.dmg or 0) * mult
	victim.damage = math.min(Config.MaxPercent, victim.damage + dmg)
	victim.lastHitBy = att
	victim.lastHitT = t
	if att then
		att.stats.dealt += dmg
		Passives.onHitDealt(att, victim, move, dmg)
	end
	local armorPassive = Passives.onHitTaken(victim, att, move, dmg)

	if move.status then
		local ok = victim:addStatus(move.status, move.statusDur or 2)
		if ok and move.status == "sneeze" then
			local dur = math.min(move.statusDur or 3, Config.StatusMax)
			task.delay(0.3 + math.random() * (dur - 0.4), function()
				if victim:alive() and victim:hasStatus("sneeze") then
					victim:interrupt()
					victim:sendHit(Vector3.zero, 0.4)
					Combat.broadcast("Fx", "sneeze", victim:position())
				end
			end)
		end
	end

	local dirX = ctx.dirX or (att and att:facing()) or 1
	local force = Knockback.force(move.bkb or 0, move.kbs or 0, victim.damage, charge, victim.data.weight)
	local vel: Vector3
	local hitstun: number
	if move.pull and att then
		local d = att:position() - victim:position()
		local speed = math.clamp(math.abs(d.X) * 5, 18, 55)
		vel = Vector3.new(sign(d.X) * speed, 10, 0)
		hitstun = 0.4
	else
		vel = Knockback.velocity(force, move.angle or 30, dirX)
		hitstun = Knockback.hitstun(force, not move.heavy)
		if vel.Y < 0 and victim:isGrounded() then
			vel = Vector3.new(vel.X, -vel.Y * 0.6, 0) -- rebond au sol
		end
	end

	local armored = armorPassive or victim.armorUntil > t or (victim.dashArmorUntil or 0) > t
	if armored then
		victim:sendHit(Vector3.zero, 0)
	else
		victim:interrupt()
		victim:sendHit(vel, hitstun)
	end
	victim:sync()
	Combat.broadcast("Fx", "hit", victim:position(), force, move.heavy == true, if att then att.data.look.body.torso else "#ffffff")
	return true
end

---------------------------------------------------------------------------
-- Projectiles
---------------------------------------------------------------------------
local function makeFxPart(shape: string?, size: Vector3, color: string, mat: string?, tr: number?): BasePart
	local p = Instance.new("Part")
	p.Anchored, p.CanCollide, p.CanQuery, p.CanTouch = true, false, false, false
	p.CastShadow = false
	p.Size = size
	if shape == "Ball" then
		p.Shape = Enum.PartType.Ball
	elseif shape == "Cyl" then
		p.Shape = Enum.PartType.Cylinder
	end
	p.Color = Color3.fromHex(color)
	local ok, m = pcall(function()
		return (Enum.Material :: any)[mat or "Neon"]
	end)
	p.Material = if ok and m then m else Enum.Material.Neon
	p.Transparency = tr or 0
	p.Parent = fxFolder()
	return p
end

function Combat.spawnProjectile(owner, move, ctx, override)
	local def = override or move.proj
	if not def or not owner:alive() then
		return
	end
	local w, h = scale(owner)
	local facing = ctx.dirX
	local speed = def.speed
	if owner.data.passive == "likes" and (owner.passive.viralUntil or 0) > now() then
		speed *= 1.25
	end
	local size = def.size or 1.2
	local partSize = if def.shape == "Cyl" then Vector3.new(0.4, size, size) else Vector3.new(size, size, size)
	local part = makeFxPart(def.shape, partSize, def.color or "#ffffff", def.mat, def.tr)
	local pos = owner:position() + Vector3.new(facing * 2 * w, 0.6 * h, 0)
	local vel = Vector3.new(facing * speed, (def.up or 0) * speed, 0)
	part.CFrame = CFrame.new(pos)
	table.insert(Combat.projectiles, {
		owner = owner, move = move, ctx = ctx, def = def, part = part, pos = pos, vel = vel,
		born = now(), life = def.life or 1.2, hit = {}, speed = speed, t = 0,
	})
end

local solidParams = RaycastParams.new()
solidParams.FilterType = Enum.RaycastFilterType.Include

local function explode(owner, pos: Vector3, radius: number, move, ctx)
	Combat.broadcast("Fx", "aura", pos, radius, move.vfx or "#ffd166")
	for _, v in Combat.inRadius(pos, radius, owner) do
		Combat.applyHit(owner, v, move, { charge = ctx.charge, mult = ctx.mult, dirX = sign(v:position().X - pos.X) })
	end
end

local function nearestEnemy(f, pos: Vector3)
	local best, bd = nil, math.huge
	for _, o in Fighter.list do
		if o ~= f and o:alive() then
			local d = (o:position() - pos).Magnitude
			if d < bd then
				best, bd = o, d
			end
		end
	end
	return best
end

local function wallsBlock(pos: Vector3, owner): BasePart?
	local fx = workspace:FindFirstChild("Fx")
	if not fx then
		return nil
	end
	for _, f in Fighter.list do
		if f ~= owner then
			for _, wpart in f.walls do
				if wpart.Parent then
					local rel = wpart.CFrame:PointToObjectSpace(pos)
					local s = wpart.Size / 2
					if math.abs(rel.X) <= s.X + 0.5 and math.abs(rel.Y) <= s.Y and math.abs(rel.Z) <= s.Z then
						return wpart
					end
				end
			end
		end
	end
	return nil
end

local function updateProjectiles(dt: number)
	local arena = workspace:FindFirstChild("Arena")
	solidParams.FilterDescendantsInstances = if arena then { arena:FindFirstChild("Solid") } else {}
	for i = #Combat.projectiles, 1, -1 do
		local pr = Combat.projectiles[i]
		local def, owner = pr.def, pr.owner
		local dead = false
		pr.t += dt
		if pr.t > pr.life or not owner.model then
			dead = true
		else
			if def.homing then
				local target = nearestEnemy(owner, pr.pos)
				if target then
					local want = (target:position() - pr.pos).Unit * pr.speed
					pr.vel = pr.vel:Lerp(Vector3.new(want.X, want.Y, 0), math.min(1, dt * 2.5))
				end
			end
			if def.boomerang and pr.t > pr.life * 0.45 then
				local back = owner:position() - pr.pos
				if back.Magnitude < 3 then
					dead = true
				else
					pr.vel = back.Unit * pr.speed
				end
			end
			if def.grav and def.grav > 0 then
				pr.vel -= Vector3.new(0, def.grav * dt, 0)
			end
			local step = pr.vel * dt
			if def.wobble then
				step += Vector3.new(0, math.sin(pr.t * 9) * 12 * dt, 0)
			end
			local hit = workspace:Raycast(pr.pos, step, solidParams)
			if hit then
				dead = true
				if pr.move.extra == "grapple" then
					local d = hit.Position - owner:position()
					owner:sendMotion({ mode = "dive", vel = d.Unit * 80, dur = math.min(0.5, d.Magnitude / 80) })
				end
			else
				pr.pos += step
			end
			local wall = wallsBlock(pr.pos, owner)
			if wall then
				dead = true
				if wall:GetAttribute("BlockOnce") then
					wall:Destroy()
				end
			end
		end
		if not dead then
			pr.part.CFrame = CFrame.new(pr.pos) * CFrame.Angles(0, 0, pr.t * 8)
			local victims = Combat.inRadius(pr.pos, (def.size or 1.2) * 0.6 + 1.2, owner)
			for _, v in victims do
				if not pr.hit[v] then
					pr.hit[v] = true
					local landed = Combat.applyHit(owner, v, pr.move, {
						charge = pr.ctx.charge, mult = pr.ctx.mult, dirX = sign(pr.vel.X),
					})
					if landed and pr.move.extra == "grappleSelf" then
						local d = v:position() - owner:position()
						owner:sendMotion({ mode = "dive", vel = d.Unit * 75, dur = math.min(0.45, d.Magnitude / 75) })
					end
					if not def.pierce then
						dead = true
						break
					end
				end
			end
		end
		if dead then
			if def.explode then
				explode(owner, pr.pos, def.explode, pr.move, pr.ctx)
			end
			pr.part:Destroy()
			table.remove(Combat.projectiles, i)
		end
	end
end

---------------------------------------------------------------------------
-- Pièges et murs
---------------------------------------------------------------------------
local function groundY(x: number, fromY: number): number?
	local arena = workspace:FindFirstChild("Arena")
	if not arena then
		return nil
	end
	local p = RaycastParams.new()
	p.FilterType = Enum.RaycastFilterType.Include
	p.FilterDescendantsInstances = { arena:FindFirstChild("Solid"), arena:FindFirstChild("Soft") }
	local r = workspace:Raycast(Vector3.new(x, fromY + 1, 0), Vector3.new(0, -40, 0), p)
	return r and r.Position.Y
end

function Combat.spawnTrap(owner, move, ctx)
	local w = scale(owner)
	local count = move.count or 1
	for i = 1, count do
		local x = owner:position().X + ctx.dirX * (2.5 + (i - 1) * 3.2) * w
		local y = groundY(x, owner:position().Y)
		if y then
			local size = move.trapSize or { 3, 1.5 }
			local part = makeFxPart("Block", Vector3.new(size[1], 0.35, 6), move.vfx or "#ffffff", "Neon", 0.35)
			part.CFrame = CFrame.new(x, y + 0.18, 0)
			local trap = {
				owner = owner, move = move, ctx = ctx, part = part, born = now(),
				life = move.life or 6, delay = move.delay, tick = 0,
			}
			table.insert(Combat.traps, trap)
			table.insert(owner.traps, part)
			local maxN = move.maxTraps or 6
			while #owner.traps > maxN do
				local old = table.remove(owner.traps, 1)
				if old and old.Parent then
					old:Destroy()
				end
			end
		end
	end
end

local function updateTraps(dt: number)
	local t = now()
	for i = #Combat.traps, 1, -1 do
		local tr = Combat.traps[i]
		local dead = not tr.part.Parent or not tr.owner.model
		if not dead then
			local age = t - tr.born
			if tr.delay then
				if age >= tr.delay then
					explode(tr.owner, tr.part.Position, tr.move.radius or 6, tr.move, tr.ctx)
					dead = true
				end
			else
				local size = tr.part.Size + Vector3.new(0, 6, 4)
				local cf = tr.part.CFrame + Vector3.new(0, 2.5, 0)
				for _, v in Combat.inBox(cf, size, tr.owner) do
					if tr.move.persistent then
						tr.tick -= dt
						if tr.tick <= 0 then
							tr.tick = 0.5
							if tr.move.status then
								v:addStatus(tr.move.status, tr.move.statusDur or 1.5)
							end
						end
					else
						Combat.applyHit(tr.owner, v, tr.move, {
							charge = tr.ctx.charge, mult = tr.ctx.mult, dirX = sign(v:position().X - tr.part.Position.X),
						})
						dead = true
						break
					end
				end
			end
			if age > tr.life then
				dead = true
			end
		end
		if dead then
			if tr.part.Parent then
				tr.part:Destroy()
			end
			local j = table.find(tr.owner.traps, tr.part)
			if j then
				table.remove(tr.owner.traps, j)
			end
			table.remove(Combat.traps, i)
		end
	end
end

function Combat.spawnWall(owner, move, ctx)
	local w, h = scale(owner)
	local size = move.wallSize or { 1.2, 6 }
	local x = owner:position().X + ctx.dirX * 3 * w
	local y = groundY(x, owner:position().Y) or (owner:position().Y - 3)
	local tr = if owner.key == "marcel" then 0.82 else 0.35
	local part = makeFxPart("Block", Vector3.new(size[1], size[2] * h, 8), move.vfx or "#ffffff", "Glass", tr)
	part.CFrame = CFrame.new(x, y + size[2] * h / 2, 0)
	if move.solid then
		part.CanCollide = true
		part.CollisionGroup = "Wall"
	else
		part:SetAttribute("BlockOnce", true)
	end
	table.insert(owner.walls, part)
	local maxN = move.maxWalls or 1
	while #owner.walls > maxN do
		local old = table.remove(owner.walls, 1)
		if old and old.Parent then
			old:Destroy()
		end
	end
	task.delay(move.life or 5, function()
		if part.Parent then
			part:Destroy()
		end
		local j = table.find(owner.walls, part)
		if j then
			table.remove(owner.walls, j)
		end
	end)
end

---------------------------------------------------------------------------
-- Exécution d'un coup
---------------------------------------------------------------------------
local function canAct(f): boolean
	local t = now()
	return f:alive() and t >= f.busyUntil and t >= f.hitstunUntil and not f:hasStatus("stun") and not f.grabbedBy
end

-- boucle par frame pendant `dur` secondes ; fn(elapsed) renvoie true pour arrêter
local function during(f, token: number, dur: number, fn: (number) -> boolean?)
	task.spawn(function()
		local t0 = os.clock()
		while true do
			RunService.Heartbeat:Wait()
			local el = os.clock() - t0
			if f.token ~= token or not f:alive() or el > dur then
				return
			end
			if fn(el) then
				return
			end
		end
	end)
end

local function hitEachOnce(f, move, ctx, cf: CFrame, size: Vector3, already)
	for _, v in Combat.inBox(cf, size, f) do
		if not already[v] then
			already[v] = true
			Combat.applyHit(f, v, move, ctx)
		end
	end
end

function Combat.perform(f, slot: string, move, ctx)
	local kind = move.kind
	local token = ctx.token
	local w, h = scale(f)
	local facing = ctx.dirX

	if kind == "melee" then
		local n = math.max(1, move.hits or 1)
		for i = 1, n do
			task.delay((i - 1) * move.active / n, function()
				if f.token ~= token or not f:alive() then
					return
				end
				local cf, size = hitboxFor(f, move, facing)
				for _, v in Combat.inBox(cf, size, f) do
					Combat.applyHit(f, v, move, ctx)
				end
			end)
		end
	elseif kind == "projectile" then
		Combat.spawnProjectile(f, move, ctx)
	elseif kind == "dash" then
		if move.extra == "spit" and f.stored then
			local stored = f.stored
			f.stored = nil
			local def = table.clone(stored.def)
			def.speed = (def.speed or 60) * 1.5
			local m = table.clone(move)
			m.dmg, m.bkb, m.kbs = 15, 30, 0.62
			Combat.spawnProjectile(f, m, ctx, def)
			return
		end
		local dur = move.dur or 0.4
		f:sendMotion({ mode = "dash", vel = Vector3.new(facing * (move.speed or 50), 0, 0), dur = dur })
		if move.armor then
			f.dashArmorUntil = now() + dur
		end
		local n = math.max(1, move.hits or 1)
		local already = {}
		local lastWave = 0
		during(f, token, dur + 0.05, function(el)
			local wave = math.floor(el / (dur / n))
			if wave ~= lastWave then
				lastWave = wave
				already = {}
			end
			local cf, size = hitboxFor(f, move, facing)
			hitEachOnce(f, move, ctx, cf, size, already)
			return false
		end)
	elseif kind == "trap" then
		Combat.spawnTrap(f, move, ctx)
	elseif kind == "wall" then
		Combat.spawnWall(f, move, ctx)
	elseif kind == "counter" then
		f.counter = { untilT = now() + (move.window or 0.5), move = move, charge = ctx.charge, mult = ctx.mult }
		Combat.broadcast("Fx", "counterReady", f:position())
	elseif kind == "aura" then
		local r = (move.radius or 6) * (w + h) / 2 * (ctx.charge or 1) ^ 0.5
		local n = math.max(1, move.hits or 1)
		for i = 1, n do
			task.delay((i - 1) * move.active / n, function()
				if f.token ~= token or not f:alive() then
					return
				end
				local pos = f:position()
				Combat.broadcast("Fx", "aura", pos, r, move.vfx or "#ffffff")
				for _, v in Combat.inRadius(pos, r, f) do
					local d = v:position().X - pos.X
					local dir = if math.abs(d) < 0.3 then facing else sign(d)
					Combat.applyHit(f, v, move, { charge = ctx.charge, mult = ctx.mult, dirX = dir })
				end
			end)
		end
	elseif kind == "vacuum" then
		local r = (move.radius or 9) * w
		local damaged = {}
		local acc = 0
		Combat.broadcast("Fx", "vacuum", f.model, move.dur or 0.7)
		during(f, token, move.dur or 0.7, function(el)
			acc += 1 / 60
			local pos = f:position()
			-- avale les projectiles adverses
			for i = #Combat.projectiles, 1, -1 do
				local pr = Combat.projectiles[i]
				if pr.owner ~= f and (pr.pos - pos).Magnitude < r and (pr.pos.X - pos.X) * facing > -2 then
					f.stored = { def = pr.def }
					pr.part:Destroy()
					table.remove(Combat.projectiles, i)
					Combat.broadcast("Fx", "absorb", pos)
				end
			end
			if acc >= 0.1 then
				acc = 0
				for _, v in Combat.inRadius(pos, r, f) do
					local dx = v:position().X - pos.X
					if dx * facing > -1 then
						if not damaged[v] then
							damaged[v] = true
							Combat.applyHit(f, v, move, ctx)
						else
							v:sendHit(Vector3.new(-sign(dx) * 26, 6, 0), 0.15)
						end
					end
				end
			end
			return false
		end)
	elseif kind == "recovery" then
		f:sendMotion({
			mode = "impulse",
			vel = Vector3.new(facing * (move.vx or 0), move.vy or 75, 0),
			dur = move.active + 0.15,
			glide = move.glide,
		})
		if not move.nohit then
			local already = {}
			during(f, token, move.active + 0.15, function()
				local cf, size = hitboxFor(f, move, facing)
				hitEachOnce(f, move, ctx, cf, size, already)
				return false
			end)
		end
	elseif kind == "groundpound" then
		local startPos = f:position()
		local function land()
			local pos = f:position()
			local r = (move.radius or 6.5) * (w + h) / 2
			Combat.broadcast("Fx", "aura", pos - Vector3.new(0, 2 * h, 0), r, move.vfx or "#ffffff")
			local any = false
			for _, v in Combat.inRadius(pos, r, f) do
				local d = v:position().X - pos.X
				any = Combat.applyHit(f, v, move, { charge = ctx.charge, mult = ctx.mult, dirX = if math.abs(d) < 0.3 then facing else sign(d) }) or any
			end
			if move.extra == "candies" then
				for _, dx in { -1, 1 } do
					local m = table.clone(move)
					m.dmg, m.bkb, m.kbs = 4, 10, 0.1
					Combat.spawnProjectile(f, m, { charge = 1, mult = ctx.mult, dirX = dx }, {
						speed = 45, grav = 60, up = 0.6, size = 0.8, life = 0.9, color = "#a3e4d7", mat = "Neon",
					})
				end
			end
			return any
		end
		if f:isGrounded() then
			land()
			return
		end
		f:sendMotion({ mode = "dive", vel = Vector3.new(facing * (move.vx or 0), move.vy or -95, 0), dur = 1.6, untilGround = true })
		local already = {}
		local anyHit = false
		during(f, token, 1.6, function(el)
			local cf, size = hitboxFor(f, move, facing)
			for _, v in Combat.inBox(cf, size, f) do
				if not already[v] then
					already[v] = true
					anyHit = Combat.applyHit(f, v, move, ctx) or anyHit
				end
			end
			if el > 0.07 and f:isGrounded() then
				anyHit = land() or anyHit
				if move.extra == "rewind" and not anyHit then
					f:sendMotion({ mode = "teleport", offset = startPos - f:position() })
				end
				return true
			end
			return false
		end)
	end
end

function Combat.startMove(f, slot: string, charge: number, dirX: number)
	local move = Fighters.move(f.key, f.armed, slot)
	if not move then
		return
	end
	move = Passives.onMoveStart(f, slot, move)
	f.token += 1
	local token = f.token
	local t0 = now()
	local facing = if dirX ~= 0 then sign(dirX) else f:facing()
	if f.mc then
		f.mc:setFacing(facing)
	end
	local mult = Passives.damageMult(f, t0)
	local total = move.startup + move.active + move.recovery
	f.busyUntil = t0 + total
	if slot == "Sup" then
		f.recoveryUsed = true
		f.recoveryT = t0
	end
	if move.invuln then
		f.invulnUntil = t0 + move.invuln
	end
	if f.mc then
		f.mc:setLock(total)
	end
	Combat.broadcast("Move", f.model, {
		slot = slot, anim = move.anim, s = move.startup, a = move.active, r = move.recovery,
		hits = move.hits or 1, charge = charge, onBeat = f.onBeat, armed = f.armed,
	})
	local ctx = { charge = charge, mult = mult, dirX = facing, token = token }
	task.delay(move.startup, function()
		if f.token == token and f:alive() then
			Combat.perform(f, slot, move, ctx)
		end
	end)
end

local INSTANT = { recovery = true, groundpound = true, counter = true, wall = true }

-- Entrées venant du client (ou du bot)
function Combat.onAction(f, action: string, data)
	if not Combat.enabled or not f or not f:alive() then
		return
	end
	local t = now()
	data = if type(data) == "table" then data else {}
	local dirX = math.clamp(tonumber(data.dirX) or 0, -1, 1)
	local dirY = math.clamp(tonumber(data.dirY) or 0, -1, 1)
	local air = data.air == true

	if action == "attack" then
		local btn = data.btn
		if btn == "P" and data.phase == "down" then
			if canAct(f) then
				Combat.startMove(f, Fighters.resolveSlot("P", dirX, dirY, air), 1, dirX)
			end
		elseif btn == "S" then
			if data.phase == "down" then
				if not canAct(f) or f:hasStatus("laugh") or f.charging then
					return
				end
				local slot = Fighters.resolveSlot("S", dirX, dirY, air)
				if slot == "Sup" and f.recoveryUsed and not f:isGrounded() then
					return -- remontée déjà utilisée dans ce saut
				end
				local move = Fighters.move(f.key, f.armed, slot)
				if INSTANT[move.kind] or slot == "Sup" or slot == "SairD" then
					Combat.startMove(f, slot, 1, dirX)
					return
				end
				f.token += 1
				local token = f.token
				f.charging = { slot = slot, t0 = t, dirX = dirX, token = token }
				f.busyUntil = t + Config.ChargeMaxTime + 1
				if f.mc then
					f.mc:setLock(Config.ChargeMaxTime + 0.3)
				end
				f.model:SetAttribute("Charging", slot)
				Combat.broadcast("Charge", f.model, slot, f.armed)
				task.delay(Config.ChargeMaxTime + 0.15, function()
					if f.charging and f.charging.token == token then
						Combat.onAction(f, "attack", { btn = "S", phase = "up" })
					end
				end)
			elseif data.phase == "up" and f.charging then
				local c = f.charging
				f.charging = nil
				f.model:SetAttribute("Charging", nil)
				f.busyUntil = 0
				local charge = Knockback.chargeMultiplier(t - c.t0)
				Combat.startMove(f, c.slot, charge, if c.dirX ~= 0 then c.dirX else dirX)
			end
		end
	elseif action == "dodge" then
		if t >= (f.nextDodge or 0) and t >= f.hitstunUntil and not f.model:GetAttribute("NoDodge") then
			f.nextDodge = t + Config.DodgeInvuln + 0.8
			f.invulnUntil = math.max(f.invulnUntil, t + Config.DodgeInvuln)
			f.model:SetAttribute("DodgeUntil", t + Config.DodgeInvuln)
			f:interrupt()
		end
	elseif action == "grab" then
		Combat.grab(f, dirX, dirY)
	end
end

-- ✋ : lancer l'arme, ramasser une Caisse Bizarre, ou saisir l'adversaire
function Combat.grab(f, dirX: number, dirY: number)
	if not canAct(f) then
		return
	end
	local t = now()
	local facing = if dirX ~= 0 then sign(dirX) else f:facing()
	if f.armed then
		f.armed = false
		f:sync()
		f.busyUntil = t + 0.3
		local wt = Config.WeaponThrow
		local move = { dmg = wt.dmg, bkb = wt.bkb, kbs = wt.kbs, angle = 30, heavy = true, kind = "projectile" }
		Combat.broadcast("Move", f.model, { slot = "throw", anim = "throw", s = 0.08, a = 0.1, r = 0.2, hits = 1 })
		Combat.spawnProjectile(f, move, { charge = 1, mult = 1, dirX = facing }, {
			speed = wt.speed, size = 1.6, life = 1.0, shape = "Block", color = "#8e5a2b", mat = "Wood",
		})
		return
	end
	if Crates.tryPickup(f) then
		f.armed = true
		f:sync()
		Combat.broadcast("Fx", "pickup", f:position())
		return
	end
	local g = Config.Grab
	local w = scale(f)
	local pos = f:position()
	local target
	for _, o in Fighter.list do
		if o ~= f and o:alive() and not o:invulnerable() then
			local d = o:position() - pos
			if d.X * facing > -0.5 and math.abs(d.X) < g.range + w and math.abs(d.Y) < 3.5 then
				target = o
				break
			end
		end
	end
	f.busyUntil = t + 0.45
	Combat.broadcast("Move", f.model, { slot = "grab", anim = "grab", s = 0.1, a = g.hold, r = 0.25, hits = 1 })
	if not target then
		return
	end
	target:interrupt()
	target.grabbedBy = f
	target.model:SetAttribute("Grabbed", t + g.hold)
	target:sendHit(Vector3.zero, g.hold + 0.1)
	local token = f.token
	task.delay(g.hold, function()
		target.grabbedBy = nil
		if not target:alive() or not f:alive() or f.token ~= token then
			return
		end
		local angle = g.angle
		if dirY > 0.5 then
			angle = 85
		elseif dirY < -0.5 then
			angle = -30
		end
		local move = { dmg = g.dmg, bkb = g.bkb, kbs = g.kbs, angle = angle, heavy = true, kind = "melee" }
		Combat.applyHit(f, target, move, { charge = 1, mult = Passives.damageMult(f, now()), dirX = facing })
	end)
end

function Combat.tick(dt: number)
	updateProjectiles(dt)
	updateTraps(dt)
	local t = now()
	for _, f in Fighter.list do
		if f:alive() then
			if f:hasStatus("burn") then
				f.burnAcc = (f.burnAcc or 0) + dt
				if f.burnAcc >= 0.5 then
					f.burnAcc = 0
					f.damage = math.min(Config.MaxPercent, f.damage + 1)
					f:sync()
				end
			end
			if f.recoveryUsed and t - (f.lastGroundCheck or 0) > 0.1 and t - (f.recoveryT or 0) > 0.4 then
				f.lastGroundCheck = t
				if f:isGrounded() then
					f.recoveryUsed = false
				end
			end
			Passives.tick(f, dt)
		end
	end
end

function Combat.clear()
	for _, pr in Combat.projectiles do
		pr.part:Destroy()
	end
	table.clear(Combat.projectiles)
	for _, tr in Combat.traps do
		if tr.part.Parent then
			tr.part:Destroy()
		end
	end
	table.clear(Combat.traps)
	fxFolder():ClearAllChildren()
end

-- Coup d'environnement (pièges d'arène)
function Combat.environmentHit(victim, dmg: number, vel: Vector3, hitstun: number, status: string?, statusDur: number?)
	if not victim:alive() or victim:invulnerable() then
		return
	end
	victim.damage = math.min(Config.MaxPercent, victim.damage + dmg)
	if status then
		victim:addStatus(status, statusDur or 1.5)
	end
	if vel.Magnitude > 0 or hitstun > 0 then
		victim:interrupt()
		victim:sendHit(vel, hitstun)
	end
	victim:sync()
	Combat.broadcast("Fx", "hit", victim:position(), vel.Magnitude, false, "#ffffff")
end

return Combat
