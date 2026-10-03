#!/usr/bin/env python3
"""Banc d'essai hors Roblox des fiches de personnages.

Assemble les modules de src/ReplicatedStorage/Shared dans un seul script Luau (avec de fausses classes
Vector2 / Vector3 / Color3 / CFrame) puis, pour chaque perso de Characters/ :
  - vérifie la fiche (coups obligatoires, champs des coups, suites d'enchaînement, statuts, fatals,
    recharge, retour, passif, costume) ;
  - joue toutes les animations dans AnimCore (chaque coup, la recharge, le retour, la saisie, l'attente)
    et vérifie qu'aucune articulation ne part en NaN ou à l'infini.

Usage : python3 tools/check_characters.py [Id ...]     (LUAU=/chemin/vers/luau si luau n'est pas dans le PATH)
"""
import os
import subprocess
import sys
import tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SHARED = os.path.join(ROOT, "src", "ReplicatedStorage", "Shared")

MOCKS = r'''
local V3mt, V2mt, C3mt, CFmt = {}, {}, {}, {}
local function v3(x, y, z) return setmetatable({ X = x or 0, Y = y or 0, Z = z or 0 }, V3mt) end
V3mt.__add = function(a, b) return v3(a.X + b.X, a.Y + b.Y, a.Z + b.Z) end
V3mt.__sub = function(a, b) return v3(a.X - b.X, a.Y - b.Y, a.Z - b.Z) end
V3mt.__mul = function(a, b)
	if type(a) == "number" then return v3(a * b.X, a * b.Y, a * b.Z) end
	if type(b) == "number" then return v3(a.X * b, a.Y * b, a.Z * b) end
	return v3(a.X * b.X, a.Y * b.Y, a.Z * b.Z)
end
V3mt.__div = function(a, b) return v3(a.X / b, a.Y / b, a.Z / b) end
V3mt.__unm = function(a) return v3(-a.X, -a.Y, -a.Z) end
V3mt.__index = function(t, k)
	if k == "Magnitude" then return math.sqrt(t.X * t.X + t.Y * t.Y + t.Z * t.Z) end
	if k == "Unit" then local m = math.sqrt(t.X * t.X + t.Y * t.Y + t.Z * t.Z); return v3(t.X / m, t.Y / m, t.Z / m) end
	return nil
end
local Vector3 = { new = v3, zero = v3(0, 0, 0), one = v3(1, 1, 1) }
local function v2(x, y) return setmetatable({ X = x or 0, Y = y or 0 }, V2mt) end
V2mt.__add = function(a, b) return v2(a.X + b.X, a.Y + b.Y) end
V2mt.__mul = function(a, b) if type(a) == "number" then return v2(a * b.X, a * b.Y) end return v2(a.X * b, a.Y * b) end
local Vector2 = { new = v2, zero = v2(0, 0) }
local function c3(r, g, b) return setmetatable({ R = r or 0, G = g or 0, B = b or 0 }, C3mt) end
C3mt.__index = { Lerp = function(a, b, t) return c3(a.R + (b.R - a.R) * t, a.G + (b.G - a.G) * t, a.B + (b.B - a.B) * t) end }
local Color3 = { new = c3, fromRGB = function(r, g, b) return c3((r or 0) / 255, (g or 0) / 255, (b or 0) / 255) end,
	fromHSV = function(h, s, v) return c3(v, v, v) end }
local CFrame = {}
CFrame.new = function(...) return setmetatable({ Position = v3(0, 0, 0) }, CFmt) end
CFrame.Angles = CFrame.new
CFrame.lookAt = CFrame.new
CFmt.__mul = function(a, b) return a end
CFmt.__add = function(a, b) return a end
CFmt.__sub = function(a, b) return a end
local Enum = setmetatable({}, { __index = function(_, k) return setmetatable({}, { __index = function(_, j) return k .. "." .. j end }) end })
local NumberSequence = { new = function(...) return { ... } end }
local ColorSequence = NumberSequence
local NumberRange = NumberSequence
local UDim2 = { new = function(...) return { ... } end, fromScale = function(...) return { ... } end, fromOffset = function(...) return { ... } end }
local Random = { new = function(seed) local s = seed or 1
	return { NextInteger = function(self, a, b) s = (s * 1103515245 + 12345) % 2147483648; return a + s % (b - a + 1) end,
		NextNumber = function(self, a, b) s = (s * 1103515245 + 12345) % 2147483648; local f = s / 2147483648; return (a or 0) + f * ((b or 1) - (a or 0)) end } end }
local function typeof(v)
	local mt = getmetatable(v)
	if mt == V3mt then return "Vector3" elseif mt == V2mt then return "Vector2" elseif mt == C3mt then return "Color3" elseif mt == CFmt then return "CFrame" end
	return type(v)
end
local function warn(...) print("WARN", ...) end
local workspace = { GetServerTimeNow = function() return 0 end }

-- Faux arbre d'instances : script.Parent:WaitForChild("X") et require(instance)
local MODULES = {}
local cache = {}
local Instance = {}
Instance.__index = Instance
local function node(name, parent, path)
	return setmetatable({ Name = name, Parent = parent, path = path, children = {} }, Instance)
end
function Instance:WaitForChild(name) return self.children[name] or error("module introuvable : " .. self.path .. "/" .. name) end
function Instance:FindFirstChild(name) return self.children[name] end
function Instance:GetChildren() local l = {} for _, c in pairs(self.children) do table.insert(l, c) end return l end
local shared = node("Shared", nil, "Shared")
local function require(inst)
	local path = inst.path
	if cache[path] == nil then
		local fn = MODULES[path]
		if not fn then error("pas de module " .. path) end
		cache[path] = fn(inst)
	end
	return cache[path]
end
-- Chaque module est compilé à part (une fiche en cours d'écriture ne casse pas les autres)
local GLOBALS = getfenv()
local ENV = { Vector3 = Vector3, Vector2 = Vector2, Color3 = Color3, CFrame = CFrame, Enum = Enum, NumberSequence = NumberSequence,
	ColorSequence = ColorSequence, NumberRange = NumberRange, UDim2 = UDim2, Random = Random, typeof = typeof, warn = warn,
	workspace = workspace, require = require }
local function loadModule(source, path, script)
	local chunk, err = loadstring(source, "=" .. path)
	if not chunk then
		error(err, 0)
	end
	setfenv(chunk, setmetatable({ script = script }, { __index = function(_, k)
		local v = ENV[k]
		if v ~= nil then return v end
		return GLOBALS[k]
	end }))
	return chunk()
end
'''

