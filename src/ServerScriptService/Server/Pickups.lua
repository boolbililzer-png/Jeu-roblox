-- Objets à ramasser (voir shared/Items.lua pour la liste) : apparition sur l'arène, ramassage, objet en main,
-- lancer, usure des armes, bombe, croustillant et peau de banane.
-- Le serveur décide seul de ce qui touche ; les clients dessinent les objets lancés (évènement « Projectile »).
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared:WaitForChild("Config"))
local Items = require(Shared:WaitForChild("Items"))
local Fighters = require(script.Parent:WaitForChild("Fighters"))

local Pickups = {}

local fxRemote = nil
local knockOut = nil -- function(model, creditTo), fournie par Match
local enabled = true
local rng = Random.new()
local folder -- objets posés
local onGround = {} -- modèle posé -> { id, point, expires }
local traps = {} -- peaux de banane au sol : { model, position, owner, safeUntil, expires }
local nextId = 100000 -- identifiants des objets lancés (les coups utilisent des petits nombres)

-- Coups « virtuels » des objets (même format que les coups des persos)
local BOMB_DIRECT = { damage = 20, kbBase = 260, kbGrowth = 0, kbAngle = 55, hitText = "KABOUM !" }
local BOMB_SPLASH = { damage = 18, kbBase = 60, kbGrowth = 95, kbAngle = 60, hitText = "BOUM !" }
local CROUSTY_HIT = { damage = 5, kbBase = 0, kbGrowth = 0, kbAngle = 0, hitText = "MIAM !" }
local THROWN_WEAPON = { damage = 9, kbBase = 35, kbGrowth = 55, kbAngle = 40, hitText = "BLONG !" }
local BANANA_SLIP = { damage = 6, kbBase = 45, kbGrowth = 25, kbAngle = 82, hitText = "GLISSS !" }

local function serverNow()
	return workspace:GetServerTimeNow()
end

local function fire(kind, data)
	if fxRemote then
		fxRemote:FireAllClients(kind, data)
	end
end

local function arenaParams()
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Include
	params.FilterDescendantsInstances = { workspace:FindFirstChild("Arena") }
	return params
end

local function anchorAll(model, anchored)
	for _, p in ipairs(model:GetDescendants()) do
		if p:IsA("BasePart") then
			p.Anchored = anchored
		end
	end
end

------------------------------------------------------------------------ Objet en main
function Pickups.heldId(model)
	local id = model:GetAttribute("Held") or ""
	return id ~= "" and id or nil
end

-- Lâche (fait disparaître) l'objet tenu
function Pickups.clear(model)
	local props = model:FindFirstChild("Tenu")
	if props then
		props:Destroy()
	end
	if model:GetAttribute("Held") ~= "" then
		model:SetAttribute("Held", "")
	end
	model:SetAttribute("HeldUses", -1)
end

-- Soude une copie de l'objet dans une main. hidden = exemplaire de l'autre main (affiché en miroir)
local function attachProp(parent, id, hand, name, hidden)
	local prop = Items.build(id)
	prop.Name = name
	prop:PivotTo(hand.CFrame * CFrame.new(0, -0.15, 0))
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = hand
	weld.Part1 = prop.PrimaryPart
	weld.Parent = prop.PrimaryPart
	for _, p in ipairs(prop:GetDescendants()) do
		if p:IsA("BasePart") then
			p:SetAttribute("BaseTransparency", p.Transparency)
			if hidden then
				p.Transparency = 1
			end
		end
	end
	prop.Parent = parent
	return prop
end

-- Caisse Bizarre ouverte : le perso sort son arme (ses accessoires « AlwaysShown » apparaissent côté client)
function Pickups.arm(model)
	model:SetAttribute("Armed", true)
	model:SetAttribute("ArmedSince", serverNow())
	local root = Fighters.root(model)
	fire("CrateOpened", { model = model, position = root and root.Position })
end

-- Éjection (ou fin de manche) : retour aux mains nues
function Pickups.disarm(model)
	if model:GetAttribute("Armed") then
		model:SetAttribute("Armed", false)
	end
end

function Pickups.give(model, id)
	local info = Items.LIST[id]
	if not info then
		return
	end
	if info.kind == "crate" then
		Pickups.arm(model)
		return
	end
	Pickups.clear(model)
	local right, left = model:FindFirstChild("RightHand"), model:FindFirstChild("LeftHand")
	local props = Instance.new("Folder")
	props.Name = "Tenu"
	if right and left then
		-- comme la bouteille : un exemplaire par main, le client montre celui côté caméra
		attachProp(props, id, right, "Prop", false)
		attachProp(props, id, left, "Prop_M", true)
	end
	props.Parent = model
	model:SetAttribute("HeldUses", info.uses or -1)
	model:SetAttribute("HeldSince", serverNow())
	model:SetAttribute("Held", id)
	fire("ItemTaken", { model = model, id = id })
