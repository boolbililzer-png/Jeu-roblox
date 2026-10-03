-- Gaston le Magnifique : magicien de cabaret raté, cape trop grande, haut-de-forme habité par un lapin grognon,
-- baguette qui crépite. Rien ne se passe jamais comme prévu. Arme sortie de la Caisse Bizarre : Baguette de
-- Magie & Chapeau (le chapeau est toujours sur sa tête, la baguette n'apparaît qu'une fois la caisse ouverte).
--
-- Mécanique « tricks » (Tours ratés) : chacun de ses spéciaux (S_*) a 3 résultats possibles (variants), dans
-- l'ordre des icônes du passif : 🕊️ colombe, 💥 confettis explosifs, 🐇 lapin agressif. Le prochain résultat est
-- affiché au-dessus de lui (NextTrick) pour garder de la stratégie. L'animation reste la même, seul l'effet change.
-- Format des coups, poses et effets : voir Gege.lua et docs/fiche-perso.md.

local function box(width, height, forward, up)
	return { size = Vector3.new(width, height, 6), offset = Vector2.new(forward, up) }
end

local MAGIC = Color3.fromRGB(190, 110, 255)
local SPARK = Color3.fromRGB(255, 235, 120)
local TUX = Color3.fromRGB(28, 26, 38)
local VELVET = Color3.fromRGB(190, 25, 45)
local SATIN = Color3.fromRGB(95, 40, 130)
local WHITE = Color3.fromRGB(245, 245, 250)
local SKIN = Color3.fromRGB(245, 205, 175)
local RABBIT = Color3.fromRGB(215, 215, 220)
local PINK = Color3.fromRGB(255, 160, 185)
local GOLD = Color3.fromRGB(235, 190, 60)
local SMOKE = Color3.fromRGB(170, 170, 185)

-- Projectiles décrits (voir client/Fx.lua buildCustomProjectile)
local CARD = { shape = "ball", size = 0.1, color = WHITE, spin = 18, parts = {
	{ "block", Vector3.new(0.9, 1.25, 0.08), Vector3.new(0, 0, 0), WHITE },
	{ "block", Vector3.new(0.35, 0.35, 0.1), Vector3.new(0, 0, 0), VELVET },
} }
local DOVE = { shape = "ball", size = 0.9, color = WHITE, parts = {
	{ "ball", Vector3.new(0.55, 0.55, 0.55), Vector3.new(0.55, 0.3, 0), WHITE },
	{ "block", Vector3.new(0.25, 0.12, 0.15), Vector3.new(0.9, 0.28, 0), GOLD },
	{ "block", Vector3.new(0.7, 0.08, 1.6), Vector3.new(-0.05, 0.25, 0), WHITE },
} }
local CONFETTI_BOMB = { shape = "ball", size = 1.2, color = MAGIC, neon = true, spin = 8, parts = {
	{ "block", Vector3.new(0.3, 0.3, 0.05), Vector3.new(0.7, 0.3, 0), SPARK },
	{ "block", Vector3.new(0.3, 0.3, 0.05), Vector3.new(-0.6, 0.4, 0), PINK },
	{ "block", Vector3.new(0.3, 0.3, 0.05), Vector3.new(0.1, -0.7, 0), Color3.fromRGB(90, 220, 140) },
} }
local BUNNY = { shape = "ball", size = 1.3, color = RABBIT, parts = {
	{ "ball", Vector3.new(0.8, 0.8, 0.8), Vector3.new(0.55, 0.55, 0), RABBIT },
	{ "ball", Vector3.new(0.22, 0.9, 0.18), Vector3.new(0.45, 1.3, 0.15), RABBIT },
	{ "ball", Vector3.new(0.22, 0.9, 0.18), Vector3.new(0.7, 1.25, -0.15), RABBIT },
	{ "block", Vector3.new(0.12, 0.2, 0.1), Vector3.new(0.95, 0.4, 0), WHITE },
} }
local HAT = { shape = "disc", size = 1.9, color = TUX, spin = 14, parts = {
	{ "block", Vector3.new(1, 1.1, 1), Vector3.new(0, 0.5, 0), TUX },
	{ "block", Vector3.new(1.05, 0.25, 1.05), Vector3.new(0, 0.15, 0), VELVET },
} }

