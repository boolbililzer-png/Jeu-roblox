-- Coups spéciaux qui laissent quelque chose dans l'arène ou changent les règles un instant :
-- pièges au sol, murs, contres, aspiration de projectiles, grappin.
-- Le serveur décide seul de ce qui touche ; les clients dessinent les objets (évènements « Object »).
--
-- kind = "trap"    : trap = { size = Vector3, offset = n (devant), lifetime, max, visual = {…}, color, persist = bool }
--                    Pose un piège au sol ; le premier adversaire qui marche dessus prend le coup (damage, status…).
-- kind = "wall"    : wall = { size = Vector3, offset = n, lifetime, max, visual = {…} ou nil (invisible), reflect = bool }
--                    Mur qui bloque les adversaires et les projectiles (reflect = les renvoie).
-- kind = "counter" : counter = { window = s, riposte = { damage, kbBase, kbGrowth, kbAngle, status, hitText }, text }
--                    Pendant la fenêtre, le prochain coup reçu est annulé et l'attaquant prend la riposte.
-- kind = "absorb"  : absorb = { radius, offset } : pendant active, les projectiles adverses proches sont avalés
--                    (et vont dans la jauge du perso si sa mécanique est « tank »).
-- kind = "grapple" : grapple = { range, angle (degrés, 0 = devant, 90 = haut), speed, pullEnemy = bool }
--                    Lance une ventouse : accroche un adversaire (il est attiré) ou le décor (le perso y vole).
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared:WaitForChild("Config"))
local Fighters = require(script.Parent:WaitForChild("Fighters"))
local Mechanics = require(script.Parent:WaitForChild("Mechanics"))

local Specials = {}

local fxRemote = nil
local objects = {} -- id -> objet posé
local absorbers = {} -- model -> { untilTime, radius, offset }
local nextId = 500000

function Specials.setFxRemote(remote)
	fxRemote = remote
end

local function fire(kind, data)
	if fxRemote then
		fxRemote:FireAllClients(kind, data)
	end
end

local function sameTeam(a, b)
	local ta, tb = a:GetAttribute("Team"), b:GetAttribute("Team")
	return Config.TEAMS and ta ~= nil and ta ~= "" and ta == tb
end

local function arenaParams()
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Include
	params.FilterDescendantsInstances = { workspace:FindFirstChild("Arena") }
	return params
end

local function removeObject(id, burst)
	local o = objects[id]
	if not o then
		return
	end
	objects[id] = nil
	if o.part then
		o.part:Destroy()
	end
	fire("ObjectEnd", { id = id, position = o.position, burst = burst, color = o.color })
end

-- Nombre d'objets de ce type posés par ce perso ; au-delà du maximum, le plus ancien disparaît
local function enforceMax(owner, kind, max)
	local mine = {}
	for id, o in pairs(objects) do
		if o.owner == owner and o.kind == kind then
			table.insert(mine, { id = id, born = o.born })
		end
	end
	table.sort(mine, function(a, b)
		return a.born < b.born
	end)
	while #mine >= max do
		removeObject(table.remove(mine, 1).id, true)
	end
	return #mine
end

local function updateCount(owner, kind)
	local p = Mechanics.passive(owner)
	if p and ((p.kind == "traps" and kind == "trap") or (p.kind == "walls" and kind == "wall")) then
		local n = 0
		for _, o in pairs(objects) do
			if o.owner == owner and o.kind == kind then
				n += 1
			end
		end
		owner:SetAttribute("Meter", n)
	end
end

