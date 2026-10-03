-- Pièges d'arène : un par arène, annoncé 2 s à l'avance (icône + texte), jamais mortel seul.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared.Config)
local GameData = require(Shared.GameData)

local Fighter = require(script.Parent.Fighter)
local Combat = require(script.Parent.Combat)

local ArenaTraps = {}
local nextTrap = math.huge
local arenaKey = "bar"

local function now(): number
	return workspace:GetServerTimeNow()
end

local function alive()
	local out = {}
	for _, f in Fighter.list do
		if f:alive() then
			table.insert(out, f)
		end
	end
	return out
end

local function stageX(): number
	local st = GameData.Layout.stage
	return st.x + (math.random() - 0.5) * (st.width - 16)
end

local function marker(x: number, width: number, color: string, dur: number)
	local p = Instance.new("Part")
	p.Anchored, p.CanCollide, p.CanQuery, p.CanTouch = true, false, false, false
	p.Size = Vector3.new(width, 0.3, 12)
	p.CFrame = CFrame.new(x, GameData.Layout.stage.top + 0.2, 0)
	p.Color = Color3.fromHex(color)
	p.Material = Enum.Material.Neon
	p.Transparency = 0.5
	p.Parent = workspace:FindFirstChild("Fx") or workspace
	game:GetService("Debris"):AddItem(p, dur)
	return p
end

local function inZone(f, x: number, width: number): boolean
	local p = f:position()
	return math.abs(p.X - x) <= width / 2 + 1 and p.Y < GameData.Layout.stage.top + 8 and p.Y > GameData.Layout.stage.top - 2
end

function ArenaTraps.start(key: string)
	arenaKey = key
	nextTrap = now() + math.random(Config.TrapInterval[1], Config.TrapInterval[2])
end

function ArenaTraps.stop()
	nextTrap = math.huge
end

