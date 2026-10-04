-- Marcel le Mime : visage blanc, marinière et béret, il ne dit jamais un mot (ses bulles sont vides) mais tout ce
-- qu'il mime devient vrai : murs, cordes, parapluies, pianos. Arme sortie de la Caisse Bizarre : ses accessoires
-- invisibles (une canne presque transparente et ses manchettes de mime ; ses gants blancs font partie du costume).
--
-- Format : voir docs/fiche-perso.md et l'en-tête de Characters/Gege.lua.
-- Mécanique « Murs invisibles » : S pose un mur invisible (kind = "wall", 2 au plus) qui bloque projectiles et
-- adversaires. Les accessoires ponctuels (corde, parapluie, ballon) sont presque transparents : on les devine.
-- Ses textes sont muets : « … » et onomatopées entre parenthèses, comme un film muet.

local function box(width, height, forward, up)
	return { size = Vector3.new(width, height, 6), offset = Vector2.new(forward, up) }
end

local FACE = Color3.fromRGB(248, 248, 250)
local WHITE = Color3.fromRGB(245, 245, 248)
local NAVY = Color3.fromRGB(30, 45, 95)
local BLACK = Color3.fromRGB(22, 22, 26)
local RED = Color3.fromRGB(205, 35, 45)
local PINK = Color3.fromRGB(240, 150, 170)
local GHOST = Color3.fromRGB(225, 238, 255) -- les objets invisibles : un reflet bleuté
local ROPE = Color3.fromRGB(235, 225, 200)
local BANANA = Color3.fromRGB(250, 225, 80)
local WIND = Color3.fromRGB(220, 230, 240)

local CUIR = Color3.fromRGB(120, 80, 50) -- coins de la valise (arme n° 2)
local SKY = Color3.fromRGB(150, 200, 255) -- ballon bleu (arme n° 3)

