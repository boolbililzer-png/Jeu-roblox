-- Bibliothèque de poses pour l'animation par code (aucune animation à importer dans Roblox).
--
-- Une pose = { Joint = { rx, ry, rz, px, py, pz } } en degrés et en studs, appliquée à Motor6D.Transform.
-- Repères (rig R15, le perso regarde vers -Z) :
--   épaule / hanche rx + : le membre part vers l'avant (90 = à l'horizontale devant)
--   épaule droite rz + / gauche rz - : le bras s'écarte sur le côté
--   coude rx + : l'avant-bras se plie vers l'avant ; genou rx - : la jambe se plie vers l'arrière
--   cheville rx - : pointe du pied vers le bas
--   Waist / Neck rx - : se penche en avant ; ry + : tourne vers la gauche
--   Root : tout le corps (rx - = bascule en avant, ry + = bassin tourné à gauche, py - = s'accroupit, pz - = avance)
--
-- Pieds : FR / FL ne sont pas des articulations mais la position visée par la cheville droite / gauche
-- { poids, 0, 0, x, y, z }. Avec un poids de 1, la jambe est calculée pour que le pied reste posé à cet
-- endroit (cinématique inverse, voir AnimCore). Dans un coup, FR / FL décalent le pied : { 0, 0, 0, dx, dy, dz }.
local Poses = {}

Poses.JOINTS = {
	Root = "Root",
	Waist = "Waist",
	Neck = "Neck",
	RS = "RightShoulder",
	RE = "RightElbow",
	RW = "RightWrist",
	LS = "LeftShoulder",
	LE = "LeftElbow",
	LW = "LeftWrist",
	RH = "RightHip",
	RK = "RightKnee",
	RA = "RightAnkle",
	LH = "LeftHip",
	LK = "LeftKnee",
	LA = "LeftAnkle",
}

-- Toutes les clés d'une pose : articulations + cibles des pieds
Poses.KEYS = { "Root", "Waist", "Neck", "RS", "RE", "RW", "LS", "LE", "LW", "RH", "RK", "RA", "LH", "LK", "LA", "FR", "FL" }

local ZERO = { 0, 0, 0, 0, 0, 0 }
Poses.ZERO = ZERO

local function get(pose, key)
	return pose[key] or ZERO
end

function Poses.lerp(a, b, t)
	local out = {}
	for _, key in ipairs(Poses.KEYS) do
		local va, vb = get(a, key), get(b, key)
		local v = {}
		for i = 1, 6 do
			local x, y = va[i] or 0, vb[i] or 0
			v[i] = x + (y - x) * t
		end
		out[key] = v
	end
	return out
end

function Poses.add(a, b)
	local out = {}
	for _, key in ipairs(Poses.KEYS) do
		local va, vb = get(a, key), get(b, key)
		local v = {}
		for i = 1, 6 do
			v[i] = (va[i] or 0) + (vb[i] or 0)
		end
		out[key] = v
	end
	return out
end

-- Superpose une pose partielle sur une pose complète : les clés non précisées gardent la base
function Poses.merge(base, override)
	local out = {}
	for _, key in ipairs(Poses.KEYS) do
		out[key] = (override and override[key]) or base[key] or ZERO
	end
	return out
end

function Poses.copy(pose)
	local out = {}
	for _, key in ipairs(Poses.KEYS) do
		local v = get(pose, key)
		out[key] = { v[1] or 0, v[2] or 0, v[3] or 0, v[4] or 0, v[5] or 0, v[6] or 0 }
	end
	return out
end

function Poses.easeOut(t)
	return 1 - (1 - t) * (1 - t)
end

function Poses.easeIn(t)
	return t * t
end

function Poses.easeInOut(t)
	return t < 0.5 and 2 * t * t or 1 - (-2 * t + 2) ^ 2 / 2
end

function Poses.smooth(t)
	t = math.clamp(t, 0, 1)
	return t * t * (3 - 2 * t)
end

-- Position de repos des chevilles (garde de Gégé : pied gauche devant, pied droit derrière)
local GROUND = -2.75
Poses.GROUND_ANKLE_Y = GROUND
Poses.STANCE_R = { 0.62, GROUND, 0.38 }
Poses.STANCE_L = { -0.58, GROUND, -0.32 }

local function feet(weight)
	return {
		FR = { weight, 0, 0, Poses.STANCE_R[1], Poses.STANCE_R[2], Poses.STANCE_R[3] },
		FL = { weight, 0, 0, Poses.STANCE_L[1], Poses.STANCE_L[2], Poses.STANCE_L[3] },
	}
end

-- Garde au repos : le haut du corps. Les jambes sont calculées pour garder les pieds posés.
Poses.idle = {
	Root = { 0, 6, 0, 0, -0.18, 0 },
	Waist = { -4, 6, 0 },
	Neck = { 4, -10, 0 },
	RS = { 22, 0, 12 },
	RE = { 55, 0, 0 },
	RW = { -10, 0, 0 },
	LS = { 18, 0, -14 },
	LE = { 40, 0, 0 },
	LW = { 0, 0, 0 },
	RH = { 0, 0, 0 },
	RK = { 0, 0, 0 },
	LH = { 0, 0, 0 },
	LK = { 0, 0, 0 },
	FR = feet(1).FR,
	FL = feet(1).FL,
}

-- Montée d'un saut : genoux repliés, bras qui accompagnent (pieds libres)
Poses.jump = {
	Root = { -4, 0, 0, 0, 0.1, 0 },
	Waist = { -10, 0, 0 },
	Neck = { 8, 0, 0 },
	RS = { 70, 0, 35 },
	RE = { 70, 0, 0 },
	LS = { 80, 0, -35 },
	LE = { 60, 0, 0 },
	RH = { 55, 0, 4 },
	RK = { -95, 0, 0 },
	RA = { -15, 0, 0 },
	LH = { 25, 0, -4 },
	LK = { -55, 0, 0 },
	LA = { -20, 0, 0 },
	FR = { 0, 0, 0 },
	FL = { 0, 0, 0 },
}

-- Chute : bras écartés pour l'équilibre, jambes qui cherchent le sol
Poses.fall = {
	Root = { 4, 0, 0 },
	Waist = { 4, 0, 0 },
	Neck = { 6, 0, 0 },
	RS = { 110, 0, 55 },
	RE = { 35, 0, 0 },
	LS = { 120, 0, -55 },
	LE = { 30, 0, 0 },
	RH = { 22, 0, 6 },
	RK = { -30, 0, 0 },
	RA = { -25, 0, 0 },
	LH = { -8, 0, -6 },
	LK = { -40, 0, 0 },
	LA = { -30, 0, 0 },
	FR = { 0, 0, 0 },
	FL = { 0, 0, 0 },
}

-- Éjecté : bras et jambes en l'air, tête en arrière (le corps tourne en plus pendant l'éjection)
Poses.hit = {
	Waist = { 20, 0, 0 },
	Neck = { 30, 0, 0 },
	RS = { 120, 0, 60 },
	RE = { 20, 0, 0 },
	LS = { 120, 0, -60 },
	LE = { 20, 0, 0 },
	RH = { 30, 0, 10 },
	RK = { -30, 0, 0 },
	LH = { -20, 0, -10 },
	LK = { -40, 0, 0 },
	FR = { 0, 0, 0 },
	FL = { 0, 0, 0 },
}

