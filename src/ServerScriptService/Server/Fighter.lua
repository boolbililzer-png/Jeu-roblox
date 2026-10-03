-- État serveur d'un combattant (joueur ou bot) : % de dégâts, vies, statuts, invulnérabilités.
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared.Config)
local Fighters = require(Shared.Fighters)
local CharacterBuilder = require(Shared.CharacterBuilder)
local MotorController = require(Shared.MotorController)
local Net = require(Shared.Net)

local ToClient = Net.get("ToClient")

local Fighter = {}
Fighter.__index = Fighter
Fighter.byModel = {} :: { [Model]: any }
Fighter.list = {} :: { any }

local function now(): number
	return workspace:GetServerTimeNow()
end

local STATUS_MAX = {
	invert = true, slow = true, root = true, stun = true, blind = true, laugh = true, dog = true,
	burn = true, sneeze = true, slip = true,
}

function Fighter.new(key: string, player: Player?, botName: string?)
	local data = Fighters.get(key)
	assert(data, "combattant inconnu " .. key)
	local self = setmetatable({}, Fighter)
	self.key = key
	self.data = data
	self.player = player
	self.isBot = player == nil
	self.name = if player then player.DisplayName else (botName or ("Bot " .. data.name))
	self.stocks = Config.Stocks
	self.damage = 0
	self.armed = false
	self.busyUntil = 0
	self.hitstunUntil = 0
	self.invulnUntil = 0
	self.armorUntil = 0
	self.counter = nil
	self.statuses = {}
	self.immune = {}
	self.token = 0
	self.charging = nil
	self.recoveryUsed = false
	self.passive = {}
	self.eliminated = false
	self.dead = false
	self.traps = {}
	self.walls = {}
	self.stored = nil
	self.lastHitBy = nil
	self.stats = { kos = 0, falls = 0, dealt = 0 }
	table.insert(Fighter.list, self)
	return self
end

function Fighter:spawn(cf: CFrame)
	if self.model then
		Fighter.byModel[self.model] = nil
		self.model:Destroy()
	end
	local model = CharacterBuilder.build(self.key, cf)
	model.Name = self.name
	local hrp = model.PrimaryPart :: BasePart
	hrp.CollisionGroup = "Fighter"
	model:SetAttribute("DisplayName", self.name)
	model:SetAttribute("IsBot", self.isBot)
	model:SetAttribute("OwnerId", if self.player then self.player.UserId else 0)
	model.Parent = workspace:WaitForChild("Fighters")
	self.model = model
	self.hrp = hrp
	self.hum = model:FindFirstChildOfClass("Humanoid")
	Fighter.byModel[model] = self
	if self.player then
		self.player.Character = model
		pcall(function()
			hrp:SetNetworkOwner(self.player)
		end)
	else
		pcall(function()
			hrp:SetNetworkOwner(nil)
		end)
		local passive = self.data.passive
		self.mc = MotorController.new(model, {
			extraAirJumps = if passive == "flottaison" then 1 else 0,
			glide = passive == "flottaison",
		})
	end
	self:sync()
end

function Fighter:sync()
	local m = self.model
	if not m then
		return
	end
	m:SetAttribute("Damage", math.floor(self.damage * 10 + 0.5) / 10)
	m:SetAttribute("Stocks", self.stocks)
	m:SetAttribute("Armed", self.armed)
	CharacterBuilder.setArmed(m, self.armed)
end

function Fighter:alive(): boolean
	return self.model ~= nil and not self.dead and not self.eliminated and self.model.Parent ~= nil
end

function Fighter:position(): Vector3
	return if self.hrp then self.hrp.Position else Vector3.zero
end

function Fighter:facing(): number
	if self.mc then
		return self.mc.facing
	end
	local x = self.hrp and self.hrp.CFrame.LookVector.X or 1
	return if x < 0 then -1 else 1
end

local groundParams = RaycastParams.new()
groundParams.FilterType = Enum.RaycastFilterType.Include

function Fighter:isGrounded(): boolean
	local arena = workspace:FindFirstChild("Arena")
	if not arena or not self.hrp then
		return false
	end
	groundParams.FilterDescendantsInstances = { arena:FindFirstChild("Solid"), arena:FindFirstChild("Soft") }
	local len = self.hrp.Size.Y / 2 + (self.hum and self.hum.HipHeight or 2) + 0.8
	return workspace:Raycast(self.hrp.Position, Vector3.new(0, -len, 0), groundParams) ~= nil
end

-- Statuts loufoques : 3 s max, non cumulables, puis 5 s d'immunité au même statut
function Fighter:addStatus(name: string, dur: number): boolean
	if not STATUS_MAX[name] or not self.model then
		return false
	end
	local t = now()
	if (self.statuses[name] or 0) > t or (self.immune[name] or 0) > t then
		return false
	end
	dur = math.min(dur, Config.StatusMax)
	self.statuses[name] = t + dur
	self.immune[name] = t + dur + Config.StatusImmunity
	self.model:SetAttribute("St_" .. name, t + dur)
	return true
end

function Fighter:hasStatus(name: string): boolean
	return (self.statuses[name] or 0) > now()
end

function Fighter:clearStatuses()
	for name in self.statuses do
		if self.model then
			self.model:SetAttribute("St_" .. name, nil)
		end
	end
	table.clear(self.statuses)
end

function Fighter:invulnerable(): boolean
	return now() < self.invulnUntil
end

function Fighter:sendHit(vel: Vector3, hitstun: number)
	self.hitstunUntil = now() + hitstun
	if self.model and hitstun > 0 then
		self.model:SetAttribute("HurtUntil", now() + hitstun)
	end
	if self.player then
		ToClient:FireClient(self.player, "Hit", vel, hitstun)
	elseif self.mc then
		self.mc:applyKnockback(vel, hitstun)
	end
end

function Fighter:sendMotion(m)
	if self.player then
		ToClient:FireClient(self.player, "Motion", m)
	elseif self.mc then
		self.mc:applyMotion(m)
	end
end

function Fighter:teleport(cf: CFrame)
	if self.model then
		self.model:PivotTo(cf)
		if self.hrp then
			self.hrp.AssemblyLinearVelocity = Vector3.zero
		end
		if self.player then
			ToClient:FireClient(self.player, "Reset")
		elseif self.mc then
			self.mc:reset()
		end
	end
end

-- Annule le coup en cours (touché, éternuement…)
function Fighter:interrupt()
	self.token += 1
	self.charging = nil
	self.busyUntil = 0
	self.counter = nil
	if self.model then
		self.model:SetAttribute("Charging", nil)
	end
end

function Fighter:destroy()
	if self.model then
		Fighter.byModel[self.model] = nil
		self.model:Destroy()
		self.model = nil
	end
	for _, p in self.traps do
		if p.Parent then
			p:Destroy()
		end
	end
	for _, p in self.walls do
		if p.Parent then
			p:Destroy()
		end
	end
	local i = table.find(Fighter.list, self)
	if i then
		table.remove(Fighter.list, i)
	end
end

function Fighter.fromPart(part: Instance)
	local model = part:FindFirstAncestorOfClass("Model")
	return model and Fighter.byModel[model]
end

function Fighter.clearAll()
	for _, f in table.clone(Fighter.list) do
		f:destroy()
	end
end

return Fighter
