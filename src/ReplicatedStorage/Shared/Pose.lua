-- Échantillonnage des poses procédurales (même logique que la visionneuse docs/visionneuse-3d.html).
-- Un coup suit 4 phases : AVANT (garde) -> ÉLAN (windup) -> FRAPPE (strike) -> RETOUR (garde).
local GameData = require(script.Parent.GameData)

local Pose = {}

local GARDE = GameData.States.garde
Pose.Garde = GARDE

local function easeOut(x: number): number
	return 1 - (1 - x) * (1 - x)
end

local function easeInOut(x: number): number
	if x < 0.5 then
		return 2 * x * x
	end
	return 1 - ((-2 * x + 2) ^ 2) / 2
end

local ZERO = { 0, 0, 0 }

function Pose.lerp(a, b, t: number)
	local out = {}
	for k, va in a do
		local vb = b[k] or ZERO
		out[k] = { va[1] + (vb[1] - va[1]) * t, va[2] + (vb[2] - va[2]) * t, va[3] + (vb[3] - va[3]) * t }
	end
	for k, vb in b do
		if out[k] == nil then
			out[k] = { vb[1] * t, vb[2] * t, vb[3] * t }
		end
	end
	return out
end

-- Renvoie (pose, phase) pour un coup à l'instant t (secondes depuis le début du coup).
function Pose.sampleMove(move, t: number)
	local tpl = GameData.Templates[move.anim] or GameData.Templates.jab
	local s, a, r = move.startup, move.active, move.recovery
	local n = math.max(1, math.floor(move.hits or 1))
	if t <= 0 then
		return GARDE, "avant"
	end
	if t < s then
		return Pose.lerp(GARDE, tpl.windup, easeInOut(t / s)), "elan"
	end
	if t < s + a then
		local seg = a / n
		local i = math.min(n - 1, math.floor((t - s) / seg))
		local q = ((t - s) - i * seg) / seg
		local alt = tpl.alt
		local target = if alt and i % 2 == 1 then alt else tpl.strike
		local from = tpl.windup
		if i > 0 then
			if alt then
				from = if i % 2 == 1 then tpl.strike else alt
			else
				from = Pose.lerp(tpl.strike, tpl.windup, 0.5)
			end
		end
		return Pose.lerp(from, target, easeOut(math.min(1, q * 3))), "frappe"
	end
	if t < s + a + r then
		local last = if tpl.alt and (n - 1) % 2 == 1 then tpl.alt else tpl.strike
		return Pose.lerp(last, GARDE, easeInOut((t - s - a) / r)), "retour"
	end
	return GARDE, "fin"
end

-- Pose tenue pendant la charge d'une Signature
function Pose.charge(move)
	local tpl = GameData.Templates[move.anim] or GameData.Templates.jab
	return tpl.windup
end

function Pose.state(name: string)
	return GameData.States[name] or GARDE
end

function Pose.run(phase01: number)
	local s = (math.sin(phase01 * math.pi * 2) + 1) / 2
	return Pose.lerp(GameData.States.runA, GameData.States.runB, s)
end

-- Applique une pose aux Motor6D (Transform). scale = {largeur, hauteur} du perso.
function Pose.apply(motors: { [string]: Motor6D }, pose, scaleW: number, scaleH: number)
	for name, motor in motors do
		local r = pose[name] or ZERO
		local cf = CFrame.Angles(math.rad(r[1]), math.rad(r[2]), math.rad(r[3]))
		if name == "Root" then
			local p = pose.RootPos
			if p then
				cf = CFrame.new(p[1] * scaleW, p[2] * scaleH, p[3] * scaleW) * cf
			end
		end
		motor.Transform = cf
	end
end

return Pose
