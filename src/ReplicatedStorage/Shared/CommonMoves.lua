-- Coups communs à tous les persos (ajoutés par CharacterList quand le perso n'a pas les siens) :
-- lancer de l'objet tenu (✋) et, à défaut, une saisie et des projections simples.
-- Même format que les coups des persos (voir l'en-tête de Characters/Gege.lua).
local function box(width, height, forward, up)
	return { size = Vector3.new(width, height, 6), offset = Vector2.new(forward, up) }
end

-- Lancer d'objet (kind = "item") : pas de zone de frappe, c'est l'objet lancé qui touche (voir server/Pickups.lua)
return {
	-- Lancer devant : grand geste par-dessus l'épaule, pas en avant
	ITEM_throw = {
		label = "Lancer d'objet", kind = "item", startup = 0.12, active = 0.05, recovery = 0.22, damage = 0,
		windup = { Root = { 8, -28, 0, 0, -0.15, 0.3 }, Waist = { 12, -36, 0 }, RS = { 190, 0, 25 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -15 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
		strike = { Root = { -12, 24, 0, 0, -0.35, -0.35 }, Waist = { -25, 36, 0 }, RS = { 70, 0, 0 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { -25, 0, -30 }, LE = { 80, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
		follow = { Root = { -16, 32, 0, 0, -0.42, -0.45 }, Waist = { -32, 46, 0 }, RS = { 30, 0, -15 }, RE = { 20, 0, 0 }, RW = { -10, 0, 0 }, LS = { -35, 0, -35 }, LE = { 85, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
		text = "TIENS !",
	},
	-- Lancer vers le haut : à deux mains au-dessus de la tête
	ITEM_throw_up = {
		label = "Lancer en l'air", kind = "item", startup = 0.12, active = 0.05, recovery = 0.22, damage = 0,
		windup = { Root = { 0, 0, 0, 0, -0.6, 0 }, Waist = { -15, 0, 0 }, RS = { 40, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 60, 0, 0 } },
		strike = { Root = { 4, 0, 0, 0, 0.2, 0 }, Waist = { 12, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 175, 0, 10 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -10 }, LE = { 5, 0, 0 } },
		follow = { Root = { 6, 0, 0, 0, 0.25, 0 }, Waist = { 15, 0, 0 }, Neck = { 35, 0, 0 }, RS = { 180, 0, 15 }, RE = { 5, 0, 0 }, RW = { -10, 0, 0 }, LS = { 175, 0, -15 }, LE = { 5, 0, 0 } },
		text = "HOP !",
	},
	-- Lancer vers le bas (en l'air) : l'objet est jeté sous ses pieds
	ITEM_throw_down = {
		label = "Lancer vers le bas", kind = "item", startup = 0.1, active = 0.05, recovery = 0.2, damage = 0,
		windup = { Root = { 10, 0, 0 }, Waist = { 15, 0, 0 }, RS = { 170, 0, 15 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 40, 0, 0 }, RH = { 40, 0, 0 }, RK = { -70, 0, 0 }, LH = { 50, 0, 0 }, LK = { -80, 0, 0 } },
		strike = { Root = { -15, 0, 0 }, Waist = { -30, 0, 0 }, RS = { 10, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -45 }, LE = { 20, 0, 0 }, RH = { 15, 0, 0 }, RK = { -40, 0, 0 }, LH = { 25, 0, 0 }, LK = { -60, 0, 0 } },
		follow = { Root = { -18, 0, 0 }, Waist = { -34, 0, 0 }, RS = { 0, 0, 10 }, RE = { 5, 0, 0 }, RW = { -10, 0, 0 }, LS = { -30, 0, -50 }, LE = { 20, 0, 0 }, RH = { 10, 0, 0 }, RK = { -35, 0, 0 }, LH = { 20, 0, 0 }, LK = { -55, 0, 0 } },
		text = "EN BAS !",
	},

	-- Saisie et projections par défaut (chaque perso a normalement les siennes)
	GRAB = {
		label = "Saisie", kind = "grab", startup = 0.1, active = 0.12, recovery = 0.35, damage = 0,
		hitbox = box(4, 4, 2, 0.5), kbBase = 0, kbGrowth = 0, kbAngle = 0,
		windup = { Root = { 4, 0, 0, 0, -0.1, 0.1 }, Waist = { 10, 0, 0 }, RS = { 110, 0, 50 }, RE = { 10, 0, 0 }, LS = { 110, 0, -50 }, LE = { 10, 0, 0 } },
		strike = { Root = { -6, 0, 0, 0, -0.2, -0.25 }, Waist = { -10, 0, 0 }, RS = { 88, 0, -15 }, RE = { 40, 0, 0 }, LS = { 88, 0, 15 }, LE = { 40, 0, 0 } },
		follow = { Root = { -6, 0, 0, 0, -0.2, -0.25 }, Waist = { -10, 0, 0 }, RS = { 90, 0, -18 }, RE = { 45, 0, 0 }, LS = { 90, 0, 18 }, LE = { 45, 0, 0 } },
	},
	THROW_fwd = {
		label = "Projection", kind = "throw", startup = 0.18, active = 0.05, recovery = 0.3,
		damage = 8, kbBase = 45, kbGrowth = 70, kbAngle = 35,
		carry = { { 0, 2.4, 0.6 }, { 0.1, 0.5, 1.5 }, { 0.18, 2.8, 1.2 } },
		windup = { Root = { 6, -30, 0, 0, -0.3, 0.2 }, Waist = { 10, -30, 0 }, RS = { 60, 0, 40 }, RE = { 60, 0, 0 }, LS = { 60, 0, -10 }, LE = { 70, 0, 0 } },
		strike = { Root = { -12, 30, 0, 0, -0.35, -0.3 }, Waist = { -18, 34, 0 }, RS = { 100, 0, -10 }, RE = { 10, 0, 0 }, LS = { 90, 0, 10 }, LE = { 10, 0, 0 } },
		follow = { Root = { -14, 36, 0, 0, -0.35, -0.35 }, Waist = { -20, 40, 0 }, RS = { 95, 0, -20 }, RE = { 15, 0, 0 }, LS = { 85, 0, 15 }, LE = { 15, 0, 0 } },
		hitText = "OUSTE !",
	},
	THROW_back = {
		label = "Projection arrière", kind = "throw", back = true, startup = 0.24, active = 0.05, recovery = 0.32,
		damage = 9, kbBase = 50, kbGrowth = 75, kbAngle = 40,
		carry = { { 0, 2.4, 0.6 }, { 0.12, 0, 4 }, { 0.24, -2.6, 1 } },
		windup = { Root = { 0, 40, 0, 0, -0.4, 0 }, Waist = { 0, 30, 0 }, RS = { 120, 0, 30 }, RE = { 40, 0, 0 }, LS = { 120, 0, -30 }, LE = { 40, 0, 0 } },
		strike = { Root = { 20, 170, 0, 0, -0.3, 0 }, Waist = { 20, 10, 0 }, Neck = { 20, 0, 0 }, RS = { 170, 0, 20 }, RE = { 20, 0, 0 }, LS = { 170, 0, -20 }, LE = { 20, 0, 0 } },
		follow = { Root = { 20, 175, 0, 0, -0.35, 0 }, Waist = { 22, 10, 0 }, Neck = { 22, 0, 0 }, RS = { 150, 0, 25 }, RE = { 25, 0, 0 }, LS = { 150, 0, -25 }, LE = { 25, 0, 0 } },
		hitText = "VLAN !",
	},
	THROW_up = {
		label = "Projection en l'air", kind = "throw", startup = 0.2, active = 0.05, recovery = 0.3,
		damage = 8, kbBase = 50, kbGrowth = 65, kbAngle = 88,
		carry = { { 0, 2.4, 0.6 }, { 0.1, 1.2, -0.5 }, { 0.2, 1, 4.5 } },
		windup = { Root = { 0, 0, 0, 0, -0.8, 0 }, Waist = { -20, 0, 0 }, RS = { 60, 0, 20 }, RE = { 60, 0, 0 }, LS = { 60, 0, -20 }, LE = { 60, 0, 0 } },
		strike = { Root = { 6, 0, 0, 0, 0.3, 0 }, Waist = { 15, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 175, 0, 10 }, RE = { 5, 0, 0 }, LS = { 175, 0, -10 }, LE = { 5, 0, 0 } },
		follow = { Root = { 8, 0, 0, 0, 0.35, 0 }, Waist = { 18, 0, 0 }, Neck = { 35, 0, 0 }, RS = { 180, 0, 15 }, RE = { 5, 0, 0 }, LS = { 180, 0, -15 }, LE = { 5, 0, 0 } },
		hitText = "DÉCOLLAGE !",
	},
	THROW_down = {
		label = "Écrasement", kind = "throw", startup = 0.2, active = 0.05, recovery = 0.35,
		damage = 7, kbBase = 40, kbGrowth = 45, kbAngle = 75,
		carry = { { 0, 2.4, 0.6 }, { 0.1, 2, 3 }, { 0.2, 2.2, -1.5 } },
		windup = { Root = { 10, 0, 0, 0, 0.1, 0 }, Waist = { 15, 0, 0 }, RS = { 170, 0, 15 }, RE = { 20, 0, 0 }, LS = { 170, 0, -15 }, LE = { 20, 0, 0 } },
		strike = { Root = { -20, 0, 0, 0, -0.7, -0.2 }, Waist = { -30, 0, 0 }, RS = { 60, 0, 10 }, RE = { 10, 0, 0 }, LS = { 60, 0, -10 }, LE = { 10, 0, 0 } },
		follow = { Root = { -22, 0, 0, 0, -0.75, -0.25 }, Waist = { -34, 0, 0 }, RS = { 50, 0, 10 }, RE = { 15, 0, 0 }, LS = { 50, 0, -10 }, LE = { 15, 0, 0 } },
		hitText = "SPLATCH !",
	},
}