-- Petit coup encaissé : la tête part en arrière, le buste plie, les pieds restent au sol
-- Éjecté par un coup moyen : plié en deux, les bras et les jambes traînent vers l'attaquant (le corps part en
-- arrière, les extrémités suivent), comme les persos de Brawlhalla
Poses.launched = {
	Root = { 12, 0, 0, 0, 0, 0 },
	Waist = { -28, 0, 0 },
	Neck = { -22, 0, 0 },
	RS = { 75, 0, 35 },
	RE = { 35, 0, 0 },
	LS = { 70, 0, -40 },
	LE = { 45, 0, 0 },
	RH = { 55, 0, 8 },
	RK = { -45, 0, 0 },
	LH = { 35, 0, -8 },
	LK = { -70, 0, 0 },
	FR = { 0, 0, 0 },
	FL = { 0, 0, 0 },
}

Poses.flinch = {
	Root = { 8, -8, 0, 0, -0.25, 0.35 },
	Waist = { 16, -10, 4 },
	Neck = { 24, 10, -6 },
	RS = { 40, 0, 45 },
	RE = { 70, 0, 0 },
	LS = { 50, 0, -50 },
	LE = { 60, 0, 0 },
}

-- Esquive : roulé en boule
Poses.dodge = {
	Root = { -15, 0, 0, 0, -0.6, 0 },
	Waist = { -25, 0, 0 },
	Neck = { -15, 0, 0 },
	RS = { 60, 0, -30 },
	RE = { 100, 0, 0 },
	LS = { 60, 0, 30 },
	LE = { 100, 0, 0 },
	RH = { 70, 0, 0 },
	RK = { -100, 0, 0 },
	LH = { 60, 0, 0 },
	LK = { -100, 0, 0 },
	FR = { 0, 0, 0 },
	FL = { 0, 0, 0 },
}