local function fire(trap)
	local kind = trap.kind
	if kind == "zone" then
		local x = stageX()
		local w = trap.width or 10
		marker(x, w, trap.color or "#ffffff", Config.TrapWarning)
		Combat.broadcast("Fx", "warn", trap.name, Vector3.new(x, 0, 0))
		task.delay(Config.TrapWarning, function()
			marker(x, w, trap.color or "#ffffff", 1.2).Transparency = 0.1
			Combat.broadcast("Fx", "aura", Vector3.new(x, 1, 0), w / 2, trap.color or "#ffffff")
			for _, f in alive() do
				if inZone(f, x, w) then
					local vel = if trap.launch then Vector3.new(0, trap.launch, 0) else Vector3.zero
					Combat.environmentHit(f, trap.dmg or 2, vel, if trap.launch then 0.5 else 0, trap.status, trap.dur)
				end
			end
		end)
	elseif kind == "projectile" then
		local list = alive()
		if #list == 0 then
			return
		end
		local target = list[math.random(1, #list)]
		Combat.broadcast("Fx", "warn", trap.name, target:position())
		task.delay(Config.TrapWarning, function()
			if not target:alive() then
				return
			end
			local from = Vector3.new(if math.random() < 0.5 then -60 else 60, target:position().Y + 6, 0)
			local p = Instance.new("Part")
			p.Anchored, p.CanCollide, p.CanQuery, p.CanTouch = true, false, false, false
			p.Shape = Enum.PartType.Ball
			p.Size = Vector3.new(2, 2, 2)
			p.Color = Color3.fromHex(trap.color or "#8e5a2b")
			p.Material = Enum.Material.Neon
			p.Parent = workspace:FindFirstChild("Fx") or workspace
			local pos = from
			local t0 = os.clock()
			local conn
			conn = RunService.Heartbeat:Connect(function(dt)
				if not target:alive() or os.clock() - t0 > 3 then
					conn:Disconnect()
					p:Destroy()
					return
				end
				local d = target:position() - pos
				if d.Magnitude < 2.5 then
					conn:Disconnect()
					p:Destroy()
					Combat.environmentHit(target, trap.dmg or 5, Vector3.new(math.sign(d.X) * 30, 25, 0), 0.4)
					return
				end
				pos += d.Unit * (trap.speed or 70) * dt
				p.CFrame = CFrame.new(pos)
			end)
		end)
	elseif kind == "global" then
		Combat.broadcast("Fx", "warn", trap.name, nil)
		task.delay(Config.TrapWarning, function()
			local dir = if math.random() < 0.5 then -1 else 1
			for _, f in alive() do
				local vel = Vector3.zero
				local hs = 0
				if trap.push then
					vel = Vector3.new(dir * trap.push, 12, 0)
					hs = 0.35
				elseif trap.bounce and f:isGrounded() then
					vel = Vector3.new(0, trap.bounce, 0)
					hs = 0.4
				end
				Combat.environmentHit(f, trap.dmg or 0, vel, hs, trap.status, trap.dur)
				if trap.status == "blind" then
					Combat.broadcast("Fx", "blackout", trap.dur or 1)
				end
			end
		end)
	elseif kind == "random" then
		local list = alive()
		if #list == 0 then
			return
		end
		local target = list[math.random(1, #list)]
		Combat.broadcast("Fx", "warn", trap.name .. " : " .. target.name, target:position())
		task.delay(Config.TrapWarning, function()
			Combat.environmentHit(target, trap.dmg or 2, Vector3.zero, trap.dur or 1, trap.status, trap.dur)
		end)
	elseif kind == "mover" then
		local dir = if math.random() < 0.5 then -1 else 1
		Combat.broadcast("Fx", "warn", trap.name, Vector3.new(-dir * 40, 0, 0))
		task.delay(Config.TrapWarning, function()
			local p = Instance.new("Part")
			p.Anchored, p.CanCollide, p.CanQuery, p.CanTouch = true, false, false, false
			p.Size = Vector3.new(5, 3, 4)
			p.Color = Color3.fromHex(trap.color or "#e74c3c")
			p.Parent = workspace:FindFirstChild("Fx") or workspace
			local x = -dir * 46
			local hit = {}
			local conn
			conn = RunService.Heartbeat:Connect(function(dt)
				x += dir * (trap.speed or 40) * dt
				p.CFrame = CFrame.new(x, GameData.Layout.stage.top + 1.5, 0)
				for _, f in alive() do
					if not hit[f] and inZone(f, x, 5) and f:position().Y < GameData.Layout.stage.top + 5 then
						hit[f] = true
						Combat.environmentHit(f, trap.dmg or 4, Vector3.new(dir * 20, trap.launch or 30, 0), 0.4)
					end
				end
				if math.abs(x) > 50 then
					conn:Disconnect()
					p:Destroy()
				end
			end)
		end)
	elseif kind == "conveyor" then
		local x = stageX()
		local w = trap.width or 20
		local dir = if math.random() < 0.5 then -1 else 1
		marker(x, w, trap.color or "#ff4fa3", Config.TrapWarning + (trap.dur or 3))
		Combat.broadcast("Fx", "warn", trap.name, Vector3.new(x, 0, 0))
		task.delay(Config.TrapWarning, function()
			local t0 = os.clock()
			while os.clock() - t0 < (trap.dur or 3) do
				for _, f in alive() do
					if inZone(f, x, w) and f:isGrounded() then
						f:sendMotion({ mode = "dash", vel = Vector3.new(dir * (trap.push or 18) * 2, 0, 0), dur = 0.12 })
					end
				end
				task.wait(0.25)
			end
		end)
	elseif kind == "swap" then
		local list = alive()
		if #list < 2 then
			return
		end
		Combat.broadcast("Fx", "warn", trap.name, nil)
		task.delay(Config.TrapWarning, function()
			local a = table.remove(list, math.random(1, #list))
			local b = table.remove(list, math.random(1, #list))
			if a:alive() and b:alive() then
				local pa, pb = a.model:GetPivot(), b.model:GetPivot()
				a:teleport(pb)
				b:teleport(pa)
				Combat.broadcast("Fx", "aura", pa.Position, 4, "#8e44ad")
				Combat.broadcast("Fx", "aura", pb.Position, 4, "#8e44ad")
			end
		end)
	end
end

function ArenaTraps.tick()
	if not Config.TrapsEnabled or now() < nextTrap then
		return
	end
	nextTrap = now() + math.random(Config.TrapInterval[1], Config.TrapInterval[2])
	local def = GameData.Arenas[arenaKey]
	if def and def.trap then
		fire(def.trap)
	end
end

return ArenaTraps