local data = {
	id = "Gaston",
	name = "Gaston le Magnifique",
	costume = "Gaston",
	style = "magician",

	look = {
		body = { head = SKIN, upper = TUX, lower = TUX, arms = TUX, hands = WHITE, legs = TUX,
			feet = Color3.fromRGB(15, 15, 20), forearms = TUX, shins = TUX },
		cubeHead = 1.25,
		parts = {
			-- haut-de-forme avec le lapin grognon qui dépasse (une oreille droite, une oreille tombante)
			{ "Chapeau", "Head", "cyl", Vector3.new(1.5, 1.15, 1.15), Vector3.new(0, 1.35, 0), Vector3.new(0, 0, 0), TUX, "SmoothPlastic", { axis = "y" } },
			{ "Bord", "Head", "cyl", Vector3.new(0.1, 1.9, 1.9), Vector3.new(0, 0.66, 0), Vector3.new(0, 0, 0), TUX, "SmoothPlastic", { axis = "y" } },
			{ "Ruban", "Head", "cyl", Vector3.new(0.28, 1.18, 1.18), Vector3.new(0, 0.85, 0), Vector3.new(0, 0, 0), VELVET, "Fabric", { axis = "y" } },
			{ "OreilleLapinG", "Head", "ball", Vector3.new(0.3, 1.1, 0.22), Vector3.new(-0.22, 2.55, 0.1), Vector3.new(0, 0, 8), RABBIT, "Fabric" },
			{ "OreilleLapinD", "Head", "ball", Vector3.new(0.3, 1.0, 0.22), Vector3.new(0.4, 2.3, 0.1), Vector3.new(0, 0, -55), RABBIT, "Fabric" },
			{ "InterieurOreille", "Head", "ball", Vector3.new(0.14, 0.8, 0.1), Vector3.new(-0.22, 2.55, -0.02), Vector3.new(0, 0, 8), PINK, "SmoothPlastic" },
			-- visage : moustache en guidon, sourcils dramatiques, nez rond
			{ "MoustacheG", "Head", "ball", Vector3.new(0.55, 0.18, 0.12), Vector3.new(-0.3, -0.2, -0.67), Vector3.new(0, 0, 18), Color3.fromRGB(30, 25, 25), "SmoothPlastic" },
			{ "MoustacheD", "Head", "ball", Vector3.new(0.55, 0.18, 0.12), Vector3.new(0.3, -0.2, -0.67), Vector3.new(0, 0, -18), Color3.fromRGB(30, 25, 25), "SmoothPlastic" },
			{ "SourcilG", "Head", "block", Vector3.new(0.38, 0.08, 0.06), Vector3.new(-0.3, 0.32, -0.64), Vector3.new(0, 0, -12), Color3.fromRGB(30, 25, 25), "SmoothPlastic" },
			{ "SourcilD", "Head", "block", Vector3.new(0.38, 0.08, 0.06), Vector3.new(0.3, 0.32, -0.64), Vector3.new(0, 0, 12), Color3.fromRGB(30, 25, 25), "SmoothPlastic" },
			{ "Nez", "Head", "ball", Vector3.new(0.3, 0.35, 0.3), Vector3.new(0, 0.02, -0.72), Vector3.new(0, 0, 0), Color3.fromRGB(240, 165, 150), "SmoothPlastic" },
			-- smoking : plastron blanc, revers en satin, nœud papillon
			{ "Plastron", "UpperTorso", "block", Vector3.new(0.7, 1.3, 0.05), Vector3.new(0, 0.15, -0.51), Vector3.new(0, 0, 0), WHITE, "Fabric" },
			{ "ReversG", "UpperTorso", "block", Vector3.new(0.3, 1.1, 0.06), Vector3.new(-0.48, 0.25, -0.52), Vector3.new(0, 0, -14), SATIN, "Fabric" },
			{ "ReversD", "UpperTorso", "block", Vector3.new(0.3, 1.1, 0.06), Vector3.new(0.48, 0.25, -0.52), Vector3.new(0, 0, 14), SATIN, "Fabric" },
			{ "Noeud", "UpperTorso", "block", Vector3.new(0.65, 0.3, 0.1), Vector3.new(0, 0.7, -0.55), Vector3.new(0, 0, 0), VELVET, "Fabric" },
			{ "NoeudCentre", "UpperTorso", "ball", Vector3.new(0.18, 0.18, 0.12), Vector3.new(0, 0.7, -0.6), Vector3.new(0, 0, 0), GOLD, "SmoothPlastic" },
			-- la cape trop grande : grand col dressé, doublure rouge, elle traîne presque par terre
			{ "Cape", "UpperTorso", "block", Vector3.new(2.7, 3.8, 0.12), Vector3.new(0, -0.75, 0.66), Vector3.new(8, 0, 0), TUX, "Fabric" },
			{ "Doublure", "UpperTorso", "block", Vector3.new(2.6, 3.7, 0.08), Vector3.new(0, -0.72, 0.58), Vector3.new(8, 0, 0), VELVET, "Fabric" },
			{ "Col", "UpperTorso", "block", Vector3.new(2.5, 1.0, 0.12), Vector3.new(0, 1.2, 0.55), Vector3.new(-18, 0, 0), VELVET, "Fabric" },
			{ "Etoile", "UpperTorso", "ball", Vector3.new(0.3, 0.3, 0.06), Vector3.new(0.6, -0.8, 0.74), Vector3.new(0, 0, 0), SPARK, "Neon" },
		},
		props = {
			-- l'arme de la Caisse Bizarre : baguette noire à bout blanc qui crépite
			{ name = "PropBaguette", hand = "Right", visible = true, pieces = {
				{ "Manche", "", "cyl", Vector3.new(1.6, 0.13, 0.13), Vector3.new(0, -0.85, 0), Vector3.new(0, 0, 0), Color3.fromRGB(15, 15, 20), "SmoothPlastic", { axis = "y" } },
				{ "Bout", "", "cyl", Vector3.new(0.32, 0.15, 0.15), Vector3.new(0, -1.78, 0), Vector3.new(0, 0, 0), WHITE, "SmoothPlastic", { axis = "y" } },
				{ "Etincelle", "", "ball", Vector3.new(0.22, 0.22, 0.22), Vector3.new(0, -2.0, 0), Vector3.new(0, 0, 0), SPARK, "Neon", { light = { SPARK, 5, 1 } } },
			} },
			-- éventail de cartes (main gauche)
			{ name = "PropCartes", hand = "Left", visible = false, pieces = {
				{ "Carte1", "", "block", Vector3.new(0.5, 0.75, 0.04), Vector3.new(-0.2, -0.5, 0), Vector3.new(0, 0, 25), WHITE, "SmoothPlastic" },
				{ "Carte2", "", "block", Vector3.new(0.5, 0.75, 0.04), Vector3.new(0, -0.55, -0.03), Vector3.new(0, 0, 0), WHITE, "SmoothPlastic" },
				{ "Carte3", "", "block", Vector3.new(0.5, 0.75, 0.04), Vector3.new(0.2, -0.5, -0.06), Vector3.new(0, 0, -25), WHITE, "SmoothPlastic" },
				{ "Coeur", "", "block", Vector3.new(0.18, 0.18, 0.05), Vector3.new(0, -0.6, -0.07), Vector3.new(0, 0, 45), VELVET, "SmoothPlastic" },
			} },
			-- foulards noués sans fin qui sortent de la manche (main gauche)
			{ name = "PropFoulard", hand = "Left", visible = false, pieces = {
				{ "Foulard1", "", "block", Vector3.new(0.45, 0.6, 0.05), Vector3.new(0, -0.45, 0), Vector3.new(0, 0, 10), VELVET, "Fabric" },
				{ "Foulard2", "", "block", Vector3.new(0.45, 0.6, 0.05), Vector3.new(0, -1.0, 0), Vector3.new(0, 0, -10), SPARK, "Fabric" },
				{ "Foulard3", "", "block", Vector3.new(0.45, 0.6, 0.05), Vector3.new(0, -1.55, 0), Vector3.new(0, 0, 10), Color3.fromRGB(80, 200, 120), "Fabric" },
				{ "Foulard4", "", "block", Vector3.new(0.45, 0.6, 0.05), Vector3.new(0, -2.1, 0), Vector3.new(0, 0, -10), Color3.fromRGB(70, 140, 240), "Fabric" },
				{ "Foulard5", "", "block", Vector3.new(0.45, 0.6, 0.05), Vector3.new(0, -2.65, 0), Vector3.new(0, 0, 10), PINK, "Fabric" },
			} },
			-- canne magique à pommeau doré (main gauche)
			{ name = "PropCanne", hand = "Left", visible = false, pieces = {
				{ "Tige", "", "cyl", Vector3.new(3, 0.18, 0.18), Vector3.new(0, -1.2, 0), Vector3.new(0, 0, 0), TUX, "SmoothPlastic", { axis = "y" } },
				{ "Pommeau", "", "ball", Vector3.new(0.35, 0.35, 0.35), Vector3.new(0, 0.3, 0), Vector3.new(0, 0, 0), GOLD, "Metal" },
				{ "Embout", "", "cyl", Vector3.new(0.3, 0.2, 0.2), Vector3.new(0, -2.7, 0), Vector3.new(0, 0, 0), WHITE, "SmoothPlastic", { axis = "y" } },
			} },
			-- le lapin grognon, tenu par les oreilles (main gauche)
			{ name = "PropLapin", hand = "Left", visible = false, pieces = {
				{ "Oreilles", "", "ball", Vector3.new(0.35, 0.7, 0.2), Vector3.new(0, -0.3, 0), Vector3.new(0, 0, 0), RABBIT, "Fabric" },
				{ "Tete", "", "ball", Vector3.new(0.75, 0.7, 0.7), Vector3.new(0, -0.85, 0), Vector3.new(0, 0, 0), RABBIT, "Fabric" },
				{ "Corps", "", "ball", Vector3.new(0.9, 1.1, 0.8), Vector3.new(0, -1.6, 0), Vector3.new(0, 0, 0), RABBIT, "Fabric" },
				{ "Dents", "", "block", Vector3.new(0.2, 0.18, 0.1), Vector3.new(0, -1.05, -0.35), Vector3.new(0, 0, 0), WHITE, "SmoothPlastic" },
			} },
		},
	},

	moves = {
		------------------------------------------------------------------ Attaques légères (P)
		-- Coup de baguette crépitante : petit tapotement sec du bout de la baguette, qui crache des étincelles
		P_neutral = {
			label = "Coup de baguette", startup = 0.07, active = 0.08, recovery = 0.14,
			damage = 6, hitbox = box(4.5, 3, 2.8, 0.8), kbBase = 20, kbGrowth = 25, kbAngle = 28,
			windup = { Root = { 2, -12, 0, 0, -0.15, 0.1 }, Waist = { 6, -14, 0 }, Neck = { 8, 10, 0 }, RS = { 110, 0, 25 }, RE = { 70, 0, 0 }, RW = { 40, 0, 0 }, LS = { 40, 0, -50 }, LE = { 60, 0, 0 } },
			strike = { Root = { -6, 10, 0, 0, -0.2, -0.25 }, Waist = { -6, 12, 0 }, Neck = { -4, -8, 0 }, RS = { 92, 0, 0 }, RE = { 5, 0, 0 }, RW = { -10, 0, 0 }, LS = { 30, 0, -70 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.25 } },
			follow = { Root = { -7, 12, 0, 0, -0.2, -0.28 }, Waist = { -7, 14, 0 }, Neck = { -5, -10, 0 }, RS = { 88, 0, -5 }, RE = { 10, 0, 0 }, RW = { -25, 0, 0 }, LS = { 25, 0, -75 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.28 } },
			trail = "prop", fx = { { "particles", tex = "spark", color = SPARK, at = "hand", dir = "all", time = 0.15, speed = 6 } }, hitText = "BZZT !",
		},
		-- Foulard sans fin (J J) : il tire de sa manche gauche une guirlande de foulards et la fouette devant lui
		P_combo2 = {
			label = "Foulard sans fin", startup = 0.08, active = 0.12, recovery = 0.18,
			damage = 5, hitbox = box(6, 2.5, 3.5, 0.6), kbBase = 18, kbGrowth = 22, kbAngle = 25,
			windup = { Root = { 2, 20, 0, 0, -0.2, 0.15 }, Waist = { 4, 22, 0 }, Neck = { 0, -14, 0 }, RS = { 50, 0, 20 }, RE = { 60, 0, 0 }, LS = { 60, 0, 40 }, LE = { 130, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -6, -16, 0, 0, -0.22, -0.25 }, Waist = { -6, -20, 0 }, Neck = { 0, 12, 0 }, RS = { 40, 0, 40 }, RE = { 50, 0, 0 }, LS = { 92, 0, -20 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { -6, -22, 0, 0, -0.22, -0.3 }, Waist = { -6, -26, 0 }, Neck = { 0, 16, 0 }, RS = { 35, 0, 45 }, RE = { 50, 0, 0 }, LS = { 90, 0, -45 }, LE = { 5, 0, 0 }, LW = { -10, 0, 0 } },
			prop = "foulard", trail = "leftHand", text = "ET ENCORE UN…", hitText = "FLOUF !",
		},
		-- Tour de passe-passe final (J J J) : il fait tournoyer la baguette au-dessus de sa tête puis l'abat, gerbe d'étincelles
		P_combo3 = {
			label = "Final étincelant", startup = 0.14, active = 0.1, recovery = 0.3,
			damage = 8, hitbox = box(5, 4, 2.6, 1), kbBase = 30, kbGrowth = 60, kbAngle = 48,
			windup = { Root = { 8, -8, 0, 0, -0.05, 0.2 }, Waist = { 14, -10, 0 }, Neck = { 18, 0, 0 }, RS = { 190, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -60 }, LE = { 20, 0, 0 } },
			strike = { Root = { -12, 10, 0, 0, -0.45, -0.4 }, Waist = { -26, 12, 0 }, Neck = { -8, 0, 0 }, RS = { 75, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -80 }, LE = { 10, 0, 0 } },
			follow = { Root = { -16, 12, 0, 0, -0.5, -0.45 }, Waist = { -30, 14, 0 }, Neck = { -10, 0, 0 }, RS = { 50, 0, 5 }, RE = { 5, 0, 0 }, RW = { -20, 0, 0 }, LS = { 35, 0, -85 }, LE = { 10, 0, 0 } },
			trail = "prop", fx = { { "burst", color = SPARK, size = 3 }, { "symbols", symbols = { "✨", "★" }, color = SPARK, count = 5, radius = 3, at = "front" } },
			text = "TA-DAAA !", hitText = "BADABZING !",
		},
		-- Cartes en éventail : de la main gauche, il lance trois cartes tranchantes en éventail court
		P_side = {
			label = "Cartes en éventail", kind = "projectile", startup = 0.1, active = 0, recovery = 0.2,
			damage = 3, kbBase = 16, kbGrowth = 22, kbAngle = 20,
			projectile = { speed = 85, gravity = 0, lifetime = 0.24, size = 1.2, color = WHITE, visual = CARD, fan = { count = 3, from = -12, to = 12 } },
			windup = { Root = { 0, 26, 0, 0, -0.2, 0.15 }, Waist = { 2, 30, 0 }, Neck = { 0, -20, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 }, LS = { 70, 0, 50 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -4, -18, 0, 0, -0.22, -0.2 }, Waist = { -4, -24, 0 }, Neck = { 0, 16, 0 }, RS = { 35, 0, 45 }, RE = { 50, 0, 0 }, LS = { 90, 0, -40 }, LE = { 5, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { -4, -24, 0, 0, -0.22, -0.25 }, Waist = { -4, -30, 0 }, Neck = { 0, 20, 0 }, RS = { 30, 0, 50 }, RE = { 50, 0, 0 }, LS = { 85, 0, -60 }, LE = { 10, 0, 0 }, LW = { -20, 0, 0 } },
			prop = "cartes", text = "FLICK !", hitText = "TCHAK !",
		},
		-- → J J : Pichenette magique, il s'avance et pique du bout de la baguette
		P_side2 = {
			label = "Pichenette magique", startup = 0.08, active = 0.08, recovery = 0.2,
			damage = 7, hitbox = box(5, 2.5, 3.2, 0.8), kbBase = 22, kbGrowth = 35, kbAngle = 25, selfVelocity = Vector2.new(18, 0),
			windup = { Root = { 4, -24, 0, 0, -0.25, 0.25 }, Waist = { 4, -26, 0 }, RS = { 60, 0, 30 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -60 }, LE = { 30, 0, 0 } },
			strike = { Root = { -12, 16, 0, 0, -0.35, -0.45 }, Waist = { -10, 20, 0 }, RS = { 98, 0, -2 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -75 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { -14, 20, 0, 0, -0.36, -0.5 }, Waist = { -12, 24, 0 }, RS = { 96, 0, -6 }, RE = { 5, 0, 0 }, RW = { -10, 0, 0 }, LS = { 15, 0, -80 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			trail = "prop", fx = { { "particles", tex = "spark", color = MAGIC, at = "hand", dir = "front", time = 0.15, speed = 8 } }, hitText = "PIC !",
		},
		-- Chaussure vernie en balayage : accroupi, il balaie au ras du sol, la chaussure laisse une traînée d'étoiles
		P_down = {
			label = "Balayage verni", startup = 0.1, active = 0.1, recovery = 0.2,
			damage = 6, hitbox = box(5.5, 2, 2.5, -2), kbBase = 26, kbGrowth = 22, kbAngle = 76,
			windup = { Root = { -8, -20, 0, 0, -0.75, 0.2 }, Waist = { -14, -10, 0 }, RS = { 60, 0, 60 }, RE = { 30, 0, 0 }, LS = { 50, 0, -40 }, LE = { 50, 0, 0 }, RH = { -15, 0, 20 }, RK = { -60, 0, 0 }, RA = { 0, 0, 0 } },
			strike = { Root = { -12, 24, 0, 0, -0.9, -0.1 }, Waist = { -20, 16, 0 }, RS = { 40, 0, 80 }, RE = { 10, 0, 0 }, LS = { 70, 0, -30 }, LE = { 40, 0, 0 }, RH = { 64, 0, 10 }, RK = { -4, 0, 0 }, RA = { 20, 0, 0 } },
			follow = { Root = { -12, 34, 0, 0, -0.9, -0.15 }, Waist = { -20, 26, 0 }, RS = { 35, 0, 85 }, RE = { 10, 0, 0 }, LS = { 75, 0, -28 }, LE = { 40, 0, 0 }, RH = { 60, 0, -12 }, RK = { -6, 0, 0 }, RA = { 20, 0, 0 } },
			trail = "rightFoot", fx = { { "symbols", symbols = { "✦", "✧" }, color = SPARK, count = 4, radius = 2, at = "feet" } }, hitText = "ZIP !",
		},
		-- ↓ J J : Révérence remontante, du fond de sa révérence il remonte la baguette jusqu'au ciel
		P_down2 = {
			label = "Révérence remontante", startup = 0.1, active = 0.1, recovery = 0.25,
			damage = 8, hitbox = box(4, 5, 2, 2), kbBase = 30, kbGrowth = 45, kbAngle = 82,
			windup = { Root = { -14, 0, 0, 0, -0.6, 0.1 }, Waist = { -30, 0, 0 }, Neck = { -20, 0, 0 }, RS = { -20, 0, 30 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 100, 0, 0 } },
			strike = { Root = { 8, 10, 0, 0, 0.15, -0.2 }, Waist = { 16, 12, 0 }, Neck = { 25, 0, 0 }, RS = { 165, 0, 10 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -70 }, LE = { 20, 0, 0 } },
			follow = { Root = { 10, 12, 0, 0, 0.2, -0.25 }, Waist = { 18, 14, 0 }, Neck = { 30, 0, 0 }, RS = { 178, 0, 5 }, RE = { 8, 0, 0 }, RW = { -15, 0, 0 }, LS = { 25, 0, -75 }, LE = { 20, 0, 0 } },
			trail = "prop", hitText = "HOP LÀ !",
		},
		-- Lapin mordeur (anti-air, ex-←J) : il brandit le lapin par les oreilles au-dessus de lui, le lapin mord
		P_up = {
			label = "Lapin mordeur", startup = 0.1, active = 0.12, recovery = 0.2,
			damage = 7, hitbox = box(4.5, 5, 1, 3.5), kbBase = 28, kbGrowth = 30, kbAngle = 85,
			windup = { Root = { -4, 10, 0, 0, -0.4, 0 }, Waist = { -10, 12, 0 }, Neck = { -6, 0, 0 }, RS = { 30, 0, 40 }, RE = { 60, 0, 0 }, LS = { 40, 0, -20 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { 6, -6, 0, 0, 0.2, 0 }, Waist = { 14, -8, 0 }, Neck = { 30, 0, 0 }, RS = { 40, 0, 60 }, RE = { 30, 0, 0 }, LS = { 170, 0, -10 }, LE = { 10, 0, 0 }, LW = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			follow = { Root = { 8, -8, 0, 0, 0.25, 0 }, Waist = { 16, -10, 0 }, Neck = { 34, 0, 0 }, RS = { 45, 0, 65 }, RE = { 30, 0, 0 }, LS = { 178, 0, -14 }, LE = { 10, 0, 0 }, LW = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			prop = "lapin", text = "GRRR !", hitText = "CROC !",
		},
		-- Cape tournoyante (J en l'air) : il s'enroule dans sa cape et tourne sur lui-même, bras écartés
		P_air = {
			label = "Cape tournoyante", startup = 0.08, active = 0.2, recovery = 0.18,
			damage = 7, hitbox = box(6, 4, 0, 0), kbBase = 22, kbGrowth = 35, kbAngle = 35,
			windup = { Root = { 6, -40, 0 }, Waist = { 6, -20, 0 }, RS = { 60, 0, -30 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 30 }, LE = { 90, 0, 0 }, RH = { 50, 0, 0 }, RK = { -90, 0, 0 }, LH = { 30, 0, 0 }, LK = { -70, 0, 0 } },
			strike = { Root = { 0, 0, 0 }, Waist = { 0, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 90, 0, 85 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -85 }, LE = { 0, 0, 0 }, RH = { 20, 0, 10 }, RK = { -40, 0, 0 }, LH = { 20, 0, -10 }, LK = { -40, 0, 0 } },
			follow = { Root = { 0, 0, 0 }, Waist = { 0, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 90, 0, 88 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -88 }, LE = { 0, 0, 0 }, RH = { 15, 0, 12 }, RK = { -35, 0, 0 }, LH = { 15, 0, -12 }, LK = { -35, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "body", hitText = "FWOUSH !",
		},
		-- Courbette fonceuse (dash puis J) : il fonce penché en une grande révérence, le haut-de-forme en bélier
		P_dash = {
			label = "Courbette fonceuse", startup = 0.08, active = 0.14, recovery = 0.24,
			damage = 8, hitbox = box(4, 3, 2.2, 0.8), kbBase = 28, kbGrowth = 50, kbAngle = 30, selfVelocity = Vector2.new(42, 0),
			windup = { Root = { 6, 0, 0, 0, -0.2, 0.15 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 120, 0, 60 }, RE = { 30, 0, 0 }, LS = { 100, 0, -70 }, LE = { 20, 0, 0 } },
			strike = { Root = { -30, 0, 0, 0, -0.45, -0.35 }, Waist = { -30, 0, 0 }, Neck = { -15, 0, 0 }, RS = { -40, 0, 50 }, RE = { 20, 0, 0 }, LS = { 70, 0, 10 }, LE = { 100, 0, 0 } },
			follow = { Root = { -32, 0, 0, 0, -0.48, -0.4 }, Waist = { -32, 0, 0 }, Neck = { -16, 0, 0 }, RS = { -48, 0, 55 }, RE = { 20, 0, 0 }, LS = { 72, 0, 12 }, LE = { 105, 0, 0 } },
			fx = { "dust" }, text = "MESDAMES ET MESSIEURS !", hitText = "BONG !",
		},

		------------------------------------------------------------------ Attaques lourdes (K)
		-- Chaussure vernie : grand coup de pied de danseur de cabaret, pointe tendue, la chaussure brille
		K_neutral = {
			label = "Chaussure vernie", startup = 0.18, active = 0.1, recovery = 0.3,
			damage = 11, hitbox = box(5, 3, 3.2, 0.5), kbBase = 30, kbGrowth = 70, kbAngle = 38,
			windup = { Root = { 10, -14, 0, 0, -0.1, 0.15 }, Waist = { 10, -10, 0 }, Neck = { 6, 10, 0 }, RS = { 60, 0, 60 }, RE = { 40, 0, 0 }, LS = { 120, 0, -40 }, LE = { 30, 0, 0 }, RH = { 90, 0, 0 }, RK = { -120, 0, 0 }, RA = { -20, 0, 0 } },
			strike = { Root = { 22, -4, 0, 0, -0.05, 0.05 }, Waist = { 16, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 40, 0, 85 }, RE = { 10, 0, 0 }, LS = { 160, 0, -30 }, LE = { 10, 0, 0 }, RH = { 110, 0, 0 }, RK = { -2, 0, 0 }, RA = { -25, 0, 0 } },
			follow = { Root = { 26, -2, 0, 0, -0.05, 0.1 }, Waist = { 18, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 38, 0, 88 }, RE = { 10, 0, 0 }, LS = { 165, 0, -28 }, LE = { 10, 0, 0 }, RH = { 118, 0, 0 }, RK = { 0, 0, 0 }, RA = { -25, 0, 0 } },
			trail = "rightFoot", fx = { { "burst", color = SPARK, size = 1.5 } }, hitText = "BLING !",
		},
		-- K K : Talon vernis, il pivote et fouette du talon gauche, cape qui vole
		K_combo2 = {
			label = "Talon vernis", startup = 0.14, active = 0.1, recovery = 0.25,
			damage = 9, hitbox = box(5, 3, 3, 0.5), kbBase = 28, kbGrowth = 50, kbAngle = 32,
			windup = { Root = { 4, 40, 0, 0, -0.15, 0.1 }, Waist = { 4, 30, 0 }, Neck = { 0, -25, 0 }, RS = { 60, 0, 50 }, RE = { 50, 0, 0 }, LS = { 40, 0, -55 }, LE = { 40, 0, 0 }, LH = { 55, 0, -40 }, LK = { -105, 0, 0 } },
			strike = { Root = { 12, -50, 0, 0, -0.1, 0 }, Waist = { 10, -30, 0 }, Neck = { 0, 20, 0 }, RS = { 70, 0, 60 }, RE = { 40, 0, 0 }, LS = { 30, 0, -70 }, LE = { 30, 0, 0 }, LH = { 85, 0, -55 }, LK = { -5, 0, 0 }, LA = { -15, 0, 0 } },
			follow = { Root = { 14, -70, 0, 0, -0.1, 0 }, Waist = { 12, -38, 0 }, Neck = { 0, 26, 0 }, RS = { 72, 0, 62 }, RE = { 40, 0, 0 }, LS = { 25, 0, -75 }, LE = { 30, 0, 0 }, LH = { 80, 0, -40 }, LK = { -8, 0, 0 }, LA = { -15, 0, 0 } },
			trail = "leftFoot", hitText = "CLAC !",
		},
		-- K K K : Coup de pied théâtral, il saute, salue de la baguette et lance une ruade en l'air
		K_combo3 = {
			label = "Coup de pied théâtral", startup = 0.16, active = 0.12, recovery = 0.32,
			damage = 12, hitbox = box(5, 4, 3, 1), kbBase = 32, kbGrowth = 80, kbAngle = 40, selfVelocity = Vector2.new(15, 42),
			windup = { Root = { -8, 0, 0, 0, -0.6, 0.1 }, Waist = { -14, 0, 0 }, RS = { 170, 0, 30 }, RE = { 20, 0, 0 }, LS = { -30, 0, -30 }, LE = { 30, 0, 0 } },
			strike = { Root = { 16, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 170, 0, 40 }, RE = { 10, 0, 0 }, LS = { 60, 0, -70 }, LE = { 20, 0, 0 }, RH = { 100, 0, 0 }, RK = { 0, 0, 0 }, RA = { -20, 0, 0 }, LH = { 30, 0, 0 }, LK = { -110, 0, 0 } },
			follow = { Root = { 20, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 175, 0, 45 }, RE = { 10, 0, 0 }, LS = { 55, 0, -75 }, LE = { 20, 0, 0 }, RH = { 108, 0, 0 }, RK = { 0, 0, 0 }, RA = { -20, 0, 0 }, LH = { 35, 0, 0 }, LK = { -115, 0, 0 } },
			trail = "rightFoot", text = "OLÉ !", hitText = "BAM !",
		},
		-- Canne magique (→K) : il sort une canne de sa cape et donne un grand coup d'estoc de la main gauche
		K_side = {
			label = "Canne magique", startup = 0.22, active = 0.12, recovery = 0.35,
			damage = 13, hitbox = box(6, 2.5, 4, 0.5), kbBase = 32, kbGrowth = 85, kbAngle = 28, selfVelocity = Vector2.new(28, 0),
			windup = { Root = { 6, 30, 0, 0, -0.25, 0.3 }, Waist = { 8, 30, 0 }, Neck = { 0, -24, 0 }, RS = { 40, 0, 50 }, RE = { 60, 0, 0 }, LS = { 60, 0, 60 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -14, -20, 0, 0, -0.4, -0.5 }, Waist = { -12, -24, 0 }, Neck = { 0, 18, 0 }, RS = { -30, 0, 50 }, RE = { 20, 0, 0 }, LS = { 92, 0, 0 }, LE = { 0, 0, 0 }, LW = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -16, -24, 0, 0, -0.42, -0.55 }, Waist = { -14, -28, 0 }, Neck = { 0, 22, 0 }, RS = { -35, 0, 55 }, RE = { 20, 0, 0 }, LS = { 95, 0, 0 }, LE = { 0, 0, 0 }, LW = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			prop = "canne", trail = "leftHand", text = "EN GARDE !", hitText = "TOC !",
		},
		-- → K K : Crochet de canne, il accroche l'adversaire par le cou avec la canne et le ramène vers lui
		K_side2 = {
			label = "Crochet de canne", startup = 0.16, active = 0.12, recovery = 0.3,
			damage = 9, hitbox = box(6, 3, 4, 0.8), kbBase = 26, kbGrowth = 30, kbAngle = 20, pull = true,
			windup = { Root = { -6, -20, 0, 0, -0.3, -0.2 }, Waist = { -8, -24, 0 }, RS = { 30, 0, 40 }, RE = { 50, 0, 0 }, LS = { 120, 0, 10 }, LE = { 10, 0, 0 }, LW = { 90, 0, 0 } },
			strike = { Root = { 10, 20, 0, 0, -0.3, 0.3 }, Waist = { 14, 26, 0 }, Neck = { 0, -16, 0 }, RS = { 40, 0, 50 }, RE = { 60, 0, 0 }, LS = { 60, 0, 30 }, LE = { 110, 0, 0 }, LW = { 90, 0, 0 } },
			follow = { Root = { 12, 26, 0, 0, -0.3, 0.4 }, Waist = { 16, 30, 0 }, Neck = { 0, -20, 0 }, RS = { 40, 0, 52 }, RE = { 60, 0, 0 }, LS = { 40, 0, 30 }, LE = { 125, 0, 0 }, LW = { 90, 0, 0 } },
			prop = "canne", trail = "leftHand", text = "VIENS PAR ICI !", hitText = "CROCHET !",
		},
		-- Trappe ratée (↓K) : il marche sur sa propre trappe, tombe jusqu'à la taille et moulinet des bras au ras du sol
		K_down = {
			label = "Trappe ratée", startup = 0.18, active = 0.2, recovery = 0.35,
			damage = 12, hitbox = box(7, 2.5, 1, -1.5), kbBase = 30, kbGrowth = 62, kbAngle = 65,
			windup = { Root = { 6, 0, 0, 0, 0.15, 0 }, Waist = { 8, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 40, 0, 40 }, RE = { 30, 0, 0 }, LS = { 40, 0, -40 }, LE = { 30, 0, 0 } },
			strike = { Root = { 0, 0, 0, 0, -1.8, 0 }, Waist = { -10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 70, 0, 80 }, RE = { 0, 0, 0 }, LS = { 70, 0, -80 }, LE = { 0, 0, 0 }, RH = { 0, 0, 0 }, RK = { 0, 0, 0 }, LH = { 0, 0, 0 }, LK = { 0, 0, 0 } },
			follow = { Root = { 0, 0, 0, 0, -1.8, 0 }, Waist = { -10, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 110, 0, 85 }, RE = { 10, 0, 0 }, LS = { 30, 0, -85 }, LE = { 10, 0, 0 }, RH = { 0, 0, 0 }, RK = { 0, 0, 0 }, LH = { 0, 0, 0 }, LK = { 0, 0, 0 } },
			wobble = true, fx = { "dust", { "text", text = "OUPS…", color = WHITE } }, hitText = "BLOMP !",
		},
		-- ↓ K K : Sortie de trappe, il jaillit de la trappe comme un diable de sa boîte, pieds en avant
		K_downK = {
			label = "Sortie de trappe", startup = 0.12, active = 0.14, recovery = 0.3,
			damage = 9, hitbox = box(4, 5, 1.5, 2.5), kbBase = 30, kbGrowth = 52, kbAngle = 84,
			windup = { Root = { 0, 0, 0, 0, -1.6, 0 }, Waist = { -20, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 30, 0, 20 }, RE = { 90, 0, 0 }, LS = { 30, 0, -20 }, LE = { 90, 0, 0 } },
			strike = { Root = { -20, 0, 0, 0, 0.6, 0 }, Waist = { 10, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 175, 0, 20 }, RE = { 0, 0, 0 }, LS = { 175, 0, -20 }, LE = { 0, 0, 0 }, RH = { -10, 0, 5 }, RK = { -20, 0, 0 }, LH = { -10, 0, -5 }, LK = { -20, 0, 0 } },
			follow = { Root = { -22, 0, 0, 0, 0.7, 0 }, Waist = { 12, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 180, 0, 25 }, RE = { 0, 0, 0 }, LS = { 180, 0, -25 }, LE = { 0, 0, 0 }, RH = { -12, 0, 8 }, RK = { -30, 0, 0 }, LH = { -12, 0, -8 }, LK = { -30, 0, 0 } },
			fx = { { "burst", color = SMOKE, size = 3, at = "feet" } }, text = "TA-DAM !", hitText = "BOING !",
		},
		-- Disparition ratée (ex-←K, recul) : pouf de fumée, il tente de disparaître et ne réussit qu'à reculer en ruant vers le haut
		K_up = {
			label = "Disparition ratée", startup = 0.18, active = 0.14, recovery = 0.3,
			damage = 11, hitbox = box(5, 5.5, 1, 3.5), kbBase = 32, kbGrowth = 72, kbAngle = 86, selfVelocity = Vector2.new(-20, 0),
			windup = { Root = { -6, 0, 0, 0, -0.5, 0 }, Waist = { -14, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 160, 0, -20 }, RE = { 100, 0, 0 }, LS = { 160, 0, 20 }, LE = { 100, 0, 0 } },
			strike = { Root = { 28, 0, 0, 0, -0.15, 0.35 }, Waist = { 12, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -30, 0, 60 }, RE = { 20, 0, 0 }, LS = { -30, 0, -60 }, LE = { 20, 0, 0 }, RH = { 150, 0, 0 }, RK = { 0, 0, 0 }, RA = { -20, 0, 0 } },
			follow = { Root = { 32, 0, 0, 0, -0.15, 0.45 }, Waist = { 14, 0, 0 }, Neck = { 24, 0, 0 }, RS = { -35, 0, 65 }, RE = { 20, 0, 0 }, LS = { -35, 0, -65 }, LE = { 20, 0, 0 }, RH = { 160, 0, 0 }, RK = { 0, 0, 0 }, RA = { -20, 0, 0 } },
			trail = "rightFoot", fx = { { "particles", tex = "smoke", color = SMOKE, at = "root", dir = "all", time = 0.4, speed = 8, size = 1.2 } }, text = "POUF !", hitText = "KOF KOF !",
		},
		-- ↑ K K : Chandelle de cabaret, coup de pied tendu à la verticale, l'autre jambe pliée, bras en V
		K_upK = {
			label = "Chandelle de cabaret", startup = 0.14, active = 0.12, recovery = 0.3,
			damage = 10, hitbox = box(4, 5, 1.5, 3), kbBase = 30, kbGrowth = 55, kbAngle = 85,
			windup = { Root = { 8, 0, 0, 0, 0.1, 0 }, Waist = { 8, 0, 0 }, RS = { 40, 0, 50 }, RE = { 40, 0, 0 }, LS = { 40, 0, -50 }, LE = { 40, 0, 0 }, RH = { 60, 0, 0 }, RK = { -110, 0, 0 } },
			strike = { Root = { 22, 0, 0, 0, 0.3, 0 }, Waist = { 10, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 150, 0, 40 }, RE = { 10, 0, 0 }, LS = { 150, 0, -40 }, LE = { 10, 0, 0 }, RH = { 160, 0, 0 }, RK = { 0, 0, 0 }, RA = { -25, 0, 0 } },
			follow = { Root = { 26, 0, 0, 0, 0.35, 0 }, Waist = { 12, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 155, 0, 45 }, RE = { 10, 0, 0 }, LS = { 155, 0, -45 }, LE = { 10, 0, 0 }, RH = { 168, 0, 0 }, RK = { 0, 0, 0 }, RA = { -25, 0, 0 } },
			trail = "rightFoot", hitText = "TCHAC !",
		},
		-- Double vernies (K en l'air) : il replie les genoux sous la cape puis détend les deux pieds devant
		K_air = {
			label = "Double vernies", startup = 0.17, active = 0.14, recovery = 0.25,
			damage = 12, hitbox = box(5, 4, 2.5, 0), kbBase = 30, kbGrowth = 70, kbAngle = 40,
			windup = { Root = { -10, 0, 0 }, Waist = { -20, 0, 0 }, RS = { 60, 0, 40 }, RE = { 60, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 }, RH = { 95, 0, 0 }, RK = { -130, 0, 0 }, LH = { 90, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 20, 0, 0 }, Waist = { 20, 0, 0 }, RS = { -30, 0, 60 }, RE = { 10, 0, 0 }, LS = { -30, 0, -60 }, LE = { 10, 0, 0 }, RH = { 90, 0, 0 }, RK = { 0, 0, 0 }, RA = { -20, 0, 0 }, LH = { 80, 0, 0 }, LK = { -5, 0, 0 }, LA = { -20, 0, 0 } },
			follow = { Root = { 24, 0, 0 }, Waist = { 22, 0, 0 }, RS = { -38, 0, 66 }, RE = { 10, 0, 0 }, LS = { -38, 0, -66 }, LE = { 10, 0, 0 }, RH = { 96, 0, 0 }, RK = { 0, 0, 0 }, RA = { -20, 0, 0 }, LH = { 86, 0, 0 }, LK = { -4, 0, 0 }, LA = { -20, 0, 0 } },
			trail = "bothFeet", hitText = "CLIC-CLAC !",
		},
		-- Glissade sur cape (dash puis K) : il glisse sur sa cape comme sur un tapis, pied droit en avant
		K_dash = {
			label = "Glissade sur cape", startup = 0.1, active = 0.25, recovery = 0.3,
			damage = 11, hitbox = box(6, 2.5, 3, -1.2), kbBase = 30, kbGrowth = 65, kbAngle = 45, selfVelocity = Vector2.new(52, 0),
			windup = { Root = { -10, 0, 0, 0, -0.45, 0 }, Waist = { -12, 0, 0 }, RS = { 50, 0, 40 }, LS = { 50, 0, -40 } },
			strike = { Root = { 30, 0, 0, 0, -1.2, 0 }, Waist = { -8, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 20, 0, 70 }, RE = { 10, 0, 0 }, LS = { 120, 0, -40 }, LE = { 30, 0, 0 }, RH = { 85, 0, 0 }, RK = { 0, 0, 0 }, RA = { -20, 0, 0 }, LH = { 40, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { 32, 0, 0, 0, -1.25, 0 }, Waist = { -10, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 15, 0, 75 }, RE = { 10, 0, 0 }, LS = { 125, 0, -42 }, LE = { 30, 0, 0 }, RH = { 88, 0, 0 }, RK = { 0, 0, 0 }, RA = { -20, 0, 0 }, LH = { 42, 0, 0 }, LK = { -105, 0, 0 } },
			trail = "rightFoot", fx = { "dust" }, hitText = "ZOUIP !",
		},

		------------------------------------------------------------------ En l'air avec une flèche (J / K)
		-- → J en l'air : Disparition volante, pouf de fumée, il réapparaît un peu plus loin en donnant un coup de baguette
		P_air_side = {
			label = "Disparition volante", startup = 0.1, active = 0.1, recovery = 0.2,
			damage = 7, hitbox = box(5, 3, 3, 0.5), kbBase = 22, kbGrowth = 40, kbAngle = 30, teleport = 4,
			windup = { Root = { 0, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, -40 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 40 }, LE = { 120, 0, 0 }, RH = { 80, 0, 0 }, RK = { -120, 0, 0 }, LH = { 80, 0, 0 }, LK = { -120, 0, 0 } },
			strike = { Root = { -6, 10, 0 }, Waist = { -6, 14, 0 }, RS = { 95, 0, 10 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -70 }, LE = { 20, 0, 0 }, RH = { 30, 0, 0 }, RK = { -60, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { -8, 12, 0 }, Waist = { -8, 16, 0 }, RS = { 92, 0, 20 }, RE = { 8, 0, 0 }, RW = { -15, 0, 0 }, LS = { 35, 0, -75 }, LE = { 20, 0, 0 }, RH = { 25, 0, 0 }, RK = { -55, 0, 0 }, LH = { 55, 0, 0 }, LK = { -95, 0, 0 } },
			trail = "prop", windupFx = { { "particles", tex = "smoke", color = SMOKE, at = "root", dir = "all", time = 0.2, speed = 6, size = 1.2 } },
			fx = { { "burst", color = SMOKE, size = 2.5, at = "root" } }, text = "POUF !", hitText = "BZING !",
		},
		-- ↑ J en l'air : Arc-en-ciel de baguette, la baguette dessine un grand arc d'étoiles au-dessus de sa tête
		P_air_up = {
			label = "Arc-en-ciel de baguette", startup = 0.09, active = 0.12, recovery = 0.18,
			damage = 7, hitbox = box(5, 4, 0.5, 3.5), kbBase = 26, kbGrowth = 45, kbAngle = 85,
			windup = { Root = { -12, 0, 0 }, Waist = { -16, 0, 0 }, Neck = { -10, 0, 0 }, RS = { -30, 0, 50 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 70, 0, 0 }, RH = { 90, 0, 0 }, RK = { -120, 0, 0 }, LH = { 80, 0, 0 }, LK = { -120, 0, 0 } },
			strike = { Root = { 14, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 165, 0, 20 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -50 }, LE = { 20, 0, 0 }, RH = { -10, 0, 0 }, RK = { -30, 0, 0 }, LH = { 20, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { 18, 0, 0 }, Waist = { 18, 0, 0 }, Neck = { 36, 0, 0 }, RS = { 195, 0, -10 }, RE = { 5, 0, 0 }, RW = { -15, 0, 0 }, LS = { -30, 0, -55 }, LE = { 20, 0, 0 }, RH = { -15, 0, 0 }, RK = { -25, 0, 0 }, LH = { 15, 0, 0 }, LK = { -55, 0, 0 } },
			trail = "prop", fx = { { "symbols", symbols = { "✨", "★" }, color = SPARK, count = 5, radius = 3, at = "above" } }, hitText = "TWINKLE !",
		},
		-- ↓ J en l'air : Chapeau plongeant, il pique tête la première, le haut-de-forme en avant (smash vers le sol)
		P_air_down = {
			label = "Chapeau plongeant", startup = 0.15, active = 0.12, recovery = 0.3,
			damage = 10, hitbox = box(4, 4, 1, -2), kbBase = 25, kbGrowth = 55, kbAngle = -78, selfVelocity = Vector2.new(4, -45),
			windup = { Root = { 20, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 160, 0, 30 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -30 }, LE = { 30, 0, 0 }, RH = { 70, 0, 0 }, RK = { -110, 0, 0 }, LH = { 70, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { -120, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 20 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 10, 0, 0 }, RH = { 0, 0, 5 }, RK = { -10, 0, 0 }, RA = { -25, 0, 0 }, LH = { 0, 0, -5 }, LK = { -10, 0, 0 }, LA = { -25, 0, 0 } },
			follow = { Root = { -125, 0, 0 }, Waist = { -12, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 30, 0, 25 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 30, 0, -25 }, LE = { 10, 0, 0 }, RH = { -5, 0, 5 }, RK = { -15, 0, 0 }, RA = { -25, 0, 0 }, LH = { -5, 0, -5 }, LK = { -15, 0, 0 }, LA = { -25, 0, 0 } },
			trail = "head", text = "CHAPEAU !", hitText = "BONK !",
		},
		-- → K en l'air : Canne volante, il balaie l'air devant lui avec la canne, à bout de bras
		K_air_side = {
			label = "Canne volante", startup = 0.15, active = 0.12, recovery = 0.25,
			damage = 11, hitbox = box(6, 3, 3.5, 0), kbBase = 30, kbGrowth = 70, kbAngle = 35,
			windup = { Root = { -6, 30, 0 }, Waist = { -6, 30, 0 }, Neck = { 0, -20, 0 }, RS = { 40, 0, 50 }, RE = { 60, 0, 0 }, LS = { 70, 0, 80 }, LE = { 40, 0, 0 }, LW = { 90, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { 30, 0, 0 }, LK = { -80, 0, 0 } },
			strike = { Root = { 6, -20, 0 }, Waist = { 0, -26, 0 }, Neck = { 0, 16, 0 }, RS = { 20, 0, 60 }, RE = { 30, 0, 0 }, LS = { 90, 0, -20 }, LE = { 0, 0, 0 }, LW = { 90, 0, 0 }, RH = { 20, 0, 0 }, RK = { -50, 0, 0 }, LH = { 60, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { 8, -30, 0 }, Waist = { 2, -34, 0 }, Neck = { 0, 22, 0 }, RS = { 15, 0, 62 }, RE = { 30, 0, 0 }, LS = { 85, 0, -50 }, LE = { 5, 0, 0 }, LW = { 90, 0, 0 }, RH = { 15, 0, 0 }, RK = { -45, 0, 0 }, LH = { 65, 0, 0 }, LK = { -55, 0, 0 } },
			prop = "canne", trail = "leftHand", hitText = "VLAN !",
		},
		-- ↑ K en l'air : Salto de cape, salto arrière, la cape claque au-dessus de lui
		K_air_up = {
			label = "Salto de cape", startup = 0.14, active = 0.2, recovery = 0.25,
			damage = 10, hitbox = box(5, 5, 0.5, 3.5), kbBase = 30, kbGrowth = 65, kbAngle = 85,
			windup = { Root = { -10, 0, 0 }, Waist = { -20, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 50 }, RE = { 40, 0, 0 }, LS = { 40, 0, -50 }, LE = { 40, 0, 0 }, RH = { 60, 0, 0 }, RK = { -120, 0, 0 }, LH = { 100, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 160, 0, 40 }, RE = { 10, 0, 0 }, LS = { 160, 0, -40 }, LE = { 10, 0, 0 }, RH = { 150, 0, 0 }, RK = { -5, 0, 0 }, RA = { -20, 0, 0 }, LH = { 40, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 165, 0, 45 }, RE = { 10, 0, 0 }, LS = { 165, 0, -45 }, LE = { 10, 0, 0 }, RH = { 100, 0, 0 }, RK = { -50, 0, 0 }, LH = { 150, 0, 0 }, LK = { -5, 0, 0 }, LA = { -20, 0, 0 } },
			spin = { axis = "x", degrees = -360 }, trail = "body", hitText = "FLAP !",
		},
		-- ↓ K en l'air : Talon de prestidigitateur, il retombe talons joints, la cape en parachute (smash vers le sol)
		K_air_down = {
			label = "Talon de prestidigitateur", startup = 0.18, active = 0.15, recovery = 0.3,
			damage = 12, hitbox = box(4, 3, 0.5, -3), kbBase = 25, kbGrowth = 55, kbAngle = -80, selfVelocity = Vector2.new(0, -60),
			windup = { Root = { -6, 0, 0 }, Waist = { -18, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 120, 0, 45 }, RE = { 30, 0, 0 }, LS = { 120, 0, -45 }, LE = { 30, 0, 0 }, RH = { 105, 0, 0 }, RK = { -135, 0, 0 }, LH = { 105, 0, 0 }, LK = { -135, 0, 0 } },
			strike = { Root = { 4, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 150, 0, 70 }, RE = { 10, 0, 0 }, LS = { 150, 0, -70 }, LE = { 10, 0, 0 }, RH = { -4, 0, 3 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 }, LH = { -4, 0, -3 }, LK = { 0, 0, 0 }, LA = { 10, 0, 0 } },
			follow = { Root = { 4, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { -25, 0, 0 }, RS = { 160, 0, 78 }, RE = { 10, 0, 0 }, LS = { 160, 0, -78 }, LE = { 10, 0, 0 }, RH = { -4, 0, 5 }, RK = { -5, 0, 0 }, RA = { 10, 0, 0 }, LH = { -4, 0, -5 }, LK = { -5, 0, 0 }, LA = { 10, 0, 0 } },
			trail = "bothFeet", text = "ABRACA-BAM !", hitText = "CLONK !",
		},

		------------------------------------------------------------------ Spéciaux (S) : 3 résultats possibles (🕊️ / 💥 / 🐇)
		-- Tour aléatoire : baguette pointée, formule magique… et il en sort colombe, confettis ou lapin (courte portée)
		S_neutral = {
			label = "Tour aléatoire", energyCost = 25, startup = 0.16, active = 0.12, recovery = 0.3,
			damage = 10, hitbox = box(4.5, 3.5, 3, 0.8), kbBase = 28, kbGrowth = 55, kbAngle = 40,
			variants = {
				{ label = "Tour aléatoire : colombe !", damage = 8, kbBase = 22, kbGrowth = 35, kbAngle = 60, status = { name = "blinded", duration = 1.5 }, hitText = "ROUCOULE !" },
				{ label = "Tour aléatoire : confettis explosifs !", damage = 14, kbBase = 34, kbGrowth = 75, kbAngle = 40, hitText = "BOUM !" },
				{ label = "Tour aléatoire : lapin agressif !", damage = 4, hits = 3, kbBase = 22, kbGrowth = 40, kbAngle = 30, hitText = "CROC CROC CROC !" },
			},
			windup = { Root = { 4, -14, 0, 0, -0.15, 0.1 }, Waist = { 10, -16, 0 }, Neck = { 14, 12, 0 }, RS = { 160, 0, 30 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 100, 0, -70 }, LE = { 20, 0, 0 } },
			strike = { Root = { -8, 10, 0, 0, -0.25, -0.3 }, Waist = { -10, 12, 0 }, Neck = { -6, -8, 0 }, RS = { 95, 0, -5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -80 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
			follow = { Root = { -8, 12, 0, 0, -0.25, -0.32 }, Waist = { -10, 14, 0 }, Neck = { -8, -10, 0 }, RS = { 98, 0, -8 }, RE = { 0, 0, 0 }, RW = { 10, 0, 0 }, LS = { 75, 0, -85 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
			hold = 0.1, shake = true, windupFx = { { "particles", tex = "spark", color = MAGIC, at = "hand", dir = "all", time = 0.2, speed = 5 } },
			fx = { { "burst", color = MAGIC, size = 2.5 }, { "symbols", symbols = { "🕊️", "💥", "🐇" }, count = 3, radius = 3, at = "front" } },
			text = "ABRACADABRA !", hitText = "TA-DA !",
		},
		-- Passe-passe (→S) : cape rabattue devant le visage, il se téléporte un peu plus loin ; qui est sur le chemin est sonné
		S_side = {
			label = "Passe-passe", energyCost = 25, startup = 0.12, active = 0.12, recovery = 0.3,
			damage = 8, hitbox = box(9, 4, 4.5, 0.5), kbBase = 20, kbGrowth = 30, kbAngle = 35, teleport = 9, invuln = 0.25,
			variants = {
				{ label = "Passe-passe : nuée de colombes", teleport = 9, status = { name = "stunned", duration = 0.8 }, hitText = "ROUCOULE !" },
				{ label = "Passe-passe : sortie explosive", teleport = 9, damage = 12, kbBase = 30, kbGrowth = 60, hitText = "BOUM !" },
				{ label = "Passe-passe : le lapin s'accroche", teleport = 5, damage = 6, status = { name = "rooted", duration = 1.2 }, hitText = "GRRR !" },
			},
			windup = { Root = { 4, 0, 0, 0, -0.2, 0.1 }, Waist = { 8, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 120, 0, -50 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 110, 0, 40 }, LE = { 100, 0, 0 } },
			strike = { Root = { -14, 0, 0, 0, -0.35, -0.3 }, Waist = { -14, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 60, 0, 80 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -80 }, LE = { 10, 0, 0 } },
			follow = { Root = { 6, 0, 0, 0, -0.2, 0 }, Waist = { 10, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 150, 0, 40 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -50 }, LE = { 30, 0, 0 } },
			windupFx = { { "particles", tex = "smoke", color = SMOKE, at = "root", dir = "all", time = 0.2, speed = 6, size = 1.4 } },
			fx = { { "burst", color = SMOKE, size = 3, at = "root" }, { "beam", color = MAGIC, length = 9, width = 0.6, at = "root" } }, text = "PASSE-PASSE !", hitText = "OÙ IL EST ?!",
		},
		-- Trappe (↓S) : coup de baguette au sol, une trappe s'ouvre devant lui ; qui marche dessus tombe… et ressort par le haut
		S_down = {
			label = "Trappe", kind = "trap", energyCost = 25, startup = 0.18, active = 0.1, recovery = 0.32,
			damage = 10, kbBase = 46, kbGrowth = 60, kbAngle = 90,
			trap = { size = Vector3.new(4, 1, 6), offset = 4, lifetime = 9, max = 1, color = MAGIC,
				visual = { shape = "ball", size = 0.2, color = TUX, trail = false, parts = {
					{ "block", Vector3.new(3.6, 0.15, 2.6), Vector3.new(0, -0.35, 0), Color3.fromRGB(10, 10, 15) },
					{ "block", Vector3.new(4, 0.12, 0.3), Vector3.new(0, -0.3, 1.4), GOLD },
					{ "block", Vector3.new(4, 0.12, 0.3), Vector3.new(0, -0.3, -1.4), GOLD },
					{ "block", Vector3.new(1.8, 0.1, 2.6), Vector3.new(-1.2, 0.3, 0), Color3.fromRGB(120, 80, 50), "Wood" },
				} } },
			variants = {
				{ label = "Trappe aux colombes", damage = 8, status = { name = "blinded", duration = 1.5 }, hitText = "ROUCOULE !" },
				{ label = "Trappe piégée", damage = 13, kbBase = 50, kbGrowth = 70, hitText = "KABOUM !" },
				{ label = "Trappe du lapin", damage = 7, kbBase = 30, kbGrowth = 40, status = { name = "rooted", duration = 1.5 }, hitText = "GRRR !" },
			},
			windup = { Root = { 6, 0, 0, 0, -0.1, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 170, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -50 }, LE = { 30, 0, 0 } },
			strike = { Root = { -14, 0, 0, 0, -0.5, -0.2 }, Waist = { -30, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -60 }, LE = { 30, 0, 0 } },
			follow = { Root = { -16, 0, 0, 0, -0.55, -0.25 }, Waist = { -32, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 30, 0, 10 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 25, 0, -62 }, LE = { 30, 0, 0 } },
			fx = { { "ring", color = MAGIC, radius = 3, at = "front" } }, text = "SÉSAME…", hitText = "AAAAAH !",
		},
		-- Lévitation ratée (remontée, gratuite) : le lapin sort du chapeau et le tire violemment vers le ciel par les oreilles
		S_up = {
			label = "Lévitation ratée", energyCost = 0, startup = 0.06, active = 0.3, recovery = 0.3,
			damage = 6, hitbox = box(5, 6, 0.5, 2), kbBase = 28, kbGrowth = 40, kbAngle = 82, selfVelocity = Vector2.new(8, 95),
			variants = {
				{ label = "Lévitation : colombes porteuses", selfVelocity = Vector2.new(14, 90), damage = 5, status = { name = "blinded", duration = 1 } },
				{ label = "Lévitation : décollage explosif", selfVelocity = Vector2.new(0, 102), damage = 8, kbAngle = 78 },
				{ label = "Lévitation ratée : le lapin tire !", selfVelocity = Vector2.new(6, 98), damage = 6, kbBase = 32 },
			},
			windup = { Root = { 0, 0, 0, 0, -0.6, 0 }, Waist = { -10, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 40, 0, 50 }, RE = { 30, 0, 0 }, LS = { 170, 0, -10 }, LE = { 20, 0, 0 } },
			strike = { Root = { 0, 0, 0, 0, 0.4, 0 }, Waist = { 6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 120, 0, 60 }, RE = { 10, 0, 0 }, LS = { 178, 0, -5 }, LE = { 5, 0, 0 }, RH = { -10, 0, 8 }, RK = { -40, 0, 0 }, RA = { -30, 0, 0 }, LH = { 10, 0, -8 }, LK = { -60, 0, 0 }, LA = { -30, 0, 0 } },
			follow = { Root = { 0, 0, 0, 0, 0.4, 0 }, Waist = { 8, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 130, 0, 65 }, RE = { 10, 0, 0 }, LS = { 180, 0, -2 }, LE = { 5, 0, 0 }, RH = { -15, 0, 10 }, RK = { -50, 0, 0 }, RA = { -30, 0, 0 }, LH = { 15, 0, -10 }, LK = { -70, 0, 0 }, LA = { -30, 0, 0 } },
			prop = "lapin", wobble = true, fx = { { "particles", tex = "spark", color = MAGIC, at = "feet", dir = "down", time = 0.3, speed = 10 } }, text = "AÏE, MES OREILLES… ENFIN, SES OREILLES !", hitText = "ZWIIING !",
		},
		-- Abracadabra (S maintenu) : il agite la baguette en grands cercles en psalmodiant ; un des trois tours lui profite
		-- (le moteur ne sait pas « garantir le prochain tour » : chaque résultat donne un bonus différent)
		S_hold = {
			label = "Abracadabra", energyCost = 30, startup = 0.3, active = 0, recovery = 0.4,
			hitbox = box(6, 4, 2.5, 0.5), kbBase = 30, kbGrowth = 55, kbAngle = 35,
			damage = 9, selfEffect = { heal = 4 },
			variants = {
				{ label = "Abracadabra : colombe guérisseuse", selfEffect = { heal = 7 } },
				{ label = "Abracadabra : feu d'artifice !", selfEffect = { buff = { "turbo", 4 } } },
				{ label = "Abracadabra : lapin garde du corps", selfEffect = { armor = 2 } },
			},
			windup = { Root = { 4, 0, 0, 0, -0.1, 0 }, Waist = { 8, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 160, 0, 40 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -60 }, LE = { 30, 0, 0 } },
			strike = { Root = { 8, 0, 0, 0, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 175, 0, -20 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 140, 0, -70 }, LE = { 20, 0, 0 } },
			follow = { Root = { 8, 0, 0, 0, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 160, 0, 50 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 145, 0, -72 }, LE = { 20, 0, 0 } },
			hold = 0.3, shake = true, windupFx = { { "symbols", symbols = { "✨", "★", "✦" }, color = MAGIC, count = 6, radius = 3, at = "above" } },
			fx = { { "burst", color = SPARK, size = 3, at = "above" }, { "symbols", symbols = { "🕊️", "💥", "🐇" }, count = 3, radius = 2, at = "above" } }, text = "ABRACADABRAAA !",
		},
		-- Téléportation (→→S) : il s'enroule dans la cape et disparaît… réussi, en l'air, ou raté (il réapparaît derrière)
		S_dash = {
			label = "Téléportation", energyCost = 20, startup = 0.14, active = 0, recovery = 0.25,
			hitbox = box(6, 4, 2.5, 0.5), kbBase = 30, kbGrowth = 55, kbAngle = 35,
			damage = 9, teleport = 14, invuln = 0.25,
			variants = {
				{ label = "Téléportation réussie !", teleport = 14 },
				{ label = "Téléportation… en l'air !", teleport = 9, teleportUp = 7 },
				{ label = "Téléportation ratée !", teleport = -6 },
			},
			windup = { Root = { 0, -60, 0, 0, -0.2, 0 }, Waist = { 0, -20, 0 }, Neck = { -10, 0, 0 }, RS = { 100, 0, -70 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 30 }, LE = { 110, 0, 0 } },
			strike = { Root = { 0, 0, 0, 0, -0.1, 0 }, Waist = { 6, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 150, 0, 60 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -60 }, LE = { 10, 0, 0 } },
			follow = { Root = { 0, 0, 0, 0, -0.1, 0 }, Waist = { 6, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 160, 0, 65 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -65 }, LE = { 10, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, windupFx = { { "particles", tex = "smoke", color = SMOKE, at = "root", dir = "all", time = 0.25, speed = 6, size = 1.5 } },
			fx = { { "burst", color = SMOKE, size = 4, at = "root" } }, text = "ET HOP !",
		},
		-- Cartes lancées (ESQUIVE puis S, ex-←S) : il lance une grosse carte qui file au loin… et qui change en route
		S_dodge = {
			label = "Cartes lancées", kind = "projectile", energyCost = 20, startup = 0.14, active = 0, recovery = 0.3,
			damage = 9, kbBase = 22, kbGrowth = 45, kbAngle = 25,
			projectile = { speed = 75, angle = 0, gravity = 0, lifetime = 0.6, size = 1.5, color = WHITE, visual = CARD },
			variants = {
				{ label = "Cartes lancées : la carte devient colombe", damage = 7, status = { name = "blinded", duration = 1.5 },
					projectile = { speed = 55, angle = 0, gravity = 0, lifetime = 1, size = 1.5, color = WHITE, visual = DOVE, homing = 0.4 } },
				{ label = "Cartes lancées : carte explosive", damage = 12, kbBase = 30, kbGrowth = 60,
					projectile = { speed = 75, angle = 0, gravity = 0, lifetime = 0.6, size = 1.8, color = MAGIC, visual = CONFETTI_BOMB } },
				{ label = "Cartes lancées : le lapin la rapporte", damage = 6, hits = 2,
					projectile = { speed = 70, angle = 0, gravity = 0, lifetime = 1.1, size = 1.5, color = RABBIT, visual = CARD, returns = true, hits = 2 } },
			},
			windup = { Root = { 0, 30, 0, 0, -0.2, 0.15 }, Waist = { 2, 34, 0 }, Neck = { 0, -24, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 }, LS = { 50, 0, 70 }, LE = { 130, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -6, -22, 0, 0, -0.25, -0.25 }, Waist = { -6, -26, 0 }, Neck = { 0, 18, 0 }, RS = { 35, 0, 45 }, RE = { 50, 0, 0 }, LS = { 92, 0, -30 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { -6, -28, 0, 0, -0.25, -0.3 }, Waist = { -6, -32, 0 }, Neck = { 0, 22, 0 }, RS = { 30, 0, 50 }, RE = { 50, 0, 0 }, LS = { 88, 0, -55 }, LE = { 5, 0, 0 }, LW = { -20, 0, 0 } },
			prop = "cartes", text = "VOTRE CARTE ?", hitText = "TCHAK !",
		},
		-- Pluie de colombes (S en l'air) : il ouvre sa cape en grand, il en tombe quelque chose sur la zone devant lui
		S_air = {
			label = "Pluie de colombes", kind = "projectile", energyCost = 25, startup = 0.18, active = 0, recovery = 0.32,
			damage = 4, kbBase = 18, kbGrowth = 25, kbAngle = -30,
			projectile = { speed = 50, gravity = 0, lifetime = 1, size = 1.4, color = WHITE, visual = DOVE, rain = { count = 4, spread = 6, ahead = 8, height = 16 } },
			variants = {
				{ label = "Pluie de colombes", damage = 3, status = { name = "blinded", duration = 1.5 } },
				{ label = "Pluie de confettis explosifs", damage = 5, kbBase = 22, kbGrowth = 35,
					projectile = { speed = 50, gravity = 0, lifetime = 1, size = 1.6, color = MAGIC, visual = CONFETTI_BOMB, rain = { count = 3, spread = 6, ahead = 8, height = 16 } } },
				{ label = "Pluie de… un lapin ?!", damage = 12, kbBase = 28, kbGrowth = 55, kbAngle = -50,
					projectile = { speed = 45, gravity = 0, lifetime = 1.1, size = 2.4, color = RABBIT, visual = BUNNY, rain = { count = 1, spread = 2, ahead = 8, height = 16 } } },
			},
			windup = { Root = { 6, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, -30 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 30 }, LE = { 100, 0, 0 }, RH = { 50, 0, 0 }, RK = { -90, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
			strike = { Root = { -6, 0, 0 }, Waist = { -4, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 140, 0, 80 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 140, 0, -80 }, LE = { 10, 0, 0 }, RH = { 20, 0, 10 }, RK = { -40, 0, 0 }, LH = { 20, 0, -10 }, LK = { -40, 0, 0 } },
			follow = { Root = { -8, 0, 0 }, Waist = { -6, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 150, 0, 85 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -85 }, LE = { 10, 0, 0 }, RH = { 15, 0, 12 }, RK = { -35, 0, 0 }, LH = { 15, 0, -12 }, LK = { -35, 0, 0 } },
			hold = 0.15, fx = { { "symbols", symbols = { "🕊️", "✨" }, color = WHITE, count = 5, radius = 4, at = "above" } }, text = "ENVOLEZ-VOUS !", hitText = "ROUCOULE !",
		},
		-- Pluie de colombes (↓S en l'air, plongeon) : il pique vers le sol, cape grande ouverte, en lâchant des colombes
		S_air_down = {
			label = "Piqué des colombes", energyCost = 25, startup = 0.12, active = 0.35, recovery = 0.32,
			damage = 11, hitbox = box(6, 4, 1, -1.5), kbBase = 25, kbGrowth = 55, kbAngle = -50, selfVelocity = Vector2.new(15, -75),
			variants = {
				{ label = "Piqué des colombes", damage = 9, status = { name = "blinded", duration = 2 }, hitText = "ROUCOULE !" },
				{ label = "Piqué aux confettis", damage = 13, kbBase = 30, kbGrowth = 65, hitText = "BADABOUM !" },
				{ label = "Piqué du lapin", damage = 10, status = { name = "stunned", duration = 0.6 }, hitText = "CROC !" },
			},
			windup = { Root = { 20, 0, 0 }, Waist = { 10, 0, 0 }, RS = { 150, 0, 40 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -40 }, LE = { 10, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { -65, 0, 0 }, Waist = { -8, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 120, 0, 80 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -80 }, LE = { 0, 0, 0 }, RH = { -10, 0, 5 }, RK = { -15, 0, 0 }, RA = { -25, 0, 0 }, LH = { -10, 0, -5 }, LK = { -25, 0, 0 }, LA = { -25, 0, 0 } },
			follow = { Root = { -70, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 125, 0, 85 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 125, 0, -85 }, LE = { 0, 0, 0 }, RH = { -15, 0, 5 }, RK = { -25, 0, 0 }, RA = { -25, 0, 0 }, LH = { -5, 0, -5 }, LK = { -15, 0, 0 }, LA = { -25, 0, 0 } },
			trail = "body", fx = { { "toss", shape = "ball", color = WHITE, count = 4, size = 0.8, speed = 16 }, { "burst", color = WHITE, size = 3, at = "feet" } }, text = "EN PIQUÉ !", hitText = "FLAP-FLAP !",
		},

		------------------------------------------------------------------ Suites d'enchaînement
		-- J puis K : Croc-en-jambe de scène, petit coup de pied sec dans le tibia en saluant
		PK_combo = {
			label = "Croc-en-jambe de scène", startup = 0.1, active = 0.08, recovery = 0.2,
			damage = 7, hitbox = box(5, 2, 3, -1.5), kbBase = 22, kbGrowth = 30, kbAngle = 35,
			windup = { Root = { 4, -10, 0, 0, -0.2, 0.15 }, Waist = { 6, -12, 0 }, Neck = { 10, 0, 0 }, RS = { 120, 0, 50 }, RE = { 30, 0, 0 }, LS = { 50, 0, -30 }, LE = { 70, 0, 0 }, RH = { -20, 0, 8 }, RK = { -70, 0, 0 }, RA = { 0, 0, 0 } },
			strike = { Root = { -6, 10, 0, 0, -0.3, -0.2 }, Waist = { -8, 8, 0 }, Neck = { 0, 0, 0 }, RS = { 130, 0, 60 }, RE = { 20, 0, 0 }, LS = { 70, 0, -35 }, LE = { 60, 0, 0 }, RH = { 62, 0, 6 }, RK = { -5, 0, 0 }, RA = { -25, 0, 0 } },
			follow = { Root = { -8, 14, 0, 0, -0.32, -0.25 }, Waist = { -10, 10, 0 }, Neck = { 0, 0, 0 }, RS = { 135, 0, 62 }, RE = { 20, 0, 0 }, LS = { 72, 0, -35 }, LE = { 60, 0, 0 }, RH = { 66, 0, 0 }, RK = { -8, 0, 0 }, RA = { -25, 0, 0 } },
			trail = "rightFoot", hitText = "TOC !",
		},
		-- K puis J : Revers de baguette, il pivote et fouette du revers de la baguette
		KP_combo = {
			label = "Revers de baguette", startup = 0.09, active = 0.08, recovery = 0.2,
			damage = 7, hitbox = box(4.5, 3, 2.6, 0.8), kbBase = 22, kbGrowth = 35, kbAngle = 30,
			windup = { Root = { -6, 24, 0, 0, -0.25, -0.2 }, Waist = { -8, 34, 0 }, RS = { 70, 0, -40 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 0, 0, -30 }, LE = { 60, 0, 0 } },
			strike = { Root = { -8, -14, 0, 0, -0.28, -0.35 }, Waist = { -10, -24, 0 }, RS = { 95, 0, 35 }, RE = { 8, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 } },
			follow = { Root = { -8, -22, 0, 0, -0.28, -0.38 }, Waist = { -10, -34, 0 }, RS = { 85, 0, 55 }, RE = { 15, 0, 0 }, RW = { -15, 0, 0 }, LS = { 45, 0, -45 }, LE = { 60, 0, 0 } },
			trail = "prop", hitText = "FWIP !",
		},

		------------------------------------------------------------------ Finitions avec S (dans un enchaînement), elles aussi à 3 résultats
		-- Pouf magique : baguette tendue à bout portant, gros nuage magique qui éclate sur l'adversaire
		S_finish_poof = {
			label = "Pouf magique", energyCost = 20, startup = 0.14, active = 0.12, recovery = 0.3,
			damage = 9, hitbox = box(5, 4, 3, 0.8), kbBase = 30, kbGrowth = 55, kbAngle = 40,
			variants = {
				{ label = "Pouf magique : envol de colombes", damage = 8, kbAngle = 70, status = { name = "blinded", duration = 1.2 } },
				{ label = "Pouf magique : confettis !", damage = 12, kbBase = 34, kbGrowth = 68 },
				{ label = "Pouf magique : lapin teigneux", damage = 4, hits = 3, kbBase = 24 },
			},
			windup = { Root = { 0, -14, 0, 0, -0.2, 0.15 }, Waist = { 0, -16, 0 }, RS = { 70, 0, 30 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -60 }, LE = { 30, 0, 0 } },
			strike = { Root = { -8, 10, 0, 0, -0.28, -0.3 }, Waist = { -8, 12, 0 }, RS = { 95, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -80 }, LE = { 20, 0, 0 } },
			follow = { Root = { -10, 12, 0, 0, -0.3, -0.32 }, Waist = { -10, 14, 0 }, RS = { 98, 0, -5 }, RE = { 0, 0, 0 }, RW = { 10, 0, 0 }, LS = { 25, 0, -82 }, LE = { 20, 0, 0 } },
			shake = true, fx = { { "burst", color = MAGIC, size = 3.5 }, { "particles", tex = "smoke", color = MAGIC, at = "front", dir = "all", time = 0.3, speed = 8, size = 1 } }, text = "POUF !", hitText = "PAF-POUF !",
		},
		-- Chapeau boomerang : il lance son haut-de-forme qui tournoie et revient (le lapin s'y cramponne)
		S_finish_hat = {
			label = "Chapeau boomerang", kind = "projectile", energyCost = 20, startup = 0.14, active = 0, recovery = 0.3,
			damage = 8, kbBase = 26, kbGrowth = 50, kbAngle = 35,
			projectile = { speed = 70, angle = 0, gravity = 0, lifetime = 1, size = 1.8, color = TUX, visual = HAT, returns = true },
			variants = {
				{ label = "Chapeau boomerang : une colombe en sort", damage = 7, status = { name = "blinded", duration = 1.2 } },
				{ label = "Chapeau boomerang : il explose !", damage = 11, kbBase = 32, kbGrowth = 62 },
				{ label = "Chapeau boomerang : le lapin mord au passage", damage = 5,
					projectile = { speed = 70, angle = 0, gravity = 0, lifetime = 1, size = 1.8, color = TUX, visual = HAT, returns = true, hits = 2 } },
			},
			windup = { Root = { 6, -24, 0, 0, -0.2, 0.2 }, Waist = { 8, -28, 0 }, Neck = { 0, 18, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 }, LS = { 175, 0, 10 }, LE = { 60, 0, 0 } },
			strike = { Root = { -8, 20, 0, 0, -0.3, -0.25 }, Waist = { -10, 26, 0 }, Neck = { 0, -16, 0 }, RS = { 30, 0, 50 }, RE = { 50, 0, 0 }, LS = { 90, 0, -30 }, LE = { 0, 0, 0 } },
			follow = { Root = { -10, 26, 0, 0, -0.3, -0.3 }, Waist = { -12, 32, 0 }, Neck = { 0, -20, 0 }, RS = { 28, 0, 52 }, RE = { 50, 0, 0 }, LS = { 85, 0, -55 }, LE = { 5, 0, 0 } },
			text = "ET HOP, LE CHAPEAU !", hitText = "TCHONK !",
		},

		------------------------------------------------------------------ Supers
		-- Le Grand Final : il tire un rideau de scène devant l'adversaire… qui disparaît et réapparaît sonné
		SUPER = {
			label = "Le Grand Final !", superCost = 100, startup = 0.35, active = 0.2, recovery = 0.55,
			damage = 22, hitbox = box(9, 7, 3.5, 1), kbBase = 22, kbGrowth = 35, kbAngle = 70,
			status = { name = "stunned", duration = 2 },
			windup = { Root = { 6, -20, 0, 0, -0.1, 0.2 }, Waist = { 10, -20, 0 }, Neck = { 15, 10, 0 }, RS = { 170, 0, 50 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -50 }, LE = { 20, 0, 0 } },
			strike = { Root = { -10, 20, 0, 0, -0.3, -0.3 }, Waist = { -12, 20, 0 }, Neck = { 0, -10, 0 }, RS = { 100, 0, -30 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 100, 0, 30 }, LE = { 10, 0, 0 } },
			follow = { Root = { 10, 0, 0, 0, -0.5, 0 }, Waist = { -40, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 60, 0, 80 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -80 }, LE = { 10, 0, 0 } },
			hold = 0.5, windupFx = { "super" },
			fx = { { "screen", color = VELVET, alpha = 0.45 }, { "pillar", color = VELVET, height = 10, width = 5, at = "front", neon = false, transparency = 0, time = 0.6 }, { "symbols", symbols = { "✨", "🎩", "★" }, color = SPARK, count = 8, radius = 5, at = "front" } },
			text = "MESDAMES ET MESSIEURS… TA-DAAAA !", hitText = "OÙ SUIS-JE ?",
		},
		-- Vol à la tire : il serre la main de l'adversaire, lui fait les poches… et le laisse muet de stupeur
		-- Super ↑ : il tente une lévitation, tourne sur lui-même et emporte tout dans un tourbillon d'étincelles
		SUPER_up = {
			label = "Lévitation ratée !", superCost = 100, startup = 0.25, active = 0.45, recovery = 0.55,
			damage = 22, hitbox = box(9, 10, 0, 3), kbBase = 45, kbGrowth = 95, kbAngle = 86, invuln = 0.3,
			windup = { Root = { -7.2, 0, 0, 0, -0.5, 0 }, Waist = { -16.8, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 192, 0, -24 }, RE = { 120, 0, 0 }, LS = { 192, 0, 24 }, LE = { 120, 0, 0 } },
			strike = { Root = { 33.6, 0, 0, 0, -0.15, 0.35 }, Waist = { 14.4, 0, 0 }, Neck = { 24, 0, 0 }, RS = { -36, 0, 72 }, RE = { 24, 0, 0 }, LS = { -36, 0, -72 }, LE = { 24, 0, 0 }, RH = { 180, 0, 0 }, RK = { 0, 0, 0 }, RA = { -24, 0, 0 } },
			follow = { Root = { 38.4, 0, 0, 0, -0.15, 0.45 }, Waist = { 16.8, 0, 0 }, Neck = { 28.8, 0, 0 }, RS = { -42, 0, 78 }, RE = { 24, 0, 0 }, LS = { -42, 0, -78 }, LE = { 24, 0, 0 }, RH = { 192, 0, 0 }, RK = { 0, 0, 0 }, RA = { -24, 0, 0 } },
			spin = { axis = "y", degrees = 720 }, selfVelocity = Vector2.new(0, 70),
			windupFx = { "super" }, trail = "prop", variants = { { label = "Lévitation ratée : colombes !", hitText = "ROUCOU !" }, { label = "Lévitation ratée : BOUM !", damage = 26, hitText = "KABOUM !" }, { label = "Lévitation ratée : lapin !", status = { name = "dog", duration = 2 }, hitText = "COUIC !" } }, fx = { { "particles", tex = "spark", color = Color3.fromRGB(190, 110, 255), dir = "all", at = "root", time = 0.7 } }, text = "ABRACADA… OUPS !", hitText = "TA-DAAA !",
		},
		-- (le moteur ne sait pas voler la jauge Super : il vole de l'énergie et rend l'adversaire muet)
		SUPER_down = {
			label = "Vol à la tire !", superCost = 100, startup = 0.3, active = 0.15, recovery = 0.5,
			damage = 18, hitbox = box(5, 4, 2.5, 0.5), kbBase = 20, kbGrowth = 30, kbAngle = 30,
			status = { name = "muted", duration = 3 }, selfEffect = { energy = 50 },
			windup = { Root = { 6, 0, 0, 0, -0.1, 0.1 }, Waist = { 12, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 60, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -10 }, LE = { 30, 0, 0 } },
			strike = { Root = { -14, 0, 0, 0, -0.35, -0.4 }, Waist = { -16, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 20, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, 10 }, LE = { 10, 0, 0 } },
			follow = { Root = { 6, 30, 0, 0, -0.2, 0.2 }, Waist = { 8, 30, 0 }, Neck = { 20, -20, 0 }, RS = { 150, 0, 40 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 120, 0, 0 } },
			hold = 0.3, windupFx = { "super" }, fx = { { "symbols", symbols = { "💰", "⭐", "✨" }, color = SPARK, count = 6, radius = 3, at = "front" } },
			text = "MERCI POUR LE POURBOIRE !", hitText = "HÉ ! MON PORTEFEUILLE !",
		},

		------------------------------------------------------------------ Chope (bouton ✋) et projections
		-- Prise magique : il ôte son chapeau d'un grand geste et le rabat sur l'adversaire, qui disparaît dedans
		GRAB = {
			label = "Prise magique", kind = "grab", startup = 0.1, active = 0.12, recovery = 0.35,
			damage = 0, hitbox = box(4, 4, 2, 0.5),
			windup = { Root = { 6, 0, 0, 0, -0.05, 0.1 }, Waist = { 12, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 100, 0, 60 }, RE = { 30, 0, 0 }, LS = { 175, 0, -10 }, LE = { 60, 0, 0 } },
			strike = { Root = { -8, 0, 0, 0, -0.2, -0.3 }, Waist = { -16, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 80, 0, -10 }, RE = { 50, 0, 0 }, LS = { 100, 0, 10 }, LE = { 30, 0, 0 } },
			follow = { Root = { -6, 0, 0, 0, -0.15, -0.3 }, Waist = { -12, 0, 0 }, Neck = { -4, 0, 0 }, RS = { 82, 0, -16 }, RE = { 60, 0, 0 }, LS = { 95, 0, 14 }, LE = { 40, 0, 0 } },
			fx = { { "particles", tex = "spark", color = MAGIC, at = "front", dir = "all", time = 0.2, speed = 6 } }, text = "UN VOLONTAIRE !", hitText = "HOP !",
		},
		-- ✋ puis → : Et hop !, coup de baguette sur le chapeau : l'adversaire en ressort devant, propulsé
		THROW_fwd = {
			label = "Et hop !", kind = "throw", startup = 0.32, active = 0.08, recovery = 0.3,
			damage = 9, kbBase = 40, kbGrowth = 55, kbAngle = 25,
			carry = { { 0, 2.4, 0.4 }, { 0.16, 2.4, 1.2 }, { 0.32, 4.5, 0.5 } },
			windup = { Root = { 6, 0, 0, 0, -0.1, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 170, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -20 }, LE = { 70, 0, 0 } },
			strike = { Root = { -14, 0, 0, 0, -0.35, -0.35 }, Waist = { -20, 0, 0 }, Neck = { -5, 0, 0 }, RS = { 80, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, -10 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -16, 0, 0, 0, -0.38, -0.4 }, Waist = { -22, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 75, 0, 0 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 95, 0, -15 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			fx = { { "burst", color = SMOKE, size = 3 } }, text = "ET HOP !", hitText = "PLOP !",
		},
		-- ✋ puis ← : Boîte coupée en deux, une boîte de magie se referme sur l'adversaire et l'éjecte derrière Gaston
		THROW_back = {
			label = "Boîte coupée en deux", kind = "throw", back = true, startup = 0.42, active = 0.1, recovery = 0.4,
			damage = 12, kbBase = 36, kbGrowth = 68, kbAngle = 40,
			carry = { { 0, 2.2, 0.3 }, { 0.15, 2.2, 0.3 }, { 0.28, 0.5, 1.5 }, { 0.42, -2.6, 0.4 } },
			windup = { Root = { 0, 30, 0, 0, -0.2, 0 }, Waist = { 4, 30, 0 }, Neck = { 0, -20, 0 }, RS = { 120, 0, 40 }, RE = { 30, 0, 0 }, LS = { 120, 0, -40 }, LE = { 30, 0, 0 } },
			strike = { Root = { 0, -120, 0, 0, -0.35, 0 }, Waist = { -10, -30, 0 }, Neck = { 0, 30, 0 }, RS = { 90, 0, 80 }, RE = { 10, 0, 0 }, LS = { 90, 0, -80 }, LE = { 10, 0, 0 } },
			follow = { Root = { 0, -150, 0, 0, -0.35, 0 }, Waist = { -10, -30, 0 }, Neck = { 0, 34, 0 }, RS = { 95, 0, 85 }, RE = { 10, 0, 0 }, LS = { 95, 0, -85 }, LE = { 10, 0, 0 } },
			fx = { { "burst", color = VELVET, size = 3 } }, text = "ET JE COUPE…", hitText = "CLAC-CLAC !",
		},
		-- ✋ puis ↑ : Lapin furieux, le lapin jaillit du chapeau et bouscule l'adversaire vers le ciel
		THROW_up = {
			label = "Lapin furieux", kind = "throw", startup = 0.3, active = 0.08, recovery = 0.35,
			damage = 9, kbBase = 38, kbGrowth = 60, kbAngle = 88,
			carry = { { 0, 2.2, 0.3 }, { 0.15, 2, 0 }, { 0.3, 0.8, 4.2 } },
			windup = { Root = { -6, 0, 0, 0, -0.4, 0.1 }, Waist = { -10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 30 }, RE = { 60, 0, 0 }, LS = { 50, 0, -10 }, LE = { 120, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { 6, 0, 0, 0, 0.2, -0.1 }, Waist = { 14, 0, 0 }, Neck = { 35, 0, 0 }, RS = { 60, 0, 70 }, RE = { 10, 0, 0 }, LS = { 175, 0, -10 }, LE = { 5, 0, 0 }, LW = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			follow = { Root = { 8, 0, 0, 0, 0.25, -0.1 }, Waist = { 16, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 65, 0, 75 }, RE = { 10, 0, 0 }, LS = { 180, 0, -12 }, LE = { 5, 0, 0 }, LW = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			prop = "lapin", text = "GRRRR !", hitText = "BOUM-LAPIN !",
		},
		-- ✋ puis ↓ : Tour raté, l'adversaire ressort du chapeau… et c'est le chapeau qui lui tombe dessus
		THROW_down = {
			label = "Tour raté", kind = "throw", startup = 0.4, active = 0.1, hold = 0.2, recovery = 0.35,
			damage = 10, kbBase = 30, kbGrowth = 25, kbAngle = 72,
			carry = { { 0, 2.2, 0.3 }, { 0.15, 2.2, 2 }, { 0.4, 2.4, -2.2 } },
			windup = { Root = { 10, 0, 0, 0, 0.05, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 170, 0, -10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, 10 }, LE = { 30, 0, 0 } },
			strike = { Root = { -10, 0, 0, 0, -0.5, -0.4 }, Waist = { -24, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 70, 0, -5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 5 }, LE = { 0, 0, 0 } },
			follow = { Root = { 0, 0, 0, 0, -0.3, -0.3 }, Waist = { 0, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 60 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -60 }, LE = { 30, 0, 0 } },
			fx = { "dust", { "symbols", symbols = { "🎩" }, count = 2, color = WHITE, radius = 1, at = "front" } }, text = "OUPS…", hitText = "BONK !",
		},
	},

	-- Séquences relatives à l'adversaire : forward = vers lui, back = à l'opposé
	fatals = {
		{
			id = "la_disparition", label = "La Disparition", sequence = { "forward", "back", "up" },
			-- rideau ! l'adversaire disparaît… et il n'en reste qu'un lapin dans le chapeau
			scene = {
				{ "fxAttacker", { "text", text = "REGARDEZ BIEN…", color = SPARK } },
				{ "spawn", at = "target", offset = Vector3.new(0, 0, -1.6), life = 1.6, pieces = {
					{ "Rideau", "", "block", Vector3.new(5, 7, 0.3), Vector3.new(0, 0.5, 0), Vector3.new(0, 0, 0), VELVET, "Fabric" },
					{ "Tringle", "", "cyl", Vector3.new(5.6, 0.25, 0.25), Vector3.new(0, 4.1, 0), Vector3.new(0, 0, 0), GOLD, "Metal", { axis = "x" } },
					{ "Frange", "", "block", Vector3.new(5, 0.3, 0.35), Vector3.new(0, -3, 0), Vector3.new(0, 0, 0), GOLD, "Fabric" },
				} },
				{ "wait", 0.6 },
				{ "hide" },
				{ "fx", { "burst", color = SMOKE, size = 5 } },
				{ "wait", 1 },
				{ "spawn", at = "target", offset = Vector3.new(0, -2.3, 0), life = 3, pieces = {
					{ "Chapeau", "", "cyl", Vector3.new(1.4, 1.4, 1.4), Vector3.new(0, 0.7, 0), Vector3.new(0, 0, 0), TUX, "SmoothPlastic", { axis = "y" } },
					{ "Bord", "", "cyl", Vector3.new(0.12, 2.2, 2.2), Vector3.new(0, 0.06, 0), Vector3.new(0, 0, 0), TUX, "SmoothPlastic", { axis = "y" } },
					{ "TeteLapin", "", "ball", Vector3.new(0.9, 0.8, 0.8), Vector3.new(0, 1.6, 0), Vector3.new(0, 0, 0), RABBIT, "Fabric" },
					{ "OreilleG", "", "ball", Vector3.new(0.25, 1, 0.2), Vector3.new(-0.2, 2.4, 0), Vector3.new(0, 0, 10), RABBIT, "Fabric" },
					{ "OreilleD", "", "ball", Vector3.new(0.25, 1, 0.2), Vector3.new(0.2, 2.4, 0), Vector3.new(0, 0, -10), RABBIT, "Fabric" },
				} },
				{ "text", "COUIC ?!" },
				{ "fxAttacker", { "text", text = "TA-DAAAA !", color = SPARK } },
				{ "fxAttacker", { "symbols", symbols = { "✨", "👏" }, count = 6, color = SPARK } },
				{ "wait", 1.2 },
			},
		},
		{
			id = "coupe_en_deux", label = "Coupé en deux", sequence = { "down", "down", "up" },
			-- le tour de la boîte : les deux moitiés partent chacune de leur côté en se disputant
			scene = {
				{ "spawn", at = "target", offset = Vector3.new(0, 0, 0), life = 1.6, pieces = {
					{ "Boite", "", "block", Vector3.new(3, 5, 3), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), SATIN, "WoodPlanks" },
					{ "Etoile", "", "ball", Vector3.new(0.8, 0.8, 0.1), Vector3.new(0, 1, -1.55), Vector3.new(0, 0, 0), SPARK, "Neon" },
					{ "Scie", "", "block", Vector3.new(4.5, 0.2, 3.6), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), Color3.fromRGB(200, 200, 210), "Metal" },
				} },
				{ "hide" },
				{ "fxAttacker", { "text", text = "ET JE SCIE… JE SCIE…", color = WHITE } },
				{ "fx", { "particles", tex = "spark", color = SPARK, at = "root", dir = "all", time = 1, speed = 8 } },
				{ "wait", 1.4 },
				{ "spawn", at = "target", offset = Vector3.new(-3, 1, 0), life = 2.2, pieces = {
					{ "MoitieHaut", "", "block", Vector3.new(3, 2.5, 3), Vector3.new(0, 0, 0), Vector3.new(0, 0, 10), SATIN, "WoodPlanks" },
				} },
				{ "spawn", at = "target", offset = Vector3.new(3, -1.2, 0), life = 2.2, pieces = {
					{ "MoitieBas", "", "block", Vector3.new(3, 2.5, 3), Vector3.new(0, 0, 0), Vector3.new(0, 0, -10), SATIN, "WoodPlanks" },
				} },
				{ "text", "C'EST TA FAUTE ! — NON, LA TIENNE !" },
				{ "wait", 1.4 },
			},
		},
		{
			id = "tour_rate", label = "Tour raté", sequence = { "back", "forward", "down" },
			-- Gaston se transforme lui-même en lapin… et c'est le vrai lapin qui achève l'adversaire d'une pichenette
			scene = {
				{ "fxAttacker", { "text", text = "ABRACADA… OH NON.", color = SPARK } },
				{ "fxAttacker", { "burst", color = SMOKE, size = 5, at = "root" } },
				{ "spawn", at = "attacker", offset = Vector3.new(0, -1.5, 0), life = 3.5, pieces = {
					{ "LapinGaston", "", "ball", Vector3.new(1.6, 2, 1.4), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), RABBIT, "Fabric" },
					{ "Moustache", "", "block", Vector3.new(0.9, 0.15, 0.1), Vector3.new(0, 0.5, -0.72), Vector3.new(0, 0, 0), Color3.fromRGB(30, 25, 25), "SmoothPlastic" },
					{ "MiniChapeau", "", "cyl", Vector3.new(0.8, 0.7, 0.7), Vector3.new(0, 1.4, 0), Vector3.new(0, 0, 0), TUX, "SmoothPlastic", { axis = "y" } },
				} },
				{ "wait", 0.8 },
				{ "spawn", at = "between", offset = Vector3.new(0, -1.5, 0), life = 2.5, pieces = {
					{ "VraiLapin", "", "ball", Vector3.new(1.2, 1.4, 1), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), RABBIT, "Fabric" },
					{ "OreilleG", "", "ball", Vector3.new(0.25, 1, 0.2), Vector3.new(-0.2, 1.1, 0), Vector3.new(0, 0, 10), RABBIT, "Fabric" },
					{ "OreilleD", "", "ball", Vector3.new(0.25, 0.9, 0.2), Vector3.new(0.3, 1, 0), Vector3.new(0, 0, -40), RABBIT, "Fabric" },
				} },
				{ "text", "… UN LAPIN ?" },
				{ "wait", 0.5 },
				{ "fx", { "text", text = "PICHENETTE.", color = WHITE } },
				{ "spin", 720, time = 0.6, axis = "y" },
				{ "launch", Vector3.new(50, 70, 0), time = 1 },
				{ "wait", 0.5 },
			},
		},
	},

	-- Mécanique : Tours ratés, 3 résultats par spécial, le prochain est annoncé (voir server/Mechanics.lua)
	passive = { kind = "tricks", name = "Tours ratés", icon = "🎩", icons = { "🕊️", "💥", "🐇" }, color = MAGIC },

	-- Recharge ⚡ : il tente un tour de cartes (elles s'envolent partout), puis tend la baguette au lapin du chapeau
	-- qui la recharge à contrecœur.
	charge = {
		label = "Tour de cartes",
		loop = 1.8,
		lockWrist = true,
		color = MAGIC,
		keys = {
			{ 0.0, { Root = { 0, 0, 0, 0, -0.15, 0 }, Waist = { 4, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 50, 0, -20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, 20 }, LE = { 90, 0, 0 } } },
			{ 0.25, { Root = { 0, 0, 0, 0, -0.15, 0 }, Waist = { 4, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, -10 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 45, 0, 25 }, LE = { 100, 0, 0 } } },
			{ 0.5, { Root = { 4, 0, 0, 0, -0.1, 0.1 }, Waist = { 12, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 150, 0, 40 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -40 }, LE = { 20, 0, 0 } } },
			{ 0.8, { Root = { 6, 0, 0, 0, -0.15, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 30, 15, 0 }, RS = { 140, 0, 50 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 60, 0, 0 } } },
			{ 1.1, { Root = { 2, 0, 0, 0, -0.15, 0 }, Waist = { 6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 165, 0, -5 }, RE = { 40, 0, 0 }, RW = { 30, 0, 0 }, LS = { 30, 0, -30 }, LE = { 60, 0, 0 } } },
			{ 1.4, { Root = { 2, 0, 0, 0, -0.15, 0 }, Waist = { 6, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 165, 0, -8 }, RE = { 45, 0, 0 }, RW = { 30, 0, 0 }, LS = { 30, 0, -30 }, LE = { 60, 0, 0 } } },
			{ 1.8, { Root = { 0, 0, 0, 0, -0.15, 0 }, Waist = { 4, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 50, 0, -20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, 20 }, LE = { 90, 0, 0 } } },
		},
		beats = {
			{ 0.5, { "symbols", symbols = { "♠", "♥", "♦", "♣" }, color = WHITE, count = 8, radius = 4, at = "above" } },
			{ 0.8, { "text", text = "… OUPS.", color = WHITE } },
			{ 1.15, { "text", text = "GRMBL…", color = RABBIT, at = "above" } },
			{ 1.3, { "particles", tex = "spark", color = MAGIC, at = "hand", dir = "all", time = 0.4, speed = 5 } },
		},
	},

	-- Manies au repos
	fidgets = {
		-- il lisse sa moustache d'un air important
		{ duration = 1.8, keys = {
			{ 0, {} },
			{ 0.35, { Neck = { 10, -10, 0 }, LS = { 120, 0, 30 }, LE = { 140, 0, 0 } } },
			{ 0.7, { Neck = { 12, -10, 0 }, LS = { 115, 0, 10 }, LE = { 145, 0, 0 } } },
			{ 1.05, { Neck = { 10, -10, 0 }, LS = { 120, 0, 30 }, LE = { 140, 0, 0 } } },
			{ 1.8, {} },
		} },
		-- il soulève son chapeau, le lapin le fusille du regard, il le repose vite
		{ duration = 2, keys = {
			{ 0, {} },
			{ 0.4, { Neck = { 25, 0, 0 }, LS = { 175, 0, -10 }, LE = { 60, 0, 0 } } },
			{ 0.9, { Root = { 0, 0, 0, 0, 0, 0.2 }, Neck = { 30, 10, 0 }, LS = { 178, 0, -15 }, LE = { 50, 0, 0 } } },
			{ 1.3, { Neck = { 5, 0, 0 }, LS = { 165, 0, -10 }, LE = { 80, 0, 0 } } },
			{ 2, {} },
		} },
		-- grande révérence au public imaginaire
		{ duration = 2.2, keys = {
			{ 0, {} },
			{ 0.4, { Waist = { 0, 0, 0 }, RS = { 120, 0, 70 }, RE = { 20, 0, 0 }, LS = { 30, 0, -30 }, LE = { 20, 0, 0 } } },
			{ 0.9, { Root = { -10, 0, 0, 0, -0.2, 0 }, Waist = { -40, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 10 }, RE = { 100, 0, 0 }, LS = { 10, 0, -60 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, 0.4 } } },
			{ 1.5, { Root = { -10, 0, 0, 0, -0.2, 0 }, Waist = { -40, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 10 }, RE = { 100, 0, 0 }, LS = { 10, 0, -60 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, 0.4 } } },
			{ 2.2, {} },
		} },
	},
}

-- Pendant qu'il tient quelqu'un : la main gauche tient le chapeau ouvert au-dessus de l'adversaire,
-- la baguette fait des moulinets au-dessus
data.grabHold = {
	Root = { 4, 0, 0, 0, -0.1, 0 },
	Waist = { 10, 0, 0 },
	Neck = { 14, 0, 0 },
	RS = { 150, 0, 30 },
	RE = { 30, 0, 0 },
	RW = { 0, 0, 0 },
	LS = { 100, 0, 10 },
	LE = { 40, 0, 0 },
}

-- Retour 🪂 : il apparaît dans un nuage de fumée raté (il tousse) sur sa malle de scène, le lapin sort du chapeau,
-- lève les yeux au ciel et lui rend sa baguette ; Gaston salue.
data.respawn = {
	duration = 1.9,
	platform = { pieces = {
		{ "Malle", "base", "block", Vector3.new(5, 1.6, 3), Vector3.new(0, -0.8, 0), Vector3.new(0, 0, 0), SATIN, "WoodPlanks" },
		{ "Cerclage1", "", "block", Vector3.new(5.1, 0.2, 3.1), Vector3.new(0, -0.2, 0), Vector3.new(0, 0, 0), GOLD, "Metal" },
		{ "Cerclage2", "", "block", Vector3.new(5.1, 0.2, 3.1), Vector3.new(0, -1.4, 0), Vector3.new(0, 0, 0), GOLD, "Metal" },
		{ "EtoileG", "", "ball", Vector3.new(0.6, 0.6, 0.1), Vector3.new(-1.4, -0.8, -1.55), Vector3.new(0, 0, 0), SPARK, "Neon" },
		{ "EtoileD", "", "ball", Vector3.new(0.6, 0.6, 0.1), Vector3.new(1.4, -0.8, -1.55), Vector3.new(0, 0, 0), SPARK, "Neon" },
		{ "Fumee1", "", "ball", Vector3.new(3, 2, 2), Vector3.new(-1.8, 0.6, 1.2), Vector3.new(0, 0, 0), SMOKE, "SmoothPlastic", { transparency = 0.4 } },
		{ "Fumee2", "", "ball", Vector3.new(2.6, 1.8, 2), Vector3.new(1.9, 1, 1.3), Vector3.new(0, 0, 0), SMOKE, "SmoothPlastic", { transparency = 0.45 } },
	} },
	keys = {
		{ 0.0, { Root = { -14, 0, 0, 0, -0.35, 0 }, Waist = { -30, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 20, 0, 10 }, RE = { 30, 0, 0 }, LS = { 120, 0, 20 }, LE = { 140, 0, 0 } } },
		{ 0.2, { Root = { -8, 0, 0, 0, -0.3, 0 }, Waist = { -18, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 20, 0, 10 }, RE = { 30, 0, 0 }, LS = { 120, 0, 20 }, LE = { 140, 0, 0 } } },
		{ 0.4, { Root = { -14, 0, 0, 0, -0.35, 0 }, Waist = { -30, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 20, 0, 10 }, RE = { 30, 0, 0 }, LS = { 120, 0, 20 }, LE = { 140, 0, 0 } } },
		{ 0.75, { Root = { 4, 0, 0 }, Waist = { 6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 20, 0, 20 }, RE = { 20, 0, 0 }, LS = { 30, 0, -20 }, LE = { 30, 0, 0 } } },
		{ 1.05, { Root = { 4, 0, 0 }, Waist = { 6, 0, 0 }, Neck = { 35, 0, 0 }, RS = { 165, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 30, 0, 0 } } },
		{ 1.3, { Root = { 2, 0, 0 }, Waist = { 4, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 90, 0, 40 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 } } },
		{ 1.6, { Root = { -8, 0, 0, 0, -0.15, 0 }, Waist = { -30, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 10 }, RE = { 100, 0, 0 }, LS = { 10, 0, -60 }, LE = { 20, 0, 0 } } },
		{ 1.9, {} },
	},
	beats = {
		{ 0.0, { "particles", tex = "smoke", color = SMOKE, at = "root", dir = "all", time = 0.8, speed = 6, size = 1.4 } },
		{ 0.15, { "text", text = "KOF ! KOF !", color = WHITE } },
		{ 0.8, { "text", text = "*soupir de lapin*", color = RABBIT, at = "above" } },
		{ 1.05, { "particles", tex = "spark", color = SPARK, at = "hand", dir = "all", time = 0.3, speed = 5 } },
		{ 1.6, { "symbols", symbols = { "✨", "★" }, color = SPARK, count = 5, radius = 3 } },
	},
}

-- Arbre d'enchaînements. En l'air, J et K s'alternent, une flèche choisit la version directionnelle,
-- ↓S pique en lâchant des colombes et ↑S reste la remontée.
local function airAfterP()
	return { K = "K_air", fwd_K = "K_air_side", up_K = "K_air_up", down_K = "K_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end
local function airAfterK()
	return { P = "P_air", fwd_P = "P_air_side", up_P = "P_air_up", down_P = "P_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end

local LINKS = {
	-- au sol : J…
	P_neutral = { P = "P_combo2", K = "PK_combo", fwd_P = "P_side2", down_K = "P_down", S = "S_finish_poof" },
	P_combo2 = { P = "P_combo3", K = "K_combo2", up_K = "K_upK", S = "S_finish_hat" }, -- J J (foulard)
	P_combo3 = { K = "K_combo3", S = "S_finish_poof" }, -- J J J
	PK_combo = { P = "KP_combo", K = "K_side", S = "S_finish_poof" }, -- J K
	-- au sol : K…
	K_neutral = { K = "K_combo2", P = "KP_combo", up_K = "K_upK", S = "S_finish_hat" },
	K_combo2 = { K = "K_combo3", P = "P_combo3", S = "S_finish_poof" }, -- K K
	K_combo3 = { K = "K_air_side", S = "S_air" }, -- K K K (il décolle)
	KP_combo = { P = "P_combo3", K = "K_downK", S = "S_finish_hat" }, -- K J
	-- avec une flèche
	P_side = { P = "P_side2", K = "K_side", S = "S_finish_hat" }, -- → J (cartes)
	P_side2 = { K = "K_side2", P = "P_combo3", S = "S_finish_poof" }, -- → J J
	P_down = { P = "P_down2", K = "K_downK", S = "S_finish_poof" }, -- ↓ J
	P_down2 = { P = "P_air_up", K = "K_air_up", S = "S_finish_hat" }, -- ↓ J J (fait décoller)
	P_up = { K = "K_upK", P = "P_down2", S = "S_finish_poof" }, -- ↑ J
	K_side = { K = "K_side2", P = "KP_combo", S = "S_finish_hat" }, -- → K (canne)
	K_side2 = { P = "P_combo3", K = "K_combo3", S = "S_finish_poof" }, -- → K K (il ramène l'adversaire contre lui)
	K_down = { K = "K_downK", P = "P_down2", S = "S_finish_poof" }, -- ↓ K
	K_downK = { K = "K_air_up", S = "S_finish_hat" }, -- ↓ K K
	K_up = { K = "K_upK", S = "S_finish_hat" }, -- ↑ K
	K_upK = { S = "S_finish_poof" }, -- ↑ K K
	P_dash = { P = "P_combo2", K = "PK_combo", S = "S_finish_poof" }, -- dash J
	K_dash = { K = "K_downK", P = "KP_combo", S = "S_finish_hat" }, -- dash K
	-- en l'air ; ↓ J et ↓ K (smash vers le sol) sont des finitions sans suite
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