-- Esquive sur place : on se baisse et on se décale en arrière
Poses.sidestep = {
	Root = { 10, -20, 0, 0, -0.7, 0.6 },
	Waist = { -10, -15, 0 },
	Neck = { 10, 20, 0 },
	RS = { 40, 0, 30 },
	RE = { 90, 0, 0 },
	LS = { 60, 0, -30 },
	LE = { 100, 0, 0 },
}

-- Saisi par un adversaire : soulevé, bras et jambes qui pédalent dans le vide (pieds libres)
Poses.held = {
	Root = { 10, 0, 0, 0, 0.2, 0 },
	Waist = { 12, 0, 0 },
	Neck = { 20, 0, 0 },
	RS = { 150, 0, 40 },
	RE = { 30, 0, 0 },
	LS = { 150, 0, -40 },
	LE = { 30, 0, 0 },
	RH = { 30, 0, 8 },
	RK = { -60, 0, 0 },
	LH = { -10, 0, -8 },
	LK = { -40, 0, 0 },
	FR = { 0, 0, 0 },
	FL = { 0, 0, 0 },
}

-- Tient un adversaire saisi à bout de bras (pose par défaut, chaque perso peut avoir la sienne : grabHold)
Poses.grabHold = {
	Root = { -4, 0, 0, 0, -0.2, 0.05 },
	Waist = { -6, 0, 0 },
	RS = { 95, 0, -15 },
	RE = { 40, 0, 0 },
	LS = { 95, 0, 15 },
	LE = { 40, 0, 0 },
}

-- Gavé de croustillant : énorme, bras écartés par le ventre, jambes écartées, il ne peut plus bouger
Poses.obese = {
	Root = { 6, 0, 0, 0, -0.35, 0 },
	Waist = { 10, 0, 0 },
	Neck = { 14, 0, 0 },
	RS = { 25, 0, 70 },
	RE = { 25, 0, 0 },
	LS = { 25, 0, -70 },
	LE = { 25, 0, 0 },
	FR = { 1, 0, 0, 1.0, GROUND, 0.2 },
	FL = { 1, 0, 0, -1.0, GROUND, -0.1 },
}

-- Dash : penché en avant, bras qui partent en arrière
Poses.dashLean = {
	Root = { -16, 0, 0 },
	Waist = { -10, 0, 0 },
	Neck = { 14, 0, 0 },
	RS = { -40, 0, 20 },
	LS = { -45, 0, -20 },
}