CHECKS = r'''
local Poses = require(shared.children.Poses)
local AnimCore = require(shared.children.AnimCore)
local Statuses = require(shared.children.Statuses)
local CharacterList = require(shared.children.CharacterList)
local Roster = require(shared.children.Roster)

local REQUIRED = {
	"P_neutral", "P_side", "P_down", "P_up", "P_air", "P_dash",
	"K_neutral", "K_side", "K_down", "K_up", "K_air", "K_dash",
	"S_neutral", "S_side", "S_down", "S_up", "S_hold", "S_dash", "S_dodge", "S_air",
	"SUPER", "SUPER_down", "GRAB", "THROW_fwd", "THROW_back", "THROW_up", "THROW_down",
}
local KINDS = { melee = true, projectile = true, self = true, grab = true, throw = true, item = true,
	trap = true, wall = true, counter = true, absorb = true, grapple = true }
local PASSIVES = { bulles = true, traps = true, walls = true, rating = true, forms = true, burn = true, caprice = true,
	tempo = true, likes = true, rage = true, laugh = true, bounce = true, contagion = true, float = true, tricks = true,
	fresh = true, tank = true, playlist = true, flock = true, grapple = true }
local STEPS = { text = true, wait = true, shrink = true, grow = true, spawn = true, move = true, lift = true, launch = true,
	spin = true, orbit = true, color = true, material = true, squash = true, hide = true, show = true, fx = true, fxAttacker = true }
local FX = { ring = true, burst = true, text = true, particles = true, pillar = true, puddle = true, toss = true, rain = true,
	swarm = true, symbols = true, beam = true, screen = true, shake = true }
local JOINTS = {}
for _, k in ipairs(Poses.KEYS) do JOINTS[k] = true end
local SHAPES = { ball = true, block = true, cyl = true, wedge = true }
local BODY = { Head = true, UpperTorso = true, LowerTorso = true, LeftUpperArm = true, LeftLowerArm = true, LeftHand = true,
	RightUpperArm = true, RightLowerArm = true, RightHand = true, LeftUpperLeg = true, LeftLowerLeg = true, LeftFoot = true,
	RightUpperLeg = true, RightLowerLeg = true, RightFoot = true }

local errors, warnings = 0, 0
local function err(id, msg) errors += 1; print("ERREUR  " .. id .. " : " .. msg) end
local function note(id, msg) warnings += 1; print("attention " .. id .. " : " .. msg) end

local function finite(x) return type(x) == "number" and x == x and x ~= math.huge and x ~= -math.huge end

local function checkPose(id, where, pose)
	if pose == nil then return end
	if type(pose) ~= "table" then err(id, where .. " n'est pas une table") return end
	for joint, v in pairs(pose) do
		if not JOINTS[joint] then err(id, where .. " : articulation inconnue " .. tostring(joint))
		elseif type(v) ~= "table" or (#v ~= 3 and #v ~= 6) then err(id, where .. "." .. joint .. " doit avoir 3 ou 6 nombres")
		else
			for i, x in ipairs(v) do
				if not finite(x) then err(id, where .. "." .. joint .. " valeur invalide") end
				if i <= 3 and math.abs(x) > 400 then note(id, where .. "." .. joint .. " angle " .. x .. "° très grand") end
				if i > 3 and joint ~= "FR" and joint ~= "FL" and math.abs(x) > 3 then note(id, where .. "." .. joint .. " déplacement " .. x .. " très grand") end
			end
		end
	end
end

local function checkFx(id, where, list)
	if list == nil then return end
	if type(list) ~= "table" then err(id, where .. " doit être une liste") return end
	for _, f in ipairs(list) do
		if type(f) == "table" then
			if not FX[f[1]] then err(id, where .. " : effet générique inconnu " .. tostring(f[1])) end
		elseif type(f) ~= "string" then
			err(id, where .. " : effet invalide")
		end
	end
end

local function checkPieces(id, where, pieces, needBody)
	for i, p in ipairs(pieces or {}) do
		if type(p[1]) ~= "string" then err(id, where .. "[" .. i .. "] : nom manquant") end
		if needBody and not BODY[p[2]] then err(id, where .. "[" .. i .. "] : partie du corps inconnue " .. tostring(p[2])) end
		if not SHAPES[p[3]] then err(id, where .. "[" .. i .. "] : forme inconnue " .. tostring(p[3])) end
		if typeof(p[4]) ~= "Vector3" then err(id, where .. "[" .. i .. "] : taille (Vector3) manquante") end
		if p[5] ~= nil and typeof(p[5]) ~= "Vector3" then err(id, where .. "[" .. i .. "] : position doit être un Vector3") end
		if p[6] ~= nil and typeof(p[6]) ~= "Vector3" then err(id, where .. "[" .. i .. "] : rotation doit être un Vector3") end
		if typeof(p[7]) ~= "Color3" then err(id, where .. "[" .. i .. "] : couleur (Color3) manquante") end
		if p[8] ~= nil and type(p[8]) ~= "string" then err(id, where .. "[" .. i .. "] : matière doit être un texte") end
	end
end

local function checkStatus(id, where, st)
	if st == nil then return end
	local name = st.name or st[1]
	if not Statuses.LIST[name] then err(id, where .. " : statut inconnu " .. tostring(name)) end
end

local function animate(id, label, rig, input, duration)
	local t = 0
	while t < duration do
		input.dt = 1 / 30
		local out = AnimCore.step(rig, input)
		for joint, v in pairs(out) do
			for _, x in ipairs(v) do
				if not finite(x) then err(id, label .. " : animation NaN sur " .. joint) return end
			end
		end
		t += 1 / 30
	end
end

local only = {}
for _, a in ipairs(ARGS) do only[a] = true end

for _, id in ipairs(Roster.ORDER) do
	local data = CharacterList[id]
	if (next(only) == nil or only[id]) then
		if not data then
			if next(only) ~= nil then err(id, "fiche absente") end
		else
			print("— " .. id .. " : " .. tostring(data.name))
			if data.id ~= id then err(id, "data.id doit valoir " .. id) end
			if type(data.name) ~= "string" then err(id, "name manquant") end
			if data.costume ~= id then err(id, "costume doit valoir " .. id) end
			if not Poses.styles[data.style or ""] then err(id, "style inconnu " .. tostring(data.style)) end
			if id ~= "Gege" then
				if type(data.look) ~= "table" or type(data.look.body) ~= "table" then err(id, "look.body manquant")
				else
					for _, k in ipairs({ "head", "upper", "lower", "arms", "legs", "feet" }) do
						if typeof(data.look.body[k]) ~= "Color3" then err(id, "look.body." .. k .. " (Color3) manquant") end
					end
					checkPieces(id, "look.parts", data.look.parts, true)
					for _, prop in ipairs(data.look.props or {}) do
						if type(prop.name) ~= "string" or string.sub(prop.name, 1, 4) ~= "Prop" then err(id, "look.props : name doit commencer par Prop") end
						checkPieces(id, "look.props." .. tostring(prop.name), prop.pieces, false)
					end
					if #(data.look.parts or {}) < 6 then note(id, "costume léger (" .. #(data.look.parts or {}) .. " pièces)") end
					local weapon = false
					for _, prop in ipairs(data.look.props or {}) do if prop.visible then weapon = true end end
					if not weapon then note(id, "aucun accessoire visible (l'arme sortie de la Caisse Bizarre)") end
				end
			end
			local moves = data.moves
			for _, key in ipairs(REQUIRED) do
				if not moves[key] then err(id, "coup obligatoire manquant : " .. key) end
			end
			local own = 0
			for key, m in pairs(moves) do
				if not string.find(key, ".", 1, true) and string.sub(key, 1, 5) ~= "ITEM_" then
					own += 1
					local where = key
					if type(m.label) ~= "string" then err(id, where .. " : label manquant") end
					for _, f in ipairs({ "startup", "active", "recovery" }) do
						if not finite(m[f]) or m[f] < 0 then err(id, where .. " : " .. f .. " invalide") end
					end
					local kind = m.kind or "melee"
					if not KINDS[kind] then err(id, where .. " : kind inconnu " .. tostring(kind)) end
					if not finite(m.damage) then err(id, where .. " : damage manquant") end
					if (kind == "melee" or kind == "grab" or (kind == "absorb" and m.hitbox)) and (type(m.hitbox) ~= "table" or typeof(m.hitbox.size) ~= "Vector3") then
						err(id, where .. " : hitbox manquante (box(...))")
					end
					if kind == "melee" or kind == "throw" or kind == "projectile" or kind == "trap" or kind == "grapple" then
						for _, f in ipairs({ "kbBase", "kbGrowth" }) do
							if not finite(m[f]) then err(id, where .. " : " .. f .. " manquant") end
						end
					end
					if kind == "projectile" then
						local p = m.projectile
						if type(p) ~= "table" or not finite(p.speed) or not finite(p.lifetime) then err(id, where .. " : projectile { speed, lifetime } manquant")
						elseif type(p.visual) == "table" and p.visual.parts then
							for i, part in ipairs(p.visual.parts) do
								if typeof(part[2]) ~= "Vector3" then err(id, where .. ".projectile.visual.parts[" .. i .. "] : taille Vector3 manquante") end
							end
						end
					end
					if kind == "throw" and m.carry then
						for _, c in ipairs(m.carry) do if #c ~= 3 then err(id, where .. " : carry = { temps, avant, haut }") end end
					end
					if kind == "trap" and type(m.trap) ~= "table" then note(id, where .. " : trap = { … } conseillé") end
					if kind == "wall" and type(m.wall) ~= "table" then note(id, where .. " : wall = { … } conseillé") end
					if kind == "counter" and type(m.counter) ~= "table" then note(id, where .. " : counter = { … } conseillé") end
					if kind == "grapple" and type(m.grapple) ~= "table" then note(id, where .. " : grapple = { … } conseillé") end
					if string.sub(key, 1, 5) == "SUPER" and not m.superCost then err(id, where .. " : superCost manquant") end
					if m.selfVelocity ~= nil and typeof(m.selfVelocity) ~= "Vector2" then err(id, where .. " : selfVelocity doit être un Vector2") end
					checkStatus(id, where .. ".status", m.status)
					if m.counter and m.counter.riposte then checkStatus(id, where .. ".counter.riposte.status", m.counter.riposte.status) end
					if m.selfEffect and m.selfEffect.buff and not Statuses.BUFFS[m.selfEffect.buff[1] or m.selfEffect.buff.name] then
						err(id, where .. " : buff inconnu")
					end
					for i, v in ipairs(m.variants or {}) do
						checkStatus(id, where .. ".variants[" .. i .. "].status", v.status)
					end
					checkPose(id, where .. ".windup", m.windup)
					checkPose(id, where .. ".strike", m.strike)
					checkPose(id, where .. ".follow", m.follow)
					if not m.strike then err(id, where .. " : pose strike manquante") end
					checkFx(id, where .. ".fx", m.fx)
					checkFx(id, where .. ".windupFx", m.windupFx)
					for button, target in pairs(m.links or {}) do
						if not moves[target] then err(id, where .. ".links." .. button .. " → " .. tostring(target) .. " n'existe pas") end
					end
					if m.spin and m.spin.axis ~= "x" and m.spin.axis ~= "y" then err(id, where .. " : spin.axis = \"x\" ou \"y\"") end
					if m.trail ~= nil and type(m.trail) ~= "string" then err(id, where .. " : trail doit être un texte") end
					-- animation du coup
					local rig = AnimCore.newRig(1)
					local air = string.find(key, "air", 1, true) ~= nil
					AnimCore.playMove(rig, key, m, 0.2)
					animate(id, key, rig, { grounded = not air, speed = 0, velY = 0, style = data.style, bottle = data.holdsBottle, fidgets = data.fidgets },
						0.2 + AnimCore.moveDuration(m) + 0.4)
				end
			end
			if own < 30 then note(id, "seulement " .. own .. " coups propres") end
			-- fatals
			local fatals = data.fatals or {}
			if #fatals ~= 3 then err(id, "il faut 3 fatals (il y en a " .. #fatals .. ")") end
			local seen = {}
			for i, f in ipairs(fatals) do
				if type(f.id) ~= "string" or type(f.label) ~= "string" then err(id, "fatal " .. i .. " : id / label manquants") end
				if type(f.sequence) ~= "table" or #f.sequence ~= 3 then err(id, "fatal " .. i .. " : 3 flèches") else
					for _, s in ipairs(f.sequence) do
						if s ~= "forward" and s ~= "back" and s ~= "up" and s ~= "down" then err(id, "fatal " .. i .. " : flèche " .. tostring(s)) end
					end
					local k = table.concat(f.sequence, ",")
					if seen[k] then err(id, "fatal " .. i .. " : séquence en double") end
					seen[k] = true
				end
				if not (id == "Gege" and i == 1) then
					if type(f.scene) ~= "table" or #f.scene < 3 then err(id, "fatal " .. i .. " : scene manquante")
					else
						for j, step in ipairs(f.scene) do
							if not STEPS[step[1]] then err(id, "fatal " .. i .. " étape " .. j .. " : inconnue " .. tostring(step[1])) end
							if step[1] == "spawn" then checkPieces(id, "fatal " .. i .. " spawn", step.pieces, false) end
							if (step[1] == "fx" or step[1] == "fxAttacker") then checkFx(id, "fatal " .. i .. " fx", { step[2] }) end
						end
					end
				end
			end
			-- passif
			if type(data.passive) ~= "table" or not PASSIVES[data.passive.kind] then err(id, "passive.kind manquant ou inconnu") end
			-- recharge, retour, saisie
			local c = data.charge
			if type(c) ~= "table" or not finite(c.loop) or type(c.keys) ~= "table" then err(id, "charge { loop, keys } manquant") else
				for i, k in ipairs(c.keys) do checkPose(id, "charge.keys[" .. i .. "]", k[2]) end
				for _, b in ipairs(c.beats or {}) do checkFx(id, "charge.beats", { b[2] }) end
				local rig = AnimCore.newRig(2)
				animate(id, "recharge", rig, { grounded = true, speed = 0, velY = 0, style = data.style, charging = true, charge = c }, c.loop * 2)
			end
			local r = data.respawn
			if type(r) ~= "table" or not finite(r.duration) or type(r.keys) ~= "table" then err(id, "respawn { duration, keys } manquant") else
				for i, k in ipairs(r.keys) do checkPose(id, "respawn.keys[" .. i .. "]", k[2]) end
				for _, b in ipairs(r.beats or {}) do checkFx(id, "respawn.beats", { b[2] }) end
				if type(r.platform) == "table" then checkPieces(id, "respawn.platform", r.platform.pieces, false)
					local base = false
					for _, p in ipairs(r.platform.pieces or {}) do if p[2] == "base" then base = true end end
					if not base then err(id, "respawn.platform : il faut au moins une pièce \"base\" (le sol de la plateforme)") end
				elseif type(r.platform) ~= "string" then err(id, "respawn.platform manquant") end
				local rig = AnimCore.newRig(3)
				local input = { grounded = true, speed = 0, velY = 0, style = data.style, respawn = r, respawnElapsed = 0 }
				local t = 0
				while t < r.duration do
					input.respawnElapsed = t
					animate(id, "retour", rig, input, 1 / 30)
					t += 1 / 30
				end
			end
			checkPose(id, "grabHold", data.grabHold)
			if not data.grabHold then note(id, "grabHold absent (pose de saisie par défaut)") end
			for i, f in ipairs(data.fidgets or {}) do
				for j, k in ipairs(f.keys or {}) do checkPose(id, "fidgets[" .. i .. "].keys[" .. j .. "]", k[2]) end
			end
			local rig = AnimCore.newRig(4)
			animate(id, "attente", rig, { grounded = true, speed = 0, velY = 0, style = data.style, fidgets = data.fidgets }, 20)
			animate(id, "marche", rig, { grounded = true, speed = 20, velY = 0, style = data.style }, 2)
			animate(id, "saisie", rig, { grounded = true, speed = 0, velY = 0, style = data.style, holding = true, grabHold = data.grabHold }, 1)
		end
	end
end
print(string.format("\n%d erreur(s), %d remarque(s)", errors, warnings))
if errors > 0 then error("fiches invalides") end
'''