-- Point au sol devant le perso (le piège se pose sur ce qu'il y a dessous)
local function groundAhead(root, facing, offset)
	local origin = root.Position + Vector3.new(facing * offset, 1, 0)
	local hit = workspace:Raycast(origin, Vector3.new(0, -14, 0), arenaParams())
	return hit and hit.Position or (root.Position + Vector3.new(facing * offset, -3, 0))
end

function Specials.placeTrap(owner, move)
	local root = Fighters.root(owner)
	if not root then
		return
	end
	local spec = move.trap or {}
	local p = Mechanics.passive(owner)
	local max = spec.max or (p and p.kind == "traps" and p.max) or 3
	enforceMax(owner, "trap", max)
	local facing = Fighters.facing(owner)
	local ground = groundAhead(root, facing, spec.offset or 3)
	local size = spec.size or Vector3.new(3, 2, 6)
	nextId += 1
	local id = nextId
	objects[id] = {
		kind = "trap", owner = owner, move = move, born = os.clock(),
		expires = os.clock() + (spec.lifetime or 10), armedAt = os.clock() + (spec.armTime or 0.4),
		position = ground + Vector3.new(0, size.Y / 2, 0), size = size, persist = spec.persist, color = spec.color,
		multiplier = Mechanics.damageMultiplier(owner), hitCooldown = {},
	}
	fire("Object", { id = id, kind = "trap", position = ground, visual = spec.visual, color = spec.color, lifetime = spec.lifetime or 10, facing = facing })
	updateCount(owner, "trap")
end

function Specials.placeWall(owner, move)
	local root = Fighters.root(owner)
	if not root then
		return
	end
	local spec = move.wall or {}
	local p = Mechanics.passive(owner)
	local max = spec.max or (p and p.kind == "walls" and p.max) or 2
	enforceMax(owner, "wall", max)
	local facing = Fighters.facing(owner)
	local size = spec.size or Vector3.new(1.2, 8, 6)
	local ground = groundAhead(root, facing, spec.offset or 4)
	local center = spec.air and (root.Position + Vector3.new(facing * (spec.offset or 4), 0, 0)) or (ground + Vector3.new(0, size.Y / 2, 0))
	if spec.above then
		center = root.Position + Vector3.new(facing * (spec.offset or 0), spec.above, 0)
	end
	local part = Instance.new("Part")
	part.Name = "MurSpecial"
	part.Anchored = true
	part.CanCollide = spec.solid ~= false
	part.CanQuery = false
	part.CanTouch = false
	part.Transparency = 1
	part.Size = size
	part.CFrame = CFrame.new(center)
	part.Parent = workspace
	nextId += 1
	local id = nextId
	objects[id] = {
		kind = "wall", owner = owner, move = move, born = os.clock(), expires = os.clock() + (spec.lifetime or 6),
		position = center, size = size, part = part, reflect = spec.reflect, color = spec.color,
		absorbs = spec.absorbs, -- pull-bouclier de Mamie : absorbe le prochain projectile puis disparaît
		follow = spec.follow and owner or nil, followOffset = spec.follow and (center - root.Position) or nil,
	}
	fire("Object", { id = id, kind = "wall", position = center, size = size, visual = spec.visual, color = spec.color, lifetime = spec.lifetime or 6, follow = spec.follow and owner or nil, facing = facing })
	updateCount(owner, "wall")
end

function Specials.startCounter(owner, move)
	local s = Fighters.get(owner)
	if s then
		local spec = move.counter or {}
		s.counter = { untilTime = os.clock() + (spec.window or math.max(move.active, 0.3)), move = move }
	end
end

function Specials.startAbsorb(owner, move)
	local spec = move.absorb or {}
	absorbers[owner] = { untilTime = os.clock() + math.max(move.active, 0.2), radius = spec.radius or 5, offset = spec.offset or 2.5 }
end

-- Un projectile en position touche-t-il un mur ? Renvoie le mur (ou nil)
function Specials.wallAt(position, size, owner)
	for id, o in pairs(objects) do
		if o.kind == "wall" and o.owner ~= owner then
			local half = o.size / 2 + size / 2
			local d = position - o.position
			if math.abs(d.X) <= half.X and math.abs(d.Y) <= half.Y then
				if o.absorbs then
					removeObject(id, true)
				end
				return o
			end
		end
	end
	return nil
end

-- Un projectile passe-t-il dans la bouche d'un aspirateur ? Renvoie celui qui l'avale
function Specials.absorbedBy(position, owner)
	local now = os.clock()
	for model, a in pairs(absorbers) do
		if now > a.untilTime or not model.Parent then
			absorbers[model] = nil
		elseif model ~= owner and not sameTeam(model, owner) then
			local root = Fighters.root(model)
			if root then
				local mouth = root.Position + Vector3.new(Fighters.facing(model) * a.offset, 0, 0)
				if (mouth - position).Magnitude <= a.radius then
					local p = Mechanics.passive(model)
					if p and p.kind == "tank" then
						Mechanics.setMeter(model, Mechanics.meter(model) + 1)
					end
					fire("Absorbed", { model = model, position = position })
					return model
				end
			end
		end
	end
	return nil
end

function Specials.grapple(owner, move)
	local root = Fighters.root(owner)
	if not root then
		return
	end
	local spec = move.grapple or {}
	local facing = Fighters.facing(owner)
	local angle = math.rad(spec.angle or 0)
	local direction = Vector3.new(math.cos(angle) * facing, math.sin(angle), 0)
	local range = spec.range or 28
	local origin = root.Position + Vector3.new(0, 1, 0)

	-- un adversaire sur la trajectoire : il est attiré (et prend le coup)
	if spec.pullEnemy ~= false then
		for _, model in ipairs(Fighters.all()) do
			local r = Fighters.root(model)
			if model ~= owner and r and not model:GetAttribute("Eliminated") and not sameTeam(model, owner) then
				local d = r.Position - origin
				local along = d:Dot(direction)
				local side = (d - direction * along).Magnitude
				if along > 0 and along <= range and side <= 2.5 then
					fire("Grapple", { model = owner, to = r.Position, target = model })
					local pull = table.clone(move)
					pull.pull = true
					Fighters.hit(owner, model, pull, Mechanics.damageMultiplier(owner), facing)
					return
				end
			end
		end
	end
	-- sinon le décor : le perso est tiré vers le point d'accroche
	local hit = workspace:Raycast(origin, direction * range, arenaParams())
	local point = hit and hit.Position or (origin + direction * range)
	fire("Grapple", { model = owner, to = point })
	if hit then
		local toward = (point - root.Position)
		local speed = spec.speed or 85
		local velocity = toward.Unit * speed + Vector3.new(0, 12, 0)
		Fighters.nudge(owner, velocity)
	end
end

------------------------------------------------------------------------ Boucle
RunService.Heartbeat:Connect(function()
	local now = os.clock()
	for id, o in pairs(objects) do
		if now >= o.expires or not o.owner.Parent or o.owner:GetAttribute("Eliminated") then
			local owner = o.owner
			removeObject(id, false)
			if owner.Parent then
				updateCount(owner, o.kind)
			end
		elseif o.follow then
			local root = Fighters.root(o.follow)
			if root then
				o.position = root.Position + o.followOffset
				if o.part then
					o.part.CFrame = CFrame.new(o.position)
				end
			end
		elseif o.kind == "trap" and now >= o.armedAt then
			for _, model in ipairs(Fighters.all()) do
				local root = Fighters.root(model)
				if root and model ~= o.owner and not model:GetAttribute("Eliminated") and not sameTeam(model, o.owner)
					and now >= (o.hitCooldown[model] or 0) then
					local d = root.Position - o.position
					if math.abs(d.X) <= o.size.X / 2 + 1 and math.abs(d.Y) <= o.size.Y / 2 + 2.5 then
						local direction = root.AssemblyLinearVelocity.X >= 0 and 1 or -1
						if Fighters.hit(o.owner, model, o.move, o.multiplier, direction) then
							if o.persist then
								o.hitCooldown[model] = now + 1
							else
								local owner = o.owner
								removeObject(id, true)
								updateCount(owner, "trap")
								break
							end
						end
					end
				end
			end
		end
	end
end)

-- Fin de manche ou éjection du poseur : tout disparaît
function Specials.clear(owner)
	for id, o in pairs(objects) do
		if owner == nil or o.owner == owner then
			removeObject(id, false)
		end
	end
	if owner then
		absorbers[owner] = nil
		local s = Fighters.get(owner)
		if s then
			s.counter = nil
		end
	end
end

return Specials