-- Balancement d'ivrogne de Gégé, qui augmente avec les bulles (les pieds, eux, restent plantés)
function Poses.drunkSway(time, intensity)
	local k = 1 + intensity
	return {
		Root = { math.sin(time * 0.8) * 2 * k, math.sin(time * 0.6) * 4, math.sin(time * 1.1) * 4 * k, math.sin(time * 1.1) * 0.12 * k, 0, math.sin(time * 0.7) * 0.08 * k },
		Waist = { 0, math.sin(time * 1.3) * 4 * k, math.sin(time * 1.1 + 1) * 4 * k },
		Neck = { math.sin(time * 2.1) * 3, 0, math.sin(time * 1.9) * 7 * k },
	}
end

-- Style de chaque perso : petit mouvement permanent ajouté à la garde (et un peu en marchant).
-- Chaque fonction reçoit le temps et une intensité (0 au repos, plus en mouvement) et renvoie une pose additive.
-- Le style est choisi par le champ « style » de la fiche du perso (voir Characters/*.lua).
local sin, abs = math.sin, math.abs
Poses.styles = {
	drunk = Poses.drunkSway,
	-- Mamie : dos voûté, tête qui tremble un peu
	granny = function(t, k)
		return {
			Root = { -6, 0, 0, 0, -0.05, 0 },
			Waist = { -12 + sin(t * 1.2) * 1.5, 0, 0 },
			Neck = { 14, sin(t * 9) * 2.5 * (1 + k), sin(t * 7) * 1.5 },
		}
	end,
	-- Dylan : sautille sur place, toujours pressé
	hurry = function(t, k)
		local hop = abs(sin(t * 7)) * 0.12 * (1 + k)
		return { Root = { -4, sin(t * 3.5) * 4, 0, 0, hop, 0 }, Neck = { 0, sin(t * 1.7) * 12, 0 } }
	end,
	-- Bernard : avachi, il s'ennuie, soupire de temps en temps
	bored = function(t, k)
		local sigh = math.max(0, sin(t * 0.5)) ^ 6
		return { Root = { 4, 0, sin(t * 0.6) * 2, 0, -0.08 - sigh * 0.1, 0 }, Waist = { 6 - sigh * 6, 0, 0 }, Neck = { -6 + sigh * 12, 0, sin(t * 0.4) * 4 } }
	end,
	-- Chef Flambé : torse bombé, petit rebond fier
	proud = function(t, k)
		return { Root = { 6, 0, 0, 0, sin(t * 2.4) * 0.04, 0 }, Waist = { 8, sin(t * 1.2) * 3, 0 }, Neck = { 10, sin(t * 0.9) * 6, 0 } }
	end,
	-- Marcel : bras qui ondulent lentement comme s'il mimait le vent
	mime = function(t, k)
		local w = sin(t * 1.6)
		return { Waist = { 0, w * 4, 0 }, RS = { w * 10, 0, 6 + w * 6 }, LS = { -w * 10, 0, -6 - w * 6 }, RE = { w * 15, 0, 0 }, LE = { -w * 15, 0, 0 } }
	end,
	-- Bébé Colosse : se dandine de gauche à droite
	baby = function(t, k)
		local w = sin(t * 2.2)
		return { Root = { 0, w * 6, w * 6, w * 0.15, 0, 0 }, Neck = { 0, 0, -w * 8 } }
	end,
	-- Gloria : danse sur le métronome (100 battements par minute)
	dance = function(t, k)
		local beat = sin(t * math.pi * 2 / 0.6)
		return { Root = { 0, beat * 6, 0, 0, abs(beat) * -0.18, 0 }, Waist = { 0, -beat * 10, beat * 5 }, RS = { 0, 0, abs(beat) * 25 }, LS = { 0, 0, -abs(beat) * 25 } }
	end,
	-- Lola : déhanché de pose photo
	diva = function(t, k)
		local w = sin(t * 1.5)
		return { Root = { 0, w * 8, w * 5, w * 0.12, 0, 0 }, Waist = { 0, -w * 6, -w * 6 }, Neck = { 6, w * 10, w * 10 } }
	end,
	-- Jordan : nerveux, petits sursauts de tilt
	gamer = function(t, k)
		local twitch = (sin(t * 23) > 0.92) and 1 or 0
		return { Root = { -6, 0, 0, 0, -0.05, 0 }, Waist = { -10, twitch * 6, 0 }, Neck = { -8 + twitch * 10, 0, twitch * 6 } }
	end,
	-- Dr Fraise : droit comme un i, petits hochements de tête rassurants
	doctor = function(t, k)
		return { Root = { 2, 0, 0, 0, 0.02, 0 }, Neck = { sin(t * 2) * 5, 0, 0 } }
	end,
	-- Sumo Gélatine : la gelée tremblote
	jelly = function(t, k)
		local w = sin(t * 9) * (0.6 + k)
		return { Root = { w * 2, 0, w * 3, 0, -0.1 + w * 0.05, 0 }, Waist = { 0, 0, -w * 4 }, Neck = { 0, 0, w * 5 } }
	end,
	-- Ramsès : patraque, il frissonne et se tient le ventre
	sick = function(t, k)
		local shiver = sin(t * 30) * 1.5
		return { Root = { -8, 0, shiver, 0, -0.1, 0 }, Waist = { -10, 0, 0 }, Neck = { 12, 0, shiver * 2 }, LS = { 30, 0, 10 }, LE = { 70, 0, 0 } }
	end,
	-- Capitaine Canard : se dandine comme un canard
	duck = function(t, k)
		local w = sin(t * 4)
		return { Root = { 0, 0, w * 7, 0, abs(w) * 0.06, 0 }, Neck = { 0, 0, -w * 6 } }
	end,
	-- Gaston : torse en avant, geste théâtral de la main
	magician = function(t, k)
		local w = sin(t * 0.8)
		return { Waist = { 6, w * 6, 0 }, Neck = { 8, -w * 8, 0 }, LS = { 30 + w * 10, 0, -30 }, LE = { 40, 0, 0 } }
	end,
	-- Gros Bob : grosse respiration, épaules qui roulent
	yeti = function(t, k)
		local b = sin(t * 1.4)
		return { Root = { 4, 0, b * 3, 0, b * 0.05 - 0.1, 0 }, Waist = { 6 + b * 3, 0, 0 }, RS = { 0, 0, 10 + b * 5 }, LS = { 0, 0, -10 - b * 5 } }
	end,
	-- R-0B0 : raide, il tourne la tête par crans comme un robot
	robot = function(t, k)
		local step = math.floor(t * 1.2) % 4
		local look = ({ 0, 25, 0, -25 })[step + 1]
		return { Root = { 0, 0, 0, 0, 0.02, 0 }, Waist = { 0, 0, 0 }, Neck = { 0, look, 0 } }
	end,
	-- Papi DJ : voûté, il hoche la tête en rythme
	grandpa = function(t, k)
		return { Root = { -4, 0, 0, 0, -0.06, 0 }, Waist = { -8, 0, 0 }, Neck = { 6 + abs(sin(t * 4.5)) * 12, 0, 0 } }
	end,
	-- Roi Pigeon : la tête avance et recule comme un pigeon
	pigeon = function(t, k)
		local bob = (t * 2.5) % 1 < 0.5 and 1 or -1
		return { Waist = { 4, 0, 0 }, Neck = { bob * 10 - 4, 0, 0 } }
	end,
	-- Madame Ventouse : décontractée, elle tapote du pied
	plumber = function(t, k)
		return { Root = { 0, sin(t * 0.7) * 5, 0 }, Neck = { 0, sin(t * 0.5) * 10, 0 } }
	end,
}

return Poses