def build(args):
    parts = [MOCKS]
    nodes = ["Shared"]
    for dirpath, _dirs, files in os.walk(SHARED):
        rel = os.path.relpath(dirpath, SHARED)
        parent = "Shared" if rel == "." else "Shared/" + rel.replace(os.sep, "/")
        if rel != ".":
            # dossier : un nœud enfant du dossier parent
            up = os.path.dirname(parent)
            name = os.path.basename(parent)
            parts.append(f'do local p = shared for seg in string.gmatch("{rel.replace(os.sep, "/")}", "[^/]+") do '
                         f'p.children[seg] = p.children[seg] or node(seg, p, p.path .. "/" .. seg); p = p.children[seg] end end')
        for f in sorted(files):
            if not f.endswith(".lua"):
                continue
            name = f[:-4]
            path = parent + "/" + name
            with open(os.path.join(dirpath, f), encoding="utf-8") as fh:
                src = fh.read()
            parts.append(f'do local p = shared for seg in string.gmatch("{parent[len("Shared"):]}", "[^/]+") do p = p.children[seg] end '
                         f'p.children["{name}"] = node("{name}", p, "{path}") end')
            level = 1
            while ("]" + "=" * level + "]") in src:
                level += 1
            eq = "=" * level
            parts.append(f'MODULES["{path}"] = function(script) return loadModule([{eq}[{src}]{eq}], "{path}", script) end')
    parts.append("local ARGS = {" + ",".join('"%s"' % a for a in args) + "}")
    parts.append(CHECKS)
    return "\n".join(parts)


def main():
    args = sys.argv[1:]
    luau = os.environ.get("LUAU", "luau")
    with tempfile.NamedTemporaryFile("w", suffix=".luau", delete=False, encoding="utf-8") as tmp:
        tmp.write(build(args))
        path = tmp.name
    result = subprocess.run([luau, path])
    os.unlink(path)
    sys.exit(result.returncode)


if __name__ == "__main__":
    main()
