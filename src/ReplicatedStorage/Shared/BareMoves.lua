-- Coups « mains nues » (P / K seulement), communs à tous les persos : chaque perso entre dans l'arène avec ce moveset
-- de survie. Ses spéciaux (L), ses Supers (Y), sa saisie et ses fatals restent les siens, même sans arme.
-- Dès qu'il ramasse une Caisse Bizarre (bouton ✋), il sort UNE de ses 3 armes au hasard et ses coups P / K / S / Y
-- deviennent ceux de l'arme (Characters/*.lua, data.moves pour l'arme n° 1, data.weapons[i].moves pour les autres).
-- Même format que les coups des persos (voir l'en-tête de Characters/Gege.lua). Rangés sous « bare.clé »
-- (voir shared/MoveSets.lua et CharacterList.lua). Les suites vers un S_… renvoient au spécial du perso.
local function box(width, height, forward, up)
	return { size = Vector3.new(width, height, 6), offset = Vector2.new(forward, up) }
end

local moves = {
		-- J : jab du gauche, garde haute, petit pas en avant
		P_neutral = {
			label = "Coup de poing", startup = 0.06, active = 0.07, recovery = 0.14,
			damage = 5, hitbox = box(4, 3, 2.6, 0.8), kbBase = 18, kbGrowth = 22, kbAngle = 25,
			windup = { Root = { 2, 14, 0, 0, -0.2, 0.1 }, Waist = { 2, 10, 0 }, RS = { 45, 0, -8 }, RE = { 125, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -15 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -6, -14, 0, 0, -0.22, -0.25 }, Waist = { -6, -18, 0 }, RS = { 45, 0, -8 }, RE = { 122, 0, 0 }, RW = { 0, 0, 0 }, LS = { 95, 0, 6 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.25 } },
			follow = { Root = { -7, -16, 0, 0, -0.22, -0.28 }, Waist = { -7, -20, 0 }, RS = { 46, 0, -8 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, 4 }, LE = { 6, 0, 0 }, LW = { -8, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.28 } },
			trail = "bothHands", hitText = "POC !",
		},
		-- → J : direct du droit, le bassin tourne et l'épaule part dans le coup
		P_side = {
			label = "Direct à mains nues", startup = 0.09, active = 0.09, recovery = 0.18,
			damage = 7, hitbox = box(5, 3, 3, 0.8), kbBase = 22, kbGrowth = 35, kbAngle = 25, selfVelocity = Vector2.new(20, 0),
			windup = { Root = { 4, -22, 0, 0, -0.25, 0.2 }, Waist = { 4, -26, 0 }, RS = { 50, 0, 20 }, RE = { 125, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -5 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -12, 18, 0, 0, -0.32, -0.45 }, Waist = { -10, 22, 0 }, RS = { 100, 0, -4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { -14, 22, 0, 0, -0.34, -0.5 }, Waist = { -12, 26, 0 }, RS = { 96, 0, -10 }, RE = { 6, 0, 0 }, RW = { -8, 0, 0 }, LS = { 25, 0, -22 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			trail = "bothHands", hitText = "PAF !",
		},
		-- ↓ J : accroupi, petit crochet au corps
		P_down = {
			label = "Coup dans le ventre", startup = 0.08, active = 0.08, recovery = 0.18,
			damage = 5, hitbox = box(4, 2.2, 2.5, -1.2), kbBase = 22, kbGrowth = 25, kbAngle = 60,
			windup = { Root = { -6, 16, 0, 0, -0.85, 0.1 }, Waist = { -14, 14, 0 }, RS = { 30, 0, 10 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -12, -14, 0, 0, -0.95, -0.2 }, Waist = { -22, -18, 0 }, RS = { 20, 0, 10 }, RE = { 125, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 10 }, LE = { 20, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
			follow = { Root = { -13, -18, 0, 0, -0.95, -0.24 }, Waist = { -24, -22, 0 }, RS = { 20, 0, 12 }, RE = { 125, 0, 0 }, RW = { 0, 0, 0 }, LS = { 56, 0, 14 }, LE = { 25, 0, 0 }, LW = { -10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
			trail = "bothHands", hitText = "TOC !",
		},
		-- ↑ J : uppercut court, de la hanche vers le menton
		P_up = {
			label = "Uppercut", startup = 0.09, active = 0.1, recovery = 0.2,
			damage = 6, hitbox = box(4, 5, 1.5, 3), kbBase = 26, kbGrowth = 30, kbAngle = 85,
			windup = { Root = { -8, -12, 0, 0, -0.6, 0.05 }, Waist = { -16, -10, 0 }, RS = { -20, 0, 15 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -10 }, LE = { 125, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { 6, 12, 0, 0, 0.3, 0 }, Waist = { 16, 16, 0 }, Neck = { 25, 0, 0 }, RS = { 170, 0, 0 }, RE = { 25, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0 }, FL = { 0, 0, 0, 0, 0.3, 0 } },
			follow = { Root = { 8, 14, 0, 0, 0.4, 0 }, Waist = { 20, 18, 0 }, Neck = { 30, 0, 0 }, RS = { 178, 0, 5 }, RE = { 15, 0, 0 }, RW = { -10, 0, 0 }, LS = { 15, 0, -35 }, LE = { 105, 0, 0 }, LW = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.35, 0 }, FL = { 0, 0, 0, 0, 0.35, 0 } },
			trail = "bothHands", hitText = "BING !",
		},
		-- J en l'air : une-deux en l'air, genoux repliés
		P_air = {
			label = "Une-deux en l'air", startup = 0.08, active = 0.12, recovery = 0.16,
			damage = 6, hitbox = box(4, 3.5, 2, 0), kbBase = 20, kbGrowth = 30, kbAngle = 30,
			windup = { Root = { 8, -15, 0 }, Waist = { 10, -12, 0 }, RS = { 40, 0, -5 }, RE = { 125, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, 5 }, LE = { 125, 0, 0 }, LW = { 0, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
			strike = { Root = { -10, 18, 0 }, Waist = { -10, 20, 0 }, RS = { 95, 0, -5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 35, 0, -5 }, LE = { 125, 0, 0 }, LW = { 0, 0, 0 }, RH = { 35, 0, 0 }, RK = { -65, 0, 0 }, LH = { 60, 0, 0 }, LK = { -95, 0, 0 } },
			follow = { Root = { -10, -18, 0 }, Waist = { -12, -20, 0 }, RS = { 40, 0, -5 }, RE = { 125, 0, 0 }, RW = { 0, 0, 0 }, LS = { 95, 0, 5 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, RH = { 60, 0, 0 }, RK = { -95, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
			trail = "bothHands", hitText = "PIF PAF !",
		},
		-- ↓ J en l'air : les deux poings joints abattus vers le bas
		P_air_down = {
			label = "Double marteau", startup = 0.14, active = 0.1, recovery = 0.26,
			damage = 9, hitbox = box(4.5, 4, 1.5, -1.5), kbBase = 26, kbGrowth = 55, kbAngle = -60,
			windup = { Root = { 18, 0, 0 }, Waist = { 20, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 190, 0, -15 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 190, 0, 15 }, LE = { 40, 0, 0 }, LW = { 0, 0, 0 }, RH = { 80, 0, 0 }, RK = { -120, 0, 0 }, LH = { 70, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { -18, 0, 0 }, Waist = { -34, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 55, 0, -15 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 55, 0, 15 }, LE = { 10, 0, 0 }, LW = { 0, 0, 0 }, RH = { 10, 0, 0 }, RK = { -30, 0, 0 }, LH = { 20, 0, 0 }, LK = { -40, 0, 0 } },
			follow = { Root = { -24, 0, 0 }, Waist = { -38, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 35, 0, -15 }, RE = { 10, 0, 0 }, RW = { -15, 0, 0 }, LS = { 35, 0, 15 }, LE = { 10, 0, 0 }, LW = { -15, 0, 0 }, RH = { 5, 0, 0 }, RK = { -25, 0, 0 }, LH = { 15, 0, 0 }, LK = { -35, 0, 0 } },
			trail = "bothHands", hitText = "BAM !",
		},
		-- K : cross appuyé, tout le poids du corps dans le poing droit
		K_neutral = {
			label = "Gros direct", startup = 0.18, active = 0.1, recovery = 0.3,
			damage = 11, hitbox = box(5, 3.5, 3, 0.8), kbBase = 30, kbGrowth = 70, kbAngle = 35,
			windup = { Root = { 10, -30, 0, 0, -0.25, 0.3 }, Waist = { 8, -28, 0 }, Neck = { 6, 18, 0 }, RS = { 50, 0, 40 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -10 }, LE = { 100, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -16, 22, 0, 0, -0.35, -0.5 }, Waist = { -14, 26, 0 }, Neck = { -6, -14, 0 }, RS = { 100, 0, -4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -25 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -18, 26, 0, 0, -0.37, -0.55 }, Waist = { -16, 30, 0 }, Neck = { -8, -16, 0 }, RS = { 96, 0, -12 }, RE = { 5, 0, 0 }, RW = { -10, 0, 0 }, LS = { 15, 0, -28 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			trail = "bothHands", hitText = "VLAN !",
		},
		-- → K : crochet large avec un pas chassé
		K_side = {
			label = "Crochet élancé", startup = 0.2, active = 0.12, recovery = 0.32,
			damage = 12, hitbox = box(5, 3.5, 3, 1), kbBase = 32, kbGrowth = 80, kbAngle = 30, selfVelocity = Vector2.new(32, 0),
			windup = { Root = { -10, -30, 0, 0, -0.3, 0.1 }, Waist = { -8, -25, 0 }, Neck = { 10, 10, 0 }, RS = { 40, 0, 90 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -30 }, LE = { 60, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -14, 18, 0, 0, -0.35, -0.5 }, Waist = { -16, 20, 0 }, Neck = { -6, -15, 0 }, RS = { 95, 0, -5 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { -10, 0, -40 }, LE = { 60, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -16, 24, 0, 0, -0.38, -0.55 }, Waist = { -18, 26, 0 }, Neck = { -8, -18, 0 }, RS = { 90, 0, -25 }, RE = { 70, 0, 0 }, RW = { -10, 0, 0 }, LS = { -15, 0, -45 }, LE = { 60, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			trail = "bothHands", fx = { "dust" }, hitText = "BAOUM !",
		},
		-- ↓ K : crochet au ras du sol qui fait décoller
		K_down = {
			label = "Coup de genou bas", startup = 0.18, active = 0.12, recovery = 0.3,
			damage = 11, hitbox = box(6, 2.5, 2.5, -1.5), kbBase = 32, kbGrowth = 65, kbAngle = 70,
			windup = { Root = { -10, -35, 0, 0, -1.0, 0.15 }, Waist = { -20, -25, 0 }, Neck = { 15, 15, 0 }, RS = { 20, 0, 95 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -15 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -16, 18, 0, 0, -1.1, -0.2 }, Waist = { -26, 18, 0 }, Neck = { 20, -10, 0 }, RS = { 55, 0, 0 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -40 }, LE = { 100, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, -0.1, 0, -0.3 } },
			follow = { Root = { -18, 24, 0, 0, -1.1, -0.25 }, Waist = { -28, 22, 0 }, Neck = { 22, -12, 0 }, RS = { 50, 0, -15 }, RE = { 35, 0, 0 }, RW = { -10, 0, 0 }, LS = { 15, 0, -45 }, LE = { 100, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, -0.1, 0, -0.35 } },
			trail = "bothHands", hitText = "BADADOUM !",
		},
		-- ↑ K : grand uppercut qui monte jusqu'au ciel
		K_up = {
			label = "Grand uppercut", startup = 0.2, active = 0.14, recovery = 0.32,
			damage = 12, hitbox = box(5, 6, 1, 3.5), kbBase = 34, kbGrowth = 75, kbAngle = 88,
			windup = { Root = { -8, -30, 0, 0, -1.0, 0 }, Waist = { -28, -20, 0 }, Neck = { -22, 0, 0 }, RS = { -35, 0, 30 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -15 }, LE = { 125, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { 6, 0, 0, 0, 0.5, 0 }, Waist = { 16, 10, 0 }, Neck = { 32, 0, 0 }, RS = { 175, 0, 5 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { -30, 0, -40 }, LE = { 50, 0, 0 }, LW = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.4, 0 }, FL = { 0, 0, 0, 0, 0.4, 0 } },
			follow = { Root = { 8, 0, 0, 0, 0.6, 0 }, Waist = { 20, 12, 0 }, Neck = { 38, 0, 0 }, RS = { 180, 0, 0 }, RE = { 5, 0, 0 }, RW = { -10, 0, 0 }, LS = { -35, 0, -45 }, LE = { 45, 0, 0 }, LW = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.5, 0 }, FL = { 0, 0, 0, 0, 0.45, 0 } },
			trail = "bothHands", hitText = "DZOING !",
		},
		-- K en l'air : direct plongeant, poing tendu vers l'avant
		K_air = {
			label = "Coup de poing volant", startup = 0.14, active = 0.12, recovery = 0.26,
			damage = 11, hitbox = box(5, 3.5, 2.8, 0), kbBase = 28, kbGrowth = 65, kbAngle = 35,
			windup = { Root = { 10, -25, 0 }, Waist = { 8, -25, 0 }, RS = { 50, 0, 30 }, RE = { 125, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -10 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 }, RH = { 80, 0, 0 }, RK = { -110, 0, 0 }, LH = { 60, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { -14, 20, 0 }, Waist = { -12, 24, 0 }, RS = { 100, 0, -4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 70, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { -16, 24, 0 }, Waist = { -14, 26, 0 }, RS = { 96, 0, -10 }, RE = { 5, 0, 0 }, RW = { -10, 0, 0 }, LS = { 15, 0, -32 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 }, RH = { 15, 0, 0 }, RK = { -35, 0, 0 }, LH = { 75, 0, 0 }, LK = { -105, 0, 0 } },
			trail = "bothHands", hitText = "BLAM !",
		},
		-- J J : direct du droit qui suit le jab
		P_combo2 = {
			label = "Une-deux", startup = 0.07, active = 0.08, recovery = 0.16,
			damage = 5, hitbox = box(4, 3, 2.8, 0.8), kbBase = 18, kbGrowth = 24, kbAngle = 28,
			windup = { Root = { 4, -20, 0, 0, -0.22, 0.1 }, Waist = { 6, -24, 0 }, RS = { 55, 0, 15 }, RE = { 125, 0, 0 }, RW = { 0, 0, 0 }, LS = { 85, 0, 0 }, LE = { 20, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -12, 16, 0, 0, -0.28, -0.35 }, Waist = { -10, 20, 0 }, RS = { 98, 0, -6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -10 }, LE = { 125, 0, 0 }, LW = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0, -0.15 } },
			follow = { Root = { -14, 20, 0, 0, -0.3, -0.4 }, Waist = { -12, 24, 0 }, RS = { 95, 0, -12 }, RE = { 5, 0, 0 }, RW = { -10, 0, 0 }, LS = { 40, 0, -12 }, LE = { 125, 0, 0 }, LW = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0, -0.2 } },
			trail = "bothHands", hitText = "BING !",
		},
		-- J J J : crochet du gauche pour finir la série
		P_combo3 = {
			label = "Crochet du gauche", startup = 0.09, active = 0.1, recovery = 0.22,
			damage = 7, hitbox = box(5, 3, 2.5, 0.8), kbBase = 26, kbGrowth = 45, kbAngle = 35,
			windup = { Root = { 6, 25, 0, 0, -0.3, 0.15 }, Waist = { 8, 30, 0 }, Neck = { 4, -15, 0 }, RS = { 40, 0, -5 }, RE = { 125, 0, 0 }, RW = { 0, 0, 0 }, LS = { 75, 0, -80 }, LE = { 95, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -10, -25, 0, 0, -0.35, -0.3 }, Waist = { -10, -32, 0 }, Neck = { -4, 15, 0 }, RS = { 35, 0, -10 }, RE = { 125, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -20 }, LE = { 85, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
			follow = { Root = { -12, -35, 0, 0, -0.36, -0.35 }, Waist = { -12, -42, 0 }, Neck = { -4, 18, 0 }, RS = { 35, 0, -10 }, RE = { 125, 0, 0 }, RW = { 0, 0, 0 }, LS = { 88, 0, 5 }, LE = { 90, 0, 0 }, LW = { -10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
			trail = "bothHands", hitText = "BADABING !",
		},
		-- K K : second cross, cette fois du gauche
		K_combo2 = {
			label = "Revers du gauche", startup = 0.15, active = 0.1, recovery = 0.28,
			damage = 10, hitbox = box(5, 3.5, 2.8, 0.8), kbBase = 30, kbGrowth = 65, kbAngle = 35,
			windup = { Root = { 12, 35, 0, 0, -0.3, 0.25 }, Waist = { 12, 35, 0 }, Neck = { 6, -20, 0 }, RS = { 40, 0, -5 }, RE = { 125, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -100 }, LE = { 30, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -14, -30, 0, 0, -0.4, -0.35 }, Waist = { -14, -38, 0 }, Neck = { -6, 15, 0 }, RS = { -20, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 100, 0, -10 }, LE = { 20, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
			follow = { Root = { -18, -45, 0, 0, -0.42, -0.4 }, Waist = { -16, -46, 0 }, Neck = { -8, 18, 0 }, RS = { -25, 0, 35 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 95, 0, 20 }, LE = { 25, 0, 0 }, LW = { -10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			trail = "bothHands", hitText = "BLAM !",
		},
		

	------------------------------------------------------------------ Spéciaux à mains nues (S)
	-- S : poing armé jusqu'à l'oreille puis lâché de tout son poids
	S_neutral = {
		label = "Poing de la colère", energyCost = 20, startup = 0.16, active = 0.1, recovery = 0.32,
		damage = 10, hitbox = box(5, 3.5, 3, 0.8), kbBase = 30, kbGrowth = 65, kbAngle = 35,
		windup = { Root = { 10, -35, 0, 0, -0.3, 0.3 }, Waist = { 10, -30, 0 }, Neck = { 6, 20, 0 }, RS = { 120, 0, 70 }, RE = { 140, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -10 }, LE = { 60, 0, 0 } },
		strike = { Root = { -18, 25, 0, 0, -0.4, -0.55 }, Waist = { -16, 30, 0 }, Neck = { -6, -16, 0 }, RS = { 100, 0, -4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
		follow = { Root = { -20, 28, 0, 0, -0.42, -0.6 }, Waist = { -18, 32, 0 }, Neck = { -8, -18, 0 }, RS = { 95, 0, -12 }, RE = { 5, 0, 0 }, RW = { -10, 0, 0 }, LS = { -25, 0, -45 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.6 } },
		shake = true, trail = "rightHand", fx = { { "ring", color = Color3.fromRGB(255, 230, 120), radius = 3, at = "front" } }, hitText = "POW !",
	},
	-- → S : charge à l'épaule sur quelques mètres
	S_side = {
		label = "Charge d'épaule", energyCost = 25, startup = 0.1, active = 0.25, recovery = 0.3,
		damage = 10, hitbox = box(4, 4, 2, 0.3), kbBase = 30, kbGrowth = 60, kbAngle = 30, selfVelocity = Vector2.new(58, 0),
		windup = { Root = { -12, -30, 0, 0, -0.35, 0.2 }, Waist = { -8, -20, 0 }, Neck = { 10, 20, 0 }, RS = { -30, 0, 25 }, RE = { 60, 0, 0 }, LS = { 50, 0, -20 }, LE = { 100, 0, 0 } },
		strike = { Root = { -25, -50, 0, 0, -0.45, -0.3 }, Waist = { -10, -20, 0 }, Neck = { 20, 30, 0 }, RS = { -30, 0, 35 }, RE = { 50, 0, 0 }, LS = { 30, 0, -10 }, LE = { 115, 0, 0 } },
		follow = { Root = { -26, -52, 0, 0, -0.45, -0.32 }, Waist = { -12, -22, 0 }, Neck = { 22, 32, 0 }, RS = { -35, 0, 38 }, RE = { 50, 0, 0 }, LS = { 28, 0, -10 }, LE = { 118, 0, 0 } },
		fx = { "dust" }, hitText = "BAM !",
	},
	-- ↓ S : balayage tournant au ras du sol
	S_down = {
		label = "Balayage tournant", energyCost = 20, startup = 0.14, active = 0.18, recovery = 0.3,
		damage = 9, hitbox = box(7, 2, 0.5, -2), kbBase = 30, kbGrowth = 50, kbAngle = 78,
		windup = { Root = { -8, -30, 0, 0, -1.1, 0 }, Waist = { -20, -15, 0 }, RS = { 20, 0, 60 }, LS = { 20, 0, -60 } },
		strike = { Root = { -10, 0, 0, 0, -1.25, 0 }, Waist = { -20, 0, 0 }, RS = { 10, 0, 60 }, LS = { 20, 0, -60 }, RH = { 75, 0, 15 }, RK = { -5, 0, 0 }, RA = { -20, 0, 0 } },
		follow = { Root = { -10, 0, 0, 0, -1.2, 0 }, Waist = { -18, 0, 0 }, RS = { 15, 0, 62 }, LS = { 25, 0, -62 }, RH = { 72, 0, 18 }, RK = { -8, 0, 0 }, RA = { -20, 0, 0 } },
		spin = { axis = "y", degrees = 360 }, trail = "rightFoot", hitText = "ZOUIP !",
	},
	-- ↑ S : grand bond vers le ciel, poing levé (la remontée : gratuite)
	S_up = {
		label = "Grand bond", energyCost = 0, startup = 0.05, active = 0.3, recovery = 0.3,
		damage = 6, hitbox = box(4, 6, 0.5, 2), kbBase = 28, kbGrowth = 35, kbAngle = 85, selfVelocity = Vector2.new(8, 82),
		windup = { Root = { 0, 0, 0, 0, -0.8, 0 }, Waist = { -15, 0, 0 }, RS = { -30, 0, 20 }, LS = { -30, 0, -20 } },
		strike = { Root = { 4, 0, 0, 0, 0.4, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 178, 0, 8 }, RE = { 5, 0, 0 }, LS = { 30, 0, -40 }, LE = { 40, 0, 0 }, RH = { 10, 0, 0 }, RK = { -20, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
		follow = { Root = { 6, 0, 0, 0, 0.45, 0 }, Waist = { 12, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 180, 0, 4 }, RE = { 5, 0, 0 }, LS = { 25, 0, -42 }, LE = { 40, 0, 0 }, RH = { 15, 0, 0 }, RK = { -30, 0, 0 }, LH = { 55, 0, 0 }, LK = { -95, 0, 0 } },
		trail = "rightHand", hitText = "HOP !",
	},
	-- S maintenu : il prend son élan en tournant le bras, puis un énorme crochet
	S_hold = {
		label = "Moulinet géant", energyCost = 35, startup = 0.2, active = 0.14, recovery = 0.4,
		damage = 14, hitbox = box(6, 4, 2.5, 0.8), kbBase = 32, kbGrowth = 85, kbAngle = 38,
		windup = { Root = { 6, -40, 0, 0, -0.3, 0.3 }, Waist = { 6, -35, 0 }, Neck = { 6, 25, 0 }, RS = { 170, 0, 80 }, RE = { 20, 0, 0 }, LS = { 70, 0, -30 }, LE = { 60, 0, 0 } },
		strike = { Root = { -16, 30, 0, 0, -0.4, -0.5 }, Waist = { -14, 40, 0 }, Neck = { -6, -20, 0 }, RS = { 95, 0, -10 }, RE = { 10, 0, 0 }, LS = { -20, 0, -45 }, LE = { 50, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
		follow = { Root = { -18, 40, 0, 0, -0.42, -0.55 }, Waist = { -16, 50, 0 }, Neck = { -8, -24, 0 }, RS = { 90, 0, -30 }, RE = { 15, 0, 0 }, LS = { -25, 0, -50 }, LE = { 50, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
		shake = true, trail = "rightHand", fx = { { "ring", color = Color3.fromRGB(255, 200, 80), radius = 5, at = "front" } }, hitText = "BADABOUM !",
	},
	-- dash puis S : plongeon tête la première
	S_dash = {
		label = "Plongeon tête la première", energyCost = 25, startup = 0.06, active = 0.28, recovery = 0.32,
		damage = 10, hitbox = box(4.5, 3, 2, 0), kbBase = 30, kbGrowth = 60, kbAngle = 30, selfVelocity = Vector2.new(62, 20),
		windup = { Root = { -15, 0, 0, 0, -0.4, 0 }, RS = { -40, 0, 20 }, LS = { -40, 0, -20 } },
		strike = { Root = { -75, 0, 0 }, Waist = { -8, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 175, 0, 10 }, RE = { 0, 0, 0 }, LS = { 175, 0, -10 }, LE = { 0, 0, 0 }, RH = { -10, 0, 0 }, RK = { -15, 0, 0 }, LH = { -10, 0, 0 }, LK = { -25, 0, 0 } },
		follow = { Root = { -80, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 178, 0, 12 }, RE = { 0, 0, 0 }, LS = { 178, 0, -12 }, LE = { 0, 0, 0 }, RH = { -15, 0, 0 }, RK = { -20, 0, 0 }, LH = { -15, 0, 0 }, LK = { -30, 0, 0 } },
		trail = "body", hitText = "BONK !",
	},
	-- esquive puis S : contre-poing qui sort de l'esquive
	S_dodge = {
		label = "Contre-poing", energyCost = 20, startup = 0.06, active = 0.1, recovery = 0.28, invuln = 0.12,
		damage = 8, hitbox = box(4.5, 3.5, 2.6, 0.8), kbBase = 32, kbGrowth = 45, kbAngle = 40,
		windup = { Root = { 10, 20, 0, 0, -0.5, 0.3 }, Waist = { 10, 20, 0 }, RS = { 40, 0, 20 }, RE = { 130, 0, 0 }, LS = { 90, 0, 30 }, LE = { 110, 0, 0 } },
		strike = { Root = { -12, -20, 0, 0, -0.3, -0.4 }, Waist = { -10, -20, 0 }, RS = { 95, 0, -5 }, RE = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 110, 0, 0 } },
		follow = { Root = { -14, -22, 0, 0, -0.3, -0.45 }, Waist = { -12, -24, 0 }, RS = { 92, 0, -12 }, RE = { 5, 0, 0 }, LS = { 25, 0, -22 }, LE = { 110, 0, 0 } },
		trail = "rightHand", text = "ET HOP !", hitText = "CONTRE !",
	},
	-- S en l'air : coup de pied plongeant en diagonale
	S_air = {
		label = "Coup de pied plongeant", energyCost = 20, startup = 0.1, active = 0.3, recovery = 0.3,
		damage = 10, hitbox = box(4, 4, 1.8, -1.2), kbBase = 26, kbGrowth = 55, kbAngle = -30, selfVelocity = Vector2.new(35, -60),
		windup = { Root = { 10, 0, 0 }, Waist = { 10, 0, 0 }, RS = { 100, 0, 40 }, LS = { 100, 0, -40 }, RH = { 90, 0, 0 }, RK = { -120, 0, 0 }, LH = { 80, 0, 0 }, LK = { -120, 0, 0 } },
		strike = { Root = { 25, 0, 0 }, Waist = { 10, 0, 0 }, RS = { -20, 0, 50 }, LS = { -20, 0, -50 }, RH = { 80, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 30, 0, 0 }, LK = { -100, 0, 0 } },
		follow = { Root = { 28, 0, 0 }, Waist = { 12, 0, 0 }, RS = { -25, 0, 55 }, LS = { -25, 0, -55 }, RH = { 84, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 28, 0, 0 }, LK = { -104, 0, 0 } },
		trail = "rightFoot", hitText = "SBAF !",
	},
	-- Dash puis J (ou J pendant la ruée) : il fonce poing en avant, sur sa lancée
	P_dash = {
		label = "Poing de la ruée", startup = 0.06, active = 0.14, recovery = 0.22,
		damage = 8, hitbox = box(4.5, 3.5, 2.5, 0.6), kbBase = 28, kbGrowth = 45, kbAngle = 28, selfVelocity = Vector2.new(48, 0),
		windup = { Root = { -8, -18, 0, 0, -0.3, 0.1 }, Waist = { -6, -14, 0 }, RS = { 30, 0, 20 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -15 }, LE = { 115, 0, 0 }, LW = { 0, 0, 0 } },
		strike = { Root = { -20, 16, 0, 0, -0.4, -0.35 }, Waist = { -14, 18, 0 }, RS = { 98, 0, -4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -25 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
		follow = { Root = { -22, 18, 0, 0, -0.42, -0.4 }, Waist = { -16, 20, 0 }, RS = { 95, 0, -8 }, RE = { 5, 0, 0 }, RW = { -8, 0, 0 }, LS = { 15, 0, -28 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
		trail = "rightHand", fx = { "dust" }, hitText = "VLAM !",
	},
	-- Dash puis K (ou K pendant la ruée) : glissade, les deux pieds devant
	K_dash = {
		label = "Glissade tacle", startup = 0.08, active = 0.24, recovery = 0.3,
		damage = 10, hitbox = box(6, 2, 3, -2), kbBase = 30, kbGrowth = 55, kbAngle = 65, selfVelocity = Vector2.new(55, 0),
		windup = { Root = { -10, 0, 0, 0, -0.6, 0 }, Waist = { -18, 0, 0 }, RS = { 60, 0, 40 }, RE = { 30, 0, 0 }, LS = { 60, 0, -40 }, LE = { 30, 0, 0 }, RH = { 50, 0, 0 }, RK = { -95, 0, 0 }, LH = { 50, 0, 0 }, LK = { -95, 0, 0 } },
		strike = { Root = { 45, 0, 0, 0, -1.6, 0 }, Waist = { -25, 0, 0 }, Neck = { -25, 0, 0 }, RS = { 150, 0, 50 }, RE = { 10, 0, 0 }, LS = { 150, 0, -50 }, LE = { 10, 0, 0 }, RH = { 85, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 75, 0, 0 }, LK = { -15, 0, 0 } },
		follow = { Root = { 50, 0, 0, 0, -1.62, 0 }, Waist = { -27, 0, 0 }, Neck = { -27, 0, 0 }, RS = { 160, 0, 55 }, RE = { 15, 0, 0 }, LS = { 145, 0, -60 }, LE = { 20, 0, 0 }, RH = { 88, 0, 0 }, RK = { 0, 0, 0 }, RA = { 18, 0, 0 }, LH = { 78, 0, 0 }, LK = { -12, 0, 0 } },
		trail = "rightFoot", fx = { "dust" }, hitText = "TCHAC !",
	},
	-- ↓ S en l'air : chute lourde, genoux en premier
	S_air_down = {
		label = "Chute lourde", energyCost = 20, startup = 0.12, active = 0.35, recovery = 0.3,
		damage = 11, hitbox = box(4.5, 4, 0.5, -2), kbBase = 25, kbGrowth = 55, kbAngle = -70, selfVelocity = Vector2.new(0, -85),
		windup = { Root = { -10, 0, 0 }, Waist = { -18, 0, 0 }, RS = { 150, 0, 40 }, LS = { 150, 0, -40 }, RH = { 100, 0, 0 }, RK = { -130, 0, 0 }, LH = { 100, 0, 0 }, LK = { -130, 0, 0 } },
		strike = { Root = { 4, 0, 0 }, Waist = { 6, 0, 0 }, RS = { 160, 0, 50 }, LS = { 160, 0, -50 }, RH = { 40, 0, 0 }, RK = { -80, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
		follow = { Root = { 4, 0, 0 }, Waist = { 8, 0, 0 }, RS = { 165, 0, 55 }, LS = { 165, 0, -55 }, RH = { 35, 0, 0 }, RK = { -75, 0, 0 }, LH = { 35, 0, 0 }, LK = { -75, 0, 0 } },
		fx = { "dust" }, hitText = "BOUM !",
	},
}

-- Enchaînements à mains nues : courts et simples (les vrais combos viennent avec l'arme)
local links = {
	P_neutral = { P = "P_combo2", K = "K_neutral", S = "S_neutral" }, -- J
	P_combo2 = { P = "P_combo3", K = "K_combo2", S = "S_side" }, -- J J
	P_combo3 = { K = "K_up", S = "S_neutral" }, -- J J J
	P_side = { P = "P_combo3", K = "K_side", S = "S_side" }, -- → J
	P_down = { P = "P_up", K = "K_down", S = "S_down" }, -- ↓ J
	P_up = { K = "K_up", S = "S_neutral" }, -- ↑ J
	K_neutral = { K = "K_combo2", P = "P_combo2", up_K = "K_up", S = "S_neutral" }, -- K
	K_combo2 = { K = "K_up", S = "S_side" }, -- K K
	P_dash = { P = "P_combo2", K = "K_side", S = "S_side" }, -- dash J
	K_dash = { P = "P_up", S = "S_up" }, -- dash K
	P_air = { K = "K_air", down_P = "P_air_down", up_S = "S_up", S = "S_air" },
	K_air = { P = "P_air", down_P = "P_air_down", up_S = "S_up", S = "S_air" },
}

return { moves = moves, links = links }
