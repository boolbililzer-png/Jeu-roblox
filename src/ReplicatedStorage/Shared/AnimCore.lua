-- Moteur d'animation procédurale, sans aucune API Roblox (le même code tourne dans l'aperçu 3D).
--
-- À chaque image :
--   1. couche de base : garde qui titube, marche / course (pieds qui suivent le sol), saut, salto,
--      atterrissage, esquive, coup encaissé, petites manies quand on attend (gorgée, gratter la bedaine)
--   2. couche du coup en cours : élan → frappe → prolongement → retour, avec le poids du corps
--   3. la tête reste tournée vers l'adversaire quand le buste tourne
--   4. ressorts sur toutes les articulations : le mouvement démarre et s'arrête avec de l'inertie
--   5. cinématique inverse des jambes : les pieds restent posés au sol au lieu de glisser
--   6. miroir quand le perso regarde à gauche (la bouteille reste du côté de la caméra)
local Poses = require(script.Parent:WaitForChild("Poses"))

local AnimCore = {}

local sin, cos, rad, deg = math.sin, math.cos, math.rad, math.deg
local abs, clamp, sqrt, atan2, asin, acos = math.abs, math.clamp, math.sqrt, math.atan2, math.asin, math.acos
local pi = math.pi
local KEYS = Poses.KEYS
local lerp, merge, add = Poses.lerp, Poses.merge, Poses.add
local easeOut, easeInOut, smooth = Poses.easeOut, Poses.easeInOut, Poses.smooth

-- Géométrie du rig R15 dans le repère du HumanoidRootPart (studs, avant = -Z)
AnimCore.RIG = {
	rootPivot = { 0, -1, 0 }, -- articulation Root (bassin)
	hipX = 0.5, -- écart des hanches
	thigh = 0.95, -- hanche → genou
	shin = 0.8, -- genou → cheville
	groundAnkleY = Poses.GROUND_ANKLE_Y, -- hauteur de la cheville quand le pied est au sol
}
local RIG = AnimCore.RIG

AnimCore.DODGE_DURATION = 0.3
AnimCore.WALK_SPEED = 24

------------------------------------------------------------------------ Petites maths 3D
local function mat(rx, ry, rz) -- degrés → matrice Rx * Ry * Rz (comme CFrame.Angles)
	local a, b, c = rad(rx), rad(ry), rad(rz)
	local ca, sa, cb, sb, cc, sc = cos(a), sin(a), cos(b), sin(b), cos(c), sin(c)
	return {
		cb * cc, -cb * sc, sb,
		sa * sb * cc + ca * sc, -sa * sb * sc + ca * cc, -sa * cb,
		-ca * sb * cc + sa * sc, ca * sb * sc + sa * cc, ca * cb,
	}
end

local function mul(A, B)
	local out = {}
	for r = 0, 2 do
		for c = 1, 3 do
			out[r * 3 + c] = A[r * 3 + 1] * B[c] + A[r * 3 + 2] * B[3 + c] + A[r * 3 + 3] * B[6 + c]
		end
	end
	return out
end

local function mulv(A, v)
	return {
		A[1] * v[1] + A[2] * v[2] + A[3] * v[3],
		A[4] * v[1] + A[5] * v[2] + A[6] * v[3],
		A[7] * v[1] + A[8] * v[2] + A[9] * v[3],
	}
end

local function transpose(A)
	return { A[1], A[4], A[7], A[2], A[5], A[8], A[3], A[6], A[9] }
end

local function toEuler(m) -- matrice → degrés (inverse de mat)
	local b = asin(clamp(m[3], -1, 1))
	local c = atan2(-m[2], m[1])
	local a = atan2(-m[6], m[9])
	return deg(a), deg(b), deg(c)
end

local function wrap(a)
	while a > pi do
		a -= 2 * pi
	end
	while a < -pi do
		a += 2 * pi
	end
	return a
end

AnimCore.mat, AnimCore.mul, AnimCore.mulv, AnimCore.toEuler = mat, mul, mulv, toEuler

------------------------------------------------------------------------ Jambes : cinématique inverse
-- Position de la hanche (côté 1 = droite, -1 = gauche) une fois le bassin placé
local function hipPosition(root, side)
	local R = mat(root[1], root[2], root[3])
	local h = mulv(R, { side * RIG.hipX, 0, 0 })
	return { RIG.rootPivot[1] + root[4] + h[1], RIG.rootPivot[2] + root[5] + h[2], RIG.rootPivot[3] + root[6] + h[3] }, R
end

