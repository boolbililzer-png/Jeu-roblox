-- Moteur d'éjection (spécifications techniques §2 et §4).
--   Force_Finale = Base_Knockback + (Pourcentage_Degats_Cible * Knockback_Scaling)
-- La force est multipliée par le vecteur directionnel de l'attaque, puis convertie en vitesse
-- appliquée via AssemblyLinearVelocity (jamais de BodyMovers). Le hitstun dépend de la force.
local Config = require(script.Parent.Config)

local Knockback = {}

function Knockback.force(baseKb: number, scaling: number, targetPercent: number, chargeMult: number?, weight: number?): number
	local mult = chargeMult or 1
	local f = (baseKb * mult) + targetPercent * (scaling * mult)
	return f / math.max(0.5, weight or 1)
end

-- angleDeg : 0 = vers l'avant, 90 = vers le haut, <0 = vers le bas, >90 = vers l'arrière.
-- facing : +1 ou -1 (sens de l'attaquant sur l'axe X).
function Knockback.direction(angleDeg: number, facing: number): Vector3
	local a = math.rad(angleDeg)
	return Vector3.new(math.cos(a) * facing, math.sin(a), 0)
end

function Knockback.velocity(force: number, angleDeg: number, facing: number): Vector3
	return Knockback.direction(angleDeg, facing) * force * Config.KnockbackToVelocity
end

function Knockback.hitstun(force: number, isLight: boolean): number
	local h = force * Config.HitstunPerForce
	local minimum = if isLight then Config.HitstunMinLight else Config.HitstunMin
	return math.clamp(h, minimum, Config.HitstunMax)
end

function Knockback.chargeMultiplier(heldSeconds: number): number
	local k = math.clamp(heldSeconds / Config.ChargeMaxTime, 0, 1)
	return 1 + (Config.ChargeMaxMult - 1) * k
end

-- Couleur de la jauge de % (blanc -> jaune -> orange -> rouge à 150 %)
function Knockback.percentColor(p: number): Color3
	if p >= Config.CriticalPercent then
		return Color3.fromRGB(255, 45, 45)
	end
	local k = p / Config.CriticalPercent
	if k < 0.5 then
		return Color3.new(1, 1, 1):Lerp(Color3.fromRGB(255, 220, 60), k * 2)
	end
	return Color3.fromRGB(255, 220, 60):Lerp(Color3.fromRGB(255, 120, 30), (k - 0.5) * 2)
end

return Knockback
