-- Jordan « RageQuit » : gamer nerveux qui tilte au moindre coup reçu. Arme sortie de la Caisse Bizarre :
-- la manette filaire (maniée comme un nunchaku) et le clavier mécanique RGB.
--
-- Même format que Gege.lua (voir son en-tête et docs/fiche-perso.md).
-- Mécanique « rage » : les dégâts reçus remplissent la jauge ; pleine, il « tilte » (+50 % de dégâts, plus
-- d'esquive) pendant 6 s.
-- Ses poses sont crispées : dos rond, épaules remontées, gestes brusques, coups en rafale façon « spam bouton ».

local function box(width, height, forward, up)
	return { size = Vector3.new(width, height, 6), offset = Vector2.new(forward, up) }
end

local PEAU = Color3.fromRGB(235, 195, 165)
local SWEAT = Color3.fromRGB(45, 45, 55)
local SWEAT_FONCE = Color3.fromRGB(30, 30, 38)
local JOGGING = Color3.fromRGB(70, 75, 92)
local BASKETS = Color3.fromRGB(235, 235, 235)
local CHEVEUX = Color3.fromRGB(90, 60, 35)
local NOIR = Color3.fromRGB(22, 22, 26)
local BLANC = Color3.fromRGB(245, 245, 245)
local ROUGE = Color3.fromRGB(255, 45, 70)
local VERT = Color3.fromRGB(40, 255, 120)
local BLEU = Color3.fromRGB(60, 140, 255)
local VIOLET = Color3.fromRGB(180, 60, 255)
local CHIPS = Color3.fromRGB(255, 205, 40)
local BSOD = Color3.fromRGB(20, 80, 220)

local ORANGE = Color3.fromRGB(255, 140, 30) -- pistolet optique (arme n° 3)
local GRIS = Color3.fromRGB(200, 200, 210) -- canon du pistolet, câbles
local data = {
	id = "Jordan",
	name = "Jordan « RageQuit »",
	costume = "Jordan",
	style = "gamer",
	------------------------------------------------------------------ Mains nues (sans Caisse Bizarre) : tryhard sans manette
	-- Ses propres J / K et ses combos sans manette (les L et les Y restent ceux de moves). Jordan rejoue les
	-- inputs de ses jeux de combat avec son corps : jabs annulés, poing sur le bureau, hitbox douteuse, wavedash,
	-- et il fête chaque touche d'un dab ou d'un floss.
	bare = {
		moves = {
			-- J : jab sec de tryhard, épaules remontées, « frame 1 »
			P_neutral = {
				label = "Jab frame 1", startup = 0.06, active = 0.07, recovery = 0.12,
				damage = 5, hitbox = box(4, 2.5, 2.6, 1), kbBase = 18, kbGrowth = 22, kbAngle = 22,
				windup = { Root = { -6, -10, 0, 0, -0.2, 0.1 }, Waist = { -10, -10, 0 }, Neck = { -10, 8, 0 }, RS = { 50, 0, 30 }, RE = { 120, 0, 0 }, LS = { 60, 0, -20 }, LE = { 120, 0, 0 } },
				strike = { Root = { -10, 14, 0, 0, -0.22, -0.2 }, Waist = { -14, 14, 0 }, Neck = { -10, -10, 0 }, RS = { 92, 0, 4 }, RE = { 4, 0, 0 }, LS = { 60, 0, -24 }, LE = { 124, 0, 0 } },
				follow = { Root = { -11, 16, 0, 0, -0.22, -0.22 }, Waist = { -15, 16, 0 }, Neck = { -10, -12, 0 }, RS = { 90, 0, 2 }, RE = { 6, 0, 0 }, LS = { 60, 0, -26 }, LE = { 126, 0, 0 } },
				trail = "rightHand", hitText = "FRAME 1 !",
			},
			-- J J : il annule le jab dans un deuxième, de l'autre poing, encore plus vite
			P_combo2 = {
				label = "Jab annulé", startup = 0.06, active = 0.07, recovery = 0.13,
				damage = 5, hitbox = box(4, 2.5, 2.8, 1), kbBase = 18, kbGrowth = 22, kbAngle = 26,
				windup = { Root = { -10, 14, 0, 0, -0.22, 0 }, Waist = { -14, 14, 0 }, Neck = { -10, -10, 0 }, RS = { 70, 0, 20 }, RE = { 100, 0, 0 }, LS = { 50, 0, -30 }, LE = { 120, 0, 0 } },
				strike = { Root = { -12, -16, 0, 0, -0.24, -0.25 }, Waist = { -16, -16, 0 }, Neck = { -10, 12, 0 }, RS = { 60, 0, 24 }, RE = { 120, 0, 0 }, LS = { 94, 0, -2 }, LE = { 4, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.25 } },
				follow = { Root = { -13, -18, 0, 0, -0.24, -0.27 }, Waist = { -17, -18, 0 }, Neck = { -10, 14, 0 }, RS = { 60, 0, 26 }, RE = { 122, 0, 0 }, LS = { 92, 0, 0 }, LE = { 6, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.27 } },
				trail = "leftHand", fx = { { "text", text = "CANCEL", color = VERT, at = "above" } }, hitText = "TAC-TAC !",
			},
			-- J J J : de rage, il abat les deux poings comme sur son bureau après une défaite
			P_combo3 = {
				label = "Poing sur le bureau", startup = 0.14, active = 0.1, recovery = 0.3,
				damage = 9, hitbox = box(4.5, 4, 2.6, 0.4), kbBase = 28, kbGrowth = 50, kbAngle = 70,
				windup = { Root = { 10, 0, 0, 0, 0.1, 0.15 }, Waist = { 14, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 175, 0, 10 }, RE = { 60, 0, 0 }, LS = { 175, 0, -10 }, LE = { 60, 0, 0 } },
				strike = { Root = { -24, 0, 0, 0, -0.5, -0.25 }, Waist = { -26, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 70, 0, 6 }, RE = { 20, 0, 0 }, LS = { 70, 0, -6 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
				follow = { Root = { -26, 0, 0, 0, -0.55, -0.28 }, Waist = { -28, 0, 0 }, Neck = { -22, 0, 0 }, RS = { 62, 0, 6 }, RE = { 24, 0, 0 }, LS = { 62, 0, -6 }, LE = { 24, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
				shake = true, hold = 0.08, trail = "bothHands", fx = { { "ring", color = ROUGE, radius = 4, at = "front" }, { "shake", amount = 0.4 } }, text = "C'EST TRUQUÉ !", hitText = "BOUM-BUREAU !",
			},
			-- J K J : il dabe de victoire, le coude replié part dans la figure
			PKP_combo = {
				label = "Dab de victoire", startup = 0.1, active = 0.1, recovery = 0.28,
				damage = 8, hitbox = box(4.5, 3.5, 2.4, 1.4), kbBase = 26, kbGrowth = 45, kbAngle = 35,
				windup = { Root = { 0, -20, 0, 0, -0.1, 0.1 }, Waist = { 0, -20, 0 }, Neck = { 10, 20, 0 }, RS = { 30, 0, 30 }, RE = { 90, 0, 0 }, LS = { 30, 0, -30 }, LE = { 90, 0, 0 } },
				strike = { Root = { -6, 20, 0, 0, -0.15, -0.25 }, Waist = { -10, 24, 0 }, Neck = { 40, 30, 0 }, RS = { 140, 0, 60 }, RE = { 10, 0, 0 }, LS = { 120, 0, 40 }, LE = { 140, 0, 0 }, FR = { 0, 0, 0, 0, 0, -0.25 } },
				follow = { Root = { -7, 22, 0, 0, -0.15, -0.27 }, Waist = { -11, 26, 0 }, Neck = { 42, 32, 0 }, RS = { 142, 0, 62 }, RE = { 10, 0, 0 }, LS = { 122, 0, 42 }, LE = { 142, 0, 0 }, FR = { 0, 0, 0, 0, 0, -0.27 } },
				hold = 0.12, trail = "leftHand", fx = { { "text", text = "GG EZ", color = VERT, at = "above" } }, text = "DAB !", hitText = "EZ !",
			},
			-- →J : il pointe l'adversaire d'un doigt accusateur, en pleine poitrine : « C'est le ping ! »
			P_side = {
				label = "Doigt accusateur", startup = 0.1, active = 0.1, recovery = 0.2,
				damage = 7, hitbox = box(5.5, 2.5, 3.3, 1.1), kbBase = 22, kbGrowth = 35, kbAngle = 22, selfVelocity = Vector2.new(18, 0),
				windup = { Root = { -4, 20, 0, 0, -0.1, 0.2 }, Waist = { -6, 20, 0 }, Neck = { -10, -10, 0 }, RS = { 60, 0, 60 }, RE = { 110, 0, 0 }, LS = { 30, 0, -30 }, LE = { 100, 0, 0 } },
				strike = { Root = { -12, -14, 0, 0, -0.2, -0.4 }, Waist = { -12, -16, 0 }, Neck = { -14, 10, 0 }, RS = { 96, 0, -4 }, RE = { 0, 0, 0 }, RW = { 10, 0, 0 }, LS = { 30, 0, -40 }, LE = { 110, 0, 0 }, FR = { 0, 0, 0, 0, 0, -0.45 } },
				follow = { Root = { -14, -16, 0, 0, -0.22, -0.44 }, Waist = { -14, -18, 0 }, Neck = { -16, 12, 0 }, RS = { 94, 0, -6 }, RE = { 0, 0, 0 }, RW = { 14, 0, 0 }, LS = { 30, 0, -42 }, LE = { 112, 0, 0 }, FR = { 0, 0, 0, 0, 0, -0.48 } },
				trail = "rightHand", text = "C'EST LE PING !", hitText = "POINT !",
			},
			-- ↓J : spam accroupi, il se baisse et se relève en boucle en tapant les tibias
			P_down = {
				label = "Spam accroupi", startup = 0.07, active = 0.14, recovery = 0.18,
				damage = 6, hits = 2, hitbox = box(4.5, 2.2, 2.4, -1.2), kbBase = 20, kbGrowth = 25, kbAngle = 65,
				windup = { Root = { -10, 0, 0, 0, -0.3, 0.05 }, Waist = { -14, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 60, 0, 30 }, RE = { 120, 0, 0 }, LS = { 60, 0, -30 }, LE = { 120, 0, 0 } },
				strike = { Root = { -16, 0, 0, 0, -1.0, -0.1 }, Waist = { -20, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 10 }, RE = { 30, 0, 0 }, LS = { 40, 0, -10 }, LE = { 30, 0, 0 } },
				follow = { Root = { -10, 0, 0, 0, -0.5, -0.1 }, Waist = { -14, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 50, 0, 20 }, RE = { 60, 0, 0 }, LS = { 50, 0, -20 }, LE = { 60, 0, 0 } },
				wobble = true, trail = "bothHands", fx = { { "text", text = "↓↓↓", color = VERT, at = "above" } }, hitText = "SPAM !",
			},
			-- ↑J : « POG ! » les deux poings jaillissent vers le ciel comme après un clutch
			P_up = {
				label = "Poings POG", startup = 0.08, active = 0.1, recovery = 0.2,
				damage = 6, hitbox = box(4, 5, 1.2, 3), kbBase = 22, kbGrowth = 38, kbAngle = 86,
				windup = { Root = { -10, 0, 0, 0, -0.5, 0.05 }, Waist = { -14, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 20, 0, 30 }, RE = { 130, 0, 0 }, LS = { 20, 0, -30 }, LE = { 130, 0, 0 } },
				strike = { Root = { 6, 0, 0, 0, 0.3, 0 }, Waist = { 8, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 172, 0, 16 }, RE = { 10, 0, 0 }, LS = { 172, 0, -16 }, LE = { 10, 0, 0 } },
				follow = { Root = { 8, 0, 0, 0, 0.32, 0 }, Waist = { 10, 0, 0 }, Neck = { 26, 0, 0 }, RS = { 176, 0, 18 }, RE = { 12, 0, 0 }, LS = { 176, 0, -18 }, LE = { 12, 0, 0 } },
				trail = "bothHands", fx = { { "symbols", symbols = { "POG", "!!" }, color = VERT, count = 3, radius = 2.5, at = "above" } }, hitText = "POG !",
			},
			-- J en l'air : coude plongeant « Alt-Tab », il pique du coude en tournant la tête ailleurs
			P_air = {
				label = "Coude Alt-Tab", startup = 0.09, active = 0.14, recovery = 0.18,
				damage = 7, hitbox = box(4, 3.5, 1.6, -1.2), kbBase = 20, kbGrowth = 32, kbAngle = -45,
				windup = { Root = { 10, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 0, 30, 0 }, RS = { 160, 0, 50 }, RE = { 140, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 20, 0, 0 }, LK = { -40, 0, 0 } },
				strike = { Root = { -30, 0, 0 }, Waist = { -16, 0, 0 }, Neck = { 0, -30, 0 }, RS = { 20, 0, 40 }, RE = { 140, 0, 0 }, LS = { 40, 0, -50 }, LE = { 60, 0, 0 }, RH = { 30, 0, 0 }, RK = { -60, 0, 0 }, LH = { 50, 0, 0 }, LK = { -80, 0, 0 } },
				follow = { Root = { -34, 0, 0 }, Waist = { -18, 0, 0 }, Neck = { 0, -34, 0 }, RS = { 10, 0, 42 }, RE = { 142, 0, 0 }, LS = { 40, 0, -52 }, LE = { 60, 0, 0 }, RH = { 26, 0, 0 }, RK = { -56, 0, 0 }, LH = { 54, 0, 0 }, LK = { -84, 0, 0 } },
				trail = "rightHand", hitText = "ALT-TAB !",
			},
			-- dash J : la charge du noob, bras qui moulinent, aucune stratégie
			P_dash = {
				label = "Charge du noob", startup = 0.08, active = 0.18, recovery = 0.24,
				damage = 7, hitbox = box(5, 3.5, 2.6, 0.8), kbBase = 24, kbGrowth = 38, kbAngle = 30, selfVelocity = Vector2.new(36, 0),
				windup = { Root = { -14, 0, 0, 0, -0.15, 0.15 }, Waist = { -10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { -40, 0, 20 }, RE = { 30, 0, 0 }, LS = { 160, 0, -20 }, LE = { 30, 0, 0 } },
				strike = { Root = { -20, 0, 0, 0, -0.2, -0.4 }, Waist = { -12, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 160, 0, 20 }, RE = { 30, 0, 0 }, LS = { -40, 0, -20 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
				follow = { Root = { -22, 0, 0, 0, -0.2, -0.44 }, Waist = { -14, 0, 0 }, Neck = { 14, 0, 0 }, RS = { -30, 0, 20 }, RE = { 30, 0, 0 }, LS = { 150, 0, -20 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.48 } },
				wobble = true, trail = "bothHands", fx = { "dust" }, text = "LEEEROY !", hitText = "NOOOB !",
			},
			-- dash J J : combo infini, il pianote des poings sur l'adversaire comme sur un clavier
			dashP_combo = {
				label = "Combo infini", startup = 0.07, active = 0.24, recovery = 0.3,
				damage = 9, hits = 4, hitbox = box(4.5, 3, 2.4, 1), kbBase = 26, kbGrowth = 48, kbAngle = 35,
				windup = { Root = { -10, 0, 0, 0, -0.2, 0.05 }, Waist = { -14, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 70, 0, 20 }, RE = { 90, 0, 0 }, LS = { 70, 0, -20 }, LE = { 90, 0, 0 } },
				strike = { Root = { -14, 10, 0, 0, -0.22, -0.2 }, Waist = { -18, 10, 0 }, Neck = { -12, 0, 0 }, RS = { 94, 0, 6 }, RE = { 10, 0, 0 }, LS = { 70, 0, -16 }, LE = { 80, 0, 0 } },
				follow = { Root = { -14, -10, 0, 0, -0.22, -0.22 }, Waist = { -18, -10, 0 }, Neck = { -12, 0, 0 }, RS = { 70, 0, 16 }, RE = { 80, 0, 0 }, LS = { 94, 0, -6 }, LE = { 10, 0, 0 } },
				wobble = true, trail = "bothHands", fx = { { "text", text = "47 HITS", color = CHIPS, at = "above" } }, hitText = "COMBO !",
			},
			-- K : coup de pied sous le bureau, sec et à ras du genou
			K_neutral = {
				label = "Pied sous le bureau", startup = 0.1, active = 0.1, recovery = 0.22,
				damage = 7, hitbox = box(4.5, 2.5, 2.6, -0.4), kbBase = 24, kbGrowth = 42, kbAngle = 38,
				windup = { Root = { -10, 0, 0, 0, -0.2, 0.1 }, Waist = { -14, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 20 }, RE = { 120, 0, 0 }, LS = { 60, 0, -20 }, LE = { 120, 0, 0 }, RH = { 60, 0, 0 }, RK = { -110, 0, 0 } },
				strike = { Root = { -4, 0, 0, 0, -0.2, -0.05 }, Waist = { -14, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 24 }, RE = { 120, 0, 0 }, LS = { 60, 0, -24 }, LE = { 120, 0, 0 }, RH = { 70, 0, 0 }, RK = { -4, 0, 0 }, RA = { 20, 0, 0 } },
				follow = { Root = { -2, 0, 0, 0, -0.2, -0.06 }, Waist = { -14, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 26 }, RE = { 120, 0, 0 }, LS = { 60, 0, -26 }, LE = { 120, 0, 0 }, RH = { 74, 0, 0 }, RK = { 0, 0, 0 }, RA = { 24, 0, 0 } },
				trail = "rightFoot", hitText = "TOC-TIBIA !",
			},
			-- K K : le coup de pied « laggue » : figé en l'air une fraction de seconde, puis il téléporte dans la cible
			K_combo2 = {
				label = "Pied désynchronisé", startup = 0.12, active = 0.12, recovery = 0.26,
				damage = 8, hitbox = box(5, 2.5, 3, 0.2), kbBase = 26, kbGrowth = 45, kbAngle = 35, selfVelocity = Vector2.new(16, 0),
				windup = { Root = { 0, -20, 0, 0, -0.1, 0.1 }, Waist = { -6, -20, 0 }, Neck = { -6, 20, 0 }, RS = { 40, 0, 40 }, RE = { 100, 0, 0 }, LS = { 40, 0, -40 }, LE = { 100, 0, 0 }, LH = { 80, 0, 0 }, LK = { -90, 0, 0 } },
				strike = { Root = { 10, 10, 0, 0, -0.05, -0.15 }, Waist = { 6, 10, 0 }, Neck = { -10, -10, 0 }, RS = { 40, 0, 60 }, RE = { 60, 0, 0 }, LS = { 60, 0, -60 }, LE = { 40, 0, 0 }, LH = { 100, 0, 0 }, LK = { 0, 0, 0 }, LA = { 30, 0, 0 } },
				follow = { Root = { 12, 12, 0, 0, -0.05, -0.18 }, Waist = { 8, 12, 0 }, Neck = { -12, -12, 0 }, RS = { 40, 0, 62 }, RE = { 60, 0, 0 }, LS = { 62, 0, -62 }, LE = { 40, 0, 0 }, LH = { 104, 0, 0 }, LK = { 0, 0, 0 }, LA = { 34, 0, 0 } },
				hold = 0.12, shake = true, trail = "leftFoot", fx = { { "text", text = "LAG", color = ROUGE, at = "above" }, { "burst", color = BSOD, size = 1.6, at = "front" } }, hitText = "DÉSYNC !",
			},
			-- K K K : le floss de la honte, hanches qui balancent, bras qui battent devant et derrière
			KKK_combo = {
				label = "Floss de la honte", startup = 0.1, active = 0.24, recovery = 0.32,
				damage = 10, hits = 3, hitbox = box(5, 3.5, 2.2, 0.4), kbBase = 30, kbGrowth = 60, kbAngle = 42,
				windup = { Root = { 0, 0, 10, 0.3, -0.1, 0 }, Waist = { 0, 0, -14 }, Neck = { 0, 0, 10 }, RS = { -30, 0, 30 }, RE = { 0, 0, 0 }, LS = { -30, 0, 30 }, LE = { 0, 0, 0 } },
				strike = { Root = { 0, 0, -10, -0.3, -0.1, -0.1 }, Waist = { 0, 0, 14 }, Neck = { 0, 0, -10 }, RS = { 30, 0, -30 }, RE = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 0, 0, 0 } },
				follow = { Root = { 0, 0, 10, 0.3, -0.1, -0.1 }, Waist = { 0, 0, -14 }, Neck = { 0, 0, 10 }, RS = { -30, 0, 30 }, RE = { 0, 0, 0 }, LS = { -30, 0, 30 }, LE = { 0, 0, 0 } },
				wobble = true, trail = "bothHands", fx = { { "symbols", symbols = { "🕺", "♪" }, color = VIOLET, count = 4, radius = 3, at = "above" } }, text = "FLOSS !", hitText = "TROLLED !",
			},
			-- →K : un front kick dont la portée est bien plus longue que ce que montre l'animation
			K_side = {
				label = "Hitbox douteuse", startup = 0.12, active = 0.12, recovery = 0.26,
				damage = 8, hitbox = box(6.5, 2.5, 3.8, 0.2), kbBase = 26, kbGrowth = 48, kbAngle = 28, selfVelocity = Vector2.new(12, 0),
				windup = { Root = { -6, -10, 0, 0, -0.15, 0.2 }, Waist = { -8, -10, 0 }, Neck = { -6, 10, 0 }, RS = { 60, 0, 30 }, RE = { 110, 0, 0 }, LS = { 60, 0, -30 }, LE = { 110, 0, 0 }, RH = { 90, 0, 0 }, RK = { -120, 0, 0 } },
				strike = { Root = { 10, 0, 0, 0, -0.1, -0.05 }, Waist = { 6, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 40 }, RE = { 90, 0, 0 }, LS = { 40, 0, -40 }, LE = { 90, 0, 0 }, RH = { 95, 0, 0 }, RK = { -2, 0, 0 }, RA = { 10, 0, 0 } },
				follow = { Root = { 12, 0, 0, 0, -0.1, -0.08 }, Waist = { 8, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 40, 0, 42 }, RE = { 90, 0, 0 }, LS = { 40, 0, -42 }, LE = { 90, 0, 0 }, RH = { 98, 0, 0 }, RK = { 0, 0, 0 }, RA = { 14, 0, 0 } },
				trail = "rightFoot", fx = { { "text", text = "?!", color = CHIPS, at = "front" } }, hitText = "HITBOX ?!",
			},
			-- ↓K : balayette en « input lag », la jambe part avec un temps de retard
			K_down = {
				label = "Balayette input lag", startup = 0.16, active = 0.14, recovery = 0.26,
				damage = 7, hitbox = box(6, 2, 2.8, -1.6), kbBase = 24, kbGrowth = 40, kbAngle = 72,
				windup = { Root = { -10, 0, 0, 0, -0.8, 0.05 }, Waist = { -10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 40, 0, 40 }, RE = { 90, 0, 0 }, LS = { 70, 0, -20 }, LE = { 90, 0, 0 } },
				strike = { Root = { -10, -40, 0, 0, -1.0, 0 }, Waist = { -10, -10, 0 }, Neck = { -6, 20, 0 }, RS = { 10, 0, 60 }, RE = { 20, 0, 0 }, LS = { 80, 0, -10 }, LE = { 30, 0, 0 }, RH = { 80, 0, 40 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 } },
				follow = { Root = { -10, -60, 0, 0, -1.0, 0 }, Waist = { -10, -14, 0 }, Neck = { -6, 24, 0 }, RS = { 8, 0, 62 }, RE = { 20, 0, 0 }, LS = { 82, 0, -10 }, LE = { 30, 0, 0 }, RH = { 84, 0, 40 }, RK = { 0, 0, 0 }, RA = { 24, 0, 0 } },
				shake = true, trail = "rightLeg", fx = { "dust" }, hitText = "INPUT LAG !",
			},
			-- ↑K : bunny hop, il saute pieds joints et le genou remonte sous le menton
			K_up = {
				label = "Bunny hop", startup = 0.12, active = 0.12, recovery = 0.28,
				damage = 8, hitbox = box(4, 5, 1.4, 2.4), kbBase = 26, kbGrowth = 50, kbAngle = 85, selfVelocity = Vector2.new(0, 22),
				windup = { Root = { -10, 0, 0, 0, -0.6, 0 }, Waist = { -10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { -20, 0, 20 }, RE = { 60, 0, 0 }, LS = { -20, 0, -20 }, LE = { 60, 0, 0 } },
				strike = { Root = { 6, 0, 0, 0, 0.3, 0 }, Waist = { 6, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 100, 0, 40 }, RE = { 60, 0, 0 }, LS = { 100, 0, -40 }, LE = { 60, 0, 0 }, RH = { 130, 0, 0 }, RK = { -120, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
				follow = { Root = { 8, 0, 0, 0, 0.32, 0 }, Waist = { 8, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 104, 0, 42 }, RE = { 60, 0, 0 }, LS = { 104, 0, -42 }, LE = { 60, 0, 0 }, RH = { 134, 0, 0 }, RK = { -124, 0, 0 }, LH = { 32, 0, 0 }, LK = { -62, 0, 0 } },
				trail = "rightLeg", fx = { { "text", text = "HOP HOP", color = VERT, at = "feet" } }, hitText = "BHOP !",
			},
			-- K en l'air : double saut glitché, les deux pieds tremblent et frappent en avant
			K_air = {
				label = "Double saut glitché", startup = 0.1, active = 0.16, recovery = 0.2,
				damage = 8, hits = 2, hitbox = box(5, 3, 2.4, -0.6), kbBase = 22, kbGrowth = 40, kbAngle = 38,
				windup = { Root = { 10, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 120, 0, 50 }, RE = { 60, 0, 0 }, LS = { 120, 0, -50 }, LE = { 60, 0, 0 }, RH = { 100, 0, 0 }, RK = { -120, 0, 0 }, LH = { 80, 0, 0 }, LK = { -110, 0, 0 } },
				strike = { Root = { 20, 0, 0 }, Waist = { 4, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 60, 0, 70 }, RE = { 20, 0, 0 }, LS = { 60, 0, -70 }, LE = { 20, 0, 0 }, RH = { 90, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 70, 0, 0 }, LK = { -20, 0, 0 } },
				follow = { Root = { 22, 0, 0 }, Waist = { 4, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 58, 0, 72 }, RE = { 20, 0, 0 }, LS = { 58, 0, -72 }, LE = { 20, 0, 0 }, RH = { 70, 0, 0 }, RK = { -20, 0, 0 }, LH = { 92, 0, 0 }, LK = { 0, 0, 0 }, LA = { 20, 0, 0 } },
				shake = true, wobble = true, trail = "rightFoot", fx = { { "particles", tex = "spark", color = VERT, dir = "all", at = "feet", time = 0.3, speed = 6, size = 0.4, rate = 50 } }, hitText = "GLITCH !",
			},
			-- dash K : wavedash, il glisse au ras du sol, une jambe tendue devant
			K_dash = {
				label = "Wavedash", startup = 0.1, active = 0.22, recovery = 0.3,
				damage = 8, hitbox = box(6, 2.2, 3, -1.2), kbBase = 28, kbGrowth = 50, kbAngle = 42, selfVelocity = Vector2.new(50, 0),
				windup = { Root = { -14, 0, 0, 0, -0.3, 0.1 }, Waist = { -10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { -30, 0, 30 }, RE = { 30, 0, 0 }, LS = { -30, 0, -30 }, LE = { 30, 0, 0 } },
				strike = { Root = { 10, 0, 0, 0, -1.0, -0.2 }, Waist = { -14, 0, 0 }, Neck = { -10, 0, 0 }, RS = { -40, 0, 40 }, RE = { 20, 0, 0 }, LS = { -40, 0, -40 }, LE = { 20, 0, 0 }, RH = { 85, 0, 4 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 10, 0, 0 }, LK = { -110, 0, 0 } },
				follow = { Root = { 12, 0, 0, 0, -1.02, -0.24 }, Waist = { -16, 0, 0 }, Neck = { -12, 0, 0 }, RS = { -44, 0, 42 }, RE = { 20, 0, 0 }, LS = { -44, 0, -42 }, LE = { 20, 0, 0 }, RH = { 88, 0, 4 }, RK = { 0, 0, 0 }, RA = { 24, 0, 0 }, LH = { 12, 0, 0 }, LK = { -112, 0, 0 } },
				trail = "rightFoot", fx = { { "particles", tex = "smoke", color = BLEU, dir = "up", at = "feet", time = 0.3, speed = 5, size = 0.6, rate = 40 } }, hitText = "WAVEDASH !",
			},
		},
		-- Combos à mains nues (en inputs de jeu de combat) : J J J (jab, jab annulé, poing sur le bureau),
		-- J K J (jab, hitbox douteuse, dab), K K K (pied sous le bureau, pied désync, floss), dash J J (combo infini).
		-- Un S pour finir envoie le spécial du perso.
		links = {
			P_neutral = { P = "P_combo2", K = "K_side", S = "S_neutral" },
			P_combo2 = { P = "P_combo3", K = "K_side", S = "S_side" },
			P_combo3 = { S = "S_down" },
			K_side = { P = "PKP_combo", K = "K_combo2", S = "S_side" },
			PKP_combo = { K = "K_up", S = "S_up" },
			K_neutral = { K = "K_combo2", P = "P_side", S = "S_neutral" },
			K_combo2 = { K = "KKK_combo", P = "PKP_combo", S = "S_side" },
			KKK_combo = { S = "S_neutral" },
			P_side = { P = "P_combo2", K = "K_side", S = "S_side" },
			P_dash = { P = "dashP_combo", K = "K_combo2", S = "S_side" },
			dashP_combo = { P = "P_combo3", S = "S_neutral" },
			P_down = { P = "P_up", K = "K_down", S = "S_down" },
			K_down = { P = "P_up", K = "K_up", S = "S_down" },
			P_up = { K = "K_up", S = "S_up" },
			K_up = { S = "S_up" },
			K_dash = { P = "dashP_combo", K = "K_up", S = "S_up" },
			P_air = { K = "K_air", S = "S_air" },
			K_air = { P = "P_air", S = "S_air" },
		},
	},
	------------------------------------------------------------------ Les 3 armes de la Caisse Bizarre (une au hasard)
	-- n° 1 : la manette filaire (ses coups sont ceux de moves). n° 2 : la tour de PC gaming, lourde et lente, qui éjecte loin.
	-- n° 3 : le pistolet optique, jeu de tirs à distance, rapide et précis.
	weapons = {
		{ id = "manette", name = "Manette filaire", icon = "🎮",
			ability = { speed = 1.15, text = "Rushdown : court 15 % plus vite" } },
		{ id = "tour", name = "Tour de PC gaming", icon = "🖥️",
			prop = { name = "PropTour", hand = "Right", pieces = {
				{ "Boitier", "", "block", Vector3.new(1.1, 2.2, 1.0), Vector3.new(0, -1.3, 0), Vector3.zero, NOIR, "SmoothPlastic" },
				{ "Vitre", "", "block", Vector3.new(0.06, 1.8, 0.8), Vector3.new(0.57, -1.3, 0), Vector3.zero, BLEU, "Neon", { neon = true, transparency = 0.3 } },
				{ "Ventilo", "", "cyl", Vector3.new(0.3, 0.7, 0.7), Vector3.new(0, -1.6, -0.5), Vector3.zero, VIOLET, "Neon", { axis = "z", neon = true, light = { VIOLET, 8, 1.5 } } },
				{ "Bouton", "", "ball", Vector3.new(0.2, 0.2, 0.2), Vector3.new(0, -0.35, -0.52), Vector3.zero, VERT, "Neon", { neon = true } },
				{ "Cables", "", "cyl", Vector3.new(0.1, 1.2, 0.1), Vector3.new(0, -2.5, 0.4), Vector3.new(30, 0, 0), GRIS, "SmoothPlastic", { axis = "y" } },
			} },
			ability = { knockback = 1.3, text = "Lourde comme un PC fixe : éjecte 30 % plus loin" },
			moves = {
				-- J : il pousse le boîtier à deux mains dans le ventre, comme pour poser un carton trop lourd
				P_neutral = {
					label = "Coup de boîtier", startup = 0.12, active = 0.1, recovery = 0.22,
					damage = 8, hitbox = box(4.5, 3.5, 2.8, 0.5), kbBase = 26, kbGrowth = 32, kbAngle = 28,
					windup = { Root = { 4, -14, 0, 0, -0.2, 0.15 }, Waist = { 4, -18, 0 }, Neck = { -6, 0, 0 }, RS = { 60, 0, 10 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 110, 0, 0 } },
					strike = { Root = { -10, 12, 0, 0, -0.3, -0.3 }, Waist = { -12, 18, 0 }, Neck = { -10, 0, 0 }, RS = { 96, 0, 4 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, -6 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
					follow = { Root = { -12, 16, 0, 0, -0.32, -0.36 }, Waist = { -14, 22, 0 }, Neck = { -12, 0, 0 }, RS = { 100, 0, 6 }, RE = { 14, 0, 0 }, RW = { -10, 0, 0 }, LS = { 96, 0, -8 }, LE = { 14, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
					trail = "prop", hitText = "BOUM !",
				},
				-- →J : balayage horizontal de la tour, il pivote sur ses baskets, tout le buste suit
				P_side = {
					label = "Balayage de tour", startup = 0.16, active = 0.12, recovery = 0.26,
					damage = 10, hitbox = box(6, 3.5, 3.5, 0.8), kbBase = 28, kbGrowth = 44, kbAngle = 26, selfVelocity = Vector2.new(14, 0),
					windup = { Root = { 6, 40, 0, 0, -0.25, 0.2 }, Waist = { 8, 46, 0 }, Neck = { 0, -20, 0 }, RS = { 70, 0, 60 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 20 }, LE = { 60, 0, 0 } },
					strike = { Root = { -8, -30, 0, 0, -0.32, -0.35 }, Waist = { -10, -36, 0 }, Neck = { 0, 20, 0 }, RS = { 90, 0, -30 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -60 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -10, -40, 0, 0, -0.34, -0.4 }, Waist = { -12, -46, 0 }, Neck = { 0, 26, 0 }, RS = { 94, 0, -36 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 94, 0, -66 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					trail = "prop", hitText = "BLAM !",
				},
				-- ↓J : il lâche la tour par terre, sur les orteils de l'adversaire, avec le bruit d'un disque dur qui meurt
				P_down = {
					label = "Tour sur les orteils", startup = 0.14, active = 0.1, recovery = 0.26,
					damage = 9, hitbox = box(5, 2.5, 2.5, -1.5), kbBase = 26, kbGrowth = 42, kbAngle = 80,
					windup = { Root = { 6, 0, 0, 0, -0.2, 0.1 }, Waist = { -10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 160, 0, 10 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -10 }, LE = { 40, 0, 0 } },
					strike = { Root = { 18, 0, 0, 0, -0.9, -0.2 }, Waist = { 28, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 40, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -10 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { 20, 0, 0, 0, -0.95, -0.24 }, Waist = { 30, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 36, 0, 12 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 36, 0, -12 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
					fx = { "thud", "dust", { "text", text = "CLIC CLIC CLIC", color = BLANC, at = "feet" } }, hitText = "MES ORTEILS !",
				},
				-- ↑J : il soulève la tour à bout de bras comme un haltère, le dessus cogne le menton
				P_up = {
					label = "Tour au menton", startup = 0.14, active = 0.12, recovery = 0.26,
					damage = 9, hitbox = box(4.5, 5.5, 1.5, 3), kbBase = 26, kbGrowth = 46, kbAngle = 86,
					windup = { Root = { 10, 0, 0, 0, -0.35, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 30, 0, 10 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -10 }, LE = { 120, 0, 0 } },
					strike = { Root = { -12, 0, 0, 0, 0.1, -0.1 }, Waist = { -16, 0, 0 }, Neck = { -22, 0, 0 }, RS = { 172, 0, 8 }, RE = { 6, 0, 0 }, RW = { 0, 0, 0 }, LS = { 172, 0, -8 }, LE = { 6, 0, 0 } },
					follow = { Root = { -14, 0, 0, 0, 0.14, -0.12 }, Waist = { -18, 0, 0 }, Neck = { -26, 0, 0 }, RS = { 178, 0, 10 }, RE = { 6, 0, 0 }, RW = { -10, 0, 0 }, LS = { 178, 0, -10 }, LE = { 6, 0, 0 } },
					trail = "prop", hitText = "KLONK !",
				},
				-- J en l'air : il laisse tomber la tour sous lui et se rattrape dessus à califourchon
				P_air = {
					label = "Tour tombante", startup = 0.12, active = 0.14, recovery = 0.18,
					damage = 10, hitbox = box(4.5, 4, 1, -1.8), kbBase = 24, kbGrowth = 42, kbAngle = -45,
					windup = { Root = { 8, 0, 0 }, Waist = { 14, 0, 0 }, RS = { 180, 0, 12 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 180, 0, -12 }, LE = { 50, 0, 0 }, RH = { 40, 0, 0 }, RK = { -80, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { -14, 0, 0 }, Waist = { -26, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 30, 0, 10 }, RE = { 0, 0, 0 }, RW = { -20, 0, 0 }, LS = { 30, 0, -10 }, LE = { 0, 0, 0 }, RH = { 60, 0, 20 }, RK = { -40, 0, 0 }, LH = { 60, 0, -20 }, LK = { -40, 0, 0 } },
					follow = { Root = { -18, 0, 0 }, Waist = { -30, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 24, 0, 12 }, RE = { 4, 0, 0 }, RW = { -30, 0, 0 }, LS = { 24, 0, -12 }, LE = { 4, 0, 0 }, RH = { 64, 0, 22 }, RK = { -44, 0, 0 }, LH = { 64, 0, -22 }, LK = { -44, 0, 0 } },
					trail = "prop", hitText = "BLAM !",
				},
				-- dash J : bélier : la tour devant lui comme un bouclier, il fonce épaule en avant
				P_dash = {
					label = "Bélier de tour", startup = 0.1, active = 0.18, recovery = 0.3,
					damage = 10, hitbox = box(5, 4, 3, 0.5), kbBase = 30, kbGrowth = 48, kbAngle = 24, selfVelocity = Vector2.new(42, 0),
					windup = { Root = { 10, 10, 0, 0, -0.25, 0.1 }, Waist = { 12, 12, 0 }, Neck = { 0, -10, 0 }, RS = { 70, 0, 10 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -10 }, LE = { 90, 0, 0 } },
					strike = { Root = { 18, 6, 0, 0, -0.35, -0.4 }, Waist = { 20, 8, 0 }, Neck = { -12, -6, 0 }, RS = { 92, 0, 4 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, -4 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					follow = { Root = { 20, 6, 0, 0, -0.36, -0.44 }, Waist = { 22, 8, 0 }, Neck = { -14, -6, 0 }, RS = { 94, 0, 6 }, RE = { 18, 0, 0 }, RW = { 0, 0, 0 }, LS = { 94, 0, -6 }, LE = { 18, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.48 } },
					trail = "prop", fx = { "dust" }, hitText = "BÉLIER !",
				},
				-- K : il cale la tour contre sa hanche et envoie un gros coup de genou par-dessus
				K_neutral = {
					label = "Genou par-dessus la tour", startup = 0.16, active = 0.12, recovery = 0.3,
					damage = 11, hitbox = box(4.5, 3.5, 2.5, 0.8), kbBase = 30, kbGrowth = 62, kbAngle = 40,
					windup = { Root = { 6, -10, 0, 0, -0.2, 0.1 }, Waist = { 6, -12, 0 }, Neck = { -6, 0, 0 }, RS = { 40, 0, 20 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 100, 0, 0 }, RH = { -20, 0, 0 }, RK = { -40, 0, 0 } },
					strike = { Root = { -8, 6, 0, 0, -0.3, -0.25 }, Waist = { -10, 8, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 30 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 90, 0, 0 }, RH = { 110, 0, 0 }, RK = { -110, 0, 0 } },
					follow = { Root = { -10, 8, 0, 0, -0.32, -0.28 }, Waist = { -12, 10, 0 }, Neck = { -12, 0, 0 }, RS = { 62, 0, 32 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 62, 0, -32 }, LE = { 90, 0, 0 }, RH = { 116, 0, 0 }, RK = { -112, 0, 0 } },
					trail = "rightLeg", hitText = "GENOU !",
				},
				-- →K : coup de pied retourné, la tour tenue à bout de bras sert de contrepoids
				K_side = {
					label = "Retourné lesté", startup = 0.18, active = 0.12, recovery = 0.34,
					damage = 13, hitbox = box(6, 3.5, 3.5, 0.5), kbBase = 34, kbGrowth = 74, kbAngle = 34, selfVelocity = Vector2.new(18, 0),
					windup = { Root = { 6, 30, 0, 0, -0.2, 0.1 }, Waist = { 8, 40, 0 }, Neck = { 0, -20, 0 }, RS = { 120, 0, 60 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 70, 0, 0 }, RH = { -20, 0, 10 }, RK = { -50, 0, 0 } },
					strike = { Root = { 10, -40, 0, 0, -0.1, -0.1 }, Waist = { 10, -50, 0 }, Neck = { 0, 20, 0 }, RS = { 80, 0, 80 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -50 }, LE = { 40, 0, 0 }, RH = { 100, 0, 20 }, RK = { -6, 0, 0 }, RA = { 10, 0, 0 } },
					follow = { Root = { 12, -50, 0, 0, -0.1, -0.14 }, Waist = { 12, -60, 0 }, Neck = { 0, 24, 0 }, RS = { 84, 0, 84 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 64, 0, -54 }, LE = { 40, 0, 0 }, RH = { 108, 0, 24 }, RK = { 0, 0, 0 }, RA = { 14, 0, 0 } },
					spin = { axis = "y", degrees = 360 }, trail = "rightFoot", hitText = "VLAN !",
				},
				-- ↓K : la tour posée au sol, il s'appuie dessus d'une main et balaie les chevilles
				K_down = {
					label = "Balayette appuyée", startup = 0.14, active = 0.14, recovery = 0.3,
					damage = 9, hitbox = box(7, 2, 3.5, -1.6), kbBase = 28, kbGrowth = 52, kbAngle = 75,
					windup = { Root = { 12, 10, 0, 0, -0.85, 0.1 }, Waist = { 16, 14, 0 }, Neck = { 6, 0, 0 }, RS = { 60, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -40 }, LE = { 80, 0, 0 }, LH = { -30, 0, 0 }, LK = { -40, 0, 0 } },
					strike = { Root = { 16, -20, 0, 0, -0.95, -0.1 }, Waist = { 20, -26, 0 }, Neck = { 6, 0, 0 }, RS = { 50, 0, 40 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 80, 0, 0 }, LH = { 50, 0, -20 }, LK = { -4, 0, 0 }, LA = { 20, 0, 0 } },
					follow = { Root = { 18, -26, 0, 0, -0.95, -0.14 }, Waist = { 22, -32, 0 }, Neck = { 6, 0, 0 }, RS = { 52, 0, 42 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 34, 0, -42 }, LE = { 80, 0, 0 }, LH = { 56, 0, -24 }, LK = { 0, 0, 0 }, LA = { 24, 0, 0 } },
					trail = "leftFoot", fx = { "dust" }, hitText = "FAUCHÉ !",
				},
				-- ↑K : coup de pied monté, la tour levée au-dessus de la tête comme un trophée
				K_up = {
					label = "Pied monté trophée", startup = 0.16, active = 0.12, recovery = 0.32,
					damage = 11, hitbox = box(4.5, 6, 1.5, 3.5), kbBase = 30, kbGrowth = 66, kbAngle = 88,
					windup = { Root = { 10, 0, 0, 0, -0.25, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 100, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 100, 0, -20 }, LE = { 60, 0, 0 }, RH = { -20, 0, 0 }, RK = { -60, 0, 0 } },
					strike = { Root = { -16, 0, 0, 0, 0.05, -0.1 }, Waist = { -20, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 176, 0, 12 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 176, 0, -12 }, LE = { 10, 0, 0 }, RH = { 140, 0, 0 }, RK = { -6, 0, 0 }, RA = { 20, 0, 0 } },
					follow = { Root = { -18, 0, 0, 0, 0.08, -0.12 }, Waist = { -22, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 180, 0, 14 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 180, 0, -14 }, LE = { 10, 0, 0 }, RH = { 148, 0, 0 }, RK = { 0, 0, 0 }, RA = { 24, 0, 0 } },
					trail = "rightFoot", hitText = "KLANG !",
				},
				-- K en l'air : double coup de pied en pédalant, la tour serrée contre le ventre
				K_air = {
					label = "Pédalage lesté", startup = 0.12, active = 0.2, recovery = 0.22,
					damage = 10, hits = 2, hitbox = box(5, 4, 2.5, -0.5), kbBase = 22, kbGrowth = 48, kbAngle = 40,
					windup = { Root = { -10, 0, 0 }, Waist = { -8, 0, 0 }, RS = { 50, 0, 10 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -10 }, LE = { 110, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { -20, 0, 0 }, LK = { -40, 0, 0 } },
					strike = { Root = { -6, 0, 0 }, Waist = { 6, 0, 0 }, RS = { 54, 0, 12 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 54, 0, -12 }, LE = { 110, 0, 0 }, RH = { 90, 0, 0 }, RK = { -6, 0, 0 }, RA = { 10, 0, 0 }, LH = { 70, 0, 0 }, LK = { -110, 0, 0 } },
					follow = { Root = { -4, 0, 0 }, Waist = { 8, 0, 0 }, RS = { 56, 0, 14 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 56, 0, -14 }, LE = { 110, 0, 0 }, RH = { 20, 0, 0 }, RK = { -60, 0, 0 }, LH = { 95, 0, 0 }, LK = { -4, 0, 0 }, LA = { 10, 0, 0 } },
					trail = "bothFeet", hitText = "TAC TAC !",
				},
				-- dash K : il se couche sur la tour et glisse dessus comme sur une luge, pieds devant
				K_dash = {
					label = "Luge de tour", startup = 0.1, active = 0.26, recovery = 0.32,
					damage = 12, hitbox = box(6, 3, 3, -0.8), kbBase = 32, kbGrowth = 68, kbAngle = 36, selfVelocity = Vector2.new(55, 10),
					windup = { Root = { -8, 0, 0, 0, -0.4, 0 }, Waist = { -10, 0, 0 }, RS = { 60, 0, 40 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -40 } },
					strike = { Root = { 20, 0, 0, 0, -0.7, 0.2 }, Waist = { 10, 0, 0 }, RS = { -30, 0, 50 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -40 }, LE = { 30, 0, 0 }, RH = { 85, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 }, LH = { 80, 0, 0 }, LK = { -10, 0, 0 } },
					follow = { Root = { 24, 0, 0, 0, -0.72, 0.24 }, Waist = { 12, 0, 0 }, RS = { -36, 0, 55 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 75, 0, -45 }, LE = { 30, 0, 0 }, RH = { 90, 0, 0 }, RK = { 0, 0, 0 }, RA = { 14, 0, 0 }, LH = { 85, 0, 0 }, LK = { -10, 0, 0 } },
					trail = "bothFeet", fx = { "dust", { "particles", tex = "spark", color = VIOLET, dir = "up", at = "feet", time = 0.3, speed = 10, size = 0.4, rate = 50 } }, hitText = "SKRRRT !",
				},
				-- L : surchauffe : la tour vire au rouge, les ventilos hurlent et un souffle brûlant balaie tout le couloir
				S_neutral = {
					label = "Surchauffe", startup = 0.24, active = 0.22, recovery = 0.5, hits = 2,
					damage = 7, hitbox = box(14, 5, 7, 1), kbBase = 26, kbGrowth = 48, kbAngle = 30,
					status = { name = "burning", duration = 2 },
					windup = { Root = { 6, 0, 0, 0, -0.3, 0.2 }, Waist = { 8, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 50, 0, 10 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -10 }, LE = { 110, 0, 0 } },
					strike = { Root = { -12, 0, 0, 0, -0.35, -0.3 }, Waist = { -14, 0, 0 }, Neck = { -16, 0, 0 }, RS = { 92, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, -6 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -14, 0, 0, 0, -0.36, -0.34 }, Waist = { -16, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 94, 0, 8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 94, 0, -8 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					shake = true, windupFx = { { "particles", tex = "smoke", color = ROUGE, dir = "up", at = "hand", time = 0.25, speed = 6, size = 0.5, rate = 40 } },
					fx = { { "beam", color = ROUGE, length = 14, width = 4, at = "hand" }, { "particles", tex = "fire", color = ORANGE, dir = "front", at = "hand", time = 0.4, speed = 24, size = 0.8, rate = 90 }, { "text", text = "95 °C", color = ROUGE, at = "above" } },
					text = "ÇA CHAUFFE !", hitText = "GRILLÉ !",
				},
				-- →L : il balance la tour entière à deux mains : elle traverse le couloir en vrille, câbles au vent
				S_side = {
					label = "Lancer de tour", kind = "projectile", startup = 0.26, active = 0, recovery = 0.55,
					damage = 16, kbBase = 34, kbGrowth = 66, kbAngle = 32,
					projectile = { speed = 70, angle = 0, gravity = 0, lifetime = 0.7, size = 2.4, color = NOIR,
						visual = { shape = "block", size = 2, color = NOIR, spin = 8, parts = { { "block", Vector3.new(0.1, 1.6, 0.8), Vector3.new(1.05, 0, 0), BLEU }, { "cyl", Vector3.new(0.3, 0.7, 0.7), Vector3.new(0, -0.3, -1.0), VIOLET } } } },
					windup = { Root = { 8, -34, 0, 0, -0.3, 0.3 }, Waist = { 10, -38, 0 }, Neck = { 4, 22, 0 }, RS = { 150, 0, 30 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -30 }, LE = { 50, 0, 0 } },
					strike = { Root = { -16, 22, 0, 0, -0.36, -0.5 }, Waist = { -18, 26, 0 }, Neck = { -6, -14, 0 }, RS = { 94, 0, 4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 94, 0, -4 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					follow = { Root = { -18, 26, 0, 0, -0.38, -0.55 }, Waist = { -20, 30, 0 }, Neck = { -8, -16, 0 }, RS = { 98, 0, 6 }, RE = { 4, 0, 0 }, RW = { 10, 0, 0 }, LS = { 98, 0, -6 }, LE = { 4, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.52 } },
					hideProp = "tour", fx = { { "burst", color = BLEU, size = 2.5, at = "hand" }, { "shake", amount = 0.2 } }, text = "TIENS, PRENDS ÇA !", hitText = "KRRRASH !",
				},
				-- ↓L : il abat la tour sur le sol comme une masse : l'onde de choc file au ras du sol sur tout le couloir
				S_down = {
					label = "Masse de tour", startup = 0.24, active = 0.18, recovery = 0.55,
					damage = 14, hitbox = box(14, 4, 7, -0.5), kbBase = 30, kbGrowth = 58, kbAngle = 62,
					status = { name = "stunned", duration = 1 },
					windup = { Root = { -10, 0, 0, 0, -0.2, 0.1 }, Waist = { -24, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 190, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 190, 0, -10 }, LE = { 30, 0, 0 } },
					strike = { Root = { 22, 0, 0, 0, -0.9, -0.3 }, Waist = { 32, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -10 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { 24, 0, 0, 0, -0.95, -0.34 }, Waist = { 34, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 34, 0, 12 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 34, 0, -12 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					hold = 0.12, trail = "prop", fx = { "thud", { "ring", color = BLEU, radius = 8, at = "feet" }, { "beam", color = VIOLET, length = 14, width = 3, at = "feet" }, { "shake", amount = 0.5 } },
					text = "BOUM !", hitText = "ÉCRASÉ !",
				},
				-- ↑L : les ventilos tournent à fond : la tour serrée contre lui fait réacteur et il décolle en diagonale
				S_up = {
					label = "Décollage ventilos", startup = 0.14, active = 0.3, recovery = 0.42,
					damage = 13, hitbox = box(10, 11, 3, 4), kbBase = 32, kbGrowth = 54, kbAngle = 74, selfVelocity = Vector2.new(42, 82),
					windup = { Root = { 6, 0, 0, 0, -0.8, 0.1 }, Waist = { -10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 40, 0, 10 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -10 }, LE = { 120, 0, 0 } },
					strike = { Root = { -40, 0, 0, 0, 0.4, -0.2 }, Waist = { -6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 60, 0, 6 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -6 }, LE = { 110, 0, 0 }, RH = { -25, 0, 5 }, RK = { -30, 0, 0 }, LH = { -15, 0, -5 }, LK = { -50, 0, 0 } },
					follow = { Root = { -44, 0, 0, 0, 0.45, -0.25 }, Waist = { -8, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 64, 0, 8 }, RE = { 112, 0, 0 }, RW = { 0, 0, 0 }, LS = { 64, 0, -8 }, LE = { 112, 0, 0 }, RH = { -30, 0, 6 }, RK = { -35, 0, 0 }, LH = { -20, 0, -6 }, LK = { -55, 0, 0 } },
					shake = true, trail = "body", fx = { { "particles", tex = "smoke", color = VIOLET, dir = "down", at = "feet", time = 0.5, speed = 18, size = 0.7, rate = 90 }, { "ring", color = VIOLET, radius = 5, at = "feet" } },
					text = "VROOOM !", hitText = "ASPIRÉ !",
				},
				-- L en l'air : il brandit la tour au-dessus de lui et la plante vers le bas : pilon sur tout ce qui est dessous
				S_air = {
					label = "Pilon de tour", startup = 0.16, active = 0.3, recovery = 0.45,
					damage = 14, hitbox = box(8, 6, 1, -2), kbBase = 28, kbGrowth = 60, kbAngle = -60, selfVelocity = Vector2.new(6, -80),
					windup = { Root = { -8, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 180, 0, 14 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 180, 0, -14 }, LE = { 30, 0, 0 }, RH = { 80, 0, 0 }, RK = { -110, 0, 0 }, LH = { 80, 0, 0 }, LK = { -110, 0, 0 } },
					strike = { Root = { -30, 0, 0 }, Waist = { -30, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 20, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -10 }, LE = { 0, 0, 0 }, RH = { -10, 0, 6 }, RK = { -10, 0, 0 }, RA = { -20, 0, 0 }, LH = { -10, 0, -6 }, LK = { -10, 0, 0 }, LA = { -20, 0, 0 } },
					follow = { Root = { -34, 0, 0 }, Waist = { -32, 0, 0 }, Neck = { -22, 0, 0 }, RS = { 22, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 22, 0, -12 }, LE = { 0, 0, 0 }, RH = { -12, 0, 6 }, RK = { -14, 0, 0 }, RA = { -20, 0, 0 }, LH = { -12, 0, -6 }, LK = { -14, 0, 0 }, LA = { -20, 0, 0 } },
					trail = "prop", fx = { { "burst", color = BLEU, size = 3, at = "feet" }, { "shake", amount = 0.4 } }, text = "PILON !", hitText = "PLANTÉ !",
				},
				-- Y : mise à jour forcée : il pose la tour, appuie sur le bouton et une barre de progression bleue géante traverse le couloir à 1 %… tout le monde attend
				SUPER = {
					label = "Mise à jour forcée !", startup = 0.4, active = 0.25, recovery = 0.7,
					damage = 24, hitbox = box(16, 8, 8, 2), kbBase = 40, kbGrowth = 80, kbAngle = 35,
					status = { name = "waiting", duration = 3 },
					windup = { Root = { 10, 0, 0, 0, -0.6, 0.1 }, Waist = { 20, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 20 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 80, 0, 0 } },
					strike = { Root = { -8, 0, 0, 0, -0.3, -0.2 }, Waist = { -10, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 90, 0, 0 }, RE = { 10, 0, 0 }, RW = { -30, 0, 0 }, LS = { 30, 0, -30 }, LE = { 110, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { -6, 0, 0, 0, -0.25, -0.1 }, Waist = { -6, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 40, 0, 30 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 100, 0, 0 } },
					hold = 0.4, windupFx = { "super", { "text", text = "NE PAS ÉTEINDRE", color = BSOD, at = "above" } },
					fx = { { "beam", color = BSOD, length = 18, width = 5, at = "feet" }, { "screen", color = BSOD, alpha = 0.3 }, { "text", text = "MISE À JOUR 1 %…", color = BLANC, at = "above" }, { "symbols", symbols = { "⏳", "1 %", "2 %" }, count = 6, radius = 5, color = BLANC } },
					text = "ATTENDEZ…", hitText = "PATIENTEZ !",
				},
				-- →Y : tour-bélier : il serre la tour contre lui, baisse la tête et fonce à travers tout le couloir comme un chariot de supermarché fou
				SUPER_side = {
					label = "Tour-bélier !", startup = 0.35, active = 0.32, recovery = 0.7,
					damage = 26, hitbox = box(16, 6, 8, 0.8), kbBase = 48, kbGrowth = 100, kbAngle = 30, selfVelocity = Vector2.new(72, 0), armor = true,
					windup = { Root = { 10, 0, 0, 0, -0.3, 0.3 }, Waist = { 16, 0, 0 }, Neck = { -16, 0, 0 }, RS = { 60, 0, 10 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 110, 0, 0 } },
					strike = { Root = { 26, 0, 0, 0, -0.4, -0.5 }, Waist = { 26, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 94, 0, 4 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 94, 0, -4 }, LE = { 30, 0, 0 }, RH = { 60, 0, 0 }, RK = { -40, 0, 0 } },
					follow = { Root = { 28, 0, 0, 0, -0.42, -0.55 }, Waist = { 28, 0, 0 }, Neck = { -26, 0, 0 }, RS = { 96, 0, 6 }, RE = { 28, 0, 0 }, RW = { 0, 0, 0 }, LS = { 96, 0, -6 }, LE = { 28, 0, 0 }, LH = { 60, 0, 0 }, LK = { -40, 0, 0 } },
					shake = true, trail = "prop", windupFx = { "super", { "symbols", symbols = { "💢", "🖥️" }, count = 5, radius = 3, color = ROUGE } },
					fx = { "dust", { "beam", color = VIOLET, length = 16, width = 4, at = "root" }, { "burst", color = BLEU, size = 4, at = "front" }, { "shake", amount = 0.5 } },
					text = "DÉGAGEZ !", hitText = "ENCASTRÉ !",
				},
				-- ↑Y : overclock : il pousse tous les curseurs à fond, la tour explose sous ses pieds et le propulse au plafond dans une gerbe de LED
				SUPER_up = {
					label = "Overclock !", startup = 0.38, active = 0.3, recovery = 0.7,
					damage = 24, hitbox = box(16, 12, 8, 5), kbBase = 46, kbGrowth = 96, kbAngle = 86, invuln = 0.3, selfVelocity = Vector2.new(0, 55),
					windup = { Root = { 10, 0, 0, 0, -0.9, 0.1 }, Waist = { 20, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 40, 0, 20 }, RE = { 110, 0, 0 }, RW = { -30, 0, 0 }, LS = { 40, 0, -20 }, LE = { 110, 0, 0 }, LW = { -30, 0, 0 } },
					strike = { Root = { 4, 0, 0, 0, 0.5, 0 }, Waist = { 14, 0, 0 }, Neck = { 46, 0, 0 }, RS = { 184, 0, 20 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 184, 0, -20 }, LE = { 0, 0, 0 }, RH = { 40, 0, 10 }, RK = { -90, 0, 0 }, LH = { 20, 0, -15 }, LK = { -60, 0, 0 } },
					follow = { Root = { 8, 0, 0, 0, 0.55, 0 }, Waist = { 20, 0, 0 }, Neck = { 52, 0, 0 }, RS = { 188, 0, 24 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 188, 0, -24 }, LE = { 0, 0, 0 }, RH = { 60, 0, 20 }, RK = { -110, 0, 0 }, LH = { 10, 0, -25 }, LK = { -40, 0, 0 } },
					hold = 0.2, shake = true, spin = { axis = "y", degrees = 360 }, hideProp = "tour",
					windupFx = { "super", { "text", text = "5,8 GHz", color = VERT, at = "above" } },
					fx = { { "pillar", color = VIOLET, height = 22, width = 3, at = "front" }, { "burst", color = ROUGE, size = 5, at = "feet" }, { "toss", shape = "block", color = NOIR, size = 0.6, count = 8, speed = 26 }, { "particles", tex = "fire", color = ORANGE, dir = "all", at = "feet", time = 0.5, speed = 16, size = 0.7, rate = 90 }, { "shake", amount = 0.6 } },
					text = "OVERCLOCK !", hitText = "KABOUM !",
				},
				-- ↓Y : court-circuit : il arrache l'alim et plante les deux fils dans le sol : les éclairs courent des deux côtés sur toute la plateforme
				SUPER_down = {
					label = "Court-circuit !", startup = 0.4, active = 0.2, recovery = 0.7,
					damage = 22, hitbox = box(34, 6, 0, 1), kbBase = 36, kbGrowth = 64, kbAngle = 60,
					status = { name = "stunned", duration = 2 },
					windup = { Root = { 0, 0, 0, 0, -0.3, 0 }, Waist = { -6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 150, 0, 40 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -40 }, LE = { 20, 0, 0 } },
					strike = { Root = { 22, 0, 0, 0, -0.95, -0.2 }, Waist = { 30, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 30, 0, 30 }, RE = { 0, 0, 0 }, RW = { -30, 0, 0 }, LS = { 30, 0, -30 }, LE = { 0, 0, 0 }, LW = { -30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { 24, 0, 0, 0, -1.0, -0.24 }, Waist = { 32, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 26, 0, 32 }, RE = { 0, 0, 0 }, RW = { -40, 0, 0 }, LS = { 26, 0, -32 }, LE = { 0, 0, 0 }, LW = { -40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
					hold = 0.3, shake = true, windupFx = { "super", { "particles", tex = "spark", color = BLEU, dir = "all", at = "hand", time = 0.3, speed = 10, size = 0.4, rate = 60 } },
					fx = { { "beam", color = BLEU, length = 34, width = 2.5, at = "feet" }, { "ring", color = VERT, radius = 10, at = "feet" }, { "ring", color = BLEU, radius = 17, at = "feet" }, { "particles", tex = "spark", color = BLEU, dir = "all", at = "feet", time = 0.5, speed = 24, size = 0.6, rate = 120 }, { "shake", amount = 0.5 } },
					text = "BZZZZT !", hitText = "ÉLECTROCUTÉ !",
				},
			},
			links = {
				P_neutral = { P = "P_side", K = "K_neutral", S = "S_down" },
				P_side = { P = "P_up", K = "K_side", S = "S_side" },
				P_down = { P = "P_up", K = "K_down", S = "S_down" },
				K_neutral = { P = "P_neutral", K = "K_side", S = "S_neutral" },
				P_dash = { P = "P_side", K = "K_side", S = "S_side" },
				K_dash = { P = "P_up", S = "S_up" },
			},
		},
		{ id = "zapper", name = "Pistolet optique", icon = "🔫",
			prop = { name = "PropZapper", hand = "Right", pieces = {
				{ "Crosse", "", "block", Vector3.new(0.3, 0.7, 0.4), Vector3.new(0, -0.35, 0.1), Vector3.new(-15, 0, 0), ORANGE, "SmoothPlastic" },
				{ "Canon", "", "cyl", Vector3.new(0.26, 0.26, 1.3), Vector3.new(0, -0.1, -0.7), Vector3.zero, GRIS, "SmoothPlastic", { axis = "z" } },
				{ "Viseur", "", "block", Vector3.new(0.1, 0.18, 0.5), Vector3.new(0, 0.1, -0.6), Vector3.zero, NOIR, "SmoothPlastic" },
				{ "Bout", "", "ball", Vector3.new(0.3, 0.3, 0.3), Vector3.new(0, -0.1, -1.4), Vector3.zero, VERT, "Neon", { neon = true, light = { VERT, 6, 1 } } },
			} },
			ability = { reach = 1.2, text = "Visée longue : portée de tous les coups +20 %" },
			moves = {
				-- J : coup de crosse sec sur le nez, le pistolet retourné dans la main
				P_neutral = {
					label = "Coup de crosse", startup = 0.07, active = 0.08, recovery = 0.14,
					damage = 5, hitbox = box(4, 3, 2.6, 0.8), kbBase = 18, kbGrowth = 22, kbAngle = 25,
					windup = { Root = { 2, -12, 0, 0, -0.15, 0.1 }, Waist = { 2, -16, 0 }, Neck = { -6, 10, 0 }, RS = { 50, 0, 20 }, RE = { 120, 0, 0 }, RW = { 60, 0, 0 }, LS = { 30, 0, -20 }, LE = { 90, 0, 0 } },
					strike = { Root = { -6, 10, 0, 0, -0.22, -0.25 }, Waist = { -8, 14, 0 }, Neck = { -8, -8, 0 }, RS = { 92, 0, 0 }, RE = { 10, 0, 0 }, RW = { 90, 0, 0 }, LS = { 20, 0, -30 }, LE = { 90, 0, 0 } },
					follow = { Root = { -8, 14, 0, 0, -0.24, -0.3 }, Waist = { -10, 18, 0 }, Neck = { -10, -10, 0 }, RS = { 88, 0, 6 }, RE = { 16, 0, 0 }, RW = { 80, 0, 0 }, LS = { 16, 0, -32 }, LE = { 90, 0, 0 } },
					trail = "prop", hitText = "TOC !",
				},
				-- →J : tir laser, bras tendu, un œil fermé : un petit trait orange file droit devant
				P_side = {
					label = "Tir laser", kind = "projectile", startup = 0.09, active = 0, recovery = 0.2,
					damage = 6, kbBase = 20, kbGrowth = 32, kbAngle = 25,
					projectile = { speed = 95, angle = 0, gravity = 0, lifetime = 0.32, size = 1, color = ORANGE, aim = false,
						visual = { shape = "ball", size = 0.8, color = ORANGE, neon = true } },
					windup = { Root = { 0, -20, 0, 0, -0.15, 0.1 }, Waist = { 0, -24, 0 }, Neck = { 0, 16, -8 }, RS = { 70, 0, 10 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 90, 0, 0 } },
					strike = { Root = { -4, 18, 0, 0, -0.2, -0.2 }, Waist = { -4, 22, 0 }, Neck = { -4, -14, -8 }, RS = { 94, 0, -4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { -2, 18, 0, 0, -0.18, -0.15 }, Waist = { -2, 22, 0 }, Neck = { -4, -14, -8 }, RS = { 102, 0, -4 }, RE = { 10, 0, 0 }, RW = { 20, 0, 0 }, LS = { 20, 0, -30 }, LE = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					fx = { { "burst", color = ORANGE, size = 1, at = "hand" } }, text = "PIOU !", hitText = "TOUCHÉ !",
				},
				-- ↓J : accroupi, il tire au ras du sol dans les tibias
				P_down = {
					label = "Tir dans les tibias", kind = "projectile", startup = 0.1, active = 0, recovery = 0.22,
					damage = 6, kbBase = 20, kbGrowth = 30, kbAngle = 70,
					projectile = { speed = 90, angle = 0, gravity = 0, lifetime = 0.3, size = 1, color = ORANGE, aim = false, from = "feet",
						visual = { shape = "ball", size = 0.8, color = ORANGE, neon = true } },
					windup = { Root = { 10, -14, 0, 0, -0.85, 0.1 }, Waist = { 16, -16, 0 }, Neck = { 6, 10, 0 }, RS = { 50, 0, 20 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 90, 0, 0 }, LH = { -40, 0, 0 }, LK = { -40, 0, 0 } },
					strike = { Root = { 14, 10, 0, 0, -0.95, -0.15 }, Waist = { 22, 12, 0 }, Neck = { 4, -8, 0 }, RS = { 70, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { 14, 10, 0, 0, -0.95, -0.15 }, Waist = { 22, 12, 0 }, Neck = { 4, -8, 0 }, RS = { 76, 0, 0 }, RE = { 6, 0, 0 }, RW = { 20, 0, 0 }, LS = { 30, 0, -30 }, LE = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					fx = { { "burst", color = ORANGE, size = 0.8, at = "hand" } }, text = "PIOU !", hitText = "AÏE LE TIBIA !",
				},
				-- ↑J : tir en cloche vers le ciel, le pistolet tenu à deux mains comme un sniper
				P_up = {
					label = "Tir en cloche", kind = "projectile", startup = 0.1, active = 0, recovery = 0.22,
					damage = 7, kbBase = 22, kbGrowth = 36, kbAngle = 85,
					projectile = { speed = 80, angle = 70, gravity = 0, lifetime = 0.35, size = 1, color = ORANGE, aim = false,
						visual = { shape = "ball", size = 0.8, color = ORANGE, neon = true } },
					windup = { Root = { 6, 0, 0, 0, -0.25, 0.1 }, Waist = { 8, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 10 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 100, 0, 0 } },
					strike = { Root = { -12, 0, 0, 0, 0.05, -0.1 }, Waist = { -16, 0, 0 }, Neck = { -30, 0, 0 }, RS = { 160, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -6 }, LE = { 20, 0, 0 } },
					follow = { Root = { -14, 0, 0, 0, 0.08, -0.12 }, Waist = { -18, 0, 0 }, Neck = { -34, 0, 0 }, RS = { 166, 0, 8 }, RE = { 6, 0, 0 }, RW = { 10, 0, 0 }, LS = { 154, 0, -8 }, LE = { 20, 0, 0 } },
					fx = { { "burst", color = ORANGE, size = 1, at = "hand" } }, text = "PIOU !", hitText = "EN L'AIR !",
				},
				-- J en l'air : tir plongeant, pistolet pointé en bas entre ses pieds
				P_air = {
					label = "Tir plongeant", kind = "projectile", startup = 0.1, active = 0, recovery = 0.2,
					damage = 7, kbBase = 20, kbGrowth = 36, kbAngle = -40,
					projectile = { speed = 90, angle = -55, gravity = 0, lifetime = 0.35, size = 1, color = ORANGE, aim = false,
						visual = { shape = "ball", size = 0.8, color = ORANGE, neon = true } },
					windup = { Root = { 6, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 120, 0, 10 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 80, 0, 0 }, RH = { 40, 0, 0 }, RK = { -80, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { 14, 0, 0 }, Waist = { 22, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 20, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 60, 0, 0 }, RH = { 30, 0, 10 }, RK = { -60, 0, 0 }, LH = { 30, 0, -10 }, LK = { -60, 0, 0 } },
					follow = { Root = { 16, 0, 0 }, Waist = { 24, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 26, 0, 10 }, RE = { 6, 0, 0 }, RW = { 20, 0, 0 }, LS = { 30, 0, -40 }, LE = { 60, 0, 0 }, RH = { 28, 0, 10 }, RK = { -56, 0, 0 }, LH = { 28, 0, -10 }, LK = { -56, 0, 0 } },
					fx = { { "burst", color = ORANGE, size = 1, at = "hand" } }, text = "PIOU !", hitText = "DANS LE MILLE !",
				},
				-- dash J : il tire deux fois en courant, bras tendu, l'autre bras en balancier
				P_dash = {
					label = "Double tir en courant", kind = "projectile", startup = 0.08, active = 0, recovery = 0.22,
					damage = 5, kbBase = 20, kbGrowth = 32, kbAngle = 28, selfVelocity = Vector2.new(30, 0),
					projectile = { speed = 95, angle = 0, gravity = 0, lifetime = 0.32, size = 1, color = ORANGE, aim = false, fan = { count = 2, from = -4, to = 6 },
						visual = { shape = "ball", size = 0.8, color = ORANGE, neon = true } },
					windup = { Root = { 8, -16, 0, 0, -0.15, 0.15 }, Waist = { 8, -20, 0 }, Neck = { 0, 12, 0 }, RS = { 60, 0, 10 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { -30, 0, -20 }, LE = { 60, 0, 0 } },
					strike = { Root = { 10, 14, 0, 0, -0.2, -0.3 }, Waist = { 10, 18, 0 }, Neck = { -6, -10, 0 }, RS = { 96, 0, -2 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -25 }, LE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { 10, 14, 0, 0, -0.2, -0.32 }, Waist = { 10, 18, 0 }, Neck = { -6, -10, 0 }, RS = { 100, 0, -2 }, RE = { 8, 0, 0 }, RW = { 16, 0, 0 }, LS = { -40, 0, -25 }, LE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					fx = { { "burst", color = ORANGE, size = 1, at = "hand" } }, text = "PIOU PIOU !", hitText = "TOUCHÉ !",
				},
				-- K : coup de pied du cow-boy, le pistolet brandi en l'air comme pour un duel
				K_neutral = {
					label = "Coup de pied de duel", startup = 0.15, active = 0.1, recovery = 0.28,
					damage = 10, hitbox = box(5, 3.5, 3, 0.3), kbBase = 28, kbGrowth = 58, kbAngle = 35,
					windup = { Root = { 4, -10, 0, 0, -0.2, 0.1 }, Waist = { 4, -10, 0 }, Neck = { 0, 10, 0 }, RS = { 150, 0, 30 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 80, 0, 0 }, RH = { -30, 0, 0 }, RK = { -50, 0, 0 } },
					strike = { Root = { 8, 0, 0, 0, -0.1, 0.05 }, Waist = { 10, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 170, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -40 }, LE = { 60, 0, 0 }, RH = { 95, 0, 0 }, RK = { -4, 0, 0 }, RA = { 10, 0, 0 } },
					follow = { Root = { 12, 0, 0, 0, -0.1, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 174, 0, 32 }, RE = { 58, 0, 0 }, RW = { 0, 0, 0 }, LS = { 54, 0, -44 }, LE = { 56, 0, 0 }, RH = { 104, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 } },
					trail = "rightFoot", hitText = "YEEHAW !",
				},
				-- →K : coup de pied sauté en avant, il tire un coup au ciel pour fêter ça
				K_side = {
					label = "Pied sauté pistolero", startup = 0.16, active = 0.14, recovery = 0.3,
					damage = 12, hitbox = box(6, 3.5, 3.5, 0.5), kbBase = 32, kbGrowth = 66, kbAngle = 36, selfVelocity = Vector2.new(26, 16),
					windup = { Root = { 6, 20, 0, 0, -0.3, 0.1 }, Waist = { 8, 26, 0 }, Neck = { 0, -14, 0 }, RS = { 120, 0, 40 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 80, 0, 0 }, RH = { -20, 0, 0 }, RK = { -60, 0, 0 } },
					strike = { Root = { -6, -10, 0, 0, 0.2, -0.2 }, Waist = { -8, -14, 0 }, Neck = { 0, 10, 0 }, RS = { 176, 0, 24 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -50 }, LE = { 60, 0, 0 }, RH = { 100, 0, 10 }, RK = { -6, 0, 0 }, RA = { 10, 0, 0 }, LH = { -20, 0, -5 }, LK = { -70, 0, 0 } },
					follow = { Root = { -8, -14, 0, 0, 0.22, -0.24 }, Waist = { -10, -18, 0 }, Neck = { 0, 12, 0 }, RS = { 180, 0, 26 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 34, 0, -54 }, LE = { 60, 0, 0 }, RH = { 106, 0, 12 }, RK = { 0, 0, 0 }, RA = { 14, 0, 0 }, LH = { -24, 0, -5 }, LK = { -74, 0, 0 } },
					trail = "rightFoot", fx = { { "burst", color = ORANGE, size = 1, at = "hand" } }, hitText = "BANG !",
				},
				-- ↓K : balayette basse, le pistolet braqué entre ses genoux
				K_down = {
					label = "Balayette braquée", startup = 0.14, active = 0.14, recovery = 0.3,
					damage = 9, hitbox = box(7, 2, 3.5, -1.6), kbBase = 26, kbGrowth = 50, kbAngle = 74,
					windup = { Root = { 10, 10, 0, 0, -0.85, 0.1 }, Waist = { 14, 14, 0 }, Neck = { 6, 0, 0 }, RS = { 60, 0, 10 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -40 }, LE = { 80, 0, 0 }, LH = { -30, 0, 0 }, LK = { -40, 0, 0 } },
					strike = { Root = { 14, -20, 0, 0, -0.95, -0.1 }, Waist = { 18, -26, 0 }, Neck = { 6, 0, 0 }, RS = { 60, 0, 0 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 80, 0, 0 }, LH = { 50, 0, -20 }, LK = { -4, 0, 0 }, LA = { 20, 0, 0 } },
					follow = { Root = { 16, -26, 0, 0, -0.95, -0.14 }, Waist = { 20, -32, 0 }, Neck = { 6, 0, 0 }, RS = { 62, 0, 0 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 34, 0, -42 }, LE = { 80, 0, 0 }, LH = { 56, 0, -24 }, LK = { 0, 0, 0 }, LA = { 24, 0, 0 } },
					trail = "leftFoot", fx = { "dust" }, hitText = "FAUCHÉ !",
				},
				-- ↑K : coup de pied monté, il tire en même temps au-dessus de sa tête, par réflexe
				K_up = {
					label = "Pied monté réflexe", startup = 0.16, active = 0.12, recovery = 0.32,
					damage = 11, hitbox = box(4.5, 6, 1.5, 3.5), kbBase = 30, kbGrowth = 64, kbAngle = 88,
					windup = { Root = { 10, 0, 0, 0, -0.25, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 80, 0, 30 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -40 }, LE = { 60, 0, 0 }, RH = { -20, 0, 0 }, RK = { -60, 0, 0 } },
					strike = { Root = { -16, 0, 0, 0, 0.05, -0.1 }, Waist = { -20, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 176, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -50 }, LE = { 30, 0, 0 }, RH = { 140, 0, 0 }, RK = { -6, 0, 0 }, RA = { 20, 0, 0 } },
					follow = { Root = { -18, 0, 0, 0, 0.08, -0.12 }, Waist = { -22, 0, 0 }, Neck = { -28, 0, 0 }, RS = { 180, 0, 12 }, RE = { 0, 0, 0 }, RW = { 10, 0, 0 }, LS = { 34, 0, -52 }, LE = { 30, 0, 0 }, RH = { 148, 0, 0 }, RK = { 0, 0, 0 }, RA = { 24, 0, 0 } },
					trail = "rightFoot", fx = { { "burst", color = ORANGE, size = 1.2, at = "above" } }, hitText = "BANG-KLANG !",
				},
				-- K en l'air : coup de pied en ciseaux, pistolet braqué sur la cible pendant tout le saut
				K_air = {
					label = "Ciseaux braqués", startup = 0.12, active = 0.18, recovery = 0.2,
					damage = 10, hits = 2, hitbox = box(5, 4, 2.5, -0.5), kbBase = 22, kbGrowth = 46, kbAngle = 40,
					windup = { Root = { -8, 0, 0 }, Waist = { -6, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 92, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 80, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { -20, 0, 0 }, LK = { -40, 0, 0 } },
					strike = { Root = { -4, 0, 0 }, Waist = { 6, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 94, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 44, 0, -44 }, LE = { 80, 0, 0 }, RH = { 90, 0, 0 }, RK = { -6, 0, 0 }, RA = { 10, 0, 0 }, LH = { -30, 0, 0 }, LK = { -30, 0, 0 } },
					follow = { Root = { -2, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 96, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 46, 0, -46 }, LE = { 80, 0, 0 }, RH = { -30, 0, 0 }, RK = { -30, 0, 0 }, LH = { 95, 0, 0 }, LK = { -4, 0, 0 }, LA = { 10, 0, 0 } },
					trail = "bothFeet", hitText = "TCHAC TCHAC !",
				},
				-- dash K : roulade de tireur : il roule en avant et ressort pistolet braqué, pied en avant
				K_dash = {
					label = "Roulade de tireur", startup = 0.1, active = 0.22, recovery = 0.3,
					damage = 11, hitbox = box(6, 3, 3, -0.5), kbBase = 30, kbGrowth = 62, kbAngle = 38, selfVelocity = Vector2.new(50, 8),
					windup = { Root = { 20, 0, 0, 0, -0.6, 0 }, Waist = { 30, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 120, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -20 }, LE = { 60, 0, 0 } },
					strike = { Root = { 10, 0, 0, 0, -0.7, 0.1 }, Waist = { 10, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 94, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -50 }, LE = { 60, 0, 0 }, RH = { 85, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
					follow = { Root = { 12, 0, 0, 0, -0.72, 0.14 }, Waist = { 12, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 96, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 44, 0, -54 }, LE = { 60, 0, 0 }, RH = { 90, 0, 0 }, RK = { 0, 0, 0 }, RA = { 14, 0, 0 }, LH = { 64, 0, 0 }, LK = { -94, 0, 0 } },
					spin = { axis = "x", degrees = 360 }, trail = "rightFoot", fx = { "dust" }, hitText = "ROULÉ-BOULÉ !",
				},
				-- L : rafale optique : trois traits orange en éventail qui foncent tous sur l'adversaire
				S_neutral = {
					label = "Rafale optique", kind = "projectile", startup = 0.22, active = 0, recovery = 0.45,
					damage = 6, kbBase = 24, kbGrowth = 40, kbAngle = 30,
					projectile = { speed = 100, angle = 0, gravity = 0, lifetime = 0.6, size = 1.2, color = ORANGE, fan = { count = 3, from = -8, to = 8 },
						visual = { shape = "ball", size = 1, color = ORANGE, neon = true } },
					windup = { Root = { 2, -24, 0, 0, -0.2, 0.15 }, Waist = { 2, -28, 0 }, Neck = { 0, 18, -8 }, RS = { 70, 0, 10 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -10 }, LE = { 70, 0, 0 } },
					strike = { Root = { -8, 20, 0, 0, -0.28, -0.3 }, Waist = { -10, 24, 0 }, Neck = { -4, -14, -8 }, RS = { 94, 0, -4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, 0 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -8, 20, 0, 0, -0.28, -0.3 }, Waist = { -10, 24, 0 }, Neck = { -4, -14, -8 }, RS = { 104, 0, -4 }, RE = { 10, 0, 0 }, RW = { 24, 0, 0 }, LS = { 90, 0, 0 }, LE = { 30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					shake = true, fx = { { "burst", color = ORANGE, size = 1.6, at = "hand" } }, text = "PIOU PIOU PIOU !", hitText = "TRIPLÉ !",
				},
				-- →L : tir chargé : il retient son souffle, le bout vire au vert et un gros rayon part percer tout le couloir
				S_side = {
					label = "Tir chargé", kind = "projectile", startup = 0.3, active = 0, recovery = 0.5,
					damage = 15, kbBase = 32, kbGrowth = 62, kbAngle = 32,
					projectile = { speed = 115, angle = 0, gravity = 0, lifetime = 0.6, size = 2, color = VERT, pierce = true,
						visual = { shape = "cyl", size = 1.8, color = VERT, neon = true } },
					windup = { Root = { 4, -26, 0, 0, -0.25, 0.2 }, Waist = { 4, -30, 0 }, Neck = { 0, 20, -10 }, RS = { 92, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -10 }, LE = { 80, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -10, 22, 0, 0, -0.3, -0.35 }, Waist = { -12, 26, 0 }, Neck = { -4, -16, -10 }, RS = { 94, 0, -4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, 0 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					follow = { Root = { -4, 22, 0, 0, -0.26, -0.2 }, Waist = { -6, 26, 0 }, Neck = { -4, -16, -10 }, RS = { 108, 0, -4 }, RE = { 10, 0, 0 }, RW = { 30, 0, 0 }, LS = { 100, 0, 0 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					shake = true, windupFx = { { "particles", tex = "spark", color = VERT, dir = "all", at = "hand", time = 0.3, speed = 4, size = 0.3, rate = 60 } },
					fx = { { "beam", color = VERT, length = 16, width = 2, at = "hand" }, { "burst", color = VERT, size = 2.5, at = "hand" }, { "shake", amount = 0.3 } },
					text = "CHARGÉ… PIOUUU !", hitText = "PERCÉ !",
				},
				-- ↓L : tir à ricochet : accroupi, il tire dans le sol et le laser rebondit en zigzag jusqu'à l'adversaire
				S_down = {
					label = "Ricochet au sol", kind = "projectile", startup = 0.22, active = 0, recovery = 0.48,
					damage = 13, kbBase = 28, kbGrowth = 52, kbAngle = 60,
					projectile = { speed = 85, angle = -25, gravity = 70, lifetime = 0.8, size = 1.4, color = ORANGE, bounce = 3,
						visual = { shape = "ball", size = 1.2, color = ORANGE, neon = true } },
					windup = { Root = { 12, -10, 0, 0, -0.8, 0.1 }, Waist = { 18, -12, 0 }, Neck = { 10, 8, 0 }, RS = { 40, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 90, 0, 0 }, LH = { -40, 0, 0 }, LK = { -40, 0, 0 } },
					strike = { Root = { 16, 8, 0, 0, -0.9, -0.15 }, Waist = { 24, 10, 0 }, Neck = { 14, -6, 0 }, RS = { 50, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { 16, 8, 0, 0, -0.9, -0.15 }, Waist = { 24, 10, 0 }, Neck = { 14, -6, 0 }, RS = { 58, 0, 0 }, RE = { 8, 0, 0 }, RW = { 20, 0, 0 }, LS = { 40, 0, -30 }, LE = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					fx = { { "burst", color = ORANGE, size = 1.5, at = "feet" }, { "ring", color = ORANGE, radius = 3, at = "front" } }, text = "RICOCHET !", hitText = "PING PANG !",
				},
				-- ↑L : tir de recul : il tire dans le sol à deux mains si fort que le recul le propulse en diagonale, pied en avant
				S_up = {
					label = "Recul propulseur", startup = 0.14, active = 0.3, recovery = 0.42,
					damage = 13, hitbox = box(10, 11, 3, 4), kbBase = 30, kbGrowth = 52, kbAngle = 72, selfVelocity = Vector2.new(42, 82),
					windup = { Root = { 10, 0, 0, 0, -0.8, 0.1 }, Waist = { 16, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 30, 0, 10 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -10 }, LE = { 10, 0, 0 } },
					strike = { Root = { -42, 0, 0, 0, 0.4, -0.2 }, Waist = { -6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { -30, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -30, 0, -10 }, LE = { 0, 0, 0 }, RH = { 60, 0, 5 }, RK = { -10, 0, 0 }, LH = { -30, 0, -5 }, LK = { -60, 0, 0 } },
					follow = { Root = { -46, 0, 0, 0, 0.45, -0.25 }, Waist = { -8, 0, 0 }, Neck = { 32, 0, 0 }, RS = { -36, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -36, 0, -12 }, LE = { 0, 0, 0 }, RH = { 66, 0, 6 }, RK = { -10, 0, 0 }, LH = { -34, 0, -6 }, LK = { -64, 0, 0 } },
					shake = true, trail = "rightFoot", fx = { { "burst", color = ORANGE, size = 3, at = "feet" }, { "particles", tex = "spark", color = ORANGE, dir = "down", at = "feet", time = 0.4, speed = 16, size = 0.5, rate = 80 }, { "ring", color = ORANGE, radius = 4, at = "feet" } },
					text = "BANG… WOUSH !", hitText = "RECUL !",
				},
				-- L en l'air : pluie de lasers : tête en bas, il arrose tout ce qu'il y a dessous
				S_air = {
					label = "Pluie de lasers", kind = "projectile", startup = 0.15, active = 0, recovery = 0.4,
					damage = 6, kbBase = 24, kbGrowth = 44, kbAngle = -40,
					projectile = { speed = 80, angle = -70, gravity = 0, lifetime = 0.6, size = 1, color = ORANGE, rain = { count = 4, spread = 6 },
						visual = { shape = "ball", size = 0.9, color = ORANGE, neon = true } },
					windup = { Root = { 10, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 140, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 80, 0, 0 }, RH = { 40, 0, 0 }, RK = { -80, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { 30, 0, 0 }, Waist = { 30, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 10, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -50 }, LE = { 60, 0, 0 }, RH = { -20, 0, 10 }, RK = { -30, 0, 0 }, LH = { -20, 0, -10 }, LK = { -30, 0, 0 } },
					follow = { Root = { 34, 0, 0 }, Waist = { 32, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 14, 0, 12 }, RE = { 4, 0, 0 }, RW = { 10, 0, 0 }, LS = { 64, 0, -54 }, LE = { 60, 0, 0 }, RH = { -24, 0, 10 }, RK = { -34, 0, 0 }, LH = { -24, 0, -10 }, LK = { -34, 0, 0 } },
					fx = { { "burst", color = ORANGE, size = 2, at = "hand" } }, text = "ARROSAGE !", hitText = "CRIBLÉ !",
				},
				-- Y : headshot : il souffle sur le canon, ajuste la visée une seconde entière… et un seul énorme rayon part se loger pile entre les deux yeux
				SUPER = {
					label = "Headshot !", kind = "projectile", startup = 0.45, active = 0, recovery = 0.7,
					damage = 26, kbBase = 48, kbGrowth = 100, kbAngle = 28,
					projectile = { speed = 130, angle = 0, gravity = 0, lifetime = 0.6, size = 2.8, color = ROUGE, pierce = true, homing = 0.6,
						visual = { shape = "ball", size = 2.4, color = ROUGE, neon = true, spin = 12, text = "🎯" } },
					status = { name = "stunned", duration = 1.5 },
					windup = { Root = { 4, -30, 0, 0, -0.3, 0.2 }, Waist = { 4, -34, 0 }, Neck = { -4, 22, -14 }, RS = { 92, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, 0 }, LE = { 10, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -12, 24, 0, 0, -0.34, -0.45 }, Waist = { -14, 28, 0 }, Neck = { -8, -18, -14 }, RS = { 94, 0, -4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, 0 }, LE = { 4, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					follow = { Root = { 0, 24, 0, 0, -0.26, -0.1 }, Waist = { -2, 28, 0 }, Neck = { -8, -18, -14 }, RS = { 118, 0, -4 }, RE = { 14, 0, 0 }, RW = { 40, 0, 0 }, LS = { 104, 0, 0 }, LE = { 4, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					shake = true, windupFx = { "super", { "text", text = "🎯 …", color = ROUGE, at = "above" }, { "particles", tex = "spark", color = ROUGE, dir = "all", at = "hand", time = 0.4, speed = 3, size = 0.3, rate = 60 } },
					fx = { { "beam", color = ROUGE, length = 18, width = 3, at = "hand" }, { "burst", color = ROUGE, size = 4, at = "hand" }, { "shake", amount = 0.5 } },
					text = "HEADSHOT !", hitText = "ONE SHOT !",
				},
				-- →Y : balle qui rebondit : il tire en diagonale sur le décor et le laser ricoche dans tous les sens à travers le couloir, puis revient dans le canon
				SUPER_side = {
					label = "Laser-flipper !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.7,
					damage = 24, kbBase = 44, kbGrowth = 92, kbAngle = 40,
					projectile = { speed = 95, angle = 20, gravity = 60, lifetime = 1.2, size = 2.6, color = VERT, bounce = 5, returns = true, pierce = true,
						visual = { shape = "ball", size = 2.2, color = VERT, neon = true, spin = 14 } },
					status = { name = "inverted", duration = 2 },
					windup = { Root = { 6, -36, 0, 0, -0.3, 0.3 }, Waist = { 8, -40, 0 }, Neck = { -10, 24, 0 }, RS = { 130, 0, 20 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 80, 0, 0 } },
					strike = { Root = { -14, 26, 0, 0, -0.34, -0.5 }, Waist = { -16, 30, 0 }, Neck = { -16, -18, 0 }, RS = { 120, 0, -6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					follow = { Root = { -16, 30, 0, 0, -0.36, -0.55 }, Waist = { -18, 34, 0 }, Neck = { -18, -20, 0 }, RS = { 126, 0, -8 }, RE = { 6, 0, 0 }, RW = { 20, 0, 0 }, LS = { 46, 0, -44 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.52 } },
					windupFx = { "super", { "symbols", symbols = { "🔫", "💥" }, count = 6, radius = 3, color = VERT } },
					fx = { { "burst", color = VERT, size = 3.5, at = "hand" }, { "ring", color = VERT, radius = 5, at = "front" }, { "symbols", symbols = { "TILT", "BONUS" }, count = 4, radius = 4, color = ORANGE }, { "shake", amount = 0.3 } },
					text = "FLIPPER !", hitText = "TILT !",
				},
				-- ↑Y : feu d'artifice optique : il tire vers le ciel en tournant sur lui-même, une gerbe de lasers retombe sur tout le couloir et le soulève
				SUPER_up = {
					label = "Feu d'artifice optique !", startup = 0.38, active = 0.3, recovery = 0.7,
					damage = 24, hitbox = box(16, 12, 8, 5), kbBase = 46, kbGrowth = 96, kbAngle = 86, invuln = 0.3, selfVelocity = Vector2.new(0, 55),
					windup = { Root = { -8, 0, 0, 0, -0.9, 0 }, Waist = { -28, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 40, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 110, 0, 0 } },
					strike = { Root = { 6, 0, 0, 0, 0.5, 0 }, Waist = { 18, 0, 0 }, Neck = { 50, 0, 0 }, RS = { 186, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -60 }, LE = { 10, 0, 0 }, RH = { 40, 0, 10 }, RK = { -90, 0, 0 }, LH = { 20, 0, -15 }, LK = { -60, 0, 0 } },
					follow = { Root = { 10, 0, 0, 0, 0.55, 0 }, Waist = { 24, 0, 0 }, Neck = { 56, 0, 0 }, RS = { 188, 0, 10 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 156, 0, -66 }, LE = { 10, 0, 0 }, RH = { 60, 0, 20 }, RK = { -110, 0, 0 }, LH = { 10, 0, -25 }, LK = { -40, 0, 0 } },
					hold = 0.2, shake = true, spin = { axis = "y", degrees = 720 },
					windupFx = { "super", { "symbols", symbols = { "🎆", "🎇" }, count = 5, radius = 3, color = ORANGE } },
					fx = { { "pillar", color = ORANGE, height = 24, width = 3, at = "front" }, { "rain", shape = "ball", color = VERT, count = 12, radius = 7, size = 0.6 }, { "burst", color = ROUGE, size = 4, at = "above" }, { "ring", color = ORANGE, radius = 6, at = "feet" }, { "shake", amount = 0.4 } },
					text = "FEU D'ARTIFICE !", hitText = "PIOU-BOUM !",
				},
				-- ↓Y : tapis de lasers : il se couche sur le dos et tire en rafale vers le ciel, une pluie de traits retombe pile sur l'adversaire
				SUPER_down = {
					label = "Tapis de lasers !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.7,
					damage = 4, kbBase = 22, kbGrowth = 36, kbAngle = 50,
					projectile = { speed = 70, gravity = 40, lifetime = 1.2, size = 1.2, color = ORANGE, rain = { count = 8, spread = 6, ahead = 9, height = 22 },
						visual = { shape = "ball", size = 1, color = ORANGE, neon = true } },
					status = { name = "slowed", duration = 2.5 },
					windup = { Root = { -20, 0, 0, 0, -0.9, 0.2 }, Waist = { -20, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 120, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 90, 0, 0 } },
					strike = { Root = { -70, 0, 0, 0, -1.4, 0 }, Waist = { 0, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 170, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, 0 }, LE = { 0, 0, 0 }, RH = { 20, 0, 5 }, RK = { -20, 0, 0 }, LH = { 20, 0, -5 }, LK = { -20, 0, 0 } },
					follow = { Root = { -72, 0, 0, 0, -1.4, 0 }, Waist = { 0, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 176, 0, 4 }, RE = { 6, 0, 0 }, RW = { 20, 0, 0 }, LS = { 176, 0, -4 }, LE = { 6, 0, 0 }, RH = { 24, 0, 5 }, RK = { -24, 0, 0 }, LH = { 24, 0, -5 }, LK = { -24, 0, 0 } },
					hold = 0.3, shake = true, windupFx = { "super" },
					fx = { { "burst", color = ORANGE, size = 3, at = "hand" }, { "particles", tex = "spark", color = ORANGE, dir = "up", at = "hand", time = 0.5, speed = 30, size = 0.5, rate = 120 }, { "shake", amount = 0.3 } },
					text = "COUVERTURE !", hitText = "CRIBLÉ !",
				},
			},
			links = {
				P_neutral = { P = "P_side", K = "K_neutral", S = "S_neutral" },
				P_side = { P = "P_side", K = "K_side", S = "S_side" },
				P_down = { P = "P_up", K = "K_down", S = "S_down" },
				K_neutral = { P = "P_side", K = "K_side", S = "S_side" },
				K_side = { P = "P_up", K = "K_up", S = "S_neutral" },
				P_dash = { P = "P_side", S = "S_side" },
				K_dash = { P = "P_up", S = "S_up" },
			},
		},
	},

	look = {
		body = {
			head = PEAU, upper = SWEAT, lower = JOGGING, arms = SWEAT, forearms = SWEAT, hands = PEAU,
			legs = JOGGING, feet = BASKETS,
		},
		cubeHead = 1.25,
		parts = {
			-- cheveux en bataille, mèche rebelle
			{ "Cheveux", "Head", "ball", Vector3.new(1.45, 0.75, 1.45), Vector3.new(0, 0.55, 0.08), Vector3.zero, CHEVEUX, "Fabric" },
			{ "Meche", "Head", "wedge", Vector3.new(0.35, 0.55, 0.6), Vector3.new(0.15, 0.95, -0.25), Vector3.new(-20, 0, -15), CHEVEUX, "Fabric" },
			-- casque gamer RGB avec micro
			{ "Arceau", "Head", "block", Vector3.new(1.55, 0.22, 0.32), Vector3.new(0, 0.88, 0), Vector3.zero, NOIR, "SmoothPlastic" },
			{ "EcouteurG", "Head", "cyl", Vector3.new(0.36, 0.9, 0.9), Vector3.new(-0.74, 0, 0), Vector3.zero, NOIR, "SmoothPlastic", { axis = "x" } },
			{ "EcouteurD", "Head", "cyl", Vector3.new(0.36, 0.9, 0.9), Vector3.new(0.74, 0, 0), Vector3.zero, NOIR, "SmoothPlastic", { axis = "x" } },
			{ "LedG", "Head", "cyl", Vector3.new(0.06, 0.62, 0.62), Vector3.new(-0.94, 0, 0), Vector3.zero, VIOLET, "Neon", { axis = "x", neon = true } },
			{ "LedD", "Head", "cyl", Vector3.new(0.06, 0.62, 0.62), Vector3.new(0.94, 0, 0), Vector3.zero, VERT, "Neon", { axis = "x", neon = true, light = { VERT, 6, 1 } } },
			{ "Micro", "Head", "block", Vector3.new(0.1, 0.1, 0.75), Vector3.new(0.68, -0.4, -0.4), Vector3.new(0, -25, 0), NOIR, "SmoothPlastic" },
			{ "MicroBout", "Head", "ball", Vector3.new(0.2, 0.2, 0.2), Vector3.new(0.5, -0.4, -0.75), Vector3.zero, ROUGE, "Neon", { neon = true } },
			-- visage : yeux cernés, petite bouche crispée
			{ "OeilG", "Head", "ball", Vector3.new(0.3, 0.26, 0.1), Vector3.new(-0.27, 0.08, -0.62), Vector3.zero, BLANC, "SmoothPlastic" },
			{ "OeilD", "Head", "ball", Vector3.new(0.3, 0.26, 0.1), Vector3.new(0.27, 0.08, -0.62), Vector3.zero, BLANC, "SmoothPlastic" },
			{ "PupilleG", "Head", "ball", Vector3.new(0.12, 0.12, 0.08), Vector3.new(-0.27, 0.08, -0.67), Vector3.zero, NOIR, "SmoothPlastic" },
			{ "PupilleD", "Head", "ball", Vector3.new(0.12, 0.12, 0.08), Vector3.new(0.27, 0.08, -0.67), Vector3.zero, NOIR, "SmoothPlastic" },
			{ "Cernes", "Head", "block", Vector3.new(0.9, 0.1, 0.05), Vector3.new(0, -0.1, -0.63), Vector3.zero, Color3.fromRGB(150, 110, 150), "SmoothPlastic" },
			{ "Bouche", "Head", "block", Vector3.new(0.4, 0.08, 0.05), Vector3.new(0.05, -0.38, -0.63), Vector3.new(0, 0, -8), Color3.fromRGB(120, 50, 50), "SmoothPlastic" },
			-- sweat à capuche : capuche rabattue, poche kangourou, cordons, logo RGB
			{ "Capuche", "UpperTorso", "ball", Vector3.new(1.9, 0.85, 1.0), Vector3.new(0, 0.85, 0.45), Vector3.zero, SWEAT_FONCE, "Fabric" },
			{ "Poche", "UpperTorso", "block", Vector3.new(1.4, 0.6, 0.1), Vector3.new(0, -0.45, -0.52), Vector3.zero, SWEAT_FONCE, "Fabric" },
			{ "CordonG", "UpperTorso", "block", Vector3.new(0.08, 0.7, 0.06), Vector3.new(-0.3, 0.2, -0.53), Vector3.zero, BLANC, "Fabric" },
			{ "CordonD", "UpperTorso", "block", Vector3.new(0.08, 0.7, 0.06), Vector3.new(0.3, 0.2, -0.53), Vector3.zero, BLANC, "Fabric" },
			{ "Logo", "UpperTorso", "block", Vector3.new(0.45, 0.45, 0.05), Vector3.new(0.5, 0.35, -0.53), Vector3.new(0, 0, 45), BLEU, "Neon", { neon = true } },
		},
		props = {
			-- l'arme : la manette filaire, son câble pend comme un nunchaku
			{ name = "PropManette", hand = "Right", visible = true, pieces = {
				{ "Corps", "", "block", Vector3.new(0.35, 0.55, 1.2), Vector3.new(0, -0.3, 0), Vector3.zero, NOIR, "SmoothPlastic" },
				{ "PoigneeAv", "", "ball", Vector3.new(0.38, 0.6, 0.45), Vector3.new(0, -0.5, -0.45), Vector3.zero, NOIR, "SmoothPlastic" },
				{ "PoigneeAr", "", "ball", Vector3.new(0.38, 0.6, 0.45), Vector3.new(0, -0.5, 0.45), Vector3.zero, NOIR, "SmoothPlastic" },
				{ "Boutons", "", "block", Vector3.new(0.38, 0.2, 0.5), Vector3.new(0, -0.2, 0.2), Vector3.zero, ROUGE, "Neon", { neon = true } },
				{ "Cable", "", "cyl", Vector3.new(0.08, 2.6, 0.08), Vector3.new(0, -1.85, 0), Vector3.zero, NOIR, "SmoothPlastic", { axis = "y" } },
				{ "Prise", "", "block", Vector3.new(0.22, 0.35, 0.22), Vector3.new(0, -3.2, 0), Vector3.zero, Color3.fromRGB(160, 160, 170), "Metal" },
			} },
			-- clavier mécanique RGB (coup de clavier, clavier volant, combo clavier)
			{ name = "PropClavier", hand = "Right", visible = false, pieces = {
				{ "Base", "", "block", Vector3.new(0.25, 3.2, 1.0), Vector3.new(0, -1.5, 0), Vector3.zero, NOIR, "SmoothPlastic" },
				{ "Touches", "", "block", Vector3.new(0.28, 3.0, 0.82), Vector3.new(0.04, -1.5, 0), Vector3.zero, BLEU, "Neon", { neon = true, transparency = 0.2 } },
			} },
			-- souris filaire (le yo-yo du ↓P)
			{ name = "PropSouris", hand = "Right", visible = false, pieces = {
				{ "Souris", "", "ball", Vector3.new(0.5, 0.35, 0.75), Vector3.new(0, -0.35, 0), Vector3.zero, BLANC, "SmoothPlastic" },
				{ "Molette", "", "block", Vector3.new(0.08, 0.1, 0.2), Vector3.new(0, -0.2, -0.15), Vector3.zero, VERT, "Neon", { neon = true } },
			} },
			-- paquet de chips (S, recharge)
			{ name = "PropChips", hand = "Right", visible = false, pieces = {
				{ "Paquet", "", "block", Vector3.new(0.4, 1.2, 0.9), Vector3.new(0, -0.65, 0), Vector3.zero, CHIPS, "Foil" },
				{ "Bande", "", "block", Vector3.new(0.42, 0.3, 0.92), Vector3.new(0, -0.65, 0), Vector3.zero, ROUGE, "SmoothPlastic" },
			} },
			-- vieil écran de PC (Écran bleu)
			{ name = "PropEcran", hand = "Right", visible = false, pieces = {
				{ "Coque", "", "block", Vector3.new(1.5, 1.6, 1.9), Vector3.new(0, -1.1, 0), Vector3.zero, Color3.fromRGB(210, 205, 190), "SmoothPlastic" },
				{ "DalleD", "", "block", Vector3.new(0.1, 1.2, 1.5), Vector3.new(0.78, -1.1, 0), Vector3.zero, BSOD, "Neon", { neon = true } },
				{ "DalleG", "", "block", Vector3.new(0.1, 1.2, 1.5), Vector3.new(-0.78, -1.1, 0), Vector3.zero, BSOD, "Neon", { neon = true } },
			} },
			-- chaise gaming (K neutre)
			{ name = "PropChaise", hand = "Right", visible = false, pieces = {
				{ "Dossier", "", "block", Vector3.new(0.35, 2.1, 1.4), Vector3.new(0, -1.1, 0), Vector3.zero, ROUGE, "Fabric" },
				{ "Assise", "", "block", Vector3.new(1.4, 0.35, 1.4), Vector3.new(0.6, -2.25, 0), Vector3.zero, NOIR, "Fabric" },
				{ "Pied", "", "cyl", Vector3.new(0.9, 0.2, 0.2), Vector3.new(1.3, -2.25, 0), Vector3.zero, NOIR, "Metal", { axis = "x" } },
				{ "Roulettes", "", "ball", Vector3.new(0.4, 1.3, 1.3), Vector3.new(1.8, -2.25, 0), Vector3.zero, NOIR, "SmoothPlastic" },
			} },
			-- ventilateur RGB de PC (S maintenu)
			{ name = "PropVentilo", hand = "Right", visible = false, pieces = {
				{ "Cadre", "", "block", Vector3.new(0.3, 1.6, 1.6), Vector3.new(0, -0.9, 0), Vector3.zero, NOIR, "SmoothPlastic" },
				{ "Anneau", "", "cyl", Vector3.new(0.34, 1.4, 1.4), Vector3.new(0, -0.9, 0), Vector3.zero, VIOLET, "Neon", { axis = "x", neon = true, light = { VIOLET, 10, 2 } } },
				{ "Moyeu", "", "cyl", Vector3.new(0.38, 0.5, 0.5), Vector3.new(0, -0.9, 0), Vector3.zero, NOIR, "SmoothPlastic", { axis = "x" } },
			} },
		},
	},

	moves = {
		------------------------------------------------------------------ Attaques légères (P)
		-- Spam bouton : manette tenue à deux mains, pouces qui martèlent, il la cogne trois fois devant lui
		P_neutral = {
			label = "Spam bouton", startup = 0.06, active = 0.2, recovery = 0.16,
			damage = 2, hits = 3, hitbox = box(4, 3, 2.5, 0.8), kbBase = 16, kbGrowth = 20, kbAngle = 25,
			windup = { Root = { -6, 0, 0, 0, -0.25, 0.1 }, Waist = { -12, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 55, 0, -15 }, RE = { 100, 0, 0 }, RW = { -20, 0, 0 }, LS = { 55, 0, 15 }, LE = { 100, 0, 0 } },
			strike = { Root = { -10, 0, 0, 0, -0.3, -0.25 }, Waist = { -14, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 85, 0, -12 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 85, 0, 12 }, LE = { 30, 0, 0 } },
			follow = { Root = { -10, 0, 0, 0, -0.3, -0.2 }, Waist = { -14, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 70, 0, -12 }, RE = { 60, 0, 0 }, RW = { -10, 0, 0 }, LS = { 70, 0, 12 }, LE = { 60, 0, 0 } },
			wobble = true, trail = "bothHands", text = "SPAM !", hitText = "A-A-A !",
		},
		-- Coup de clavier : il sort le clavier et le balance à l'horizontale à bout de bras, de tout le buste
		P_side = {
			label = "Coup de clavier", startup = 0.11, active = 0.1, recovery = 0.2,
			damage = 8, hitbox = box(6, 3, 3.5, 0.5), kbBase = 22, kbGrowth = 38, kbAngle = 20, selfVelocity = Vector2.new(18, 0),
			windup = { Root = { 4, -30, 0, 0, -0.25, 0.3 }, Waist = { 6, -36, 0 }, Neck = { 0, 20, 0 }, RS = { 80, 0, 85 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 80, 0, 0 } },
			strike = { Root = { -10, 22, 0, 0, -0.35, -0.4 }, Waist = { -12, 34, 0 }, Neck = { 0, -16, 0 }, RS = { 92, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -30, 0, -40 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -12, 32, 0, 0, -0.38, -0.45 }, Waist = { -14, 48, 0 }, Neck = { 0, -24, 0 }, RS = { 88, 0, -35 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { -38, 0, -45 }, LE = { 40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			prop = "clavier", hideProp = "manette", trail = "prop", text = "CLAC-CLAC !", hitText = "QWERTY !",
		},
		-- Souris yo-yo : accroupi, il lance la souris par son fil au ras du sol puis la ramène (fait décoller)
		P_down = {
			label = "Souris yo-yo", kind = "projectile", startup = 0.1, active = 0, recovery = 0.22,
			damage = 5, kbBase = 24, kbGrowth = 22, kbAngle = 72,
			projectile = { speed = 58, angle = 0, gravity = 0, lifetime = 0.5, size = 1.3, color = BLANC, returns = true, from = "feet",
				visual = { shape = "ball", size = 0.8, color = BLANC, spin = 0, parts = { { "block", Vector3.new(0.1, 0.12, 0.3), Vector3.new(0, 0.35, 0), VERT } } } },
			windup = { Root = { -8, -16, 0, 0, -0.7, 0.15 }, Waist = { -16, -12, 0 }, Neck = { 0, 12, 0 }, RS = { -20, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -30 }, LE = { 90, 0, 0 } },
			strike = { Root = { -12, 14, 0, 0, -0.85, -0.15 }, Waist = { -20, 16, 0 }, Neck = { 4, -8, 0 }, RS = { 70, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 70, 0, 0 } },
			follow = { Root = { -12, 10, 0, 0, -0.82, -0.1 }, Waist = { -18, 12, 0 }, Neck = { 4, -6, 0 }, RS = { 60, 0, 10 }, RE = { 50, 0, 0 }, RW = { -10, 0, 0 }, LS = { 30, 0, -40 }, LE = { 70, 0, 0 } },
			prop = "souris", hideProp = "manette", text = "CLIC !", hitText = "DOUBLE-CLIC !",
		},
		-- Manette hélico (anti-air, ex-←P) : il fait tournoyer la manette par son câble au-dessus de sa tête
		P_up = {
			label = "Manette hélico", startup = 0.09, active = 0.18, recovery = 0.2,
			damage = 4, hits = 2, hitbox = box(5, 4.5, 0.5, 3.5), kbBase = 26, kbGrowth = 30, kbAngle = 86,
			windup = { Root = { -6, 0, 0, 0, -0.4, 0 }, Waist = { -10, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 40, 0, 50 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 90, 0, 0 } },
			strike = { Root = { 4, 0, 0, 0, -0.1, 0 }, Waist = { 8, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 170, 0, 30 }, RE = { 10, 0, 0 }, RW = { 70, 0, 0 }, LS = { 40, 0, -40 }, LE = { 100, 0, 0 } },
			follow = { Root = { 4, 0, 0, 0, -0.1, 0 }, Waist = { 8, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 172, 0, -10 }, RE = { 10, 0, 0 }, RW = { 70, 0, 0 }, LS = { 40, 0, -40 }, LE = { 100, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "prop", text = "HÉLICO !", hitText = "VRRR !",
		},
		-- Coup de casque RGB : en l'air, il fait les cornes des deux mains et headbangue deux fois, casque allumé,
		-- la visière RGB cogne en cadence
		P_air = {
			label = "Coup de casque RGB", startup = 0.09, active = 0.16, recovery = 0.16,
			damage = 4, hits = 2, hitbox = box(4.5, 3.5, 2.2, 1), kbBase = 22, kbGrowth = 38, kbAngle = 35,
			windup = { Root = { 14, 0, 0 }, Waist = { 18, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 150, 0, 50 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -50 }, LE = { 40, 0, 0 }, RH = { 50, 0, 0 }, RK = { -90, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
			strike = { Root = { -20, 0, 0 }, Waist = { -24, 0, 0 }, Neck = { -40, 0, 0 }, RS = { 120, 0, 60 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -60 }, LE = { 60, 0, 0 }, RH = { 20, 0, 0 }, RK = { -60, 0, 0 }, LH = { 10, 0, 0 }, LK = { -50, 0, 0 } },
			follow = { Root = { 10, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 26, 0, 0 }, RS = { 150, 0, 50 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -50 }, LE = { 40, 0, 0 }, RH = { 50, 0, 0 }, RK = { -90, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
			wobble = true, trail = "head", fx = { { "burst", color = VERT, size = 2, at = "head" }, { "symbols", symbols = { "🤘", "♪" }, count = 3, radius = 2, color = VIOLET } }, text = "METAL !", hitText = "BZZT-BZZT !",
		},
		-- Rush sprint (dash puis P) : il fonce tête baissée, la manette tenue à deux mains devant lui comme un volant,
		-- et la plante dans le ventre d'en face sans lever les yeux
		P_dash = {
			label = "Rush sprint", startup = 0.08, active = 0.15, recovery = 0.24,
			damage = 8, hitbox = box(4.5, 3.5, 2.5, 0.5), kbBase = 28, kbGrowth = 50, kbAngle = 25, selfVelocity = Vector2.new(44, 0),
			windup = { Root = { -16, 0, 0, 0, -0.3, 0.1 }, Waist = { -14, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 50, 0, -10 }, RE = { 110, 0, 0 }, RW = { -20, 0, 0 }, LS = { 50, 0, 10 }, LE = { 110, 0, 0 } },
			strike = { Root = { -30, 0, 0, 0, -0.4, -0.35 }, Waist = { -12, 0, 0 }, Neck = { -30, 0, 0 }, RS = { 92, 0, -8 }, RE = { 10, 0, 0 }, RW = { -30, 0, 0 }, LS = { 92, 0, 8 }, LE = { 10, 0, 0 } },
			follow = { Root = { -32, 0, 0, 0, -0.42, -0.4 }, Waist = { -14, 0, 0 }, Neck = { -32, 0, 0 }, RS = { 94, 0, -10 }, RE = { 10, 0, 0 }, RW = { -30, 0, 0 }, LS = { 94, 0, 10 }, LE = { 10, 0, 0 } },
			trail = "prop", fx = { "dust" }, text = "RUSH B !", hitText = "TCHAC !",
		},

		-- P P : Nunchaku de manette, la manette fouette au bout de son câble d'un côté à l'autre
		P_combo2 = {
			label = "Nunchaku de manette", startup = 0.07, active = 0.1, recovery = 0.16,
			damage = 5, hitbox = box(5.5, 4, 3, 0.5), kbBase = 20, kbGrowth = 25, kbAngle = 30,
			windup = { Root = { -4, 26, 0, 0, -0.25, -0.2 }, Waist = { -6, 34, 0 }, Neck = { 0, -20, 0 }, RS = { 80, 0, -40 }, RE = { 60, 0, 0 }, RW = { 60, 0, 0 }, LS = { 20, 0, -30 }, LE = { 100, 0, 0 } },
			strike = { Root = { -8, -16, 0, 0, -0.3, -0.35 }, Waist = { -10, -26, 0 }, Neck = { 0, 12, 0 }, RS = { 95, 0, 45 }, RE = { 0, 0, 0 }, RW = { 80, 0, 0 }, LS = { 30, 0, -25 }, LE = { 100, 0, 0 } },
			follow = { Root = { -8, -24, 0, 0, -0.3, -0.38 }, Waist = { -10, -36, 0 }, Neck = { 0, 18, 0 }, RS = { 88, 0, 70 }, RE = { 5, 0, 0 }, RW = { 80, 0, 0 }, LS = { 32, 0, -25 }, LE = { 100, 0, 0 } },
			trail = "prop", text = "HOUWA !", hitText = "FOUIT !",
		},
		-- P P P P : Smash de rage, la manette levée à deux mains et fracassée sur le crâne d'en face (finition)
		P_combo3 = {
			label = "Smash de rage", startup = 0.1, active = 0.1, recovery = 0.3,
			damage = 10, hitbox = box(5.5, 4.5, 3, 0.8), kbBase = 36, kbGrowth = 78, kbAngle = 50,
			windup = { Root = { 8, 0, 0, 0, -0.05, 0.25 }, Waist = { 14, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 190, 0, 8 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 190, 0, -8 }, LE = { 60, 0, 0 } },
			strike = { Root = { -16, 0, 0, 0, -0.5, -0.35 }, Waist = { -30, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 60, 0, -8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, 8 }, LE = { 0, 0, 0 } },
			follow = { Root = { -18, 0, 0, 0, -0.6, -0.4 }, Waist = { -36, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 40, 0, -8 }, RE = { 5, 0, 0 }, RW = { -20, 0, 0 }, LS = { 40, 0, 8 }, LE = { 5, 0, 0 } },
			shake = true, trail = "prop", fx = { { "shake", amount = 0.3 } }, text = "ARGH !", hitText = "KRAK !",
		},
		-- → P P : Revers de clavier, le clavier revient dans l'autre sens
		P_side2 = {
			label = "Revers de clavier", startup = 0.08, active = 0.1, recovery = 0.22,
			damage = 7, hitbox = box(6, 4, 3.5, 0.5), kbBase = 22, kbGrowth = 35, kbAngle = 25,
			windup = { Root = { -8, 30, 0, 0, -0.35, -0.4 }, Waist = { -10, 40, 0 }, Neck = { 0, -20, 0 }, RS = { 85, 0, -50 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { -30, 0, -40 }, LE = { 40, 0, 0 } },
			strike = { Root = { -6, -18, 0, 0, -0.3, -0.45 }, Waist = { -10, -28, 0 }, Neck = { 0, 14, 0 }, RS = { 95, 0, 50 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 70, 0, 0 } },
			follow = { Root = { -6, -26, 0, 0, -0.3, -0.5 }, Waist = { -10, -38, 0 }, Neck = { 0, 18, 0 }, RS = { 86, 0, 72 }, RE = { 15, 0, 0 }, RW = { -10, 0, 0 }, LS = { 45, 0, -30 }, LE = { 70, 0, 0 } },
			prop = "clavier", hideProp = "manette", trail = "prop", text = "ALT !", hitText = "TAB !",
		},

		------------------------------------------------------------------ Attaques lourdes (K)
		-- Coup de chaise gaming : il soulève sa chaise gaming au-dessus de la tête et l'abat devant lui
		K_neutral = {
			label = "Coup de chaise gaming", startup = 0.24, active = 0.12, recovery = 0.34,
			damage = 13, hitbox = box(5, 4.5, 3, 1), kbBase = 32, kbGrowth = 85, kbAngle = 40,
			windup = { Root = { 10, -6, 0, 0, -0.1, 0.25 }, Waist = { 16, -8, 0 }, Neck = { 14, 0, 0 }, RS = { 195, 0, 10 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 180, 0, -10 }, LE = { 50, 0, 0 } },
			strike = { Root = { -16, 6, 0, 0, -0.45, -0.4 }, Waist = { -26, 8, 0 }, Neck = { -6, 0, 0 }, RS = { 75, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -5 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -20, 8, 0, 0, -0.55, -0.45 }, Waist = { -32, 10, 0 }, Neck = { -8, 0, 0 }, RS = { 55, 0, 5 }, RE = { 0, 0, 0 }, RW = { -15, 0, 0 }, LS = { 50, 0, -5 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			prop = "chaise", hideProp = "manette", shake = true, fx = { { "shake", amount = 0.35 } }, text = "MA CHAISE !", hitText = "KLONK !",
		},
		-- Clavier volant : il fait tourner le clavier comme un frisbee et le lance devant lui
		K_side = {
			label = "Clavier volant", kind = "projectile", startup = 0.2, active = 0, recovery = 0.35,
			damage = 11, kbBase = 30, kbGrowth = 70, kbAngle = 30,
			projectile = { speed = 55, angle = 6, gravity = 25, lifetime = 0.8, size = 2.2, color = BLEU,
				visual = { shape = "block", size = 0.5, color = NOIR, spin = 16, parts = {
					{ "block", Vector3.new(3, 0.25, 1.0), Vector3.zero, NOIR },
					{ "block", Vector3.new(2.8, 0.1, 0.8), Vector3.new(0, 0.15, 0), BLEU, "Neon" },
				} } },
			windup = { Root = { 4, 30, 0, 0, -0.25, 0.25 }, Waist = { 4, 36, 0 }, Neck = { 0, -24, 0 }, RS = { 80, 0, -60 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 60, 0, 0 } },
			strike = { Root = { -10, -20, 0, 0, -0.35, -0.35 }, Waist = { -12, -30, 0 }, Neck = { 0, 16, 0 }, RS = { 92, 0, 40 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -40 }, LE = { 50, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -12, -28, 0, 0, -0.38, -0.4 }, Waist = { -14, -40, 0 }, Neck = { 0, 20, 0 }, RS = { 85, 0, 70 }, RE = { 5, 0, 0 }, RW = { -10, 0, 0 }, LS = { 15, 0, -45 }, LE = { 50, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			prop = "clavier", hideProp = "manette", text = "CLAVIER VOLANT !", hitText = "AZERTY !",
		},
		-- Glissade à roulettes : il s'assoit sur sa chaise gaming, bras sur les accoudoirs, et traverse l'arène en roulant,
		-- les deux pieds tendus devant comme des pare-chocs
		K_down = {
			label = "Glissade à roulettes", startup = 0.17, active = 0.25, recovery = 0.35,
			damage = 12, hitbox = box(6.5, 2.5, 3, -1.5), kbBase = 30, kbGrowth = 60, kbAngle = 62, selfVelocity = Vector2.new(46, 0),
			windup = { Root = { 8, 0, 0, 0, -1.1, 0.1 }, Waist = { -4, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 90, 0, 0 }, RH = { 90, 0, 10 }, RK = { -95, 0, 0 }, LH = { 90, 0, -10 }, LK = { -95, 0, 0 } },
			strike = { Root = { 18, 0, 0, 0, -1.2, -0.2 }, Waist = { -10, 0, 0 }, Neck = { -16, 0, 0 }, RS = { 40, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 90, 0, 0 }, RH = { 85, 0, 12 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 85, 0, -12 }, LK = { 0, 0, 0 }, LA = { 15, 0, 0 } },
			follow = { Root = { 20, 0, 0, 0, -1.2, -0.25 }, Waist = { -12, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 40, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 90, 0, 0 }, RH = { 88, 0, 12 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 88, 0, -12 }, LK = { 0, 0, 0 }, LA = { 15, 0, 0 } },
			prop = "chaise", hideProp = "manette", trail = "bothFeet", fx = { "dust" }, text = "ROULETTES !", hitText = "SKRRR !",
		},
		-- Retour d'AFK (anti-air, ex-←K) : figé et voûté comme un joueur AFK… puis il se détend d'un coup de genou
		K_up = {
			label = "Retour d'AFK", startup = 0.22, active = 0.12, recovery = 0.3,
			damage = 11, hitbox = box(4, 5, 1.5, 3), kbBase = 32, kbGrowth = 72, kbAngle = 86, invuln = 0.15,
			windup = { Root = { -10, 0, 4, 0, -0.6, 0.05 }, Waist = { -24, 0, 6 }, Neck = { -20, 0, 10 }, RS = { 0, 0, 10 }, RE = { 10, 0, 0 }, LS = { 0, 0, -10 }, LE = { 10, 0, 0 } },
			strike = { Root = { 10, 0, 0, 0, 0.3, 0 }, Waist = { 14, 0, 0 }, Neck = { 22, 0, 0 }, RS = { -40, 0, 40 }, RE = { 30, 0, 0 }, LS = { -40, 0, -40 }, LE = { 30, 0, 0 }, RH = { 130, 0, 0 }, RK = { -120, 0, 0 }, RA = { -20, 0, 0 }, FL = { 0, 0, 0, 0, 0.3, 0 } },
			follow = { Root = { 12, 0, 0, 0, 0.35, 0 }, Waist = { 16, 0, 0 }, Neck = { 26, 0, 0 }, RS = { -45, 0, 42 }, RE = { 30, 0, 0 }, LS = { -45, 0, -42 }, LE = { 30, 0, 0 }, RH = { 138, 0, 0 }, RK = { -125, 0, 0 }, RA = { -20, 0, 0 }, FL = { 0, 0, 0, 0, 0.35, 0 } },
			shake = true, trail = "rightLeg", text = "AFK… RETOUR !", hitText = "BOUH !",
		},
		-- Double pied rageux : en l'air, recroquevillé de colère puis les deux pieds partent devant
		K_air = {
			label = "Double pied rageux", startup = 0.17, active = 0.14, recovery = 0.25,
			damage = 12, hitbox = box(5, 4, 2.5, 0), kbBase = 30, kbGrowth = 70, kbAngle = 38,
			windup = { Root = { -12, 0, 0 }, Waist = { -24, 0, 0 }, Neck = { -14, 0, 0 }, RS = { 70, 0, -10 }, RE = { 110, 0, 0 }, LS = { 70, 0, 10 }, LE = { 110, 0, 0 }, RH = { 100, 0, 0 }, RK = { -135, 0, 0 }, LH = { 95, 0, 0 }, LK = { -135, 0, 0 } },
			strike = { Root = { 22, 0, 0 }, Waist = { 20, 0, 0 }, Neck = { -10, 0, 0 }, RS = { -40, 0, 45 }, RE = { 30, 0, 0 }, LS = { -40, 0, -45 }, LE = { 30, 0, 0 }, RH = { 88, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 80, 0, 0 }, LK = { -4, 0, 0 }, LA = { 15, 0, 0 } },
			follow = { Root = { 26, 0, 0 }, Waist = { 22, 0, 0 }, Neck = { -12, 0, 0 }, RS = { -48, 0, 50 }, RE = { 30, 0, 0 }, LS = { -48, 0, -50 }, LE = { 30, 0, 0 }, RH = { 94, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 86, 0, 0 }, LK = { -2, 0, 0 }, LA = { 15, 0, 0 } },
			trail = "bothFeet", text = "RAAH !", hitText = "POW !",
		},
		-- Genou rush (dash puis K) : il décolle genou en avant, manette brandie derrière lui
		K_dash = {
			label = "Genou rush", startup = 0.1, active = 0.24, recovery = 0.3,
			damage = 11, hitbox = box(5, 3.5, 2.5, 0.3), kbBase = 30, kbGrowth = 65, kbAngle = 38, selfVelocity = Vector2.new(50, 26),
			windup = { Root = { -12, 0, 0, 0, -0.45, 0 }, Waist = { -14, 0, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 }, LS = { 50, 0, -40 }, LE = { 60, 0, 0 } },
			strike = { Root = { -10, 0, 0 }, Waist = { -6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { -50, 0, 40 }, RE = { 20, 0, 0 }, LS = { 60, 0, -30 }, LE = { 100, 0, 0 }, RH = { 110, 0, 0 }, RK = { -120, 0, 0 }, RA = { -20, 0, 0 }, LH = { -30, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { -12, 0, 0 }, Waist = { -8, 0, 0 }, Neck = { 12, 0, 0 }, RS = { -55, 0, 42 }, RE = { 20, 0, 0 }, LS = { 62, 0, -30 }, LE = { 102, 0, 0 }, RH = { 115, 0, 0 }, RK = { -125, 0, 0 }, RA = { -20, 0, 0 }, LH = { -34, 0, 0 }, LK = { -64, 0, 0 } },
			trail = "rightLeg", text = "GO GO GO !", hitText = "SBAM !",
		},

		-- K K : Coup de pied rageur, la jambe gauche part dans les tibias en trépignant
		K_combo2 = {
			label = "Coup de pied rageur", startup = 0.09, active = 0.1, recovery = 0.22,
			damage = 8, hitbox = box(5, 4, 3, 0.5), kbBase = 24, kbGrowth = 40, kbAngle = 32,
			windup = { Root = { 4, 16, 0, 0, -0.15, 0.1 }, Waist = { 6, 12, 0 }, Neck = { 0, -12, 0 }, RS = { 70, 0, 40 }, RE = { 90, 0, 0 }, LS = { 40, 0, -40 }, LE = { 80, 0, 0 }, LH = { 80, 0, 0 }, LK = { -115, 0, 0 } },
			strike = { Root = { 16, 10, 0, 0, -0.1, 0.05 }, Waist = { 12, 6, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 60 }, RE = { 40, 0, 0 }, LS = { 30, 0, -60 }, LE = { 40, 0, 0 }, LH = { 100, 0, 0 }, LK = { -5, 0, 0 }, LA = { 10, 0, 0 } },
			follow = { Root = { 18, 12, 0, 0, -0.1, 0.08 }, Waist = { 14, 8, 0 }, Neck = { -12, 0, 0 }, RS = { 38, 0, 62 }, RE = { 40, 0, 0 }, LS = { 28, 0, -62 }, LE = { 40, 0, 0 }, LH = { 106, 0, 0 }, LK = { 0, 0, 0 }, LA = { 10, 0, 0 } },
			trail = "leftFoot", text = "NUL !", hitText = "VLAN !",
		},
		-- K K K K : Ragekick sauté, il bondit et décoche un coup de pied de rage, « git gud ! » (finition)
		K_combo3 = {
			label = "Ragekick sauté", startup = 0.1, active = 0.12, recovery = 0.32,
			damage = 12, hitbox = box(5.5, 4.5, 3, 1), kbBase = 36, kbGrowth = 82, kbAngle = 42, selfVelocity = Vector2.new(15, 42),
			windup = { Root = { -10, 0, 0, 0, -0.7, 0.1 }, Waist = { -18, 0, 0 }, Neck = { -10, 0, 0 }, RS = { -40, 0, 30 }, RE = { 40, 0, 0 }, LS = { -40, 0, -30 }, LE = { 40, 0, 0 } },
			strike = { Root = { 16, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 150, 0, 40 }, RE = { 20, 0, 0 }, LS = { 150, 0, -40 }, LE = { 20, 0, 0 }, RH = { 98, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 30, 0, 0 }, LK = { -110, 0, 0 } },
			follow = { Root = { 20, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 155, 0, 45 }, RE = { 20, 0, 0 }, LS = { 155, 0, -45 }, LE = { 20, 0, 0 }, RH = { 106, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 34, 0, 0 }, LK = { -114, 0, 0 } },
			trail = "rightFoot", text = "GIT GUD !", hitText = "BAM !",
		},
		-- P puis K : Coup de pied de tilt, petit coup sec dans le tibia en trépignant
		PK_combo = {
			label = "Coup de pied de tilt", startup = 0.08, active = 0.1, recovery = 0.2,
			damage = 7, hitbox = box(5, 4, 3, 0.5), kbBase = 22, kbGrowth = 30, kbAngle = 30,
			windup = { Root = { -4, -10, 0, 0, -0.25, 0.15 }, Waist = { -10, -10, 0 }, RS = { 50, 0, -10 }, RE = { 100, 0, 0 }, LS = { 50, 0, 10 }, LE = { 100, 0, 0 }, RH = { -20, 0, 6 }, RK = { -75, 0, 0 } },
			strike = { Root = { -8, 10, 0, 0, -0.3, -0.2 }, Waist = { -14, 8, 0 }, RS = { 55, 0, -10 }, RE = { 95, 0, 0 }, LS = { 55, 0, 10 }, LE = { 95, 0, 0 }, RH = { 60, 0, 4 }, RK = { -5, 0, 0 }, RA = { -25, 0, 0 } },
			follow = { Root = { -9, 12, 0, 0, -0.32, -0.24 }, Waist = { -15, 10, 0 }, RS = { 56, 0, -10 }, RE = { 95, 0, 0 }, LS = { 56, 0, 10 }, LE = { 95, 0, 0 }, RH = { 64, 0, 0 }, RK = { -8, 0, 0 }, RA = { -25, 0, 0 } },
			trail = "rightFoot", hitText = "TOC !",
		},
		-- K puis P : Uppercut manette, de l'accroupi jusqu'au ciel (fait décoller)
		KP_combo = {
			label = "Uppercut manette", startup = 0.08, active = 0.1, recovery = 0.24,
			damage = 8, hitbox = box(5, 5, 2.5, 1.5), kbBase = 28, kbGrowth = 45, kbAngle = 80,
			windup = { Root = { -8, -14, 0, 0, -0.7, 0.1 }, Waist = { -20, -14, 0 }, Neck = { -8, 0, 0 }, RS = { -30, 0, 25 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -30 }, LE = { 90, 0, 0 } },
			strike = { Root = { 8, 14, 0, 0, 0.15, -0.2 }, Waist = { 14, 18, 0 }, Neck = { 20, 0, 0 }, RS = { 165, 0, 8 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { -10, 0, -30 }, LE = { 50, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.15, 0 } },
			follow = { Root = { 10, 16, 0, 0, 0.2, -0.24 }, Waist = { 16, 20, 0 }, Neck = { 24, 0, 0 }, RS = { 176, 0, 4 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { -15, 0, -32 }, LE = { 50, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			trail = "prop", text = "UPPERCUT !", hitText = "WOUSH !",
		},

		-- P P P : Quart de cercle avant, il mime la manip du hadoken et pousse les deux paumes : boule RGB à bout portant
		P_hadoken = {
			label = "Quart de cercle avant", startup = 0.08, active = 0.1, recovery = 0.2,
			damage = 6, hitbox = box(5.5, 4.5, 3.2, 0.8), kbBase = 20, kbGrowth = 28, kbAngle = 35,
			windup = { Root = { -4, 40, 0, 0, -0.35, 0.15 }, Waist = { -6, 30, 0 }, Neck = { 0, -24, 0 }, RS = { 30, 0, -20 }, RE = { 110, 0, 0 }, RW = { 60, 0, 0 }, LS = { 30, 0, 20 }, LE = { 110, 0, 0 }, LW = { 60, 0, 0 } },
			strike = { Root = { -12, -10, 0, 0, -0.3, -0.4 }, Waist = { -14, -10, 0 }, Neck = { -6, 8, 0 }, RS = { 95, 0, 0 }, RE = { 0, 0, 0 }, RW = { 85, 0, 0 }, LS = { 95, 0, 0 }, LE = { 0, 0, 0 }, LW = { 85, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -14, -12, 0, 0, -0.32, -0.45 }, Waist = { -16, -12, 0 }, Neck = { -8, 10, 0 }, RS = { 98, 0, 2 }, RE = { 0, 0, 0 }, RW = { 85, 0, 0 }, LS = { 98, 0, -2 }, LE = { 0, 0, 0 }, LW = { 85, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			trail = "bothHands", windupFx = { { "symbols", symbols = { "↓", "↘", "→" }, count = 3, radius = 2, color = VERT, at = "front" } }, fx = { { "burst", color = BLEU, size = 3.5, at = "front" }, { "ring", color = VIOLET, radius = 2.5, at = "front" } }, text = "HA-DO-KEN !", hitText = "BZZOUM !",
		},
		-- → P P P : Ctrl+Alt+Suppr, trois touches tapées à toute vitesse… sur le front d'en face
		P_ctrlalt = {
			label = "Ctrl+Alt+Suppr", startup = 0.06, active = 0.2, recovery = 0.18,
			damage = 3, hits = 3, hitbox = box(5.5, 4, 3.2, 0.8), kbBase = 18, kbGrowth = 24, kbAngle = 40,
			windup = { Root = { -6, 0, 0, 0, -0.25, 0.1 }, Waist = { -10, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 60, 0, 10 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 100, 0, 0 } },
			strike = { Root = { -10, 0, 0, 0, -0.3, -0.3 }, Waist = { -14, 0, 0 }, Neck = { -14, 0, 0 }, RS = { 92, 0, 10 }, RE = { 10, 0, 0 }, RW = { -30, 0, 0 }, LS = { 92, 0, -10 }, LE = { 10, 0, 0 }, LW = { -30, 0, 0 } },
			follow = { Root = { -10, 0, 0, 0, -0.3, -0.3 }, Waist = { -14, 0, 0 }, Neck = { -14, 0, 0 }, RS = { 80, 0, 10 }, RE = { 40, 0, 0 }, RW = { 20, 0, 0 }, LS = { 80, 0, -10 }, LE = { 40, 0, 0 }, LW = { 20, 0, 0 } },
			wobble = true, prop = "clavier", hideProp = "manette", trail = "prop", fx = { { "symbols", symbols = { "CTRL", "ALT", "SUPPR" }, count = 3, radius = 2.5, at = "front", color = BLANC } }, text = "CTRL-ALT-SUPPR !", hitText = "GESTIONNAIRE DES TÂCHES !",
		},
		-- → P P P P : Barre espace, le clavier balaie à l'horizontale de tout son long, l'adversaire part au bout de l'arène (finition)
		P_espace = {
			label = "Barre espace", startup = 0.1, active = 0.12, recovery = 0.32,
			damage = 11, hitbox = box(6.5, 4.5, 3.5, 0.8), kbBase = 38, kbGrowth = 78, kbAngle = 20,
			windup = { Root = { 4, -40, 0, 0, -0.3, 0.3 }, Waist = { 6, -44, 0 }, Neck = { 0, 26, 0 }, RS = { 70, 0, 90 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -90 }, LE = { 10, 0, 0 } },
			strike = { Root = { -12, 24, 0, 0, -0.4, -0.45 }, Waist = { -14, 36, 0 }, Neck = { 0, -18, 0 }, RS = { 92, 0, -6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, 6 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -14, 40, 0, 0, -0.42, -0.5 }, Waist = { -16, 52, 0 }, Neck = { 0, -26, 0 }, RS = { 86, 0, -40 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 86, 0, -28 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			prop = "clavier", hideProp = "manette", trail = "prop", fx = { { "beam", color = BLEU, length = 7, width = 1.6, at = "front" }, { "shake", amount = 0.3 } }, text = "ESPAAACE !", hitText = "TAB-ULÉ !",
		},
		-- ↓ P P : Clic droit, la souris revient au bout de son fil et claque dans la figure
		P_souris2 = {
			label = "Clic droit", startup = 0.07, active = 0.1, recovery = 0.18,
			damage = 6, hitbox = box(5.5, 4, 3.2, 0.8), kbBase = 20, kbGrowth = 26, kbAngle = 40,
			windup = { Root = { -8, -20, 0, 0, -0.5, 0.1 }, Waist = { -14, -16, 0 }, Neck = { 0, 14, 0 }, RS = { 120, 0, 40 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 80, 0, 0 } },
			strike = { Root = { -10, 16, 0, 0, -0.3, -0.3 }, Waist = { -12, 18, 0 }, Neck = { -6, -10, 0 }, RS = { 95, 0, -5 }, RE = { 0, 0, 0 }, RW = { -20, 0, 0 }, LS = { 30, 0, -40 }, LE = { 80, 0, 0 } },
			follow = { Root = { -12, 20, 0, 0, -0.32, -0.34 }, Waist = { -14, 22, 0 }, Neck = { -8, -12, 0 }, RS = { 90, 0, -15 }, RE = { 10, 0, 0 }, RW = { -40, 0, 0 }, LS = { 30, 0, -40 }, LE = { 80, 0, 0 } },
			prop = "souris", hideProp = "manette", trail = "prop", fx = { { "symbols", symbols = { "🖱️", "!" }, count = 2, radius = 2, at = "front", color = BLANC } }, text = "CLIC !", hitText = "CLIC DROIT !",
		},
		-- ↓ P P P : Glisser-déposer, il enroule le fil de la souris autour d'en face et le balance par-dessus sa tête (finition, fait décoller)
		P_deposer = {
			label = "Glisser-déposer", startup = 0.1, active = 0.14, recovery = 0.32,
			damage = 10, hitbox = box(5.5, 5.5, 3, 1.5), kbBase = 34, kbGrowth = 74, kbAngle = 84,
			windup = { Root = { -14, 20, 0, 0, -0.45, 0.1 }, Waist = { -18, 20, 0 }, Neck = { -6, -14, 0 }, RS = { 40, 0, 40 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 80, 0, 0 } },
			strike = { Root = { 10, -10, 0, 0, 0.15, -0.1 }, Waist = { 14, -10, 0 }, Neck = { 28, 8, 0 }, RS = { 180, 0, 10 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -20 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			follow = { Root = { 14, -14, 0, 0, 0.2, -0.1 }, Waist = { 18, -14, 0 }, Neck = { 34, 10, 0 }, RS = { 195, 0, 5 }, RE = { 10, 0, 0 }, RW = { -20, 0, 0 }, LS = { 180, 0, -25 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			prop = "souris", hideProp = "manette", trail = "prop", fx = { { "text", text = "DÉPLACER VERS… LA CORBEILLE", color = VERT, at = "above" }, { "burst", color = VERT, size = 3, at = "above" } }, text = "GLISSER…", hitText = "DÉPOSÉ !",
		},
		-- K K K : Trash talk, il se penche en avant, doigt pointé, et hurle deux insultes de gamer à bout portant
		K_trashtalk = {
			label = "Trash talk", startup = 0.06, active = 0.16, recovery = 0.2,
			damage = 4, hits = 2, hitbox = box(5.5, 4.5, 3.2, 1), kbBase = 18, kbGrowth = 26, kbAngle = 40,
			windup = { Root = { 6, 0, 0, 0, -0.15, 0.15 }, Waist = { 10, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 40, 0, 20 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -20 }, LE = { 110, 0, 0 } },
			strike = { Root = { -16, 0, 0, 0, -0.35, -0.4 }, Waist = { -18, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 98, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -20 }, LE = { 110, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -18, 0, 0, 0, -0.38, -0.45 }, Waist = { -20, 0, 0 }, Neck = { -14, 0, 6 }, RS = { 100, 0, -4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -20 }, LE = { 110, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			shake = true, wobble = true, trail = "rightHand", fx = { { "symbols", symbols = { "EZ", "NOOB", "💢" }, count = 4, radius = 3, at = "front", color = ROUGE } }, text = "EZ ! NOOB !", hitText = "POSTILLONS !",
		},
		-- ↓ K K : Tour de chaise, assis sur sa chaise à roulettes, il tourne sur lui-même les pieds en avant
		K_down2 = {
			label = "Tour de chaise", startup = 0.07, active = 0.18, recovery = 0.2,
			damage = 7, hitbox = box(6.5, 4, 2.5, 0.5), kbBase = 20, kbGrowth = 30, kbAngle = 45,
			windup = { Root = { 10, -30, 0, 0, -1.2, 0 }, Waist = { 0, -20, 0 }, Neck = { 0, 20, 0 }, RS = { 40, 0, 20 }, RE = { 90, 0, 0 }, LS = { 40, 0, -20 }, LE = { 90, 0, 0 }, RH = { 90, 0, 10 }, RK = { -95, 0, 0 }, LH = { 90, 0, -10 }, LK = { -95, 0, 0 } },
			strike = { Root = { 12, 0, 0, 0, -1.2, -0.1 }, Waist = { 0, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 40, 0, 20 }, RE = { 90, 0, 0 }, LS = { 40, 0, -20 }, LE = { 90, 0, 0 }, RH = { 88, 0, 15 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 88, 0, -15 }, LK = { 0, 0, 0 }, LA = { 15, 0, 0 } },
			follow = { Root = { 12, 0, 0, 0, -1.2, -0.1 }, Waist = { 0, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 40, 0, 20 }, RE = { 90, 0, 0 }, LS = { 40, 0, -20 }, LE = { 90, 0, 0 }, RH = { 88, 0, 15 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 88, 0, -15 }, LK = { 0, 0, 0 }, LA = { 15, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, prop = "chaise", hideProp = "manette", trail = "bothFeet", fx = { "dust" }, text = "WIIII !", hitText = "ROULETTES !",
		},
		-- ↓ K K K : Chaise renversée, il bascule en arrière avec la chaise, les deux pieds partent vers le ciel (finition, fait décoller)
		K_down3 = {
			label = "Chaise renversée", startup = 0.1, active = 0.14, recovery = 0.36,
			damage = 11, hitbox = box(5.5, 5.5, 2.5, 1.5), kbBase = 34, kbGrowth = 76, kbAngle = 82,
			windup = { Root = { 10, 0, 0, 0, -1.2, 0 }, Waist = { 0, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 20 }, RE = { 90, 0, 0 }, LS = { 40, 0, -20 }, LE = { 90, 0, 0 }, RH = { 90, 0, 10 }, RK = { -95, 0, 0 }, LH = { 90, 0, -10 }, LK = { -95, 0, 0 } },
			strike = { Root = { 70, 0, 0, 0, -1.4, 0.3 }, Waist = { -10, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 120, 0, 50 }, RE = { 40, 0, 0 }, LS = { 120, 0, -50 }, LE = { 40, 0, 0 }, RH = { 110, 0, 10 }, RK = { -10, 0, 0 }, RA = { 20, 0, 0 }, LH = { 100, 0, -10 }, LK = { -10, 0, 0 }, LA = { 20, 0, 0 } },
			follow = { Root = { 78, 0, 0, 0, -1.5, 0.4 }, Waist = { -12, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 130, 0, 55 }, RE = { 40, 0, 0 }, LS = { 130, 0, -55 }, LE = { 40, 0, 0 }, RH = { 118, 0, 12 }, RK = { -10, 0, 0 }, RA = { 20, 0, 0 }, LH = { 108, 0, -12 }, LK = { -10, 0, 0 }, LA = { 20, 0, 0 } },
			prop = "chaise", hideProp = "manette", trail = "bothFeet", fx = { { "shake", amount = 0.35 }, "dust", { "symbols", symbols = { "💢", "!!" }, count = 3, radius = 2.5, color = ROUGE } }, text = "MA CHAAAISE !", hitText = "PATATRAS !",
		},

		------------------------------------------------------------------ En l'air avec une flèche (P / K)
		-- → P en l'air : Câble-fouet, il fouette l'air devant lui avec le câble de la manette (longue portée)
		P_air_side = {
			label = "Câble-fouet", startup = 0.1, active = 0.1, recovery = 0.2,
			damage = 8, hitbox = box(6.5, 2.5, 4, 0.3), kbBase = 22, kbGrowth = 40, kbAngle = 28,
			windup = { Root = { -6, -20, 0 }, Waist = { -8, -24, 0 }, Neck = { 0, 16, 0 }, RS = { 150, 0, 60 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 80, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 30, 0, 0 }, LK = { -80, 0, 0 } },
			strike = { Root = { -10, 16, 0 }, Waist = { -10, 20, 0 }, Neck = { 0, -10, 0 }, RS = { 92, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -50 }, LE = { 40, 0, 0 }, RH = { 40, 0, 0 }, RK = { -70, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { -12, 20, 0 }, Waist = { -12, 24, 0 }, Neck = { 0, -12, 0 }, RS = { 86, 0, -10 }, RE = { 0, 0, 0 }, RW = { -30, 0, 0 }, LS = { -25, 0, -52 }, LE = { 40, 0, 0 }, RH = { 38, 0, 0 }, RK = { -68, 0, 0 }, LH = { 52, 0, 0 }, LK = { -92, 0, 0 } },
			trail = "prop", text = "FOUET !", hitText = "TCHAK !",
		},
		-- ↑ P en l'air : Moulinet de câble, la manette tourne au-dessus de sa tête pendant qu'il pivote
		P_air_up = {
			label = "Moulinet de câble", startup = 0.09, active = 0.16, recovery = 0.18,
			damage = 7, hitbox = box(5, 4, 0.5, 3.5), kbBase = 26, kbGrowth = 45, kbAngle = 85,
			windup = { Root = { -12, 0, 0 }, Waist = { -14, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 30, 0, 50 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 90, 0, 0 }, RH = { 80, 0, 0 }, RK = { -110, 0, 0 }, LH = { 70, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { 10, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 26, 0, 0 }, RS = { 172, 0, 20 }, RE = { 5, 0, 0 }, RW = { 70, 0, 0 }, LS = { 40, 0, -50 }, LE = { 90, 0, 0 }, RH = { 10, 0, 0 }, RK = { -40, 0, 0 }, LH = { 20, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { 12, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 176, 0, -10 }, RE = { 5, 0, 0 }, RW = { 70, 0, 0 }, LS = { 42, 0, -52 }, LE = { 92, 0, 0 }, RH = { 8, 0, 0 }, RK = { -36, 0, 0 }, LH = { 18, 0, 0 }, LK = { -58, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "prop", hitText = "VRRRT !",
		},
		-- ↓ P en l'air : Smash de manette à deux mains, levée au-dessus de la tête puis abattue vers le sol
		P_air_down = {
			label = "Smash de manette", startup = 0.15, active = 0.1, recovery = 0.3,
			damage = 10, hitbox = box(4, 4, 1, -2), kbBase = 25, kbGrowth = 55, kbAngle = -80,
			windup = { Root = { 18, 0, 0 }, Waist = { 20, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 195, 0, -8 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 195, 0, 8 }, LE = { 40, 0, 0 }, RH = { 70, 0, 0 }, RK = { -110, 0, 0 }, LH = { 75, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { -20, 0, 0 }, Waist = { -30, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 65, 0, -8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 65, 0, 8 }, LE = { 0, 0, 0 }, RH = { 10, 0, 0 }, RK = { -80, 0, 0 }, LH = { 20, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { -26, 0, 0 }, Waist = { -34, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 42, 0, -8 }, RE = { 0, 0, 0 }, RW = { -15, 0, 0 }, LS = { 42, 0, 8 }, LE = { 5, 0, 0 }, RH = { 5, 0, 0 }, RK = { -85, 0, 0 }, LH = { 15, 0, 0 }, LK = { -95, 0, 0 } },
			trail = "prop", text = "GAME OVER !", hitText = "KRAK !",
		},
		-- → K en l'air : Coup de pied tilté, buste en arrière, jambe droite qui part à l'horizontale
		K_air_side = {
			label = "Coup de pied tilté", startup = 0.15, active = 0.12, recovery = 0.25,
			damage = 11, hitbox = box(5, 3, 3.2, 0), kbBase = 30, kbGrowth = 70, kbAngle = 34,
			windup = { Root = { -14, 20, 0 }, Waist = { -16, 10, 0 }, RS = { 50, 0, 45 }, RE = { 90, 0, 0 }, LS = { 70, 0, -30 }, LE = { 100, 0, 0 }, RH = { 105, 0, 0 }, RK = { -135, 0, 0 }, RA = { 10, 0, 0 }, LH = { 40, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { 28, 25, 0 }, Waist = { 10, 5, 0 }, Neck = { -15, 0, 0 }, RS = { -30, 0, 60 }, RE = { 30, 0, 0 }, LS = { 40, 0, -70 }, LE = { 40, 0, 0 }, RH = { 66, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 20, 0, 0 }, LK = { -110, 0, 0 } },
			follow = { Root = { 32, 28, 0 }, Waist = { 12, 5, 0 }, Neck = { -18, 0, 0 }, RS = { -38, 0, 65 }, RE = { 30, 0, 0 }, LS = { 45, 0, -75 }, LE = { 40, 0, 0 }, RH = { 70, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 15, 0, 0 }, LK = { -105, 0, 0 } },
			trail = "rightFoot", hitText = "SBLAF !",
		},
		-- ↑ K en l'air : Salto ragequit, salto arrière rageur, les pieds balaient au-dessus de sa tête
		K_air_up = {
			label = "Salto ragequit", startup = 0.14, active = 0.2, recovery = 0.25,
			damage = 10, hitbox = box(4, 5, 0.5, 3.5), kbBase = 30, kbGrowth = 65, kbAngle = 85,
			windup = { Root = { -10, 0, 0 }, Waist = { -20, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 50 }, RE = { 60, 0, 0 }, LS = { 40, 0, -50 }, LE = { 60, 0, 0 }, RH = { 60, 0, 0 }, RK = { -120, 0, 0 }, LH = { 100, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -40, 0, 60 }, RE = { 20, 0, 0 }, LS = { -40, 0, -60 }, LE = { 20, 0, 0 }, RH = { 150, 0, 0 }, RK = { -5, 0, 0 }, RA = { 20, 0, 0 }, LH = { 40, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -45, 0, 65 }, RE = { 20, 0, 0 }, LS = { -45, 0, -65 }, LE = { 20, 0, 0 }, RH = { 100, 0, 0 }, RK = { -50, 0, 0 }, LH = { 150, 0, 0 }, LK = { -5, 0, 0 }, LA = { 20, 0, 0 } },
			spin = { axis = "x", degrees = -360 }, trail = "bothFeet", text = "RAGEQUIT !", hitText = "POC !",
		},
		-- ↓ K en l'air : Piétinement clavier, il retombe à pieds joints comme pour écraser son clavier (smash vers le bas)
		K_air_down = {
			label = "Piétinement clavier", startup = 0.18, active = 0.15, recovery = 0.3,
			damage = 12, hitbox = box(4, 3, 0.5, -3), kbBase = 25, kbGrowth = 55, kbAngle = -80, selfVelocity = Vector2.new(0, -60),
			windup = { Root = { -6, 0, 0 }, Waist = { -18, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 120, 0, 45 }, RE = { 60, 0, 0 }, LS = { 120, 0, -45 }, LE = { 60, 0, 0 }, RH = { 105, 0, 0 }, RK = { -135, 0, 0 }, LH = { 105, 0, 0 }, LK = { -135, 0, 0 } },
			strike = { Root = { 4, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 40, 0, 50 }, RE = { 90, 0, 0 }, LS = { 40, 0, -50 }, LE = { 90, 0, 0 }, RH = { -4, 0, 4 }, RK = { 0, 0, 0 }, RA = { -10, 0, 0 }, LH = { -4, 0, -4 }, LK = { 0, 0, 0 }, LA = { -10, 0, 0 } },
			follow = { Root = { 4, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { -25, 0, 0 }, RS = { 35, 0, 55 }, RE = { 95, 0, 0 }, LS = { 35, 0, -55 }, LE = { 95, 0, 0 }, RH = { -4, 0, 6 }, RK = { -5, 0, 0 }, RA = { -10, 0, 0 }, LH = { -4, 0, -6 }, LK = { -5, 0, 0 }, LA = { -10, 0, 0 } },
			trail = "bothFeet", text = "CTRL-ALT-SUPPR !", hitText = "CRONCH !",
		},

		------------------------------------------------------------------ Signatures (L) : sûres de toucher (couloir / projectiles visés, voir docs/fiche-perso.md)
		-- Paquet de chips : il sort son paquet et le balance droit sur la figure de l'adversaire ; personne à portée : il retombe
		-- et éclate en un nuage de miettes grasses qui reste au sol
		S_neutral = {
			label = "Paquet de chips", kind = "projectile", startup = 0.2, active = 0, recovery = 0.42,
			damage = 13, kbBase = 22, kbGrowth = 38, kbAngle = 35,
			projectile = { speed = 55, angle = 12, gravity = 40, lifetime = 0.8, size = 2.6, color = CHIPS, linger = 1.2,
				visual = { shape = "block", size = 1.2, color = CHIPS, material = "Foil", spin = 10, parts = { { "block", Vector3.new(1.25, 0.3, 0.75), Vector3.zero, ROUGE } } } },
			windup = { Root = { 6, -24, 0, 0, -0.15, 0.25 }, Waist = { 10, -30, 0 }, Neck = { 0, 16, 0 }, RS = { 185, 0, 25 }, RE = { 80, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -20 }, LE = { 30, 0, 0 } },
			strike = { Root = { -12, 20, 0, 0, -0.3, -0.35 }, Waist = { -22, 30, 0 }, Neck = { 0, -10, 0 }, RS = { 92, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -30 }, LE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { -14, 26, 0, 0, -0.35, -0.4 }, Waist = { -26, 38, 0 }, Neck = { 0, -14, 0 }, RS = { 60, 0, -15 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { -30, 0, -35 }, LE = { 75, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			prop = "chips", hideProp = "manette", trail = "prop", fx = { { "toss", shape = "flat", color = CHIPS, size = 0.4, count = 5, speed = 20 } }, text = "CRUNCH !", hitText = "MIETTES !",
		},
		-- Speedrun : il glisse à genoux à toute vitesse d'un bout à l'autre du couloir, traverse l'adversaire et ressort derrière lui
		S_side = {
			label = "Speedrun", startup = 0.15, active = 0.24, recovery = 0.42,
			damage = 13, hitbox = box(12, 5, 5, -0.5), kbBase = 30, kbGrowth = 58, kbAngle = 50, selfVelocity = Vector2.new(85, 0),
			invuln = 0.3, teleport = 7,
			windup = { Root = { -14, 0, 0, 0, -0.4, 0 }, Waist = { -10, 0, 0 }, Neck = { 10, 0, 0 }, RS = { -30, 0, 30 }, RE = { 40, 0, 0 }, LS = { -30, 0, -30 }, LE = { 40, 0, 0 } },
			strike = { Root = { 16, 0, 0, 0, -1.2, -0.3 }, Waist = { 10, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 150, 0, 30 }, RE = { 20, 0, 0 }, LS = { 150, 0, -30 }, LE = { 20, 0, 0 }, RH = { 10, 0, 0 }, RK = { -120, 0, 0 }, LH = { 10, 0, 0 }, LK = { -120, 0, 0 } },
			follow = { Root = { 18, 0, 0, 0, -1.22, -0.35 }, Waist = { 12, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 155, 0, 32 }, RE = { 20, 0, 0 }, LS = { 155, 0, -32 }, LE = { 20, 0, 0 }, RH = { 10, 0, 0 }, RK = { -122, 0, 0 }, LH = { 10, 0, 0 }, LK = { -122, 0, 0 } },
			trail = "body", fx = { "dust", { "text", text = "WORLD RECORD", color = VERT, at = "above" } }, text = "SPEEDRUN !", hitText = "SKIP !",
		},
		-- Câble tendu : il arrache le câble de la manette, le claque au ras du sol sur toute la longueur du couloir, et tout le monde trébuche
		S_down = {
			label = "Câble tendu", startup = 0.22, active = 0.16, recovery = 0.48,
			damage = 13, hitbox = box(14, 6, 7, 0.5), kbBase = 26, kbGrowth = 50, kbAngle = 75,
			status = { name = "stunned", duration = 0.7 },
			windup = { Root = { -6, 0, 0, 0, -0.5, 0.1 }, Waist = { -16, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 170, 0, 30 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -30 }, LE = { 40, 0, 0 } },
			strike = { Root = { -18, 0, 0, 0, -0.8, -0.3 }, Waist = { -30, 0, 0 }, Neck = { -4, 0, 0 }, RS = { 60, 0, 8 }, RE = { 0, 0, 0 }, RW = { -40, 0, 0 }, LS = { 55, 0, -8 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -20, 0, 0, 0, -0.85, -0.35 }, Waist = { -32, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 50, 0, 10 }, RE = { 0, 0, 0 }, RW = { -50, 0, 0 }, LS = { 45, 0, -10 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			trail = "prop", fx = { { "beam", color = NOIR, length = 16, width = 0.4, at = "feet" }, { "ring", color = VERT, radius = 4, at = "front" }, "dust" },
			text = "CÂBLE TENDU !", hitText = "PATATRAS !",
		},
		-- Rage Jump (remontée) : il hurle de rage et le cri le propulse en diagonale vers l'avant, manette tendue devant lui
		-- comme un bélier, jambes qui gigotent derrière ; tout ce qui est sur le passage prend la rage
		S_up = {
			label = "Rage Jump", startup = 0.15, active = 0.32, recovery = 0.4,
			damage = 15, hitbox = box(10, 11, 3, 4), kbBase = 32, kbGrowth = 55, kbAngle = 72, selfVelocity = Vector2.new(44, 86),
			windup = { Root = { -6, 0, 0, 0, -0.8, 0 }, Waist = { -20, 0, 0 }, Neck = { -14, 0, 0 }, RS = { 20, 0, 30 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 110, 0, 0 } },
			strike = { Root = { -42, 0, 0, 0, 0.3, 0 }, Waist = { -6, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 168, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -45 }, LE = { 110, 0, 0 }, RH = { -24, 0, 8 }, RK = { -40, 0, 0 }, RA = { -25, 0, 0 }, LH = { -36, 0, -8 }, LK = { -55, 0, 0 }, LA = { -25, 0, 0 } },
			follow = { Root = { -46, 0, 0, 0, 0.35, 0 }, Waist = { -8, 0, 0 }, Neck = { 36, 0, 0 }, RS = { 172, 0, 12 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 45, 0, -50 }, LE = { 110, 0, 0 }, RH = { -36, 0, 10 }, RK = { -55, 0, 0 }, RA = { -25, 0, 0 }, LH = { -24, 0, -10 }, LK = { -40, 0, 0 }, LA = { -25, 0, 0 } },
			shake = true, trail = "prop",
			fx = { { "pillar", color = VIOLET, height = 10, width = 3, at = "feet" }, { "particles", tex = "spark", color = VERT, dir = "down", at = "feet", time = 0.4, speed = 14 }, { "ring", color = ROUGE, radius = 4, at = "feet" }, { "symbols", symbols = { "💢", "RAAH" }, count = 3, radius = 2, color = ROUGE } },
			text = "RAAAAAH !", hitText = "RAGE !",
		},
		-- Écran bleu (plongeon) : il tombe en tenant un vieil écran à bout de bras sur tout ce qu'il y a dessous ; l'impact fige l'adversaire
		S_air_down = {
			label = "Écran bleu", startup = 0.18, active = 0.35, recovery = 0.45,
			damage = 14, hitbox = box(8, 6, 1, -2), kbBase = 28, kbGrowth = 55, kbAngle = -60, selfVelocity = Vector2.new(0, -85),
			status = { name = "frozen", duration = 0.5 },
			windup = { Root = { 14, 0, 0 }, Waist = { 14, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 190, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 190, 0, -10 }, LE = { 30, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { 60, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { -20, 0, 0 }, Waist = { -20, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 30, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, 20 }, LE = { 20, 0, 0 }, RH = { 40, 0, 0 }, RK = { -80, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
			follow = { Root = { -24, 0, 0 }, Waist = { -22, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 25, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 35, 0, 20 }, LE = { 20, 0, 0 }, RH = { 38, 0, 0 }, RK = { -78, 0, 0 }, LH = { 38, 0, 0 }, LK = { -78, 0, 0 } },
			prop = "ecran", hideProp = "manette", trail = "prop",
			fx = { { "screen", color = BSOD, alpha = 0.25 }, { "ring", color = BSOD, radius = 6, at = "feet" }, { "shake", amount = 0.4 } }, text = ":(", hitText = "ÉCRAN BLEU !",
		},
		-- Freeze (esquive puis S) : il pointe la manette comme une télécommande et met en pause tout le couloir devant lui (0,8 s)
		S_dodge = {
			label = "Freeze", startup = 0.15, active = 0.14, recovery = 0.42,
			damage = 12, hitbox = box(14, 6, 7, 1), kbBase = 8, kbGrowth = 8, kbAngle = 0,
			status = { name = "stunned", duration = 0.8 },
			windup = { Root = { 4, -10, 0, 0, -0.2, 0.15 }, Waist = { 4, -10, 0 }, Neck = { 0, 10, 0 }, RS = { 60, 0, 10 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -20 }, LE = { 80, 0, 0 } },
			strike = { Root = { -12, 8, 0, 0, -0.3, -0.4 }, Waist = { -10, 8, 0 }, Neck = { -6, -6, 0 }, RS = { 98, 0, 0 }, RE = { 0, 0, 0 }, RW = { -60, 0, 0 }, LS = { 30, 0, -25 }, LE = { 85, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { -12, 8, 0, 0, -0.3, -0.4 }, Waist = { -10, 8, 0 }, Neck = { -6, -6, 0 }, RS = { 100, 0, 0 }, RE = { 0, 0, 0 }, RW = { -62, 0, 0 }, LS = { 30, 0, -25 }, LE = { 85, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			hold = 0.15, trail = "prop", fx = { { "beam", color = BLEU, length = 16, width = 2, at = "hand" }, { "symbols", symbols = { "⏸", "▓", "░" }, count = 6, radius = 4, color = BLEU, at = "front" } },
			text = "PAUSE !", hitText = "*LAG*",
		},
		-- Ventilo RGB (S maintenu) : il brandit un ventilateur de PC allumé à fond ; le souffle balaie tout le couloir et repousse très loin
		S_hold = {
			label = "Ventilo RGB", startup = 0.26, active = 0.3, recovery = 0.5,
			damage = 12, hitbox = box(14, 6, 7, 1), kbBase = 52, kbGrowth = 55, kbAngle = 10,
			windup = { Root = { 6, -10, 0, 0, -0.2, 0.2 }, Waist = { 6, -10, 0 }, Neck = { 0, 10, 0 }, RS = { 60, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 80, 0, 0 } },
			strike = { Root = { -12, 4, 0, 0, -0.35, -0.3 }, Waist = { -10, 4, 0 }, Neck = { 6, 0, 0 }, RS = { 94, 0, 0 }, RE = { 5, 0, 0 }, RW = { -80, 0, 0 }, LS = { 88, 0, 12 }, LE = { 25, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			follow = { Root = { -14, 4, 0, 0, -0.35, -0.35 }, Waist = { -12, 4, 0 }, Neck = { 8, 0, 0 }, RS = { 96, 0, 0 }, RE = { 5, 0, 0 }, RW = { -82, 0, 0 }, LS = { 90, 0, 12 }, LE = { 25, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.48 } },
			hold = 0.1, prop = "ventilo", hideProp = "manette",
			fx = { { "beam", color = VIOLET, length = 16, width = 4, at = "hand" }, { "particles", tex = "smoke", color = BLEU, dir = "front", at = "hand", time = 0.45, speed = 32, size = 1.2, rate = 90 } },
			text = "VROOOOM !", hitText = "WHOOSH !",
		},
		-- Moulinet nunchaku (→→S) : il avance en faisant tournoyer la manette au bout de son câble, un grand moulinet qui balaie tout le couloir
		S_dash = {
			label = "Moulinet nunchaku", startup = 0.15, active = 0.3, recovery = 0.42,
			damage = 14, hitbox = box(14, 6, 7, 0.5), kbBase = 32, kbGrowth = 60, kbAngle = 35, selfVelocity = Vector2.new(36, 0),
			windup = { Root = { -8, -20, 0, 0, -0.25, 0.1 }, Waist = { -6, -20, 0 }, RS = { 80, 0, 70 }, RE = { 20, 0, 0 }, RW = { 60, 0, 0 }, LS = { 50, 0, -40 }, LE = { 90, 0, 0 } },
			strike = { Root = { -12, 0, 0, 0, -0.3, -0.25 }, Waist = { -8, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 92, 0, 88 }, RE = { 0, 0, 0 }, RW = { 80, 0, 0 }, LS = { 60, 0, -50 }, LE = { 90, 0, 0 } },
			follow = { Root = { -12, 0, 0, 0, -0.3, -0.3 }, Waist = { -8, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 94, 0, 88 }, RE = { 0, 0, 0 }, RW = { 80, 0, 0 }, LS = { 62, 0, -50 }, LE = { 90, 0, 0 } },
			spin = { axis = "y", degrees = 720 }, trail = "prop", fx = { { "ring", color = ROUGE, radius = 5, at = "root" }, "dust" }, text = "MOULINET !", hitText = "WATAAA !",
		},
		-- Pic de lag (S en l'air) : il frappe dans un sursaut saccadé tout autour de lui… puis se « téléporte » en arrière comme un lag
		S_air = {
			label = "Pic de lag", startup = 0.15, active = 0.16, recovery = 0.42,
			damage = 13, hitbox = box(8, 6, 2, 0), kbBase = 28, kbGrowth = 52, kbAngle = 35, teleport = -5,
			windup = { Root = { -8, 10, 6 }, Waist = { -10, 10, 0 }, Neck = { 0, -10, 10 }, RS = { 140, 0, 50 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 90, 0, 0 }, RH = { 70, 0, 0 }, RK = { -100, 0, 0 }, LH = { 40, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { -20, -10, -6 }, Waist = { -14, -10, 0 }, Neck = { -10, 10, -10 }, RS = { 92, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -50 }, LE = { 40, 0, 0 }, RH = { 40, 0, 0 }, RK = { -60, 0, 0 }, LH = { 60, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { -22, -12, -8 }, Waist = { -16, -12, 0 }, Neck = { -12, 12, -12 }, RS = { 94, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -25, 0, -52 }, LE = { 40, 0, 0 }, RH = { 38, 0, 0 }, RK = { -58, 0, 0 }, LH = { 62, 0, 0 }, LK = { -102, 0, 0 } },
			wobble = true, trail = "prop", fx = { { "symbols", symbols = { "▓", "░", "▒" }, count = 8, radius = 3, color = VERT }, { "ring", color = VERT, radius = 4, at = "root" } }, text = "LAG !", hitText = "*GLITCH*",
		},

		------------------------------------------------------------------ Finitions avec S (dans un enchaînement)
		-- Explosion de rage : poings vers le sol, il hurle et tout vole autour de lui
		S_finish_rage = {
			label = "Explosion de rage", startup = 0.12, active = 0.2, recovery = 0.32,
			damage = 11, hitbox = box(8, 4.5, 0, 0.5), kbBase = 32, kbGrowth = 65, kbAngle = 45,
			windup = { Root = { -8, 0, 0, 0, -0.5, 0 }, Waist = { -24, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 30, 0, -20 }, RE = { 120, 0, 0 }, LS = { 30, 0, 20 }, LE = { 120, 0, 0 } },
			strike = { Root = { 8, 0, 0, 0, -0.2, 0 }, Waist = { 14, 0, 0 }, Neck = { 36, 0, 0 }, RS = { 20, 0, 50 }, RE = { 20, 0, 0 }, LS = { 20, 0, -50 }, LE = { 20, 0, 0 } },
			follow = { Root = { 10, 0, 0, 0, -0.2, 0 }, Waist = { 16, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 15, 0, 55 }, RE = { 20, 0, 0 }, LS = { 15, 0, -55 }, LE = { 20, 0, 0 } },
			shake = true, fx = { { "burst", color = ROUGE, size = 5, at = "root" }, { "ring", color = ROUGE, radius = 6 }, { "shake", amount = 0.4 } },
			text = "J'EN AI MARRE !", hitText = "BOUM !",
		},
		-- Combo clavier : clavier levé à deux mains, abattu devant lui avec un « ENTRÉE » rageur
		S_finish_key = {
			label = "Touche Entrée", startup = 0.15, active = 0.12, recovery = 0.3,
			damage = 10, hitbox = box(6, 4, 3.5, 0.5), kbBase = 32, kbGrowth = 65, kbAngle = 35,
			windup = { Root = { 10, 0, 0, 0, -0.05, 0.2 }, Waist = { 14, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 190, 0, 5 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 185, 0, -5 }, LE = { 40, 0, 0 } },
			strike = { Root = { -14, 0, 0, 0, -0.4, -0.35 }, Waist = { -24, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 85, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, 0 }, LE = { 10, 0, 0 } },
			follow = { Root = { -16, 0, 0, 0, -0.45, -0.4 }, Waist = { -28, 0, 0 }, Neck = { -8, 0, 0 }, RS = { 70, 0, 0 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 66, 0, 0 }, LE = { 10, 0, 0 } },
			prop = "clavier", hideProp = "manette", trail = "prop", text = "ENTRÉE !", hitText = "CLAC !",
		},

		------------------------------------------------------------------ Supers (Y) : couloir 1,3 fois plus grand, plus farfelus
		-- Rage Quit ! (Y) : il fracasse son clavier et une pluie de touches tombe du ciel pile sur l'adversaire
		SUPER = {
			label = "Rage Quit !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.7,
			damage = 3, kbBase = 20, kbGrowth = 25, kbAngle = 50,
			projectile = { speed = 60, gravity = 40, lifetime = 1.2, size = 1.6, color = BLANC, rain = { count = 8, spread = 6, ahead = 9, height = 22 },
				visual = { shape = "block", size = 1.0, color = BLANC, text = "ESC", textColor = NOIR, spin = 8 } },
			windup = { Root = { 8, 0, 0, 0, -0.05, 0.2 }, Waist = { 14, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 190, 0, 10 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 190, 0, -10 }, LE = { 40, 0, 0 } },
			strike = { Root = { -14, 0, 0, 0, -0.6, -0.2 }, Waist = { -30, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 40, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 30, 0, 0 } },
			follow = { Root = { -14, 0, 0, 0, -0.6, -0.2 }, Waist = { -32, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 30, 0, 40 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 30, 0, 0 } },
			hold = 0.3, prop = "clavier", hideProp = "manette", windupFx = { "super" },
			fx = { { "burst", color = BLEU, size = 4, at = "front" }, { "toss", shape = "block", color = BLANC, size = 0.5, count = 10, speed = 28 }, { "shake", amount = 0.5 } },
			text = "RAGE QUIT !", hitText = "TAC-TAC-TAC !",
		},
		-- Hadoken de rage (→Y) : quart de cercle avant à deux mains sur la manette, il hurle et une boule de rage rouge
		-- grosse comme lui part de ses paumes et traverse tout le couloir en grésillant
		SUPER_side = {
			label = "Hadoken de rage !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.7,
			damage = 26, kbBase = 48, kbGrowth = 98, kbAngle = 32,
			projectile = { speed = 88, angle = 0, gravity = 0, lifetime = 0.9, size = 3.4, color = ROUGE, pierce = true,
				visual = { shape = "ball", size = 3.2, color = ROUGE, neon = true, spin = 10, text = "💢" } },
			windup = { Root = { 10, -40, 0, 0, -0.45, 0.3 }, Waist = { 12, -44, 0 }, Neck = { 6, 24, 0 }, RS = { 20, 0, 20 }, RE = { 120, 0, 0 }, RW = { 40, 0, 0 }, LS = { 20, 0, -20 }, LE = { 120, 0, 0 }, LW = { 40, 0, 0 } },
			strike = { Root = { -16, 20, 0, 0, -0.4, -0.55 }, Waist = { -18, 24, 0 }, Neck = { -8, -14, 0 }, RS = { 94, 0, 8 }, RE = { 0, 0, 0 }, RW = { -40, 0, 0 }, LS = { 94, 0, -8 }, LE = { 0, 0, 0 }, LW = { -40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			follow = { Root = { -18, 24, 0, 0, -0.42, -0.6 }, Waist = { -20, 28, 0 }, Neck = { -10, -16, 0 }, RS = { 98, 0, 10 }, RE = { 4, 0, 0 }, RW = { -50, 0, 0 }, LS = { 98, 0, -10 }, LE = { 4, 0, 0 }, LW = { -50, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.58 } },
			shake = true, windupFx = { "super", { "text", text = "↓ ↘ → + P", color = VERT, at = "above" }, { "particles", tex = "fire", color = ROUGE, dir = "all", at = "hand", time = 0.35, speed = 6, size = 0.6, rate = 60 } },
			fx = { { "burst", color = ROUGE, size = 4, at = "front" }, { "beam", color = ROUGE, length = 14, width = 3, at = "hand" }, { "shake", amount = 0.4 } },
			text = "HADOKEEEN !", hitText = "K.O. !",
		},
		-- Chaise en orbite (Y↑) : il empoigne sa chaise gaming à deux mains et la balance de toutes ses forces : elle fonce droit
		-- sur l'adversaire et l'emporte en orbite… et il reste planté à la regarder s'éloigner
		SUPER_up = {
			label = "Chaise en orbite !", kind = "projectile", startup = 0.35, active = 0, recovery = 0.75,
			damage = 24, kbBase = 46, kbGrowth = 95, kbAngle = 86,
			projectile = { speed = 78, angle = 45, gravity = 0, lifetime = 1.3, size = 4.2, color = NOIR, pierce = true, from = "above",
				visual = { shape = "block", size = 2.2, color = SWEAT_FONCE, spin = 5, parts = {
					{ "block", Vector3.new(2.2, 0.5, 2.2), Vector3.new(0, -0.6, 0), SWEAT_FONCE },
					{ "block", Vector3.new(2.2, 2.6, 0.5), Vector3.new(0, 0.9, 1.0), SWEAT_FONCE },
					{ "block", Vector3.new(0.4, 2.6, 0.2), Vector3.new(0, 0.9, 0.75), ROUGE },
					{ "ball", Vector3.new(0.5, 0.5, 0.5), Vector3.new(0.9, -1.4, 0.9), VERT },
					{ "ball", Vector3.new(0.5, 0.5, 0.5), Vector3.new(-0.9, -1.4, -0.9), VIOLET },
				} } },
			windup = { Root = { -12, 0, 0, 0, -0.75, 0.1 }, Waist = { -24, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 30, 0, 0 } },
			strike = { Root = { -10, 0, 0, 0, 0.2, -0.2 }, Waist = { -8, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 150, 0, 14 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -14 }, LE = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0 }, FL = { 0, 0, 0, 0, 0.3, 0 } },
			follow = { Root = { 12, 0, 0, 0, 0.2, 0 }, Waist = { 16, 0, 0 }, Neck = { 50, 0, 0 }, RS = { 150, 0, 60 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -60 }, LE = { 0, 0, 0 } },
			hold = 0.3, shake = true, prop = "chaise", hideProp = "manette",
			windupFx = { "super", { "symbols", symbols = { "💢", "!!" }, count = 4, radius = 2.5, color = ROUGE } },
			fx = { { "beam", color = VIOLET, length = 14, width = 3.5, at = "hand" }, { "burst", color = VERT, size = 4, at = "above" }, { "shake", amount = 0.5 }, { "text", text = "ELLE REVIENT PAS ?", color = BLANC, at = "above" } },
			text = "MA CHAIIISE !", hitText = "EN ORBITE !",
		},
		-- Code de triche (Y↓) : il tape le code sur la manette, aura « GOD MODE » : invincible 2,5 s et une onde de choc
		-- dorée des deux côtés sur toute la plateforme
		SUPER_down = {
			label = "Code de triche !", startup = 0.4, active = 0.2, recovery = 0.65,
			damage = 22, hitbox = box(34, 8, 0, 2), kbBase = 36, kbGrowth = 62, kbAngle = 60,
			invuln = 2.5, selfEffect = { armor = 3 },
			windup = { Root = { -4, 0, 0, 0, -0.25, 0 }, Waist = { -14, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 60, 0, -15 }, RE = { 110, 0, 0 }, RW = { -20, 0, 0 }, LS = { 60, 0, 15 }, LE = { 110, 0, 0 } },
			strike = { Root = { 6, 0, 0, 0, 0.2, 0 }, Waist = { 14, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 170, 0, 40 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -40 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			follow = { Root = { 6, 0, 0, 0, 0.25, 0 }, Waist = { 16, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 175, 0, 45 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 175, 0, -45 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			hold = 0.4, windupFx = { "super", { "text", text = "↑↑↓↓←→←→ B A", color = VERT, at = "above" } },
			fx = { { "pillar", color = Color3.fromRGB(255, 215, 60), height = 16, width = 4, at = "root" }, { "ring", color = Color3.fromRGB(255, 215, 60), radius = 10 }, { "ring", color = Color3.fromRGB(255, 215, 60), radius = 17, time = 0.5 }, { "text", text = "GOD MODE", color = Color3.fromRGB(255, 215, 60), at = "above" } },
			text = "GOD MODE !", hitText = "TRICHEUR !",
		},

		------------------------------------------------------------------ Saisie (bouton ✋) et projections
		-- Prise de rage : il agrippe l'adversaire par la capuche d'une main, l'autre poing déjà armé
		GRAB = {
			label = "Prise de rage", kind = "grab", startup = 0.1, active = 0.12, recovery = 0.35,
			damage = 0, hitbox = box(4, 4, 2, 0.5),
			windup = { Root = { -6, 10, 0, 0, -0.2, 0.15 }, Waist = { -10, 10, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 40 }, RE = { 90, 0, 0 }, LS = { 120, 0, -30 }, LE = { 20, 0, 0 } },
			strike = { Root = { -10, -6, 0, 0, -0.25, -0.3 }, Waist = { -14, -6, 0 }, Neck = { -14, 0, 0 }, RS = { 60, 0, 30 }, RE = { 120, 0, 0 }, LS = { 105, 0, 5 }, LE = { 30, 0, 0 } },
			follow = { Root = { -10, -8, 0, 0, -0.25, -0.3 }, Waist = { -14, -8, 0 }, Neck = { -14, 0, 0 }, RS = { 62, 0, 32 }, RE = { 122, 0, 0 }, LS = { 108, 0, 5 }, LE = { 35, 0, 0 } },
			text = "VIENS LÀ !", hitText = "GRR !",
		},
		-- ✋ puis → : Alt+F4, il lance l'adversaire droit devant comme on ferme une fenêtre
		THROW_fwd = {
			label = "Alt+F4", kind = "throw", startup = 0.3, active = 0.08, recovery = 0.3,
			damage = 9, kbBase = 42, kbGrowth = 55, kbAngle = 10,
			carry = { { 0, 2.4, 0.4 }, { 0.14, 1.4, 0.4 }, { 0.3, 4.5, 0.6 } },
			windup = { Root = { 6, 30, 0, 0, -0.3, 0.3 }, Waist = { 8, 26, 0 }, Neck = { 0, -16, 0 }, RS = { 60, 0, 30 }, RE = { 110, 0, 0 }, LS = { 80, 0, -10 }, LE = { 60, 0, 0 } },
			strike = { Root = { -20, -12, 0, 0, -0.45, -0.5 }, Waist = { -18, -12, 0 }, Neck = { 10, 6, 0 }, RS = { 90, 0, 0 }, RE = { 5, 0, 0 }, LS = { 90, 0, 0 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -24, -16, 0, 0, -0.5, -0.55 }, Waist = { -20, -14, 0 }, Neck = { 14, 8, 0 }, RS = { 92, 0, -5 }, RE = { 5, 0, 0 }, LS = { 92, 0, 5 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			fx = { "dust", { "text", text = "[X]", color = ROUGE, at = "front" } }, text = "ALT+F4 !", hitText = "FERMÉ !",
		},
		-- ✋ puis ← : Câble arraché, il fait passer l'adversaire par-dessus son épaule comme une manette qu'on débranche
		THROW_back = {
			label = "Câble arraché", kind = "throw", back = true, startup = 0.4, active = 0.1, recovery = 0.4,
			damage = 12, kbBase = 35, kbGrowth = 70, kbAngle = 45,
			carry = { { 0, 2.2, 0.3 }, { 0.12, 1.6, 1.0 }, { 0.26, 0.2, 3.2 }, { 0.4, -2.6, 0.2 } },
			windup = { Root = { -10, 0, 0, 0, -0.5, 0.1 }, Waist = { -16, 0, 0 }, RS = { 80, 0, -10 }, RE = { 60, 0, 0 }, LS = { 80, 0, 10 }, LE = { 60, 0, 0 } },
			strike = { Root = { 30, 0, 0, 0, -0.35, 0.3 }, Waist = { 26, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 195, 0, -10 }, RE = { 20, 0, 0 }, LS = { 195, 0, 10 }, LE = { 20, 0, 0 } },
			follow = { Root = { 34, 0, 0, 0, -0.38, 0.35 }, Waist = { 30, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 205, 0, -10 }, RE = { 20, 0, 0 }, LS = { 205, 0, 10 }, LE = { 20, 0, 0 } },
			fx = { "dust" }, text = "DÉBRANCHÉ !", hitText = "BADABOUM !",
		},
		-- ✋ puis ↑ : Lancer de manette, il lance l'adversaire au ciel comme une manette jetée de rage
		THROW_up = {
			label = "Lancer de manette", kind = "throw", startup = 0.3, active = 0.08, recovery = 0.35,
			damage = 9, kbBase = 38, kbGrowth = 60, kbAngle = 88,
			carry = { { 0, 2.2, 0.3 }, { 0.14, 1.8, -0.8 }, { 0.3, 0.8, 4.0 } },
			windup = { Root = { -10, 0, 0, 0, -0.8, 0.1 }, Waist = { -18, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 45, 0, -15 }, RE = { 40, 0, 0 }, LS = { 45, 0, 15 }, LE = { 40, 0, 0 } },
			strike = { Root = { 8, 0, 0, 0, 0.3, -0.1 }, Waist = { 15, 0, 0 }, Neck = { 38, 0, 0 }, RS = { 175, 0, 10 }, RE = { 5, 0, 0 }, LS = { 175, 0, -10 }, LE = { 5, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			follow = { Root = { 10, 0, 0, 0, 0.35, -0.1 }, Waist = { 18, 0, 0 }, Neck = { 42, 0, 0 }, RS = { 180, 0, 20 }, RE = { 5, 0, 0 }, LS = { 180, 0, -20 }, LE = { 5, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0 }, FL = { 0, 0, 0, 0, 0.3, 0 } },
			text = "VOLE !", hitText = "ZWIIING !",
		},
		-- ✋ puis ↓ : Clavier cassé, il plaque l'adversaire au sol et tape dessus à deux poings comme sur un clavier
		THROW_down = {
			label = "Clavier cassé", kind = "throw", startup = 0.4, active = 0.1, hold = 0.3, recovery = 0.35,
			damage = 10, kbBase = 30, kbGrowth = 25, kbAngle = 75,
			carry = { { 0, 2.2, 0.3 }, { 0.14, 2.0, 1.4 }, { 0.28, 1.8, -2.0 }, { 0.4, 1.6, -2.3 } },
			windup = { Root = { 10, 0, 0, 0, 0.1, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 160, 0, -10 }, RE = { 30, 0, 0 }, LS = { 160, 0, 10 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			strike = { Root = { -20, 0, 0, 0, -0.9, -0.3 }, Waist = { -30, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 70, 0, -10 }, RE = { 40, 0, 0 }, LS = { 30, 0, 10 }, LE = { 90, 0, 0 } },
			follow = { Root = { -20, 0, 0, 0, -0.9, -0.3 }, Waist = { -30, 0, 0 }, Neck = { -12, 0, 0 }, RS = { 30, 0, -10 }, RE = { 90, 0, 0 }, LS = { 70, 0, 10 }, LE = { 40, 0, 0 } },
			wobble = true, fx = { "dust", { "symbols", symbols = { "Q", "W", "E", "R" }, count = 6, radius = 2, color = BLANC, at = "front" } },
			text = "TAPE-TAPE-TAPE !", hitText = "CLAC-CLAC !",
		},
	},

	-- Fatals (→ = forward, ← = back) : 1er offert, 2e au niveau de maîtrise 5, 3e au niveau 15
	fatals = {
		{
			id = "game_over", label = "Game Over", sequence = { "down", "forward", "forward" },
			-- l'adversaire devient du pixel art 8-bit et se désagrège en pixels
			scene = {
				{ "fxAttacker", { "text", text = "GG EZ.", color = VERT } },
				{ "material", "Slate" },
				{ "color", Color3.fromRGB(90, 200, 90) },
				{ "fx", { "symbols", symbols = { "▓", "░", "▒", "█" }, count = 10, radius = 3, color = VERT } },
				{ "wait", 0.5 },
				{ "spawn", at = "target", offset = Vector3.new(0, 0, 0), life = 3, pieces = {
					{ "Pixel1", "", "block", Vector3.new(0.8, 0.8, 0.8), Vector3.new(-1.2, 1.5, 0), Vector3.zero, VERT, "Neon", { neon = true } },
					{ "Pixel2", "", "block", Vector3.new(0.8, 0.8, 0.8), Vector3.new(1.0, 0.5, 0), Vector3.zero, BLEU, "Neon", { neon = true } },
					{ "Pixel3", "", "block", Vector3.new(0.8, 0.8, 0.8), Vector3.new(-0.6, -1.0, 0), Vector3.zero, VIOLET, "Neon", { neon = true } },
					{ "Pixel4", "", "block", Vector3.new(0.8, 0.8, 0.8), Vector3.new(1.4, -1.8, 0), Vector3.zero, ROUGE, "Neon", { neon = true } },
				} },
				{ "shrink", 0.4, time = 0.5 },
				{ "shrink", 0.15, time = 0.4 },
				{ "fx", { "burst", color = VERT, size = 3, at = "root" } },
				{ "hide" },
				{ "text", "GAME OVER" },
				{ "fxAttacker", { "text", text = "INSERT COIN ?", color = CHIPS } },
				{ "wait", 1.2 },
			},
		},
		{
			id = "ctrl_z", label = "Ctrl+Z", sequence = { "back", "back", "down" },
			-- l'adversaire est rembobiné à toute vitesse jusqu'à disparaître dans l'écran titre
			scene = {
				{ "fxAttacker", { "text", text = "CTRL+Z !", color = BLEU } },
				{ "text", "◀◀" },
				{ "spin", -720, time = 0.6 },
				{ "launch", Vector3.new(6, 1, 0), time = 0.5 },
				{ "text", "◀◀ ◀◀" },
				{ "spin", -720, time = 0.4 },
				{ "spawn", at = "target", offset = Vector3.new(2, 1, 1), life = 3.5, pieces = {
					{ "EcranTitre", "", "block", Vector3.new(7, 5, 0.4), Vector3.zero, Vector3.zero, NOIR, "SmoothPlastic" },
					{ "Titre", "", "block", Vector3.new(5, 1, 0.5), Vector3.new(0, 1.2, 0), Vector3.zero, VIOLET, "Neon", { neon = true } },
					{ "Start", "", "block", Vector3.new(3, 0.5, 0.5), Vector3.new(0, -1.2, 0), Vector3.zero, BLANC, "Neon", { neon = true } },
				} },
				{ "shrink", 0.2, time = 0.6 },
				{ "move", to = "target", offset = Vector3.new(0, 1, 1), time = 0.3 },
				{ "hide" },
				{ "text", "PRESS START" },
				{ "fxAttacker", { "text", text = "ANNULÉ.", color = VERT } },
				{ "wait", 1.2 },
			},
		},
		{
			id = "desinstalle", label = "Désinstallé", sequence = { "up", "forward", "down" },
			-- une barre « Désinstallation… » se remplit au-dessus de l'adversaire, qui s'efface à 100 %
			scene = {
				{ "fxAttacker", { "text", text = "DÉSINSTALLER ? OUI.", color = ROUGE } },
				{ "spawn", at = "above", offset = Vector3.new(0, 1, 0), life = 3.5, pieces = {
					{ "Cadre", "", "block", Vector3.new(6, 0.9, 0.3), Vector3.zero, Vector3.zero, BLANC, "SmoothPlastic" },
					{ "Remplissage", "", "block", Vector3.new(5.6, 0.6, 0.4), Vector3.zero, Vector3.zero, VERT, "Neon", { neon = true } },
				} },
				{ "text", "Désinstallation… 12 %" },
				{ "wait", 0.5 },
				{ "material", "Glass" },
				{ "text", "… 64 %" },
				{ "wait", 0.5 },
				{ "shrink", 0.6, time = 0.4 },
				{ "text", "… 99 %" },
				{ "wait", 0.7 },
				{ "text", "100 %" },
				{ "fx", { "particles", tex = "spark", color = VERT, dir = "up", at = "root", time = 0.6, speed = 10 } },
				{ "hide" },
				{ "fxAttacker", { "text", text = "ESPACE LIBÉRÉ !", color = VERT } },
				{ "wait", 1 },
			},
		},
	},

	-- Mécanique « rage » : les dégâts reçus remplissent la jauge ; pleine, il tilte (+50 % de dégâts, plus d'esquive)
	passive = { kind = "rage", name = "Rage", icon = "😡", max = 100, gain = 1.2, duration = 6, color = ROUGE },

	-- Recharge ⚡ : il s'enfile une poignée de chips et martèle sa manette, le casque RGB clignote de plus en plus vite
	charge = {
		label = "Chips et spam",
		loop = 1.4,
		lockWrist = true,
		color = VERT,
		keys = {
			{ 0.0, { Root = { -8, 0, 0, 0, -0.3, 0 }, Waist = { -16, 0, 0 }, Neck = { -14, 0, 0 }, RS = { 55, 0, -15 }, RE = { 105, 0, 0 }, RW = { -20, 0, 0 }, LS = { 55, 0, 15 }, LE = { 105, 0, 0 } } },
			{ 0.12, { Root = { -8, 0, 0, 0, -0.32, 0 }, Waist = { -17, 2, 0 }, Neck = { -15, 0, 0 }, RS = { 58, 0, -15 }, RE = { 100, 0, 0 }, RW = { -20, 0, 0 }, LS = { 58, 0, 15 }, LE = { 100, 0, 0 } } },
			{ 0.24, { Root = { -8, 0, 0, 0, -0.3, 0 }, Waist = { -16, -2, 0 }, Neck = { -14, 0, 0 }, RS = { 55, 0, -15 }, RE = { 105, 0, 0 }, RW = { -20, 0, 0 }, LS = { 55, 0, 15 }, LE = { 105, 0, 0 } } },
			{ 0.36, { Root = { -8, 0, 0, 0, -0.32, 0 }, Waist = { -17, 2, 0 }, Neck = { -15, 0, 0 }, RS = { 58, 0, -15 }, RE = { 100, 0, 0 }, RW = { -20, 0, 0 }, LS = { 58, 0, 15 }, LE = { 100, 0, 0 } } },
			{ 0.48, { Root = { -8, 0, 0, 0, -0.3, 0 }, Waist = { -16, -2, 0 }, Neck = { -14, 0, 0 }, RS = { 55, 0, -15 }, RE = { 105, 0, 0 }, RW = { -20, 0, 0 }, LS = { 55, 0, 15 }, LE = { 105, 0, 0 } } },
			{ 0.75, { Root = { -2, 0, 0, 0, -0.2, 0 }, Waist = { -4, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 50, 0, -10 }, RE = { 100, 0, 0 }, RW = { -20, 0, 0 }, LS = { 120, 0, 20 }, LE = { 150, 0, 0 } } },
			{ 0.95, { Root = { -2, 0, 0, 0, -0.22, 0 }, Waist = { -4, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 50, 0, -10 }, RE = { 100, 0, 0 }, RW = { -20, 0, 0 }, LS = { 115, 0, 20 }, LE = { 155, 0, 0 } } },
			{ 1.15, { Root = { -8, 0, 0, 0, -0.3, 0 }, Waist = { -16, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 55, 0, -15 }, RE = { 105, 0, 0 }, RW = { -20, 0, 0 }, LS = { 55, 0, 15 }, LE = { 105, 0, 0 } } },
			{ 1.4, { Root = { -8, 0, 0, 0, -0.3, 0 }, Waist = { -16, 0, 0 }, Neck = { -14, 0, 0 }, RS = { 55, 0, -15 }, RE = { 105, 0, 0 }, RW = { -20, 0, 0 }, LS = { 55, 0, 15 }, LE = { 105, 0, 0 } } },
		},
		beats = {
			{ 0.05, { "particles", tex = "spark", color = VIOLET, dir = "up", at = "head", time = 0.2, speed = 4 } },
			{ 0.3, { "particles", tex = "spark", color = VERT, dir = "up", at = "head", time = 0.15, speed = 4 } },
			{ 0.5, { "particles", tex = "spark", color = BLEU, dir = "up", at = "head", time = 0.1, speed = 4 } },
			{ 0.85, { "text", text = "CRUNCH", color = CHIPS, at = "head" } },
			{ 0.9, { "toss", shape = "flat", color = CHIPS, size = 0.4, count = 3, speed = 8 } },
		},
	},

	-- Manies au repos : il fait craquer sa nuque, secoue sa manette (« elle lague ! »), tapote du pied nerveusement
	fidgets = {
		{ duration = 1.8, lockWrist = false, keys = {
			{ 0, {} },
			{ 0.35, { Neck = { 0, 0, 25 }, Waist = { -10, 0, 0 } } },
			{ 0.6, { Neck = { 0, 0, -25 }, Waist = { -10, 0, 0 } } },
			{ 0.9, { Neck = { 20, 0, 0 }, Waist = { -6, 0, 0 }, RS = { 60, 0, -20 }, RE = { 120, 0, 0 }, LS = { 60, 0, 20 }, LE = { 120, 0, 0 } } },
			{ 1.3, { Neck = { -10, 0, 0 } } },
			{ 1.8, {} },
		} },
		{ duration = 2.2, lockWrist = true, keys = {
			{ 0, {} },
			{ 0.3, { Neck = { -20, 0, 0 }, Waist = { -14, 0, 0 }, RS = { 70, 0, -10 }, RE = { 110, 0, 0 }, RW = { -30, 0, 0 } } },
			{ 0.6, { Neck = { -22, 0, 0 }, Waist = { -14, 0, 0 }, RS = { 90, 0, -10 }, RE = { 90, 0, 0 }, RW = { -10, 0, 0 } } },
			{ 0.75, { Neck = { -22, 0, 0 }, Waist = { -14, 0, 0 }, RS = { 70, 0, -10 }, RE = { 120, 0, 0 }, RW = { -40, 0, 0 } } },
			{ 0.9, { Neck = { -22, 0, 0 }, Waist = { -14, 0, 0 }, RS = { 90, 0, -10 }, RE = { 90, 0, 0 }, RW = { -10, 0, 0 } } },
			{ 1.05, { Neck = { -22, 0, 0 }, Waist = { -14, 0, 0 }, RS = { 70, 0, -10 }, RE = { 120, 0, 0 }, RW = { -40, 0, 0 } } },
			{ 1.6, { Neck = { 10, 0, 0 }, Waist = { 6, 0, 0 }, RS = { 40, 0, 30 }, RE = { 60, 0, 0 }, LS = { 40, 0, -30 }, LE = { 60, 0, 0 } } },
			{ 2.2, {} },
		} },
		{ duration = 1.6, lockWrist = false, keys = {
			{ 0, {} },
			{ 0.2, { Root = { 0, 0, 0, 0, -0.15, 0 }, Neck = { -6, 10, 0 } } },
			{ 0.4, { Root = { 0, 0, 0, 0, -0.22, 0 }, Neck = { -6, -10, 0 } } },
			{ 0.6, { Root = { 0, 0, 0, 0, -0.15, 0 }, Neck = { -6, 10, 0 } } },
			{ 0.8, { Root = { 0, 0, 0, 0, -0.22, 0 }, Neck = { -6, -10, 0 } } },
			{ 1.0, { Root = { 0, 0, 0, 0, -0.15, 0 }, Neck = { -6, 10, 0 } } },
			{ 1.6, {} },
		} },
	},
}

-- Pendant qu'il tient quelqu'un : il le tient par la capuche à bout de bras gauche, poing droit (manette) armé,
-- penché en avant, les épaules remontées de rage
data.grabHold = {
	Root = { -8, -6, 0, 0, -0.25, 0.05 },
	Waist = { -12, -6, 0 },
	Neck = { -12, 6, 0 },
	RS = { 50, 0, 35 },
	RE = { 120, 0, 0 },
	RW = { 0, 0, 0 },
	LS = { 100, 0, 8 },
	LE = { 30, 0, 0 },
}

-- Retour 🪂 : il réapparaît en pixels qui se recomposent comme un jeu qui recharge (« RESPAWN »), crie « LAG ! »
-- et remet son casque
data.respawn = {
	duration = 1.8,
	platform = { pieces = {
		{ "Dalle", "base", "block", Vector3.new(4.5, 0.5, 3.5), Vector3.new(0, -0.25, 0), Vector3.zero, NOIR, "SmoothPlastic", { reflect = 0.2 } },
		{ "BordAv", "", "block", Vector3.new(4.6, 0.12, 0.12), Vector3.new(0, 0, -1.75), Vector3.zero, VERT, "Neon", { neon = true } },
		{ "BordAr", "", "block", Vector3.new(4.6, 0.12, 0.12), Vector3.new(0, 0, 1.75), Vector3.zero, VIOLET, "Neon", { neon = true } },
		{ "Pixel1", "", "block", Vector3.new(0.6, 0.6, 0.6), Vector3.new(-1.8, 2.5, 0), Vector3.zero, VERT, "Neon", { neon = true } },
		{ "Pixel2", "", "block", Vector3.new(0.6, 0.6, 0.6), Vector3.new(1.9, 4, 0.4), Vector3.zero, BLEU, "Neon", { neon = true } },
		{ "Pixel3", "", "block", Vector3.new(0.6, 0.6, 0.6), Vector3.new(-1.4, 5.2, -0.3), Vector3.zero, VIOLET, "Neon", { neon = true } },
		{ "Pixel4", "", "block", Vector3.new(0.6, 0.6, 0.6), Vector3.new(1.6, 1.2, -0.2), Vector3.zero, ROUGE, "Neon", { neon = true } },
	} },
	keys = {
		{ 0.0, { Root = { -10, 0, 12, 0, -0.6, 0 }, Waist = { -16, 0, -8 }, Neck = { -20, 0, 14 }, RS = { 10, 0, 10 }, RE = { 20, 0, 0 }, LS = { 10, 0, -10 }, LE = { 20, 0, 0 } } },
		{ 0.25, { Root = { -10, 0, 12, 0, -0.6, 0 }, Waist = { -16, 0, -8 }, Neck = { -20, 0, 14 }, RS = { 10, 0, 10 }, RE = { 20, 0, 0 }, LS = { 10, 0, -10 }, LE = { 20, 0, 0 } } },
		{ 0.3, { Root = { 4, 0, -10, 0, -0.3, 0 }, Waist = { 0, 0, 10 }, Neck = { 10, 0, -12 }, RS = { 60, 0, 40 }, RE = { 60, 0, 0 }, LS = { 30, 0, -10 }, LE = { 90, 0, 0 } } },
		{ 0.55, { Root = { 4, 0, -10, 0, -0.3, 0 }, Waist = { 0, 0, 10 }, Neck = { 10, 0, -12 }, RS = { 60, 0, 40 }, RE = { 60, 0, 0 }, LS = { 30, 0, -10 }, LE = { 90, 0, 0 } } },
		{ 0.6, { Root = { 0, 0, 0, 0, -0.2, 0 }, Waist = { 0, 0, 0 }, Neck = { 0, 0, 0 } } },
		{ 0.85, { Root = { 6, 0, 0, 0, -0.1, 0.1 }, Waist = { 12, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 100, 0, 70 }, RE = { 30, 0, 0 }, LS = { 100, 0, -70 }, LE = { 30, 0, 0 } } },
		{ 1.2, { Root = { 0, 0, 0, 0, -0.15, 0 }, Waist = { 0, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 150, 0, 35 }, RE = { 130, 0, 0 }, LS = { 150, 0, -35 }, LE = { 130, 0, 0 } } },
		{ 1.45, { Root = { -4, 0, 0, 0, -0.18, 0 }, Waist = { -8, 0, 0 }, Neck = { -6, 0, 0 }, RS = { 145, 0, 38 }, RE = { 135, 0, 0 }, LS = { 145, 0, -38 }, LE = { 135, 0, 0 } } },
		{ 1.8, {} },
	},
	beats = {
		{ 0.05, { "symbols", symbols = { "▓", "░", "▒", "█" }, count = 10, radius = 3, color = VERT } },
		{ 0.3, { "text", text = "RESPAWN", color = VERT, at = "above" } },
		{ 0.85, { "text", text = "LAG !", color = ROUGE } },
		{ 1.25, { "particles", tex = "spark", color = VIOLET, dir = "all", at = "head", time = 0.3, speed = 6 } },
	},
}

-- Arbre d'enchaînements : P P P P = spam, nunchaku, hadoken, smash de rage ; → P P P P = clavier, revers, Ctrl+Alt+Suppr,
-- barre espace ; ↓ P P P = souris yo-yo, clic droit, glisser-déposer ; K K K K = chaise, pied rageur, trash talk,
-- ragekick ; ↓ K K K = roulettes, tour de chaise, chaise renversée. S finit presque toutes les chaînes (explosion de
-- rage tout autour, touche Entrée devant lui).
local function airAfterP()
	return { K = "K_air", fwd_K = "K_air_side", up_K = "K_air_up", down_K = "K_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end
local function airAfterK()
	return { P = "P_air", fwd_P = "P_air_side", up_P = "P_air_up", down_P = "P_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end

local LINKS = {
	-- P P P P : spam bouton, nunchaku, quart de cercle avant, smash de rage (finition)
	P_neutral = { P = "P_combo2", K = "PK_combo", S = "S_finish_key" },
	P_combo2 = { P = "P_hadoken", K = "PK_combo", up_P = "KP_combo", S = "S_finish_rage" },
	P_hadoken = { P = "P_combo3", K = "K_trashtalk", S = "S_finish_rage" },
	PK_combo = { K = "K_trashtalk", P = "KP_combo", S = "S_finish_key" },
	KP_combo = { P = "P_combo3", S = "S_finish_rage" },
	-- K K K K : chaise gaming, coup de pied rageur, trash talk, ragekick sauté (finition)
	K_neutral = { K = "K_combo2", P = "KP_combo", S = "S_finish_rage" },
	K_combo2 = { K = "K_trashtalk", P = "P_hadoken", S = "S_finish_key" },
	K_trashtalk = { K = "K_combo3", P = "P_espace", S = "S_finish_rage" },
	-- → P P P P : coup de clavier, revers, Ctrl+Alt+Suppr, barre espace (finition à l'horizontale)
	P_side = { P = "P_side2", K = "PK_combo", S = "S_finish_key" },
	P_side2 = { P = "P_ctrlalt", K = "K_combo2", S = "S_finish_rage" },
	P_ctrlalt = { P = "P_espace", K = "K_trashtalk", S = "S_finish_key" },
	-- ↓ P P P : souris yo-yo (fait décoller), clic droit, glisser-déposer (finition vers le ciel)
	P_down = { P = "P_souris2", K = "K_down", up_K = "K_up", S = "S_finish_rage" },
	P_souris2 = { P = "P_deposer", K = "K_down2", S = "S_finish_key" },
	-- ↓ K K K : glissade à roulettes, tour de chaise, chaise renversée (finition vers le ciel)
	K_down = { K = "K_down2", up_K = "K_up", P = "P_souris2", S = "S_finish_rage" },
	K_down2 = { K = "K_down3", P = "P_hadoken", S = "S_finish_key" },
	-- autres départs
	P_up = { K = "K_up", P = "P_combo2", S = "S_finish_key" },
	P_dash = { P = "P_ctrlalt", K = "PK_combo", S = "S_finish_key" },
	K_side = { S = "S_finish_rage" }, -- clavier volant
	K_up = { S = "S_finish_key" },
	K_dash = { P = "KP_combo", K = "K_trashtalk", S = "S_finish_rage" },
	-- en l'air ; ↓ P et ↓ K (smash vers le sol) sont des finitions sans suite
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
