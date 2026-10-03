-- Mamie Tricot (Germaine) : 1,40 m de malice voûtée, zoneuse qui sème ses pelotes-pièges et lance ses chats.
-- Arme sortie de la Caisse Bizarre : sac à main (main droite) & canne (main gauche).
--
-- Même format que Gege.lua (voir l'en-tête de Gege.lua et docs/fiche-perso.md).
-- Mamie est voûtée : presque tous ses coups gardent le buste penché (Waist rx −), la nuque relevée pour
-- regarder par-dessus ses lunettes, et de tout petits pas. Le sac pend au poignet droit, la canne est à gauche.

local function box(width, height, forward, up)
	return { size = Vector3.new(width, height, 6), offset = Vector2.new(forward, up) }
end

local SKIN = Color3.fromRGB(240, 205, 185)
local HAIR = Color3.fromRGB(225, 225, 232)
local SHAWL = Color3.fromRGB(150, 85, 160)
local DRESS = Color3.fromRGB(95, 120, 170)
local LEATHER = Color3.fromRGB(120, 60, 35)
local GOLD = Color3.fromRGB(230, 190, 70)
local WOOD = Color3.fromRGB(110, 70, 40)
local WOOL = Color3.fromRGB(240, 120, 170)
local WOOL2 = Color3.fromRGB(120, 200, 230)
local MINOU = Color3.fromRGB(240, 150, 60) -- le chat roux (épaule droite)
local POMPON = Color3.fromRGB(70, 70, 75) -- le chat gris (épaule gauche)
local MINT = Color3.fromRGB(170, 240, 210)
local SLIPPER = Color3.fromRGB(200, 60, 90)
local WHITE = Color3.fromRGB(250, 250, 250)

-- Chat lancé (projectile) : boule de poils, tête, oreilles et queue
local function catVisual(color)
	return {
		shape = "ball", size = 1.2, color = color, spin = 8,
		parts = {
			{ "ball", Vector3.new(0.75, 0.7, 0.7), Vector3.new(0.65, 0.35, 0), color },
			{ "block", Vector3.new(0.18, 0.3, 0.18), Vector3.new(0.5, 0.8, 0.2), color },
			{ "block", Vector3.new(0.18, 0.3, 0.18), Vector3.new(0.8, 0.8, -0.2), color },
			{ "cyl", Vector3.new(0.9, 0.15, 0.15), Vector3.new(-0.8, 0.3, 0), color },
		},
	}
end

local data = {
	id = "Mamie",
	name = "Mamie Tricot",
	costume = "Mamie",
	style = "granny",

	-- Costume : chignon blanc, lunettes triple foyer, châle violet, robe bleue, chaussons, et ses deux chats
	-- (Minou le roux sur l'épaule droite, Pompon le gris sur la gauche)
	look = {
		body = {
			head = SKIN, upper = DRESS, lower = DRESS, arms = SHAWL, hands = SKIN, legs = Color3.fromRGB(215, 180, 160),
			feet = SLIPPER, forearms = DRESS,
		},
		cubeHead = 1.2,
		parts = {
			{ "Chignon", "Head", "ball", Vector3.new(0.85, 0.7, 0.85), Vector3.new(0, 0.75, 0.25), Vector3.new(0, 0, 0), HAIR, "Fabric" },
			{ "Cheveux", "Head", "block", Vector3.new(1.28, 0.35, 1.28), Vector3.new(0, 0.48, 0.02), Vector3.new(0, 0, 0), HAIR, "Fabric" },
			{ "PiqueChignon", "Head", "cyl", Vector3.new(1.1, 0.08, 0.08), Vector3.new(0, 0.85, 0.25), Vector3.new(0, 0, 25), WOOL, "SmoothPlastic", { axis = "x" } },
			{ "VerreDroit", "Head", "cyl", Vector3.new(0.08, 0.5, 0.5), Vector3.new(0.27, 0.08, -0.64), Vector3.new(0, 0, 0), Color3.fromRGB(200, 230, 255), "Glass", { axis = "z", transparency = 0.2 } },
			{ "VerreGauche", "Head", "cyl", Vector3.new(0.08, 0.5, 0.5), Vector3.new(-0.27, 0.08, -0.64), Vector3.new(0, 0, 0), Color3.fromRGB(200, 230, 255), "Glass", { axis = "z", transparency = 0.2 } },
			{ "Foyers", "Head", "block", Vector3.new(1.05, 0.05, 0.1), Vector3.new(0, 0.02, -0.68), Vector3.new(0, 0, 0), Color3.fromRGB(60, 40, 30) },
			{ "Nez", "Head", "ball", Vector3.new(0.28, 0.32, 0.3), Vector3.new(0, -0.15, -0.66), Vector3.new(0, 0, 0), Color3.fromRGB(235, 175, 160) },
			{ "Chale", "UpperTorso", "wedge", Vector3.new(2.3, 0.9, 1.25), Vector3.new(0, 0.55, 0.05), Vector3.new(0, 180, 0), SHAWL, "Fabric" },
			{ "PointeChale", "UpperTorso", "wedge", Vector3.new(1.2, 1.1, 0.15), Vector3.new(0, 0.1, 0.56), Vector3.new(180, 0, 0), SHAWL, "Fabric" },
			{ "Broche", "UpperTorso", "ball", Vector3.new(0.3, 0.3, 0.15), Vector3.new(0, 0.35, -0.55), Vector3.new(0, 0, 0), GOLD, "Metal" },
			{ "Jupe", "LowerTorso", "block", Vector3.new(2.2, 1.1, 1.3), Vector3.new(0, -0.55, 0), Vector3.new(0, 0, 0), DRESS, "Fabric" },
			{ "Tablier", "LowerTorso", "block", Vector3.new(1.3, 1.0, 0.08), Vector3.new(0, -0.45, -0.68), Vector3.new(0, 0, 0), WHITE, "Fabric" },
			-- Minou (roux), assis sur l'épaule droite
			{ "MinouCorps", "UpperTorso", "ball", Vector3.new(0.65, 0.55, 0.85), Vector3.new(0.95, 1.1, 0.15), Vector3.new(0, 0, 0), MINOU, "Fabric" },
			{ "MinouTete", "UpperTorso", "ball", Vector3.new(0.55, 0.5, 0.5), Vector3.new(1.0, 1.5, -0.25), Vector3.new(0, 0, 0), MINOU, "Fabric" },
			{ "MinouOreille", "UpperTorso", "wedge", Vector3.new(0.4, 0.22, 0.15), Vector3.new(1.0, 1.82, -0.25), Vector3.new(0, 0, 0), MINOU, "Fabric" },
			{ "MinouQueue", "UpperTorso", "cyl", Vector3.new(0.8, 0.12, 0.12), Vector3.new(1.15, 1.0, 0.65), Vector3.new(0, 0, -55), MINOU, "Fabric", { axis = "x" } },
			-- Pompon (gris), sur l'épaule gauche
			{ "PomponCorps", "UpperTorso", "ball", Vector3.new(0.65, 0.55, 0.85), Vector3.new(-0.95, 1.1, 0.15), Vector3.new(0, 0, 0), POMPON, "Fabric" },
			{ "PomponTete", "UpperTorso", "ball", Vector3.new(0.55, 0.5, 0.5), Vector3.new(-1.0, 1.5, -0.25), Vector3.new(0, 0, 0), POMPON, "Fabric" },
			{ "PomponOreille", "UpperTorso", "wedge", Vector3.new(0.4, 0.22, 0.15), Vector3.new(-1.0, 1.82, -0.25), Vector3.new(0, 0, 0), POMPON, "Fabric" },
			{ "PomponQueue", "UpperTorso", "cyl", Vector3.new(0.8, 0.12, 0.12), Vector3.new(-1.15, 1.0, 0.65), Vector3.new(0, 0, 55), POMPON, "Fabric", { axis = "x" } },
			{ "PomponChausson", "LeftFoot", "ball", Vector3.new(0.35, 0.3, 0.35), Vector3.new(0, 0.15, -0.45), Vector3.new(0, 0, 0), WHITE, "Fabric" },
			{ "MinouChausson", "RightFoot", "ball", Vector3.new(0.35, 0.3, 0.35), Vector3.new(0, 0.15, -0.45), Vector3.new(0, 0, 0), WHITE, "Fabric" },
		},
		props = {
			-- L'arme (Caisse Bizarre) : le sac à main en cuir qui pend au poignet droit…
			{ name = "PropSac", hand = "Right", visible = true, pieces = {
				{ "Anse", "", "block", Vector3.new(0.12, 0.55, 0.12), Vector3.new(0, -0.3, 0), Vector3.new(0, 0, 0), LEATHER },
				{ "Corps", "", "block", Vector3.new(1.1, 0.85, 0.5), Vector3.new(0, -1.0, 0), Vector3.new(0, 0, 0), LEATHER, "Fabric" },
				{ "Rabat", "", "block", Vector3.new(1.14, 0.35, 0.54), Vector3.new(0, -0.72, 0), Vector3.new(0, 0, 0), Color3.fromRGB(90, 45, 25), "Fabric" },
				{ "Fermoir", "", "ball", Vector3.new(0.2, 0.2, 0.12), Vector3.new(0, -0.85, -0.28), Vector3.new(0, 0, 0), GOLD, "Metal" },
			} },
			-- … et la canne en bois dans la main gauche
			{ name = "PropCanne", hand = "Left", visible = true, pieces = {
				{ "Baton", "", "cyl", Vector3.new(3, 0.18, 0.18), Vector3.new(0, -1.35, 0), Vector3.new(0, 0, 0), WOOD, "Wood" },
				{ "Crosse", "", "cyl", Vector3.new(0.6, 0.18, 0.18), Vector3.new(0, 0.12, -0.22), Vector3.new(0, 0, 0), WOOD, "Wood", { axis = "z" } },
				{ "Embout", "", "ball", Vector3.new(0.26, 0.26, 0.26), Vector3.new(0, -2.85, 0), Vector3.new(0, 0, 0), Color3.fromRGB(40, 40, 40) },
			} },
			-- Objets ponctuels (prop = "…" dans les coups)
			{ name = "PropAiguille", hand = "Right", visible = false, pieces = {
				{ "Aiguille", "", "cyl", Vector3.new(3.4, 0.1, 0.1), Vector3.new(0, -1.6, 0), Vector3.new(0, 0, 0), Color3.fromRGB(200, 200, 210), "Metal" },
				{ "Bouton", "", "ball", Vector3.new(0.25, 0.25, 0.25), Vector3.new(0, 0.1, 0), Vector3.new(0, 0, 0), WOOL },
			} },
			{ name = "PropParapluie", hand = "Right", visible = false, pieces = {
				{ "Manche", "", "cyl", Vector3.new(2.4, 0.1, 0.1), Vector3.new(0, -1.1, 0), Vector3.new(0, 0, 0), WOOD, "Wood" },
				{ "Toile", "", "ball", Vector3.new(3.4, 1.0, 3.4), Vector3.new(0, -2.3, 0), Vector3.new(0, 0, 0), Color3.fromRGB(90, 40, 110), "Fabric" },
				{ "Pointe", "", "ball", Vector3.new(0.2, 0.4, 0.2), Vector3.new(0, -2.85, 0), Vector3.new(0, 0, 0), GOLD, "Metal" },
			} },
			{ name = "PropDentier", hand = "Right", visible = false, pieces = {
				{ "Gencive", "", "block", Vector3.new(0.8, 0.22, 0.6), Vector3.new(0, -0.35, -0.15), Vector3.new(0, 0, 0), Color3.fromRGB(230, 120, 140) },
				{ "Dents", "", "block", Vector3.new(0.75, 0.2, 0.55), Vector3.new(0, -0.55, -0.15), Vector3.new(0, 0, 0), WHITE },
				{ "Gencive2", "", "block", Vector3.new(0.8, 0.22, 0.6), Vector3.new(0, -0.75, -0.15), Vector3.new(0, 0, 0), Color3.fromRGB(230, 120, 140) },
			} },
			{ name = "PropDeambulateur", hand = "Right", visible = false, pieces = {
				{ "Barre", "", "cyl", Vector3.new(2.2, 0.15, 0.15), Vector3.new(-0.9, 0, 0), Vector3.new(0, 0, 0), Color3.fromRGB(190, 190, 200), "Metal", { axis = "x" } },
				{ "MontantD", "", "cyl", Vector3.new(2.6, 0.13, 0.13), Vector3.new(0.15, -1.3, 0), Vector3.new(0, 0, 0), Color3.fromRGB(190, 190, 200), "Metal" },
				{ "MontantG", "", "cyl", Vector3.new(2.6, 0.13, 0.13), Vector3.new(-1.95, -1.3, 0), Vector3.new(0, 0, 0), Color3.fromRGB(190, 190, 200), "Metal" },
				{ "BalleD", "", "ball", Vector3.new(0.4, 0.4, 0.4), Vector3.new(0.15, -2.65, 0), Vector3.new(0, 0, 0), Color3.fromRGB(210, 240, 60), "Fabric" },
				{ "BalleG", "", "ball", Vector3.new(0.4, 0.4, 0.4), Vector3.new(-1.95, -2.65, 0), Vector3.new(0, 0, 0), Color3.fromRGB(210, 240, 60), "Fabric" },
			} },
			{ name = "PropEcharpe", hand = "Right", visible = false, pieces = {
				{ "Laine", "", "block", Vector3.new(0.45, 4.2, 0.12), Vector3.new(0, -2.1, 0), Vector3.new(0, 0, 0), Color3.fromRGB(200, 40, 50), "Fabric" },
				{ "Rayure", "", "block", Vector3.new(0.47, 0.4, 0.14), Vector3.new(0, -2.6, 0), Vector3.new(0, 0, 0), WHITE, "Fabric" },
				{ "Rayure2", "", "block", Vector3.new(0.47, 0.4, 0.14), Vector3.new(0, -3.6, 0), Vector3.new(0, 0, 0), WHITE, "Fabric" },
			} },
		},
	},

	moves = {
		------------------------------------------------------------------ Attaques légères (P)
		-- Coup de sac à main : voûtée, elle tourne le buste et balance le sac de la droite vers l'avant
		P_neutral = {
			label = "Coup de sac à main", startup = 0.08, active = 0.08, recovery = 0.16,
			damage = 6, hitbox = box(4.5, 3, 2.8, 0.4), kbBase = 18, kbGrowth = 24, kbAngle = 25,
			windup = { Root = { -6, -18, 0, 0, -0.15, 0.15 }, Waist = { -14, -24, 0 }, Neck = { 12, 18, 0 }, RS = { 55, 0, 65 }, RE = { 40, 0, 0 }, LS = { 20, 0, -10 }, LE = { 45, 0, 0 } },
			strike = { Root = { -10, 16, 0, 0, -0.2, -0.25 }, Waist = { -18, 24, 0 }, Neck = { 14, -14, 0 }, RS = { 95, 0, -15 }, RE = { 15, 0, 0 }, LS = { 12, 0, -18 }, LE = { 40, 0, 0 } },
			follow = { Root = { -10, 22, 0, 0, -0.2, -0.3 }, Waist = { -18, 32, 0 }, Neck = { 14, -20, 0 }, RS = { 85, 0, -40 }, RE = { 25, 0, 0 }, LS = { 8, 0, -22 }, LE = { 40, 0, 0 } },
			trail = "prop", hitText = "PAF !",
		},
		-- Long coup d'aiguille : elle sort une aiguille à tricoter et pique en estoc, pas glissé du pied gauche
		P_side = {
			label = "Long coup d'aiguille", startup = 0.1, active = 0.1, recovery = 0.2,
			damage = 7, hitbox = box(7, 2.2, 4, 0.8), kbBase = 22, kbGrowth = 38, kbAngle = 15, selfVelocity = Vector2.new(12, 0),
			windup = { Root = { -4, -25, 0, 0, -0.2, 0.3 }, Waist = { -10, -30, 0 }, Neck = { 10, 25, 0 }, RS = { 40, 0, 25 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 50, 0, 0 } },
			strike = { Root = { -12, 18, 0, 0, -0.3, -0.5 }, Waist = { -16, 24, 0 }, Neck = { 16, -18, 0 }, RS = { 92, 0, -6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -10, 0, -25 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -14, 22, 0, 0, -0.32, -0.55 }, Waist = { -18, 28, 0 }, Neck = { 18, -22, 0 }, RS = { 95, 0, -10 }, RE = { 0, 0, 0 }, RW = { -8, 0, 0 }, LS = { -15, 0, -28 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			prop = "aiguille", hideProp = "sac", text = "TIENS !", hitText = "PIC !",
		},
		-- Balayage de canne : accroupie sur ses vieux genoux, la canne rase le sol et fauche les chevilles
		P_down = {
			label = "Balayage de canne", startup = 0.1, active = 0.1, recovery = 0.2,
			damage = 6, hitbox = box(6, 1.8, 3, -2), kbBase = 24, kbGrowth = 22, kbAngle = 72,
			windup = { Root = { -10, 25, 0, 0, -0.65, 0.15 }, Waist = { -22, 20, 0 }, Neck = { 18, -15, 0 }, RS = { 30, 0, 20 }, RE = { 60, 0, 0 }, LS = { 40, 0, -85 }, LE = { 10, 0, 0 } },
			strike = { Root = { -14, -20, 0, 0, -0.8, -0.1 }, Waist = { -26, -22, 0 }, Neck = { 20, 15, 0 }, RS = { 25, 0, 30 }, RE = { 60, 0, 0 }, LS = { 70, 0, 10 }, LE = { 0, 0, 0 } },
			follow = { Root = { -14, -30, 0, 0, -0.8, -0.15 }, Waist = { -26, -30, 0 }, Neck = { 20, 20, 0 }, RS = { 25, 0, 32 }, RE = { 60, 0, 0 }, LS = { 70, 0, 35 }, LE = { 0, 0, 0 } },
			trail = "leftHand", fx = { { "particles", tex = "smoke", color = Color3.fromRGB(200, 190, 170), dir = "front", at = "feet", time = 0.25, speed = 6 } }, hitText = "CROC !",
		},
		-- Parapluie (anti-air) : elle ouvre son parapluie d'un coup sec au-dessus de sa tête
		P_up = {
			label = "Parapluie", startup = 0.1, active = 0.14, recovery = 0.22,
			damage = 7, hitbox = box(5, 5, 1, 3.5), kbBase = 26, kbGrowth = 32, kbAngle = 85,
			windup = { Root = { -8, 0, 0, 0, -0.45, 0 }, Waist = { -20, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 30, 0, 15 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -10 }, LE = { 40, 0, 0 } },
			strike = { Root = { 2, 0, 0, 0, 0.1, 0 }, Waist = { 6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 172, 0, 8 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 15, 0, -20 }, LE = { 35, 0, 0 }, FR = { 0, 0, 0, 0, 0.15, 0 }, FL = { 0, 0, 0, 0, 0.15, 0 } },
			follow = { Root = { 4, 8, 0, 0, 0.15, 0 }, Waist = { 8, 6, 0 }, Neck = { 34, 0, 0 }, RS = { 178, 0, 12 }, RE = { 8, 0, 0 }, RW = { -10, 0, 0 }, LS = { 15, 0, -22 }, LE = { 35, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			prop = "parapluie", hideProp = "sac", fx = { { "ring", color = Color3.fromRGB(150, 90, 170), radius = 4, at = "above" } }, text = "IL VA PLEUVOIR !", hitText = "FLOP !",
		},
		-- Parapluie tournoyant : en l'air, parapluie ouvert tendu devant, elle tourne comme une toupie
		P_air = {
			label = "Parapluie tournoyant", startup = 0.08, active = 0.2, recovery = 0.18,
			damage = 7, hitbox = box(6, 4, 1, 0.5), kbBase = 20, kbGrowth = 34, kbAngle = 40,
			windup = { Root = { -8, -30, 0 }, Waist = { -12, -20, 0 }, Neck = { 12, 20, 0 }, RS = { 60, 0, 60 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 50, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 50, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { -6, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 95, 0, 80 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -70 }, LE = { 20, 0, 0 }, RH = { 40, 0, 0 }, RK = { -80, 0, 0 }, LH = { 45, 0, 0 }, LK = { -85, 0, 0 } },
			follow = { Root = { -6, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 98, 0, 85 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 72, 0, -75 }, LE = { 20, 0, 0 }, RH = { 35, 0, 0 }, RK = { -75, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, prop = "parapluie", hideProp = "sac", trail = "prop", hitText = "FLOUF !",
		},
		-- Coup de cabas pressé (dash puis P) : « Pardon, pardon ! », elle fonce en tenant le sac devant elle
		P_dash = {
			label = "Coup de cabas pressé", startup = 0.08, active = 0.15, recovery = 0.25,
			damage = 8, hitbox = box(4.5, 3, 2.5, 0.3), kbBase = 28, kbGrowth = 50, kbAngle = 25, selfVelocity = Vector2.new(40, 0),
			windup = { Root = { -12, -10, 0, 0, -0.25, 0.1 }, Waist = { -20, -10, 0 }, Neck = { 22, 10, 0 }, RS = { 70, 0, 10 }, RE = { 90, 0, 0 }, LS = { 30, 0, -15 }, LE = { 30, 0, 0 } },
			strike = { Root = { -22, 5, 0, 0, -0.3, -0.3 }, Waist = { -22, 5, 0 }, Neck = { 30, 0, 0 }, RS = { 100, 0, -5 }, RE = { 30, 0, 0 }, LS = { 50, 0, -20 }, LE = { 20, 0, 0 } },
			follow = { Root = { -24, 8, 0, 0, -0.32, -0.35 }, Waist = { -24, 8, 0 }, Neck = { 32, 0, 0 }, RS = { 102, 0, -10 }, RE = { 28, 0, 0 }, LS = { 55, 0, -20 }, LE = { 20, 0, 0 } },
			trail = "prop", fx = { { "particles", tex = "smoke", color = Color3.fromRGB(220, 210, 190), dir = "up", at = "feet", time = 0.3, speed = 5 } }, text = "PARDON, PARDON !", hitText = "BLAM !",
		},

		-- Suites d'enchaînement (voir LINKS) : P P, P P P…
		-- P P : Pincement de joue, elle attrape la joue de l'adversaire et la tortille
		P_combo2 = {
			label = "Pincement de joue", startup = 0.07, active = 0.1, recovery = 0.16,
			damage = 5, hitbox = box(4, 3, 2.4, 1), kbBase = 16, kbGrowth = 20, kbAngle = 35,
			windup = { Root = { -4, -10, 0, 0, -0.1, 0.1 }, Waist = { -12, -12, 0 }, Neck = { 10, 10, 0 }, RS = { 70, 0, 20 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -10 }, LE = { 40, 0, 0 } },
			strike = { Root = { -10, 10, 0, 0, -0.15, -0.25 }, Waist = { -16, 12, 0 }, Neck = { 16, -8, 8 }, RS = { 100, 0, -5 }, RE = { 10, 0, 0 }, RW = { 0, 0, 35 }, LS = { 15, 0, -12 }, LE = { 40, 0, 0 } },
			follow = { Root = { -10, 12, 0, 0, -0.15, -0.28 }, Waist = { -16, 14, 0 }, Neck = { 16, -8, -8 }, RS = { 98, 0, -2 }, RE = { 12, 0, 0 }, RW = { 0, 0, -35 }, LS = { 15, 0, -12 }, LE = { 40, 0, 0 } },
			hold = 0.06, text = "QU'IL EST MIGNON !", hitText = "PINCE !",
		},
		-- P P P : Le cabas du marché, sac levé bien haut puis abattu sur le crâne
		P_combo3 = {
			label = "Le cabas du marché", startup = 0.14, active = 0.1, recovery = 0.3,
			damage = 9, hitbox = box(5, 4, 2.5, 1), kbBase = 30, kbGrowth = 60, kbAngle = 50,
			windup = { Root = { 4, -10, 0, 0, -0.05, 0.2 }, Waist = { 4, -12, 0 }, Neck = { 22, 0, 0 }, RS = { 178, 0, 20 }, RE = { 40, 0, 0 }, LS = { 25, 0, -15 }, LE = { 40, 0, 0 } },
			strike = { Root = { -16, 10, 0, 0, -0.45, -0.35 }, Waist = { -30, 10, 0 }, Neck = { 30, 0, 0 }, RS = { 70, 0, 5 }, RE = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 30, 0, 0 } },
			follow = { Root = { -18, 12, 0, 0, -0.5, -0.4 }, Waist = { -34, 12, 0 }, Neck = { 32, 0, 0 }, RS = { 40, 0, 5 }, RE = { 5, 0, 0 }, LS = { 30, 0, -22 }, LE = { 30, 0, 0 } },
			trail = "prop", fx = { { "burst", color = GOLD, size = 2.5 } }, text = "ET LE CABAS !", hitText = "BADABOUM !",
		},

		------------------------------------------------------------------ Attaques lourdes (K) : canne et pantoufles
		-- Coup de canne : elle pivote l'épaule gauche en avant et pique droit devant avec le bout caoutchouté
		K_neutral = {
			label = "Coup de canne", startup = 0.18, active = 0.1, recovery = 0.3,
			damage = 11, hitbox = box(6, 2.5, 3.5, 0.3), kbBase = 30, kbGrowth = 70, kbAngle = 30,
			windup = { Root = { -6, 22, 0, 0, -0.2, 0.2 }, Waist = { -14, 25, 0 }, Neck = { 12, -20, 0 }, RS = { 25, 0, 30 }, RE = { 50, 0, 0 }, LS = { 35, 0, -30 }, LE = { 105, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -12, -22, 0, 0, -0.3, -0.35 }, Waist = { -18, -26, 0 }, Neck = { 16, 20, 0 }, RS = { -10, 0, 25 }, RE = { 40, 0, 0 }, LS = { 92, 0, 5 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
			follow = { Root = { -14, -26, 0, 0, -0.32, -0.4 }, Waist = { -20, -30, 0 }, Neck = { 18, 24, 0 }, RS = { -15, 0, 25 }, RE = { 40, 0, 0 }, LS = { 95, 0, 8 }, LE = { 0, 0, 0 }, LW = { -8, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			trail = "leftHand", hitText = "TOC !",
		},
		-- Pantoufle : petit coup de pied tendu, la charentaise s'envole vers l'adversaire
		K_side = {
			label = "Pantoufle", startup = 0.2, active = 0.12, recovery = 0.32,
			damage = 12, hitbox = box(5, 2.5, 3, -0.4), kbBase = 32, kbGrowth = 75, kbAngle = 30, selfVelocity = Vector2.new(18, 0),
			windup = { Root = { 6, -8, 0, 0, -0.15, 0.2 }, Waist = { -6, -8, 0 }, Neck = { 6, 0, 0 }, RS = { 40, 0, 45 }, RE = { 60, 0, 0 }, LS = { 30, 0, -25 }, LE = { 40, 0, 0 }, RH = { 70, 0, 0 }, RK = { -110, 0, 0 }, RA = { -10, 0, 0 } },
			strike = { Root = { 14, 0, 0, 0, -0.1, -0.2 }, Waist = { 4, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 60, 0, 60 }, RE = { 30, 0, 0 }, LS = { 25, 0, -35 }, LE = { 35, 0, 0 }, RH = { 78, 0, 0 }, RK = { -4, 0, 0 }, RA = { 20, 0, 0 } },
			follow = { Root = { 16, 0, 0, 0, -0.1, -0.25 }, Waist = { 6, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 62, 0, 65 }, RE = { 30, 0, 0 }, LS = { 22, 0, -38 }, LE = { 35, 0, 0 }, RH = { 82, 0, 0 }, RK = { 0, 0, 0 }, RA = { 25, 0, 0 } },
			trail = "rightFoot", fx = { { "toss", shape = "flat", color = SLIPPER, size = 1, count = 1, speed = 26 } }, hitText = "FLAP !",
		},
		-- Crochet de canne : accroupie, elle accroche la cheville avec la crosse et tire l'adversaire vers elle
		K_down = {
			label = "Crochet de canne", startup = 0.18, active = 0.12, recovery = 0.3,
			damage = 10, hitbox = box(6, 2, 3.5, -2), kbBase = 26, kbGrowth = 40, kbAngle = 20, pull = true,
			windup = { Root = { -10, 25, 0, 0, -0.6, 0.1 }, Waist = { -28, 20, 0 }, Neck = { 22, -15, 0 }, RS = { 20, 0, 25 }, RE = { 60, 0, 0 }, LS = { 75, 0, -25 }, LE = { 10, 0, 0 }, LW = { 30, 0, 0 } },
			strike = { Root = { -14, 10, 0, 0, -0.75, -0.25 }, Waist = { -32, 10, 0 }, Neck = { 24, -8, 0 }, RS = { 20, 0, 28 }, RE = { 60, 0, 0 }, LS = { 60, 0, -10 }, LE = { 5, 0, 0 }, LW = { 40, 0, 0 } },
			follow = { Root = { -4, -10, 0, 0, -0.6, 0.15 }, Waist = { -20, -10, 0 }, Neck = { 18, 8, 0 }, RS = { 25, 0, 28 }, RE = { 60, 0, 0 }, LS = { 15, 0, -20 }, LE = { 70, 0, 0 }, LW = { 40, 0, 0 } },
			trail = "leftHand", text = "VIENS VOIR MAMIE !", hitText = "HOP !",
		},
		-- Recul prudent : petit pas en arrière et canne pointée vers le ciel (anti-air)
		K_up = {
			label = "Recul prudent", startup = 0.18, active = 0.14, recovery = 0.3,
			damage = 11, hitbox = box(4, 5, 0.8, 3.5), kbBase = 32, kbGrowth = 70, kbAngle = 88, selfVelocity = Vector2.new(-20, 0),
			windup = { Root = { -10, 10, 0, 0, -0.35, 0 }, Waist = { -24, 10, 0 }, Neck = { 30, 0, 0 }, RS = { 20, 0, 30 }, RE = { 60, 0, 0 }, LS = { 40, 0, -15 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { 8, -5, 0, 0, -0.1, 0.4 }, Waist = { 6, -5, 0 }, Neck = { 38, 0, 0 }, RS = { -20, 0, 35 }, RE = { 40, 0, 0 }, LS = { 175, 0, -5 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0.3 }, FL = { 0, 0, 0, 0, 0, 0.35 } },
			follow = { Root = { 10, -5, 0, 0, -0.1, 0.45 }, Waist = { 8, -5, 0 }, Neck = { 40, 0, 0 }, RS = { -25, 0, 38 }, RE = { 40, 0, 0 }, LS = { 180, 0, -2 }, LE = { 0, 0, 0 }, LW = { -10, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0.35 }, FL = { 0, 0, 0, 0, 0, 0.4 } },
			trail = "leftHand", text = "PRUDENCE…", hitText = "TOC TOC !",
		},
		-- Dentier volant : en l'air, elle retire son dentier et le lance, il claque des dents deux fois
		K_air = {
			label = "Dentier volant", kind = "projectile", startup = 0.16, active = 0, recovery = 0.3,
			damage = 5, kbBase = 22, kbGrowth = 40, kbAngle = 35,
			projectile = { speed = 50, angle = 0, gravity = 0, lifetime = 0.45, size = 1.6, hits = 2, color = WHITE,
				visual = { shape = "block", size = 0.8, color = WHITE, parts = {
					{ "block", Vector3.new(0.85, 0.2, 0.55), Vector3.new(0, 0.3, 0), Color3.fromRGB(230, 120, 140) },
					{ "block", Vector3.new(0.85, 0.2, 0.55), Vector3.new(0, -0.3, 0), Color3.fromRGB(230, 120, 140) },
				} } },
			windup = { Root = { -6, -10, 0 }, Waist = { -10, -10, 0 }, Neck = { 0, 10, 0 }, RS = { 140, 0, -35 }, RE = { 130, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 50, 0, 0 }, RH = { 70, 0, 0 }, RK = { -100, 0, 0 }, LH = { 40, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { 6, 10, 0 }, Waist = { -6, 14, 0 }, Neck = { 10, -10, 0 }, RS = { 95, 0, 5 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -45 }, LE = { 40, 0, 0 }, RH = { 40, 0, 0 }, RK = { -70, 0, 0 }, LH = { 60, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { 8, 12, 0 }, Waist = { -4, 16, 0 }, Neck = { 12, -12, 0 }, RS = { 88, 0, 8 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 18, 0, -48 }, LE = { 40, 0, 0 }, RH = { 35, 0, 0 }, RK = { -65, 0, 0 }, LH = { 55, 0, 0 }, LK = { -95, 0, 0 } },
			text = "CLAC CLAC !", hitText = "CROC !",
		},
		-- Glissade en charentaises (dash puis K) : elle glisse sur le parquet ciré, les deux chaussons devant
		K_dash = {
			label = "Glissade en charentaises", startup = 0.1, active = 0.25, recovery = 0.32,
			damage = 11, hitbox = box(6, 2, 3, -1.5), kbBase = 30, kbGrowth = 62, kbAngle = 40, selfVelocity = Vector2.new(48, 0),
			windup = { Root = { -8, 0, 0, 0, -0.5, 0 }, Waist = { -16, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 50, 0, 45 }, RE = { 40, 0, 0 }, LS = { 50, 0, -45 }, LE = { 40, 0, 0 } },
			strike = { Root = { 40, 0, 0, 0, -1.4, 0 }, Waist = { -25, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 130, 0, 55 }, RE = { 20, 0, 0 }, LS = { 130, 0, -55 }, LE = { 20, 0, 0 }, RH = { 80, 0, 0 }, RK = { -5, 0, 0 }, RA = { 15, 0, 0 }, LH = { 72, 0, 0 }, LK = { -15, 0, 0 } },
			follow = { Root = { 44, 0, 3, 0, -1.45, 0 }, Waist = { -28, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 140, 0, 62 }, RE = { 25, 0, 0 }, LS = { 135, 0, -62 }, LE = { 25, 0, 0 }, RH = { 84, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 76, 0, 0 }, LK = { -10, 0, 0 } },
			trail = "bothFeet", fx = { { "particles", tex = "spark", color = WHITE, dir = "up", at = "feet", time = 0.3, speed = 6 } }, text = "OUPSIE !", hitText = "SCHLIIIP !",
		},

		-- Suites d'enchaînement : K K, K K K
		-- K K : Revers de canne, elle ramène la canne de droite à gauche à hauteur des côtes
		K_combo2 = {
			label = "Revers de canne", startup = 0.14, active = 0.1, recovery = 0.26,
			damage = 9, hitbox = box(5.5, 3, 3, 0.3), kbBase = 26, kbGrowth = 45, kbAngle = 30,
			windup = { Root = { -8, -30, 0, 0, -0.2, 0.1 }, Waist = { -16, -32, 0 }, Neck = { 14, 25, 0 }, RS = { 15, 0, 30 }, RE = { 60, 0, 0 }, LS = { 80, 0, 45 }, LE = { 30, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -10, 18, 0, 0, -0.25, -0.2 }, Waist = { -16, 26, 0 }, Neck = { 14, -15, 0 }, RS = { 15, 0, 32 }, RE = { 60, 0, 0 }, LS = { 90, 0, -55 }, LE = { 5, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { -10, 26, 0, 0, -0.25, -0.22 }, Waist = { -16, 36, 0 }, Neck = { 14, -22, 0 }, RS = { 15, 0, 34 }, RE = { 60, 0, 0 }, LS = { 85, 0, -80 }, LE = { 10, 0, 0 }, LW = { -10, 0, 0 } },
			trail = "leftHand", hitText = "VLAN !",
		},
		-- K K K : Coup de golf, la canne part du sol et remonte comme un swing (fait décoller)
		K_combo3 = {
			label = "Coup de golf", startup = 0.18, active = 0.12, recovery = 0.34,
			damage = 12, hitbox = box(5, 4, 2.5, 0.5), kbBase = 34, kbGrowth = 80, kbAngle = 70,
			windup = { Root = { -12, 30, 0, 0, -0.45, 0.15 }, Waist = { -30, 30, 0 }, Neck = { 30, -25, 0 }, RS = { 20, 0, -20 }, RE = { 40, 0, 0 }, LS = { 10, 0, 40 }, LE = { 5, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { 0, -15, 0, 0, -0.2, -0.2 }, Waist = { -6, -20, 0 }, Neck = { 30, 15, 0 }, RS = { 30, 0, 20 }, RE = { 50, 0, 0 }, LS = { 150, 0, -20 }, LE = { 5, 0, 0 }, LW = { 0, 0, 0 } },
			follow = { Root = { 4, -25, 0, 0, -0.15, -0.2 }, Waist = { -2, -30, 0 }, Neck = { 34, 20, 0 }, RS = { 30, 0, 25 }, RE = { 50, 0, 0 }, LS = { 175, 0, -35 }, LE = { 10, 0, 0 }, LW = { -10, 0, 0 } },
			trail = "leftHand", text = "FORE !", hitText = "TCHOC !",
		},
		-- P puis K : Coup de pantoufle au tibia, petit coup sec et sournois
		PK_combo = {
			label = "Pantoufle au tibia", startup = 0.1, active = 0.08, recovery = 0.2,
			damage = 7, hitbox = box(4.5, 2, 2.8, -1.6), kbBase = 22, kbGrowth = 30, kbAngle = 35,
			windup = { Root = { -4, -8, 0, 0, -0.2, 0.1 }, Waist = { -14, -8, 0 }, Neck = { 14, 0, 0 }, RS = { 35, 0, 30 }, RE = { 60, 0, 0 }, LS = { 30, 0, -20 }, LE = { 40, 0, 0 }, RH = { -15, 0, 6 }, RK = { -70, 0, 0 } },
			strike = { Root = { -8, 8, 0, 0, -0.25, -0.2 }, Waist = { -14, 8, 0 }, Neck = { 16, 0, 0 }, RS = { 20, 0, 40 }, RE = { 50, 0, 0 }, LS = { 45, 0, -25 }, LE = { 40, 0, 0 }, RH = { 55, 0, 4 }, RK = { -5, 0, 0 }, RA = { -20, 0, 0 } },
			follow = { Root = { -9, 10, 0, 0, -0.26, -0.22 }, Waist = { -15, 10, 0 }, Neck = { 16, 0, 0 }, RS = { 18, 0, 42 }, RE = { 50, 0, 0 }, LS = { 48, 0, -25 }, LE = { 40, 0, 0 }, RH = { 58, 0, 0 }, RK = { -8, 0, 0 }, RA = { -20, 0, 0 } },
			trail = "rightFoot", hitText = "AÏE MON TIBIA !",
		},
		-- K puis P : Sac retourné, après la canne elle repart dans l'autre sens avec le sac
		KP_combo = {
			label = "Sac retourné", startup = 0.09, active = 0.08, recovery = 0.2,
			damage = 7, hitbox = box(4.5, 3, 2.6, 0.5), kbBase = 22, kbGrowth = 35, kbAngle = 30,
			windup = { Root = { -8, 25, 0, 0, -0.2, -0.2 }, Waist = { -16, 30, 0 }, Neck = { 14, -20, 0 }, RS = { 80, 0, -50 }, RE = { 60, 0, 0 }, LS = { 50, 0, -10 }, LE = { 20, 0, 0 } },
			strike = { Root = { -10, -12, 0, 0, -0.22, -0.3 }, Waist = { -16, -20, 0 }, Neck = { 14, 12, 0 }, RS = { 92, 0, 40 }, RE = { 10, 0, 0 }, LS = { 30, 0, -20 }, LE = { 40, 0, 0 } },
			follow = { Root = { -10, -18, 0, 0, -0.22, -0.32 }, Waist = { -16, -28, 0 }, Neck = { 14, 18, 0 }, RS = { 82, 0, 65 }, RE = { 15, 0, 0 }, LS = { 28, 0, -22 }, LE = { 40, 0, 0 } },
			trail = "prop", hitText = "PIF !",
		},

		------------------------------------------------------------------ En l'air avec une flèche
		-- → P en l'air : Pantoufle jetée, elle arrache sa charentaise et la jette à courte portée
		P_air_side = {
			label = "Pantoufle jetée", kind = "projectile", startup = 0.1, active = 0, recovery = 0.2,
			damage = 7, kbBase = 22, kbGrowth = 38, kbAngle = 25,
			projectile = { speed = 60, angle = -5, gravity = 40, lifetime = 0.35, size = 1.4, color = SLIPPER,
				visual = { shape = "block", size = 0.9, color = SLIPPER, spin = 14, parts = {
					{ "ball", Vector3.new(0.5, 0.4, 0.5), Vector3.new(0.35, 0.3, 0), WHITE },
				} } },
			windup = { Root = { -10, -20, 0 }, Waist = { -12, -20, 0 }, Neck = { 10, 20, 0 }, RS = { 150, 0, 40 }, RE = { 90, 0, 0 }, LS = { 40, 0, -40 }, LE = { 50, 0, 0 }, RH = { 70, 0, 0 }, RK = { -120, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
			strike = { Root = { 6, 15, 0 }, Waist = { -6, 20, 0 }, Neck = { 10, -15, 0 }, RS = { 90, 0, -10 }, RE = { 5, 0, 0 }, LS = { 20, 0, -50 }, LE = { 40, 0, 0 }, RH = { 40, 0, 0 }, RK = { -60, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { 8, 18, 0 }, Waist = { -4, 22, 0 }, Neck = { 12, -18, 0 }, RS = { 75, 0, -20 }, RE = { 10, 0, 0 }, LS = { 18, 0, -52 }, LE = { 40, 0, 0 }, RH = { 35, 0, 0 }, RK = { -55, 0, 0 }, LH = { 45, 0, 0 }, LK = { -85, 0, 0 } },
			text = "ATTRAPE !", hitText = "FLAC !",
		},
		-- ↑ P en l'air : Moulinet de sac, le sac tourne au-dessus de son chignon
		P_air_up = {
			label = "Moulinet de sac", startup = 0.09, active = 0.14, recovery = 0.18,
			damage = 7, hitbox = box(5, 4, 0.5, 3.5), kbBase = 26, kbGrowth = 42, kbAngle = 85,
			windup = { Root = { -12, 0, 0 }, Waist = { -18, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 60, 0, 70 }, RE = { 30, 0, 0 }, LS = { 30, 0, -40 }, LE = { 60, 0, 0 }, RH = { 80, 0, 0 }, RK = { -110, 0, 0 }, LH = { 70, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { 10, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 170, 0, 30 }, RE = { 10, 0, 0 }, LS = { 10, 0, -50 }, LE = { 30, 0, 0 }, RH = { 10, 0, 0 }, RK = { -40, 0, 0 }, LH = { 20, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { 14, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { 36, 0, 0 }, RS = { 175, 0, -25 }, RE = { 10, 0, 0 }, LS = { 5, 0, -52 }, LE = { 30, 0, 0 }, RH = { 5, 0, 0 }, RK = { -35, 0, 0 }, LH = { 15, 0, 0 }, LK = { -55, 0, 0 } },
			trail = "prop", hitText = "WHOUF !",
		},
		-- ↓ P en l'air : Dentier mordant, elle pointe le dentier vers le bas et il croque tout ce qui passe dessous
		P_air_down = {
			label = "Dentier mordant", startup = 0.15, active = 0.12, recovery = 0.3,
			damage = 10, hitbox = box(4, 4, 1, -2), kbBase = 25, kbGrowth = 55, kbAngle = -78,
			windup = { Root = { 16, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 170, 0, 10 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -50 }, LE = { 40, 0, 0 }, RH = { 70, 0, 0 }, RK = { -110, 0, 0 }, LH = { 70, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { -22, 0, 0 }, Waist = { -30, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 40, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -50 }, LE = { 30, 0, 0 }, RH = { 15, 0, 0 }, RK = { -80, 0, 0 }, LH = { 20, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { -26, 0, 0 }, Waist = { -32, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 25, 0, 5 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { -25, 0, -52 }, LE = { 30, 0, 0 }, RH = { 10, 0, 0 }, RK = { -85, 0, 0 }, LH = { 15, 0, 0 }, LK = { -95, 0, 0 } },
			prop = "dentier", hideProp = "sac", text = "CROC CROC !", hitText = "CRONCH !",
		},
		-- → K en l'air : Canne volante, grand balayage horizontal de la canne, jambes en ciseau
		K_air_side = {
			label = "Canne volante", startup = 0.15, active = 0.12, recovery = 0.25,
			damage = 11, hitbox = box(6, 3, 3.2, 0.3), kbBase = 30, kbGrowth = 68, kbAngle = 32,
			windup = { Root = { -6, 30, 0 }, Waist = { -10, 30, 0 }, Neck = { 6, -25, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 }, LS = { 60, 0, -85 }, LE = { 20, 0, 0 }, LW = { 0, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { 20, 0, 0 }, LK = { -60, 0, 0 } },
			strike = { Root = { 4, -20, 0 }, Waist = { -6, -26, 0 }, Neck = { 8, 20, 0 }, RS = { 30, 0, 50 }, RE = { 50, 0, 0 }, LS = { 92, 0, 10 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, RH = { 10, 0, 0 }, RK = { -30, 0, 0 }, LH = { 60, 0, 0 }, LK = { -70, 0, 0 } },
			follow = { Root = { 6, -28, 0 }, Waist = { -6, -34, 0 }, Neck = { 8, 26, 0 }, RS = { 28, 0, 52 }, RE = { 50, 0, 0 }, LS = { 88, 0, 35 }, LE = { 5, 0, 0 }, LW = { -10, 0, 0 }, RH = { 5, 0, 0 }, RK = { -25, 0, 0 }, LH = { 62, 0, 0 }, LK = { -65, 0, 0 } },
			trail = "leftHand", hitText = "SCHLAK !",
		},
		-- ↑ K en l'air : Canne hélice, elle fait tourner la canne au-dessus d'elle comme une hélice
		K_air_up = {
			label = "Canne hélice", startup = 0.14, active = 0.2, recovery = 0.25,
			damage = 10, hitbox = box(5, 4.5, 0.5, 3.5), kbBase = 30, kbGrowth = 65, kbAngle = 86,
			windup = { Root = { -10, 0, 0 }, Waist = { -16, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 }, LS = { 60, 0, -30 }, LE = { 100, 0, 0 }, LW = { 0, 0, 0 }, RH = { 80, 0, 0 }, RK = { -120, 0, 0 }, LH = { 90, 0, 0 }, LK = { -120, 0, 0 } },
			strike = { Root = { 12, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 30, 0, 50 }, RE = { 40, 0, 0 }, LS = { 178, 0, -5 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, RH = { 20, 0, 0 }, RK = { -50, 0, 0 }, LH = { 10, 0, 0 }, LK = { -40, 0, 0 } },
			follow = { Root = { 14, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 28, 0, 55 }, RE = { 40, 0, 0 }, LS = { 180, 0, -2 }, LE = { 0, 0, 0 }, LW = { -10, 0, 0 }, RH = { 15, 0, 0 }, RK = { -45, 0, 0 }, LH = { 5, 0, 0 }, LK = { -35, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "leftHand", hitText = "VROUM VROUM !",
		},
		-- ↓ K en l'air : Charentaises plombées, genoux repliés puis les deux chaussons écrasent le dessous
		K_air_down = {
			label = "Charentaises plombées", startup = 0.18, active = 0.15, recovery = 0.3,
			damage = 12, hitbox = box(4, 3, 0.5, -3), kbBase = 25, kbGrowth = 55, kbAngle = -80, selfVelocity = Vector2.new(0, -55),
			windup = { Root = { -6, 0, 0 }, Waist = { -20, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 70, 0, 50 }, RE = { 40, 0, 0 }, LS = { 70, 0, -50 }, LE = { 40, 0, 0 }, RH = { 100, 0, 0 }, RK = { -130, 0, 0 }, LH = { 100, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 2, 0, 0 }, Waist = { -6, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 140, 0, 50 }, RE = { 20, 0, 0 }, LS = { 140, 0, -50 }, LE = { 20, 0, 0 }, RH = { -4, 0, 5 }, RK = { 0, 0, 0 }, RA = { -10, 0, 0 }, LH = { -4, 0, -5 }, LK = { 0, 0, 0 }, LA = { -10, 0, 0 } },
			follow = { Root = { 2, 0, 0 }, Waist = { -4, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 150, 0, 58 }, RE = { 20, 0, 0 }, LS = { 150, 0, -58 }, LE = { 20, 0, 0 }, RH = { -4, 0, 6 }, RK = { -5, 0, 0 }, RA = { -10, 0, 0 }, LH = { -4, 0, -6 }, LK = { -5, 0, 0 }, LA = { -10, 0, 0 } },
			trail = "bothFeet", text = "POUF POUF !", hitText = "SPLAF !",
		},

		------------------------------------------------------------------ Spéciaux (S)
		-- Lancer de chat : elle attrape Minou sur son épaule et le lance en cloche (anti-air), il griffe 3 fois
		S_neutral = {
			label = "Lancer de chat", kind = "projectile", energyCost = 25, startup = 0.18, active = 0, recovery = 0.35,
			damage = 4, kbBase = 12, kbGrowth = 25, kbAngle = 60,
			projectile = { speed = 48, angle = 55, gravity = 70, lifetime = 1.2, size = 2, hits = 3, color = MINOU, visual = catVisual(MINOU) },
			windup = { Root = { -6, -10, 0, 0, -0.25, 0.15 }, Waist = { -10, -15, 0 }, Neck = { 10, 15, 0 }, RS = { 150, 0, -25 }, RE = { 120, 0, 0 }, LS = { 25, 0, -15 }, LE = { 40, 0, 0 } },
			strike = { Root = { 4, 10, 0, 0, -0.05, -0.15 }, Waist = { 4, 12, 0 }, Neck = { 28, -5, 0 }, RS = { 145, 0, 10 }, RE = { 10, 0, 0 }, LS = { 20, 0, -20 }, LE = { 40, 0, 0 } },
			follow = { Root = { 2, 14, 0, 0, -0.1, -0.2 }, Waist = { 0, 16, 0 }, Neck = { 30, -8, 0 }, RS = { 120, 0, 15 }, RE = { 15, 0, 0 }, LS = { 18, 0, -22 }, LE = { 40, 0, 0 } },
			windupFx = { { "symbols", symbols = { "🐈" }, count = 2, radius = 1.5, color = MINOU } }, text = "VAS-Y MINOU !", hitText = "MIAOU !",
		},
		-- Charge du déambulateur : elle sort son déambulateur et fonce droit devant à petits pas rageurs
		S_side = {
			label = "Charge du déambulateur", energyCost = 25, startup = 0.12, active = 0.4, recovery = 0.35,
			damage = 7, hitbox = box(5, 3.5, 2.8, 0), hits = 2, kbBase = 30, kbGrowth = 60, kbAngle = 30, selfVelocity = Vector2.new(55, 0),
			windup = { Root = { -8, 0, 0, 0, -0.25, 0.1 }, Waist = { -20, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 40, 0, 0 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -5 }, LE = { 40, 0, 0 } },
			strike = { Root = { -18, 0, 0, 0, -0.3, -0.2 }, Waist = { -24, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 60, 0, -5 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 5 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.1, -0.2 } },
			follow = { Root = { -18, 0, 0, 0, -0.3, -0.25 }, Waist = { -24, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 62, 0, -5 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 62, 0, 5 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0.1, -0.25 } },
			wobble = true, prop = "deambulateur", hideProp = "sac", fx = { { "particles", tex = "smoke", color = Color3.fromRGB(220, 210, 190), dir = "up", at = "feet", time = 0.4, speed = 6 } },
			text = "PLACE AUX ANCIENS !", hitText = "CLANG !",
		},
		-- Pose de pelote : elle se penche (aïe les reins) et pose une pelote piégée qui ligote qui marche dessus
		S_down = {
			label = "Pose de pelote", kind = "trap", energyCost = 20, startup = 0.15, active = 0, recovery = 0.3,
			damage = 4, kbBase = 10, kbGrowth = 10, kbAngle = 60, status = { name = "rooted", duration = 1 },
			trap = { size = Vector3.new(3, 2, 6), offset = 3, lifetime = 12, color = WOOL,
				visual = { shape = "ball", size = 1.6, color = WOOL, trail = false, material = "Fabric", parts = {
					{ "cyl", Vector3.new(0.12, 1.65, 1.65), Vector3.new(0, 0, 0), Color3.fromRGB(210, 90, 140), "Fabric" },
					{ "block", Vector3.new(0.1, 2.2, 0.1), Vector3.new(0.3, 0.5, 0), Color3.fromRGB(200, 200, 210), "Metal" },
					{ "block", Vector3.new(0.1, 2.2, 0.1), Vector3.new(-0.3, 0.5, 0), Color3.fromRGB(200, 200, 210), "Metal" },
				} } },
			windup = { Root = { -10, 0, 0, 0, -0.35, 0.1 }, Waist = { -30, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 40, 0, 10 }, RE = { 60, 0, 0 }, LS = { 30, 0, -20 }, LE = { 30, 0, 0 } },
			strike = { Root = { -16, 0, 0, 0, -0.6, -0.1 }, Waist = { -45, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 65, 0, 5 }, RE = { 10, 0, 0 }, LS = { 30, 0, -20 }, LE = { 20, 0, 0 } },
			follow = { Root = { -6, 0, 0, 0, -0.3, 0.05 }, Waist = { -10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { -30, 0, 20 }, RE = { 90, 0, 0 }, LS = { -30, 0, -20 }, LE = { 90, 0, 0 } },
			text = "ATTENTION OÙ TU MARCHES…", hitText = "LIGOTÉ !",
		},
		-- Pelote semée (après une esquive) : elle laisse tomber une pelote derrière elle en filant
		S_dodge = {
			label = "Pelote semée", kind = "trap", energyCost = 20, startup = 0.1, active = 0, recovery = 0.25,
			damage = 4, kbBase = 10, kbGrowth = 10, kbAngle = 60, status = { name = "rooted", duration = 1 },
			trap = { size = Vector3.new(3, 2, 6), offset = -1.5, lifetime = 10, color = WOOL2,
				visual = { shape = "ball", size = 1.5, color = WOOL2, trail = false, material = "Fabric", parts = {
					{ "cyl", Vector3.new(0.12, 1.55, 1.55), Vector3.new(0, 0, 0), Color3.fromRGB(80, 160, 200), "Fabric" },
					{ "block", Vector3.new(0.1, 2, 0.1), Vector3.new(0.2, 0.5, 0), Color3.fromRGB(200, 200, 210), "Metal" },
				} } },
			windup = { Root = { -4, -20, 0, 0, -0.2, 0 }, Waist = { -14, -20, 0 }, Neck = { 10, 35, 0 }, RS = { 20, 0, 30 }, RE = { 60, 0, 0 }, LS = { 30, 0, -20 }, LE = { 40, 0, 0 } },
			strike = { Root = { -8, -30, 0, 0, -0.3, 0.2 }, Waist = { -16, -30, 0 }, Neck = { 10, 60, 0 }, RS = { -40, 0, 25 }, RE = { 20, 0, 0 }, LS = { 30, 0, -20 }, LE = { 40, 0, 0 } },
			follow = { Root = { -6, -20, 0, 0, -0.25, 0.25 }, Waist = { -14, -20, 0 }, Neck = { 10, 50, 0 }, RS = { -30, 0, 25 }, RE = { 30, 0, 0 }, LS = { 30, 0, -20 }, LE = { 40, 0, 0 } },
			text = "OUPS, J'AI FAIT TOMBER…", hitText = "LIGOTÉ !",
		},
		-- Envol de châle : elle ouvre son châle comme un parachute et s'envole en diagonale haute
		-- (gratuit : c'est la remontée)
		S_up = {
			label = "Envol de châle", energyCost = 0, startup = 0.06, active = 0.35, recovery = 0.3,
			damage = 6, hitbox = box(5, 5, 0.5, 2), kbBase = 26, kbGrowth = 35, kbAngle = 75, selfVelocity = Vector2.new(25, 80),
			windup = { Root = { -10, 0, 0, 0, -0.6, 0 }, Waist = { -24, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 60, 0, -20 }, RE = { 100, 0, 0 }, LS = { 60, 0, 20 }, LE = { 100, 0, 0 } },
			strike = { Root = { 6, 0, 0, 0, 0.3, 0 }, Waist = { 8, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 160, 0, 55 }, RE = { 10, 0, 0 }, LS = { 160, 0, -55 }, LE = { 10, 0, 0 }, RH = { 10, 0, 0 }, RK = { -30, 0, 0 }, LH = { 20, 0, 0 }, LK = { -50, 0, 0 } },
			follow = { Root = { 8, 0, 0, 0, 0.3, 0 }, Waist = { 10, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 165, 0, 70 }, RE = { 10, 0, 0 }, LS = { 165, 0, -70 }, LE = { 10, 0, 0 }, RH = { 5, 0, 0 }, RK = { -40, 0, 0 }, LH = { 25, 0, 0 }, LK = { -60, 0, 0 } },
			fx = { { "particles", tex = "smoke", color = SHAWL, dir = "down", at = "root", time = 0.4, speed = 8 } }, text = "HOP LÀ !", hitText = "FLOUF !",
		},
		-- Tricot express (S maintenu) : elle tricote à toute vitesse un pull-bouclier qui avale le prochain projectile
		S_hold = {
			label = "Tricot express", kind = "wall", energyCost = 30, startup = 0.3, active = 0.1, recovery = 0.3,
			hitbox = box(5, 4, 2.5, 0.5), kbBase = 30, kbGrowth = 45, kbAngle = 30,
			damage = 7,
			wall = { size = Vector3.new(2.5, 5, 6), offset = 2.2, lifetime = 4, max = 1, follow = true, absorbs = true, solid = false, color = WOOL,
				visual = { shape = "block", size = 2.4, color = WOOL, trail = false, material = "Fabric", parts = {
					{ "block", Vector3.new(0.8, 2.2, 1.2), Vector3.new(0, 0.2, 1.5), WOOL, "Fabric" },
					{ "block", Vector3.new(0.8, 2.2, 1.2), Vector3.new(0, 0.2, -1.5), WOOL, "Fabric" },
					{ "block", Vector3.new(2.5, 0.3, 1.5), Vector3.new(0, 0.3, 0), WHITE, "Fabric" },
				} } },
			windup = { Root = { -6, 0, 0, 0, -0.2, 0 }, Waist = { -16, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 45, 0, -20 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 45, 0, 20 }, LE = { 100, 0, 0 } },
			strike = { Root = { -6, 0, 0, 0, -0.2, -0.1 }, Waist = { -14, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 80, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -20 }, LE = { 30, 0, 0 } },
			follow = { Root = { -6, 0, 0, 0, -0.2, -0.1 }, Waist = { -14, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 82, 0, 25 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 82, 0, -25 }, LE = { 30, 0, 0 } },
			shake = true, prop = "aiguille", hideProp = "sac",
			windupFx = { { "particles", tex = "spark", color = WOOL, dir = "all", at = "hand", time = 0.3, speed = 4 } },
			text = "TRICOT EXPRESS !", hitText = "TOUT DOUX !",
		},
		-- Chat boomerang (→→S) : elle lance Pompon à l'horizontale, il griffe 3 fois et revient sur son épaule
		S_dash = {
			label = "Chat boomerang", kind = "projectile", energyCost = 25, startup = 0.14, active = 0, recovery = 0.3,
			damage = 4, kbBase = 14, kbGrowth = 25, kbAngle = 25,
			projectile = { speed = 55, angle = 0, gravity = 0, lifetime = 0.9, size = 2, hits = 3, returns = true, color = POMPON, visual = catVisual(POMPON) },
			windup = { Root = { -4, -30, 0, 0, -0.2, 0.2 }, Waist = { -12, -35, 0 }, Neck = { 10, 30, 0 }, RS = { 80, 0, 60 }, RE = { 70, 0, 0 }, LS = { 30, 0, -20 }, LE = { 40, 0, 0 } },
			strike = { Root = { -10, 20, 0, 0, -0.25, -0.3 }, Waist = { -14, 26, 0 }, Neck = { 12, -18, 0 }, RS = { 92, 0, -10 }, RE = { 5, 0, 0 }, LS = { 20, 0, -25 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
			follow = { Root = { -10, 26, 0, 0, -0.25, -0.35 }, Waist = { -14, 32, 0 }, Neck = { 12, -22, 0 }, RS = { 85, 0, -30 }, RE = { 10, 0, 0 }, LS = { 18, 0, -26 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
			text = "À TOI POMPON !", hitText = "FFFSHHH !",
		},
		-- Bonbons en rafale (S en l'air) : elle vide son paquet de bonbons à la menthe en diagonale vers le bas
		S_air = {
			label = "Bonbons en rafale", kind = "projectile", energyCost = 20, startup = 0.12, active = 0, recovery = 0.3,
			damage = 4, kbBase = 16, kbGrowth = 25, kbAngle = -20,
			projectile = { speed = 60, angle = -35, gravity = 20, lifetime = 0.6, size = 1, color = MINT, fan = { count = 4, from = -55, to = -20 },
				visual = { shape = "ball", size = 0.8, color = MINT, spin = 10, parts = { { "block", Vector3.new(0.9, 0.12, 0.12), Vector3.new(0, 0, 0), WHITE } } } },
			windup = { Root = { -6, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 130, 0, 20 }, RE = { 60, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
			strike = { Root = { -16, 0, 0 }, Waist = { -18, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 50, 0, 5 }, RE = { 0, 0, 0 }, LS = { 70, 0, -50 }, LE = { 40, 0, 0 }, RH = { 30, 0, 0 }, RK = { -60, 0, 0 }, LH = { 25, 0, 0 }, LK = { -70, 0, 0 } },
			follow = { Root = { -14, 0, 0 }, Waist = { -16, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 45, 0, 10 }, RE = { 5, 0, 0 }, LS = { 72, 0, -52 }, LE = { 40, 0, 0 }, RH = { 25, 0, 0 }, RK = { -55, 0, 0 }, LH = { 20, 0, 0 }, LK = { -65, 0, 0 } },
			text = "UN BONBON ?", hitText = "TIC !",
		},
		-- Pluie de bonbons (↓S en l'air, plongeon) : elle plonge en diagonale en semant des bonbons durs
		S_air_down = {
			label = "Pluie de bonbons", energyCost = 25, startup = 0.12, active = 0.35, recovery = 0.3,
			damage = 11, hitbox = box(5, 4, 1.5, -1.5), kbBase = 25, kbGrowth = 55, kbAngle = -50, selfVelocity = Vector2.new(30, -75),
			windup = { Root = { 12, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 160, 0, 30 }, RE = { 40, 0, 0 }, LS = { 160, 0, -30 }, LE = { 40, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { -45, 0, 0 }, Waist = { -14, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 130, 0, 60 }, RE = { 10, 0, 0 }, LS = { 130, 0, -60 }, LE = { 10, 0, 0 }, RH = { 10, 0, 0 }, RK = { -40, 0, 0 }, LH = { 5, 0, 0 }, LK = { -50, 0, 0 } },
			follow = { Root = { -50, 0, 0 }, Waist = { -16, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 135, 0, 65 }, RE = { 10, 0, 0 }, LS = { 135, 0, -65 }, LE = { 10, 0, 0 }, RH = { 5, 0, 0 }, RK = { -45, 0, 0 }, LH = { 0, 0, 0 }, LK = { -55, 0, 0 } },
			trail = "body", fx = { { "toss", shape = "ball", color = MINT, size = 0.6, count = 6, speed = 18 }, { "ring", color = MINT, radius = 4, at = "feet" } },
			text = "À LA MENTHE !", hitText = "CRAC !",
		},
		-- Écharpe-fouet (finition d'enchaînement) : elle déroule son écharpe et fouette au ras du sol, très loin
		S_finish_echarpe = {
			label = "Écharpe-fouet", energyCost = 20, startup = 0.14, active = 0.12, recovery = 0.32,
			damage = 10, hitbox = box(9, 2.2, 5.5, -1), kbBase = 30, kbGrowth = 55, kbAngle = 30,
			windup = { Root = { -6, -30, 0, 0, -0.3, 0.2 }, Waist = { -16, -30, 0 }, Neck = { 12, 25, 0 }, RS = { 120, 0, 70 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 40, 0, 0 } },
			strike = { Root = { -14, 20, 0, 0, -0.45, -0.3 }, Waist = { -24, 24, 0 }, Neck = { 22, -15, 0 }, RS = { 70, 0, -5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 40, 0, 0 } },
			follow = { Root = { -16, 26, 0, 0, -0.5, -0.35 }, Waist = { -26, 30, 0 }, Neck = { 24, -18, 0 }, RS = { 55, 0, -25 }, RE = { 0, 0, 0 }, RW = { -15, 0, 0 }, LS = { 18, 0, -32 }, LE = { 40, 0, 0 } },
			prop = "echarpe", hideProp = "sac", trail = "rightHand", text = "COUVRE-TOI !", hitText = "FOUETTÉ !",
		},

		------------------------------------------------------------------ Supers
		-- Armée de chats : elle siffle entre ses doigts et six chats de quartier chargent à travers l'arène
		SUPER = {
			label = "Armée de chats !", kind = "projectile", superCost = 100, startup = 0.35, active = 0, recovery = 0.5,
			damage = 5, kbBase = 25, kbGrowth = 45, kbAngle = 35,
			projectile = { speed = 55, angle = 0, gravity = 0, lifetime = 1.2, size = 2, pierce = true, from = "feet", color = MINOU,
				fan = { count = 6, from = -4, to = 8, gap = 0.12 }, visual = catVisual(MINOU) },
			windup = { Root = { -4, 0, 0, 0, -0.15, 0.1 }, Waist = { -8, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 20, 0, 25 }, RE = { 50, 0, 0 }, LS = { 120, 0, 35 }, LE = { 140, 0, 0 } },
			strike = { Root = { -10, 10, 0, 0, -0.25, -0.2 }, Waist = { -14, 12, 0 }, Neck = { 16, -8, 0 }, RS = { 95, 0, -5 }, RE = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 40, 0, 0 } },
			follow = { Root = { -10, 12, 0, 0, -0.25, -0.22 }, Waist = { -14, 14, 0 }, Neck = { 18, -10, 0 }, RS = { 100, 0, -8 }, RE = { 0, 0, 0 }, LS = { 30, 0, -22 }, LE = { 40, 0, 0 } },
			hold = 0.2, windupFx = { { "screen", color = MINOU, alpha = 0.25 }, { "symbols", symbols = { "🐈", "🐾" }, count = 6, radius = 3, color = MINOU } },
			fx = { { "shake", amount = 0.4 } }, text = "MES CHÉRIS, À L'ATTAQUE !", hitText = "MIAAAOU !",
		},
		-- Super ↑ : elle lève sac et canne : une colonne de pelotes de laine jaillit et emporte tout
		SUPER_up = {
			label = "Envolée de pelotes !", superCost = 100, startup = 0.4, active = 0.3, recovery = 0.6,
			damage = 22, hitbox = box(8, 14, 4, 6), kbBase = 45, kbGrowth = 95, kbAngle = 86, invuln = 0.3,
			windup = { Root = { -12, 12, 0, 0, -0.35, 0 }, Waist = { -28.8, 12, 0 }, Neck = { 36, 0, 0 }, RS = { 24, 0, 36 }, RE = { 72, 0, 0 }, LS = { 48, 0, -18 }, LE = { 132, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { 9.6, -6, 0, 0, -0.1, 0.4 }, Waist = { 7.2, -6, 0 }, Neck = { 45.6, 0, 0 }, RS = { -24, 0, 42 }, RE = { 48, 0, 0 }, LS = { 210, 0, -6 }, LE = { 0, 0, 0 }, LW = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0.3 }, FL = { 0, 0, 0, 0, 0, 0.35 } },
			follow = { Root = { 12, -6, 0, 0, -0.1, 0.45 }, Waist = { 9.6, -6, 0 }, Neck = { 48, 0, 0 }, RS = { -30, 0, 45.6 }, RE = { 48, 0, 0 }, LS = { 216, 0, -2.4 }, LE = { 0, 0, 0 }, LW = { -12, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0.35 }, FL = { 0, 0, 0, 0, 0, 0.4 } },
			hold = 0.45, shake = true,
			windupFx = { "super" }, trail = "prop", status = { name = "rooted", duration = 1 }, fx = { { "pillar", color = Color3.fromRGB(230, 120, 170), height = 20, width = 4, at = "front" }, { "toss", shape = "ball", color = Color3.fromRGB(160, 90, 200), count = 6, speed = 10, lift = 40 } }, text = "DE MON TEMPS !", hitText = "EMBOBINÉ !",
		},
		-- « De mon temps… » : elle raconte sa jeunesse en agitant le doigt, tout le monde s'endort
		SUPER_down = {
			label = "« De mon temps… »", superCost = 100, startup = 0.5, active = 0.2, recovery = 0.5,
			damage = 6, hitbox = box(60, 40, 0, 8), kbBase = 8, kbGrowth = 8, kbAngle = 60,
			status = { name = "asleep", duration = 2.5 },
			windup = { Root = { -4, 0, 0, 0, -0.15, 0 }, Waist = { -10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 120, 0, -10 }, RE = { 120, 0, 0 }, LS = { 20, 0, -12 }, LE = { 40, 0, 0 } },
			strike = { Root = { -4, 6, 0, 0, -0.15, 0 }, Waist = { -10, 8, 0 }, Neck = { 26, -8, 6 }, RS = { 140, 0, 10 }, RE = { 70, 0, 0 }, RW = { 0, 0, 20 }, LS = { 20, 0, -12 }, LE = { 40, 0, 0 } },
			follow = { Root = { -4, -6, 0, 0, -0.15, 0 }, Waist = { -10, -8, 0 }, Neck = { 26, 8, -6 }, RS = { 140, 0, 10 }, RE = { 70, 0, 0 }, RW = { 0, 0, -20 }, LS = { 20, 0, -12 }, LE = { 40, 0, 0 } },
			hold = 0.6, windupFx = { { "screen", color = Color3.fromRGB(230, 200, 150), alpha = 0.3 } },
			fx = { { "symbols", symbols = { "Z", "z", "💤", "BLA BLA" }, count = 10, radius = 7, color = Color3.fromRGB(170, 200, 255) } },
			text = "DE MON TEMPS, MON PETIT…", hitText = "ZZZ…",
		},

		------------------------------------------------------------------ Saisie (bouton ✋) et projections
		-- Prise au sac à main : elle passe l'anse du sac autour du cou de l'adversaire et tire
		GRAB = {
			label = "Prise au sac à main", kind = "grab", startup = 0.1, active = 0.12, recovery = 0.35,
			damage = 0, hitbox = box(4, 4, 2, 0.5),
			windup = { Root = { -4, -15, 0, 0, -0.15, 0.1 }, Waist = { -12, -15, 0 }, Neck = { 14, 10, 0 }, RS = { 130, 0, 30 }, RE = { 40, 0, 0 }, LS = { 25, 0, -15 }, LE = { 40, 0, 0 } },
			strike = { Root = { -10, 8, 0, 0, -0.2, -0.3 }, Waist = { -16, 10, 0 }, Neck = { 16, -5, 0 }, RS = { 90, 0, -20 }, RE = { 60, 0, 0 }, LS = { 25, 0, -15 }, LE = { 40, 0, 0 } },
			follow = { Root = { -6, 8, 0, 0, -0.2, -0.2 }, Waist = { -14, 10, 0 }, Neck = { 16, -5, 0 }, RS = { 80, 0, -25 }, RE = { 90, 0, 0 }, LS = { 25, 0, -15 }, LE = { 40, 0, 0 } },
			text = "VIENS LÀ, TOI !", hitText = "ATTRAPÉ !",
		},
		-- ✋ puis → : Coup de cabas, elle fait tourner la victime au bout de l'anse et la lâche d'un coup de sac
		THROW_fwd = {
			label = "Coup de cabas", kind = "throw", startup = 0.34, active = 0.08, recovery = 0.3,
			damage = 9, kbBase = 40, kbGrowth = 55, kbAngle = 20,
			carry = { { 0, 2.4, 0.6 }, { 0.12, 0.5, 1.2 }, { 0.24, -1.5, 0.8 }, { 0.34, 3.5, 0.2 } },
			windup = { Root = { -6, -40, 0, 0, -0.25, 0.2 }, Waist = { -14, -40, 0 }, Neck = { 12, 30, 0 }, RS = { 80, 0, 70 }, RE = { 30, 0, 0 }, LS = { 25, 0, -15 }, LE = { 40, 0, 0 } },
			strike = { Root = { -12, 25, 0, 0, -0.3, -0.35 }, Waist = { -18, 30, 0 }, Neck = { 16, -20, 0 }, RS = { 95, 0, -20 }, RE = { 10, 0, 0 }, LS = { 15, 0, -20 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -14, 32, 0, 0, -0.3, -0.4 }, Waist = { -20, 38, 0 }, Neck = { 18, -26, 0 }, RS = { 88, 0, -40 }, RE = { 15, 0, 0 }, LS = { 12, 0, -22 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			trail = "prop", text = "ET HOP, AU MARCHÉ !", hitText = "VLAN !",
		},
		-- ✋ puis ← : Retour à l'envoyeur, elle fait passer la victime par-dessus son épaule voûtée
		THROW_back = {
			label = "Retour à l'envoyeur", kind = "throw", back = true, startup = 0.4, active = 0.1, recovery = 0.4,
			damage = 11, kbBase = 35, kbGrowth = 68, kbAngle = 45,
			carry = { { 0, 2.4, 0.6 }, { 0.14, 1.2, 1.4 }, { 0.28, -0.5, 3.0 }, { 0.4, -2.8, 0.6 } },
			windup = { Root = { -10, 0, 0, 0, -0.45, 0.1 }, Waist = { -24, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 70, 0, -10 }, RE = { 80, 0, 0 }, LS = { 70, 0, 10 }, LE = { 80, 0, 0 } },
			strike = { Root = { 20, 0, 0, 0, -0.35, 0.3 }, Waist = { 20, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 190, 0, -10 }, RE = { 30, 0, 0 }, LS = { 190, 0, 10 }, LE = { 30, 0, 0 } },
			follow = { Root = { 24, 0, 0, 0, -0.35, 0.35 }, Waist = { 24, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 195, 0, -8 }, RE = { 35, 0, 0 }, LS = { 195, 0, 8 }, LE = { 35, 0, 0 } },
			text = "RETOUR À L'ENVOYEUR !", hitText = "AÏE MES REINS !",
		},
		-- ✋ puis ↑ : Chat lancé, Minou et Pompon sautent sous la victime et l'expédient vers le ciel
		THROW_up = {
			label = "Chat lancé", kind = "throw", startup = 0.3, active = 0.08, recovery = 0.35,
			damage = 9, kbBase = 38, kbGrowth = 60, kbAngle = 88,
			carry = { { 0, 2.4, 0.6 }, { 0.15, 2.2, 0 }, { 0.3, 1.5, 3.5 } },
			windup = { Root = { -8, 0, 0, 0, -0.35, 0.05 }, Waist = { -20, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 45, 0, -10 }, RE = { 50, 0, 0 }, LS = { 45, 0, 10 }, LE = { 50, 0, 0 } },
			strike = { Root = { 4, 0, 0, 0, 0.1, -0.1 }, Waist = { 8, 0, 0 }, Neck = { 36, 0, 0 }, RS = { 165, 0, 20 }, RE = { 10, 0, 0 }, LS = { 165, 0, -20 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.15, 0 }, FL = { 0, 0, 0, 0, 0.15, 0 } },
			follow = { Root = { 6, 0, 0, 0, 0.15, -0.1 }, Waist = { 10, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 170, 0, 30 }, RE = { 10, 0, 0 }, LS = { 170, 0, -30 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			fx = { { "symbols", symbols = { "🐈", "🐾" }, count = 4, radius = 2, at = "front", color = MINOU } }, text = "LES CHATS, HOP !", hitText = "MIAOU-BOING !",
		},
		-- ✋ puis ↓ : Assis sur le tabouret, elle plaque la victime, s'assoit dessus en tricotant… et lui fait un bisou baveux
		THROW_down = {
			label = "Assis sur le tabouret", kind = "throw", startup = 0.42, active = 0.1, hold = 0.3, recovery = 0.35,
			damage = 10, kbBase = 30, kbGrowth = 25, kbAngle = 75, status = { name = "stunned", duration = 0.8 },
			carry = { { 0, 2.4, 0.6 }, { 0.16, 2.0, 1.4 }, { 0.3, 1.4, -2.0 }, { 0.42, 0.9, -2.4 } },
			windup = { Root = { 6, 0, 0, 0, 0, 0.1 }, Waist = { 4, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 150, 0, -10 }, RE = { 40, 0, 0 }, LS = { 150, 0, 10 }, LE = { 40, 0, 0 } },
			strike = { Root = { 2, 0, 0, 0, -1.1, -0.5 }, Waist = { -8, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 50, 0, -15 }, RE = { 100, 0, 0 }, LS = { 50, 0, 15 }, LE = { 100, 0, 0 }, FR = { 0, 0, 0, 0, 0, -0.6 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { 0, 0, 0, 0, -1.1, -0.5 }, Waist = { -20, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 45, 0, -20 }, RE = { 110, 0, 0 }, LS = { 45, 0, 20 }, LE = { 110, 0, 0 }, FR = { 0, 0, 0, 0, 0, -0.6 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			prop = "aiguille", fx = { { "symbols", symbols = { "💋", "♥" }, count = 4, radius = 2, at = "front", color = Color3.fromRGB(255, 90, 140) } },
			text = "BISOU BAVEUX !", hitText = "BEUUURK !",
		},
	},

	-- Séquences relatives à l'adversaire : forward = vers lui, back = à l'opposé
	fatals = {
		{
			id = "pull_de_noel", label = "Le Pull de Noël", sequence = { "down", "forward", "down" },
			-- tricoté dans un pull géant et moche, seule la tête dépasse, photo de famille forcée
			scene = {
				{ "text", "UN PETIT PULL, MON CHÉRI ?" },
				{ "fxAttacker", { "particles", tex = "spark", color = WOOL, dir = "all", at = "hand", time = 1, speed = 6 } },
				{ "wait", 0.6 },
				{ "spawn", at = "target", offset = Vector3.new(0, -0.4, 0), life = 4, pieces = {
					{ "Pull", "", "block", Vector3.new(3.4, 3.6, 2), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), Color3.fromRGB(200, 30, 40), "Fabric" },
					{ "MancheD", "", "block", Vector3.new(1, 3, 1.2), Vector3.new(2, 0, 0), Vector3.new(0, 0, 0), Color3.fromRGB(30, 140, 60), "Fabric" },
					{ "MancheG", "", "block", Vector3.new(1, 3, 1.2), Vector3.new(-2, 0, 0), Vector3.new(0, 0, 0), Color3.fromRGB(30, 140, 60), "Fabric" },
					{ "Col", "", "cyl", Vector3.new(0.5, 1.6, 1.6), Vector3.new(0, 1.9, 0), Vector3.new(0, 0, 0), WHITE, "Fabric" },
					{ "Renne", "", "ball", Vector3.new(1.4, 1.2, 0.2), Vector3.new(0, 0.2, -1.05), Vector3.new(0, 0, 0), Color3.fromRGB(150, 90, 40), "Fabric" },
					{ "NezRouge", "", "ball", Vector3.new(0.45, 0.45, 0.3), Vector3.new(0.5, 0, -1.15), Vector3.new(0, 0, 0), Color3.fromRGB(255, 30, 30), "Neon" },
				} },
				{ "fx", { "symbols", symbols = { "❄️", "🎄", "⭐" }, count = 8, radius = 4 } },
				{ "wait", 0.8 },
				{ "fxAttacker", { "text", text = "SOURIEZ !", color = Color3.fromRGB(255, 230, 120) } },
				{ "wait", 0.4 },
				{ "fx", { "screen", color = WHITE, alpha = 0.7 } },
				{ "text", "CLIC ! (PHOTO DE FAMILLE)" },
				{ "wait", 1.2 },
			},
		},
		{
			id = "finis_ta_soupe", label = "Finis ta soupe", sequence = { "back", "back", "forward" },
			-- l'adversaire rétrécit et finit dans un bol de soupe fumant
			scene = {
				{ "fxAttacker", { "text", text = "TU N'AS PAS FINI TA SOUPE !", color = Color3.fromRGB(255, 200, 120) } },
				{ "wait", 0.6 },
				{ "shrink", 0.25, time = 0.8 },
				{ "spawn", at = "target", offset = Vector3.new(0, -2.4, 0), life = 4, pieces = {
					{ "Bol", "", "cyl", Vector3.new(1.4, 4.4, 4.4), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), WHITE, "SmoothPlastic", { axis = "y" } },
					{ "Liseré", "", "cyl", Vector3.new(0.2, 4.5, 4.5), Vector3.new(0, 0.55, 0), Vector3.new(0, 0, 0), Color3.fromRGB(60, 110, 200), "SmoothPlastic", { axis = "y" } },
					{ "Soupe", "", "cyl", Vector3.new(0.1, 4, 4), Vector3.new(0, 0.65, 0), Vector3.new(0, 0, 0), Color3.fromRGB(230, 150, 50), "SmoothPlastic", { axis = "y" } },
					{ "Cuillere", "", "block", Vector3.new(0.3, 3.5, 0.15), Vector3.new(1.5, 1.6, 0), Vector3.new(0, 0, -25), Color3.fromRGB(200, 200, 210), "Metal" },
				} },
				{ "move", to = "between", offset = Vector3.new(0, -1.2, 0), time = 0.3 },
				{ "fx", { "particles", tex = "smoke", color = WHITE, dir = "up", at = "root", time = 1.5, speed = 4 } },
				{ "text", "SLUURP…" },
				{ "wait", 1 },
				{ "fxAttacker", { "text", text = "C'EST BON POUR CE QUE T'AS !", color = Color3.fromRGB(255, 230, 120) } },
				{ "hide" },
				{ "wait", 1 },
			},
		},
		{
			id = "la_pelote", label = "La Pelote", sequence = { "up", "down", "up" },
			-- roulé en pelote, les chats se le renvoient jusqu'à ce qu'il roule hors de l'écran
			scene = {
				{ "text", "EN PELOTE !" },
				{ "spin", 720, axis = "z", time = 0.6 },
				{ "color", WOOL },
				{ "material", "Fabric" },
				{ "spawn", at = "target", offset = Vector3.new(0, 0, 0), life = 3.5, name = "Pelote", pieces = {
					{ "Pelote", "", "ball", Vector3.new(4.5, 4.5, 4.5), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), WOOL, "Fabric", { transparency = 0.15 } },
					{ "Brin", "", "cyl", Vector3.new(0.15, 4.6, 4.6), Vector3.new(0, 0, 0), Vector3.new(0, 30, 0), Color3.fromRGB(210, 90, 140), "Fabric" },
				} },
				{ "fxAttacker", { "symbols", symbols = { "🐈", "🐾" }, count = 6, radius = 3, color = MINOU } },
				{ "move", to = "attacker", offset = Vector3.new(0, 0, 0), time = 0.4 },
				{ "text", "PATOUNE !" },
				{ "move", to = "between", offset = Vector3.new(0, 1, 0), time = 0.4 },
				{ "text", "PATOUNE !" },
				{ "launch", Vector3.new(60, 4, 0), time = 1.2 },
				{ "wait", 0.4 },
			},
		},
	},

	-- Mécanique : pelotes-pièges posées au sol (S_down, S_dodge), 3 au maximum (la plus vieille disparaît)
	passive = { kind = "traps", name = "Pelotes", icon = "🧶", max = 3 },

	-- Recharge ⚡ : assise dans un rocking-chair invisible (le moteur ne fait pas apparaître d'objet pendant la
	-- recharge), elle se balance et tricote à toute vitesse pendant que les chats ronronnent
	charge = {
		label = "Tricot du soir",
		loop = 1.6,
		lockWrist = false,
		color = WOOL,
		keys = {
			{ 0.0, { Root = { 6, 0, 0, 0, -1.05, 0.15 }, Waist = { -14, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 40, 0, -15 }, RE = { 105, 0, 0 }, LS = { 40, 0, 15 }, LE = { 95, 0, 0 }, RH = { 85, 0, 4 }, RK = { -85, 0, 0 }, LH = { 85, 0, -4 }, LK = { -85, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, 0 } } },
			{ 0.2, { Root = { 2, 0, 0, 0, -1.05, 0.15 }, Waist = { -14, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 42, 0, -15 }, RE = { 90, 0, 0 }, LS = { 38, 0, 15 }, LE = { 110, 0, 0 }, RH = { 88, 0, 4 }, RK = { -80, 0, 0 }, LH = { 88, 0, -4 }, LK = { -80, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, 0 } } },
			{ 0.4, { Root = { -4, 0, 0, 0, -1.05, 0.15 }, Waist = { -14, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 40, 0, -15 }, RE = { 105, 0, 0 }, LS = { 40, 0, 15 }, LE = { 95, 0, 0 }, RH = { 92, 0, 4 }, RK = { -76, 0, 0 }, LH = { 92, 0, -4 }, LK = { -76, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, 0 } } },
			{ 0.6, { Root = { -8, 0, 0, 0, -1.05, 0.15 }, Waist = { -14, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 42, 0, -15 }, RE = { 90, 0, 0 }, LS = { 38, 0, 15 }, LE = { 110, 0, 0 }, RH = { 95, 0, 4 }, RK = { -72, 0, 0 }, LH = { 95, 0, -4 }, LK = { -72, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, 0 } } },
			{ 0.8, { Root = { -4, 0, 0, 0, -1.05, 0.15 }, Waist = { -14, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 40, 0, -15 }, RE = { 105, 0, 0 }, LS = { 40, 0, 15 }, LE = { 95, 0, 0 }, RH = { 92, 0, 4 }, RK = { -76, 0, 0 }, LH = { 92, 0, -4 }, LK = { -76, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, 0 } } },
			{ 1.0, { Root = { 2, 0, 0, 0, -1.05, 0.15 }, Waist = { -14, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 42, 0, -15 }, RE = { 90, 0, 0 }, LS = { 38, 0, 15 }, LE = { 110, 0, 0 }, RH = { 88, 0, 4 }, RK = { -80, 0, 0 }, LH = { 88, 0, -4 }, LK = { -80, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, 0 } } },
			{ 1.2, { Root = { 6, 0, 0, 0, -1.05, 0.15 }, Waist = { -14, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 40, 0, -15 }, RE = { 105, 0, 0 }, LS = { 40, 0, 15 }, LE = { 95, 0, 0 }, RH = { 85, 0, 4 }, RK = { -85, 0, 0 }, LH = { 85, 0, -4 }, LK = { -85, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, 0 } } },
			{ 1.4, { Root = { 9, 0, 0, 0, -1.05, 0.15 }, Waist = { -14, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 42, 0, -15 }, RE = { 90, 0, 0 }, LS = { 38, 0, 15 }, LE = { 110, 0, 0 }, RH = { 82, 0, 4 }, RK = { -88, 0, 0 }, LH = { 82, 0, -4 }, LK = { -88, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, 0 } } },
			{ 1.6, { Root = { 6, 0, 0, 0, -1.05, 0.15 }, Waist = { -14, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 40, 0, -15 }, RE = { 105, 0, 0 }, LS = { 40, 0, 15 }, LE = { 95, 0, 0 }, RH = { 85, 0, 4 }, RK = { -85, 0, 0 }, LH = { 85, 0, -4 }, LK = { -85, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, 0 } } },
		},
		beats = {
			{ 0.1, { "particles", tex = "spark", color = WOOL, dir = "all", at = "hand", time = 0.5, speed = 3, size = 0.4 } },
			{ 0.7, { "symbols", symbols = { "🧶" }, count = 2, radius = 1.5, at = "front", color = WOOL } },
			{ 1.2, { "symbols", symbols = { "RRRON", "♥" }, count = 2, radius = 2.5, color = MINOU } },
		},
	},

	-- Manies au repos : elle remonte ses lunettes, fouille dans son sac, se masse les reins
	fidgets = {
		{ duration = 1.6, keys = {
			{ 0, {} },
			{ 0.35, { Neck = { 20, 0, 0 }, RS = { 125, 0, -35 }, RE = { 140, 0, 0 } } },
			{ 0.6, { Neck = { 26, 0, 0 }, RS = { 130, 0, -38 }, RE = { 145, 0, 0 } } },
			{ 1.0, { Neck = { 22, 0, 0 }, RS = { 125, 0, -35 }, RE = { 140, 0, 0 } } },
			{ 1.6, {} },
		} },
		{ duration = 2.2, keys = {
			{ 0, {} },
			{ 0.4, { Waist = { -20, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 45, 0, 5 }, RE = { 100, 0, 0 }, LS = { 55, 0, 15 }, LE = { 80, 0, 0 } } },
			{ 0.8, { Waist = { -22, 6, 0 }, Neck = { -18, 6, 0 }, RS = { 45, 0, 5 }, RE = { 100, 0, 0 }, LS = { 60, 0, 20 }, LE = { 70, 0, 0 } } },
			{ 1.2, { Waist = { -20, -6, 0 }, Neck = { -15, -6, 0 }, RS = { 45, 0, 5 }, RE = { 100, 0, 0 }, LS = { 55, 0, 10 }, LE = { 85, 0, 0 } } },
			{ 1.7, { Waist = { -14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 5 }, RE = { 100, 0, 0 }, LS = { 30, 0, -10 }, LE = { 60, 0, 0 } } },
			{ 2.2, {} },
		} },
		{ duration = 2, keys = {
			{ 0, {} },
			{ 0.4, { Waist = { 10, 0, 0 }, Neck = { 25, 0, 0 }, RS = { -40, 0, 18 }, RE = { 95, 0, 0 }, LS = { -40, 0, -18 }, LE = { 95, 0, 0 } } },
			{ 0.8, { Waist = { 14, 0, 4 }, Neck = { 30, 0, 0 }, RS = { -45, 0, 18 }, RE = { 100, 0, 0 }, LS = { -45, 0, -18 }, LE = { 100, 0, 0 } } },
			{ 1.2, { Waist = { 14, 0, -4 }, Neck = { 30, 0, 0 }, RS = { -45, 0, 18 }, RE = { 100, 0, 0 }, LS = { -45, 0, -18 }, LE = { 100, 0, 0 } } },
			{ 2, {} },
		} },
	},
}

-- Pendant qu'elle tient quelqu'un : bras droit tendu qui tient l'anse passée autour du cou, buste voûté,
-- appuyée sur sa canne
data.grabHold = {
	Root = { -6, 6, 0, 0, -0.2, 0.05 },
	Waist = { -14, 6, 0 },
	Neck = { 16, -6, 0 },
	RS = { 85, 0, -12 },
	RE = { 35, 0, 0 },
	RW = { 0, 0, 0 },
	LS = { 22, 0, -10 },
	LE = { 35, 0, 0 },
}

-- Retour 🪂 : elle descend assise dans son rocking-chair suspendu à une pelote géante qui se déroule,
-- se lève en se tenant les reins et brandit ses aiguilles
data.respawn = {
	duration = 1.8,
	platform = { pieces = {
		{ "Assise", "base", "block", Vector3.new(4.5, 0.6, 3.4), Vector3.new(0, -0.3, 0), Vector3.zero, WOOD, "Wood" },
		{ "Coussin", "", "block", Vector3.new(3.6, 0.2, 2.8), Vector3.new(0, 0.05, 0), Vector3.zero, WOOL, "Fabric" },
		{ "Dossier", "", "block", Vector3.new(4.5, 3.6, 0.4), Vector3.new(0, 1.6, 1.8), Vector3.new(-10, 0, 0), WOOD, "Wood" },
		{ "PatinAvant", "", "cyl", Vector3.new(5.5, 0.3, 0.3), Vector3.new(0, -1.3, -1.4), Vector3.new(0, 0, 0), WOOD, "Wood", { axis = "x" } },
		{ "PatinArriere", "", "cyl", Vector3.new(5.5, 0.3, 0.3), Vector3.new(0, -1.3, 1.4), Vector3.new(0, 0, 0), WOOD, "Wood", { axis = "x" } },
		{ "Pied", "", "block", Vector3.new(4, 1, 0.3), Vector3.new(0, -0.8, 0), Vector3.zero, WOOD, "Wood" },
		{ "Fil", "", "cyl", Vector3.new(8, 0.12, 0.12), Vector3.new(0, 6.5, 0.6), Vector3.new(0, 0, 0), Color3.fromRGB(210, 90, 140), "Fabric" },
		{ "PeloteGeante", "", "ball", Vector3.new(5, 5, 5), Vector3.new(0, 12, 0.6), Vector3.zero, WOOL, "Fabric" },
		{ "AiguilleA", "", "cyl", Vector3.new(7, 0.2, 0.2), Vector3.new(0, 12.5, 0.6), Vector3.new(0, 0, 30), Color3.fromRGB(200, 200, 210), "Metal", { axis = "x" } },
		{ "AiguilleB", "", "cyl", Vector3.new(7, 0.2, 0.2), Vector3.new(0, 12.5, 0.6), Vector3.new(0, 0, -30), Color3.fromRGB(200, 200, 210), "Metal", { axis = "x" } },
	} },
	keys = {
		{ 0.0, { Root = { 4, 0, 0, 0, -1.05, 0.15 }, Waist = { -10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 40, 0, -15 }, RE = { 100, 0, 0 }, LS = { 40, 0, 15 }, LE = { 100, 0, 0 }, RH = { 85, 0, 4 }, RK = { -85, 0, 0 }, LH = { 85, 0, -4 }, LK = { -85, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, 0 } } },
		{ 0.5, { Root = { -4, 0, 0, 0, -1.05, 0.15 }, Waist = { -10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 42, 0, -15 }, RE = { 90, 0, 0 }, LS = { 38, 0, 15 }, LE = { 110, 0, 0 }, RH = { 90, 0, 4 }, RK = { -80, 0, 0 }, LH = { 90, 0, -4 }, LK = { -80, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, 0 } } },
		{ 0.8, { Root = { -14, 0, 0, 0, -0.5, 0 }, Waist = { -35, 0, 0 }, Neck = { 30, 0, 0 }, RS = { -40, 0, 20 }, RE = { 100, 0, 0 }, LS = { 30, 0, -10 }, LE = { 30, 0, 0 } } },
		{ 1.1, { Root = { -6, 0, 0, 0, -0.25, 0 }, Waist = { -10, 0, 0 }, Neck = { 22, 0, 0 }, RS = { -45, 0, 20 }, RE = { 105, 0, 0 }, LS = { 25, 0, -10 }, LE = { 30, 0, 0 } } },
		{ 1.35, { Root = { 2, 0, 0, 0, -0.1, 0 }, Waist = { 4, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 165, 0, 20 }, RE = { 15, 0, 0 }, LS = { 165, 0, -20 }, LE = { 15, 0, 0 } } },
		{ 1.55, { Root = { 2, 0, 0, 0, -0.1, 0 }, Waist = { 6, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 170, 0, 28 }, RE = { 20, 0, 0 }, LS = { 170, 0, -28 }, LE = { 20, 0, 0 } } },
		{ 1.8, {} },
	},
	beats = {
		{ 0.1, { "symbols", symbols = { "🧶" }, count = 3, radius = 3, color = WOOL } },
		{ 0.8, { "text", text = "AÏE, MES REINS…", color = Color3.fromRGB(255, 220, 180) } },
		{ 1.35, { "particles", tex = "spark", color = Color3.fromRGB(220, 220, 230), dir = "up", at = "hand", time = 0.3, speed = 6 } },
		{ 1.4, { "text", text = "À NOUS DEUX !", color = WOOL } },
	},
}

-- Arbre d'enchaînements : P P P (sac, joue, cabas), K K K (canne, revers, golf), mélanges P/K,
-- et presque tout peut finir sur S (écharpe-fouet, ou chat lancé après un coup qui fait décoller)
local function airAfterP()
	return { K = "K_air", fwd_K = "K_air_side", up_K = "K_air_up", down_K = "K_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end
local function airAfterK()
	return { P = "P_air", fwd_P = "P_air_side", up_P = "P_air_up", down_P = "P_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end

local LINKS = {
	P_neutral = { P = "P_combo2", K = "PK_combo", S = "S_finish_echarpe" }, -- P
	P_combo2 = { P = "P_combo3", K = "K_combo3", S = "S_finish_echarpe" }, -- P P
	P_combo3 = { S = "S_neutral" }, -- P P P
	PK_combo = { P = "P_combo3", K = "K_combo2", S = "S_finish_echarpe" }, -- P K
	K_neutral = { K = "K_combo2", P = "KP_combo", S = "S_finish_echarpe" }, -- K
	K_combo2 = { K = "K_combo3", P = "P_combo3", S = "S_finish_echarpe" }, -- K K
	K_combo3 = { S = "S_neutral" }, -- K K K (fait décoller : le chat en cloche suit)
	KP_combo = { K = "K_combo3", P = "P_combo2", S = "S_finish_echarpe" }, -- K P
	P_side = { P = "P_combo2", K = "K_neutral", S = "S_finish_echarpe" }, -- → P
	P_down = { P = "P_up", K = "K_combo3", S = "S_down" }, -- ↓ P (balayage puis parapluie ou golf)
	P_up = { P = "P_combo3", S = "S_neutral" }, -- ↑ P
	K_down = { P = "P_combo2", K = "K_combo2", S = "S_down" }, -- ↓ K (elle attire, puis enchaîne)
	K_side = { P = "KP_combo", S = "S_finish_echarpe" }, -- → K
	P_dash = { P = "P_combo2", K = "PK_combo", S = "S_finish_echarpe" }, -- dash P
	K_dash = { P = "P_up", S = "S_finish_echarpe" }, -- dash K
	-- en l'air
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