end

-- Une touche (ou un tir) avec l'arme : elle s'use, et se casse à 0
function Pickups.consumeUse(model)
	local uses = model:GetAttribute("HeldUses") or -1
	if uses < 0 then
		return
	end
	uses -= 1
	model:SetAttribute("HeldUses", uses)
	if uses <= 0 then
		local root = Fighters.root(model)
		fire("ItemBroken", { model = model, id = model:GetAttribute("Held"), position = root and root.Position })
		Pickups.clear(model)
	end
end

------------------------------------------------------------------------ Objets au sol
local function freePoint()
	local points = table.clone(Config.ITEM_POINTS)
	for _ = 1, #points do
		local i = rng:NextInteger(1, #points)
		local point = points[i]
		local busy = false
		for _, entry in pairs(onGround) do
			if (entry.point - point).Magnitude < 4 then
				busy = true
			end
		end
		if not busy then
			return point
		end
		table.remove(points, i)
		if #points == 0 then
			break
		end
	end
	return nil
end

local function countGround()
	local n = 0
	for _ in pairs(onGround) do
		n += 1
	end
	return n
end

function Pickups.spawnItem(id, point)
	local info = Items.LIST[id]
	if not info or not point then
		return
	end
	local model = Items.build(id)
	model.Name = "Objet_" .. id
	model:SetAttribute("ItemId", id)
	anchorAll(model, true)
	-- halo et petit panneau pour le repérer de loin
	local grip = model.PrimaryPart
	local light = Instance.new("PointLight")
	light.Color = info.color
	light.Range = 10
	light.Brightness = 2
	light.Parent = grip
	local gui = Instance.new("BillboardGui")
	gui.Size = UDim2.fromOffset(46, 46)
	gui.StudsOffset = Vector3.new(0, 2.6, 0)
	gui.AlwaysOnTop = true
	gui.LightInfluence = 0
	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.TextScaled = true
	label.Text = info.icon
	label.Parent = gui
	gui.Parent = grip
	local top = point + Vector3.new(0, 1.3, 0)
	model:PivotTo(CFrame.new(top + Vector3.new(0, 30, 0)))
	model.Parent = folder
	onGround[model] = { id = id, point = point, expires = os.clock() + Config.ITEM_LIFETIME, born = os.clock(), top = top }
	fire("ItemSpawn", { position = top, id = id })
	return model
end

-- Ramassage : l'objet posé le plus proche à portée
function Pickups.tryPickup(model)
	local root = Fighters.root(model)
	if not root then
		return false
	end
	local best, bestDistance = nil, Config.PICKUP_RANGE
	local armed = model:GetAttribute("Armed") == true
	for item, entry in pairs(onGround) do
		-- encore en train de tomber ; une caisse ne sert à rien si on a déjà son arme
		if os.clock() - entry.born > 0.8 and not (armed and entry.id == "crate") then
			local distance = (item:GetPivot().Position - root.Position).Magnitude
			if distance <= bestDistance then
				best, bestDistance = item, distance
			end
		end
	end
	if not best then
		return false
	end
	local id = onGround[best].id
	onGround[best] = nil
	best:Destroy()
	Pickups.give(model, id)
	return true
end

-- Liste des objets posés (pour le client : il voit les modèles dans workspace.Objets)
function Pickups.folder()
	return folder
end

------------------------------------------------------------------------ Bombe
-- Touché direct (ou explosion en main) : éjecté d'office, comme un coup fatal
local function blastTarget(target, attacker, position)
	if Fighters.isObese(target) then
		-- gavé, personne ne peut l'éjecter : il prend juste les dégâts
		Fighters.hit(attacker, target, BOMB_SPLASH, 1, 1)
		return
	end
	local root = Fighters.root(target)
	local direction = (root and position and root.Position.X < position.X) and -1 or 1
	Fighters.hit(attacker, target, BOMB_DIRECT, 1, direction)
	task.delay(0.55, function()
		if knockOut and Fighters.get(target) and not target:GetAttribute("Away") and not target:GetAttribute("Eliminated") then
			local r = Fighters.root(target)
			if r and not r.Anchored then
				knockOut(target, attacker)
			end
		end
	end)
end

local function explode(position, attacker, direct)
	fire("Explosion", { position = position, radius = Config.BOMB_RADIUS })
	for _, model in ipairs(Fighters.all()) do
		local root = Fighters.root(model)
		if root and model ~= direct and not model:GetAttribute("Eliminated") then
			local offset = root.Position - position
			if offset.Magnitude <= Config.BOMB_RADIUS then
				Fighters.hit(attacker, model, BOMB_SPLASH, 1, offset.X >= 0 and 1 or -1)
			end
		end
	end
end

------------------------------------------------------------------------ Objets lancés
local function landBanana(position, owner)
	local model = Items.build("banana")
	model.Name = "PeauDeBanane"
	anchorAll(model, true)
	model:PivotTo(CFrame.new(position + Vector3.new(0, 0.45, 0)))
	model.Parent = folder
	table.insert(traps, { model = model, position = position, owner = owner, safeUntil = os.clock() + 0.6, expires = os.clock() + Config.BANANA_TIME })
end

-- Quelqu'un est touché par l'objet lancé
local function onThrownHit(id, thrower, target, direction, position)
	if id == "bomb" then
		blastTarget(target, thrower, position)
		explode(position, thrower, target)
	elseif id == "crousty" then
		Fighters.hit(thrower, target, CROUSTY_HIT, 1, direction)
		Fighters.makeObese(target)
		fire("Obese", { model = target })
	elseif id == "banana" then
		Fighters.hit(thrower, target, BANANA_SLIP, 1, direction)
	elseif id == "crate" then
		-- arme jetée : elle assomme celui qu'elle touche, puis retombe en caisse
		Fighters.hit(thrower, target, THROWN_WEAPON, 1, direction)
		task.delay(0.3, Pickups.spawnItem, "crate", position)
	end
end

-- L'objet lancé touche le sol (ou finit sa course) sans toucher personne
local function onThrownLand(id, thrower, position, landed)
	if id == "bomb" then
		explode(position, thrower, nil)
	elseif id == "banana" and landed then
		landBanana(position, thrower)
	elseif id == "crousty" then
		fire("Splat", { position = position, id = id })
	elseif id == "crate" then
		-- l'arme jetée retombe en Caisse Bizarre : n'importe qui peut la reprendre
		Pickups.spawnItem("crate", position)
	end
end

-- Jeter son arme (✋ avec la caisse ouverte, même en se faisant frapper) : elle part en projectile, le perso
-- repasse à mains nues. En plein combo adverse, ça le casse (court instant d'invulnérabilité).
function Pickups.throwWeapon(model, direction)
	if model:GetAttribute("Armed") ~= true or Pickups.heldId(model) then
		return false
	end
	Pickups.disarm(model)
	model:SetAttribute("Held", "crate") -- le temps du lancer : l'objet lancé est la caisse
	return Pickups.throw(model, direction)
end

function Pickups.throw(model, direction)
	local id = Pickups.heldId(model)
	local root = Fighters.root(model)
	if not id or not root then
		return false
	end
	Pickups.clear(model)
	local facing = Fighters.facing(model)
	local spec = Items.THROWS[direction] or Items.THROWS.fwd
	if id == "banana" and direction == "fwd" then
		spec = Items.THROWS.lob
	end
	local angle = math.rad(spec.angle)
	local velocity = Vector3.new(math.cos(angle) * spec.speed * facing, math.sin(angle) * spec.speed, 0)
	local position = root.Position + Vector3.new(1.8 * facing, 1.5, 0)
	local gravity = Items.GRAVITY
	local lifetime = 2.5

	nextId += 1
	local projectileId = nextId
	fire("Projectile", { id = projectileId, origin = position, velocity = velocity, gravity = gravity, lifetime = lifetime, visual = "item:" .. id })

	local size = Vector3.new(2.2, 2.2, 6)
	local params = OverlapParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = { model }
	local rayParams = arenaParams()
	local elapsed = 0
	local connection
	connection = RunService.Heartbeat:Connect(function(dt)
		elapsed += dt
		local previous = position
		velocity += Vector3.new(0, -gravity * dt, 0)
		position += velocity * dt
		local function finish(touched, landed)
			connection:Disconnect()
			fire("ProjectileEnd", { id = projectileId, position = position, touched = touched })
			if not touched then
				onThrownLand(id, model, position, landed)
			end
		end
		-- un adversaire sur la trajectoire (celui qui lance ne peut pas se toucher au départ)
		for _, part in ipairs(workspace:GetPartBoundsInBox(CFrame.new(position), size, params)) do
			local target = part:FindFirstAncestorOfClass("Model")
			while target and not CollectionService:HasTag(target, Fighters.TAG) do
				target = target:FindFirstAncestorOfClass("Model")
			end
			if target and target ~= model and Fighters.get(target) and not target:GetAttribute("Eliminated") and not Fighters.isInvulnerable(target) then
				onThrownHit(id, model, target, velocity.X >= 0 and 1 or -1, position)
				finish(true, false)
				return
			end
		end
		-- le sol ou une plateforme (en descendant seulement : on passe à travers les plateformes fines en montant)
		local move = position - previous
		local hit = workspace:Raycast(previous, move, rayParams)
		if hit and (velocity.Y < 0 or not hit.Instance:HasTag("Traversable")) then
			position = hit.Position
			finish(false, true)
			return
		end
		if elapsed >= lifetime then
			finish(false, false)
		end
	end)
	return true
end

------------------------------------------------------------------------ Démarrage
function Pickups.start(remote, knockOutFunction)
	fxRemote = remote
	knockOut = knockOutFunction
	folder = Instance.new("Folder")
	folder.Name = "Objets"
	folder.Parent = workspace

	-- apparitions régulières
	task.spawn(function()
		task.wait(Config.ITEM_FIRST_DELAY)
		while true do
			if Config.ITEMS and enabled and countGround() < Config.ITEMS_MAX then
				Pickups.spawnItem(Items.random(rng), freePoint())
			end
			task.wait(rng:NextNumber(Config.ITEM_INTERVAL_MIN, Config.ITEM_INTERVAL_MAX))
		end
	end)

	RunService.Heartbeat:Connect(function()
		local now = os.clock()
		-- objets posés : descente, rotation, disparition (en clignotant)
		for item, entry in pairs(onGround) do
			local age = now - entry.born
			if now >= entry.expires or not item.Parent then
				onGround[item] = nil
				item:Destroy()
			else
				local fall = math.clamp(age / 0.8, 0, 1)
				local y = entry.top.Y + 30 * (1 - fall) ^ 2 + math.sin(now * 3) * 0.25
				item:PivotTo(CFrame.new(entry.top.X, y, 0) * CFrame.Angles(0, now * 2, 0))
				if entry.expires - now < 3 then
					local visible = math.floor(now * 8) % 2 == 0
					for _, p in ipairs(item:GetDescendants()) do
						if p:IsA("BasePart") and p.Name ~= "Prise" then
							p.Transparency = visible and 0 or 0.7
						end
					end
				end
			end
		end

		-- bombe gardée trop longtemps : elle explose en main
		local serverTime = serverNow()
		for _, model in ipairs(Fighters.all()) do
			if model:GetAttribute("Held") == "bomb" and serverTime - (model:GetAttribute("HeldSince") or serverTime) >= Config.BOMB_FUSE then
				local root = Fighters.root(model)
				Pickups.clear(model)
				if root then
					blastTarget(model, Fighters.get(model).lastHitBy, root.Position)
					explode(root.Position, nil, model)
				end
			end
		end

		-- peaux de banane : celui qui marche dessus glisse
		for i = #traps, 1, -1 do
			local trap = traps[i]
			local triggered = false
			if now < trap.expires then
				for _, model in ipairs(Fighters.all()) do
					local root = Fighters.root(model)
					if root and not root.Anchored and not (model == trap.owner and now < trap.safeUntil) and not model:GetAttribute("Eliminated") then
						local feet = root.Position.Y - 3
						if math.abs(root.Position.X - trap.position.X) < 1.8 and feet > trap.position.Y - 1.5 and feet < trap.position.Y + 1.5 then
							Fighters.hit(trap.owner, model, BANANA_SLIP, 1, root.AssemblyLinearVelocity.X >= 0 and 1 or -1)
							triggered = true
							break
						end
					end
				end
			end
			if triggered or now >= trap.expires then
				trap.model:Destroy()
				table.remove(traps, i)
			end
		end
	end)
end

-- Fin de manche : on vide l'arène et on coupe les apparitions le temps de l'annonce
function Pickups.reset(active)
	enabled = active
	for item in pairs(onGround) do
		item:Destroy()
	end
	table.clear(onGround)
	for _, trap in ipairs(traps) do
		trap.model:Destroy()
	end
	table.clear(traps)
end

return Pickups