local data = {
	id = "Marcel",
	name = "Marcel le Mime",
	costume = "Marcel",
	style = "mime",

	------------------------------------------------------------------ Les 3 armes de la Caisse Bizarre (une au hasard)
	-- n° 1 : la canne invisible (ses coups sont ceux de moves). n° 2 : la valise invisible, lourde et lente, qui éjecte loin
	-- et encaisse pendant les spéciaux. n° 3 : le bouquet de ballons, jeu de projectiles flottants et de Supers vite rechargés.
	weapons = {
		{ id = "canne", name = "Canne invisible", icon = "🤍",
			ability = { jumps = 1, text = "Un saut de plus : il monte un escalier invisible" } },
		{ id = "valise", name = "Valise invisible", icon = "🧳",
			prop = { name = "PropValise", hand = "Right", pieces = {
				{ "Poignee", "", "cyl", Vector3.new(0.7, 0.14, 0.14), Vector3.new(0, -0.1, 0), Vector3.zero, CUIR, "Leather", { axis = "x" } },
				{ "Coffre", "", "block", Vector3.new(2.4, 1.7, 0.8), Vector3.new(0, -1.25, 0), Vector3.zero, GHOST, "Glass", { transparency = 0.72 } },
				{ "CoinG", "", "block", Vector3.new(0.32, 0.32, 0.86), Vector3.new(-1.05, -2.0, 0), Vector3.zero, CUIR, "Leather" },
				{ "CoinD", "", "block", Vector3.new(0.32, 0.32, 0.86), Vector3.new(1.05, -2.0, 0), Vector3.zero, CUIR, "Leather" },
				{ "Etiquette", "", "block", Vector3.new(0.55, 0.32, 0.05), Vector3.new(0.6, -0.95, -0.42), Vector3.new(0, 0, 15), RED, "SmoothPlastic" },
			} },
			ability = { knockback = 1.3, armor = true, text = "Pleine de rien et pourtant lourde : éjecte 30 % plus loin, les L encaissent" },
			moves = {
				-- J : il balance la valise devant lui d'un coup de reins, comme un bagagiste pressé
				P_neutral = {
					label = "Coup de valise", startup = 0.11, active = 0.1, recovery = 0.2,
					damage = 7, hitbox = box(5, 3.5, 2.8, 0.6), kbBase = 24, kbGrowth = 36, kbAngle = 30,
					windup = { Root = { 4, -18, 0, 0, -0.12, 0.15 }, Waist = { 6, -22, 0 }, Neck = { 0, 14, 0 }, RS = { 20, 0, 24 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 80, 0, 0 } },
					strike = { Root = { -8, 16, 0, 0, -0.26, -0.3 }, Waist = { -10, 22, 0 }, Neck = { -4, -10, 0 }, RS = { 92, 0, 4 }, RE = { 10, 0, 0 }, RW = { -30, 0, 0 }, LS = { 10, 0, -30 }, LE = { 90, 0, 0 } },
					follow = { Root = { -10, 20, 0, 0, -0.28, -0.34 }, Waist = { -12, 26, 0 }, Neck = { -4, -12, 0 }, RS = { 96, 0, 2 }, RE = { 14, 0, 0 }, RW = { -40, 0, 0 }, LS = { 8, 0, -30 }, LE = { 92, 0, 0 } },
					trail = "prop", text = "…", hitText = "( BADABOUM )",
				},
				-- →J : grand balancé latéral de la valise à bout de bras, la hanche part en premier
				P_side = {
					label = "Valise balancée", startup = 0.12, active = 0.1, recovery = 0.22,
					damage = 8, hitbox = box(6, 3, 3.5, 0.8), kbBase = 26, kbGrowth = 46, kbAngle = 25, selfVelocity = Vector2.new(18, 0),
					windup = { Root = { 2, -40, 0, 0, -0.15, 0.2 }, Waist = { 4, -36, 0 }, Neck = { 0, 28, 0 }, RS = { 40, 0, 70 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 90, 0, 0 } },
					strike = { Root = { -6, 24, 0, 0, -0.3, -0.35 }, Waist = { -8, 30, 0 }, Neck = { 0, -18, 0 }, RS = { 90, 0, -10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -40 }, LE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -8, 34, 0, 0, -0.32, -0.4 }, Waist = { -10, 40, 0 }, Neck = { 0, -24, 0 }, RS = { 84, 0, -30 }, RE = { 6, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -40 }, LE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					trail = "prop", hitText = "( VLAN )",
				},
				-- ↓J : il pose la valise… pile sur les orteils d'en face, puis s'excuse d'un geste
				P_down = {
					label = "Valise posée", startup = 0.1, active = 0.1, recovery = 0.2,
					damage = 7, hitbox = box(4.5, 2, 2.4, -1.8), kbBase = 24, kbGrowth = 32, kbAngle = 72,
					windup = { Root = { 6, 0, 0, 0, -0.3, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 60, 0, 16 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 60, 0, 0 } },
					strike = { Root = { 14, 0, 0, 0, -0.75, -0.15 }, Waist = { 26, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { 10, 0, 0, 0, -0.6, -0.1 }, Waist = { 18, 0, 0 }, Neck = { 4, 0, 10 }, RS = { 30, 0, 20 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -40 }, LE = { 110, 0, 0 }, LW = { 0, 0, 40 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					fx = { "dust" }, text = "( OUPS )", hitText = "( AÏE LES ORTEILS )",
				},
				-- ↑J : il hisse la valise au-dessus du béret comme un porteur de gare, bras tendus
				P_up = {
					label = "Valise au plafond", startup = 0.12, active = 0.12, recovery = 0.22,
					damage = 8, hitbox = box(4.5, 5, 1.2, 3.6), kbBase = 28, kbGrowth = 42, kbAngle = 86,
					windup = { Root = { 8, 0, 0, 0, -0.4, 0.1 }, Waist = { 12, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 30, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 60, 0, 0 } },
					strike = { Root = { -6, 0, 0, 0, 0.15, -0.05 }, Waist = { -8, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 180, 0, 8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 176, 0, -8 }, LE = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.15, 0 }, FL = { 0, 0, 0, 0, 0.15, 0 } },
					follow = { Root = { -8, 0, 0, 0, 0.18, -0.06 }, Waist = { -10, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 184, 0, 10 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 180, 0, -10 }, LE = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.18, 0 }, FL = { 0, 0, 0, 0, 0.18, 0 } },
					trail = "prop", fx = { { "ring", color = GHOST, radius = 3, at = "above" } }, hitText = "( TOC )",
				},
				-- J en l'air : il abat la valise sous lui, genoux remontés, comme on jette un bagage dans la soute
				P_air = {
					label = "Valise plongeante", startup = 0.1, active = 0.12, recovery = 0.18,
					damage = 8, hitbox = box(4.5, 4, 2, -1), kbBase = 24, kbGrowth = 40, kbAngle = -35,
					windup = { Root = { 10, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 180, 0, 10 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 40, 0, 0 }, RH = { 50, 0, 0 }, RK = { -90, 0, 0 }, LH = { 60, 0, 0 }, LK = { -100, 0, 0 } },
					strike = { Root = { -14, 0, 0 }, Waist = { -30, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 40, 0, 4 }, RE = { 0, 0, 0 }, RW = { -20, 0, 0 }, LS = { -20, 0, -45 }, LE = { 20, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -18, 0, 0 }, Waist = { -34, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 20, 0, 6 }, RE = { 6, 0, 0 }, RW = { -30, 0, 0 }, LS = { -28, 0, -50 }, LE = { 20, 0, 0 }, RH = { 10, 0, 0 }, RK = { -30, 0, 0 }, LH = { 24, 0, 0 }, LK = { -55, 0, 0 } },
					trail = "prop", hitText = "( BLAM )",
				},
				-- dash J : bagagiste en retard, il fonce la valise devant lui comme un bélier
				P_dash = {
					label = "Bagagiste en retard", startup = 0.1, active = 0.16, recovery = 0.26,
					damage = 9, hitbox = box(5, 4, 3, 0.5), kbBase = 30, kbGrowth = 55, kbAngle = 28, selfVelocity = Vector2.new(42, 0),
					windup = { Root = { -6, 0, 0, 0, -0.2, 0.1 }, Waist = { -6, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 50, 0, 10 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -10 }, LE = { 90, 0, 0 } },
					strike = { Root = { -16, 0, 0, 0, -0.3, -0.3 }, Waist = { -10, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 94, 0, 6 }, RE = { 0, 0, 0 }, RW = { -20, 0, 0 }, LS = { 94, 0, -6 }, LE = { 0, 0, 0 }, LW = { -20, 0, 0 } },
					follow = { Root = { -18, 0, 0, 0, -0.32, -0.34 }, Waist = { -12, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 96, 0, 8 }, RE = { 0, 0, 0 }, RW = { -24, 0, 0 }, LS = { 96, 0, -8 }, LE = { 0, 0, 0 }, LW = { -24, 0, 0 } },
					trail = "prop", fx = { "dust", { "symbols", symbols = { "( VITE )" }, count = 1, radius = 1.5, color = WHITE } }, hitText = "( BOUM )",
				},
				-- K : il prend la valise à deux mains derrière lui et l'abat de tout son poids, le béret s'envole presque
				K_neutral = {
					label = "Valise à deux mains", startup = 0.22, active = 0.12, recovery = 0.36,
					damage = 13, hitbox = box(5.5, 4, 3, 0.8), kbBase = 34, kbGrowth = 86, kbAngle = 35,
					windup = { Root = { 14, 0, 0, 0, 0.0, 0.25 }, Waist = { 18, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 190, 0, 8 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 186, 0, 2 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0.15, 0 }, FL = { 0, 0, 0, 0, 0.15, 0 } },
					strike = { Root = { -16, 0, 0, 0, -0.5, -0.35 }, Waist = { -28, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 70, 0, -4 }, RE = { 0, 0, 0 }, RW = { -40, 0, 0 }, LS = { 70, 0, 10 }, LE = { 10, 0, 0 } },
					follow = { Root = { -20, 0, 0, 0, -0.56, -0.4 }, Waist = { -32, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 50, 0, -4 }, RE = { 0, 0, 0 }, RW = { -55, 0, 0 }, LS = { 50, 0, 10 }, LE = { 10, 0, 0 } },
					trail = "prop", fx = { { "ring", color = GHOST, radius = 3.5, at = "front" }, { "shake", amount = 0.25 } }, text = "…!", hitText = "( SBAM )",
				},
				-- →K : tourniquet de bagages, un tour complet sur lui-même la valise à l'horizontale
				K_side = {
					label = "Tourniquet de bagages", startup = 0.22, active = 0.16, recovery = 0.36,
					damage = 14, hitbox = box(6.5, 3.5, 3.5, 0.8), kbBase = 36, kbGrowth = 90, kbAngle = 30, selfVelocity = Vector2.new(20, 0),
					windup = { Root = { 0, -50, 0, 0, -0.2, 0.1 }, Waist = { 0, -30, 0 }, Neck = { 0, 30, 0 }, RS = { 60, 0, 60 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -40 }, LE = { 50, 0, 0 } },
					strike = { Root = { -4, 0, 0, 0, -0.22, -0.1 }, Waist = { -4, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 90, 0, 14 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -85 }, LE = { 0, 0, 0 } },
					follow = { Root = { -4, 0, 0, 0, -0.22, -0.1 }, Waist = { -4, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 92, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -85 }, LE = { 0, 0, 0 } },
					spin = { axis = "y", degrees = 360 }, trail = "prop", hitText = "( VLAM )",
				},
				-- ↓K : il écrase la valise au sol et l'onde de choc fauche les chevilles
				K_down = {
					label = "Valise écrasée", startup = 0.2, active = 0.12, recovery = 0.36,
					damage = 12, hitbox = box(7, 2.5, 3.5, -1.5), kbBase = 32, kbGrowth = 72, kbAngle = 76,
					windup = { Root = { 8, 0, 0, 0, 0.05, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 186, 0, 14 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 186, 0, -14 }, LE = { 30, 0, 0 } },
					strike = { Root = { 12, 0, 0, 0, -0.9, -0.2 }, Waist = { 24, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 50, 0, 10 }, RE = { 0, 0, 0 }, RW = { -20, 0, 0 }, LS = { 50, 0, -10 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { 14, 0, 0, 0, -0.95, -0.24 }, Waist = { 26, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 44, 0, 12 }, RE = { 0, 0, 0 }, RW = { -30, 0, 0 }, LS = { 44, 0, -12 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
					trail = "prop", fx = { { "ring", color = GHOST, radius = 5, at = "feet" }, { "shake", amount = 0.35 }, "dust" }, hitText = "( BROUM )",
				},
				-- ↑K : uppercut de valise, il la remonte du sol jusqu'au ciel en se cambrant
				K_up = {
					label = "Valise soulevée", startup = 0.22, active = 0.12, recovery = 0.34,
					damage = 13, hitbox = box(4.5, 6, 1.5, 3.5), kbBase = 34, kbGrowth = 82, kbAngle = 88,
					windup = { Root = { 12, 0, 0, 0, -0.55, 0.15 }, Waist = { 20, 0, 0 }, Neck = { -14, 0, 0 }, RS = { -20, 0, 20 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 80, 0, 0 } },
					strike = { Root = { -14, 0, 0, 0, 0.1, -0.1 }, Waist = { -18, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 176, 0, 6 }, RE = { 10, 0, 0 }, RW = { -30, 0, 0 }, LS = { 20, 0, -40 }, LE = { 60, 0, 0 }, FR = { 0, 0, 0, 0, 0.12, 0 }, FL = { 0, 0, 0, 0, 0.12, 0 } },
					follow = { Root = { -16, 0, 0, 0, 0.12, -0.12 }, Waist = { -20, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 182, 0, 8 }, RE = { 10, 0, 0 }, RW = { -40, 0, 0 }, LS = { 16, 0, -42 }, LE = { 60, 0, 0 }, FR = { 0, 0, 0, 0, 0.14, 0 }, FL = { 0, 0, 0, 0, 0.14, 0 } },
					trail = "prop", fx = { { "burst", color = GHOST, size = 2.5, at = "above" } }, hitText = "( HOP LÀ )",
				},
				-- K en l'air : assis sur la valise comme sur une luge, il la lâche sous lui
				K_air = {
					label = "Assis sur la valise", startup = 0.16, active = 0.14, recovery = 0.26,
					damage = 12, hitbox = box(5, 4, 1.5, -1.5), kbBase = 30, kbGrowth = 72, kbAngle = -45,
					windup = { Root = { -6, 0, 0 }, Waist = { -8, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 60, 0, 30 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 90, 0, 0 }, RH = { 90, 0, 0 }, RK = { -100, 0, 0 }, LH = { 90, 0, 0 }, LK = { -100, 0, 0 } },
					strike = { Root = { 8, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 20, 0, 20 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -20 }, LE = { 10, 0, 0 }, RH = { 95, 0, 10 }, RK = { -10, 0, 0 }, RA = { 10, 0, 0 }, LH = { 95, 0, -10 }, LK = { -10, 0, 0 }, LA = { 10, 0, 0 } },
					follow = { Root = { 10, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 10, 0, 24 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -24 }, LE = { 10, 0, 0 }, RH = { 100, 0, 12 }, RK = { -12, 0, 0 }, RA = { 10, 0, 0 }, LH = { 100, 0, -12 }, LK = { -12, 0, 0 }, LA = { 10, 0, 0 } },
					trail = "prop", hitText = "( POUM )",
				},
				-- dash K : il glisse sur la valise à roulettes, pieds devant, et renverse tout
				K_dash = {
					label = "Valise à roulettes", startup = 0.12, active = 0.26, recovery = 0.34,
					damage = 12, hitbox = box(6, 3, 3, -0.8), kbBase = 32, kbGrowth = 70, kbAngle = 38, selfVelocity = Vector2.new(55, 10),
					windup = { Root = { -8, 0, 0, 0, -0.4, 0 }, Waist = { -10, 0, 0 }, RS = { 40, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 60, 0, 0 } },
					strike = { Root = { 22, 0, 0, 0, -0.7, 0.2 }, Waist = { 10, 0, 0 }, Neck = { 6, 0, 0 }, RS = { -20, 0, 20 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 30, 0, 0 }, RH = { 85, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 }, LH = { 80, 0, 0 }, LK = { -10, 0, 0 } },
					follow = { Root = { 26, 0, 0, 0, -0.72, 0.24 }, Waist = { 12, 0, 0 }, Neck = { 8, 0, 0 }, RS = { -26, 0, 24 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 66, 0, -44 }, LE = { 30, 0, 0 }, RH = { 90, 0, 0 }, RK = { 0, 0, 0 }, RA = { 14, 0, 0 }, LH = { 85, 0, 0 }, LK = { -10, 0, 0 } },
					trail = "prop", fx = { "dust", { "symbols", symbols = { "( RRRR )" }, count = 2, radius = 2, color = WHITE } }, hitText = "( SKRRRT )",
				},
				-- L : la valise s'ouvre d'un coup et tout ce qu'elle ne contient pas gicle en ressort sur tout le couloir
				S_neutral = {
					label = "Valise à ressort", startup = 0.24, active = 0.2, recovery = 0.5,
					damage = 14, hitbox = box(14, 6, 7, 1), kbBase = 34, kbGrowth = 60, kbAngle = 30,
					windup = { Root = { 6, 0, 0, 0, -0.25, 0.2 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 10 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 100, 0, 0 }, LW = { 60, 0, 0 } },
					strike = { Root = { -12, 0, 0, 0, -0.35, -0.4 }, Waist = { -14, 0, 0 }, Neck = { -16, 0, 0 }, RS = { 96, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -30 }, LE = { 20, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					follow = { Root = { -14, 0, 0, 0, -0.38, -0.45 }, Waist = { -16, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 98, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 156, 0, -34 }, LE = { 20, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
					hold = 0.1, shake = true, trail = "prop",
					fx = { { "burst", color = GHOST, size = 3.5, at = "hand" }, { "toss", shape = "flat", color = WHITE, size = 0.8, count = 6, speed = 26 }, { "beam", color = GHOST, length = 14, width = 2.5, at = "hand" } },
					text = "( CLAC )", hitText = "( SURPRISE )",
				},
				-- →L : le convoyeur à bagages, il pousse la valise sur un tapis roulant d'aéroport qui traverse tout le couloir
				S_side = {
					label = "Convoyeur à bagages", startup = 0.22, active = 0.3, recovery = 0.5,
					damage = 15, hitbox = box(14, 6, 7, 0.5), kbBase = 36, kbGrowth = 64, kbAngle = 32, selfVelocity = Vector2.new(46, 0),
					windup = { Root = { 6, 0, 0, 0, -0.3, 0.2 }, Waist = { 10, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 40, 0, 10 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -10 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -22, 0, 0, 0, -0.45, -0.5 }, Waist = { -12, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 90, 0, 8 }, RE = { 0, 0, 0 }, RW = { -30, 0, 0 }, LS = { 90, 0, -8 }, LE = { 0, 0, 0 }, LW = { -30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.6 } },
					follow = { Root = { -24, 0, 0, 0, -0.48, -0.55 }, Waist = { -14, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 92, 0, 8 }, RE = { 0, 0, 0 }, RW = { -34, 0, 0 }, LS = { 92, 0, -8 }, LE = { 0, 0, 0 }, LW = { -34, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.65 } },
					wobble = true, trail = "prop", fx = { { "beam", color = GHOST, length = 16, width = 3, at = "feet" }, "dust", { "symbols", symbols = { "▶", "▶" }, count = 3, radius = 2, color = WHITE } },
					text = "( BIIIP )", hitText = "( EMBARQUÉ )",
				},
				-- ↓L : valise trop lourde : il tire dessus, n'y arrive pas, et la laisse retomber si fort que le sol se fend
				S_down = {
					label = "Valise trop lourde", startup = 0.26, active = 0.16, recovery = 0.5,
					damage = 14, hitbox = box(14, 6, 7, 0.5), kbBase = 34, kbGrowth = 60, kbAngle = 80,
					windup = { Root = { 16, 0, 0, 0, -0.5, 0.3 }, Waist = { -10, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 40, 0, 10 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -10 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					strike = { Root = { 10, 0, 0, 0, -0.9, -0.2 }, Waist = { 26, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 50, 0, 10 }, RE = { 0, 0, 0 }, RW = { -20, 0, 0 }, LS = { 50, 0, -10 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { 12, 0, 0, 0, -0.92, -0.24 }, Waist = { 28, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 44, 0, 14 }, RE = { 0, 0, 0 }, RW = { -30, 0, 0 }, LS = { 44, 0, -14 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					shake = true, hold = 0.1, trail = "prop",
					fx = { { "ring", color = GHOST, radius = 7, at = "feet" }, { "pillar", color = GHOST, height = 3, width = 8, at = "front", time = 0.5 }, { "shake", amount = 0.6 }, "dust" },
					text = "( HAN… )", hitText = "( CRAAAC )",
				},
				-- ↑L : il monte sur la valise comme sur un tapis roulant d'aéroport qui s'emballe et file en diagonale vers le ciel
				S_up = {
					label = "Tapis roulant d'aéroport", startup = 0.15, active = 0.3, recovery = 0.4,
					damage = 14, hitbox = box(10, 11, 3, 4), kbBase = 32, kbGrowth = 55, kbAngle = 72, selfVelocity = Vector2.new(42, 80),
					windup = { Root = { 6, 0, 0, 0, -0.7, 0.1 }, Waist = { -10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 30, 0, 10 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -20 }, LE = { 40, 0, 0 } },
					strike = { Root = { -38, 0, 0, 0, 0.3, 0 }, Waist = { -8, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 10, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -30 }, LE = { 10, 0, 0 }, RH = { 10, 0, 6 }, RK = { -10, 0, 0 }, RA = { -20, 0, 0 }, LH = { 6, 0, -6 }, LK = { -10, 0, 0 }, LA = { -20, 0, 0 } },
					follow = { Root = { -42, 0, 0, 0, 0.35, 0 }, Waist = { -10, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 8, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 156, 0, -34 }, LE = { 10, 0, 0 }, RH = { 12, 0, 8 }, RK = { -14, 0, 0 }, RA = { -20, 0, 0 }, LH = { 4, 0, -8 }, LK = { -12, 0, 0 }, LA = { -20, 0, 0 } },
					trail = "prop", fx = { { "ring", color = WIND, radius = 4, at = "feet" }, { "beam", color = GHOST, length = 12, width = 2, at = "feet" }, { "symbols", symbols = { "✈", "( DING )" }, count = 3, radius = 2, color = WHITE } },
					text = "( EMBARQUEMENT )", hitText = "( DÉCOLLÉ )",
				},
				-- L en l'air : il lâche la valise, qui tombe du ciel pile sur la tête de l'adversaire
				S_air = {
					label = "Valise lâchée", kind = "projectile", startup = 0.18, active = 0, recovery = 0.42,
					damage = 14, kbBase = 28, kbGrowth = 58, kbAngle = -60,
					projectile = { speed = 60, gravity = 60, lifetime = 0.9, size = 3, color = GHOST, rain = { count = 1, spread = 0.5, ahead = 7, height = 18 },
						visual = { shape = "block", size = 2.4, color = GHOST, transparency = 0.7, spin = 4,
							parts = { { "block", Vector3.new(0.3, 0.3, 0.9), Vector3.new(-1.1, -1.0, 0), CUIR }, { "block", Vector3.new(0.3, 0.3, 0.9), Vector3.new(1.1, -1.0, 0), CUIR } } } },
					windup = { Root = { -6, 0, 0 }, Waist = { -8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 176, 0, 14 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, RH = { 40, 0, 0 }, RK = { -60, 0, 0 }, LH = { 20, 0, 0 }, LK = { -50, 0, 0 } },
					strike = { Root = { 4, 0, 0 }, Waist = { 4, 0, 0 }, Neck = { -16, 0, 0 }, RS = { 150, 0, 40 }, RE = { 10, 0, 0 }, RW = { 60, 0, 0 }, LS = { 60, 0, -30 }, LE = { 110, 0, 0 }, LW = { 0, 0, 40 }, RH = { 30, 0, 0 }, RK = { -50, 0, 0 }, LH = { 20, 0, 0 }, LK = { -50, 0, 0 } },
					follow = { Root = { 4, 0, 0 }, Waist = { 4, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 140, 0, 44 }, RE = { 10, 0, 0 }, RW = { 70, 0, 0 }, LS = { 70, 0, -30 }, LE = { 110, 0, 0 }, LW = { 0, 0, 50 }, RH = { 30, 0, 0 }, RK = { -50, 0, 0 }, LH = { 20, 0, 0 }, LK = { -50, 0, 0 } },
					hideProp = "valise", fx = { { "symbols", symbols = { "🧳", "▼" }, count = 2, radius = 2, at = "above", color = WHITE } }, text = "( OUPS )", hitText = "( PLONK )",
				},
				-- Y : excédent de bagages, il ouvre la valise en grand, y fourre tout le couloir et la referme à coups de fesses
				SUPER = {
					label = "Excédent de bagages !", startup = 0.4, active = 0.24, recovery = 0.7,
					damage = 24, hitbox = box(14, 6, 7, 1), kbBase = 48, kbGrowth = 98, kbAngle = 32,
					status = { name = "rooted", duration = 1 },
					windup = { Root = { 10, 0, 0, 0, -0.5, 0.2 }, Waist = { 16, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 70, 0, 30 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -30 }, LE = { 90, 0, 0 }, LW = { 60, 0, 0 } },
					strike = { Root = { -20, 0, 0, 0, -0.5, -0.5 }, Waist = { -20, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 96, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 96, 0, -10 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.6 } },
					follow = { Root = { 20, 180, 0, 0, -0.9, -0.2 }, Waist = { -10, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 60, 0, 60 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -60 }, LE = { 20, 0, 0 } },
					hold = 0.2, shake = true, windupFx = { "super", { "text", text = "[ 23 KG MAX ]", color = WHITE, at = "above" } },
					fx = { { "burst", color = GHOST, size = 4, at = "front" }, { "ring", color = GHOST, radius = 6, at = "front" }, { "symbols", symbols = { "🧳", "( CLAC )" }, count = 5, radius = 3, color = WHITE }, { "shake", amount = 0.4 } },
					text = "( ÇA RENTRE )", hitText = "( EMBALLÉ, PESÉ )",
				},
				-- →Y : le carrousel, il lance la valise à plat ; elle fait le tour du tapis à bagages… et revient dans sa main
				SUPER_side = {
					label = "Le Carrousel !", kind = "projectile", startup = 0.38, active = 0, recovery = 0.65,
					damage = 24, kbBase = 46, kbGrowth = 94, kbAngle = 30,
					projectile = { speed = 85, angle = 0, gravity = 0, lifetime = 0.9, size = 3.2, color = GHOST, returns = true, pierce = true,
						visual = { shape = "block", size = 2.8, color = GHOST, transparency = 0.7, spin = 10,
							parts = { { "block", Vector3.new(0.3, 0.3, 1.0), Vector3.new(-1.3, -1.2, 0), CUIR }, { "block", Vector3.new(0.3, 0.3, 1.0), Vector3.new(1.3, -1.2, 0), CUIR }, { "block", Vector3.new(0.6, 0.35, 0.06), Vector3.new(0.6, 0, -1.45), RED } } } },
					windup = { Root = { 6, -40, 0, 0, -0.3, 0.3 }, Waist = { 10, -40, 0 }, Neck = { 6, 28, 0 }, RS = { 60, 0, 80 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 70, 0, 0 } },
					strike = { Root = { -14, 26, 0, 0, -0.34, -0.5 }, Waist = { -16, 30, 0 }, Neck = { -4, -18, 0 }, RS = { 92, 0, -10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					follow = { Root = { -16, 30, 0, 0, -0.36, -0.55 }, Waist = { -20, 34, 0 }, Neck = { -6, -20, 0 }, RS = { 96, 0, -14 }, RE = { 4, 0, 0 }, RW = { 6, 0, 0 }, LS = { 36, 0, -44 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.52 } },
					hideProp = "valise", windupFx = { "super", { "symbols", symbols = { "🧳", "↻" }, count = 5, radius = 3, color = WHITE } },
					fx = { { "burst", color = GHOST, size = 3, at = "hand" }, { "ring", color = GHOST, radius = 4, at = "front" }, { "shake", amount = 0.3 } },
					text = "( TAPIS 4 )", hitText = "( FAUCHÉ )",
				},
				-- ↑Y : le tapis volant de bagages, debout sur la valise, il décolle à la verticale et tout le couloir monte avec lui
				SUPER_up = {
					label = "Tapis volant de bagages !", startup = 0.35, active = 0.3, recovery = 0.7,
					damage = 24, hitbox = box(14, 8, 7, 2), kbBase = 46, kbGrowth = 95, kbAngle = 88, invuln = 0.3, selfVelocity = Vector2.new(0, 60),
					windup = { Root = { 0, 0, 0, 0, -0.85, 0 }, Waist = { -20, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 10 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -10 }, LE = { 60, 0, 0 } },
					strike = { Root = { 6, 0, 0, 0, 0.45, 0 }, Waist = { 4, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 20, 0, 60 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -60 }, LE = { 0, 0, 0 }, RH = { 10, 0, 10 }, RK = { -20, 0, 0 }, LH = { 10, 0, -10 }, LK = { -20, 0, 0 } },
					follow = { Root = { 8, 0, 0, 0, 0.5, 0 }, Waist = { 6, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 24, 0, 64 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 24, 0, -64 }, LE = { 0, 0, 0 }, RH = { 12, 0, 12 }, RK = { -24, 0, 0 }, LH = { 12, 0, -12 }, LK = { -24, 0, 0 } },
					hold = 0.2, trail = "prop", windupFx = { "super", { "text", text = "[ PORTE 12 ]", color = WHITE, at = "above" } },
					fx = { { "pillar", color = GHOST, height = 24, width = 6, at = "front" }, { "ring", color = WIND, radius = 7, at = "feet" }, { "symbols", symbols = { "▲", "🧳" }, count = 5, radius = 3, color = WHITE } },
					text = "…", hitText = "[ DERNIER APPEL ]",
				},
				-- ↓Y : la douane, il pose la valise, enfile des gants invisibles et fouille tout le couloir sans ménagement
				SUPER_down = {
					label = "La Douane !", startup = 0.35, active = 0.8, recovery = 0.6,
					damage = 6, hits = 4, hitbox = box(14, 6, 7, 0.5), kbBase = 16, kbGrowth = 22, kbAngle = 70,
					status = { name = "slowed", duration = 2 },
					windup = { Root = { 4, 0, 0, 0, -0.2, 0.1 }, Waist = { 6, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 60, 0, 20 }, RE = { 110, 0, 0 }, RW = { 60, 0, 0 }, LS = { 60, 0, -20 }, LE = { 110, 0, 0 }, LW = { 60, 0, 0 } },
					strike = { Root = { -10, 10, 0, 0, -0.5, -0.3 }, Waist = { -14, 12, 0 }, Neck = { -10, 0, 0 }, RS = { 90, 0, 0 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -20 }, LE = { 60, 0, 0 }, LW = { 0, 0, 0 } },
					follow = { Root = { -10, -10, 0, 0, -0.5, -0.3 }, Waist = { -14, -12, 0 }, Neck = { -10, 0, 0 }, RS = { 70, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, 0 }, LE = { 20, 0, 0 }, LW = { 0, 0, 0 } },
					wobble = true, windupFx = { "super", { "text", text = "[ RIEN À DÉCLARER ? ]", color = WHITE, at = "above" } },
					fx = { { "ring", color = GHOST, radius = 6, at = "front" }, { "symbols", symbols = { "🧤", "( TOC )", "?" }, count = 8, radius = 4, at = "front", color = WHITE }, { "toss", shape = "flat", color = WHITE, size = 0.6, count = 5, speed = 16 } },
					text = "( FOUILLE )", hitText = "( CONFISQUÉ )",
				},
			},
			links = {
				P_neutral = { P = "P_side", K = "K_neutral", S = "S_neutral" },
				P_side = { P = "P_up", K = "K_side", S = "S_side" },
				P_down = { P = "P_neutral", K = "K_down", S = "S_down" },
				K_neutral = { P = "P_up", K = "K_up", S = "S_neutral" },
				P_dash = { P = "P_side", K = "K_side", S = "S_side" },
				K_dash = { P = "P_up", S = "S_up" },
			},
		},
		{ id = "ballons", name = "Bouquet de ballons", icon = "🎈",
			prop = { name = "PropBallons", hand = "Right", pieces = {
				{ "Ficelles", "", "cyl", Vector3.new(0.06, 2.2, 0.06), Vector3.new(0, -1.1, 0), Vector3.zero, WHITE, "SmoothPlastic", { transparency = 0.5 } },
				{ "Noeud", "", "ball", Vector3.new(0.26, 0.26, 0.26), Vector3.new(0, -2.05, 0), Vector3.zero, WHITE, "SmoothPlastic" },
				{ "BallonRose", "", "ball", Vector3.new(1.3, 1.6, 1.3), Vector3.new(0, -2.9, 0), Vector3.zero, PINK, "Glass", { transparency = 0.55 } },
				{ "BallonBleu", "", "ball", Vector3.new(1.1, 1.4, 1.1), Vector3.new(0.72, -2.5, 0.4), Vector3.zero, SKY, "Glass", { transparency = 0.55 } },
				{ "BallonRouge", "", "ball", Vector3.new(1.1, 1.4, 1.1), Vector3.new(-0.7, -2.6, -0.35), Vector3.zero, RED, "Glass", { transparency = 0.55 } },
			} },
			ability = { superCooldown = 0.6, text = "Léger comme l'air : Supers rechargés 40 % plus vite" },
			moves = {
				-- J : il tapote un ballon sur le nez d'en face, l'air de rien
				P_neutral = {
					label = "Ballon au nez", startup = 0.07, active = 0.08, recovery = 0.14,
					damage = 5, hitbox = box(4.5, 3, 2.6, 0.8), kbBase = 16, kbGrowth = 20, kbAngle = 30,
					windup = { Root = { 2, -14, 0, 0, -0.1, 0.1 }, Waist = { 4, -16, 0 }, Neck = { 0, 12, 0 }, RS = { 120, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 70, 0, 0 } },
					strike = { Root = { -4, 12, 0, 0, -0.2, -0.2 }, Waist = { -6, 14, 0 }, Neck = { -4, -8, 0 }, RS = { 60, 0, 0 }, RE = { 30, 0, 0 }, RW = { 40, 0, 0 }, LS = { 20, 0, -30 }, LE = { 70, 0, 0 } },
					follow = { Root = { -6, 14, 0, 0, -0.22, -0.24 }, Waist = { -8, 16, 0 }, Neck = { -4, -10, 0 }, RS = { 50, 0, 0 }, RE = { 40, 0, 0 }, RW = { 50, 0, 0 }, LS = { 20, 0, -30 }, LE = { 70, 0, 0 } },
					trail = "prop", text = "…", hitText = "( POC )",
				},
				-- →J : il lâche un ballon qui dérive mollement vers l'avant… et vers le haut
				P_side = {
					label = "Ballon lâché", kind = "projectile", startup = 0.1, active = 0, recovery = 0.2,
					damage = 6, kbBase = 18, kbGrowth = 28, kbAngle = 35,
					projectile = { speed = 55, angle = 10, gravity = -15, lifetime = 0.4, size = 1.4, color = PINK, aim = false,
						visual = { shape = "ball", size = 1.3, color = PINK, transparency = 0.5, spin = 2 } },
					windup = { Root = { 4, -20, 0, 0, -0.15, 0.15 }, Waist = { 6, -24, 0 }, Neck = { 0, 16, 0 }, RS = { 140, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 80, 0, 0 } },
					strike = { Root = { -6, 16, 0, 0, -0.25, -0.3 }, Waist = { -8, 20, 0 }, Neck = { 0, -12, 0 }, RS = { 100, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 80, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
					follow = { Root = { -8, 18, 0, 0, -0.26, -0.32 }, Waist = { -10, 22, 0 }, Neck = { 6, -14, 0 }, RS = { 110, 0, 4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 30 }, LS = { 30, 0, -30 }, LE = { 80, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
					hitText = "( FLOP )",
				},
				-- ↓J : accroupi, il gonfle un ballon sous les pieds d'en face, qui enfle, enfle… et éclate
				P_down = {
					label = "Ballon gonflé au sol", startup = 0.1, active = 0.1, recovery = 0.2,
					damage = 6, hitbox = box(5, 2.5, 2.8, -1.5), kbBase = 22, kbGrowth = 26, kbAngle = 75,
					windup = { Root = { 8, 0, 0, 0, -0.8, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 60, 0, 10 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 120, 0, 0 } },
					strike = { Root = { 12, 0, 0, 0, -0.9, -0.2 }, Waist = { 22, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { 6, 0, 0, 0, -0.8, -0.2 }, Waist = { 16, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 60 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -60 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					shake = true, fx = { { "burst", color = PINK, size = 3, at = "feet" } }, text = "( FFF… FFF… )", hitText = "( BANG )",
				},
				-- ↑J : il hisse le bouquet au ciel sur la pointe des pieds, les ballons cognent ce qui passe
				P_up = {
					label = "Bouquet au ciel", startup = 0.08, active = 0.12, recovery = 0.2,
					damage = 7, hitbox = box(4.5, 5, 1, 3.6), kbBase = 26, kbGrowth = 32, kbAngle = 86,
					windup = { Root = { -4, 0, 0, 0, -0.35, 0 }, Waist = { -6, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 10 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 60, 0, 0 } },
					strike = { Root = { 4, 0, 0, 0, 0.15, 0 }, Waist = { 8, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 182, 0, 8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -50 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0.15, 0 }, FL = { 0, 0, 0, 0, 0.15, 0 } },
					follow = { Root = { 4, 0, 0, 0, 0.18, 0 }, Waist = { 8, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 186, 0, 10 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 6, 0, -54 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0.18, 0 }, FL = { 0, 0, 0, 0, 0.18, 0 } },
					trail = "prop", fx = { { "symbols", symbols = { "🎈" }, count = 3, radius = 2, at = "above", color = PINK } }, hitText = "( BOING )",
				},
				-- J en l'air : il claque des deux mains sur un ballon devant lui, qui éclate à la figure d'en face
				P_air = {
					label = "Ballon claqué", startup = 0.08, active = 0.1, recovery = 0.16,
					damage = 7, hitbox = box(5, 4, 2, 0), kbBase = 22, kbGrowth = 34, kbAngle = 35,
					windup = { Root = { 6, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 80, 0, 60 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -60 }, LE = { 40, 0, 0 }, RH = { 50, 0, 0 }, RK = { -80, 0, 0 }, LH = { 40, 0, 0 }, LK = { -70, 0, 0 } },
					strike = { Root = { -6, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 92, 0, -10 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, 10 }, LE = { 10, 0, 0 }, RH = { 30, 0, 0 }, RK = { -60, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -8, 0, 0 }, Waist = { -12, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 100, 0, 40 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 100, 0, -40 }, LE = { 30, 0, 0 }, RH = { 30, 0, 0 }, RK = { -60, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					fx = { { "burst", color = RED, size = 3, at = "front" } }, hitText = "( PAN )",
				},
				-- dash J : il court, les ballons traînent derrière lui, et il se jette en avant tête baissée
				P_dash = {
					label = "Course aux ballons", startup = 0.08, active = 0.14, recovery = 0.24,
					damage = 8, hitbox = box(5, 4, 3, 0.8), kbBase = 26, kbGrowth = 48, kbAngle = 28, selfVelocity = Vector2.new(40, 0),
					windup = { Root = { -6, 0, 0, 0, -0.2, 0.1 }, Waist = { -6, 0, 0 }, Neck = { 6, 0, 0 }, RS = { -40, 0, 20 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 80, 0, 0 } },
					strike = { Root = { -22, 0, 0, 0, -0.35, -0.3 }, Waist = { -14, 0, 0 }, Neck = { -10, 0, 0 }, RS = { -50, 0, 24 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 100, 0, -10 }, LE = { 10, 0, 0 } },
					follow = { Root = { -24, 0, 0, 0, -0.36, -0.34 }, Waist = { -16, 0, 0 }, Neck = { -12, 0, 0 }, RS = { -54, 0, 26 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 104, 0, -12 }, LE = { 10, 0, 0 } },
					trail = "head", fx = { "dust", { "symbols", symbols = { "🎈" }, count = 2, radius = 2, color = SKY } }, hitText = "( TONK )",
				},
				-- K : il fait tournoyer un ballon d'eau géant au bout de sa ficelle et le balance comme une massue
				K_neutral = {
					label = "Ballon-massue", startup = 0.18, active = 0.12, recovery = 0.3,
					damage = 11, hitbox = box(5.5, 4, 3, 0.8), kbBase = 30, kbGrowth = 68, kbAngle = 36,
					windup = { Root = { 6, -30, 0, 0, -0.15, 0.2 }, Waist = { 8, -34, 0 }, Neck = { 0, 24, 0 }, RS = { 170, 0, 50 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 70, 0, 0 } },
					strike = { Root = { -10, 24, 0, 0, -0.3, -0.35 }, Waist = { -12, 30, 0 }, Neck = { -6, -16, 0 }, RS = { 80, 0, -10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					follow = { Root = { -12, 30, 0, 0, -0.32, -0.4 }, Waist = { -14, 36, 0 }, Neck = { -8, -20, 0 }, RS = { 60, 0, -24 }, RE = { 6, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					trail = "prop", fx = { { "burst", color = SKY, size = 2.5, at = "front" } }, hitText = "( SPLASH )",
				},
				-- →K : il lâche tout le bouquet en éventail, trois ballons qui dérivent vers l'avant
				K_side = {
					label = "Lâcher de bouquet", kind = "projectile", startup = 0.2, active = 0, recovery = 0.34,
					damage = 9, kbBase = 28, kbGrowth = 58, kbAngle = 30,
					projectile = { speed = 60, angle = 5, gravity = -10, lifetime = 0.5, size = 1.4, color = PINK, aim = false, fan = { count = 3, from = -10, to = 20 },
						visual = { shape = "ball", size = 1.3, color = RED, transparency = 0.5, spin = 3 } },
					windup = { Root = { 6, 0, 0, 0, -0.2, 0.2 }, Waist = { 10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 110, 0, 0 } },
					strike = { Root = { -14, 0, 0, 0, -0.3, -0.4 }, Waist = { -16, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 100, 0, 30 }, RE = { 0, 0, 0 }, RW = { 0, 0, 40 }, LS = { 100, 0, -30 }, LE = { 0, 0, 0 }, LW = { 0, 0, -40 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					follow = { Root = { -16, 0, 0, 0, -0.32, -0.44 }, Waist = { -18, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 104, 0, 34 }, RE = { 0, 0, 0 }, RW = { 0, 0, 44 }, LS = { 104, 0, -34 }, LE = { 0, 0, 0 }, LW = { 0, 0, -44 }, FL = { 0, 0, 0, 0, 0, -0.48 } },
					hideProp = "ballons", fx = { { "symbols", symbols = { "🎈", "🎈" }, count = 3, radius = 2.5, at = "front" } }, text = "( ENVOLEZ-VOUS )", hitText = "( POUF )",
				},
				-- ↓K : il noue un ballon à la cheville d'en face : le ballon le soulève tout doucement… puis d'un coup
				K_down = {
					label = "Ballon à la cheville", startup = 0.18, active = 0.12, recovery = 0.32,
					damage = 10, hitbox = box(6, 2, 3.5, -1.5), kbBase = 28, kbGrowth = 60, kbAngle = 86,
					windup = { Root = { 10, 0, 0, 0, -0.85, 0.1 }, Waist = { 16, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 50, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -20 }, LE = { 110, 0, 0 } },
					strike = { Root = { 14, 0, 0, 0, -0.95, -0.2 }, Waist = { 24, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 60, 0, 0 }, RE = { 30, 0, 0 }, RW = { 60, 0, 0 }, LS = { 60, 0, -10 }, LE = { 30, 0, 0 }, LW = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { -4, 0, 0, 0, -0.3, -0.1 }, Waist = { -6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 170, 0, 20 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 60, 0, 0 } },
					fx = { { "symbols", symbols = { "🎈", "▲" }, count = 3, radius = 2, at = "front", color = PINK } }, text = "( NŒUD )", hitText = "( ET HOP )",
				},
				-- ↑K : il balance un ballon d'eau droit au plafond, qui éclate sur ce qui passe au-dessus
				K_up = {
					label = "Ballon d'eau au plafond", kind = "projectile", startup = 0.18, active = 0, recovery = 0.32,
					damage = 11, kbBase = 30, kbGrowth = 65, kbAngle = 85,
					status = { name = "wet", duration = 1 },
					projectile = { speed = 60, angle = 78, gravity = 50, lifetime = 0.5, size = 1.6, color = SKY, aim = false,
						visual = { shape = "ball", size = 1.4, color = SKY, transparency = 0.4, spin = 4 } },
					windup = { Root = { 8, 0, 0, 0, -0.4, 0.1 }, Waist = { 12, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 20, 0, 20 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 80, 0, 0 } },
					strike = { Root = { -8, 0, 0, 0, 0.1, -0.1 }, Waist = { -12, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 176, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -40 }, LE = { 60, 0, 0 }, FR = { 0, 0, 0, 0, 0.12, 0 }, FL = { 0, 0, 0, 0, 0.12, 0 } },
					follow = { Root = { -10, 0, 0, 0, 0.12, -0.12 }, Waist = { -14, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 182, 0, 12 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 16, 0, -42 }, LE = { 60, 0, 0 }, FR = { 0, 0, 0, 0, 0.14, 0 }, FL = { 0, 0, 0, 0, 0.14, 0 } },
					trail = "rightHand", hitText = "( SPLATCH )",
				},
				-- K en l'air : suspendu aux ballons, il pédale dans le vide et ses pieds tapent sous lui
				K_air = {
					label = "Pédalage suspendu", startup = 0.12, active = 0.2, recovery = 0.2,
					damage = 10, hits = 2, hitbox = box(5, 4, 1.5, -1), kbBase = 24, kbGrowth = 50, kbAngle = -40,
					windup = { Root = { -6, 0, 0 }, Waist = { -6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 182, 0, 10 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 60, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { -20, 0, 0 }, LK = { -40, 0, 0 } },
					strike = { Root = { 4, 0, 0 }, Waist = { 6, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 184, 0, 12 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 60, 0, 0 }, RH = { 10, 0, 0 }, RK = { -10, 0, 0 }, RA = { -20, 0, 0 }, LH = { 70, 0, 0 }, LK = { -110, 0, 0 } },
					follow = { Root = { 4, 0, 0 }, Waist = { 6, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 184, 0, 12 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 60, 0, 0 }, RH = { 70, 0, 0 }, RK = { -110, 0, 0 }, LH = { 10, 0, 0 }, LK = { -10, 0, 0 }, LA = { -20, 0, 0 } },
					trail = "bothFeet", hitText = "( TAC TAC )",
				},
				-- dash K : il s'accroche aux ballons et plane en avant, les deux pieds en avant comme un train d'atterrissage
				K_dash = {
					label = "Vol plané", startup = 0.1, active = 0.24, recovery = 0.3,
					damage = 11, hitbox = box(6, 3, 3, 0), kbBase = 30, kbGrowth = 62, kbAngle = 38, selfVelocity = Vector2.new(50, 14),
					windup = { Root = { -8, 0, 0, 0, -0.3, 0 }, Waist = { -8, 0, 0 }, RS = { 180, 0, 10 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -10 }, LE = { 10, 0, 0 } },
					strike = { Root = { 18, 0, 0, 0, -0.2, 0.1 }, Waist = { 8, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 184, 0, 12 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 176, 0, -12 }, LE = { 10, 0, 0 }, RH = { 88, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 }, LH = { 84, 0, 0 }, LK = { -6, 0, 0 } },
					follow = { Root = { 22, 0, 0, 0, -0.2, 0.14 }, Waist = { 10, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 186, 0, 14 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 178, 0, -14 }, LE = { 10, 0, 0 }, RH = { 92, 0, 0 }, RK = { 0, 0, 0 }, RA = { 14, 0, 0 }, LH = { 88, 0, 0 }, LK = { -6, 0, 0 } },
					trail = "bothFeet", fx = { { "symbols", symbols = { "🎈", "( FIOU )" }, count = 3, radius = 2, color = WHITE } }, hitText = "( BOUM )",
				},
				-- L : salve de ballons, quatre ballons lâchés d'un coup qui filent tous sur l'adversaire
				S_neutral = {
					label = "Salve de ballons", kind = "projectile", startup = 0.22, active = 0, recovery = 0.45,
					damage = 5, kbBase = 22, kbGrowth = 40, kbAngle = 30,
					projectile = { speed = 70, angle = 0, gravity = 0, lifetime = 0.7, size = 1.5, color = PINK, fan = { count = 4, from = -12, to = 12 },
						visual = { shape = "ball", size = 1.3, color = PINK, transparency = 0.5, spin = 3 } },
					windup = { Root = { 4, 0, 0, 0, -0.2, 0.2 }, Waist = { 8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 170, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -20 }, LE = { 30, 0, 0 } },
					strike = { Root = { -12, 0, 0, 0, -0.3, -0.35 }, Waist = { -14, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 96, 0, 20 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 96, 0, -20 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -14, 0, 0, 0, -0.32, -0.4 }, Waist = { -16, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 100, 0, 24 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 100, 0, -24 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					hideProp = "ballons", fx = { { "burst", color = PINK, size = 2.5, at = "hand" }, { "symbols", symbols = { "🎈" }, count = 4, radius = 3, at = "front" } }, text = "( FEU )", hitText = "( POC POC )",
				},
				-- →L : il sculpte un chien en ballon, le pose au sol et siffle : le chien fonce sur l'adversaire et le mord
				S_side = {
					label = "Chien en ballon", kind = "projectile", startup = 0.24, active = 0, recovery = 0.48,
					damage = 14, kbBase = 30, kbGrowth = 58, kbAngle = 30,
					projectile = { speed = 62, angle = 0, gravity = 0, lifetime = 0.9, size = 2, color = PINK, homing = 0.4, from = "feet",
						visual = { shape = "ball", size = 1.1, color = PINK, transparency = 0.4, spin = 0,
							parts = { { "ball", Vector3.new(1.4, 0.8, 0.8), Vector3.new(0, -0.1, 0.9), PINK }, { "ball", Vector3.new(0.5, 0.5, 0.5), Vector3.new(0, -0.6, 1.4), PINK }, { "ball", Vector3.new(0.5, 0.5, 0.5), Vector3.new(0, -0.6, 0.3), PINK }, { "ball", Vector3.new(0.3, 0.6, 0.3), Vector3.new(0, 0.5, 1.6), PINK } } } },
					windup = { Root = { 8, 0, 0, 0, -0.3, 0.1 }, Waist = { 12, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 70, 0, 20 }, RE = { 110, 0, 0 }, RW = { 40, 0, 0 }, LS = { 70, 0, -20 }, LE = { 110, 0, 0 }, LW = { -40, 0, 0 } },
					strike = { Root = { 14, 0, 0, 0, -0.75, -0.1 }, Waist = { 24, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 50, 0, 10 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { -4, 0, 0, 0, -0.25, -0.2 }, Waist = { -6, 0, 0 }, Neck = { 4, 0, 0 }, RS = { 96, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 110, 0, -30 }, LE = { 130, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
					windupFx = { { "symbols", symbols = { "( COUIC )", "( COUIC )" }, count = 2, radius = 2, color = WHITE } }, fx = { { "symbols", symbols = { "🐕", "( SIFFLE )" }, count = 3, radius = 2.5, at = "front", color = WHITE } },
					text = "( AU PIED )", hitText = "( WAF )",
				},
				-- ↓L : ballon d'eau géant, posé par terre, qu'il pousse du pied : il roule et explose sur l'adversaire
				S_down = {
					label = "Ballon d'eau géant", kind = "projectile", startup = 0.24, active = 0, recovery = 0.48,
					damage = 14, kbBase = 30, kbGrowth = 55, kbAngle = 40,
					status = { name = "wet", duration = 2 },
					projectile = { speed = 55, angle = 15, gravity = 55, lifetime = 0.8, size = 3, color = SKY, from = "feet",
						visual = { shape = "ball", size = 2.6, color = SKY, transparency = 0.35, spin = 6 } },
					windup = { Root = { 10, 0, 0, 0, -0.6, 0.1 }, Waist = { 18, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 40 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 90, 0, 0 }, RH = { -30, 0, 0 }, RK = { -60, 0, 0 } },
					strike = { Root = { 8, 0, 0, 0, -0.2, 0 }, Waist = { 10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 40, 0, 50 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -50 }, LE = { 30, 0, 0 }, RH = { 95, 0, 0 }, RK = { -4, 0, 0 }, RA = { 10, 0, 0 } },
					follow = { Root = { 10, 0, 0, 0, -0.2, 0.04 }, Waist = { 12, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 44, 0, 54 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 44, 0, -54 }, LE = { 30, 0, 0 }, RH = { 104, 0, 0 }, RK = { 0, 0, 0 }, RA = { 14, 0, 0 } },
					trail = "rightFoot", fx = { { "ring", color = SKY, radius = 4, at = "feet" } }, text = "( ROULE )", hitText = "( SPLAAASH )",
				},
				-- ↑L : il saisit le bouquet à deux mains, une rafale l'emporte en diagonale, jambes qui pendent comme un pantin
				S_up = {
					label = "Envol en bouquet", startup = 0.15, active = 0.3, recovery = 0.4,
					damage = 13, hitbox = box(10, 11, 3, 4), kbBase = 30, kbGrowth = 52, kbAngle = 72, selfVelocity = Vector2.new(42, 80),
					windup = { Root = { 6, 0, 0, 0, -0.6, 0.1 }, Waist = { -10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 100, 0, 10 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 100, 0, -10 }, LE = { 110, 0, 0 } },
					strike = { Root = { -36, 0, 0, 0, 0.3, 0 }, Waist = { -6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 184, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 184, 0, -10 }, LE = { 0, 0, 0 }, RH = { -20, 0, 6 }, RK = { -40, 0, 0 }, RA = { -30, 0, 0 }, LH = { -30, 0, -6 }, LK = { -50, 0, 0 }, LA = { -30, 0, 0 } },
					follow = { Root = { -40, 0, 0, 0, 0.35, 0 }, Waist = { -8, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 188, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 188, 0, -12 }, LE = { 0, 0, 0 }, RH = { -26, 0, 8 }, RK = { -48, 0, 0 }, RA = { -30, 0, 0 }, LH = { -36, 0, -8 }, LK = { -58, 0, 0 }, LA = { -30, 0, 0 } },
					trail = "prop", fx = { { "ring", color = WIND, radius = 4, at = "feet" }, { "particles", tex = "smoke", color = WIND, dir = "up", at = "feet", time = 0.35, speed = 16, size = 0.7, rate = 60 }, { "symbols", symbols = { "🎈", "🎈", "( FIOU )" }, count = 4, radius = 2, color = WHITE } },
					text = "…", hitText = "( POC )",
				},
				-- L en l'air : pluie de ballons d'eau lâchés sous lui, qui éclatent tous sur l'adversaire
				S_air = {
					label = "Pluie de ballons d'eau", kind = "projectile", startup = 0.15, active = 0, recovery = 0.4,
					damage = 6, kbBase = 22, kbGrowth = 42, kbAngle = -40,
					status = { name = "wet", duration = 1 },
					projectile = { speed = 60, angle = -70, gravity = 40, lifetime = 0.7, size = 1.4, color = SKY, rain = { count = 4, spread = 6 },
						visual = { shape = "ball", size = 1.2, color = SKY, transparency = 0.4, spin = 3 } },
					windup = { Root = { 8, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 176, 0, 16 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 176, 0, -16 }, LE = { 40, 0, 0 }, RH = { 40, 0, 0 }, RK = { -80, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { -12, 0, 0 }, Waist = { -26, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 24, 0, 12 }, RE = { 0, 0, 0 }, RW = { -40, 0, 0 }, LS = { 24, 0, -12 }, LE = { 0, 0, 0 }, LW = { -40, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -16, 0, 0 }, Waist = { -30, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 18, 0, 14 }, RE = { 4, 0, 0 }, RW = { -50, 0, 0 }, LS = { 18, 0, -14 }, LE = { 4, 0, 0 }, LW = { -50, 0, 0 }, RH = { 16, 0, 0 }, RK = { -36, 0, 0 }, LH = { 26, 0, 0 }, LK = { -56, 0, 0 } },
					hideProp = "ballons", fx = { { "burst", color = SKY, size = 2, at = "feet" } }, text = "( LÂCHEZ TOUT )", hitText = "( SPLOTCH )",
				},
				-- Y : le bouquet infini, il tire du béret un bouquet sans fin et huit ballons en éventail filent sur l'adversaire
				SUPER = {
					label = "Le Bouquet infini !", kind = "projectile", startup = 0.35, active = 0, recovery = 0.6,
					damage = 4, kbBase = 24, kbGrowth = 40, kbAngle = 40,
					status = { name = "laughing", duration = 2 },
					projectile = { speed = 72, angle = 0, gravity = 0, lifetime = 1.0, size = 1.6, color = PINK, fan = { count = 8, from = -24, to = 36 },
						visual = { shape = "ball", size = 1.3, color = RED, transparency = 0.5, spin = 4 } },
					windup = { Root = { 0, 0, 0, 0, -0.2, 0 }, Waist = { 4, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 150, 0, -30 }, RE = { 130, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 60, 0, 0 } },
					strike = { Root = { -10, 0, 0, 0, -0.3, -0.3 }, Waist = { -12, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 100, 0, 30 }, RE = { 0, 0, 0 }, RW = { 0, 0, 40 }, LS = { 100, 0, -30 }, LE = { 0, 0, 0 }, LW = { 0, 0, -40 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -12, 0, 0, 0, -0.32, -0.34 }, Waist = { -14, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 104, 0, 34 }, RE = { 0, 0, 0 }, RW = { 0, 0, 44 }, LS = { 104, 0, -34 }, LE = { 0, 0, 0 }, LW = { 0, 0, -44 }, FL = { 0, 0, 0, 0, 0, -0.44 } },
					hideProp = "ballons", windupFx = { "super", { "symbols", symbols = { "🎩", "🎈" }, count = 6, radius = 3, color = PINK } },
					fx = { { "burst", color = PINK, size = 4, at = "hand" }, { "symbols", symbols = { "🎈", "🎈", "🎈" }, count = 8, radius = 4, at = "front" }, { "shake", amount = 0.3 } },
					text = "( TADAAA )", hitText = "( POC POC POC )",
				},
				-- →Y : la montgolfière, il gonfle un ballon jusqu'à la taille d'une montgolfière et la pousse : elle emporte tout le couloir
				SUPER_side = {
					label = "La Montgolfière !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.7,
					damage = 24, kbBase = 46, kbGrowth = 94, kbAngle = 22,
					projectile = { speed = 78, angle = 0, gravity = 0, lifetime = 0.9, size = 3.6, color = RED, pierce = true,
						visual = { shape = "ball", size = 3.2, color = RED, transparency = 0.4, spin = 2,
							parts = { { "block", Vector3.new(1.2, 0.8, 1.2), Vector3.new(0, -2.3, 0), CUIR }, { "cyl", Vector3.new(0.08, 1.2, 0.08), Vector3.new(0.5, -1.6, 0.5), WHITE }, { "cyl", Vector3.new(0.08, 1.2, 0.08), Vector3.new(-0.5, -1.6, -0.5), WHITE } } } },
					windup = { Root = { 8, 0, 0, 0, -0.3, 0.2 }, Waist = { 14, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 60, 0, 10 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 120, 0, 0 } },
					strike = { Root = { -18, 0, 0, 0, -0.4, -0.5 }, Waist = { -16, 0, 0 }, Neck = { 4, 0, 0 }, RS = { 96, 0, 14 }, RE = { 0, 0, 0 }, RW = { 85, 0, 0 }, LS = { 96, 0, -14 }, LE = { 0, 0, 0 }, LW = { 85, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.6 } },
					follow = { Root = { -20, 0, 0, 0, -0.42, -0.55 }, Waist = { -18, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 100, 0, 16 }, RE = { 0, 0, 0 }, RW = { 85, 0, 0 }, LS = { 100, 0, -16 }, LE = { 0, 0, 0 }, LW = { 85, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.62 } },
					shake = true, hideProp = "ballons", windupFx = { "super", { "symbols", symbols = { "( FFFFF )" }, count = 3, radius = 2, color = WHITE } },
					fx = { { "burst", color = RED, size = 4, at = "front" }, { "particles", tex = "fire", color = Color3.fromRGB(255, 180, 60), dir = "up", at = "front", time = 0.4, speed = 10, size = 0.8 }, { "shake", amount = 0.3 } },
					text = "( BON VOYAGE )", hitText = "( EMPORTÉ )",
				},
				-- ↑Y : le vol du mime, accroché au bouquet, il s'élève à la verticale… et tout le couloir avec lui
				SUPER_up = {
					label = "Le Vol du mime !", startup = 0.35, active = 0.3, recovery = 0.7,
					damage = 24, hitbox = box(14, 8, 7, 2), kbBase = 46, kbGrowth = 95, kbAngle = 88, invuln = 0.3, selfVelocity = Vector2.new(0, 58),
					windup = { Root = { 0, 0, 0, 0, -0.8, 0 }, Waist = { -16, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 120, 0, 10 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -10 }, LE = { 100, 0, 0 } },
					strike = { Root = { 0, 0, 0, 0, 0.45, 0 }, Waist = { 0, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 186, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 186, 0, -6 }, LE = { 0, 0, 0 }, RH = { -20, 0, 8 }, RK = { -50, 0, 0 }, RA = { -30, 0, 0 }, LH = { -10, 0, -8 }, LK = { -40, 0, 0 }, LA = { -30, 0, 0 } },
					follow = { Root = { 0, 0, 0, 0, 0.5, 0 }, Waist = { 0, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 188, 0, 8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 188, 0, -8 }, LE = { 0, 0, 0 }, RH = { -26, 0, 10 }, RK = { -56, 0, 0 }, RA = { -30, 0, 0 }, LH = { -14, 0, -10 }, LK = { -46, 0, 0 }, LA = { -30, 0, 0 } },
					hold = 0.2, trail = "prop", windupFx = { "super", { "symbols", symbols = { "🎈", "🎈", "🎈" }, count = 6, radius = 3, color = PINK } },
					fx = { { "pillar", color = PINK, height = 24, width = 6, at = "front" }, { "ring", color = WIND, radius = 7, at = "feet" }, { "particles", tex = "smoke", color = WIND, dir = "down", at = "feet", time = 0.5, speed = 14, size = 0.8 } },
					text = "…", hitText = "( ENVOLÉ )",
				},
				-- ↓Y : le ballon d'eau du siècle, il siffle et un ballon d'eau gros comme une maison tombe du ciel sur l'adversaire
				SUPER_down = {
					label = "Ballon d'eau du siècle !", kind = "projectile", startup = 0.38, active = 0, recovery = 0.7,
					damage = 26, kbBase = 44, kbGrowth = 90, kbAngle = 70,
					status = { name = "wet", duration = 3 },
					projectile = { speed = 60, gravity = 60, lifetime = 1.0, size = 5, color = SKY, rain = { count = 1, spread = 0.5, ahead = 8, height = 22 },
						visual = { shape = "ball", size = 4.6, color = SKY, transparency = 0.35, spin = 2 } },
					windup = { Root = { 0, 0, 0, 0, -0.15, 0 }, Waist = { 4, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 60, 0, 10 }, RE = { 130, 0, 0 }, RW = { 0, 0, 0 }, LS = { 176, 0, -20 }, LE = { 10, 0, 0 } },
					strike = { Root = { 6, 0, 0, 0, -0.2, 0.1 }, Waist = { 8, 0, 0 }, Neck = { 36, 0, 0 }, RS = { 40, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -40 }, LE = { 10, 0, 0 } },
					follow = { Root = { 10, 0, 0, 0, -0.3, 0.2 }, Waist = { 12, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 110, 0, 20 }, RE = { 130, 0, 0 }, RW = { 0, 0, 0 }, LS = { 110, 0, -20 }, LE = { 130, 0, 0 } },
					windupFx = { "super", { "symbols", symbols = { "( SIFFLE )", "▼" }, count = 3, radius = 2, color = WHITE } },
					fx = { { "burst", color = SKY, size = 5, at = "above" }, { "puddle", color = SKY, width = 12, time = 2 }, { "shake", amount = 0.5 } },
					text = "( ATTENTION LÀ-HAUT )", hitText = "( SPLAAAAASH )",
				},
			},
			links = {
				P_neutral = { P = "P_side", K = "K_neutral", S = "S_neutral" },
				P_side = { P = "P_up", K = "K_side", S = "S_side" },
				P_down = { P = "P_up", K = "K_down", S = "S_down" },
				K_neutral = { P = "P_neutral", K = "K_up", S = "S_side" },
				P_dash = { P = "P_neutral", K = "K_side", S = "S_neutral" },
				K_dash = { P = "P_up", S = "S_up" },
			},
		},
	},

	look = {
		body = {
			head = FACE, upper = WHITE, lower = BLACK, arms = WHITE, forearms = WHITE,
			hands = WHITE, legs = BLACK, feet = BLACK,
		},
		cubeHead = 1.25,
		parts = {
			-- béret penché et sa petite tige
			{ "Beret", "Head", "ball", Vector3.new(1.55, 0.45, 1.5), Vector3.new(0.15, 0.72, 0.02), Vector3.new(0, 0, -12), BLACK, "Fabric" },
			{ "TigeBeret", "Head", "cyl", Vector3.new(0.25, 0.09, 0.09), Vector3.new(0.12, 0.98, 0), Vector3.zero, BLACK, "Fabric" },
			-- maquillage de mime : yeux en amande, sourcils en accent circonflexe, larme, bouche rouge, pommettes
			{ "OeilG", "Head", "ball", Vector3.new(0.14, 0.27, 0.08), Vector3.new(-0.28, 0.14, -0.63), Vector3.zero, BLACK, "SmoothPlastic" },
			{ "OeilD", "Head", "ball", Vector3.new(0.14, 0.27, 0.08), Vector3.new(0.28, 0.14, -0.63), Vector3.zero, BLACK, "SmoothPlastic" },
			{ "SourcilG", "Head", "block", Vector3.new(0.32, 0.06, 0.05), Vector3.new(-0.3, 0.44, -0.64), Vector3.new(0, 0, 18), BLACK, "SmoothPlastic" },
			{ "SourcilD", "Head", "block", Vector3.new(0.32, 0.06, 0.05), Vector3.new(0.3, 0.44, -0.64), Vector3.new(0, 0, -18), BLACK, "SmoothPlastic" },
			{ "Larme", "Head", "block", Vector3.new(0.1, 0.1, 0.04), Vector3.new(0.3, -0.12, -0.64), Vector3.new(0, 0, 45), BLACK, "SmoothPlastic" },
			{ "Bouche", "Head", "block", Vector3.new(0.34, 0.1, 0.05), Vector3.new(0, -0.33, -0.64), Vector3.zero, RED, "SmoothPlastic" },
			{ "JoueG", "Head", "ball", Vector3.new(0.22, 0.15, 0.04), Vector3.new(-0.42, -0.14, -0.63), Vector3.zero, PINK, "SmoothPlastic", { transparency = 0.3 } },
			{ "JoueD", "Head", "ball", Vector3.new(0.22, 0.15, 0.04), Vector3.new(0.42, -0.14, -0.63), Vector3.zero, PINK, "SmoothPlastic", { transparency = 0.3 } },
			-- marinière : rayures marine, bretelles noires et foulard rouge
			{ "Rayure1", "UpperTorso", "block", Vector3.new(2.02, 0.16, 1.02), Vector3.new(0, 0.5, 0), Vector3.zero, NAVY, "Fabric" },
			{ "Rayure2", "UpperTorso", "block", Vector3.new(2.02, 0.16, 1.02), Vector3.new(0, 0.1, 0), Vector3.zero, NAVY, "Fabric" },
			{ "Rayure3", "UpperTorso", "block", Vector3.new(2.02, 0.16, 1.02), Vector3.new(0, -0.3, 0), Vector3.zero, NAVY, "Fabric" },
			{ "Rayure4", "UpperTorso", "block", Vector3.new(2.02, 0.16, 1.02), Vector3.new(0, -0.7, 0), Vector3.zero, NAVY, "Fabric" },
			{ "BretelleG", "UpperTorso", "block", Vector3.new(0.18, 1.62, 1.05), Vector3.new(-0.45, 0, 0), Vector3.zero, BLACK, "Fabric" },
			{ "BretelleD", "UpperTorso", "block", Vector3.new(0.18, 1.62, 1.05), Vector3.new(0.45, 0, 0), Vector3.zero, BLACK, "Fabric" },
			{ "Foulard", "UpperTorso", "block", Vector3.new(0.9, 0.26, 0.4), Vector3.new(0, 0.74, -0.38), Vector3.zero, RED, "Fabric" },
			{ "MancheRayeeG", "LeftUpperArm", "block", Vector3.new(1.04, 0.16, 1.04), Vector3.new(0, 0.05, 0), Vector3.zero, NAVY, "Fabric" },
			{ "MancheRayeeD", "RightUpperArm", "block", Vector3.new(1.04, 0.16, 1.04), Vector3.new(0, 0.05, 0), Vector3.zero, NAVY, "Fabric" },
		},
		props = {
			-- l'arme de la caisse : une canne invisible (on la devine à peine) et la manchette blanche du mime
			{ name = "PropCanne", hand = "Right", visible = true, pieces = {
				{ "Canne", "", "cyl", Vector3.new(3, 0.18, 0.18), Vector3.new(0, -1.5, 0), Vector3.zero, GHOST, "Glass", { transparency = 0.82 } },
				{ "Crosse", "", "ball", Vector3.new(0.5, 0.5, 0.2), Vector3.new(0, 0.12, -0.22), Vector3.zero, GHOST, "Glass", { transparency = 0.82 } },
				{ "Manchette", "", "cyl", Vector3.new(0.22, 0.85, 0.85), Vector3.new(0, 0.42, 0), Vector3.zero, WHITE, "Fabric" },
			} },
			-- accessoires mimés : corde, parapluie et ballon presque invisibles
			{ name = "PropCorde", hand = "Right", visible = false, pieces = {
				{ "Corde", "", "cyl", Vector3.new(5, 0.14, 0.14), Vector3.new(0, -2.5, 0), Vector3.zero, ROPE, "Fabric", { transparency = 0.75 } },
			} },
			{ name = "PropParapluie", hand = "Right", visible = false, pieces = {
				{ "Tige", "", "cyl", Vector3.new(2.6, 0.1, 0.1), Vector3.new(0, -1.3, 0), Vector3.zero, GHOST, "Glass", { transparency = 0.78 } },
				{ "Toile", "", "ball", Vector3.new(3.4, 1.2, 3.4), Vector3.new(0, -2.6, 0), Vector3.zero, GHOST, "Glass", { transparency = 0.8 } },
			} },
			{ name = "PropBallon", hand = "Right", visible = false, pieces = {
				{ "Ficelle", "", "cyl", Vector3.new(2, 0.05, 0.05), Vector3.new(0, -1, 0), Vector3.zero, WHITE, "SmoothPlastic", { transparency = 0.6 } },
				{ "Ballon", "", "ball", Vector3.new(1.7, 2, 1.7), Vector3.new(0, -2.9, 0), Vector3.zero, PINK, "Glass", { transparency = 0.8 } },
			} },
		},
	},

	moves = {
		------------------------------------------------------------------ Attaques légères (P)
		-- Fausse claque : grand armé théâtral de la main gauche, gifle à plat, la tête de Marcel accompagne le geste
		P_neutral = {
			label = "Fausse claque", startup = 0.07, active = 0.07, recovery = 0.14,
			damage = 5, hitbox = box(4, 3, 2.5, 1), kbBase = 18, kbGrowth = 22, kbAngle = 28,
			windup = { Root = { 2, 25, 0, 0, -0.15, 0.1 }, Waist = { 0, 25, 0 }, Neck = { 0, -15, 6 }, RS = { 20, 0, 20 }, RE = { 60, 0, 0 }, LS = { 85, 0, -95 }, LE = { 30, 0, 0 }, LW = { 0, 0, -30 } },
			strike = { Root = { -4, -15, 0, 0, -0.2, -0.2 }, Waist = { -4, -20, 0 }, Neck = { 0, 10, -6 }, RS = { 25, 0, 25 }, RE = { 60, 0, 0 }, LS = { 95, 0, 15 }, LE = { 5, 0, 0 }, LW = { 0, 0, 20 } },
			follow = { Root = { -4, -20, 0, 0, -0.2, -0.22 }, Waist = { -4, -26, 0 }, Neck = { 0, 14, -8 }, RS = { 25, 0, 25 }, RE = { 60, 0, 0 }, LS = { 90, 0, 35 }, LE = { 10, 0, 0 }, LW = { 0, 0, 30 } },
			trail = "leftHand", text = "…", hitText = "( CLAC )",
		},
		-- Coup de canne invisible : il fait tournoyer la canne qu'on ne voit pas et frappe d'un revers sec
		P_combo2 = {
			label = "Coup de canne invisible", startup = 0.07, active = 0.08, recovery = 0.16,
			damage = 5, hitbox = box(5, 4, 3, 0.8), kbBase = 18, kbGrowth = 24, kbAngle = 30,
			windup = { Root = { 2, -20, 0, 0, -0.18, 0.1 }, Waist = { 2, -25, 0 }, Neck = { 0, 15, 0 }, RS = { 70, 0, 80 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -40 }, LE = { 90, 0, 0 } },
			strike = { Root = { -6, 18, 0, 0, -0.22, -0.28 }, Waist = { -6, 22, 0 }, Neck = { 0, -12, 0 }, RS = { 95, 0, -5 }, RE = { 5, 0, 0 }, RW = { -80, 0, 0 }, LS = { 25, 0, -45 }, LE = { 90, 0, 0 } },
			follow = { Root = { -8, 22, 0, 0, -0.24, -0.32 }, Waist = { -8, 26, 0 }, Neck = { 0, -14, 0 }, RS = { 92, 0, -20 }, RE = { 8, 0, 0 }, RW = { -85, 0, 0 }, LS = { 25, 0, -45 }, LE = { 90, 0, 0 } },
			trail = "prop", hitText = "( TOC )",
		},
		-- P P P P : Grand coup de canne, la canne invisible levée à deux mains comme un marteau de foire, puis abattue (finition)
		P_combo3 = {
			label = "Grand coup de canne", startup = 0.1, active = 0.1, recovery = 0.3,
			damage = 10, hitbox = box(5.5, 4.5, 3, 1), kbBase = 36, kbGrowth = 78, kbAngle = 48,
			windup = { Root = { 10, 0, 0, 0, 0.05, 0.2 }, Waist = { 14, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 190, 0, 5 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 185, 0, 5 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0.15, 0 }, FL = { 0, 0, 0, 0, 0.15, 0 } },
			strike = { Root = { -14, 0, 0, 0, -0.45, -0.35 }, Waist = { -26, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 75, 0, -5 }, RE = { 0, 0, 0 }, RW = { -40, 0, 0 }, LS = { 75, 0, 15 }, LE = { 10, 0, 0 } },
			follow = { Root = { -18, 0, 0, 0, -0.52, -0.4 }, Waist = { -30, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 55, 0, -5 }, RE = { 0, 0, 0 }, RW = { -55, 0, 0 }, LS = { 55, 0, 15 }, LE = { 10, 0, 0 } },
			trail = "prop", fx = { { "ring", color = GHOST, radius = 3.5, at = "front" } }, text = "…!", hitText = "( BOUM )",
		},
		-- Corde tirée : il lance une corde invisible, puis tire main sur main, penché en arrière : l'adversaire vient à lui
		P_side = {
			label = "Corde tirée", startup = 0.1, active = 0.12, recovery = 0.2,
			damage = 6, hitbox = box(7, 3, 4, 0.6), kbBase = 18, kbGrowth = 15, kbAngle = 12, pull = true,
			windup = { Root = { -8, 0, 0, 0, -0.2, -0.2 }, Waist = { -10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 95, 0, 5 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, 5 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
			strike = { Root = { 14, -10, 0, 0, -0.35, 0.35 }, Waist = { 16, -10, 0 }, Neck = { 10, 0, 0 }, RS = { 70, 0, 10 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 85, 0, -5 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { 18, -14, 0, 0, -0.4, 0.45 }, Waist = { 20, -12, 0 }, Neck = { 12, 0, 0 }, RS = { 40, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -5 }, LE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			prop = "corde", hideProp = "canne", text = "…", hitText = "( HISSE )",
		},
		-- Marche d'escalier invisible : il descend une marche qui n'existe pas et écrase les orteils d'en face
		P_down = {
			label = "Marche d'escalier invisible", startup = 0.09, active = 0.08, recovery = 0.18,
			damage = 6, hitbox = box(4.5, 2, 2.4, -2), kbBase = 24, kbGrowth = 22, kbAngle = 70,
			windup = { Root = { 2, 0, 0, 0, 0.05, 0 }, Waist = { 4, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 15, 0, 35 }, RE = { 30, 0, 0 }, LS = { 15, 0, -35 }, LE = { 30, 0, 0 }, RH = { 70, 0, 0 }, RK = { -95, 0, 0 }, RA = { 10, 0, 0 } },
			strike = { Root = { -6, 0, 0, 0, -0.5, -0.15 }, Waist = { -8, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 20, 0, 45 }, RE = { 20, 0, 0 }, LS = { 20, 0, -45 }, LE = { 20, 0, 0 }, RH = { 35, 0, 0 }, RK = { -10, 0, 0 }, RA = { -15, 0, 0 } },
			follow = { Root = { -6, 0, 0, 0, -0.6, -0.18 }, Waist = { -10, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 22, 0, 48 }, RE = { 20, 0, 0 }, LS = { 22, 0, -48 }, LE = { 20, 0, 0 }, RH = { 32, 0, 0 }, RK = { -12, 0, 0 }, RA = { -15, 0, 0 } },
			trail = "rightFoot", hitText = "( AÏE MES ORTEILS )",
		},
		-- Parapluie invisible (anti-air) : il ouvre d'un geste sec un parapluie au-dessus de son béret
		P_up = {
			label = "Parapluie invisible", startup = 0.08, active = 0.12, recovery = 0.2,
			damage = 7, hitbox = box(5, 4, 1, 3.8), kbBase = 26, kbGrowth = 32, kbAngle = 86,
			windup = { Root = { -4, 0, 0, 0, -0.35, 0 }, Waist = { -6, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 40, 0, 10 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 100, 0, 0 } },
			strike = { Root = { 4, 0, 0, 0, 0.15, 0 }, Waist = { 8, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 172, 0, 5 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -50 }, LE = { 30, 0, 0 }, LW = { 0, 0, -40 }, FR = { 0, 0, 0, 0, 0.15, 0 }, FL = { 0, 0, 0, 0, 0.15, 0 } },
			follow = { Root = { 4, 0, 0, 0, 0.15, 0 }, Waist = { 8, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 176, 0, 5 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 5, 0, -55 }, LE = { 30, 0, 0 }, LW = { 0, 0, -50 } },
			prop = "parapluie", hideProp = "canne", fx = { { "ring", color = GHOST, radius = 3, at = "above" } }, hitText = "( FLOP )",
		},
		-- Parapluie invisible en l'air : parapluie fermé tenu comme une épée, grand coup de haut en bas devant lui
		P_air = {
			label = "Coup de parapluie", startup = 0.08, active = 0.1, recovery = 0.16,
			damage = 7, hitbox = box(4.5, 4, 2.4, 0), kbBase = 22, kbGrowth = 32, kbAngle = 32,
			windup = { Root = { 10, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 175, 0, 15 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -60 }, LE = { 30, 0, 0 }, LW = { 0, 0, -30 }, RH = { 70, 0, 0 }, RK = { -110, 0, 0 }, LH = { 40, 0, 0 }, LK = { -60, 0, 0 } },
			strike = { Root = { -10, 0, 0 }, Waist = { -16, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 85, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -70 }, LE = { 20, 0, 0 }, LW = { 0, 0, -40 }, RH = { 30, 0, 0 }, RK = { -60, 0, 0 }, LH = { 60, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { -14, 0, 0 }, Waist = { -20, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 60, 0, 5 }, RE = { 0, 0, 0 }, RW = { -15, 0, 0 }, LS = { 25, 0, -72 }, LE = { 20, 0, 0 }, LW = { 0, 0, -40 }, RH = { 25, 0, 0 }, RK = { -55, 0, 0 }, LH = { 65, 0, 0 }, LK = { -100, 0, 0 } },
			prop = "parapluie", hideProp = "canne", trail = "rightHand", hitText = "( PAF )",
		},
		-- Porte invisible (dash puis P) : il tourne une poignée imaginaire et ouvre la porte en grand… dans le nez d'en face
		P_dash = {
			label = "Porte invisible", startup = 0.08, active = 0.14, recovery = 0.25,
			damage = 8, hitbox = box(4.5, 4.5, 2.4, 0.8), kbBase = 28, kbGrowth = 50, kbAngle = 28, selfVelocity = Vector2.new(40, 0),
			windup = { Root = { -4, 15, 0, 0, -0.2, 0.1 }, Waist = { -4, 15, 0 }, Neck = { 0, -10, 0 }, RS = { 70, 0, -30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 80, 0, 0 } },
			strike = { Root = { -12, -20, 0, 0, -0.3, -0.3 }, Waist = { -10, -25, 0 }, Neck = { 0, 15, 0 }, RS = { 85, 0, 60 }, RE = { 10, 0, 0 }, RW = { 0, 0, 30 }, LS = { 30, 0, -40 }, LE = { 70, 0, 0 } },
			follow = { Root = { -14, -26, 0, 0, -0.32, -0.35 }, Waist = { -12, -30, 0 }, Neck = { 0, 18, 0 }, RS = { 80, 0, 80 }, RE = { 10, 0, 0 }, RW = { 0, 0, 30 }, LS = { 30, 0, -40 }, LE = { 70, 0, 0 } },
			trail = "rightHand", fx = { "dust" }, text = "( TOC TOC )", hitText = "( BLAM )",
		},

		------------------------------------------------------------------ Attaques lourdes (K)
		-- Pied imaginaire : il pose un ballon invisible devant lui, recule d'un pas et tire dedans de toutes ses forces
		K_neutral = {
			label = "Pied imaginaire", startup = 0.19, active = 0.1, recovery = 0.3,
			damage = 11, hitbox = box(5, 3, 3, -0.3), kbBase = 30, kbGrowth = 70, kbAngle = 38,
			windup = { Root = { 6, -8, 0, 0, -0.12, 0.25 }, Waist = { 10, -6, 0 }, Neck = { -15, 0, 0 }, RS = { -30, 0, 45 }, RE = { 20, 0, 0 }, LS = { 60, 0, -40 }, LE = { 20, 0, 0 }, LW = { 0, 0, -40 }, RH = { -45, 0, 0 }, RK = { -80, 0, 0 }, RA = { -20, 0, 0 } },
			strike = { Root = { 14, -2, 0, 0, -0.1, -0.05 }, Waist = { 16, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 70, 0, 50 }, RE = { 10, 0, 0 }, LS = { -30, 0, -55 }, LE = { 10, 0, 0 }, LW = { 0, 0, -40 }, RH = { 100, 0, 0 }, RK = { -4, 0, 0 }, RA = { 15, 0, 0 } },
			follow = { Root = { 18, 0, 0, 0, -0.1, 0 }, Waist = { 18, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 80, 0, 55 }, RE = { 10, 0, 0 }, LS = { -35, 0, -60 }, LE = { 10, 0, 0 }, LW = { 0, 0, -40 }, RH = { 115, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 } },
			trail = "rightFoot", hitText = "( BUT )",
		},
		-- Canne invisible : fente d'escrimeur, la canne tendue loin devant, le bras gauche levé derrière
		K_side = {
			label = "Canne invisible", startup = 0.2, active = 0.12, recovery = 0.32,
			damage = 13, hitbox = box(6.5, 2.5, 4, 0.8), kbBase = 32, kbGrowth = 82, kbAngle = 25, selfVelocity = Vector2.new(30, 0),
			windup = { Root = { 4, -40, 0, 0, -0.2, 0.3 }, Waist = { 4, -30, 0 }, Neck = { 0, 35, 0 }, RS = { 60, 0, 10 }, RE = { 110, 0, 0 }, RW = { -70, 0, 0 }, LS = { 150, 0, -40 }, LE = { 60, 0, 0 }, LW = { 30, 0, 0 } },
			strike = { Root = { -8, -55, 0, 0, -0.55, -0.6 }, Waist = { -4, -30, 0 }, Neck = { 0, 45, 0 }, RS = { 92, 0, 0 }, RE = { 0, 0, 0 }, RW = { -88, 0, 0 }, LS = { 150, 0, -70 }, LE = { 60, 0, 0 }, LW = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.7 } },
			follow = { Root = { -10, -58, 0, 0, -0.6, -0.65 }, Waist = { -6, -32, 0 }, Neck = { 0, 48, 0 }, RS = { 93, 0, 0 }, RE = { 0, 0, 0 }, RW = { -90, 0, 0 }, LS = { 152, 0, -72 }, LE = { 55, 0, 0 }, LW = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.75 } },
			trail = "prop", text = "( TOUCHÉ )", hitText = "( PIC )",
		},
		-- Glissade « contre le vent » : penché comme dans une tempête, il glisse en avant au ras du sol, bras devant
		K_down = {
			label = "Glissade contre le vent", startup = 0.17, active = 0.22, recovery = 0.32,
			damage = 11, hitbox = box(6, 2.5, 2.8, -1.5), kbBase = 30, kbGrowth = 60, kbAngle = 65, selfVelocity = Vector2.new(38, 0),
			windup = { Root = { 10, 0, 0, 0, -0.2, 0.2 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 120, 0, 20 }, RE = { 60, 0, 0 }, RW = { 60, 0, 0 }, LS = { 110, 0, -20 }, LE = { 60, 0, 0 }, LW = { 60, 0, 0 } },
			strike = { Root = { -40, 0, 0, 0, -0.9, -0.3 }, Waist = { -15, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 140, 0, 15 }, RE = { 10, 0, 0 }, RW = { 70, 0, 0 }, LS = { 140, 0, -15 }, LE = { 10, 0, 0 }, LW = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.6 } },
			follow = { Root = { -45, 0, 0, 0, -1.0, -0.35 }, Waist = { -18, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 150, 0, 15 }, RE = { 10, 0, 0 }, RW = { 70, 0, 0 }, LS = { 150, 0, -15 }, LE = { 10, 0, 0 }, LW = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.65 } },
			trail = "body", fx = { { "particles", tex = "smoke", color = WIND, dir = "all", at = "front", time = 0.3, speed = 12, size = 0.6 } }, hitText = "( FIOU )",
		},
		-- Moonwalk arrière : il recule en moonwalk, s'arrête net sur la pointe des pieds et lance un coup de talon vers le ciel
		K_up = {
			label = "Moonwalk arrière", startup = 0.2, active = 0.12, recovery = 0.3,
			damage = 12, hitbox = box(4.5, 5, 1.2, 3), kbBase = 32, kbGrowth = 74, kbAngle = 84, selfVelocity = Vector2.new(-22, 0),
			windup = { Root = { 0, 0, 0, 0, 0.1, 0.3 }, Waist = { 4, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 10, 0, 20 }, RE = { 40, 0, 0 }, LS = { 10, 0, -20 }, LE = { 40, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0.4 }, FL = { 0, 0, 0, 0, 0, -0.2 } },
			strike = { Root = { 25, 0, 0, 0, -0.05, 0.4 }, Waist = { 10, 0, 0 }, Neck = { 12, 0, 0 }, RS = { -30, 0, 55 }, RE = { 10, 0, 0 }, LS = { -30, 0, -55 }, LE = { 10, 0, 0 }, RH = { 155, 0, 0 }, RK = { -5, 0, 0 }, RA = { 25, 0, 0 } },
			follow = { Root = { 28, 0, 0, 0, -0.05, 0.45 }, Waist = { 12, 0, 0 }, Neck = { 14, 0, 0 }, RS = { -35, 0, 60 }, RE = { 10, 0, 0 }, LS = { -35, 0, -60 }, LE = { 10, 0, 0 }, RH = { 165, 0, 0 }, RK = { 0, 0, 0 }, RA = { 25, 0, 0 } },
			trail = "rightFoot", text = "( HI-HI )", hitText = "( POC )",
		},
		-- Ballon invisible : en l'air, reprise de volée dans un ballon que personne ne voit
		K_air = {
			label = "Ballon invisible", startup = 0.16, active = 0.12, recovery = 0.25,
			damage = 11, hitbox = box(5, 3.5, 2.8, 0), kbBase = 30, kbGrowth = 68, kbAngle = 38,
			windup = { Root = { -12, 15, 0 }, Waist = { -10, 10, 0 }, Neck = { -15, 0, 0 }, RS = { 60, 0, 50 }, RE = { 30, 0, 0 }, LS = { 80, 0, -40 }, LE = { 30, 0, 0 }, RH = { 40, 0, 0 }, RK = { -120, 0, 0 }, LH = { 60, 0, 0 }, LK = { -60, 0, 0 } },
			strike = { Root = { 22, -10, 0 }, Waist = { 14, -10, 0 }, Neck = { -10, 0, 0 }, RS = { -20, 0, 60 }, RE = { 20, 0, 0 }, LS = { 40, 0, -70 }, LE = { 20, 0, 0 }, RH = { 95, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 10, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { 26, -14, 0 }, Waist = { 16, -12, 0 }, Neck = { -10, 0, 0 }, RS = { -25, 0, 62 }, RE = { 20, 0, 0 }, LS = { 45, 0, -72 }, LE = { 20, 0, 0 }, RH = { 110, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 5, 0, 0 }, LK = { -95, 0, 0 } },
			trail = "rightFoot", hitText = "( POUM )",
		},
		-- Second pied imaginaire : il reprend le ballon invisible du pied gauche (suite de K)
		K_combo2 = {
			label = "Reprise du gauche", startup = 0.09, active = 0.1, recovery = 0.22,
			damage = 8, hitbox = box(5, 4, 3, 0.5), kbBase = 24, kbGrowth = 40, kbAngle = 32,
			windup = { Root = { 6, 10, 0, 0, -0.12, 0.2 }, Waist = { 8, 8, 0 }, Neck = { -12, 0, 0 }, RS = { 50, 0, 40 }, RE = { 20, 0, 0 }, LS = { -20, 0, -40 }, LE = { 20, 0, 0 }, LH = { -40, 0, 0 }, LK = { -80, 0, 0 } },
			strike = { Root = { 14, 4, 0, 0, -0.1, -0.05 }, Waist = { 14, 2, 0 }, Neck = { -8, 0, 0 }, RS = { -30, 0, 55 }, RE = { 10, 0, 0 }, LS = { 70, 0, -50 }, LE = { 10, 0, 0 }, LH = { 100, 0, 0 }, LK = { -4, 0, 0 }, LA = { 15, 0, 0 } },
			follow = { Root = { 16, 6, 0, 0, -0.1, 0 }, Waist = { 16, 2, 0 }, Neck = { -6, 0, 0 }, RS = { -35, 0, 60 }, RE = { 10, 0, 0 }, LS = { 80, 0, -55 }, LE = { 10, 0, 0 }, LH = { 112, 0, 0 }, LK = { 0, 0, 0 }, LA = { 18, 0, 0 } },
			trail = "leftFoot", hitText = "( PAM )",
		},
		-- K K ↑K : Ciseau muet, il saute, les jambes se croisent en l'air et la droite frappe en hauteur (finition)
		K_combo3 = {
			label = "Ciseau muet", startup = 0.1, active = 0.12, recovery = 0.3,
			damage = 12, hitbox = box(5.5, 4.5, 3, 1), kbBase = 36, kbGrowth = 82, kbAngle = 42, selfVelocity = Vector2.new(15, 42),
			windup = { Root = { -8, 0, 0, 0, -0.6, 0.1 }, Waist = { -12, 0, 0 }, RS = { 150, 0, 30 }, RE = { 20, 0, 0 }, LS = { 150, 0, -30 }, LE = { 20, 0, 0 } },
			strike = { Root = { 18, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 160, 0, 40 }, RE = { 10, 0, 0 }, LS = { 160, 0, -40 }, LE = { 10, 0, 0 }, RH = { 105, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { -20, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { 22, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 165, 0, 45 }, RE = { 10, 0, 0 }, LS = { 165, 0, -45 }, LE = { 10, 0, 0 }, RH = { 115, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { -25, 0, 0 }, LK = { -65, 0, 0 } },
			trail = "rightFoot", text = "…!", hitText = "( CRAC )",
		},
		-- Trottinette invisible (dash puis K) : un pied pousse, l'autre glisse, et le pied d'appel finit dans le tibia
		K_dash = {
			label = "Trottinette invisible", startup = 0.1, active = 0.22, recovery = 0.3,
			damage = 11, hitbox = box(5.5, 2.5, 3, -1.2), kbBase = 30, kbGrowth = 62, kbAngle = 40, selfVelocity = Vector2.new(52, 0),
			windup = { Root = { -6, 0, 0, 0, -0.25, 0 }, Waist = { -8, 0, 0 }, RS = { 70, 0, 10 }, RE = { 40, 0, 0 }, LS = { 70, 0, -10 }, LE = { 40, 0, 0 }, RH = { -30, 0, 0 }, RK = { -30, 0, 0 } },
			strike = { Root = { -8, 0, 0, 0, -0.35, -0.2 }, Waist = { -6, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 75, 0, 10 }, RE = { 35, 0, 0 }, LS = { 75, 0, -10 }, LE = { 35, 0, 0 }, RH = { 70, 0, 0 }, RK = { -5, 0, 0 }, RA = { 10, 0, 0 } },
			follow = { Root = { -10, 0, 0, 0, -0.35, -0.25 }, Waist = { -6, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 75, 0, 10 }, RE = { 35, 0, 0 }, LS = { 75, 0, -10 }, LE = { 35, 0, 0 }, RH = { 75, 0, 0 }, RK = { -5, 0, 0 }, RA = { 10, 0, 0 } },
			trail = "rightFoot", fx = { "dust" }, hitText = "( DRING )",
		},
		-- P puis K : Croc-en-jambe mimé, la pointe du pied fauche la cheville
		PK_combo = {
			label = "Croc-en-jambe mimé", startup = 0.08, active = 0.1, recovery = 0.2,
			damage = 7, hitbox = box(5.5, 4, 3, 0.5), kbBase = 22, kbGrowth = 30, kbAngle = 40,
			windup = { Root = { 2, -12, 0, 0, -0.18, 0.1 }, Waist = { 4, -10, 0 }, Neck = { -8, 10, 0 }, RS = { 20, 0, 40 }, RE = { 50, 0, 0 }, LS = { 20, 0, -40 }, LE = { 50, 0, 0 }, RH = { -15, 0, 15 }, RK = { -60, 0, 0 } },
			strike = { Root = { -6, 12, 0, 0, -0.28, -0.2 }, Waist = { -6, 12, 0 }, Neck = { -12, -10, 0 }, RS = { 10, 0, 50 }, RE = { 30, 0, 0 }, LS = { 30, 0, -50 }, LE = { 30, 0, 0 }, RH = { 55, 0, -10 }, RK = { -5, 0, 0 }, RA = { -30, 0, 0 } },
			follow = { Root = { -8, 16, 0, 0, -0.3, -0.24 }, Waist = { -8, 14, 0 }, Neck = { -12, -12, 0 }, RS = { 10, 0, 52 }, RE = { 30, 0, 0 }, LS = { 30, 0, -52 }, LE = { 30, 0, 0 }, RH = { 58, 0, -15 }, RK = { -6, 0, 0 }, RA = { -30, 0, 0 } },
			trail = "rightFoot", hitText = "( HOP )",
		},
		-- K puis P : Coup de poing à ressort, il remonte un ressort invisible dans son bras et le poing part tout seul
		KP_combo = {
			label = "Poing à ressort", startup = 0.08, active = 0.1, recovery = 0.2,
			damage = 7, hitbox = box(5, 4, 3, 0.8), kbBase = 22, kbGrowth = 35, kbAngle = 30,
			windup = { Root = { 2, -10, 0, 0, -0.18, 0.15 }, Waist = { 4, -14, 0 }, Neck = { 0, 10, 0 }, RS = { 40, 0, 10 }, RE = { 130, 0, 0 }, LS = { 50, 0, 30 }, LE = { 90, 0, 0 }, LW = { 0, 0, 60 } },
			strike = { Root = { -8, 12, 0, 0, -0.25, -0.3 }, Waist = { -10, 16, 0 }, Neck = { 0, -8, 0 }, RS = { 95, 0, -2 }, RE = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 80, 0, 0 } },
			follow = { Root = { -10, 14, 0, 0, -0.27, -0.34 }, Waist = { -12, 18, 0 }, Neck = { 0, -10, 0 }, RS = { 98, 0, -4 }, RE = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 80, 0, 0 } },
			trail = "rightHand", hitText = "( BOING )",
		},

		-- P P P : Claquement de porte, il referme la porte invisible d'un grand revers… elle claque sur l'adversaire
		P_porte2 = {
			label = "Claquement de porte", startup = 0.08, active = 0.1, recovery = 0.2,
			damage = 7, hitbox = box(5.5, 4.5, 3, 0.8), kbBase = 22, kbGrowth = 30, kbAngle = 30,
			windup = { Root = { -6, -30, 0, 0, -0.25, 0.1 }, Waist = { -6, -30, 0 }, Neck = { 0, 20, 0 }, RS = { 85, 0, 85 }, RE = { 10, 0, 0 }, RW = { 0, 0, 30 }, LS = { 20, 0, -30 }, LE = { 80, 0, 0 } },
			strike = { Root = { -10, 24, 0, 0, -0.3, -0.3 }, Waist = { -10, 28, 0 }, Neck = { 0, -14, 0 }, RS = { 92, 0, -20 }, RE = { 5, 0, 0 }, RW = { 0, 0, 30 }, LS = { 25, 0, -35 }, LE = { 80, 0, 0 } },
			follow = { Root = { -12, 30, 0, 0, -0.32, -0.34 }, Waist = { -12, 34, 0 }, Neck = { 0, -18, 0 }, RS = { 90, 0, -30 }, RE = { 10, 0, 0 }, RW = { 0, 0, 30 }, LS = { 25, 0, -35 }, LE = { 80, 0, 0 } },
			trail = "rightHand", fx = { { "ring", color = GHOST, radius = 3, at = "front" }, { "shake", amount = 0.2 } }, hitText = "( VLAN )",
		},
		-- → P P : Vitre invisible, il plaque les deux paumes sur une vitre qui n'existe pas… et la pousse dans le nez d'en face
		P_vitre = {
			label = "Vitre invisible", startup = 0.07, active = 0.1, recovery = 0.18,
			damage = 6, hitbox = box(5.5, 4.5, 3, 1), kbBase = 20, kbGrowth = 26, kbAngle = 35, selfVelocity = Vector2.new(14, 0),
			windup = { Root = { 2, 0, 0, 0, -0.15, 0.1 }, Waist = { 4, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 70, 0, 25 }, RE = { 100, 0, 0 }, RW = { 85, 0, 0 }, LS = { 70, 0, -25 }, LE = { 100, 0, 0 }, LW = { 85, 0, 0 } },
			strike = { Root = { -10, 0, 0, 0, -0.3, -0.4 }, Waist = { -12, 0, 0 }, Neck = { -14, 0, 0 }, RS = { 95, 0, 14 }, RE = { 0, 0, 0 }, RW = { 85, 0, 0 }, LS = { 95, 0, -14 }, LE = { 0, 0, 0 }, LW = { 85, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -12, 0, 0, 0, -0.32, -0.45 }, Waist = { -14, 0, 0 }, Neck = { -16, 0, 6 }, RS = { 98, 0, 16 }, RE = { 0, 0, 0 }, RW = { 85, 0, 0 }, LS = { 98, 0, -16 }, LE = { 0, 0, 0 }, LW = { 85, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			wobble = true, trail = "bothHands", fx = { { "ring", color = GHOST, radius = 3, at = "front" } }, text = "…", hitText = "( SPLATCH )",
		},
		-- → P P P : Canne à pêche invisible, il ferre d'un grand coup de poignet : l'adversaire mord et décolle (finition)
		P_peche = {
			label = "Canne à pêche invisible", startup = 0.09, active = 0.12, recovery = 0.3,
			damage = 10, hitbox = box(6, 5, 3.5, 1.5), kbBase = 34, kbGrowth = 74, kbAngle = 82,
			windup = { Root = { -6, -16, 0, 0, -0.3, 0.1 }, Waist = { -10, -16, 0 }, Neck = { -6, 10, 0 }, RS = { 40, 0, 20 }, RE = { 70, 0, 0 }, RW = { 60, 0, 0 }, LS = { 50, 0, -10 }, LE = { 90, 0, 0 } },
			strike = { Root = { 12, 10, 0, 0, 0.05, 0.1 }, Waist = { 16, 12, 0 }, Neck = { 26, 0, 0 }, RS = { 165, 0, 10 }, RE = { 10, 0, 0 }, RW = { -40, 0, 0 }, LS = { 110, 0, -20 }, LE = { 80, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			follow = { Root = { 16, 14, 0, 0, 0.1, 0.15 }, Waist = { 20, 16, 0 }, Neck = { 32, 0, 0 }, RS = { 180, 0, 5 }, RE = { 10, 0, 0 }, RW = { -50, 0, 0 }, LS = { 120, 0, -25 }, LE = { 85, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			prop = "corde", hideProp = "canne", trail = "rightHand", fx = { { "burst", color = Color3.fromRGB(120, 180, 255), size = 3, at = "front" }, { "symbols", symbols = { "🐟", "💦" }, count = 3, radius = 2.5, at = "front" } }, text = "( ÇA MORD )", hitText = "( FERRÉ )",
		},
		-- ↓ P P : Chien invisible, il siffle, tend une laisse à bout de bras… et le chien qu'on ne voit pas mord le mollet d'en face
		P_chien = {
			label = "Chien invisible", startup = 0.08, active = 0.12, recovery = 0.2,
			damage = 3, hits = 2, hitbox = box(5.5, 4, 3.5, 0.6), kbBase = 18, kbGrowth = 24, kbAngle = 40,
			windup = { Root = { 4, 0, 0, 0, -0.1, 0.1 }, Waist = { 6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 0 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 60, 0, 0 } },
			strike = { Root = { -14, 0, 0, 0, -0.3, -0.3 }, Waist = { -16, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 60, 0, -10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -16, 0, 0, 0, -0.32, -0.35 }, Waist = { -18, 0, 0 }, Neck = { 4, 0, 0 }, RS = { 50, 0, -12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			shake = true, prop = "corde", hideProp = "canne", windupFx = { { "symbols", symbols = { "🐕", "♪" }, count = 2, radius = 2, color = WHITE } }, fx = { { "symbols", symbols = { "🐕", "💢" }, count = 3, radius = 2.5, at = "front", color = WHITE } }, text = "( SIFFLE )", hitText = "( GRRR-WAF )",
		},
		-- ↓ P P P : Tapis roulant invisible, il court sur place à toute vitesse sans avancer… puis le tapis le catapulte épaule en avant (finition)
		P_tapis = {
			label = "Tapis roulant invisible", startup = 0.1, active = 0.14, recovery = 0.3,
			damage = 10, hitbox = box(5.5, 4.5, 3.2, 0.8), kbBase = 36, kbGrowth = 72, kbAngle = 24, selfVelocity = Vector2.new(42, 0),
			windup = { Root = { -12, 0, 0, 0, -0.25, 0.3 }, Waist = { -10, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 60, 0, 10 }, RE = { 110, 0, 0 }, LS = { -40, 0, -10 }, LE = { 100, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { -30, 0, 0 }, LK = { -60, 0, 0 } },
			strike = { Root = { -26, -30, 0, 0, -0.4, -0.4 }, Waist = { -10, -20, 0 }, Neck = { 10, 20, 0 }, RS = { -30, 0, 40 }, RE = { 40, 0, 0 }, LS = { 40, 0, -10 }, LE = { 110, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -28, -34, 0, 0, -0.42, -0.5 }, Waist = { -12, -22, 0 }, Neck = { 12, 22, 0 }, RS = { -40, 0, 45 }, RE = { 35, 0, 0 }, LS = { 35, 0, -10 }, LE = { 112, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			shake = true, trail = "body", windupFx = { "dust" }, fx = { "dust", { "particles", tex = "smoke", color = WIND, dir = "front", at = "feet", time = 0.3, speed = 16, size = 0.8 } }, text = "( VITESSE 10 )", hitText = "( CATAPULTÉ )",
		},
		-- K K K : Tête dans le ballon, il saute et reprend le ballon invisible de la tête : but ! (finition, fait décoller)
		K_tete = {
			label = "Tête dans le ballon", startup = 0.1, active = 0.12, recovery = 0.3,
			damage = 11, hitbox = box(5.5, 5, 3, 1.5), kbBase = 34, kbGrowth = 76, kbAngle = 70, selfVelocity = Vector2.new(10, 30),
			windup = { Root = { 8, 0, 0, 0, -0.5, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 25, 0, 0 }, RS = { -30, 0, 30 }, RE = { 40, 0, 0 }, LS = { -30, 0, -30 }, LE = { 40, 0, 0 } },
			strike = { Root = { -22, 0, 0, 0, 0.3, -0.3 }, Waist = { -20, 0, 0 }, Neck = { -35, 0, 0 }, RS = { 60, 0, 60 }, RE = { 40, 0, 0 }, LS = { 60, 0, -60 }, LE = { 40, 0, 0 }, RH = { 40, 0, 0 }, RK = { -90, 0, 0 }, LH = { 30, 0, 0 }, LK = { -80, 0, 0 } },
			follow = { Root = { -26, 0, 0, 0, 0.3, -0.35 }, Waist = { -24, 0, 0 }, Neck = { -40, 0, 0 }, RS = { 65, 0, 65 }, RE = { 40, 0, 0 }, LS = { 65, 0, -65 }, LE = { 40, 0, 0 }, RH = { 35, 0, 0 }, RK = { -85, 0, 0 }, LH = { 25, 0, 0 }, LK = { -75, 0, 0 } },
			trail = "head", fx = { { "burst", color = WHITE, size = 3, at = "front" }, { "symbols", symbols = { "⚽", "!" }, count = 3, radius = 2.5, at = "front", color = WHITE } }, text = "…!", hitText = "( BUUUT )",
		},
		-- → K K : Double touche, il salue de la canne puis pique deux fois de suite comme un escrimeur pressé
		K_side2 = {
			label = "Double touche", startup = 0.07, active = 0.14, recovery = 0.2,
			damage = 4, hits = 2, hitbox = box(6, 4, 3.5, 0.8), kbBase = 20, kbGrowth = 28, kbAngle = 28, selfVelocity = Vector2.new(16, 0),
			windup = { Root = { 2, -45, 0, 0, -0.2, 0.15 }, Waist = { 2, -25, 0 }, Neck = { 0, 40, 0 }, RS = { 110, 0, -10 }, RE = { 120, 0, 0 }, RW = { -90, 0, 0 }, LS = { 140, 0, -50 }, LE = { 70, 0, 0 } },
			strike = { Root = { -8, -55, 0, 0, -0.45, -0.5 }, Waist = { -4, -30, 0 }, Neck = { 0, 45, 0 }, RS = { 94, 0, 0 }, RE = { 0, 0, 0 }, RW = { -88, 0, 0 }, LS = { 150, 0, -70 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.6 } },
			follow = { Root = { -6, -52, 0, 0, -0.4, -0.45 }, Waist = { -2, -28, 0 }, Neck = { 0, 44, 0 }, RS = { 70, 0, 0 }, RE = { 60, 0, 0 }, RW = { -88, 0, 0 }, LS = { 150, 0, -70 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			wobble = true, trail = "prop", text = "( SALUT )", hitText = "( TOUCHÉ-TOUCHÉ )",
		},
		-- → K K K : Moulinet de canne, un tour complet sur lui-même, la canne invisible tendue à l'horizontale (finition)
		K_side3 = {
			label = "Moulinet de canne", startup = 0.1, active = 0.2, recovery = 0.32,
			damage = 12, hitbox = box(7, 4, 2.5, 0.8), kbBase = 36, kbGrowth = 80, kbAngle = 32,
			windup = { Root = { 0, -50, 0, 0, -0.25, 0.1 }, Waist = { 0, -30, 0 }, Neck = { 0, 30, 0 }, RS = { 80, 0, 60 }, RE = { 60, 0, 0 }, RW = { -60, 0, 0 }, LS = { 60, 0, -40 }, LE = { 40, 0, 0 } },
			strike = { Root = { -4, 0, 0, 0, -0.2, -0.1 }, Waist = { -4, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 92, 0, 10 }, RE = { 0, 0, 0 }, RW = { -88, 0, 0 }, LS = { 90, 0, -85 }, LE = { 0, 0, 0 } },
			follow = { Root = { -4, 0, 0, 0, -0.2, -0.1 }, Waist = { -4, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 92, 0, 10 }, RE = { 0, 0, 0 }, RW = { -88, 0, 0 }, LS = { 90, 0, -85 }, LE = { 0, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "prop", fx = { { "ring", color = GHOST, radius = 4, at = "root" } }, text = "…!", hitText = "( SBAM )",
		},

		------------------------------------------------------------------ En l'air avec une flèche (P / K)
		-- → P en l'air : Ballon éclaté, il gonfle un ballon invisible entre ses mains puis le fait éclater d'une claque
		P_air_side = {
			label = "Ballon éclaté", startup = 0.1, active = 0.08, recovery = 0.18,
			damage = 8, hitbox = box(5, 4, 2.8, 0.5), kbBase = 24, kbGrowth = 40, kbAngle = 30,
			windup = { Root = { 6, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 80, 0, 50 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -50 }, LE = { 50, 0, 0 }, LW = { 0, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
			strike = { Root = { -6, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 90, 0, -12 }, RE = { 15, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, 12 }, LE = { 15, 0, 0 }, LW = { 0, 0, 0 }, RH = { 40, 0, 0 }, RK = { -70, 0, 0 }, LH = { 30, 0, 0 }, LK = { -70, 0, 0 } },
			follow = { Root = { -8, 0, 0 }, Waist = { -12, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 100, 0, 40 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 100, 0, -40 }, LE = { 30, 0, 0 }, LW = { 0, 0, 0 }, RH = { 40, 0, 0 }, RK = { -70, 0, 0 }, LH = { 30, 0, 0 }, LK = { -70, 0, 0 } },
			fx = { { "burst", color = PINK, size = 3, at = "front" }, { "symbols", symbols = { "💥" }, count = 1, radius = 1, at = "front" } }, hitText = "( POP )",
		},
		-- ↑ P en l'air : Fenêtre à guillotine, il pousse une fenêtre invisible vers le haut à deux paumes
		P_air_up = {
			label = "Fenêtre à guillotine", startup = 0.09, active = 0.12, recovery = 0.18,
			damage = 7, hitbox = box(5, 4, 0.5, 3.6), kbBase = 26, kbGrowth = 45, kbAngle = 86,
			windup = { Root = { -10, 0, 0 }, Waist = { -14, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 60, 0, 20 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 }, RH = { 80, 0, 0 }, RK = { -110, 0, 0 }, LH = { 80, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { 10, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 172, 0, 15 }, RE = { 10, 0, 0 }, RW = { 80, 0, 0 }, LS = { 172, 0, -15 }, LE = { 10, 0, 0 }, LW = { 80, 0, 0 }, RH = { 0, 0, 0 }, RK = { -20, 0, 0 }, LH = { 10, 0, 0 }, LK = { -30, 0, 0 } },
			follow = { Root = { 12, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 178, 0, 18 }, RE = { 5, 0, 0 }, RW = { 80, 0, 0 }, LS = { 178, 0, -18 }, LE = { 5, 0, 0 }, LW = { 80, 0, 0 }, RH = { -5, 0, 0 }, RK = { -20, 0, 0 }, LH = { 5, 0, 0 }, LK = { -30, 0, 0 } },
			trail = "bothHands", hitText = "( CLAC )",
		},
		-- ↓ P en l'air : Ascenseur qui descend, bien droit, il « descend les étages » à toute vitesse (smash vers le sol)
		P_air_down = {
			label = "Ascenseur qui descend", startup = 0.15, active = 0.14, recovery = 0.3,
			damage = 10, hitbox = box(4, 4, 0.5, -2.2), kbBase = 25, kbGrowth = 55, kbAngle = -78, selfVelocity = Vector2.new(0, -55),
			windup = { Root = { 0, 0, 0 }, Waist = { 4, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 10 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -10 }, LE = { 10, 0, 0 }, RH = { 10, 0, 0 }, RK = { -15, 0, 0 }, LH = { 10, 0, 0 }, LK = { -15, 0, 0 } },
			strike = { Root = { 0, 0, 0 }, Waist = { 0, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 170, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -10 }, LE = { 0, 0, 0 }, RH = { 0, 0, 3 }, RK = { 0, 0, 0 }, RA = { -20, 0, 0 }, LH = { 0, 0, -3 }, LK = { 0, 0, 0 }, LA = { -20, 0, 0 } },
			follow = { Root = { 0, 0, 0 }, Waist = { 0, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 175, 0, 8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 175, 0, -8 }, LE = { 0, 0, 0 }, RH = { 0, 0, 3 }, RK = { 0, 0, 0 }, RA = { -25, 0, 0 }, LH = { 0, 0, -3 }, LK = { 0, 0, 0 }, LA = { -25, 0, 0 } },
			trail = "body", text = "( DING )", hitText = "( REZ-DE-CHAUSSÉE )",
		},
		-- → K en l'air : Coup de pied dans la porte, pied à plat, il enfonce une porte invisible
		K_air_side = {
			label = "Coup de pied dans la porte", startup = 0.15, active = 0.12, recovery = 0.25,
			damage = 11, hitbox = box(5, 3, 3.2, 0), kbBase = 30, kbGrowth = 70, kbAngle = 30,
			windup = { Root = { -10, 30, 0 }, Waist = { -10, 15, 0 }, Neck = { 0, -20, 0 }, RS = { 60, 0, 40 }, RE = { 70, 0, 0 }, LS = { 60, 0, -60 }, LE = { 40, 0, 0 }, RH = { 100, 0, 0 }, RK = { -130, 0, 0 }, RA = { 20, 0, 0 }, LH = { 30, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { 25, 40, 0 }, Waist = { 8, 10, 0 }, Neck = { -12, -20, 0 }, RS = { -20, 0, 60 }, RE = { 20, 0, 0 }, LS = { 40, 0, -80 }, LE = { 10, 0, 0 }, LW = { 0, 0, -50 }, RH = { 70, 0, 0 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 }, LH = { 20, 0, 0 }, LK = { -110, 0, 0 } },
			follow = { Root = { 28, 42, 0 }, Waist = { 10, 10, 0 }, Neck = { -14, -20, 0 }, RS = { -25, 0, 64 }, RE = { 20, 0, 0 }, LS = { 42, 0, -82 }, LE = { 10, 0, 0 }, LW = { 0, 0, -50 }, RH = { 72, 0, 0 }, RK = { 0, 0, 0 }, RA = { 30, 0, 0 }, LH = { 15, 0, 0 }, LK = { -105, 0, 0 } },
			trail = "rightFoot", hitText = "( BLAM )",
		},
		-- ↑ K en l'air : Saut à la corde, il saute une corde imaginaire et finit en salto arrière, pieds au ciel
		K_air_up = {
			label = "Saut à la corde", startup = 0.14, active = 0.2, recovery = 0.25,
			damage = 10, hitbox = box(4, 5, 0.5, 3.5), kbBase = 30, kbGrowth = 65, kbAngle = 86,
			windup = { Root = { -8, 0, 0 }, Waist = { -10, 0, 0 }, RS = { 30, 0, 50 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -50 }, LE = { 30, 0, 0 }, LW = { 0, 0, 0 }, RH = { 80, 0, 0 }, RK = { -130, 0, 0 }, LH = { 80, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -40, 0, 50 }, RE = { 20, 0, 0 }, LS = { -40, 0, -50 }, LE = { 20, 0, 0 }, RH = { 150, 0, 0 }, RK = { -5, 0, 0 }, RA = { 20, 0, 0 }, LH = { 140, 0, 0 }, LK = { -10, 0, 0 }, LA = { 20, 0, 0 } },
			follow = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -45, 0, 55 }, RE = { 20, 0, 0 }, LS = { -45, 0, -55 }, LE = { 20, 0, 0 }, RH = { 120, 0, 0 }, RK = { -30, 0, 0 }, LH = { 110, 0, 0 }, LK = { -40, 0, 0 } },
			spin = { axis = "x", degrees = -360 }, trail = "bothFeet", hitText = "( HOP-LÀ )",
		},
		-- ↓ K en l'air : Valise qui tombe, il porte au-dessus de sa tête une valise trop lourde et tombe pieds joints (smash vers le sol)
		K_air_down = {
			label = "Valise qui tombe", startup = 0.18, active = 0.15, recovery = 0.3,
			damage = 12, hitbox = box(4, 3, 0.5, -3), kbBase = 25, kbGrowth = 55, kbAngle = -80, selfVelocity = Vector2.new(0, -60),
			windup = { Root = { -6, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 175, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 175, 0, -20 }, LE = { 60, 0, 0 }, LW = { 0, 0, 0 }, RH = { 100, 0, 0 }, RK = { -130, 0, 0 }, LH = { 100, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 2, 0, 0 }, Waist = { 6, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 175, 0, 25 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 175, 0, -25 }, LE = { 80, 0, 0 }, LW = { 0, 0, 0 }, RH = { -4, 0, 4 }, RK = { 0, 0, 0 }, RA = { -10, 0, 0 }, LH = { -4, 0, -4 }, LK = { 0, 0, 0 }, LA = { -10, 0, 0 } },
			follow = { Root = { 2, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 170, 0, 30 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -30 }, LE = { 90, 0, 0 }, LW = { 0, 0, 0 }, RH = { -4, 0, 6 }, RK = { -5, 0, 0 }, RA = { -10, 0, 0 }, LH = { -4, 0, -6 }, LK = { -5, 0, 0 }, LA = { -10, 0, 0 } },
			shake = true, trail = "bothFeet", text = "( UMPF )", hitText = "( BADABOUM )",
		},

		------------------------------------------------------------------ Signatures (L) : sûres de toucher (couloir / projectiles visés, voir docs/fiche-perso.md)
		-- Mur invisible poussé : les deux paumes à plat, il « trouve » un mur devant lui et le pousse d'un grand coup de reins
		-- sur toute la longueur du couloir ; le mur reste planté là (2 au plus, bloque projectiles et adversaires)
		S_neutral = {
			label = "Mur invisible poussé", kind = "wall", startup = 0.2, active = 0.14, recovery = 0.45,
			damage = 13, hitbox = box(14, 6, 7, 1), kbBase = 34, kbGrowth = 60, kbAngle = 28, selfVelocity = Vector2.new(18, 0),
			wall = { size = Vector3.new(1.2, 8, 6), offset = 5, lifetime = 6, max = 2 },
			windup = { Root = { 6, 0, 0, 0, -0.2, 0.25 }, Waist = { 8, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 45, 0, -12 }, RE = { 125, 0, 0 }, RW = { 85, 0, 0 }, LS = { 45, 0, 12 }, LE = { 125, 0, 0 }, LW = { 85, 0, 0 } },
			strike = { Root = { -22, 0, 0, 0, -0.45, -0.6 }, Waist = { -14, 0, 0 }, Neck = { 4, 0, 0 }, RS = { 96, 0, 14 }, RE = { 0, 0, 0 }, RW = { 85, 0, 0 }, LS = { 96, 0, -14 }, LE = { 0, 0, 0 }, LW = { 85, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.7 } },
			follow = { Root = { -26, 0, 0, 0, -0.5, -0.7 }, Waist = { -16, 0, 0 }, Neck = { 6, 6, 0 }, RS = { 102, 0, 18 }, RE = { 0, 0, 0 }, RW = { 85, 0, 0 }, LS = { 102, 0, -18 }, LE = { 0, 0, 0 }, LW = { 85, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.75 } },
			hold = 0.12, shake = true, trail = "bothHands",
			fx = { { "ring", color = GHOST, radius = 4, at = "front" }, { "burst", color = GHOST, size = 3, at = "front" }, { "particles", tex = "smoke", color = GHOST, dir = "front", at = "front", time = 0.3, speed = 26, size = 0.9, rate = 60 } },
			text = "…!", hitText = "( MUR )",
		},
		-- Lasso invisible : il fait tournoyer un lasso qu'on ne voit pas au-dessus du béret et le lance à l'horizontale sur
		-- toute la longueur du couloir ; l'adversaire accroché est tiré d'un coup sec jusqu'à lui (sinon Marcel se hisse vers le décor)
		S_side = {
			label = "Lasso invisible", kind = "grapple", startup = 0.22, active = 0.12, recovery = 0.45,
			damage = 13, kbBase = 24, kbGrowth = 30, kbAngle = 15,
			grapple = { range = 32, angle = 0, speed = 80, pullEnemy = true },
			windup = { Root = { 6, -14, 0, 0, -0.15, 0.15 }, Waist = { 8, -14, 0 }, Neck = { 12, 0, 0 }, RS = { 178, 0, 35 }, RE = { 35, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 70, 0, 0 } },
			strike = { Root = { -12, 12, 0, 0, -0.3, -0.4 }, Waist = { -12, 14, 0 }, Neck = { -4, 0, 0 }, RS = { 98, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -20 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { 16, -8, 0, 0, -0.4, 0.3 }, Waist = { 20, -10, 0 }, Neck = { 12, 0, 0 }, RS = { 55, 0, 15 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 85, 0, -10 }, LE = { 50, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			prop = "corde", hideProp = "canne", trail = "prop",
			windupFx = { { "ring", color = ROPE, radius = 2.5, at = "above" } }, fx = { { "beam", color = ROPE, length = 14, width = 0.5, at = "hand" } },
			text = "( YIIHA )", hitText = "( TCHAC )",
		},
		-- Contre silencieux : il se fige en statue ; un coup reçu pendant la pose est annulé et il riposte. Statue ou pas,
		-- ses deux paumes font ensuite coulisser une vitre invisible sur toute la longueur du couloir
		S_down = {
			label = "Contre silencieux", kind = "counter", startup = 0.15, active = 0.4, recovery = 0.45,
			damage = 12, hitbox = box(14, 6, 7, 1), kbBase = 32, kbGrowth = 58, kbAngle = 32,
			counter = { window = 0.6, text = "…", riposte = { damage = 16, kbBase = 40, kbGrowth = 75, kbAngle = 35, hitText = "( RETOUR À L'ENVOYEUR )" } },
			windup = { Root = { 0, 0, 0, 0, -0.1, 0.1 }, Waist = { 4, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 60, 0, 30 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -14, 0, 0, 0, -0.35, -0.5 }, Waist = { -12, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 98, 0, 6 }, RE = { 0, 0, 0 }, RW = { 85, 0, 0 }, LS = { 98, 0, -6 }, LE = { 0, 0, 0 }, LW = { 85, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			follow = { Root = { -16, 0, 0, 0, -0.38, -0.55 }, Waist = { -14, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 100, 0, 8 }, RE = { 0, 0, 0 }, RW = { 85, 0, 0 }, LS = { 100, 0, -8 }, LE = { 0, 0, 0 }, LW = { 85, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			hold = 0.2, trail = "bothHands",
			fx = { { "ring", color = GHOST, radius = 3, at = "root" }, { "symbols", symbols = { "✋", "▯" }, count = 3, radius = 2, at = "front", color = WHITE }, { "burst", color = GHOST, size = 2.5, at = "front" } },
			text = "…", hitText = "( STOP )",
		},
		-- Parapluie emporté (remontée) : il ouvre un parapluie qu'on devine à peine, une rafale l'emporte en diagonale vers
		-- l'avant, pointe du parapluie en avant et jambes qui flottent derrière : tout ce qui est sur le passage prend le pied
		S_up = {
			label = "Parapluie emporté", startup = 0.15, active = 0.32, recovery = 0.4,
			damage = 14, hitbox = box(10, 11, 3, 4), kbBase = 32, kbGrowth = 55, kbAngle = 70, selfVelocity = Vector2.new(44, 84),
			windup = { Root = { 6, 0, 0, 0, -0.65, 0.1 }, Waist = { -14, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 120, 0, 10 }, RE = { 90, 0, 0 }, RW = { -40, 0, 0 }, LS = { -20, 0, -25 }, LE = { 40, 0, 0 } },
			strike = { Root = { -42, 0, 0, 0, 0.3, 0 }, Waist = { -8, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 168, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -40 }, LE = { 20, 0, 0 }, RH = { -24, 0, 6 }, RK = { -30, 0, 0 }, RA = { -30, 0, 0 }, LH = { -36, 0, -6 }, LK = { -45, 0, 0 }, LA = { -30, 0, 0 } },
			follow = { Root = { -46, 0, 0, 0, 0.35, 0 }, Waist = { -10, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 172, 0, 14 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 125, 0, -45 }, LE = { 20, 0, 0 }, RH = { -30, 0, 8 }, RK = { -40, 0, 0 }, RA = { -30, 0, 0 }, LH = { -42, 0, -8 }, LK = { -55, 0, 0 }, LA = { -30, 0, 0 } },
			prop = "parapluie", hideProp = "canne", trail = "prop",
			windupFx = { { "burst", color = GHOST, size = 2.5, at = "hand" } },
			fx = { { "ring", color = WIND, radius = 4, at = "feet" }, { "particles", tex = "smoke", color = WIND, dir = "up", at = "feet", time = 0.35, speed = 18, size = 0.8, rate = 70 }, { "symbols", symbols = { "☂", "( FIOU )" }, count = 3, radius = 2, color = WHITE } },
			text = "…", hitText = "( POC )",
		},
		-- Le Piano (plongeon) : il pousse un piano imaginaire par-dessus bord… et tombe avec, de tout son poids, sur tout ce qu'il y a dessous
		S_air_down = {
			label = "Le Piano", startup = 0.18, active = 0.35, recovery = 0.45,
			damage = 14, hitbox = box(8, 6, 1, -2), kbBase = 28, kbGrowth = 60, kbAngle = -70, selfVelocity = Vector2.new(0, -85),
			windup = { Root = { 6, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 95, 0, 20 }, RE = { 20, 0, 0 }, RW = { 80, 0, 0 }, LS = { 95, 0, -20 }, LE = { 20, 0, 0 }, LW = { 80, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 40, 0, 0 }, LK = { -70, 0, 0 } },
			strike = { Root = { 0, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { -30, 0, 0 }, RS = { 160, 0, 60 }, RE = { 20, 0, 0 }, LS = { 160, 0, -60 }, LE = { 20, 0, 0 }, RH = { -2, 0, 5 }, RK = { 0, 0, 0 }, RA = { -10, 0, 0 }, LH = { -2, 0, -5 }, LK = { 0, 0, 0 }, LA = { -10, 0, 0 } },
			follow = { Root = { 0, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { -32, 0, 0 }, RS = { 165, 0, 65 }, RE = { 20, 0, 0 }, LS = { 165, 0, -65 }, LE = { 20, 0, 0 }, RH = { -2, 0, 8 }, RK = { -5, 0, 0 }, RA = { -10, 0, 0 }, LH = { -2, 0, -8 }, LK = { -5, 0, 0 }, LA = { -10, 0, 0 } },
			trail = "body", fx = { { "shake", amount = 0.6 }, { "ring", color = GHOST, radius = 6, at = "feet" }, { "burst", color = GHOST, size = 3, at = "feet" } }, text = "…", hitText = "( PLONK )",
		},
		-- Peau de banane invisible (esquive puis S) : il pèle une banane imaginaire, la mange et jette la peau d'un grand
		-- geste… elle file droit sur l'adversaire (personne à portée : elle retombe et reste au sol un moment, glissante)
		S_dodge = {
			label = "Peau de banane invisible", kind = "projectile", startup = 0.18, active = 0, recovery = 0.4,
			damage = 12, kbBase = 24, kbGrowth = 30, kbAngle = 80,
			status = { name = "slippery", duration = 2 },
			projectile = { speed = 60, angle = 8, gravity = 30, lifetime = 0.6, size = 2, color = BANANA, linger = 1.5, from = "feet",
				visual = { shape = "ball", size = 0.9, color = BANANA, transparency = 0.75, spin = 6,
					parts = { { "block", Vector3.new(0.9, 0.1, 0.3), Vector3.new(0.6, -0.3, 0), BANANA }, { "block", Vector3.new(0.9, 0.1, 0.3), Vector3.new(-0.6, -0.3, 0), BANANA } } } },
			windup = { Root = { 0, 0, 0, 0, -0.1, 0 }, Waist = { 4, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 110, 0, -30 }, RE = { 130, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, 10 }, LE = { 100, 0, 0 } },
			strike = { Root = { -10, 14, 0, 0, -0.3, -0.3 }, Waist = { -10, 16, 0 }, Neck = { -4, -10, 0 }, RS = { 60, 0, 30 }, RE = { 5, 0, 0 }, RW = { 40, 0, 0 }, LS = { 30, 0, -20 }, LE = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -12, 16, 0, 0, -0.32, -0.35 }, Waist = { -12, 18, 0 }, Neck = { -4, -12, 0 }, RS = { 40, 0, 40 }, RE = { 10, 0, 0 }, RW = { 50, 0, 0 }, LS = { 30, 0, -20 }, LE = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			trail = "rightHand", fx = { { "symbols", symbols = { "🍌" }, count = 1, radius = 1.5, at = "front", color = BANANA } },
			text = "( MIAM )", hitText = "( WOUPS )",
		},
		-- Vent violent (S maintenu) : il gonfle les joues, se plante sur ses jambes et pousse à deux paumes une bourrasque
		-- qui balaie tout le couloir devant lui (repousse très loin)
		S_hold = {
			label = "Vent violent", startup = 0.26, active = 0.28, recovery = 0.5,
			damage = 12, hitbox = box(14, 6, 7, 1), kbBase = 58, kbGrowth = 72, kbAngle = 18,
			windup = { Root = { 8, 0, 0, 0, -0.3, 0.3 }, Waist = { 16, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 40, 0, 70 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -70 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
			strike = { Root = { -12, 0, 0, 0, -0.45, -0.4 }, Waist = { -16, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 94, 0, 10 }, RE = { 0, 0, 0 }, RW = { 85, 0, 0 }, LS = { 94, 0, -10 }, LE = { 0, 0, 0 }, LW = { 85, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			follow = { Root = { -14, 0, 0, 0, -0.48, -0.45 }, Waist = { -18, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 98, 0, 12 }, RE = { 0, 0, 0 }, RW = { 85, 0, 0 }, LS = { 98, 0, -12 }, LE = { 0, 0, 0 }, LW = { 85, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			shake = true, wobble = true, trail = "bothHands",
			fx = { { "particles", tex = "smoke", color = WIND, dir = "front", at = "front", time = 0.4, speed = 34, size = 1.3, rate = 100 }, { "beam", color = WIND, length = 16, width = 3, at = "hand" }, { "swarm", shape = "flat", color = Color3.fromRGB(150, 190, 90), count = 6, distance = 20, size = 0.5, height = 2 } },
			text = "( FFFFFF )", hitText = "( WOUSH )",
		},
		-- Vélo invisible (→→S) : assis sur une selle qui n'existe pas, il pédale à toute allure, guidon en main, et traverse tout le couloir
		S_dash = {
			label = "Vélo invisible", startup = 0.15, active = 0.32, recovery = 0.4,
			damage = 13, hitbox = box(12, 5, 5, 0.5), kbBase = 32, kbGrowth = 62, kbAngle = 32, selfVelocity = Vector2.new(66, 0), invuln = 0.15, armor = true,
			windup = { Root = { -10, 0, 0, 0, -0.55, 0 }, Waist = { -10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 75, 0, 15 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 75, 0, -15 }, LE = { 40, 0, 0 }, LW = { 0, 0, 0 }, RH = { 90, 0, 0 }, RK = { -100, 0, 0 }, LH = { 40, 0, 0 }, LK = { -60, 0, 0 } },
			strike = { Root = { -18, 0, 0, 0, -0.55, -0.25 }, Waist = { -12, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 82, 0, 15 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 82, 0, -15 }, LE = { 30, 0, 0 }, LW = { 0, 0, 0 }, RH = { 40, 0, 0 }, RK = { -60, 0, 0 }, LH = { 90, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { -18, 0, 0, 0, -0.55, -0.25 }, Waist = { -12, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 82, 0, 15 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 82, 0, -15 }, LE = { 30, 0, 0 }, LW = { 0, 0, 0 }, RH = { 90, 0, 0 }, RK = { -100, 0, 0 }, LH = { 40, 0, 0 }, LK = { -60, 0, 0 } },
			wobble = true, fx = { "dust", { "symbols", symbols = { "( DRING )" }, count = 2, radius = 2, color = WHITE } }, text = "( DRING DRING )", hitText = "( PROUT-PROUT )",
		},
		-- Piano lâché (S en l'air) : il fait signe à quelqu'un là-haut… et un piano invisible tombe du ciel pile sur la tête de l'adversaire
		S_air = {
			label = "Piano lâché", kind = "projectile", startup = 0.2, active = 0, recovery = 0.42,
			damage = 14, kbBase = 28, kbGrowth = 58, kbAngle = 70,
			status = { name = "stunned", duration = 0.6 },
			projectile = { speed = 60, gravity = 60, lifetime = 0.9, size = 3.6, color = BLACK, rain = { count = 1, spread = 0.5, ahead = 7, height = 20 },
				visual = { shape = "block", size = 3, color = Color3.fromRGB(40, 40, 45), transparency = 0.72, trail = false,
					parts = { { "block", Vector3.new(3.1, 0.3, 1.2), Vector3.new(0, 1.1, -0.6), WHITE }, { "block", Vector3.new(0.3, 1.2, 0.3), Vector3.new(-1.2, -2, 0), BLACK }, { "block", Vector3.new(0.3, 1.2, 0.3), Vector3.new(1.2, -2, 0), BLACK } } } },
			windup = { Root = { -6, 0, 0 }, Waist = { -6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 170, 0, 20 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 60, 0, 0 }, RH = { 40, 0, 0 }, RK = { -60, 0, 0 }, LH = { 20, 0, 0 }, LK = { -50, 0, 0 } },
			strike = { Root = { 4, 0, 0 }, Waist = { 4, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 120, 0, 10 }, RE = { 10, 0, 0 }, RW = { 60, 0, 0 }, LS = { 30, 0, -50 }, LE = { 60, 0, 0 }, RH = { 30, 0, 0 }, RK = { -50, 0, 0 }, LH = { 20, 0, 0 }, LK = { -50, 0, 0 } },
			follow = { Root = { 4, 0, 0 }, Waist = { 4, 0, 0 }, Neck = { -14, 0, 0 }, RS = { 100, 0, 10 }, RE = { 10, 0, 0 }, RW = { 80, 0, 0 }, LS = { 60, 0, -30 }, LE = { 120, 0, 0 }, RH = { 30, 0, 0 }, RK = { -50, 0, 0 }, LH = { 20, 0, 0 }, LK = { -50, 0, 0 } },
			fx = { { "symbols", symbols = { "🎹", "▼" }, count = 2, radius = 2, at = "above", color = WHITE } }, text = "( LÂCHEZ TOUT )", hitText = "( PLONK )",
		},

		------------------------------------------------------------------ Finitions avec S (dans un enchaînement)
		-- Poussée du mur : il plaque un mur invisible contre l'adversaire et pousse de tout son corps
		S_finish_mur = {
			label = "Poussée du mur", startup = 0.14, active = 0.16, recovery = 0.32,
			damage = 10, hitbox = box(5, 6, 3, 1), kbBase = 34, kbGrowth = 66, kbAngle = 22, selfVelocity = Vector2.new(20, 0),
			windup = { Root = { 4, 0, 0, 0, -0.25, 0.2 }, Waist = { 6, 0, 0 }, RS = { 70, 0, 20 }, RE = { 120, 0, 0 }, RW = { 80, 0, 0 }, LS = { 70, 0, -20 }, LE = { 120, 0, 0 }, LW = { 80, 0, 0 } },
			strike = { Root = { -20, 0, 0, 0, -0.45, -0.5 }, Waist = { -10, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 100, 0, 15 }, RE = { 5, 0, 0 }, RW = { 85, 0, 0 }, LS = { 100, 0, -15 }, LE = { 5, 0, 0 }, LW = { 85, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -24, 0, 0, 0, -0.5, -0.6 }, Waist = { -12, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 100, 0, 15 }, RE = { 0, 0, 0 }, RW = { 85, 0, 0 }, LS = { 100, 0, -15 }, LE = { 0, 0, 0 }, LW = { 85, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.6 } },
			fx = { { "ring", color = GHOST, radius = 4, at = "front" } }, text = "( HAN )", hitText = "( SPLATCH )",
		},
		-- Coup de lasso : la corde invisible claque de bas en haut comme un fouet et fait décoller l'adversaire
		S_finish_corde = {
			label = "Coup de lasso", startup = 0.12, active = 0.14, recovery = 0.3,
			damage = 9, hitbox = box(6, 5, 3.5, 1.5), kbBase = 32, kbGrowth = 60, kbAngle = 78,
			windup = { Root = { -6, -10, 0, 0, -0.4, 0.1 }, Waist = { -14, -10, 0 }, RS = { -20, 0, 30 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 70, 0, 0 } },
			strike = { Root = { 8, 10, 0, 0, 0.1, -0.15 }, Waist = { 12, 12, 0 }, Neck = { 20, 0, 0 }, RS = { 160, 0, 15 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -40 }, LE = { 60, 0, 0 } },
			follow = { Root = { 10, 12, 0, 0, 0.15, -0.18 }, Waist = { 14, 14, 0 }, Neck = { 26, 0, 0 }, RS = { 180, 0, 5 }, RE = { 5, 0, 0 }, RW = { -20, 0, 0 }, LS = { 5, 0, -42 }, LE = { 60, 0, 0 } },
			prop = "corde", hideProp = "canne", trail = "rightHand", hitText = "( FLAC )",
		},

		------------------------------------------------------------------ Supers (Y) : couloir 1,3 fois plus grand, plus farfelus
		-- Le Silence (Y) : un doigt sur la bouche… et plus un bruit dans toute l'arène ; l'adversaire est réduit au silence
		-- (muet : plus de signatures pendant 3 s) et l'écran s'éteint comme au cinéma
		SUPER = {
			label = "Le Silence", startup = 0.4, active = 0.2, recovery = 0.7,
			damage = 20, hitbox = box(50, 36, 0, 8), kbBase = 12, kbGrowth = 12, kbAngle = 60,
			status = { name = "muted", duration = 3 },
			windup = { Root = { 0, 0, 0, 0, -0.1, 0 }, Waist = { 6, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 130, 0, -35 }, RE = { 145, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -20 }, LE = { 20, 0, 0 } },
			strike = { Root = { 0, 0, 0, 0, 0.05, 0 }, Waist = { 10, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 130, 0, -38 }, RE = { 150, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -40 }, LE = { 10, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { 0, 0, 0, 0, 0.05, 0 }, Waist = { 10, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 130, 0, -38 }, RE = { 150, 0, 0 }, RW = { 0, 0, 0 }, LS = { 155, 0, -45 }, LE = { 10, 0, 0 }, LW = { 0, 0, 0 } },
			hold = 0.5, windupFx = { "super" },
			fx = { { "screen", color = Color3.fromRGB(10, 10, 20), alpha = 0.6, time = 0.8 }, { "ring", color = WHITE, radius = 12, at = "head" }, { "symbols", symbols = { "🤫", "…", "🔇" }, count = 8, radius = 5, color = WHITE } },
			text = "CHUUUT…", hitText = "( … )",
		},
		-- La Cage de verre (→Y) : il tâte l'air, trouve une paroi, puis une autre, et pousse la cage de verre invisible qu'il vient
		-- de mimer sur toute la longueur du couloir : tout le monde se retrouve enfermé dedans, incapable de bouger
		SUPER_side = {
			label = "La Cage de verre !", startup = 0.4, active = 0.24, recovery = 0.7,
			damage = 24, hitbox = box(14, 6, 7, 1), kbBase = 44, kbGrowth = 90, kbAngle = 30,
			status = { name = "rooted", duration = 2 },
			windup = { Root = { 0, -20, 0, 0, -0.15, 0.1 }, Waist = { 2, -18, 0 }, Neck = { -6, 16, 0 }, RS = { 90, 0, 40 }, RE = { 10, 0, 0 }, RW = { 85, 0, 0 }, LS = { 90, 0, -10 }, LE = { 60, 0, 0 }, LW = { 85, 0, 0 } },
			strike = { Root = { -20, 0, 0, 0, -0.45, -0.55 }, Waist = { -14, 0, 0 }, Neck = { 4, 0, 0 }, RS = { 98, 0, 16 }, RE = { 0, 0, 0 }, RW = { 85, 0, 0 }, LS = { 98, 0, -16 }, LE = { 0, 0, 0 }, LW = { 85, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.65 } },
			follow = { Root = { -24, 0, 0, 0, -0.5, -0.65 }, Waist = { -16, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 102, 0, 20 }, RE = { 0, 0, 0 }, RW = { 85, 0, 0 }, LS = { 102, 0, -20 }, LE = { 0, 0, 0 }, LW = { 85, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.7 } },
			hold = 0.3, shake = true, trail = "bothHands", windupFx = { "super", { "symbols", symbols = { "▯", "▯", "?" }, count = 4, radius = 2.5, color = WHITE } },
			fx = { { "ring", color = GHOST, radius = 7, at = "front" }, { "beam", color = GHOST, length = 16, width = 5, at = "hand" }, { "symbols", symbols = { "▯", "( TOC )", "▯" }, count = 8, radius = 4, at = "front", color = GHOST }, { "shake", amount = 0.35 } },
			text = "…!", hitText = "( ENFERMÉ )",
		},
		-- Ascenseur invisible (Y↑) : il appuie sur un bouton qui n'existe pas, soulève le plafond de la cabine à deux paumes
		-- et tout le couloir devant lui monte au dernier étage avec lui
		SUPER_up = {
			label = "L'Ascenseur invisible !", startup = 0.35, active = 0.3, recovery = 0.7,
			damage = 24, hitbox = box(14, 8, 7, 2), kbBase = 46, kbGrowth = 95, kbAngle = 88, invuln = 0.3, selfVelocity = Vector2.new(0, 60),
			windup = { Root = { 0, -15, 0, 0, -0.1, 0.1 }, Waist = { 2, -12, 0 }, Neck = { 22, 10, 0 }, RS = { 110, 0, 5 }, RE = { 30, 0, 0 }, RW = { -40, 0, 0 }, LS = { 10, 0, -20 }, LE = { 60, 0, 0 } },
			strike = { Root = { 0, 0, 0, 0, 0.4, 0 }, Waist = { 0, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 178, 0, 12 }, RE = { 0, 0, 0 }, RW = { 85, 0, 0 }, LS = { 178, 0, -12 }, LE = { 0, 0, 0 }, LW = { 85, 0, 0 }, FR = { 0, 0, 0, 0, 0.35, 0 }, FL = { 0, 0, 0, 0, 0.35, 0 } },
			follow = { Root = { 0, 0, 0, 0, 0.5, 0 }, Waist = { 0, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 182, 0, 14 }, RE = { 0, 0, 0 }, RW = { 85, 0, 0 }, LS = { 182, 0, -14 }, LE = { 0, 0, 0 }, LW = { 85, 0, 0 }, FR = { 0, 0, 0, 0, 0.45, 0 }, FL = { 0, 0, 0, 0, 0.45, 0 } },
			hold = 0.3, trail = "bothHands",
			windupFx = { "super", { "text", text = "[ 12e ÉTAGE ]", color = WHITE, at = "above" } },
			fx = { { "pillar", color = GHOST, height = 26, width = 6, at = "front" }, { "ring", color = GHOST, radius = 7, at = "feet" }, { "symbols", symbols = { "▲", "( DING )" }, count = 5, radius = 3, color = WHITE } },
			text = "…", hitText = "[ DERNIER ÉTAGE ]",
		},
		-- La Boîte ultime (Y↓) : il mime une boîte géante qui prend tout le couloir, l'aspire dedans, puis la secoue et cogne contre les parois
		SUPER_down = {
			label = "La Boîte ultime", startup = 0.35, active = 0.8, recovery = 0.6,
			damage = 4, hits = 6, pull = true, hitbox = box(14, 6, 7, 1), kbBase = 14, kbGrowth = 20, kbAngle = 60,
			windup = { Root = { 0, 0, 0, 0, -0.1, 0 }, Waist = { 0, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 95, 0, 60 }, RE = { 30, 0, 0 }, RW = { 85, 0, 0 }, LS = { 95, 0, -60 }, LE = { 30, 0, 0 }, LW = { 85, 0, 0 } },
			strike = { Root = { -6, 10, 0, 0, -0.2, -0.2 }, Waist = { -8, 12, 0 }, Neck = { -4, 0, 0 }, RS = { 95, 0, 0 }, RE = { 10, 0, 0 }, RW = { 85, 0, 0 }, LS = { 120, 0, -10 }, LE = { 60, 0, 0 }, LW = { 85, 0, 0 } },
			follow = { Root = { -6, -10, 0, 0, -0.2, -0.2 }, Waist = { -8, -12, 0 }, Neck = { -4, 0, 0 }, RS = { 120, 0, 10 }, RE = { 60, 0, 0 }, RW = { 85, 0, 0 }, LS = { 95, 0, 0 }, LE = { 10, 0, 0 }, LW = { 85, 0, 0 } },
			wobble = true, windupFx = { "super" }, fx = { { "ring", color = GHOST, radius = 6, at = "front" }, { "symbols", symbols = { "▢", "( TOC )" }, count = 8, radius = 4, at = "front", color = GHOST }, { "shake", amount = 0.3 } },
			text = "( LA BOÎTE )", hitText = "( BOÎTE )",
		},

		------------------------------------------------------------------ Saisie (bouton ✋) et projections
		-- Prise invisible : il lance une corde mimée autour de l'adversaire et serre le nœud… qui tient vraiment
		GRAB = {
			label = "Prise invisible", kind = "grab", startup = 0.1, active = 0.12, recovery = 0.35,
			damage = 0, hitbox = box(4, 4, 2, 0.5),
			windup = { Root = { 2, 0, 0, 0, -0.1, 0.05 }, Waist = { 4, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 120, 0, 40 }, RE = { 30, 0, 0 }, LS = { 120, 0, -40 }, LE = { 30, 0, 0 } },
			strike = { Root = { -6, 0, 0, 0, -0.18, -0.25 }, Waist = { -8, 0, 0 }, RS = { 85, 0, -20 }, RE = { 70, 0, 0 }, LS = { 85, 0, 20 }, LE = { 70, 0, 0 } },
			follow = { Root = { 6, 0, 0, 0, -0.2, 0.1 }, Waist = { 10, 0, 0 }, RS = { 80, 0, -10 }, RE = { 90, 0, 0 }, LS = { 80, 0, 10 }, LE = { 90, 0, 0 } },
			text = "…", hitText = "( NŒUD )",
		},
		-- ✋ puis → : Tir à la corde, il prend appui, tire de toutes ses forces… et lâche : l'adversaire part au loin
		THROW_fwd = {
			label = "Tir à la corde", kind = "throw", startup = 0.34, active = 0.08, recovery = 0.3,
			damage = 9, kbBase = 40, kbGrowth = 55, kbAngle = 15,
			carry = { { 0, 2.4, 0.4 }, { 0.2, 1.4, 0.3 }, { 0.34, 4.0, 0.6 } },
			windup = { Root = { 16, 0, 0, 0, -0.4, 0.4 }, Waist = { 18, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 70, 0, 0 }, RE = { 100, 0, 0 }, LS = { 85, 0, 0 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			strike = { Root = { -10, 0, 0, 0, -0.3, -0.3 }, Waist = { -10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 95, 0, 20 }, RE = { 5, 0, 0 }, LS = { 95, 0, -20 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -12, 0, 0, 0, -0.3, -0.35 }, Waist = { -12, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 100, 0, 40 }, RE = { 5, 0, 0 }, LS = { 100, 0, -40 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			text = "( HISSE… )", hitText = "( ET HOP )",
		},
		-- ✋ puis ← : Valise lourde, il soulève la victime comme une valise trop lourde, en peinant, et la jette derrière lui
		THROW_back = {
			label = "Valise lourde", kind = "throw", back = true, startup = 0.44, active = 0.1, recovery = 0.4,
			damage = 12, kbBase = 35, kbGrowth = 70, kbAngle = 40,
			carry = { { 0, 2.2, 0.3 }, { 0.2, 1.6, 0.6 }, { 0.32, 0.4, 2.6 }, { 0.44, -2.6, 0.8 } },
			windup = { Root = { -14, 0, 0, 0, -0.6, 0.1 }, Waist = { -30, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 10 }, RE = { 10, 0, 0 }, LS = { 30, 0, -40 }, LE = { 30, 0, 0 } },
			strike = { Root = { 10, 30, 0, 0, -0.2, 0.2 }, Waist = { 20, 40, 0 }, Neck = { 20, 0, 0 }, RS = { 190, 0, 10 }, RE = { 20, 0, 0 }, LS = { 40, 0, -60 }, LE = { 30, 0, 0 } },
			follow = { Root = { 14, 40, 0, 0, -0.2, 0.25 }, Waist = { 24, 50, 0 }, Neck = { 24, 0, 0 }, RS = { 200, 0, 10 }, RE = { 20, 0, 0 }, LS = { 30, 0, -65 }, LE = { 30, 0, 0 } },
			shake = true, text = "( HNNNGH )", hitText = "( BADABOUM )",
		},
		-- ✋ puis ↑ : Lâcher de ballon, il attache la victime à un ballon invisible et la regarde s'envoler en saluant
		THROW_up = {
			label = "Lâcher de ballon", kind = "throw", startup = 0.34, active = 0.08, recovery = 0.38,
			damage = 9, kbBase = 38, kbGrowth = 60, kbAngle = 90,
			carry = { { 0, 2.2, 0.3 }, { 0.16, 1.6, 1.4 }, { 0.34, 1.2, 4.2 } },
			windup = { Root = { 0, 0, 0, 0, -0.2, 0 }, Waist = { 4, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 100, 0, 0 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 100, 0, 0 }, LE = { 80, 0, 0 } },
			strike = { Root = { 6, 0, 0, 0, 0.1, 0 }, Waist = { 10, 0, 0 }, Neck = { 35, 0, 0 }, RS = { 175, 0, 10 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -30 }, LE = { 30, 0, 0 } },
			follow = { Root = { 6, 0, 0, 0, 0.05, 0 }, Waist = { 10, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 160, 0, 40 }, RE = { 10, 0, 0 }, RW = { 0, 0, 30 }, LS = { 10, 0, -30 }, LE = { 30, 0, 0 } },
			prop = "ballon", hideProp = "canne", text = "( AU REVOIR )", hitText = "( FLOUP )",
		},
		-- ✋ puis ↓ : Coincé dans la boîte, il plaque la victime au sol et referme les parois invisibles sur elle
		THROW_down = {
			label = "Coincé dans la boîte", kind = "throw", startup = 0.42, active = 0.1, hold = 0.2, recovery = 0.35,
			damage = 10, kbBase = 26, kbGrowth = 25, kbAngle = 75,
			status = { name = "rooted", duration = 1.2 },
			carry = { { 0, 2.2, 0.3 }, { 0.16, 2.0, 1.2 }, { 0.3, 2.4, -1.6 }, { 0.42, 2.4, -2.0 } },
			windup = { Root = { 6, 0, 0, 0, 0, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 160, 0, 10 }, RE = { 30, 0, 0 }, LS = { 160, 0, -10 }, LE = { 30, 0, 0 } },
			strike = { Root = { -18, 0, 0, 0, -0.75, -0.3 }, Waist = { -20, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 70, 0, 50 }, RE = { 30, 0, 0 }, RW = { 85, 0, 0 }, LS = { 70, 0, -50 }, LE = { 30, 0, 0 }, LW = { 85, 0, 0 } },
			follow = { Root = { -20, 0, 0, 0, -0.8, -0.35 }, Waist = { -22, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 75, 0, 5 }, RE = { 20, 0, 0 }, RW = { 85, 0, 0 }, LS = { 75, 0, -5 }, LE = { 20, 0, 0 }, LW = { 85, 0, 0 } },
			fx = { { "ring", color = GHOST, radius = 3, at = "front" } }, text = "( CLAC CLAC )", hitText = "( COINCÉ )",
		},
	},

	-- Séquences relatives à l'adversaire : forward = vers lui, back = à l'opposé
	fatals = {
		{
			id = "la_boite", label = "La Boîte", sequence = { "back", "forward", "back" },
			-- il enferme l'adversaire dans une boîte invisible, la plie encore et encore jusqu'à la taille d'un
			-- mouchoir, et la range dans sa poche
			scene = {
				{ "spawn", at = "target", offset = Vector3.zero, life = 2.2, pieces = {
					{ "Boite", "", "block", Vector3.new(4, 6, 4), Vector3.zero, Vector3.zero, GHOST, "Glass", { transparency = 0.82 } },
				} },
				{ "fxAttacker", { "text", text = "( UNE BOÎTE… )", color = WHITE } },
				{ "wait", 0.5 },
				{ "shrink", 0.6, time = 0.4 },
				{ "fx", { "ring", color = GHOST, radius = 2.5, at = "root" } },
				{ "shrink", 0.3, time = 0.4 },
				{ "fx", { "ring", color = GHOST, radius = 1.5, at = "root" } },
				{ "shrink", 0.12, time = 0.4 },
				{ "text", "PLIÉ" },
				{ "move", to = "attacker", offset = Vector3.new(0, 0, 0), time = 0.5 },
				{ "hide" },
				{ "fxAttacker", { "symbols", symbols = { "🤫", "✨" }, count = 4, color = WHITE } },
				{ "fxAttacker", { "text", text = "( DANS LA POCHE )", color = WHITE } },
				{ "wait", 1 },
			},
		},
		{
			id = "le_piano", label = "Le Piano", sequence = { "down", "down", "forward" },
			-- un piano invisible tombe du ciel : on n'entend qu'un « plonk », l'adversaire reste aplati comme un tapis
			scene = {
				{ "fxAttacker", { "text", text = "( LÂCHEZ TOUT ! )", color = WHITE } },
				{ "spawn", at = "above", offset = Vector3.new(0, 4, 0), life = 1.2, pieces = {
					{ "Piano", "", "block", Vector3.new(5, 3.5, 3), Vector3.zero, Vector3.zero, Color3.fromRGB(40, 40, 45), "Glass", { transparency = 0.75 } },
					{ "Clavier", "", "block", Vector3.new(5, 0.3, 1.2), Vector3.new(0, -0.6, -1.9), Vector3.zero, WHITE, "SmoothPlastic", { transparency = 0.6 } },
				} },
				{ "wait", 0.6 },
				{ "squash" },
				{ "spawn", at = "target", offset = Vector3.new(0, -1.5, 0), life = 3, pieces = {
					{ "PianoAuSol", "", "block", Vector3.new(5, 3.5, 3), Vector3.zero, Vector3.zero, Color3.fromRGB(40, 40, 45), "Glass", { transparency = 0.8 } },
				} },
				{ "fx", { "shake", amount = 0.8 } },
				{ "text", "plonk." },
				{ "fx", { "burst", color = GHOST, size = 5, at = "feet" } },
				{ "wait", 0.8 },
				{ "fxAttacker", { "symbols", symbols = { "🎹", "…" }, count = 4, color = WHITE } },
				{ "wait", 0.8 },
			},
		},
		{
			id = "le_ballon", label = "Le Ballon", sequence = { "up", "back", "up" },
			-- il gonfle l'adversaire à la pompe invisible comme un ballon de baudruche et le lâche au vent
			scene = {
				{ "fxAttacker", { "text", text = "( POMPE… POMPE… )", color = WHITE } },
				{ "grow", 1.3, time = 0.4 },
				{ "fx", { "ring", color = PINK, radius = 3, at = "root" } },
				{ "grow", 1.7, time = 0.4 },
				{ "color", PINK },
				{ "material", "Glass" },
				{ "fx", { "ring", color = PINK, radius = 4, at = "root" } },
				{ "text", "GONFLÉ !" },
				{ "wait", 0.4 },
				{ "lift", 4, time = 0.8 },
				{ "fxAttacker", { "symbols", symbols = { "👋" }, count = 2, color = WHITE } },
				{ "launch", Vector3.new(25, 70, 0), time = 1.6 },
				{ "wait", 0.3 },
			},
		},
	},

	-- Mécanique « Murs invisibles » : 2 murs au plus (voir server/Specials.lua)
	passive = { kind = "walls", name = "Murs invisibles", icon = "🧱", max = 2 },

	-- Recharge ⚡ : il se branche une pompe à vélo invisible dans le nombril et se regonfle en pompant,
	-- pendant qu'une bulle de dialogue vide grossit au-dessus de sa tête
	charge = {
		label = "Pompe à vélo",
		loop = 1.2,
		lockWrist = true,
		color = Color3.fromRGB(200, 225, 255),
		keys = {
			{ 0.0, { Root = { 0, 0, 0, 0, -0.1, 0 }, Waist = { -6, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 120, 0, -20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 80 }, LS = { 115, 0, 20 }, LE = { 110, 0, 0 }, LW = { 0, 0, -80 } } },
			{ 0.3, { Root = { 0, 0, 0, 0, -0.15, 0 }, Waist = { -10, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 45, 0, -20 }, RE = { 70, 0, 0 }, RW = { 0, 0, 80 }, LS = { 40, 0, 20 }, LE = { 70, 0, 0 }, LW = { 0, 0, -80 } } },
			{ 0.6, { Root = { 4, 0, 0, 0, -0.05, 0 }, Waist = { 8, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 120, 0, -20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 80 }, LS = { 115, 0, 20 }, LE = { 110, 0, 0 }, LW = { 0, 0, -80 } } },
			{ 0.9, { Root = { 0, 0, 0, 0, -0.15, 0 }, Waist = { -10, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 45, 0, -20 }, RE = { 70, 0, 0 }, RW = { 0, 0, 80 }, LS = { 40, 0, 20 }, LE = { 70, 0, 0 }, LW = { 0, 0, -80 } } },
			{ 1.2, { Root = { 0, 0, 0, 0, -0.1, 0 }, Waist = { -6, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 120, 0, -20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 80 }, LS = { 115, 0, 20 }, LE = { 110, 0, 0 }, LW = { 0, 0, -80 } } },
		},
		beats = {
			{ 0.3, { "symbols", symbols = { "💬" }, count = 1, radius = 1.5, at = "above", color = WHITE } },
			{ 0.9, { "particles", tex = "smoke", color = WHITE, dir = "all", at = "root", time = 0.15, speed = 3, size = 0.4 } },
		},
	},

	-- Manies au repos : il tâte un mur invisible, tire une corde imaginaire, s'appuie sur sa canne qui n'existe pas
	fidgets = {
		{ duration = 2.4, lockWrist = true, keys = {
			{ 0, {} },
			{ 0.4, { Neck = { 0, 0, 0 }, RS = { 90, 0, 20 }, RE = { 20, 0, 0 }, RW = { 85, 0, 0 }, LS = { 90, 0, -20 }, LE = { 20, 0, 0 }, LW = { 85, 0, 0 } } },
			{ 0.9, { Neck = { 0, 15, 0 }, RS = { 120, 0, 25 }, RE = { 20, 0, 0 }, RW = { 85, 0, 0 }, LS = { 85, 0, -20 }, LE = { 20, 0, 0 }, LW = { 85, 0, 0 } } },
			{ 1.4, { Neck = { 0, -15, 0 }, RS = { 85, 0, 20 }, RE = { 20, 0, 0 }, RW = { 85, 0, 0 }, LS = { 120, 0, -25 }, LE = { 20, 0, 0 }, LW = { 85, 0, 0 } } },
			{ 1.9, { Neck = { 10, 0, 0 }, RS = { 90, 0, 40 }, RE = { 20, 0, 0 }, RW = { 85, 0, 0 }, LS = { 90, 0, -40 }, LE = { 20, 0, 0 }, LW = { 85, 0, 0 } } },
			{ 2.4, {} },
		} },
		{ duration = 2.2, lockWrist = false, keys = {
			{ 0, {} },
			{ 0.35, { Root = { -6, 0, 0, 0, -0.15, -0.1 }, Waist = { -6, 0, 0 }, RS = { 140, 0, 5 }, RE = { 30, 0, 0 }, LS = { 120, 0, -5 }, LE = { 40, 0, 0 } } },
			{ 0.8, { Root = { 10, 0, 0, 0, -0.25, 0.2 }, Waist = { 14, 0, 0 }, RS = { 90, 0, 5 }, RE = { 100, 0, 0 }, LS = { 140, 0, -5 }, LE = { 30, 0, 0 } } },
			{ 1.25, { Root = { 12, 0, 0, 0, -0.3, 0.25 }, Waist = { 16, 0, 0 }, RS = { 140, 0, 5 }, RE = { 30, 0, 0 }, LS = { 90, 0, -5 }, LE = { 100, 0, 0 } } },
			{ 1.7, { Root = { 14, 0, 0, 0, -0.32, 0.3 }, Waist = { 18, 0, 0 }, RS = { 90, 0, 5 }, RE = { 100, 0, 0 }, LS = { 140, 0, -5 }, LE = { 30, 0, 0 } } },
			{ 2.2, {} },
		} },
		{ duration = 2.4, lockWrist = false, keys = {
			{ 0, {} },
			{ 0.4, { Root = { 0, 0, 6, 0.1, -0.05, 0 }, Waist = { 0, 0, 6 }, Neck = { 0, 0, 8 }, RS = { 30, 0, 25 }, RE = { 20, 0, 0 }, LS = { 0, 0, -10 }, LE = { 100, 0, 0 } } },
			{ 1.6, { Root = { 0, 0, 8, 0.12, -0.05, 0 }, Waist = { 0, 0, 8 }, Neck = { 0, 10, 10 }, RS = { 30, 0, 25 }, RE = { 20, 0, 0 }, LS = { 0, 0, -10 }, LE = { 105, 0, 0 } } },
			{ 1.8, { Root = { 0, 0, -10, -0.2, -0.2, 0 }, Waist = { -10, 0, -4 }, Neck = { 10, 0, -10 }, RS = { 60, 0, 60 }, RE = { 20, 0, 0 }, LS = { 60, 0, -60 }, LE = { 20, 0, 0 } } },
			{ 2.4, {} },
		} },
	},
}

-- Pendant qu'il tient quelqu'un : il tient à deux mains une corde invisible bien tendue, penché en arrière
data.grabHold = {
	Root = { 8, 10, 0, 0, -0.18, 0.2 },
	Waist = { 14, 6, 0 },
	Neck = { 8, -6, 0 },
	RS = { 80, 0, -8 },
	RE = { 45, 0, 0 },
	RW = { 0, 0, 0 },
	LS = { 86, 0, 8 },
	LE = { 65, 0, 0 },
}

-- Retour 🪂 : il descend lentement accroché à un ballon invisible, le lâche, ouvre une porte invisible et salue
-- (la plateforme elle-même est presque invisible : un plancher de verre)
data.respawn = {
	duration = 2.0,
	platform = { pieces = {
		{ "Plancher", "base", "block", Vector3.new(6, 0.6, 4), Vector3.new(0, -0.3, 0), Vector3.zero, GHOST, "Glass", { transparency = 0.7 } },
		{ "Bord", "", "block", Vector3.new(6.2, 0.08, 4.2), Vector3.new(0, 0.02, 0), Vector3.zero, WHITE, "SmoothPlastic", { transparency = 0.5 } },
		{ "Ficelle", "", "cyl", Vector3.new(4, 0.06, 0.06), Vector3.new(1.2, 6.8, 0), Vector3.zero, WHITE, "SmoothPlastic", { transparency = 0.5 } },
		{ "Ballon", "", "ball", Vector3.new(2.6, 3.2, 2.6), Vector3.new(1.2, 10.2, 0), Vector3.zero, PINK, "Glass", { transparency = 0.8 } },
		{ "Porte", "", "block", Vector3.new(0.2, 5.5, 2.6), Vector3.new(-2.6, 2.75, 0), Vector3.zero, GHOST, "Glass", { transparency = 0.88 } },
		{ "Poignee", "", "ball", Vector3.new(0.25, 0.25, 0.25), Vector3.new(-2.45, 2.6, -0.9), Vector3.zero, GHOST, "Glass", { transparency = 0.6 } },
	} },
	keys = {
		{ 0.0, { Root = { 0, 0, 3, 0, 0, 0 }, Waist = { 0, 0, 3 }, Neck = { 25, 0, 0 }, RS = { 178, 0, 5 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -30 }, LE = { 20, 0, 0 } } },
		{ 0.5, { Root = { 0, 0, -3, 0, 0, 0 }, Waist = { 0, 0, -3 }, Neck = { 25, 0, 0 }, RS = { 178, 0, 5 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 10, 0, -30 }, LE = { 20, 0, 0 } } },
		{ 0.75, { Neck = { 30, 0, 0 }, RS = { 150, 0, 30 }, RE = { 20, 0, 0 }, RW = { 0, 0, 40 }, LS = { 10, 0, -30 }, LE = { 20, 0, 0 } } },
		{ 1.0, { Root = { 0, 30, 0 }, Waist = { 0, 20, 0 }, Neck = { 0, -30, 0 }, RS = { 20, 0, 20 }, RE = { 40, 0, 0 }, LS = { 80, 0, -40 }, LE = { 30, 0, 0 }, LW = { 0, 0, -60 } } },
		{ 1.25, { Root = { 0, 10, 0 }, Waist = { 0, 0, 0 }, Neck = { 0, -10, 0 }, RS = { 20, 0, 20 }, RE = { 40, 0, 0 }, LS = { 70, 0, -90 }, LE = { 20, 0, 0 }, LW = { 0, 0, -60 } } },
		{ 1.55, { Root = { 0, 0, 0, 0, -0.1, 0 }, Waist = { -40, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, -30 }, RE = { 100, 0, 0 }, LS = { -40, 0, -50 }, LE = { 10, 0, 0 } } },
		{ 1.75, { Root = { 0, 0, 0, 0, -0.1, 0 }, Waist = { -40, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, -30 }, RE = { 100, 0, 0 }, LS = { -40, 0, -50 }, LE = { 10, 0, 0 } } },
		{ 2.0, {} },
	},
	beats = {
		{ 0.75, { "symbols", symbols = { "🎈" }, count = 1, radius = 2, at = "above", color = PINK } },
		{ 1.0, { "text", text = "( GRIIINCE )", color = WHITE } },
		{ 1.55, { "symbols", symbols = { "👏", "…" }, count = 4, radius = 3, color = WHITE } },
	},
}

-- Arbre d'enchaînements : après le coup de gauche, le bouton (avec sa direction) lance le coup de droite.
-- P P P P : claque, canne, porte claquée, grand coup de canne · → P P P : corde (ramène), vitre, canne à pêche (au ciel)
-- ↓ P P P : marche, chien invisible, tapis roulant (à l'horizontale) · K K K : pied, reprise, tête dans le ballon
-- (↑ K : ciseau muet) · → K K K : fente, double touche, moulinet. Les S finissent : Poussée du mur ou Coup de lasso.
local function airAfterP()
	return { K = "K_air", fwd_K = "K_air_side", up_K = "K_air_up", down_K = "K_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end
local function airAfterK()
	return { P = "P_air", fwd_P = "P_air_side", up_P = "P_air_up", down_P = "P_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end

local LINKS = {
	-- P P P P : fausse claque, canne invisible, claquement de porte, grand coup de canne (finition)
	P_neutral = { P = "P_combo2", K = "PK_combo", S = "S_finish_mur" },
	P_combo2 = { P = "P_porte2", K = "K_combo2", up_K = "K_up", S = "S_finish_corde" },
	P_porte2 = { P = "P_combo3", K = "K_tete", S = "S_finish_mur" },
	PK_combo = { P = "KP_combo", K = "K_combo3", S = "S_finish_corde" },
	KP_combo = { P = "P_combo3", K = "K_tete", S = "S_finish_mur" },
	-- K K K : pied imaginaire, reprise du gauche, tête dans le ballon (↑ K : ciseau muet)
	K_neutral = { K = "K_combo2", P = "KP_combo", S = "S_finish_mur" },
	K_combo2 = { K = "K_tete", up_K = "K_combo3", P = "P_porte2", S = "S_finish_corde" },
	-- → P P P : corde tirée (ramène), vitre invisible, canne à pêche (finition vers le ciel)
	P_side = { P = "P_vitre", K = "K_side", S = "S_finish_mur" },
	P_vitre = { P = "P_peche", K = "K_side2", S = "S_finish_corde" },
	-- ↓ P P P : marche d'escalier, chien invisible, tapis roulant (finition à l'horizontale)
	P_down = { P = "P_chien", K = "K_down", S = "S_finish_corde" },
	P_chien = { P = "P_tapis", K = "K_tete", S = "S_finish_mur" },
	-- → K K K : canne (fente), double touche, moulinet de canne (finition)
	K_side = { K = "K_side2", P = "KP_combo", S = "S_finish_mur" },
	K_side2 = { K = "K_side3", P = "P_vitre", S = "S_finish_corde" },
	-- autres départs
	P_up = { K = "K_up", S = "S_finish_corde" },
	K_down = { P = "P_up", K = "K_up", S = "S_finish_corde" },
	K_up = { S = "S_finish_corde" },
	P_dash = { P = "P_porte2", K = "K_side", S = "S_finish_mur" },
	K_dash = { P = "P_up", K = "K_up", S = "S_finish_corde" },
	-- en l'air ; les smashs ↓ sont des finitions sans suite
	P_air = airAfterP(),
	P_air_side = airAfterP(),
	P_air_up = airAfterP(),
	K_air = airAfterK(),
	K_air_side = airAfterK(),
	K_air_up = airAfterK(),
}
for key, links in pairs(LINKS) do
	data.moves[key].links = links
end

return data