-- Angles de hanche, genou et cheville pour que la cheville atteigne target (pied à plat + pointe)
local function legIK(root, side, target, toePitch)
	local L1, L2 = RIG.thigh, RIG.shin
	local H, Rr = hipPosition(root, side)
	local a = mulv(transpose(Rr), { target[1] - H[1], target[2] - H[2], target[3] - H[3] })
	local length = sqrt(a[1] * a[1] + a[2] * a[2] + a[3] * a[3])
	local d = clamp(length, abs(L1 - L2) + 0.01, L1 + L2 - 0.002)
	if length > 1e-4 then
		a = { a[1] * d / length, a[2] * d / length, a[3] * d / length }
	else
		a = { 0, -d, 0 }
	end
	local k = -acos(clamp((d * d - L1 * L1 - L2 * L2) / (2 * L1 * L2), -1, 1))
	local vy = -L1 - L2 * cos(k)
	local vz = -L2 * sin(k)
	local hz = asin(clamp(-a[1] / vy, -1, 1))
	local y1 = vy * cos(hz)
	local hx = wrap(atan2(a[3], a[2]) - atan2(vz, y1))
	local hip = { deg(hx), 0, deg(hz) }
	local knee = { deg(k), 0, 0 }
	-- cheville : le pied reste parallèle au sol, puis on incline la pointe
	local world = mul(mul(Rr, mat(hip[1], 0, hip[3])), mat(knee[1], 0, 0))
	local ax, ay, az = toEuler(transpose(world))
	return hip, knee, { ax + (toePitch or 0), ay, az }
end
AnimCore.legIK = legIK

------------------------------------------------------------------------ Ressorts
-- Ressort amorti implicite (stable quelle que soit la cadence d'images)
local function springStep(x, v, target, omega, zeta, dt)
	local f = 1 + 2 * dt * zeta * omega
	local oo = omega * omega
	local hoo = dt * oo
	local hhoo = dt * hoo
	local detInv = 1 / (f + hhoo)
	return (f * x + dt * v + hhoo * target) * detInv, (v + hoo * (target - x)) * detInv
end

-- Vitesse de réaction de chaque articulation : le tronc mène, les extrémités suivent avec un léger retard
local OMEGA = {
	Root = 30, Waist = 28, Neck = 16,
	RS = 30, RE = 24, RW = 18, LS = 30, LE = 24, LW = 18,
	RH = 34, RK = 30, RA = 26, LH = 34, LK = 30, LA = 26,
	FR = 26, FL = 26,
}
local ZETA = 0.68
-- Pendant un coup : le tronc est ferme, les membres claquent et dépassent un peu leur cible (effet cartoon)
local ZETA_MOVE = {
	Root = 0.8, Waist = 0.72, Neck = 0.6,
	RS = 0.58, RE = 0.5, RW = 0.45, LS = 0.58, LE = 0.5, LW = 0.45,
	RH = 0.62, RK = 0.55, RA = 0.5, LH = 0.62, LK = 0.55, LA = 0.5,
	FR = 0.8, FL = 0.8,
}
-- Raideur des ressorts selon la phase du coup : très nerveux pendant la frappe (la pose est vraiment atteinte),
-- vif au retour en garde (pas de flottement)
local PHASE_BOOST = { windup = 2.4, active = 3.2, recovery = 1.8 }

-- Mouvement en fouet (« successive breaking of joints ») : quand le corps passe d'une pose à l'autre, le bassin
-- part d'abord, puis le buste, l'épaule, le coude et enfin le poignet, qui rattrape tout le monde en claquant.
-- Valeur = part du temps de transition attendue avant que l'articulation se mette en route.
local DELAY = {
	Root = 0, Waist = 0.12, Neck = 0.32,
	RS = 0.2, RE = 0.36, RW = 0.5, LS = 0.2, LE = 0.36, LW = 0.5,
	RH = 0.06, RK = 0.18, RA = 0.3, LH = 0.06, LK = 0.18, LA = 0.3,
	FR = 0.08, FL = 0.08,
}

------------------------------------------------------------------------ Miroir
local MIRROR = { RS = "LS", RE = "LE", RW = "LW", RH = "LH", RK = "LK", RA = "LA", FR = "FL" }
for a, b in pairs(table.clone(MIRROR)) do
	MIRROR[b] = a
end

local function mirror(pose)
	local out = {}
	for _, key in ipairs(KEYS) do
		local v = pose[MIRROR[key] or key]
		out[key] = { v[1], -v[2], -v[3], -v[4], v[5], v[6] }
	end
	return out
end
AnimCore.mirror = mirror

------------------------------------------------------------------------ État d'un perso
function AnimCore.newRig(seed)
	local rig = {
		time = 0,
		seed = seed or 0,
		gaitPhase = 0,
		move = nil,
		dodgeStart = -10,
		dodgeMoving = false,
		hitStart = -10,
		hitPower = 0,
		wasGrounded = true,
		lastVelY = 0,
		landAt = -10,
		landImpact = 0,
		takeoffAt = -10,
		airJumpAt = -10,
		idleSince = 0,
		chargeStart = -10,
		wasCharging = false,
		springs = {},
		lastPose = nil,
	}
	return rig
end

function AnimCore.playMove(rig, key, move, startTime)
	-- relâchement d'une frappe chargée : le perso est déjà en élan, il ne repasse pas par la garde
	local fromHold = rig.move ~= nil and rig.move.holding == true and rig.move.key == key
	rig.move = { key = key, data = move, start = startTime, skipWindup = fromHold }
end

-- Frappe chargée : le perso reste en élan et tremble de plus en plus jusqu'au relâchement
AnimCore.SMASH_MAX_TIME = 1
function AnimCore.holdMove(rig, key, move, startTime)
	rig.move = { key = key, data = move, start = startTime, holding = true }
end

function AnimCore.playDodge(rig, startTime, moving)
	rig.dodgeStart = startTime
	rig.dodgeMoving = moving
	rig.move = nil
end

function AnimCore.playHit(rig, startTime, power)
	rig.hitStart = startTime
	rig.hitPower = power or 50
	rig.move = nil
end

------------------------------------------------------------------------ Couche de base
local function stanceFeet(pose, sway)
	pose.FR = { 1, 0, 0, Poses.STANCE_R[1], Poses.STANCE_R[2], Poses.STANCE_R[3] }
	pose.FL = { 1, 0, 0, Poses.STANCE_L[1], Poses.STANCE_L[2], Poses.STANCE_L[3] }
	return pose
end

-- Marche / course : chaque pied suit une trajectoire (posé au sol, il recule exactement à la vitesse
-- du perso, donc il ne glisse pas ; en l'air, il revient vers l'avant en se levant)
local function gait(rig, speed, dt, drunk)
	local run = clamp((speed - 9) / 12, 0, 1)
	local stepLength = clamp(0.5 + speed * 0.11, 0.6, 3)
	local duty = 0.62 + (0.36 - 0.62) * run
	rig.gaitPhase += dt * speed / (2 * stepLength)
	local phase = rig.gaitPhase
	local reach = duty * stepLength
	local lift = 0.35 + 0.55 * run

	local pose = {}
	local function foot(offset, side)
		local p = (phase + offset) % 1
		local z, y
		local toe = 0
		if p < duty then
			local s = p / duty
			z = -reach + 2 * reach * s
			y = 0
			toe = s > 0.8 and -25 * (s - 0.8) / 0.2 or 0
		else
			local s = (p - duty) / (1 - duty)
			z = reach - 2 * reach * smooth(s)
			y = sin(pi * s ^ (0.8 - 0.25 * run)) * lift
			toe = -25 * (1 - s) + 10 * s
		end
		-- Gégé zigzague : les pieds se croisent un peu
		local x = side * (0.55 - 0.18 * drunk) + sin(phase * pi * 2 + side) * 0.12 * drunk
		return { 1, toe, 0, x, RIG.groundAnkleY + y, z }
	end
	pose.FR = foot(0, 1)
	pose.FL = foot(0.5, -1)

	local swing = cos(2 * pi * phase)
	local bob = (0.07 + 0.3 * run) * (0.5 + 0.5 * cos(4 * pi * (phase - duty / 2)))
	local lean = -(5 + 15 * run)
	pose.Root = { lean, -swing * (6 + 6 * run), 0, 0, -0.12 - bob - 0.15 * run, 0 }
	pose.Waist = { -3 - 4 * run, swing * (9 + 6 * run), 0 }
	pose.Neck = { -lean * 0.6, -swing * 6, 0 }
	local armSwing = 28 + 30 * run
	pose.RS = { 15 - swing * armSwing * 0.7, 0, 10 }
	pose.RE = { 50 + 35 * run + math.max(0, swing) * 15, 0, 0 }
	pose.RW = { -10, 0, 0 }
	pose.LS = { 10 + swing * armSwing, 0, -10 }
	pose.LE = { 30 + 55 * run + math.max(0, -swing) * 25, 0, 0 }
	return pose, run
end

-- Petites manies quand Gégé attend : une gorgée à la bouteille, puis il se gratte la bedaine
local FIDGETS = {
	{
		duration = 2.4,
		keys = {
			{ 0.0, {} },
			{ 0.45, { Waist = { 6, 6, 0 }, Neck = { 18, -10, 0 }, RS = { 118, 0, -20 }, RE = { 125, 0, 0 }, RW = { -95, 0, 0 } } },
			{ 1.3, { Waist = { 12, 6, 0 }, Neck = { 32, -10, 0 }, RS = { 145, 0, -22 }, RE = { 112, 0, 0 }, RW = { -120, 0, 0 } } },
			{ 1.7, { Waist = { -2, 6, 0 }, Neck = { 0, -10, 0 }, RS = { 30, 0, 14 }, RE = { 60, 0, 0 }, LS = { 75, 0, 30 }, LE = { 120, 0, 0 } } },
			{ 2.0, { LS = { 70, 0, 5 }, LE = { 115, 0, 0 } } },
			{ 2.4, {} },
		},
	},
	{
		duration = 2.0,
		keys = {
			{ 0.0, {} },
			{ 0.35, { Neck = { 12, -10, 0 }, LS = { 25, 0, -2 }, LE = { 100, 0, 0 }, LW = { -30, 0, 0 } } },
			{ 0.55, { Neck = { 14, -10, 0 }, LS = { 30, 0, -2 }, LE = { 85, 0, 0 }, LW = { -10, 0, 0 } } },
			{ 0.75, { Neck = { 12, -10, 0 }, LS = { 25, 0, -2 }, LE = { 100, 0, 0 }, LW = { -30, 0, 0 } } },
			{ 0.95, { Neck = { 14, -10, 0 }, LS = { 30, 0, -2 }, LE = { 85, 0, 0 }, LW = { -10, 0, 0 } } },
			{ 1.15, { Neck = { 12, -10, 0 }, LS = { 25, 0, -2 }, LE = { 100, 0, 0 }, LW = { -30, 0, 0 } } },
			{ 2.0, {} },
		},
	},
}
local FIDGET_EVERY = 6.5

-- fidgets : manies propres au perso (champ fidgets de sa fiche, même format que FIDGETS) ; Gégé garde les siennes
local function fidget(rig, base, idleTime, fidgets)
	rig.wristLocked = false
	if idleTime < 3 then
		return base
	end
	local list = fidgets or FIDGETS
	local cycle = (idleTime - 3) % FIDGET_EVERY
	local index = math.floor((idleTime - 3) / FIDGET_EVERY) % #list + 1
	local f = list[index]
	if cycle > f.duration then
		return base
	end
	local keys = f.keys
	if fidgets then
		rig.wristLocked = f.lockWrist == true
	else
		rig.wristLocked = index == 1
	end
	for i = 1, #keys - 1 do
		local a, b = keys[i], keys[i + 1]
		if cycle <= b[1] then
			local t = easeInOut((cycle - a[1]) / (b[1] - a[1]))
			return lerp(merge(base, a[2]), merge(base, b[2]), t)
		end
	end
	return base
end

-- Recharge d'énergie : chaque perso a sa propre boucle (charge dans ses données) ; à défaut, il se
-- concentre poings serrés sur les hanches
local DEFAULT_CHARGE = {
	loop = 1.2,
	keys = {
		{ 0.0, { Root = { 0, 0, 0, 0, -0.35, 0 }, Waist = { -6, 0, 0 }, RS = { -10, 0, 30 }, RE = { 100, 0, 0 }, LS = { -10, 0, -30 }, LE = { 100, 0, 0 } } },
		{ 0.6, { Root = { 0, 0, 0, 0, -0.45, 0 }, Waist = { -10, 0, 0 }, RS = { -15, 0, 35 }, RE = { 110, 0, 0 }, LS = { -15, 0, -35 }, LE = { 110, 0, 0 } } },
		{ 1.2, { Root = { 0, 0, 0, 0, -0.35, 0 }, Waist = { -6, 0, 0 }, RS = { -10, 0, 30 }, RE = { 100, 0, 0 }, LS = { -10, 0, -30 }, LE = { 100, 0, 0 } } },
	},
}
AnimCore.DEFAULT_CHARGE = DEFAULT_CHARGE

-- Suite de poses clés { temps, pose partielle } jouée au temps t. Le poignet est tenu (la bouteille ne pend
-- pas) quand les poses autour de t précisent le poignet droit.
local function keyedPose(rig, base, keys, t)
	for i = 1, #keys - 1 do
		local a, b = keys[i], keys[i + 1]
		if t <= b[1] then
			local k = easeInOut(clamp((t - a[1]) / math.max(b[1] - a[1], 0.001), 0, 1))
			rig.wristLocked = (a[2].RW ~= nil) or (b[2].RW ~= nil)
			return lerp(merge(base, a[2]), merge(base, b[2]), k)
		end
	end
	return merge(base, keys[#keys][2])
end

local function chargePose(rig, base, charge, now)
	local elapsed = now - rig.chargeStart
	local pose = keyedPose(rig, base, charge.keys, elapsed % charge.loop)
	if charge.lockWrist then
		rig.wristLocked = true
	end
	-- on entre dans la boucle en douceur
	return lerp(base, pose, smooth(elapsed / 0.2))
end

-- Entrée après une chute (sur la plateforme de retour) : chaque perso a la sienne (respawn dans sa fiche)
local DEFAULT_RESPAWN = {
	duration = 1.2,
	keys = {
		{ 0.0, { Root = { 0, 0, 0, 0, -0.6, 0 }, Waist = { -10, 0, 0 }, RS = { 20, 0, 30 }, LS = { 20, 0, -30 } } },
		{ 0.6, { Root = { 0, 0, 0, 0, -0.6, 0 }, Waist = { -10, 0, 0 }, RS = { 20, 0, 30 }, LS = { 20, 0, -30 } } },
		{ 0.9, { Waist = { 10, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 170, 0, 25 }, RE = { 10, 0, 0 }, LS = { 170, 0, -25 }, LE = { 10, 0, 0 } } },
		{ 1.2, {} },
	},
}
AnimCore.DEFAULT_RESPAWN = DEFAULT_RESPAWN

local function basePose(rig, input, dt)
	local now = rig.time
	rig.wristLocked = false
	local drunk = input.drunk or 0
	local speed = abs(input.speed or 0)

	-- Coup encaissé
	if input.hitstun then
		local elapsed = now - rig.hitStart
		if rig.hitPower < 45 and input.grounded then
			-- petit coup : la tête part en arrière puis revient, les pieds restent au sol
			local t = clamp(elapsed / 0.08, 0, 1) * (1 - smooth((elapsed - 0.12) / 0.3))
			return lerp(stanceFeet(merge(Poses.idle, {})), stanceFeet(merge(Poses.idle, Poses.flinch)), t), "hit"
		end
		-- impact : il se plie autour du coup (0,08 s), puis vole
		local fold = clamp(elapsed / 0.06, 0, 1) * (1 - smooth((elapsed - 0.06) / 0.18))
		local flail = sin(now * 25) * 15
		if rig.hitPower < 115 then
			-- coup moyen : plié en deux, bras et jambes qui traînent vers l'attaquant, il ne tourne pas
			local wob = sin(now * 18) * 6
			return add(merge(Poses.idle, Poses.launched), {
				Root = { 8 * fold, 0, wob * 0.5, 0, 0, 0 },
				Waist = { -18 * fold, 0, 0 },
				RS = { flail * 0.6, 0, 0 },
				LS = { -flail * 0.6, 0, 0 },
				RH = { -wob, 0, 0 },
				LH = { wob, 0, 0 },
			}), "tumble"
		end
		-- gros coup : il tournoie (de plus en plus vite selon la force), les membres en vrac
		local spin = -elapsed * clamp(rig.hitPower * 5, 360, 1100)
		return add(merge(Poses.idle, Poses.hit), {
			Root = { spin, 0, 0 },
			Waist = { -15 * fold, 0, 0 },
			RS = { flail, 0, 0 },
			LS = { -flail, 0, 0 },
			RH = { -flail, 0, 0 },
		}), "tumble"
	end

	-- Esquive : roulade (ou on se baisse et on recule sur place)
	local dodgeElapsed = now - rig.dodgeStart
	if dodgeElapsed < AnimCore.DODGE_DURATION then
		local progress = dodgeElapsed / AnimCore.DODGE_DURATION
		local env = sin(pi * progress)
		if rig.dodgeMoving then
			local roll = -360 * easeInOut(progress)
			return add(merge(Poses.idle, Poses.dodge), { Root = { roll, 0, 0 } }), "dodge"
		end
		return lerp(stanceFeet(merge(Poses.idle, {})), stanceFeet(merge(Poses.idle, Poses.sidestep)), env), "dodge"
	end

	-- Entrée après une chute : jouée même si le perso est encore tenu en place par le serveur
	local respawnAnim = input.respawn or DEFAULT_RESPAWN
	local sinceRespawn = input.respawnElapsed
	if sinceRespawn and sinceRespawn >= 0 and sinceRespawn < (respawnAnim.duration or 1.2) then
		rig.idleSince = now
		rig.move = nil
		return keyedPose(rig, stanceFeet(merge(Poses.idle, {})), respawnAnim.keys, sinceRespawn), "respawn"
	end

	-- Saisi par un adversaire : il gigote dans le vide en attendant d'être projeté
	if input.held then
		rig.idleSince = now
		rig.move = nil
		local kick = sin(now * 22)
		return add(merge(Poses.idle, Poses.held), {
			RS = { kick * 18, 0, 0 },
			LS = { -kick * 18, 0, 0 },
			RH = { -kick * 25, 0, 0 },
			LH = { kick * 25, 0, 0 },
			Neck = { 0, sin(now * 9) * 20, 0 },
		}), "held"
	end

	-- Gavé de croustillant : il ne peut plus bouger, il gonfle et dégonfle en respirant fort
	if input.obese then
		rig.idleSince = now
		rig.move = nil
		local puff = sin(now * 6)
		return add(merge(stanceFeet(merge(Poses.idle, {})), Poses.obese), {
			Root = { 0, 0, puff * 3, 0, puff * 0.05, 0 },
			RS = { 0, 0, puff * 6 },
			LS = { 0, 0, -puff * 6 },
		}), "obese"
	end

	if input.frozen then
		rig.idleSince = now
		return stanceFeet(merge(Poses.idle, {})), "idle"
	end

	-- En l'air
	if not input.grounded then
		local vy = input.velY or 0
		local t = clamp((vy + 25) / 55, 0, 1)
		local pose = lerp(merge(Poses.idle, Poses.fall), merge(Poses.idle, Poses.jump), t)
		-- impulsion du départ : jambes tendues qui poussent
		local sinceTakeoff = now - rig.takeoffAt
		if sinceTakeoff < 0.14 then
			local k = 1 - sinceTakeoff / 0.14
			pose = add(pose, { RH = { -45 * k, 0, 0 }, RK = { 80 * k, 0, 0 }, LH = { -20 * k, 0, 0 }, LK = { 50 * k, 0, 0 }, RA = { -25 * k, 0, 0 }, LA = { -25 * k, 0, 0 } })
		end
		-- double saut : salto avant en boule
		local sinceAirJump = now - rig.airJumpAt
		if sinceAirJump < 0.42 then
			local p = sinceAirJump / 0.42
			local tuck = sin(pi * p)
			pose = lerp(pose, merge(Poses.idle, Poses.dodge), tuck * 0.9)
			pose = add(pose, { Root = { -360 * easeInOut(p), 0, 0 } })
		end
		rig.idleSince = now
		return pose, "air"
	end

	local pose, state
	local charging = input.charging == true
	if charging and not rig.wasCharging then
		rig.chargeStart = now
	end
	rig.wasCharging = charging
	if charging then
		rig.gaitPhase = 0
		rig.idleSince = now
		pose = chargePose(rig, stanceFeet(merge(Poses.idle, {})), input.charge or DEFAULT_CHARGE, now)
		state = "charge"
	elseif speed > 1.5 then
		local walk, run = gait(rig, speed, dt, drunk)
		local amount = clamp(speed / 6, 0, 1)
		pose = lerp(stanceFeet(merge(Poses.idle, {})), merge(Poses.idle, walk), amount)
		-- en partant ou en s'arrêtant, les pieds glissent vers la garde au lieu de sauter d'un coup
		rig.idleSince = now
		state = run > 0.5 and "run" or "walk"
	else
		rig.gaitPhase = 0
		pose = stanceFeet(merge(Poses.idle, {}))
		-- respiration
		local breath = sin(now * 2.2 + rig.seed)
		pose = add(pose, { Waist = { breath * 1.5, 0, 0 }, Neck = { -breath * 1, 0, 0 }, RS = { 0, 0, breath * 2 }, LS = { 0, 0, -breath * 2 }, Root = { 0, 0, 0, 0, breath * 0.03, 0 } })
		pose = fidget(rig, pose, now - rig.idleSince, input.fidgets)
		state = "idle"
	end

	-- Dash : penché en avant pendant la ruée
	if input.dashing and state ~= "charge" then
		pose = add(pose, Poses.dashLean)
		state = "dash"
	end

	-- Garde levée : accroupi derrière ses bras croisés, les pieds plantés
	if input.shielding and state ~= "charge" then
		pose = merge(pose, Poses.shield)
		state = "shield"
	end

	-- Tient un adversaire saisi (avant de le projeter)
	if input.holding then
		pose = merge(pose, input.grabHold or Poses.grabHold)
		rig.wristLocked = true
	end

	-- Gégé titube, de plus en plus avec les bulles
	-- Chaque perso a son style (Poses.styles) : Gégé titube de plus en plus avec les bulles,
	-- Mamie tremble, Gloria danse sur le temps, le Roi Pigeon hoche la tête…
	local styleFn = input.style and Poses.styles[input.style]
	if styleFn and state ~= "charge" then
		local intensity = drunk * 0.4 + (state == "idle" and 0 or 0.3)
		pose = add(pose, styleFn(now + rig.seed * 7, intensity))
	end

	-- Atterrissage : on plie les genoux pour amortir (les pieds restent au sol)
	local sinceLanding = now - rig.landAt
	if sinceLanding < 0.32 then
		local t = sinceLanding / 0.32
		local k = (t < 0.25 and t / 0.25 or 1 - smooth((t - 0.25) / 0.75)) * rig.landImpact
		pose = add(pose, { Root = { -10 * k, 0, 0, 0, -0.75 * k, 0 }, Waist = { -12 * k, 0, 0 }, Neck = { 12 * k, 0, 0 }, RS = { 25 * k, 0, 15 * k }, LS = { 25 * k, 0, -15 * k } })
	end
	return pose, state
end

------------------------------------------------------------------------ Couche du coup
-- Pose partielle d'un coup posée sur la base : FR / FL décalent les pieds, une hanche précisée libère la jambe
local function compose(base, partial)
	if not partial then
		return base
	end
	local out = merge(base, partial)
	for _, foot in ipairs({ "FR", "FL" }) do
		local offset = partial[foot]
		local b = base[foot]
		if offset then
			out[foot] = { b[1], b[2], b[3], b[4] + (offset[4] or 0), b[5] + (offset[5] or 0), b[6] + (offset[6] or 0) }
		end
	end
	if partial.RH then
		local f = out.FR
		out.FR = { 0, f[2], f[3], f[4], f[5], f[6] }
	end
	if partial.LH then
		local f = out.FL
		out.FL = { 0, f[2], f[3], f[4], f[5], f[6] }
	end
	return out
end

-- Interpolation en fouet entre deux poses : chaque articulation démarre avec son retard (DELAY × stagger)
-- et arrive à l'heure, donc les extrémités vont plus vite et claquent
local function lerpStaggered(a, b, t, ease, stagger)
	local out = {}
	for _, key in ipairs(KEYS) do
		local d = (DELAY[key] or 0) * stagger
		local tk = clamp((t - d) / (1 - d), 0, 1)
		local k = ease(tk)
		local va, vb = a[key] or Poses.ZERO, b[key] or Poses.ZERO
		local v = {}
		for i = 1, 6 do
			local x, y = va[i] or 0, vb[i] or 0
			v[i] = x + (y - x) * k
		end
		out[key] = v
	end
	return out
end

-- Anticipation et poids automatiques des coups au sol : petit recul avant (le corps se ramasse), puis il plonge
-- dans le coup à l'impact et revient en garde. S'ajoute aux poses écrites dans les fiches.
local ANTICIPATION = { Root = { 5, 0, 0, 0, -0.12, 0.16 }, Waist = { 4, 0, 0 } }
local IMPACT = { Root = { -7, 0, 0, 0, -0.14, -0.32 }, Waist = { -6, 0, 0 } }
local function scaled(p, k)
	local out = {}
	for key, v in pairs(p) do
		out[key] = { (v[1] or 0) * k, (v[2] or 0) * k, (v[3] or 0) * k, (v[4] or 0) * k, (v[5] or 0) * k, (v[6] or 0) * k }
	end
	return out
end
-- Le coup est-il un coup au sol frappé avec le corps (et pas un saut, une vrille, une recharge…) ?
local function groundedStrike(key, m)
	if not key or m.spin or (m.kind and m.kind ~= "melee") then
		return false
	end
	if string.find(key, "air", 1, true) or string.find(key, "EMOTE", 1, true) or string.find(key, "ITEM", 1, true) then
		return false
	end
	return m.selfVelocity == nil or m.selfVelocity.Y == 0
end

-- Courbe de frappe : part doucement, finit très vite (le coup « claque »)
local function easeStrike(t)
	return t * t * t
end
-- Courbe d'élan : se ramasse vite puis ralentit (anticipation)
local function easeWindup(t)
	return 1 - (1 - t) ^ 3
end

function AnimCore.moveDuration(m)
	return math.max(m.startup, 0.02) + math.max(m.active, 0.06) + (m.hold or 0) + math.max(m.recovery, 0.05)
end

local function movePose(rig, base, now)
	local m = rig.move.data
	local elapsed = now - rig.move.start
	local startup = math.max(m.startup, 0.02)
	local active = math.max(m.active, 0.06)
	local hold = m.hold or 0
	local recovery = math.max(m.recovery, 0.05)
	local windup = compose(base, m.windup)
	local strike = compose(base, m.strike)
	local follow = m.follow and compose(base, m.follow) or strike

	if rig.move.holding then
		local charge = clamp(elapsed / AnimCore.SMASH_MAX_TIME, 0, 1)
		if elapsed > AnimCore.SMASH_MAX_TIME + 1.5 then
			rig.move = nil -- relâchement jamais reçu
			return base, nil
		end
		local amp = 1 + 3 * charge
		local pose = lerp(base, windup, easeOut(clamp(elapsed / 0.25, 0, 1)))
		pose = add(pose, {
			Root = { 0, 0, sin(elapsed * 55) * 1.5 * amp, 0, -0.15 * charge, 0 },
			RS = { sin(elapsed * 70) * 2 * amp, 0, 0 },
			LS = { -sin(elapsed * 70) * 2 * amp, 0, 0 },
		})
		return pose, "windup"
	end

	local weighted = groundedStrike(rig.move.key, m)
	if elapsed < startup then
		-- élan (60 % du temps) puis départ du coup en fouet, de plus en plus vite jusqu'à l'impact
		local split = startup * 0.6
		local pose
		if elapsed < split then
			local t = elapsed / split
			pose = rig.move.skipWindup and windup or lerpStaggered(base, windup, t, easeWindup, 0.5)
			if weighted then
				pose = add(pose, scaled(ANTICIPATION, easeWindup(t)))
			end
		else
			local t = (elapsed - split) / (startup - split)
			pose = lerpStaggered(windup, strike, t, easeStrike, 0.7)
			if weighted then
				pose = add(pose, scaled(ANTICIPATION, 1 - t))
				pose = add(pose, scaled(IMPACT, easeStrike(t)))
			end
		end
		if m.shake then
			pose = add(pose, { Root = { 0, 0, sin(elapsed * 70) * 4 }, RS = { sin(elapsed * 90) * 12, 0, 0 }, RE = { sin(elapsed * 90 + 1) * 15, 0, 0 } })
		end
		return pose, "windup"
	end

	elapsed -= startup
	if elapsed < active + hold then
		-- le coup continue sur sa lancée après l'impact
		local progress = elapsed / (active + hold)
		local pose = lerpStaggered(strike, follow, progress, easeOut, 0.4)
		if weighted then
			-- le poids reste dans le coup puis se relâche
			pose = add(pose, scaled(IMPACT, 1 - 0.4 * progress))
		end
		if m.spin then
			local angle = m.spin.degrees * easeOut(progress)
			pose = add(pose, { Root = m.spin.axis == "y" and { 0, angle, 0 } or { -angle, 0, 0 } })
		end
		if m.wobble then
			pose = add(pose, { Root = { 0, sin(elapsed * 30) * 20, sin(elapsed * 30) * 12 } })
		end
		return pose, "active"
	end

	elapsed -= active + hold
	-- fin d'une vrille : le tour complet est fait, on le retire aussi des ressorts (sinon le corps
	-- « se dévisse » en sens inverse pour revenir de 360° à 0°)
	if m.spin and not rig.move.spinDone then
		rig.move.spinDone = true
		local root = rig.springs.Root
		if root then
			local turns = math.floor(math.abs(m.spin.degrees) / 360) * 360 * (m.spin.degrees >= 0 and 1 or -1)
			if m.spin.axis == "y" then
				root.x[2] -= turns
			else
				root.x[1] += turns
			end
		end
	end
	if elapsed < recovery then
		local t = elapsed / recovery
		local pose = lerpStaggered(follow, base, t, easeInOut, 0.35)
		if weighted then
			pose = add(pose, scaled(IMPACT, 0.6 * (1 - easeInOut(t))))
		end
		return pose, "recovery"
	end
	rig.move = nil
	return base, nil
end

------------------------------------------------------------------------ Image complète
-- input = { dt, grounded, speed (horizontale), velY, hitstun, frozen, style, drunk, bottle, mirror,
--           charging (recharge d'énergie en cours), charge (animation de recharge du perso),
--           respawnElapsed (temps depuis la réapparition), respawn (animation d'entrée du perso),
--           weapon (arme tenue), held (saisi par un adversaire), holding + grabHold (tient un adversaire saisi),
--           obese (gavé de croustillant), dashing, fidgets (manies du perso au repos) }
function AnimCore.step(rig, input)
	local dt = math.min(input.dt or 1 / 60, 0.1)
	rig.time += dt
	local now = rig.time

	-- Événements détectés tout seuls : décollage, double saut, atterrissage
	local vy = input.velY or 0
	if input.grounded and not rig.wasGrounded then
		rig.landAt = now
		rig.landImpact = clamp(-rig.lastVelY / 70, 0.35, 1)
	elseif not input.grounded and rig.wasGrounded and vy > 5 then
		rig.takeoffAt = now
	elseif not input.grounded and not rig.wasGrounded and vy > rig.lastVelY + 25 and vy > 20 then
		rig.airJumpAt = now
	end
	rig.wasGrounded = input.grounded
	rig.lastVelY = vy

	local base, state = basePose(rig, input, dt)
	local pose = base
	local movePhase = nil
	if rig.move and state ~= "tumble" and state ~= "hit" then
		-- on vise la pose avec un poil d'avance : les ressorts arrivent ainsi pile à l'impact
		pose, movePhase = movePose(rig, base, now + 0.03)
	elseif state == "tumble" or state == "hit" then
		rig.move = nil
	end

	-- La tête compense la rotation du buste pour garder les yeux sur l'adversaire
	local neckAuthored = rig.move and rig.move.data.strike and rig.move.data.strike.Neck
	if state ~= "tumble" and state ~= "dodge" and not neckAuthored then
		local r, w = pose.Root, pose.Waist
		pose.Neck = {
			pose.Neck[1] - (r[1] + w[1]) * 0.55,
			pose.Neck[2] - (r[2] + w[2]) * 0.7,
			pose.Neck[3] - (r[3] + w[3]) * 0.5,
			0, 0, 0,
		}
	end

	-- La bouteille, tenue par le goulot, pend vers le sol (sauf si le coup tient la bouteille autrement)
	local moveWrist = rig.move and rig.move.data.strike and rig.move.data.strike.RW
	-- (avec une arme en main, le poignet la tient : pas de bouteille qui pend)
	if input.bottle and not input.weapon and not moveWrist and not rig.wristLocked and state ~= "tumble" and state ~= "dodge" then
		local swing = pose.Root[1] + pose.Waist[1] + pose.RS[1] + pose.RE[1]
		pose.RW = { -swing * 0.9 + 6, pose.RW[2], pose.RW[3], 0, 0, 0 }
	end

	-- Ressorts : inertie et léger dépassement en fin de mouvement
	local boost = movePhase and PHASE_BOOST[movePhase] or 1
	if state == "tumble" or state == "dodge" or state == "air" and now - rig.airJumpAt < 0.42 then
		boost = 2.2
	end
	local springs = rig.springs
	local out = {}
	for _, key in ipairs(KEYS) do
		local target = pose[key] or Poses.ZERO
		local s = springs[key]
		if not s then
			s = { x = {}, v = {} }
			for i = 1, 6 do
				s.x[i] = target[i] or 0
				s.v[i] = 0
			end
			springs[key] = s
		end
		local omega = OMEGA[key] * boost
		local zeta = movePhase and (ZETA_MOVE[key] or ZETA) or ZETA
		local v = {}
		for i = 1, 6 do
			s.x[i], s.v[i] = springStep(s.x[i], s.v[i], target[i] or 0, omega, zeta, dt)
			v[i] = s.x[i]
		end
		out[key] = v
	end

	-- Pieds posés : on recalcule hanche, genou et cheville pour atteindre la cible
	for _, leg in ipairs({ { "FR", "RH", "RK", "RA", 1 }, { "FL", "LH", "LK", "LA", -1 } }) do
		local foot = out[leg[1]]
		local weight = clamp(foot[1], 0, 1)
		if weight > 0.01 then
			local hip, knee, ankle = legIK(out.Root, leg[5], { foot[4], foot[5], foot[6] }, foot[2])
			local h, k, a = out[leg[2]], out[leg[3]], out[leg[4]]
			for i = 1, 3 do
				h[i] += (hip[i] - h[i]) * weight
				k[i] += (knee[i] - k[i]) * weight
				a[i] += (ankle[i] - a[i]) * weight
			end
		end
	end

	if input.mirror then
		out = mirror(out)
	end
	rig.lastPose = out
	rig.state = state
	return out, state
end

return AnimCore
