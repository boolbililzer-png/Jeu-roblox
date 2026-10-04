-- Gégé le Pochtron (version soda douteux) : coups, animations et effets.
--
-- Clés de coups : P_/K_ + neutral, side, down, up, air, dash (après un dash) ;
-- P_/K_ + air_side, air_up, air_down : en l'air avec une flèche (sans coup pour cette flèche, on prend P_air / K_air) ;
-- S_ + neutral, side, down, up, dash, dodge (après une esquive), air, air_down ; SUPER, SUPER_side, SUPER_up, SUPER_down ;
-- GRAB (bouton ✋) puis THROW_fwd, THROW_back, THROW_up, THROW_down (flèche tenue pendant la saisie).
-- Les autres coups (combo, finish…) ne sortent que dans un enchaînement, voir links.
--
-- Enchaînements façon Tekken
--   links    : coups qui peuvent suivre celui-ci, par bouton : { P = "...", K = "...", S = "..." }.
--              Une direction tenue peut donner une autre suite : "down_K", "up_P", "fwd_P" (vers l'adversaire),
--              "back_K" (à l'opposé). Sans suite pour cette direction, on prend celle du bouton seul.
--              La fenêtre s'ouvre à l'impact du coup et se ferme peu après son retour en garde.
--
-- Signatures (S_, bouton L) et Supers (SUPER…, bouton Y) : sans limite, plus d'energyCost ni de superCost (seule
--   limite : Config.SUPER_COOLDOWN secondes de recharge entre deux Supers, gérées par le moteur). Le moteur
--   en fait des coups sûrs de toucher (couloir de 16 studs devant lui, projectiles qui visent l'adversaire, ↑L en
--   diagonale, voir docs/fiche-perso.md) : on écrit ici des gestes qui balaient tout le couloir.
--   charge     : animation du perso pendant la recharge (boucle de poses, voir plus bas)
--
-- Gameplay
--   kind     : "melee" (défaut), "projectile" ou "self"
--   startup / active / recovery : durées en secondes
--   hitbox   : size = taille de la zone, offset.X = vers l'avant, offset.Y = vers le haut
--   kbBase + kbGrowth * dégâts / 100 = vitesse d'éjection ; kbAngle en degrés (90 = vers le haut, négatif = vers le bas)
--   selfVelocity : élan donné à Gégé (X = vers l'avant, Y = 0 garde la vitesse verticale)
--
-- Chopes et projections
--   GRAB     : kind = "grab", la saisie elle-même (aucun dégât, aucune éjection) : si la zone touche, l'adversaire
--              est tenu, Gégé prend la pose data.grabHold, puis une flèche (ou rien) choisit la projection.
--   THROW_*  : kind = "throw". Dégâts et éjection (kbBase, kbGrowth, kbAngle) appliqués à la fin du startup,
--              quand la victime est lâchée.
--   carry    : { { temps, avant, haut }, ... } positions de la victime tenue pendant le startup, par rapport au
--              centre de Gégé (temps de 0 à startup ; avant en studs, négatif = derrière lui ; haut en studs).
--   back     : true = la victime part derrière Gégé (l'éjection est retournée)
--   data.grabHold : pose partielle de Gégé pendant qu'il tient quelqu'un, avant la projection
--
-- Visuel (voir shared/Poses.lua pour le sens des angles)
--   windup / strike / follow : poses d'élan, de frappe et de prolongement (le coup continue sur sa lancée).
--            L'animation va : garde → élan → frappe → prolongement → retour en garde. Les articulations non
--            précisées gardent la pose de base ; les pieds non précisés restent plantés au sol (FR / FL décalent un
--            pied, une hanche précisée libère la jambe). Poignet droit non précisé : la bouteille pend naturellement.
--            En l'air (P_air*, K_air*) les jambes sont libres : on précise RH / RK / LH / LK, jamais FR / FL.
--   hold     : temps (s) passé figé dans la pose de frappe avant le retour
--   spin     : { axis = "x" ou "y", degrees = n } rotation du corps pendant la frappe
--              (axe "x" : n positif = salto avant, négatif = salto arrière ; garder un multiple de 360)
--   shake    : tremblement pendant l'élan ; wobble : zigzag pendant la frappe
--   trail    : traînées pendant la frappe ("bottle", "rightFoot", "leftFoot", "rightLeg", "body")
--   prop     : objet qui apparaît le temps du coup ("lighter", "mic") ; hideProp : objet caché ("bottle")
--   windupFx / fx : effets lancés au début / au moment de la frappe (voir client/Fx.lua)
--   text     : onomatopée affichée à la frappe ; hitText : onomatopée à l'impact

local function box(width, height, forward, up)
	return { size = Vector3.new(width, height, 6), offset = Vector2.new(forward, up) }
end

local SODA = Color3.fromRGB(170, 220, 60)
local BOTTLE = Color3.fromRGB(40, 140, 60)
local CAN = Color3.fromRGB(210, 50, 50) -- canettes (arme n° 2)
local WOODY = Color3.fromRGB(140, 95, 50) -- tonneau (arme n° 3)

local data = {
	id = "Gege",
	name = "Gégé le Pochtron",
	costume = "Gege",
	style = "drunk",
	holdsBottle = true, -- la bouteille pend au bout du bras quand aucun coup ne la tient autrement
	------------------------------------------------------------------ Mains nues (sans Caisse Bizarre) : bagarre de comptoir
	-- Ses propres J / K et ses combos sans arme (les L et les Y restent ceux de moves). Gégé titube, gifle mou,
	-- donne des coups de boule et de bedaine ; ses combos finissent en roulade ou en « câlin » d'ivrogne.
	bare = {
		moves = {
			-- J : gifle molle du revers, le poignet qui pendouille
			P_neutral = {
				label = "Gifle molle", startup = 0.07, active = 0.08, recovery = 0.14,
				damage = 5, hitbox = box(4, 3, 2.6, 0.8), kbBase = 18, kbGrowth = 22, kbAngle = 25,
				windup = { Root = { 4, 18, 0, 0, -0.1, 0.12 }, Waist = { 4, 22, 0 }, RS = { 60, 0, 60 }, RE = { 70, 0, 0 }, RW = { 30, 0, 0 }, LS = { 30, 0, -20 }, LE = { 60, 0, 0 } },
				strike = { Root = { -6, -16, 0, 0, -0.18, -0.25 }, Waist = { -6, -24, 0 }, RS = { 95, 0, -20 }, RE = { 10, 0, 0 }, RW = { -30, 0, 0 }, LS = { 25, 0, -25 }, LE = { 70, 0, 0 } },
				follow = { Root = { -8, -22, 0, 0, -0.2, -0.3 }, Waist = { -8, -30, 0 }, RS = { 90, 0, -36 }, RE = { 14, 0, 0 }, RW = { -50, 0, 0 }, LS = { 22, 0, -28 }, LE = { 72, 0, 0 } },
				trail = "rightHand", hitText = "PFLAC !",
			},
			-- J J : deuxième gifle, de l'autre main, il manque de tomber en avant
			P_combo2 = {
				label = "Aller-retour", startup = 0.06, active = 0.08, recovery = 0.14,
				damage = 5, hitbox = box(4, 3, 2.8, 0.8), kbBase = 18, kbGrowth = 22, kbAngle = 30,
				windup = { Root = { 4, -18, 0, 0, -0.1, 0.1 }, Waist = { 4, -22, 0 }, RS = { 30, 0, 20 }, RE = { 60, 0, 0 }, LS = { 60, 0, -60 }, LE = { 70, 0, 0 }, LW = { 30, 0, 0 } },
				strike = { Root = { -8, 16, 0, 0, -0.22, -0.3 }, Waist = { -8, 24, 0 }, RS = { 25, 0, 25 }, RE = { 70, 0, 0 }, LS = { 95, 0, 20 }, LE = { 10, 0, 0 }, LW = { -30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
				follow = { Root = { -12, 20, 0, 0, -0.28, -0.4 }, Waist = { -12, 28, 0 }, RS = { 20, 0, 28 }, RE = { 72, 0, 0 }, LS = { 92, 0, 34 }, LE = { 14, 0, 0 }, LW = { -50, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
				trail = "bothHands", hitText = "PFLIC !",
			},
			-- J J J : coup de boule titubant, il s'élance tête la première
			P_combo3 = {
				label = "Coup de boule titubant", startup = 0.12, active = 0.1, recovery = 0.26,
				damage = 8, hitbox = box(4.5, 3, 2.8, 1.5), kbBase = 26, kbGrowth = 45, kbAngle = 35, selfVelocity = Vector2.new(18, 0),
				windup = { Root = { -14, 0, 0, 0, -0.1, 0.25 }, Waist = { -18, 0, 0 }, Neck = { -25, 0, 0 }, RS = { -20, 0, 30 }, RE = { 40, 0, 0 }, LS = { -20, 0, -30 }, LE = { 40, 0, 0 } },
				strike = { Root = { 22, 0, 0, 0, -0.25, -0.45 }, Waist = { 24, 0, 0 }, Neck = { 30, 0, 0 }, RS = { -30, 0, 40 }, RE = { 20, 0, 0 }, LS = { -30, 0, -40 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
				follow = { Root = { 26, 0, 0, 0, -0.3, -0.5 }, Waist = { 26, 0, 0 }, Neck = { 34, 0, 0 }, RS = { -36, 0, 46 }, RE = { 20, 0, 0 }, LS = { -36, 0, -46 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
				fx = { "headStar" }, trail = "head", hitText = "BOING !",
			},
			-- J K : il trébuche et donne un coup de bedaine en se rattrapant
			PK_combo = {
				label = "Bedaine de rattrapage", startup = 0.1, active = 0.1, recovery = 0.22,
				damage = 7, hitbox = box(4.5, 3.5, 2.4, 0.3), kbBase = 24, kbGrowth = 40, kbAngle = 30, selfVelocity = Vector2.new(14, 0),
				windup = { Root = { -10, 0, 0, 0, -0.05, 0.2 }, Waist = { -16, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 40, 0, 50 }, RE = { 30, 0, 0 }, LS = { 40, 0, -50 }, LE = { 30, 0, 0 } },
				strike = { Root = { -16, 0, 0, 0, -0.15, -0.35 }, Waist = { -26, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 60, 0, 80 }, RE = { 10, 0, 0 }, LS = { 60, 0, -80 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
				follow = { Root = { -18, 0, 0, 0, -0.18, -0.4 }, Waist = { -28, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 64, 0, 84 }, RE = { 10, 0, 0 }, LS = { 64, 0, -84 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
				fx = { "burp" }, hitText = "BLOMF !",
			},
			-- K K : coup de pied qui part trop haut, il pivote sur lui-même
			K_combo2 = {
				label = "Pied qui s'emballe", startup = 0.12, active = 0.12, recovery = 0.26,
				damage = 8, hitbox = box(5, 3, 3, 0.8), kbBase = 26, kbGrowth = 45, kbAngle = 40,
				windup = { Root = { 6, 30, 0, 0, -0.15, 0.1 }, Waist = { 6, 36, 0 }, RS = { 40, 0, 50 }, RE = { 40, 0, 0 }, LS = { 40, 0, -50 }, LE = { 40, 0, 0 }, RH = { -20, 0, 10 }, RK = { -60, 0, 0 } },
				strike = { Root = { 10, -40, 0, 0, -0.1, -0.1 }, Waist = { 10, -50, 0 }, RS = { 70, 0, 70 }, RE = { 20, 0, 0 }, LS = { 70, 0, -70 }, LE = { 20, 0, 0 }, RH = { 110, 0, 20 }, RK = { -6, 0, 0 }, RA = { 10, 0, 0 } },
				follow = { Root = { 12, -60, 0, 0, -0.1, -0.12 }, Waist = { 12, -70, 0 }, RS = { 74, 0, 74 }, RE = { 20, 0, 0 }, LS = { 74, 0, -74 }, LE = { 20, 0, 0 }, RH = { 116, 0, 24 }, RK = { 0, 0, 0 }, RA = { 14, 0, 0 } },
				spin = { axis = "y", degrees = 360 }, trail = "rightFoot", hitText = "WOUPS !",
			},
			-- K J : roulade d'ivrogne en avant, il fauche les jambes au passage
			KP_combo = {
				label = "Roulade d'ivrogne", startup = 0.1, active = 0.24, recovery = 0.3,
				damage = 9, hitbox = box(5, 2.5, 2, -0.8), kbBase = 28, kbGrowth = 50, kbAngle = 70, selfVelocity = Vector2.new(36, 0),
				windup = { Root = { 30, 0, 0, 0, -0.6, 0.1 }, Waist = { 30, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 120, 0, 20 }, RE = { 60, 0, 0 }, LS = { 120, 0, -20 }, LE = { 60, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { 60, 0, 0 }, LK = { -100, 0, 0 } },
				strike = { Root = { 60, 0, 0, 0, -0.9, -0.2 }, Waist = { 40, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 140, 0, 30 }, RE = { 90, 0, 0 }, LS = { 140, 0, -30 }, LE = { 90, 0, 0 }, RH = { 100, 0, 0 }, RK = { -130, 0, 0 }, LH = { 100, 0, 0 }, LK = { -130, 0, 0 } },
				follow = { Root = { 64, 0, 0, 0, -0.9, -0.24 }, Waist = { 42, 0, 0 }, Neck = { 42, 0, 0 }, RS = { 144, 0, 32 }, RE = { 92, 0, 0 }, LS = { 144, 0, -32 }, LE = { 92, 0, 0 }, RH = { 104, 0, 0 }, RK = { -134, 0, 0 }, LH = { 104, 0, 0 }, LK = { -134, 0, 0 } },
				spin = { axis = "x", degrees = 360 }, trail = "body", fx = { "dust" }, hitText = "ROULÉ-BOULÉ !",
			},
			-- K K J : le « câlin » d'ivrogne : il serre l'adversaire et le secoue (finition du combo)
			KKP_combo = {
				label = "Câlin d'ivrogne", startup = 0.12, active = 0.2, recovery = 0.32,
				damage = 10, hits = 2, hitbox = box(4, 3.5, 2.2, 0.8), kbBase = 30, kbGrowth = 60, kbAngle = 45,
				windup = { Root = { -6, 0, 0, 0, -0.1, 0.1 }, Waist = { -8, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 80, 0, 80 }, RE = { 20, 0, 0 }, LS = { 80, 0, -80 }, LE = { 20, 0, 0 } },
				strike = { Root = { 8, 0, 0, 0, -0.15, -0.3 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 90, 0, 10 }, RE = { 90, 0, 0 }, LS = { 90, 0, -10 }, LE = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
				follow = { Root = { 10, 0, 0, 0, -0.15, -0.32 }, Waist = { 12, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 94, 0, 8 }, RE = { 94, 0, 0 }, LS = { 94, 0, -8 }, LE = { 94, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
				hold = 0.15, wobble = true, fx = { "hug" }, hitText = "T'ES MON POTE !",
			},
			-- →J : crochet titubant, le bras fait un grand arc avant de toucher
			P_side = {
				label = "Crochet titubant", startup = 0.1, active = 0.1, recovery = 0.18,
				damage = 7, hitbox = box(5, 3, 3, 0.8), kbBase = 22, kbGrowth = 35, kbAngle = 28, selfVelocity = Vector2.new(18, 0),
				windup = { Root = { 6, 30, 0, 0, -0.2, 0.2 }, Waist = { 6, 36, 0 }, RS = { 80, 0, 80 }, RE = { 40, 0, 0 }, LS = { 40, 0, -20 }, LE = { 70, 0, 0 } },
				strike = { Root = { -10, -24, 0, 0, -0.3, -0.4 }, Waist = { -10, -30, 0 }, RS = { 95, 0, -30 }, RE = { 30, 0, 0 }, LS = { 30, 0, -30 }, LE = { 80, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
				follow = { Root = { -12, -30, 0, 0, -0.32, -0.46 }, Waist = { -12, -36, 0 }, RS = { 90, 0, -44 }, RE = { 34, 0, 0 }, LS = { 26, 0, -32 }, LE = { 82, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
				wobble = true, trail = "rightHand", hitText = "SPLONK !",
			},
			-- ↓J : accroupi, il pince le mollet de l'adversaire
			P_down = {
				label = "Pinçon au mollet", startup = 0.07, active = 0.08, recovery = 0.18,
				damage = 5, hitbox = box(4, 2, 2.6, -1.3), kbBase = 20, kbGrowth = 25, kbAngle = 65,
				windup = { Root = { 10, 10, 0, 0, -0.85, 0.1 }, Waist = { 20, 10, 0 }, RS = { 40, 0, 20 }, RE = { 90, 0, 0 }, LS = { 30, 0, -30 }, LE = { 90, 0, 0 } },
				strike = { Root = { 16, -10, 0, 0, -0.95, -0.2 }, Waist = { 26, -12, 0 }, RS = { 70, 0, 0 }, RE = { 10, 0, 0 }, RW = { -20, 0, 0 }, LS = { 30, 0, -30 }, LE = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
				follow = { Root = { 18, -12, 0, 0, -0.95, -0.24 }, Waist = { 28, -14, 0 }, RS = { 66, 0, 2 }, RE = { 14, 0, 0 }, RW = { -30, 0, 0 }, LS = { 30, 0, -32 }, LE = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
				hitText = "AÏE !",
			},
			-- ↑J : il lève les bras pour trinquer… sans verre, et cogne le menton
			P_up = {
				label = "Santé sans verre", startup = 0.08, active = 0.1, recovery = 0.2,
				damage = 6, hitbox = box(4, 5, 1.5, 3), kbBase = 22, kbGrowth = 38, kbAngle = 85,
				windup = { Root = { 6, 0, 0, 0, -0.3, 0.1 }, Waist = { 8, 0, 0 }, RS = { 30, 0, 20 }, RE = { 110, 0, 0 }, LS = { 30, 0, -20 }, LE = { 110, 0, 0 } },
				strike = { Root = { -8, 0, 0, 0, 0.1, -0.1 }, Waist = { -12, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 172, 0, 10 }, RE = { 10, 0, 0 }, LS = { 172, 0, -10 }, LE = { 10, 0, 0 } },
				follow = { Root = { -10, 0, 0, 0, 0.12, -0.12 }, Waist = { -14, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 178, 0, 14 }, RE = { 10, 0, 0 }, LS = { 178, 0, -14 }, LE = { 10, 0, 0 } },
				trail = "bothHands", hitText = "SANTÉ !",
			},
			-- J en l'air : il retombe à plat ventre sur l'adversaire
			P_air = {
				label = "Plat ventre", startup = 0.1, active = 0.14, recovery = 0.18,
				damage = 7, hitbox = box(5, 3.5, 1, -1.5), kbBase = 20, kbGrowth = 32, kbAngle = -40,
				windup = { Root = { -20, 0, 0 }, Waist = { -10, 0, 0 }, RS = { 160, 0, 30 }, RE = { 30, 0, 0 }, LS = { 160, 0, -30 }, LE = { 30, 0, 0 }, RH = { 40, 0, 0 }, RK = { -80, 0, 0 }, LH = { 40, 0, 0 }, LK = { -80, 0, 0 } },
				strike = { Root = { 50, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 120, 0, 60 }, RE = { 0, 0, 0 }, LS = { 120, 0, -60 }, LE = { 0, 0, 0 }, RH = { -10, 0, 10 }, RK = { -10, 0, 0 }, LH = { -10, 0, -10 }, LK = { -10, 0, 0 } },
				follow = { Root = { 56, 0, 0 }, Waist = { 12, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 124, 0, 64 }, RE = { 0, 0, 0 }, LS = { 124, 0, -64 }, LE = { 0, 0, 0 }, RH = { -14, 0, 12 }, RK = { -12, 0, 0 }, LH = { -14, 0, -12 }, LK = { -12, 0, 0 } },
				trail = "body", hitText = "SPLAF !",
			},
			-- dash J : il court bras tendus comme pour embrasser tout le monde
			P_dash = {
				label = "Accolade de comptoir", startup = 0.08, active = 0.18, recovery = 0.24,
				damage = 7, hitbox = box(5, 3.5, 2.5, 0.8), kbBase = 24, kbGrowth = 38, kbAngle = 32, selfVelocity = Vector2.new(34, 0),
				windup = { Root = { 10, 0, 0, 0, -0.15, 0.2 }, Waist = { 10, 0, 0 }, RS = { 40, 0, 60 }, RE = { 30, 0, 0 }, LS = { 40, 0, -60 }, LE = { 30, 0, 0 } },
				strike = { Root = { 16, 0, 0, 0, -0.2, -0.3 }, Waist = { 12, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 90, 0, 40 }, RE = { 10, 0, 0 }, LS = { 90, 0, -40 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
				follow = { Root = { 18, 0, 0, 0, -0.22, -0.34 }, Waist = { 14, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 94, 0, 30 }, RE = { 20, 0, 0 }, LS = { 94, 0, -30 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
				fx = { "dust" }, hitText = "VIENS LÀ !",
			},
			-- K : coup de genou bancal, il perd l'équilibre en arrière
			K_neutral = {
				label = "Genou bancal", startup = 0.12, active = 0.1, recovery = 0.24,
				damage = 8, hitbox = box(4, 3, 2.4, 0.2), kbBase = 24, kbGrowth = 45, kbAngle = 45,
				windup = { Root = { 8, -8, 0, 0, -0.1, 0.1 }, Waist = { 8, -6, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, RH = { 30, 0, 0 }, RK = { -80, 0, 0 } },
				strike = { Root = { -12, 4, 0, 0, -0.05, 0.05 }, Waist = { -14, 4, 0 }, RS = { 60, 0, 60 }, RE = { 30, 0, 0 }, LS = { 60, 0, -60 }, LE = { 30, 0, 0 }, RH = { 100, 0, 0 }, RK = { -100, 0, 0 } },
				follow = { Root = { -16, 6, 0, 0, -0.05, 0.08 }, Waist = { -18, 6, 0 }, RS = { 64, 0, 64 }, RE = { 30, 0, 0 }, LS = { 64, 0, -64 }, LE = { 30, 0, 0 }, RH = { 104, 0, 0 }, RK = { -104, 0, 0 } },
				wobble = true, trail = "rightLeg", hitText = "TONK !",
			},
			-- →K : savate envoyée trop loin : la chaussure part et revient presque
			K_side = {
				label = "Savate perdue", startup = 0.14, active = 0.12, recovery = 0.28,
				damage = 9, hitbox = box(6, 3, 3.5, 0.3), kbBase = 26, kbGrowth = 50, kbAngle = 32, selfVelocity = Vector2.new(16, 0),
				windup = { Root = { 6, -12, 0, 0, -0.15, 0.15 }, Waist = { 6, -10, 0 }, RS = { 30, 0, 40 }, RE = { 50, 0, 0 }, LS = { 40, 0, -40 }, LE = { 50, 0, 0 }, RH = { 80, 0, 0 }, RK = { -110, 0, 0 } },
				strike = { Root = { 14, -4, 0, 0, -0.1, 0.05 }, Waist = { 16, 0, 0 }, RS = { 55, 0, 58 }, RE = { 30, 0, 0 }, LS = { 62, 0, -58 }, LE = { 30, 0, 0 }, RH = { 100, 0, 0 }, RK = { -6, 0, 0 }, RA = { 20, 0, 0 } },
				follow = { Root = { 18, -2, 0, 0, -0.1, 0.1 }, Waist = { 20, 0, 0 }, RS = { 60, 0, 65 }, RE = { 25, 0, 0 }, LS = { 68, 0, -65 }, LE = { 25, 0, 0 }, RH = { 108, 0, 0 }, RK = { 0, 0, 0 }, RA = { 24, 0, 0 } },
				trail = "rightFoot", fx = { "slipper" }, hitText = "FLOP !",
			},
			-- ↓K : il glisse, tombe sur les fesses et fauche avec les deux jambes
			K_down = {
				label = "Chute fauchante", startup = 0.12, active = 0.14, recovery = 0.3,
				damage = 8, hitbox = box(6, 2, 3, -1.5), kbBase = 26, kbGrowth = 45, kbAngle = 75,
				windup = { Root = { -10, 0, 0, 0, -0.3, 0 }, Waist = { -10, 0, 0 }, RS = { 60, 0, 40 }, RE = { 30, 0, 0 }, LS = { 60, 0, -40 }, LE = { 30, 0, 0 } },
				strike = { Root = { -30, 0, 0, 0, -1.0, -0.1 }, Waist = { -10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 20, 0, 50 }, RE = { 10, 0, 0 }, LS = { 20, 0, -50 }, LE = { 10, 0, 0 }, RH = { 80, 0, 10 }, RK = { -4, 0, 0 }, LH = { 80, 0, -10 }, LK = { -4, 0, 0 } },
				follow = { Root = { -32, 0, 0, 0, -1.0, -0.12 }, Waist = { -12, 0, 0 }, Neck = { 22, 0, 0 }, RS = { 16, 0, 54 }, RE = { 10, 0, 0 }, LS = { 16, 0, -54 }, LE = { 10, 0, 0 }, RH = { 86, 0, 12 }, RK = { 0, 0, 0 }, LH = { 86, 0, -12 }, LK = { 0, 0, 0 } },
				trail = "rightFoot", fx = { "dust", "thud" }, hitText = "BADABOUM !",
			},
			-- ↑K : coup de pied retourné raté qui touche quand même, il finit à la renverse
			K_up = {
				label = "Ciseau raté", startup = 0.14, active = 0.12, recovery = 0.3,
				damage = 9, hitbox = box(4.5, 6, 1, 3.5), kbBase = 26, kbGrowth = 55, kbAngle = 88,
				windup = { Root = { 10, 0, 0, 0, -0.3, 0.1 }, Waist = { 12, 0, 0 }, RS = { 60, 0, 40 }, RE = { 40, 0, 0 }, LS = { 60, 0, -40 }, LE = { 40, 0, 0 }, RH = { -20, 0, 0 }, RK = { -60, 0, 0 } },
				strike = { Root = { -30, 0, 0, 0, 0.1, -0.1 }, Waist = { -20, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 20, 0, 60 }, RE = { 20, 0, 0 }, LS = { 20, 0, -60 }, LE = { 20, 0, 0 }, RH = { 150, 0, 0 }, RK = { -6, 0, 0 }, RA = { 20, 0, 0 } },
				follow = { Root = { -34, 0, 0, 0, 0.12, -0.12 }, Waist = { -22, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 16, 0, 64 }, RE = { 20, 0, 0 }, LS = { 16, 0, -64 }, LE = { 20, 0, 0 }, RH = { 156, 0, 0 }, RK = { 0, 0, 0 }, RA = { 24, 0, 0 } },
				trail = "rightFoot", hitText = "OUPS-BAM !",
			},
			-- K en l'air : pédalage maladroit des deux jambes
			K_air = {
				label = "Pédalo", startup = 0.1, active = 0.2, recovery = 0.2,
				damage = 8, hits = 2, hitbox = box(5, 3.5, 2.4, -0.5), kbBase = 22, kbGrowth = 40, kbAngle = 40,
				windup = { Root = { -10, 0, 0 }, Waist = { -8, 0, 0 }, RS = { 120, 0, 40 }, RE = { 40, 0, 0 }, LS = { 120, 0, -40 }, LE = { 40, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { -20, 0, 0 }, LK = { -40, 0, 0 } },
				strike = { Root = { -6, 0, 0 }, Waist = { 6, 0, 0 }, RS = { 124, 0, 42 }, RE = { 30, 0, 0 }, LS = { 124, 0, -42 }, LE = { 30, 0, 0 }, RH = { 90, 0, 0 }, RK = { -6, 0, 0 }, LH = { 70, 0, 0 }, LK = { -110, 0, 0 } },
				follow = { Root = { -4, 0, 0 }, Waist = { 8, 0, 0 }, RS = { 126, 0, 44 }, RE = { 30, 0, 0 }, LS = { 126, 0, -44 }, LE = { 30, 0, 0 }, RH = { 20, 0, 0 }, RK = { -60, 0, 0 }, LH = { 95, 0, 0 }, LK = { -4, 0, 0 } },
				trail = "rightFoot", hitText = "PÉDALE !",
			},
			-- dash K : il glisse sur une flaque imaginaire, pieds devant
			K_dash = {
				label = "Glissade de bistrot", startup = 0.1, active = 0.24, recovery = 0.3,
				damage = 9, hitbox = box(6, 2.5, 3, -0.8), kbBase = 28, kbGrowth = 55, kbAngle = 40, selfVelocity = Vector2.new(50, 10),
				windup = { Root = { -8, 0, 0, 0, -0.4, 0 }, Waist = { -10, 0, 0 }, RS = { 60, 0, 40 }, RE = { 60, 0, 0 }, LS = { 50, 0, -40 } },
				strike = { Root = { 20, 0, 0, 0, -0.7, 0.2 }, Waist = { 10, 0, 0 }, RS = { 150, 0, 50 }, RE = { 20, 0, 0 }, LS = { 150, 0, -50 }, LE = { 20, 0, 0 }, RH = { 85, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 }, LH = { 80, 0, 0 }, LK = { -10, 0, 0 } },
				follow = { Root = { 24, 0, 0, 0, -0.72, 0.24 }, Waist = { 12, 0, 0 }, RS = { 156, 0, 55 }, RE = { 20, 0, 0 }, LS = { 156, 0, -55 }, LE = { 20, 0, 0 }, RH = { 90, 0, 0 }, RK = { 0, 0, 0 }, RA = { 14, 0, 0 }, LH = { 85, 0, 0 }, LK = { -10, 0, 0 } },
				trail = "rightFoot", fx = { "dust" }, hitText = "WAAAH !",
			},
		},
		-- Combos à mains nues : J J J (gifles puis coup de boule), J K (bedaine), K K J (câlin), K J (roulade).
		-- Un S pour finir envoie le spécial du perso (ses L restent les siens).
		links = {
			P_neutral = { P = "P_combo2", K = "PK_combo", S = "S_neutral" },
			P_combo2 = { P = "P_combo3", K = "PK_combo", S = "S_side" },
			P_combo3 = { K = "K_up", S = "S_neutral" },
			PK_combo = { P = "P_up", K = "K_combo2", S = "S_down" },
			K_neutral = { K = "K_combo2", P = "KP_combo", S = "S_side" },
			K_combo2 = { P = "KKP_combo", K = "K_up", S = "S_neutral" },
			KP_combo = { P = "P_up", K = "K_up", S = "S_up" },
			KKP_combo = { S = "S_neutral" },
			P_side = { P = "P_combo2", K = "K_side", S = "S_side" },
			P_down = { P = "P_up", K = "K_down", S = "S_down" },
			P_up = { K = "K_up", S = "S_up" },
			K_side = { P = "PK_combo", S = "S_side" },
			K_down = { P = "P_up", S = "S_down" },
			P_dash = { P = "P_combo2", K = "K_side", S = "S_side" },
			K_dash = { P = "P_up", S = "S_up" },
			P_air = { K = "K_air", S = "S_air" },
			K_air = { P = "P_air", S = "S_air" },
		},
	},
	------------------------------------------------------------------ Les 3 armes de la Caisse Bizarre (une au hasard)
	-- n° 1 : la bouteille (ses coups sont ceux de moves). n° 2 : le pack de canettes, jeu de projectiles à portée.
	-- n° 3 : le tonneau de soda, lourd et lent, qui encaisse pendant les spéciaux et éjecte loin.
	weapons = {
		{ id = "bouteille", name = "Bouteille de soda douteux", icon = "🍾",
			ability = { speed = 1.1, text = "Trottine 10 % plus vite" } },
		{ id = "canettes", name = "Pack de canettes", icon = "🥫",
			prop = { name = "PropPack", hand = "Right", pieces = {
				{ "Canette1", "", "cyl", Vector3.new(0.42, 0.75, 0.42), Vector3.new(-0.24, -0.55, 0), Vector3.new(0, 0, 0), CAN, "Metal" },
				{ "Canette2", "", "cyl", Vector3.new(0.42, 0.75, 0.42), Vector3.new(0.24, -0.55, 0), Vector3.new(0, 0, 0), CAN, "Metal" },
				{ "Canette3", "", "cyl", Vector3.new(0.42, 0.75, 0.42), Vector3.new(0, -0.55, 0.4), Vector3.new(0, 0, 0), Color3.fromRGB(60, 160, 230), "Metal" },
				{ "Carton", "", "block", Vector3.new(1.0, 0.25, 0.9), Vector3.new(0, -0.95, 0.15), Vector3.new(0, 0, 0), Color3.fromRGB(190, 150, 90), "Fabric" },
			} },
			ability = { reach = 1.2, text = "Portée de tous les coups +20 %" },
			moves = {
				-- J : il claque une canette sur le nez de l'adversaire, bras tendu
				P_neutral = {
					label = "Claque de canette", startup = 0.08, active = 0.08, recovery = 0.14,
					damage = 6, hitbox = box(4.5, 3, 2.8, 0.6), kbBase = 20, kbGrowth = 25, kbAngle = 25,
					windup = { Root = { 4, -16, 0, 0, -0.1, 0.15 }, Waist = { 4, -22, 0 }, RS = { 60, 0, 30 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -15 }, LE = { 85, 0, 0 } },
					strike = { Root = { -8, 16, 0, 0, -0.25, -0.3 }, Waist = { -10, 26, 0 }, RS = { 98, 0, 4 }, RE = { 8, 0, 0 }, RW = { -20, 0, 0 }, LS = { -8, 0, -20 }, LE = { 100, 0, 0 } },
					follow = { Root = { -10, 22, 0, 0, -0.28, -0.4 }, Waist = { -14, 32, 0 }, RS = { 84, 0, 0 }, RE = { 14, 0, 0 }, RW = { -45, 0, 0 }, LS = { -14, 0, -20 }, LE = { 105, 0, 0 } },
					trail = "prop", hitText = "TCHAC !",
				},
				-- →J : canette lancée à bout portant, qui rebondit sur le front (petit projectile court)
				P_side = {
					label = "Canette au front", kind = "projectile", startup = 0.1, active = 0, recovery = 0.2,
					damage = 7, kbBase = 22, kbGrowth = 35, kbAngle = 30,
					projectile = { speed = 70, angle = 5, gravity = 40, lifetime = 0.3, size = 1.2, color = CAN, visual = "can", aim = false },
					windup = { Root = { 6, -26, 0, 0, -0.15, 0.2 }, Waist = { 6, -30, 0 }, RS = { 160, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -10 }, LE = { 30, 0, 0 } },
					strike = { Root = { -10, 20, 0, 0, -0.3, -0.35 }, Waist = { -12, 26, 0 }, RS = { 95, 0, 0 }, RE = { 0, 0, 0 }, RW = { 10, 0, 0 }, LS = { 50, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -12, 24, 0, 0, -0.32, -0.4 }, Waist = { -14, 30, 0 }, RS = { 90, 0, 4 }, RE = { 6, 0, 0 }, RW = { -10, 0, 0 }, LS = { 45, 0, -45 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					hitText = "BLONG !",
				},
				-- ↓J : accroupi, il fait rouler une canette dans les tibias
				P_down = {
					label = "Canette roulante", startup = 0.1, active = 0.12, recovery = 0.2,
					damage = 6, hitbox = box(6, 2, 3.5, -1.4), kbBase = 22, kbGrowth = 30, kbAngle = 70,
					windup = { Root = { 10, 0, 0, 0, -0.9, 0.1 }, Waist = { 20, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 120, 0, 10 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 90, 0, 0 } },
					strike = { Root = { 16, 0, 0, 0, -1.0, -0.2 }, Waist = { 26, 0, 0 }, Neck = { 14, 0, 0 }, RS = { 30, 0, 10 }, RE = { 0, 0, 0 }, RW = { -30, 0, 0 }, LS = { 40, 0, -30 }, LE = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { 18, 0, 0, 0, -1.0, -0.24 }, Waist = { 28, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 20, 0, 12 }, RE = { 0, 0, 0 }, RW = { -40, 0, 0 }, LS = { 44, 0, -32 }, LE = { 90, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
					fx = { { "toss", shape = "cyl", color = CAN, size = 0.5, count = 1, speed = 18 } }, hitText = "ROULE !",
				},
				-- ↑J : il décapsule une canette sous le menton, le jet de mousse soulève
				P_up = {
					label = "Mousse au menton", startup = 0.1, active = 0.1, recovery = 0.2,
					damage = 7, hitbox = box(4, 5, 1.5, 3), kbBase = 24, kbGrowth = 40, kbAngle = 85,
					windup = { Root = { 8, 0, 0, 0, -0.3, 0.1 }, Waist = { 10, 0, 0 }, RS = { 40, 0, 20 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 100, 0, 0 } },
					strike = { Root = { -10, 0, 0, 0, 0.1, -0.1 }, Waist = { -14, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 170, 0, 10 }, RE = { 10, 0, 0 }, RW = { -40, 0, 0 }, LS = { 60, 0, -30 }, LE = { 80, 0, 0 } },
					follow = { Root = { -12, 0, 0, 0, 0.12, -0.12 }, Waist = { -16, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 178, 0, 12 }, RE = { 10, 0, 0 }, RW = { -50, 0, 0 }, LS = { 64, 0, -32 }, LE = { 80, 0, 0 } },
					fx = { { "particles", tex = "spark", color = Color3.fromRGB(255, 250, 220), dir = "up", at = "hand", time = 0.25, speed = 16, size = 0.5, rate = 70 } }, hitText = "PSCHIT !",
				},
				-- J en l'air : il balance le pack entier en dessous de lui
				P_air = {
					label = "Pack plongeant", startup = 0.1, active = 0.12, recovery = 0.16,
					damage = 8, hitbox = box(4.5, 4, 1.5, -1.5), kbBase = 20, kbGrowth = 35, kbAngle = -40,
					windup = { Root = { 10, 0, 0 }, Waist = { 16, 0, 0 }, RS = { 185, 0, 12 }, RE = { 55, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -40 }, LE = { 40, 0, 0 }, RH = { 40, 0, 0 }, RK = { -80, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { -12, 0, 0 }, Waist = { -30, 0, 0 }, RS = { 50, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -25, 0, -45 }, LE = { 20, 0, 0 }, RH = { 15, 0, 0 }, RK = { -35, 0, 0 }, LH = { 35, 0, 0 }, LK = { -70, 0, 0 } },
					follow = { Root = { -18, 0, 0 }, Waist = { -36, 0, 0 }, RS = { 22, 0, 5 }, RE = { 8, 0, 0 }, RW = { -20, 0, 0 }, LS = { -35, 0, -50 }, LE = { 20, 0, 0 }, RH = { 5, 0, 0 }, RK = { -30, 0, 0 }, LH = { 30, 0, 0 }, LK = { -65, 0, 0 } },
					trail = "prop", hitText = "BLAM !",
				},
				-- dash J : en courant, il jette deux canettes devant lui
				P_dash = {
					label = "Double canette", kind = "projectile", startup = 0.08, active = 0, recovery = 0.22,
					damage = 6, kbBase = 22, kbGrowth = 35, kbAngle = 30, selfVelocity = Vector2.new(30, 0),
					projectile = { speed = 75, angle = 8, gravity = 50, lifetime = 0.35, size = 1.1, color = CAN, visual = "can", aim = false, fan = { count = 2, from = 0, to = 20 } },
					windup = { Root = { 8, -20, 0, 0, -0.1, 0.2 }, Waist = { 8, -24, 0 }, RS = { 150, 0, 20 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -20 }, LE = { 40, 0, 0 } },
					strike = { Root = { -8, 18, 0, 0, -0.2, -0.3 }, Waist = { -10, 22, 0 }, RS = { 92, 0, 0 }, RE = { 0, 0, 0 }, RW = { 10, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -10, 22, 0, 0, -0.24, -0.34 }, Waist = { -12, 26, 0 }, RS = { 88, 0, 2 }, RE = { 6, 0, 0 }, RW = { -10, 0, 0 }, LS = { 36, 0, -44 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					hitText = "BLING !",
				},
				-- K : coup de pied dans une canette posée au sol, qui part comme un ballon
				K_neutral = {
					label = "Shoot de canette", kind = "projectile", startup = 0.18, active = 0, recovery = 0.3,
					damage = 10, kbBase = 28, kbGrowth = 55, kbAngle = 30,
					projectile = { speed = 80, angle = 10, gravity = 60, lifetime = 0.45, size = 1.3, color = CAN, visual = "can", aim = false },
					windup = { Root = { 6, -10, 0, 0, -0.15, 0.1 }, Waist = { 6, -8, 0 }, RS = { 30, 0, 40 }, RE = { 50, 0, 0 }, LS = { 50, 0, -40 }, LE = { 50, 0, 0 }, RH = { -30, 0, 0 }, RK = { -60, 0, 0 } },
					strike = { Root = { 10, 0, 0, 0, -0.1, 0.05 }, Waist = { 12, 0, 0 }, RS = { 60, 0, 55 }, RE = { 30, 0, 0 }, LS = { 70, 0, -55 }, LE = { 30, 0, 0 }, RH = { 95, 0, 0 }, RK = { -4, 0, 0 }, RA = { 10, 0, 0 } },
					follow = { Root = { 14, 0, 0, 0, -0.1, 0.1 }, Waist = { 16, 0, 0 }, RS = { 64, 0, 60 }, RE = { 25, 0, 0 }, LS = { 74, 0, -60 }, LE = { 25, 0, 0 }, RH = { 104, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 } },
					trail = "rightFoot", hitText = "PÉNO !",
				},
				-- →K : coup de pied retourné en tenant le pack à bout de bras (il sert de contrepoids)
				K_side = {
					label = "Retourné au pack", startup = 0.16, active = 0.12, recovery = 0.32,
					damage = 12, hitbox = box(6, 3.5, 3.5, 0.5), kbBase = 32, kbGrowth = 70, kbAngle = 35, selfVelocity = Vector2.new(22, 0),
					windup = { Root = { 6, 30, 0, 0, -0.2, 0.1 }, Waist = { 8, 40, 0 }, RS = { 120, 0, 60 }, RE = { 20, 0, 0 }, LS = { 40, 0, -40 }, LE = { 70, 0, 0 }, RH = { -20, 0, 10 }, RK = { -50, 0, 0 } },
					strike = { Root = { 10, -40, 0, 0, -0.1, -0.1 }, Waist = { 10, -50, 0 }, RS = { 80, 0, 80 }, RE = { 10, 0, 0 }, LS = { 60, 0, -50 }, LE = { 40, 0, 0 }, RH = { 100, 0, 20 }, RK = { -6, 0, 0 }, RA = { 10, 0, 0 } },
					follow = { Root = { 12, -50, 0, 0, -0.1, -0.14 }, Waist = { 12, -60, 0 }, RS = { 84, 0, 84 }, RE = { 10, 0, 0 }, LS = { 64, 0, -54 }, LE = { 40, 0, 0 }, RH = { 108, 0, 24 }, RK = { 0, 0, 0 }, RA = { 14, 0, 0 } },
					spin = { axis = "y", degrees = 360 }, trail = "rightFoot", hitText = "VLAN !",
				},
				-- ↓K : balayette basse, le pack posé par terre pour s'appuyer dessus
				K_down = {
					label = "Balayette au pack", startup = 0.14, active = 0.14, recovery = 0.3,
					damage = 9, hitbox = box(7, 2, 3.5, -1.6), kbBase = 28, kbGrowth = 50, kbAngle = 75,
					windup = { Root = { 12, 10, 0, 0, -0.85, 0.1 }, Waist = { 16, 14, 0 }, RS = { 60, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -40 }, LE = { 80, 0, 0 }, LH = { -30, 0, 0 }, LK = { -40, 0, 0 } },
					strike = { Root = { 16, -20, 0, 0, -0.95, -0.1 }, Waist = { 20, -26, 0 }, RS = { 50, 0, 40 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -40 }, LE = { 80, 0, 0 }, LH = { 50, 0, -20 }, LK = { -4, 0, 0 }, LA = { 20, 0, 0 } },
					follow = { Root = { 18, -26, 0, 0, -0.95, -0.14 }, Waist = { 22, -32, 0 }, RS = { 52, 0, 42 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 34, 0, -42 }, LE = { 80, 0, 0 }, LH = { 56, 0, -24 }, LK = { 0, 0, 0 }, LA = { 24, 0, 0 } },
					trail = "leftFoot", fx = { "dust" }, hitText = "FAUCHÉ !",
				},
				-- ↑K : coup de pied monté, une canette lâchée explose au plafond au même moment
				K_up = {
					label = "Pied et canette au plafond", startup = 0.16, active = 0.12, recovery = 0.32,
					damage = 11, hitbox = box(4.5, 6, 1.5, 3.5), kbBase = 30, kbGrowth = 65, kbAngle = 88,
					windup = { Root = { 10, 0, 0, 0, -0.25, 0.1 }, Waist = { 14, 0, 0 }, RS = { 100, 0, 40 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 }, RH = { -20, 0, 0 }, RK = { -60, 0, 0 } },
					strike = { Root = { -16, 0, 0, 0, 0.05, -0.1 }, Waist = { -20, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 160, 0, 20 }, RE = { 20, 0, 0 }, RW = { -30, 0, 0 }, LS = { 30, 0, -50 }, LE = { 30, 0, 0 }, RH = { 140, 0, 0 }, RK = { -6, 0, 0 }, RA = { 20, 0, 0 } },
					follow = { Root = { -18, 0, 0, 0, 0.08, -0.12 }, Waist = { -22, 0, 0 }, Neck = { -24, 0, 0 }, RS = { 166, 0, 22 }, RE = { 20, 0, 0 }, RW = { -36, 0, 0 }, LS = { 34, 0, -52 }, LE = { 30, 0, 0 }, RH = { 148, 0, 0 }, RK = { 0, 0, 0 }, RA = { 24, 0, 0 } },
					trail = "rightFoot", fx = { { "burst", color = CAN, size = 2, at = "above" } }, hitText = "KLANG !",
				},
				-- K en l'air : double coup de pied en pédalant, le pack au-dessus de la tête
				K_air = {
					label = "Pédalage pétillant", startup = 0.12, active = 0.2, recovery = 0.2,
					damage = 10, hits = 2, hitbox = box(5, 4, 2.5, -0.5), kbBase = 22, kbGrowth = 45, kbAngle = 40,
					windup = { Root = { -10, 0, 0 }, Waist = { -8, 0, 0 }, RS = { 170, 0, 20 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -20 }, LE = { 40, 0, 0 }, RH = { 60, 0, 0 }, RK = { -100, 0, 0 }, LH = { -20, 0, 0 }, LK = { -40, 0, 0 } },
					strike = { Root = { -6, 0, 0 }, Waist = { 6, 0, 0 }, RS = { 174, 0, 22 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 174, 0, -22 }, LE = { 30, 0, 0 }, RH = { 90, 0, 0 }, RK = { -6, 0, 0 }, RA = { 10, 0, 0 }, LH = { 70, 0, 0 }, LK = { -110, 0, 0 } },
					follow = { Root = { -4, 0, 0 }, Waist = { 8, 0, 0 }, RS = { 176, 0, 24 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 176, 0, -24 }, LE = { 30, 0, 0 }, RH = { 20, 0, 0 }, RK = { -60, 0, 0 }, LH = { 95, 0, 0 }, LK = { -4, 0, 0 }, LA = { 10, 0, 0 } },
					trail = "rightFoot", hitText = "TAC TAC !",
				},
				-- dash K : glissade sur le carton du pack, pieds devant
				K_dash = {
					label = "Glissade au carton", startup = 0.1, active = 0.26, recovery = 0.3,
					damage = 11, hitbox = box(6, 3, 3, -0.8), kbBase = 30, kbGrowth = 65, kbAngle = 38, selfVelocity = Vector2.new(55, 12),
					windup = { Root = { -8, 0, 0, 0, -0.4, 0 }, Waist = { -10, 0, 0 }, RS = { 60, 0, 40 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -40 } },
					strike = { Root = { 20, 0, 0, 0, -0.7, 0.2 }, Waist = { 10, 0, 0 }, RS = { -30, 0, 50 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -40 }, LE = { 30, 0, 0 }, RH = { 85, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 }, LH = { 80, 0, 0 }, LK = { -10, 0, 0 } },
					follow = { Root = { 24, 0, 0, 0, -0.72, 0.24 }, Waist = { 12, 0, 0 }, RS = { -36, 0, 55 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 75, 0, -45 }, LE = { 30, 0, 0 }, RH = { 90, 0, 0 }, RK = { 0, 0, 0 }, RA = { 14, 0, 0 }, LH = { 85, 0, 0 }, LK = { -10, 0, 0 } },
					trail = "rightFoot", fx = { "dust" }, hitText = "SKRRRT !",
				},
				-- L : rafale de canettes secouées qui foncent sur l'adversaire (visée automatique)
				S_neutral = {
					label = "Rafale de canettes", kind = "projectile", startup = 0.22, active = 0, recovery = 0.45,
					damage = 5, kbBase = 24, kbGrowth = 40, kbAngle = 30,
					projectile = { speed = 85, angle = 0, gravity = 0, lifetime = 0.6, size = 1.3, color = CAN, visual = "can", fan = { count = 3, from = -8, to = 8 } },
					windup = { Root = { 6, -20, 0, 0, -0.2, 0.2 }, Waist = { 8, -26, 0 }, Neck = { 4, 16, 0 }, RS = { 150, 0, 30 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -10 }, LE = { 40, 0, 0 } },
					strike = { Root = { -12, 18, 0, 0, -0.3, -0.35 }, Waist = { -14, 24, 0 }, Neck = { 0, -12, 0 }, RS = { 96, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -14, 22, 0, 0, -0.34, -0.42 }, Waist = { -18, 28, 0 }, Neck = { 0, -16, 0 }, RS = { 100, 0, 6 }, RE = { 6, 0, 0 }, RW = { -8, 0, 0 }, LS = { 55, 0, -45 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					shake = true, windupFx = { "sodaShake" }, fx = { { "burst", color = CAN, size = 2, at = "hand" } }, text = "RAFALE !", hitText = "TING TING !",
				},
				-- →L : la canette-fusée : décapsulée à l'envers, elle part comme une torpille sur l'adversaire
				S_side = {
					label = "Canette-fusée", kind = "projectile", startup = 0.24, active = 0, recovery = 0.5,
					damage = 15, kbBase = 32, kbGrowth = 62, kbAngle = 35,
					projectile = { speed = 95, angle = 0, gravity = 0, lifetime = 0.7, size = 1.8, color = CAN, visual = "can" },
					status = { name = "wet", duration = 2 },
					windup = { Root = { 8, -30, 0, 0, -0.2, 0.25 }, Waist = { 10, -34, 0 }, Neck = { 6, 20, 0 }, RS = { 40, 0, 20 }, RE = { 120, 0, 0 }, RW = { 20, 0, 0 }, LS = { 40, 0, -20 }, LE = { 110, 0, 0 } },
					strike = { Root = { -14, 20, 0, 0, -0.32, -0.4 }, Waist = { -16, 26, 0 }, Neck = { -4, -14, 0 }, RS = { 94, 0, -4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, 6 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					follow = { Root = { -16, 24, 0, 0, -0.36, -0.46 }, Waist = { -20, 30, 0 }, Neck = { -6, -16, 0 }, RS = { 98, 0, -6 }, RE = { 4, 0, 0 }, RW = { 6, 0, 0 }, LS = { 94, 0, 8 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
					shake = true, windupFx = { "sodaShake" }, fx = { { "beam", color = SODA, length = 12, width = 2, at = "hand" }, { "particles", tex = "spark", color = SODA, dir = "front", at = "hand", time = 0.3, speed = 20, size = 0.5, rate = 80 } },
					text = "TORPILLE !", hitText = "KABLONG !",
				},
				-- ↓L : il écrase une canette sous sa semelle, la mousse jaillit en vague sur tout le couloir
				S_down = {
					label = "Vague de mousse", startup = 0.22, active = 0.2, recovery = 0.5,
					damage = 13, hitbox = box(14, 5, 7, 0.8), kbBase = 28, kbGrowth = 50, kbAngle = 40,
					status = { name = "slippery", duration = 2 },
					windup = { Root = { 10, 0, 0, 0, -0.4, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 60, 0, 30 }, RE = { 90, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -30 }, LE = { 80, 0, 0 }, RH = { -60, 0, 0 }, RK = { -70, 0, 0 } },
					strike = { Root = { -8, 0, 0, 0, -0.2, -0.2 }, Waist = { -12, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 30, 0, 50 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -50 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0, -0.5 } },
					follow = { Root = { -10, 0, 0, 0, -0.22, -0.24 }, Waist = { -14, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 34, 0, 54 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 34, 0, -54 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0, -0.52 } },
					hold = 0.1, fx = { "puddle", { "beam", color = Color3.fromRGB(255, 250, 225), length = 14, width = 2.5, at = "feet" }, { "ring", color = SODA, radius = 6, at = "feet" } }, text = "SCRATCH !", hitText = "MOUSSÉ !",
				},
				-- ↑L : deux canettes secouées sous les bras comme des réacteurs : décollage en diagonale sur une traînée de mousse
				S_up = {
					label = "Réacteurs de canettes", startup = 0.12, active = 0.3, recovery = 0.4,
					damage = 13, hitbox = box(10, 11, 3, 4), kbBase = 32, kbGrowth = 52, kbAngle = 72, selfVelocity = Vector2.new(42, 82),
					windup = { Root = { 6, 0, 0, 0, -0.8, 0.1 }, Waist = { -10, 0, 0 }, Neck = { 26, 0, 0 }, RS = { 20, 0, 30 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 20, 0, -30 }, LE = { 120, 0, 0 } },
					strike = { Root = { -40, 0, 0, 0, 0.4, -0.2 }, Waist = { -6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { -40, 0, 50 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -50 }, LE = { 10, 0, 0 }, RH = { -25, 0, 5 }, RK = { -30, 0, 0 }, LH = { -15, 0, -5 }, LK = { -50, 0, 0 } },
					follow = { Root = { -44, 0, 0, 0, 0.45, -0.25 }, Waist = { -8, 0, 0 }, Neck = { 32, 0, 0 }, RS = { -46, 0, 55 }, RE = { 10, 0, 0 }, RW = { -8, 0, 0 }, LS = { -46, 0, -55 }, LE = { 10, 0, 0 }, RH = { -30, 0, 6 }, RK = { -35, 0, 0 }, LH = { -20, 0, -6 }, LK = { -55, 0, 0 } },
					shake = true, trail = "body", fx = { { "particles", tex = "spark", color = Color3.fromRGB(255, 250, 220), dir = "down", at = "feet", time = 0.5, speed = 18, size = 0.6, rate = 90 }, { "ring", color = SODA, radius = 5, at = "feet" } },
					text = "DÉCOLLAGE !", hitText = "FSHHH !",
				},
				-- L en l'air : pluie de canettes lâchées sous lui, qui tombent sur l'adversaire
				S_air = {
					label = "Pluie de canettes", kind = "projectile", startup = 0.15, active = 0, recovery = 0.4,
					damage = 6, kbBase = 24, kbGrowth = 45, kbAngle = -40,
					projectile = { speed = 60, angle = -70, gravity = 40, lifetime = 0.7, size = 1.2, color = CAN, visual = "can", rain = { count = 4, spread = 6 } },
					windup = { Root = { 10, 0, 0 }, Waist = { 14, 0, 0 }, RS = { 170, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -20 }, LE = { 60, 0, 0 }, RH = { 40, 0, 0 }, RK = { -80, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { -14, 0, 0 }, Waist = { -28, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 20, 0, 10 }, RE = { 0, 0, 0 }, RW = { -40, 0, 0 }, LS = { 20, 0, -10 }, LE = { 0, 0, 0 }, LW = { -40, 0, 0 }, RH = { 20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 30, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { -18, 0, 0 }, Waist = { -32, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 16, 0, 12 }, RE = { 4, 0, 0 }, RW = { -50, 0, 0 }, LS = { 16, 0, -12 }, LE = { 4, 0, 0 }, LW = { -50, 0, 0 }, RH = { 16, 0, 0 }, RK = { -36, 0, 0 }, LH = { 26, 0, 0 }, LK = { -56, 0, 0 } },
					fx = { { "burst", color = CAN, size = 2, at = "feet" } }, text = "LÂCHER !", hitText = "PLONK !",
				},
				-- Y : le pack entier secoué comme un maraca, 12 canettes en éventail qui filent toutes sur l'adversaire
				SUPER = {
					label = "Maraca de canettes !", kind = "projectile", startup = 0.35, active = 0, recovery = 0.6,
					damage = 4, kbBase = 25, kbGrowth = 40, kbAngle = 40,
					projectile = { speed = 75, angle = 0, gravity = 0, lifetime = 1.0, size = 1.4, color = CAN, visual = "can", fan = { count = 8, from = -20, to = 40 } },
					status = { name = "inverted", duration = 3 },
					windup = { Root = { 0, 0, 0, 0, -0.85, 0.15 }, Waist = { -25, 0, 0 }, RS = { 60, 0, -40 }, RE = { 90, 0, 0 }, LS = { 60, 0, 40 }, LE = { 90, 0, 0 } },
					strike = { Root = { 0, 0, 0, 0, 0.3, 0 }, Waist = { 20, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 150, 0, 70 }, RE = { 0, 0, 0 }, LS = { 150, 0, -70 }, LE = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
					follow = { Root = { 4, 0, 0, 0, 0.2, 0 }, Waist = { 24, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 160, 0, 80 }, RE = { 5, 0, 0 }, LS = { 160, 0, -80 }, LE = { 5, 0, 0 } },
					shake = true, windupFx = { "super", "sodaShake" }, text = "MARACA !", hitText = "TING TING TING !",
				},
				-- →Y : la canette géante : il gonfle une canette à la pompe à vélo et la lance comme un obus qui traverse le couloir
				SUPER_side = {
					label = "Canette géante !", kind = "projectile", startup = 0.4, active = 0, recovery = 0.7,
					damage = 26, kbBase = 50, kbGrowth = 100, kbAngle = 30,
					projectile = { speed = 90, angle = 0, gravity = 0, lifetime = 0.9, size = 3.2, color = CAN, visual = "can", pierce = true },
					windup = { Root = { 10, -30, 0, 0, -0.5, 0.3 }, Waist = { 14, -34, 0 }, Neck = { 10, 20, 0 }, RS = { 30, 0, 30 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -30 }, LE = { 120, 0, 0 } },
					strike = { Root = { -18, 22, 0, 0, -0.3, -0.5 }, Waist = { -20, 28, 0 }, Neck = { -6, -16, 0 }, RS = { 96, 0, -2 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, 4 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					follow = { Root = { -20, 26, 0, 0, -0.34, -0.56 }, Waist = { -24, 32, 0 }, Neck = { -8, -18, 0 }, RS = { 100, 0, -4 }, RE = { 4, 0, 0 }, RW = { 6, 0, 0 }, LS = { 96, 0, 6 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.52 } },
					shake = true, windupFx = { "super", { "symbols", symbols = { "🥫" }, count = 6, radius = 3, color = CAN } }, fx = { { "burst", color = CAN, size = 3.5, at = "hand" }, { "shake", amount = 0.4 } },
					text = "OBUS !", hitText = "KA-BLONG !",
				},
				-- ↑Y : la fontaine : il décapsule tout le pack en même temps sous ses pieds et décolle sur un geyser de mousse
				SUPER_up = {
					label = "Fontaine de canettes !", startup = 0.35, active = 0.3, recovery = 0.7,
					damage = 24, hitbox = box(16, 12, 8, 5), kbBase = 45, kbGrowth = 95, kbAngle = 86, invuln = 0.3, selfVelocity = Vector2.new(0, 55),
					windup = { Root = { -10, 0, 0, 0, -0.95, 0 }, Waist = { -32, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 40, 0, -20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, 20 }, LE = { 110, 0, 0 } },
					strike = { Root = { 6, 0, 0, 0, 0.5, 0 }, Waist = { 18, 0, 0 }, Neck = { 50, 0, 0 }, RS = { 186, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 186, 0, -6 }, LE = { 0, 0, 0 }, RH = { 40, 0, 10 }, RK = { -90, 0, 0 }, LH = { 20, 0, -15 }, LK = { -60, 0, 0 } },
					follow = { Root = { 10, 0, 0, 0, 0.55, 0 }, Waist = { 24, 0, 0 }, Neck = { 56, 0, 0 }, RS = { 188, 0, 10 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 188, 0, -10 }, LE = { 0, 0, 0 }, RH = { 60, 0, 20 }, RK = { -110, 0, 0 }, LH = { 10, 0, -25 }, LK = { -40, 0, 0 } },
					hold = 0.2, shake = true, spin = { axis = "y", degrees = 360 },
					windupFx = { "super", "sodaShake" }, fx = { { "pillar", color = Color3.fromRGB(255, 250, 225), height = 22, width = 3, at = "front" }, { "beam", color = SODA, length = 16, width = 5, at = "feet" }, { "burst", color = CAN, size = 4, at = "above" }, { "ring", color = SODA, radius = 6, at = "feet" } },
					text = "FONTAINE !", hitText = "PSCHIIIT !",
				},
				-- ↓Y : la roulade au sol : il fait rouler le pack entier à travers tout le couloir comme un rouleau compresseur
				SUPER_down = {
					label = "Rouleau de canettes !", startup = 0.35, active = 0.35, recovery = 0.7,
					damage = 22, hitbox = box(16, 4, 8, -0.5), kbBase = 44, kbGrowth = 90, kbAngle = 60,
					status = { name = "slowed", duration = 2 },
					windup = { Root = { 14, 0, 0, 0, -0.9, 0.2 }, Waist = { 24, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 120, 0, 20 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -20 }, LE = { 70, 0, 0 } },
					strike = { Root = { 20, 0, 0, 0, -1.0, -0.3 }, Waist = { 30, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 30, 0, 20 }, RE = { 0, 0, 0 }, RW = { -30, 0, 0 }, LS = { 30, 0, -20 }, LE = { 0, 0, 0 }, LW = { -30, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { 22, 0, 0, 0, -1.0, -0.34 }, Waist = { 32, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 20, 0, 22 }, RE = { 0, 0, 0 }, RW = { -40, 0, 0 }, LS = { 20, 0, -22 }, LE = { 0, 0, 0 }, LW = { -40, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					hold = 0.15, windupFx = { "super" }, fx = { { "toss", shape = "cyl", color = CAN, size = 1.2, count = 6, speed = 26 }, { "beam", color = CAN, length = 16, width = 3, at = "feet" }, { "shake", amount = 0.4 }, { "particles", tex = "smoke", color = Color3.fromRGB(230, 230, 230), dir = "front", at = "feet", time = 0.4, speed = 14 } },
					text = "ROULEAU !", hitText = "ÉCRASÉ !",
				},
			},
			links = {
				P_neutral = { P = "P_side", K = "K_neutral", S = "S_neutral" },
				P_side = { P = "P_up", K = "K_side", S = "S_side" },
				P_down = { P = "P_up", K = "K_down", S = "S_down" },
				K_neutral = { P = "P_neutral", K = "K_side", S = "S_side" },
				K_side = { P = "P_up", K = "K_up", S = "S_neutral" },
				P_dash = { P = "P_side", K = "K_side", S = "S_side" },
				K_dash = { P = "P_up", S = "S_up" },
			},
		},
		{ id = "tonneau", name = "Tonneau de soda", icon = "🛢️",
			prop = { name = "PropTonneau", hand = "Right", pieces = {
				{ "Fut", "", "cyl", Vector3.new(1.3, 1.7, 1.3), Vector3.new(0, -1.05, 0), Vector3.new(0, 0, 0), WOODY, "Wood" },
				{ "Cercle1", "", "cyl", Vector3.new(1.38, 0.14, 1.38), Vector3.new(0, -0.5, 0), Vector3.new(0, 0, 0), Color3.fromRGB(70, 70, 75), "Metal" },
				{ "Cercle2", "", "cyl", Vector3.new(1.38, 0.14, 1.38), Vector3.new(0, -1.6, 0), Vector3.new(0, 0, 0), Color3.fromRGB(70, 70, 75), "Metal" },
				{ "Robinet", "", "cyl", Vector3.new(0.5, 0.16, 0.16), Vector3.new(0, -1.3, -0.8), Vector3.new(0, 0, 0), Color3.fromRGB(200, 170, 60), "Metal", { axis = "z" } },
			} },
			ability = { knockback = 1.25, armor = true, text = "Éjecte 25 % plus loin ; les L encaissent sans broncher" },
			moves = {
				-- J : coup de fût dans le ventre, à deux mains
				P_neutral = {
					label = "Coup de fût", startup = 0.12, active = 0.1, recovery = 0.22,
					damage = 8, hitbox = box(4.5, 3.5, 2.8, 0.5), kbBase = 24, kbGrowth = 30, kbAngle = 30,
					windup = { Root = { 4, -16, 0, 0, -0.15, 0.15 }, Waist = { 6, -20, 0 }, RS = { 60, 0, 10 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 110, 0, 0 }, LW = { 0, 0, 0 } },
					strike = { Root = { -10, 14, 0, 0, -0.28, -0.3 }, Waist = { -12, 20, 0 }, RS = { 96, 0, 4 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, -6 }, LE = { 10, 0, 0 }, LW = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
					follow = { Root = { -12, 18, 0, 0, -0.3, -0.36 }, Waist = { -14, 24, 0 }, RS = { 100, 0, 6 }, RE = { 14, 0, 0 }, RW = { -10, 0, 0 }, LS = { 96, 0, -8 }, LE = { 14, 0, 0 }, LW = { -10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.38 } },
					trail = "prop", hitText = "BOUM !",
				},
				-- →J : balayage horizontal du tonneau, il pivote sur ses talons
				P_side = {
					label = "Balayage de tonneau", startup = 0.16, active = 0.12, recovery = 0.26,
					damage = 10, hitbox = box(6, 3.5, 3.5, 0.8), kbBase = 26, kbGrowth = 42, kbAngle = 28, selfVelocity = Vector2.new(16, 0),
					windup = { Root = { 6, 40, 0, 0, -0.2, 0.2 }, Waist = { 8, 46, 0 }, RS = { 70, 0, 60 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 20 }, LE = { 60, 0, 0 } },
					strike = { Root = { -8, -30, 0, 0, -0.3, -0.35 }, Waist = { -10, -36, 0 }, RS = { 90, 0, -30 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -60 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -10, -40, 0, 0, -0.32, -0.4 }, Waist = { -12, -46, 0 }, RS = { 94, 0, -36 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 94, 0, -66 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					trail = "prop", hitText = "BLAM !",
				},
				-- ↓J : il pose le tonneau par terre, lourdement, sur les orteils de l'adversaire
				P_down = {
					label = "Tonneau sur les orteils", startup = 0.14, active = 0.1, recovery = 0.26,
					damage = 9, hitbox = box(5, 2.5, 2.5, -1.5), kbBase = 26, kbGrowth = 40, kbAngle = 80,
					windup = { Root = { 6, 0, 0, 0, -0.2, 0.1 }, Waist = { -10, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 160, 0, 10 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -10 }, LE = { 40, 0, 0 } },
					strike = { Root = { 18, 0, 0, 0, -0.9, -0.2 }, Waist = { 28, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 40, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -10 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { 20, 0, 0, 0, -0.95, -0.24 }, Waist = { 30, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 36, 0, 12 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 36, 0, -12 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
					fx = { "thud", "dust" }, hitText = "AÏE LES ORTEILS !",
				},
				-- ↑J : il soulève le tonneau à bout de bras, le fond cogne le menton
				P_up = {
					label = "Tonneau au menton", startup = 0.14, active = 0.12, recovery = 0.26,
					damage = 9, hitbox = box(4.5, 5.5, 1.5, 3), kbBase = 26, kbGrowth = 45, kbAngle = 86,
					windup = { Root = { 10, 0, 0, 0, -0.35, 0.1 }, Waist = { 14, 0, 0 }, RS = { 30, 0, 10 }, RE = { 120, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -10 }, LE = { 120, 0, 0 } },
					strike = { Root = { -12, 0, 0, 0, 0.1, -0.1 }, Waist = { -16, 0, 0 }, Neck = { -22, 0, 0 }, RS = { 172, 0, 8 }, RE = { 6, 0, 0 }, RW = { 0, 0, 0 }, LS = { 172, 0, -8 }, LE = { 6, 0, 0 } },
					follow = { Root = { -14, 0, 0, 0, 0.14, -0.12 }, Waist = { -18, 0, 0 }, Neck = { -26, 0, 0 }, RS = { 178, 0, 10 }, RE = { 6, 0, 0 }, RW = { -10, 0, 0 }, LS = { 178, 0, -10 }, LE = { 6, 0, 0 } },
					trail = "prop", hitText = "KLONK !",
				},
				-- J en l'air : il laisse tomber le tonneau sous lui et se rattrape dessus
				P_air = {
					label = "Tonneau tombant", startup = 0.12, active = 0.14, recovery = 0.18,
					damage = 10, hitbox = box(4.5, 4, 1, -1.8), kbBase = 24, kbGrowth = 40, kbAngle = -45,
					windup = { Root = { 8, 0, 0 }, Waist = { 14, 0, 0 }, RS = { 185, 0, 10 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 185, 0, -10 }, LE = { 40, 0, 0 }, RH = { 40, 0, 0 }, RK = { -80, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { -10, 0, 0 }, Waist = { -28, 0, 0 }, RS = { 40, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -5 }, LE = { 0, 0, 0 }, RH = { 15, 0, 0 }, RK = { -35, 0, 0 }, LH = { 35, 0, 0 }, LK = { -70, 0, 0 } },
					follow = { Root = { -14, 0, 0 }, Waist = { -32, 0, 0 }, RS = { 20, 0, 5 }, RE = { 8, 0, 0 }, RW = { -20, 0, 0 }, LS = { 20, 0, -5 }, LE = { 8, 0, 0 }, RH = { 5, 0, 0 }, RK = { -30, 0, 0 }, LH = { 30, 0, 0 }, LK = { -65, 0, 0 } },
					trail = "prop", hitText = "BLAM !",
				},
				-- dash J : charge épaule contre tonneau, le fût en bélier
				P_dash = {
					label = "Bélier à tonneau", startup = 0.1, active = 0.2, recovery = 0.3,
					damage = 11, hitbox = box(6, 4, 3, 0.5), kbBase = 30, kbGrowth = 55, kbAngle = 30, selfVelocity = Vector2.new(48, 0), armor = true,
					windup = { Root = { 10, -20, 0, 0, -0.2, 0.2 }, Waist = { 12, -24, 0 }, RS = { 80, 0, 10 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, -10 }, LE = { 100, 0, 0 } },
					strike = { Root = { 18, 10, 0, 0, -0.3, -0.3 }, Waist = { 14, 14, 0 }, Neck = { -10, 0, 0 }, RS = { 96, 0, 4 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, -4 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { 20, 12, 0, 0, -0.32, -0.36 }, Waist = { 16, 16, 0 }, Neck = { -12, 0, 0 }, RS = { 100, 0, 6 }, RE = { 20, 0, 0 }, RW = { -10, 0, 0 }, LS = { 96, 0, -6 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					trail = "prop", fx = { "dust" }, hitText = "BÉLIER !",
				},
				-- K : coup de pied dans le tonneau posé devant lui, qui roule sur l'adversaire
				K_neutral = {
					label = "Tonneau roulant", startup = 0.2, active = 0.2, recovery = 0.35,
					damage = 12, hitbox = box(8, 3.5, 4.5, 0), kbBase = 32, kbGrowth = 70, kbAngle = 32,
					windup = { Root = { 8, -10, 0, 0, -0.15, 0.1 }, Waist = { 8, -8, 0 }, RS = { 40, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -40 }, LE = { 55, 0, 0 }, RH = { -30, 0, 0 }, RK = { -60, 0, 0 } },
					strike = { Root = { 12, 0, 0, 0, -0.1, 0.05 }, Waist = { 14, 0, 0 }, RS = { 60, 0, 55 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -55 }, LE = { 30, 0, 0 }, RH = { 95, 0, 0 }, RK = { -4, 0, 0 }, RA = { 10, 0, 0 } },
					follow = { Root = { 16, 0, 0, 0, -0.1, 0.1 }, Waist = { 18, 0, 0 }, RS = { 64, 0, 60 }, RE = { 25, 0, 0 }, RW = { 0, 0, 0 }, LS = { 74, 0, -60 }, LE = { 25, 0, 0 }, RH = { 104, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 } },
					trail = "rightFoot", fx = { { "toss", shape = "cyl", color = WOODY, size = 1.4, count = 1, speed = 24 }, "dust" }, hitText = "ROULE-BOULE !",
				},
				-- →K : coup de pied sauté avec le tonneau serré contre lui en bouclier
				K_side = {
					label = "Pied-bouclier", startup = 0.16, active = 0.14, recovery = 0.32,
					damage = 13, hitbox = box(6, 3.5, 3.5, 0.5), kbBase = 34, kbGrowth = 72, kbAngle = 36, selfVelocity = Vector2.new(26, 18),
					windup = { Root = { 6, -10, 0, 0, -0.2, 0.1 }, Waist = { 8, -8, 0 }, RS = { 60, 0, 10 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 110, 0, 0 }, RH = { -20, 0, 10 }, RK = { -50, 0, 0 } },
					strike = { Root = { 10, 0, 0, 0, 0.1, -0.1 }, Waist = { 12, 0, 0 }, RS = { 70, 0, 10 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -10 }, LE = { 100, 0, 0 }, RH = { 100, 0, 10 }, RK = { -6, 0, 0 }, RA = { 10, 0, 0 }, LH = { -20, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { 12, 0, 0, 0, 0.12, -0.14 }, Waist = { 14, 0, 0 }, RS = { 74, 0, 12 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 74, 0, -12 }, LE = { 100, 0, 0 }, RH = { 108, 0, 12 }, RK = { 0, 0, 0 }, RA = { 14, 0, 0 }, LH = { -24, 0, 0 }, LK = { -64, 0, 0 } },
					trail = "rightFoot", hitText = "VLAN !",
				},
				-- ↓K : il s'assoit sur le tonneau et balaie des deux jambes
				K_down = {
					label = "Balayage assis", startup = 0.16, active = 0.16, recovery = 0.34,
					damage = 10, hitbox = box(7, 2.2, 3.5, -1.6), kbBase = 28, kbGrowth = 52, kbAngle = 76,
					windup = { Root = { 6, 0, 0, 0, -0.5, 0.1 }, Waist = { 10, 0, 0 }, RS = { 40, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 60, 0, 0 }, RH = { 40, 0, 0 }, RK = { -60, 0, 0 }, LH = { 40, 0, 0 }, LK = { -60, 0, 0 } },
					strike = { Root = { 14, 0, 0, 0, -0.75, -0.15 }, Waist = { 18, 0, 0 }, RS = { 50, 0, 40 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -40 }, LE = { 30, 0, 0 }, RH = { 90, 0, 10 }, RK = { -4, 0, 0 }, RA = { 20, 0, 0 }, LH = { 90, 0, -10 }, LK = { -4, 0, 0 }, LA = { 20, 0, 0 } },
					follow = { Root = { 16, 0, 0, 0, -0.78, -0.18 }, Waist = { 20, 0, 0 }, RS = { 54, 0, 44 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 54, 0, -44 }, LE = { 30, 0, 0 }, RH = { 96, 0, 12 }, RK = { 0, 0, 0 }, RA = { 24, 0, 0 }, LH = { 96, 0, -12 }, LK = { 0, 0, 0 }, LA = { 24, 0, 0 } },
					trail = "rightFoot", fx = { "dust" }, hitText = "FAUCHÉ !",
				},
				-- ↑K : il balance le tonneau en l'air et le suit d'un coup de pied monté
				K_up = {
					label = "Tonneau envoyé", startup = 0.18, active = 0.14, recovery = 0.34,
					damage = 12, hitbox = box(5, 6, 1.5, 3.5), kbBase = 32, kbGrowth = 68, kbAngle = 88,
					windup = { Root = { 10, 0, 0, 0, -0.3, 0.1 }, Waist = { 14, 0, 0 }, RS = { 60, 0, 10 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 110, 0, 0 }, RH = { -20, 0, 0 }, RK = { -60, 0, 0 } },
					strike = { Root = { -16, 0, 0, 0, 0.05, -0.1 }, Waist = { -20, 0, 0 }, Neck = { -22, 0, 0 }, RS = { 170, 0, 10 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -10 }, LE = { 10, 0, 0 }, RH = { 140, 0, 0 }, RK = { -6, 0, 0 }, RA = { 20, 0, 0 } },
					follow = { Root = { -18, 0, 0, 0, 0.08, -0.12 }, Waist = { -22, 0, 0 }, Neck = { -26, 0, 0 }, RS = { 176, 0, 12 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 176, 0, -12 }, LE = { 10, 0, 0 }, RH = { 148, 0, 0 }, RK = { 0, 0, 0 }, RA = { 24, 0, 0 } },
					trail = "rightFoot", hitText = "ET HOP !",
				},
				-- K en l'air : coup de pied de la pointe, le tonneau calé sous le bras
				K_air = {
					label = "Pointe sous tonneau", startup = 0.12, active = 0.14, recovery = 0.22,
					damage = 11, hitbox = box(5.5, 3.5, 3, -0.5), kbBase = 26, kbGrowth = 52, kbAngle = 40,
					windup = { Root = { -8, 0, 0 }, Waist = { -6, 0, 0 }, RS = { 20, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 120, 0, -30 }, LE = { 40, 0, 0 }, RH = { -20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { 10, 0, 0 }, Waist = { 8, 0, 0 }, RS = { 20, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 130, 0, -40 }, LE = { 30, 0, 0 }, RH = { 95, 0, 0 }, RK = { -4, 0, 0 }, RA = { 20, 0, 0 }, LH = { 10, 0, 0 }, LK = { -60, 0, 0 } },
					follow = { Root = { 12, 0, 0 }, Waist = { 10, 0, 0 }, RS = { 20, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 134, 0, -44 }, LE = { 30, 0, 0 }, RH = { 100, 0, 0 }, RK = { 0, 0, 0 }, RA = { 24, 0, 0 }, LH = { 6, 0, 0 }, LK = { -56, 0, 0 } },
					trail = "rightFoot", hitText = "TOC !",
				},
				-- dash K : il saute sur le tonneau et le chevauche en roulant sur l'adversaire
				K_dash = {
					label = "Chevauchée de tonneau", startup = 0.12, active = 0.3, recovery = 0.34,
					damage = 13, hitbox = box(6, 4, 3, -0.5), kbBase = 32, kbGrowth = 68, kbAngle = 40, selfVelocity = Vector2.new(52, 16), armor = true,
					windup = { Root = { -8, 0, 0, 0, -0.4, 0 }, Waist = { -10, 0, 0 }, RS = { 60, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 60, 0, 0 } },
					strike = { Root = { 14, 0, 0, 0, 0.3, 0.1 }, Waist = { 10, 0, 0 }, RS = { 150, 0, 40 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -40 }, LE = { 20, 0, 0 }, RH = { 70, 0, 25 }, RK = { -80, 0, 0 }, LH = { 70, 0, -25 }, LK = { -80, 0, 0 } },
					follow = { Root = { 18, 0, 0, 0, 0.32, 0.14 }, Waist = { 12, 0, 0 }, RS = { 156, 0, 44 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 156, 0, -44 }, LE = { 20, 0, 0 }, RH = { 74, 0, 28 }, RK = { -84, 0, 0 }, LH = { 74, 0, -28 }, LK = { -84, 0, 0 } },
					trail = "body", fx = { "dust" }, hitText = "YIHAA !",
				},
				-- L : il ouvre le robinet et arrose tout le couloir d'un jet de soda à haute pression (il encaisse pendant ce temps)
				S_neutral = {
					label = "Robinet à fond", startup = 0.24, active = 0.3, recovery = 0.5,
					damage = 14, hitbox = box(14, 5, 7, 1), kbBase = 30, kbGrowth = 50, kbAngle = 28,
					status = { name = "wet", duration = 2 },
					windup = { Root = { 8, -16, 0, 0, -0.2, 0.15 }, Waist = { 8, -22, 0 }, Neck = { 6, 14, 0 }, RS = { 60, 0, 10 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 110, 0, 0 } },
					strike = { Root = { -10, 14, 0, 0, -0.3, -0.3 }, Waist = { -12, 20, 0 }, Neck = { -4, -10, 0 }, RS = { 92, 0, 4 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 88, 0, -6 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -12, 16, 0, 0, -0.32, -0.34 }, Waist = { -14, 22, 0 }, Neck = { -6, -12, 0 }, RS = { 96, 0, 6 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 92, 0, -8 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					hold = 0.15, shake = true, fx = { { "beam", color = SODA, length = 14, width = 2.2, at = "hand" }, { "particles", tex = "spark", color = SODA, dir = "front", at = "hand", time = 0.4, speed = 22, size = 0.5, rate = 90 } },
					text = "À FOND !", hitText = "ARROSÉ !",
				},
				-- →L : il lance le tonneau entier, qui roule droit sur l'adversaire
				S_side = {
					label = "Lancer de tonneau", kind = "projectile", startup = 0.26, active = 0, recovery = 0.55,
					damage = 17, kbBase = 36, kbGrowth = 66, kbAngle = 32,
					projectile = { speed = 70, angle = 0, gravity = 0, lifetime = 0.75, size = 2.6, color = WOODY, visual = "barrel" },
					windup = { Root = { 10, -34, 0, 0, -0.25, 0.3 }, Waist = { 12, -38, 0 }, Neck = { 8, 22, 0 }, RS = { 150, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 150, 0, -30 }, LE = { 60, 0, 0 } },
					strike = { Root = { -16, 22, 0, 0, -0.34, -0.45 }, Waist = { -18, 28, 0 }, Neck = { -6, -16, 0 }, RS = { 94, 0, 4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -4 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
					follow = { Root = { -18, 26, 0, 0, -0.36, -0.5 }, Waist = { -22, 32, 0 }, Neck = { -8, -18, 0 }, RS = { 98, 0, 6 }, RE = { 4, 0, 0 }, RW = { 6, 0, 0 }, LS = { 94, 0, -6 }, LE = { 4, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.52 } },
					hideProp = "tonneau", fx = { { "burst", color = WOODY, size = 2.5, at = "hand" }, "dust" }, text = "ROULE !", hitText = "TONNEAU !",
				},
				-- ↓L : il frappe le sol avec le tonneau : onde de choc qui secoue tout le couloir
				S_down = {
					label = "Onde de tonneau", startup = 0.26, active = 0.2, recovery = 0.55,
					damage = 15, hitbox = box(14, 5, 7, 0.5), kbBase = 32, kbGrowth = 55, kbAngle = 50,
					status = { name = "stunned", duration = 1 },
					windup = { Root = { -8, 0, 0, 0, -0.2, 0.1 }, Waist = { -16, 0, 0 }, Neck = { -14, 0, 0 }, RS = { 170, 0, 10 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -10 }, LE = { 30, 0, 0 } },
					strike = { Root = { 22, 0, 0, 0, -0.9, -0.2 }, Waist = { 30, 0, 0 }, Neck = { 16, 0, 0 }, RS = { 40, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -10 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.3 } },
					follow = { Root = { 24, 0, 0, 0, -0.95, -0.24 }, Waist = { 32, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 36, 0, 12 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 36, 0, -12 }, LE = { 0, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.32 } },
					hold = 0.1, fx = { "thud", { "ring", color = WOODY, radius = 7, at = "feet" }, { "beam", color = Color3.fromRGB(230, 220, 200), length = 14, width = 2.5, at = "feet" }, { "shake", amount = 0.35 } },
					text = "BADABOUM !", hitText = "SECOUÉ !",
				},
				-- ↑L : il monte sur le tonneau qui explose de pression : décollage en diagonale dans une gerbe de soda
				S_up = {
					label = "Tonneau-propulseur", startup = 0.14, active = 0.3, recovery = 0.42,
					damage = 15, hitbox = box(10, 11, 3, 4), kbBase = 34, kbGrowth = 56, kbAngle = 72, selfVelocity = Vector2.new(42, 84),
					windup = { Root = { 6, 0, 0, 0, -0.8, 0.1 }, Waist = { -10, 0, 0 }, Neck = { 26, 0, 0 }, RS = { 40, 0, 20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 110, 0, 0 }, RH = { 40, 0, 0 }, RK = { -60, 0, 0 } },
					strike = { Root = { -40, 0, 0, 0, 0.4, -0.2 }, Waist = { -6, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 170, 0, 20 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 170, 0, -20 }, LE = { 10, 0, 0 }, RH = { -25, 0, 5 }, RK = { -30, 0, 0 }, LH = { -15, 0, -5 }, LK = { -50, 0, 0 } },
					follow = { Root = { -44, 0, 0, 0, 0.45, -0.25 }, Waist = { -8, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 176, 0, 22 }, RE = { 10, 0, 0 }, RW = { -8, 0, 0 }, LS = { 176, 0, -22 }, LE = { 10, 0, 0 }, RH = { -30, 0, 6 }, RK = { -35, 0, 0 }, LH = { -20, 0, -6 }, LK = { -55, 0, 0 } },
					trail = "body", fx = { { "pillar", color = SODA, height = 12, width = 2.5, at = "feet" }, { "burst", color = SODA, size = 3, at = "feet" }, { "ring", color = SODA, radius = 5, at = "feet" } },
					text = "PROPULSÉ !", hitText = "SPLOUF !",
				},
				-- L en l'air : chute en boulet de canon, assis sur le tonneau
				S_air = {
					label = "Boulet de tonneau", startup = 0.15, active = 0.35, recovery = 0.42,
					damage = 15, hitbox = box(6, 5, 2, -1.5), kbBase = 28, kbGrowth = 58, kbAngle = -40, selfVelocity = Vector2.new(22, -75), armor = true,
					windup = { Root = { 16, 0, 0 }, Waist = { 10, 0, 0 }, RS = { 160, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -20 }, LE = { 30, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { -10, 0, 0 }, Waist = { -8, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 40, 0, 20 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -20 }, LE = { 100, 0, 0 }, RH = { 90, 0, 15 }, RK = { -90, 0, 0 }, LH = { 90, 0, -15 }, LK = { -90, 0, 0 } },
					follow = { Root = { -14, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { 24, 0, 0 }, RS = { 44, 0, 22 }, RE = { 100, 0, 0 }, RW = { 0, 0, 0 }, LS = { 44, 0, -22 }, LE = { 100, 0, 0 }, RH = { 94, 0, 16 }, RK = { -94, 0, 0 }, LH = { 94, 0, -16 }, LK = { -94, 0, 0 } },
					trail = "body", fx = { "thud", "dust" }, hitText = "BOULET !",
				},
				-- Y : le tonneau explose de pression entre ses bras, un raz-de-marée de soda sur tout le couloir
				SUPER = {
					label = "Raz-de-marée de soda !", startup = 0.4, active = 0.3, recovery = 0.7,
					damage = 24, hitbox = box(16, 7, 8, 1.5), kbBase = 46, kbGrowth = 96, kbAngle = 35, armor = true,
					status = { name = "wet", duration = 3 },
					windup = { Root = { 0, 0, 0, 0, -0.6, 0.15 }, Waist = { -20, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 60, 0, 10 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -10 }, LE = { 110, 0, 0 } },
					strike = { Root = { -16, 0, 0, 0, -0.3, -0.3 }, Waist = { -18, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 90, 0, 60 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -60 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
					follow = { Root = { -18, 0, 0, 0, -0.32, -0.34 }, Waist = { -20, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 94, 0, 66 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { 94, 0, -66 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.42 } },
					hold = 0.2, shake = true, windupFx = { "super", "sodaShake" }, fx = { { "beam", color = SODA, length = 18, width = 6, at = "feet" }, { "burst", color = SODA, size = 5, at = "front" }, { "rain", shape = "ball", color = SODA, count = 12, radius = 8, size = 0.7 }, { "shake", amount = 0.5 } },
					text = "RAZ-DE-MARÉE !", hitText = "NOYÉ !",
				},
				-- →Y : il saute sur le tonneau couché et le fait rouler à toute vitesse à travers le couloir, en équilibriste
				SUPER_side = {
					label = "Rouleau compresseur !", startup = 0.4, active = 0.45, recovery = 0.7,
					damage = 26, hitbox = box(8, 5, 3, 0), kbBase = 50, kbGrowth = 100, kbAngle = 38, selfVelocity = Vector2.new(60, 8), armor = true,
					windup = { Root = { -6, 0, 0, 0, -0.5, 0 }, Waist = { -10, 0, 0 }, RS = { 60, 0, 30 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 60, 0, 0 }, RH = { 30, 0, 0 }, RK = { -60, 0, 0 } },
					strike = { Root = { 10, 0, 0, 0, 0.5, 0.1 }, Waist = { 6, 0, 0 }, RS = { 90, 0, 80 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -80 }, LE = { 0, 0, 0 }, RH = { 20, 0, 20 }, RK = { -20, 0, 0 }, LH = { 20, 0, -20 }, LK = { -20, 0, 0 } },
					follow = { Root = { 12, 0, 0, 0, 0.52, 0.14 }, Waist = { 8, 0, 0 }, RS = { 94, 0, 84 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 94, 0, -84 }, LE = { 0, 0, 0 }, RH = { 24, 0, 24 }, RK = { -24, 0, 0 }, LH = { 24, 0, -24 }, LK = { -24, 0, 0 } },
					wobble = true, windupFx = { "super", { "symbols", symbols = { "🛢️" }, count = 5, radius = 3, color = WOODY } }, fx = { { "toss", shape = "cyl", color = WOODY, size = 1.6, count = 1, speed = 30 }, { "particles", tex = "smoke", color = Color3.fromRGB(230, 230, 230), dir = "front", at = "feet", time = 0.5, speed = 14 }, { "shake", amount = 0.4 }, "dust" },
					text = "ROULEAU COMPRESSEUR !", hitText = "APLATI !",
				},
				-- ↑Y : le geyser du tonneau : il saute dessus, le bouchon saute et un geyser le propulse au plafond en emportant tout
				SUPER_up = {
					label = "Geyser de tonneau !", startup = 0.35, active = 0.3, recovery = 0.7,
					damage = 25, hitbox = box(16, 12, 8, 5), kbBase = 46, kbGrowth = 96, kbAngle = 86, invuln = 0.3, selfVelocity = Vector2.new(0, 58),
					windup = { Root = { -10, 0, 0, 0, -0.95, 0 }, Waist = { -32, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 40, 0, -20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, 20 }, LE = { 110, 0, 0 } },
					strike = { Root = { 6, 0, 0, 0, 0.5, 0 }, Waist = { 18, 0, 0 }, Neck = { 50, 0, 0 }, RS = { 186, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 186, 0, -6 }, LE = { 0, 0, 0 }, RH = { 40, 0, 10 }, RK = { -90, 0, 0 }, LH = { 20, 0, -15 }, LK = { -60, 0, 0 } },
					follow = { Root = { 10, 0, 0, 0, 0.55, 0 }, Waist = { 24, 0, 0 }, Neck = { 56, 0, 0 }, RS = { 188, 0, 10 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 188, 0, -10 }, LE = { 0, 0, 0 }, RH = { 60, 0, 20 }, RK = { -110, 0, 0 }, LH = { 10, 0, -25 }, LK = { -40, 0, 0 } },
					hold = 0.2, shake = true, spin = { axis = "y", degrees = 360 },
					windupFx = { "super", "sodaShake" }, fx = { { "pillar", color = SODA, height = 24, width = 3.5, at = "front" }, { "beam", color = SODA, length = 16, width = 5, at = "feet" }, { "burst", color = Color3.fromRGB(255, 240, 150), size = 4, at = "above" }, { "ring", color = SODA, radius = 6, at = "feet" }, "thud" },
					text = "GEYSER !", hitText = "AU PLAFOND !",
				},
				-- ↓Y : il saute à pieds joints sur le tonneau qui s'écrase : la pression fait sauter le sol et tout le couloir avec
				SUPER_down = {
					label = "Écrasement de tonneau !", startup = 0.4, active = 0.3, recovery = 0.75,
					damage = 24, hitbox = box(16, 5, 8, 0), kbBase = 46, kbGrowth = 94, kbAngle = 62, armor = true,
					status = { name = "stunned", duration = 1.5 },
					windup = { Root = { -10, 0, 0, 0, 0.3, 0 }, Waist = { -14, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 160, 0, 20 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 160, 0, -20 }, LE = { 30, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
					strike = { Root = { 24, 0, 0, 0, -0.95, -0.2 }, Waist = { 32, 0, 0 }, Neck = { 18, 0, 0 }, RS = { 30, 0, 50 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -50 }, LE = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0.2 }, FL = { 0, 0, 0, 0, 0, -0.2 } },
					follow = { Root = { 26, 0, 0, 0, -1.0, -0.24 }, Waist = { 34, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 26, 0, 54 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 26, 0, -54 }, LE = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0.22 }, FL = { 0, 0, 0, 0, 0, -0.22 } },
					hold = 0.2, windupFx = { "super" }, fx = { "thud", { "ring", color = WOODY, radius = 8, at = "feet" }, { "beam", color = Color3.fromRGB(230, 220, 200), length = 16, width = 3, at = "feet" }, { "toss", shape = "flat", color = WOODY, size = 1, count = 6, speed = 24 }, { "shake", amount = 0.6 } },
					text = "ÉCRASEMENT !", hitText = "APLATI !",
				},
			},
			links = {
				P_neutral = { P = "P_side", K = "K_neutral", S = "S_neutral" },
				P_side = { P = "P_up", K = "K_side", S = "S_side" },
				P_down = { P = "P_up", K = "K_down", S = "S_down" },
				K_neutral = { K = "K_side", P = "P_neutral", S = "S_down" },
				K_side = { P = "P_up", K = "K_up", S = "S_side" },
				P_dash = { P = "P_side", K = "K_side", S = "S_side" },
				K_dash = { P = "P_up", S = "S_up" },
			},
		},
	},

	moves = {
		------------------------------------------------------------------ Attaques légères (P)
		-- Coup de goulot : petit coup sec de bouteille sur le crâne, le bassin tourne et pousse le bras
		P_neutral = {
			label = "Coup de goulot", startup = 0.08, active = 0.08, recovery = 0.14,
			damage = 6, hitbox = box(4, 3, 2.5, 0.5), kbBase = 20, kbGrowth = 25, kbAngle = 25,
			windup = { Root = { 4, -14, 0, 0, -0.1, 0.18 }, Waist = { 4, -24, 0 }, RS = { 70, 0, 28 }, RE = { 105, 0, 0 }, RW = { 10, 0, 0 }, LS = { 40, 0, -15 }, LE = { 85, 0, 0 } },
			strike = { Root = { -8, 16, 0, 0, -0.25, -0.3 }, Waist = { -10, 26, 0 }, RS = { 100, 0, 6 }, RE = { 12, 0, 0 }, RW = { -15, 0, 0 }, LS = { -8, 0, -20 }, LE = { 100, 0, 0 } },
			follow = { Root = { -10, 22, 0, 0, -0.28, -0.4 }, Waist = { -14, 32, 0 }, RS = { 82, 0, 0 }, RE = { 18, 0, 0 }, RW = { -40, 0, 0 }, LS = { -14, 0, -20 }, LE = { 105, 0, 0 } },
			trail = "bottle", hitText = "BONK !",
		},
		-- Revers de bouteille : grand balayage de la bouteille d'arrière en avant, en fonçant
		P_side = {
			label = "Revers de bouteille", startup = 0.12, active = 0.1, recovery = 0.18,
			damage = 8, hitbox = box(5, 3, 3, 0.5), kbBase = 22, kbGrowth = 35, kbAngle = 20, selfVelocity = Vector2.new(25, 0),
			windup = { Root = { 6, -28, 0, 0, -0.3, 0.3 }, Waist = { 8, -38, 0 }, RS = { -60, 0, 42 }, RE = { 30, 0, 0 }, RW = { 0, 0, 0 }, LS = { 65, 0, -25 }, LE = { 55, 0, 0 } },
			strike = { Root = { -10, 22, 0, 0, -0.4, -0.4 }, Waist = { -15, 36, 0 }, RS = { 100, 0, 18 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { -35, 0, -35 }, LE = { 40, 0, 0 } },
			follow = { Root = { -12, 34, 0, 0, -0.4, -0.5 }, Waist = { -16, 52, 0 }, RS = { 95, 0, -28 }, RE = { 22, 0, 0 }, RW = { -15, 0, 0 }, LS = { -45, 0, -40 }, LE = { 30, 0, 0 } },
			trail = "bottle", hitText = "PAF !",
		},
		-- Croche-patte : accroupi sur la jambe gauche, la jambe droite balaie le sol
		P_down = {
			label = "Croche-patte", startup = 0.1, active = 0.08, recovery = 0.18,
			damage = 6, hitbox = box(5, 2, 2.5, -2), kbBase = 25, kbGrowth = 20, kbAngle = 75,
			windup = { Root = { -8, -18, 0, 0, -0.75, 0.2 }, Waist = { -16, -10, 0 }, RS = { 30, 0, 38 }, RE = { 45, 0, 0 }, LS = { 50, 0, -30 }, LE = { 55, 0, 0 }, RH = { -15, 0, 18 }, RK = { -60, 0, 0 }, RA = { 0, 0, 0 } },
			strike = { Root = { -12, 22, 0, 0, -0.9, -0.1 }, Waist = { -22, 16, 0 }, RS = { 10, 0, 48 }, RE = { 30, 0, 0 }, LS = { 75, 0, -30 }, LE = { 40, 0, 0 }, RH = { 62, 0, 10 }, RK = { -6, 0, 0 }, RA = { -20, 0, 0 } },
			follow = { Root = { -12, 32, 0, 0, -0.9, -0.15 }, Waist = { -22, 26, 0 }, RS = { 5, 0, 50 }, RE = { 30, 0, 0 }, LS = { 80, 0, -28 }, LE = { 40, 0, 0 }, RH = { 58, 0, -12 }, RK = { -8, 0, 0 }, RA = { -20, 0, 0 } },
			trail = "rightFoot", hitText = "OUPS !",
		},
		-- Hoquet repoussant : Gégé se recroqueville puis un hoquet le soulève, bras en l'air
		P_up = {
			label = "Hoquet repoussant", startup = 0.1, active = 0.12, recovery = 0.2,
			damage = 7, hitbox = box(5, 5, 1, 3.5), kbBase = 28, kbGrowth = 30, kbAngle = 85,
			windup = { Root = { -10, 0, 0, 0, -0.75, 0 }, Waist = { -22, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 20, 0, 22 }, RE = { 85, 0, 0 }, LS = { 25, 0, -22 }, LE = { 85, 0, 0 } },
			strike = { Root = { 6, 0, 0, 0, 0.4, 0 }, Waist = { 18, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 165, 0, 25 }, RE = { 10, 0, 0 }, LS = { 160, 0, -30 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0 }, FL = { 0, 0, 0, 0, 0.3, 0 } },
			follow = { Root = { 8, 0, 0, 0, 0.5, 0 }, Waist = { 22, 0, 0 }, Neck = { 36, 0, 0 }, RS = { 175, 0, 32 }, RE = { 15, 0, 0 }, LS = { 172, 0, -36 }, LE = { 15, 0, 0 }, FR = { 0, 0, 0, 0, 0.4, 0 }, FL = { 0, 0, 0, 0, 0.35, 0 } },
			fx = { "hiccup" }, text = "HIC !", hitText = "HIC !",
		},
		-- Bouteille plongeante : en l'air, bouteille levée au-dessus de la tête puis abattue vers le bas
		P_air = {
			label = "Bouteille plongeante", startup = 0.1, active = 0.12, recovery = 0.16,
			damage = 8, hitbox = box(4, 4, 1.5, -1.5), kbBase = 20, kbGrowth = 35, kbAngle = -40,
			windup = { Root = { 10, 0, 0 }, Waist = { 16, 0, 0 }, RS = { 185, 0, 12 }, RE = { 55, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -40 }, LE = { 40, 0, 0 }, RH = { 40, 0, 0 }, RK = { -80, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { -12, 0, 0 }, Waist = { -30, 0, 0 }, RS = { 55, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -25, 0, -45 }, LE = { 20, 0, 0 }, RH = { 15, 0, 0 }, RK = { -35, 0, 0 }, LH = { 35, 0, 0 }, LK = { -70, 0, 0 } },
			follow = { Root = { -18, 0, 0 }, Waist = { -36, 0, 0 }, RS = { 25, 0, 5 }, RE = { 8, 0, 0 }, RW = { -20, 0, 0 }, LS = { -35, 0, -50 }, LE = { 20, 0, 0 }, RH = { 5, 0, 0 }, RK = { -30, 0, 0 }, LH = { 30, 0, 0 }, LK = { -65, 0, 0 } },
			trail = "bottle", hitText = "BLAM !",
		},

		-- Suites d'enchaînement (voir links) : J J, J J J…
		P_combo2 = {
			label = "Revers du goulot", startup = 0.07, active = 0.08, recovery = 0.16,
			damage = 5, hitbox = box(5, 3.5, 2.5, 0.6), kbBase = 18, kbGrowth = 22, kbAngle = 30,
			windup = { Root = { -6, 24, 0, 0, -0.25, -0.3 }, Waist = { -8, 34, 0 }, RS = { 70, 0, -35 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { -5, 0, -20 }, LE = { 100, 0, 0 } },
			strike = { Root = { -8, -14, 0, 0, -0.28, -0.35 }, Waist = { -10, -24, 0 }, RS = { 95, 0, 32 }, RE = { 8, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -25 }, LE = { 95, 0, 0 } },
			follow = { Root = { -8, -22, 0, 0, -0.28, -0.38 }, Waist = { -10, -34, 0 }, RS = { 85, 0, 50 }, RE = { 15, 0, 0 }, RW = { -15, 0, 0 }, LS = { 35, 0, -25 }, LE = { 95, 0, 0 } },
			trail = "bottle", hitText = "PIF !",
		},
		P_combo3 = {
			label = "Coup de bouteille final", startup = 0.1, active = 0.1, recovery = 0.3,
			damage = 9, hitbox = box(5, 4, 2.5, 1), kbBase = 30, kbGrowth = 60, kbAngle = 50,
			windup = { Root = { 8, -10, 0, 0, -0.05, 0.25 }, Waist = { 14, -12, 0 }, RS = { 195, 0, 15 }, RE = { 70, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -30 }, LE = { 30, 0, 0 } },
			strike = { Root = { -14, 10, 0, 0, -0.5, -0.4 }, Waist = { -30, 12, 0 }, RS = { 70, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -35 }, LE = { 60, 0, 0 } },
			follow = { Root = { -18, 12, 0, 0, -0.6, -0.45 }, Waist = { -36, 14, 0 }, RS = { 40, 0, 5 }, RE = { 5, 0, 0 }, RW = { -25, 0, 0 }, LS = { -30, 0, -40 }, LE = { 60, 0, 0 } },
			trail = "bottle", text = "ET DE TROIS !", hitText = "BADABOUM !",
		},
		-- Coup d'épaule de comptoir (dash puis P) : il fonce épaule en avant, la bouteille traîne derrière
		P_dash = {
			label = "Coup d'épaule de comptoir", startup = 0.08, active = 0.15, recovery = 0.25,
			damage = 9, hitbox = box(4, 4, 2, 0.5), kbBase = 30, kbGrowth = 55, kbAngle = 25, selfVelocity = Vector2.new(45, 0),
			windup = { Root = { -10, -20, 0, 0, -0.3, 0.1 }, Waist = { -6, -10, 0 }, RS = { -20, 0, 30 }, RE = { 50, 0, 0 }, LS = { 30, 0, -10 }, LE = { 110, 0, 0 } },
			strike = { Root = { -22, -45, 0, 0, -0.4, -0.25 }, Waist = { -10, -15, 0 }, RS = { -35, 0, 35 }, RE = { 40, 0, 0 }, LS = { 20, 0, -8 }, LE = { 115, 0, 0 } },
			follow = { Root = { -24, -50, 0, 0, -0.42, -0.3 }, Waist = { -12, -18, 0 }, RS = { -45, 0, 40 }, RE = { 35, 0, 0 }, LS = { 15, 0, -8 }, LE = { 118, 0, 0 } },
			fx = { "dust" }, hitText = "TCHAC !",
		},

		------------------------------------------------------------------ Attaques lourdes (K)
		-- Savate molle : genou monté, coup de pied de face qui détend la jambe, la savate s'envole
		K_neutral = {
			label = "Savate molle", startup = 0.2, active = 0.1, recovery = 0.3,
			damage = 11, hitbox = box(5, 3, 3, 0), kbBase = 30, kbGrowth = 70, kbAngle = 35,
			windup = { Root = { 8, -12, 0, 0, -0.15, 0.15 }, Waist = { 6, -10, 0 }, RS = { 35, 0, 40 }, RE = { 55, 0, 0 }, LS = { 45, 0, -40 }, LE = { 55, 0, 0 }, RH = { 88, 0, 0 }, RK = { -115, 0, 0 }, RA = { -20, 0, 0 } },
			strike = { Root = { 14, -5, 0, 0, -0.1, 0.05 }, Waist = { 16, 0, 0 }, RS = { 55, 0, 58 }, RE = { 30, 0, 0 }, LS = { 62, 0, -58 }, LE = { 30, 0, 0 }, RH = { 100, 0, 0 }, RK = { -6, 0, 0 }, RA = { 10, 0, 0 } },
			follow = { Root = { 18, -2, 0, 0, -0.1, 0.1 }, Waist = { 20, 0, 0 }, RS = { 60, 0, 65 }, RE = { 25, 0, 0 }, LS = { 68, 0, -65 }, LE = { 25, 0, 0 }, RH = { 108, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 } },
			trail = "rightFoot", fx = { "slipper" }, hitText = "FLAP !",
		},
		-- Genou bancal : il attrape la tête de l'adversaire et la tire vers son genou qui monte
		K_side = {
			label = "Genou bancal", startup = 0.25, active = 0.12, recovery = 0.35,
			damage = 13, hitbox = box(5, 3, 3, 0.5), kbBase = 32, kbGrowth = 85, kbAngle = 30, selfVelocity = Vector2.new(35, 0),
			windup = { Root = { 6, -10, 0, 0, -0.2, 0.2 }, Waist = { 8, -10, 0 }, RS = { 115, 0, 25 }, RE = { 35, 0, 0 }, LS = { 115, 0, -25 }, LE = { 35, 0, 0 }, RH = { -25, 0, 0 }, RK = { -55, 0, 0 } },
			strike = { Root = { -12, 10, 0, 0, 0.05, -0.3 }, Waist = { -18, 10, 0 }, RS = { 55, 0, 15 }, RE = { 95, 0, 0 }, LS = { 55, 0, -15 }, LE = { 95, 0, 0 }, RH = { 110, 0, 0 }, RK = { -120, 0, 0 }, RA = { -30, 0, 0 } },
			follow = { Root = { -16, 12, 0, 0, 0.1, -0.38 }, Waist = { -22, 12, 0 }, RS = { 45, 0, 12 }, RE = { 105, 0, 0 }, LS = { 45, 0, -12 }, LE = { 105, 0, 0 }, RH = { 118, 0, 0 }, RK = { -128, 0, 0 }, RA = { -30, 0, 0 } },
			trail = "rightLeg", hitText = "GNAC !",
		},
		-- Glissade sur flaque : il glisse sur le dos, les deux pieds en avant
		K_down = {
			label = "Glissade sur flaque", startup = 0.18, active = 0.25, recovery = 0.35,
			damage = 12, hitbox = box(7, 2, 3, -2), kbBase = 30, kbGrowth = 60, kbAngle = 60, selfVelocity = Vector2.new(45, 0),
			windup = { Root = { -10, 0, 0, 0, -0.65, 0 }, Waist = { -20, 0, 0 }, RS = { 60, 0, 40 }, RE = { 30, 0, 0 }, LS = { 60, 0, -40 }, LE = { 30, 0, 0 }, RH = { 50, 0, 0 }, RK = { -95, 0, 0 }, LH = { 50, 0, 0 }, LK = { -95, 0, 0 } },
			strike = { Root = { 45, 0, 0, 0, -1.6, 0 }, Waist = { -25, 0, 0 }, Neck = { -25, 0, 0 }, RS = { 150, 0, 50 }, RE = { 10, 0, 0 }, LS = { 150, 0, -50 }, LE = { 10, 0, 0 }, RH = { 85, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 70, 0, 0 }, LK = { -20, 0, 0 } },
			follow = { Root = { 52, 0, 4, 0, -1.65, 0 }, Waist = { -28, 0, 0 }, Neck = { -28, 0, 0 }, RS = { 165, 0, 60 }, RE = { 20, 0, 0 }, LS = { 140, 0, -65 }, LE = { 25, 0, 0 }, RH = { 90, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 78, 0, 0 }, LK = { -15, 0, 0 } },
			trail = "rightFoot", fx = { "puddle" }, hitText = "SPLOTCH !",
		},
		-- Coup de tête titubant : accroupi, puis il se détend vers le haut en donnant un coup de tête
		K_up = {
			label = "Coup de tête titubant", startup = 0.2, active = 0.12, recovery = 0.3,
			damage = 12, hitbox = box(5, 5, 1, 4), kbBase = 32, kbGrowth = 75, kbAngle = 88,
			windup = { Root = { -6, 0, 0, 0, -0.95, 0 }, Waist = { -35, 0, 0 }, Neck = { -30, 0, 0 }, RS = { -30, 0, 22 }, RE = { 40, 0, 0 }, LS = { -30, 0, -22 }, LE = { 40, 0, 0 } },
			strike = { Root = { 2, 0, 0, 0, 0.45, 0 }, Waist = { 12, 0, 0 }, Neck = { 48, 0, 0 }, RS = { -55, 0, 30 }, RE = { 10, 0, 0 }, LS = { -55, 0, -30 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0 }, FL = { 0, 0, 0, 0, 0.3, 0 } },
			follow = { Root = { 4, 0, 0, 0, 0.55, 0 }, Waist = { 16, 0, 0 }, Neck = { 55, 0, 0 }, RS = { -62, 0, 35 }, RE = { 10, 0, 0 }, LS = { -62, 0, -35 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.45, 0 }, FL = { 0, 0, 0, 0, 0.4, 0 } },
			fx = { "headStar" }, hitText = "BONK !",
		},
		-- Ruade titubante : en l'air, genoux à la poitrine puis les deux pieds partent devant
		K_air = {
			label = "Ruade titubante", startup = 0.18, active = 0.14, recovery = 0.25,
			damage = 12, hitbox = box(5, 4, 2.5, 0), kbBase = 30, kbGrowth = 70, kbAngle = 40,
			windup = { Root = { -10, 0, 0 }, Waist = { -22, 0, 0 }, RS = { 60, 0, 40 }, RE = { 60, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 }, RH = { 95, 0, 0 }, RK = { -130, 0, 0 }, LH = { 90, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 20, 0, 0 }, Waist = { 22, 0, 0 }, RS = { -35, 0, 50 }, RE = { 20, 0, 0 }, LS = { -35, 0, -50 }, LE = { 20, 0, 0 }, RH = { 90, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 78, 0, 0 }, LK = { -6, 0, 0 }, LA = { 15, 0, 0 } },
			follow = { Root = { 26, 0, 0 }, Waist = { 25, 0, 0 }, RS = { -45, 0, 55 }, RE = { 20, 0, 0 }, LS = { -45, 0, -55 }, LE = { 20, 0, 0 }, RH = { 96, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 84, 0, 0 }, LK = { -4, 0, 0 }, LA = { 15, 0, 0 } },
			trail = "bothFeet", hitText = "POW !",
		},

		-- Suites d'enchaînement : K K, K K K…
		K_combo2 = {
			label = "Talon pivotant", startup = 0.1, active = 0.1, recovery = 0.25,
			damage = 9, hitbox = box(5, 3.5, 3, 0.5), kbBase = 28, kbGrowth = 50, kbAngle = 30,
			windup = { Root = { 4, -40, 0, 0, -0.15, 0.1 }, Waist = { 4, -30, 0 }, RS = { 40, 0, 55 }, RE = { 40, 0, 0 }, LS = { 60, 0, -50 }, LE = { 50, 0, 0 }, RH = { 55, 0, 40 }, RK = { -105, 0, 0 } },
			strike = { Root = { 12, 50, 0, 0, -0.1, 0 }, Waist = { 10, 30, 0 }, RS = { 30, 0, 70 }, RE = { 30, 0, 0 }, LS = { 70, 0, -60 }, LE = { 40, 0, 0 }, RH = { 85, 0, 55 }, RK = { -5, 0, 0 }, RA = { 10, 0, 0 } },
			follow = { Root = { 14, 70, 0, 0, -0.1, 0 }, Waist = { 12, 38, 0 }, RS = { 25, 0, 75 }, RE = { 30, 0, 0 }, LS = { 72, 0, -62 }, LE = { 40, 0, 0 }, RH = { 80, 0, 40 }, RK = { -8, 0, 0 }, RA = { 10, 0, 0 } },
			trail = "rightFoot", hitText = "VLAN !",
		},
		K_combo3 = {
			label = "Coup de pied sauté", startup = 0.1, active = 0.12, recovery = 0.3,
			damage = 12, hitbox = box(5, 4, 3, 1), kbBase = 32, kbGrowth = 80, kbAngle = 40, selfVelocity = Vector2.new(15, 45),
			windup = { Root = { -8, 0, 0, 0, -0.65, 0.1 }, Waist = { -15, 0, 0 }, RS = { -40, 0, 30 }, RE = { 30, 0, 0 }, LS = { -40, 0, -30 }, LE = { 30, 0, 0 } },
			strike = { Root = { 15, 0, 0 }, Waist = { 12, 0, 0 }, RS = { 60, 0, 60 }, RE = { 20, 0, 0 }, LS = { 70, 0, -60 }, LE = { 20, 0, 0 }, RH = { 95, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 }, LH = { 30, 0, 0 }, LK = { -110, 0, 0 } },
			follow = { Root = { 20, 0, 0 }, Waist = { 16, 0, 0 }, RS = { 55, 0, 70 }, RE = { 20, 0, 0 }, LS = { 65, 0, -70 }, LE = { 20, 0, 0 }, RH = { 105, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 35, 0, 0 }, LK = { -115, 0, 0 } },
			trail = "rightFoot", text = "HIIIYA !", hitText = "BAM !",
		},
		-- Tacle volant (dash puis K) : il décolle, jambe droite tendue, jambe gauche repliée
		K_dash = {
			label = "Tacle volant", startup = 0.1, active = 0.25, recovery = 0.3,
			damage = 11, hitbox = box(6, 3, 3, -0.5), kbBase = 30, kbGrowth = 65, kbAngle = 35, selfVelocity = Vector2.new(55, 30),
			windup = { Root = { -10, 0, 0, 0, -0.45, 0 }, Waist = { -12, 0, 0 }, RS = { 40, 0, 40 }, LS = { 50, 0, -40 } },
			strike = { Root = { 12, 0, 0 }, Waist = { 6, 0, 0 }, RS = { -30, 0, 50 }, RE = { 20, 0, 0 }, LS = { 70, 0, -40 }, LE = { 30, 0, 0 }, RH = { 80, 0, 0 }, RK = { 0, 0, 0 }, RA = { 10, 0, 0 }, LH = { -20, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { 16, 0, 0 }, Waist = { 8, 0, 0 }, RS = { -40, 0, 55 }, RE = { 20, 0, 0 }, LS = { 75, 0, -45 }, LE = { 30, 0, 0 }, RH = { 85, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { -25, 0, 0 }, LK = { -105, 0, 0 } },
			trail = "rightFoot", hitText = "SBAM !",
		},

		------------------------------------------------------------------ En l'air avec une flèche (J / K)
		-- → J en l'air : Revers volant, la bouteille part du côté gauche et balaie vers l'avant, jambes en ciseau
		P_air_side = {
			label = "Revers volant", startup = 0.1, active = 0.1, recovery = 0.18,
			damage = 8, hitbox = box(5, 3, 3, 0.5), kbBase = 22, kbGrowth = 40, kbAngle = 30,
			windup = { Root = { -6, 30, 0 }, Waist = { -8, 38, 0 }, Neck = { 0, -20, 0 }, RS = { 70, 0, -45 }, RE = { 95, 0, 0 }, RW = { 0, 0, 0 }, LS = { 30, 0, -50 }, LE = { 50, 0, 0 }, RH = { 70, 0, 0 }, RK = { -100, 0, 0 }, LH = { 30, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { 6, -4, 0 }, Waist = { -6, -10, 0 }, Neck = { 0, 10, 0 }, RS = { 95, 0, 20 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -60 }, LE = { 30, 0, 0 }, RH = { -20, 0, 0 }, RK = { -40, 0, 0 }, LH = { 60, 0, 0 }, LK = { -50, 0, 0 } },
			follow = { Root = { 8, -12, 0 }, Waist = { -6, -20, 0 }, Neck = { 0, 18, 0 }, RS = { 92, 0, 45 }, RE = { 12, 0, 0 }, RW = { -15, 0, 0 }, LS = { 45, 0, -65 }, LE = { 30, 0, 0 }, RH = { -25, 0, 0 }, RK = { -45, 0, 0 }, LH = { 65, 0, 0 }, LK = { -45, 0, 0 } },
			trail = "bottle", hitText = "SCHLAK !",
		},
		-- ↑ J en l'air : Goulot au plafond, recroquevillé puis la bouteille balaie l'air au-dessus de sa tête
		P_air_up = {
			label = "Goulot au plafond", startup = 0.09, active = 0.12, recovery = 0.18,
			damage = 7, hitbox = box(5, 4, 0.5, 3.5), kbBase = 26, kbGrowth = 45, kbAngle = 85,
			windup = { Root = { -14, 0, 0 }, Waist = { -20, 0, 0 }, Neck = { -10, 0, 0 }, RS = { -40, 0, 30 }, RE = { 50, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 70, 0, 0 }, RH = { 90, 0, 0 }, RK = { -120, 0, 0 }, LH = { 80, 0, 0 }, LK = { -120, 0, 0 } },
			strike = { Root = { 14, 0, 0 }, Waist = { 16, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 160, 0, 15 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -45 }, LE = { 20, 0, 0 }, RH = { -10, 0, 0 }, RK = { -30, 0, 0 }, LH = { 20, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { 20, 0, 0 }, Waist = { 22, 0, 0 }, Neck = { 38, 0, 0 }, RS = { 200, 0, 5 }, RE = { 10, 0, 0 }, RW = { -20, 0, 0 }, LS = { -30, 0, -50 }, LE = { 20, 0, 0 }, RH = { -15, 0, 0 }, RK = { -25, 0, 0 }, LH = { 15, 0, 0 }, LK = { -55, 0, 0 } },
			trail = "bottle", hitText = "TCHING !",
		},
		-- ↓ J en l'air : Météore de bouteille, bouteille levée à deux mains puis abattue droit vers le bas (smash vers le sol)
		P_air_down = {
			label = "Météore de bouteille", startup = 0.16, active = 0.1, recovery = 0.3,
			damage = 10, hitbox = box(4, 4, 1, -2), kbBase = 25, kbGrowth = 55, kbAngle = -80,
			windup = { Root = { 18, 0, 0 }, Waist = { 20, 0, 0 }, Neck = { 15, 0, 0 }, RS = { 195, 0, -8 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 195, 0, 8 }, LE = { 40, 0, 0 }, RH = { 70, 0, 0 }, RK = { -110, 0, 0 }, LH = { 75, 0, 0 }, LK = { -110, 0, 0 } },
			strike = { Root = { -20, 0, 0 }, Waist = { -30, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 70, 0, -8 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, 8 }, LE = { 0, 0, 0 }, RH = { 10, 0, 0 }, RK = { -80, 0, 0 }, LH = { 20, 0, 0 }, LK = { -90, 0, 0 } },
			follow = { Root = { -26, 0, 0 }, Waist = { -34, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 45, 0, -8 }, RE = { 0, 0, 0 }, RW = { -15, 0, 0 }, LS = { 45, 0, 8 }, LE = { 5, 0, 0 }, RH = { 5, 0, 0 }, RK = { -85, 0, 0 }, LH = { 15, 0, 0 }, LK = { -95, 0, 0 } },
			trail = "bottle", text = "MÉTÉORE !", hitText = "KLONK !",
		},
		-- → K en l'air : Savate volante, genou replié puis jambe droite détendue à l'horizontale, buste en arrière
		K_air_side = {
			label = "Savate volante", startup = 0.15, active = 0.12, recovery = 0.25,
			damage = 11, hitbox = box(5, 3, 3.2, 0), kbBase = 30, kbGrowth = 70, kbAngle = 35,
			windup = { Root = { -14, 20, 0 }, Waist = { -16, 10, 0 }, RS = { 50, 0, 45 }, RE = { 70, 0, 0 }, LS = { 70, 0, -30 }, LE = { 80, 0, 0 }, RH = { 105, 0, 0 }, RK = { -135, 0, 0 }, RA = { 10, 0, 0 }, LH = { 40, 0, 0 }, LK = { -100, 0, 0 } },
			strike = { Root = { 28, 25, 0 }, Waist = { 10, 5, 0 }, Neck = { -15, 0, 0 }, RS = { -30, 0, 60 }, RE = { 20, 0, 0 }, LS = { 40, 0, -70 }, LE = { 30, 0, 0 }, RH = { 65, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 20, 0, 0 }, LK = { -110, 0, 0 } },
			follow = { Root = { 32, 28, 0 }, Waist = { 12, 5, 0 }, Neck = { -18, 0, 0 }, RS = { -38, 0, 65 }, RE = { 20, 0, 0 }, LS = { 45, 0, -75 }, LE = { 30, 0, 0 }, RH = { 68, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { 15, 0, 0 }, LK = { -105, 0, 0 } },
			trail = "rightFoot", hitText = "SBLAF !",
		},
		-- ↑ K en l'air : Retourné du pochtron, ciseau retourné : salto arrière, les pieds passent au-dessus de la tête
		K_air_up = {
			label = "Retourné du pochtron", startup = 0.14, active = 0.2, recovery = 0.25,
			damage = 10, hitbox = box(4, 5, 0.5, 3.5), kbBase = 30, kbGrowth = 65, kbAngle = 85,
			windup = { Root = { -10, 0, 0 }, Waist = { -20, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 40, 0, 50 }, RE = { 40, 0, 0 }, LS = { 40, 0, -50 }, LE = { 40, 0, 0 }, RH = { 60, 0, 0 }, RK = { -120, 0, 0 }, LH = { 100, 0, 0 }, LK = { -130, 0, 0 } },
			strike = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -40, 0, 60 }, RE = { 20, 0, 0 }, LS = { -40, 0, -60 }, LE = { 20, 0, 0 }, RH = { 150, 0, 0 }, RK = { -5, 0, 0 }, RA = { 20, 0, 0 }, LH = { 40, 0, 0 }, LK = { -100, 0, 0 } },
			follow = { Root = { 30, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { -45, 0, 65 }, RE = { 20, 0, 0 }, LS = { -45, 0, -65 }, LE = { 20, 0, 0 }, RH = { 100, 0, 0 }, RK = { -50, 0, 0 }, LH = { 150, 0, 0 }, LK = { -5, 0, 0 }, LA = { 20, 0, 0 } },
			spin = { axis = "x", degrees = -360 }, trail = "rightFoot", text = "RETOURNÉ !", hitText = "POC !",
		},
		-- ↓ K en l'air : Écrase-canette, genoux à la poitrine puis les deux pieds tombent comme sur une canette (smash vers le sol)
		K_air_down = {
			label = "Écrase-canette", startup = 0.18, active = 0.15, recovery = 0.3,
			damage = 12, hitbox = box(4, 3, 0.5, -3), kbBase = 25, kbGrowth = 55, kbAngle = -80, selfVelocity = Vector2.new(0, -60),
			windup = { Root = { -6, 0, 0 }, Waist = { -18, 0, 0 }, Neck = { -10, 0, 0 }, RS = { 120, 0, 45 }, RE = { 30, 0, 0 }, LS = { 120, 0, -45 }, LE = { 30, 0, 0 }, RH = { 105, 0, 0 }, RK = { -135, 0, 0 }, LH = { 105, 0, 0 }, LK = { -135, 0, 0 } },
			strike = { Root = { 4, 0, 0 }, Waist = { 8, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 160, 0, 40 }, RE = { 10, 0, 0 }, LS = { 160, 0, -40 }, LE = { 10, 0, 0 }, RH = { -4, 0, 4 }, RK = { 0, 0, 0 }, RA = { -10, 0, 0 }, LH = { -4, 0, -4 }, LK = { 0, 0, 0 }, LA = { -10, 0, 0 } },
			follow = { Root = { 4, 0, 0 }, Waist = { 10, 0, 0 }, Neck = { -25, 0, 0 }, RS = { 170, 0, 50 }, RE = { 10, 0, 0 }, LS = { 170, 0, -50 }, LE = { 10, 0, 0 }, RH = { -4, 0, 6 }, RK = { -5, 0, 0 }, RA = { -10, 0, 0 }, LH = { -4, 0, -6 }, LK = { -5, 0, 0 }, LA = { -10, 0, 0 } },
			trail = "bothFeet", text = "ÉCRASE-CANETTE !", hitText = "CRONCH !",
		},

		------------------------------------------------------------------ Spéciaux (S)
		-- Jet de soda douteux : il secoue la bouteille à deux mains et la giclée pétillante fonce droit dans la figure de l'adversaire (il voit tout à l'envers)
		S_neutral = {
			label = "Jet de soda douteux", kind = "projectile", startup = 0.18, active = 0, recovery = 0.4,
			damage = 12, kbBase = 28, kbGrowth = 45, kbAngle = 25,
			projectile = { speed = 80, angle = 0, gravity = 0, lifetime = 0.6, size = 2, color = SODA, visual = "soda" },
			status = { name = "inverted", duration = 3 },
			windup = { Root = { 4, -14, 0, 0, -0.2, 0.15 }, Waist = { 4, -20, 0 }, Neck = { 6, 12, 0 }, RS = { 70, 0, -10 }, RE = { 100, 0, 0 }, RW = { 20, 0, 0 }, LS = { 70, 0, 10 }, LE = { 100, 0, 0 } },
			strike = { Root = { -10, 12, 0, 0, -0.3, -0.3 }, Waist = { -14, 16, 0 }, Neck = { -4, -10, 0 }, RS = { 96, 0, -4 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 92, 0, 6 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
			follow = { Root = { -12, 14, 0, 0, -0.32, -0.35 }, Waist = { -16, 18, 0 }, Neck = { -6, -12, 0 }, RS = { 100, 0, -6 }, RE = { 4, 0, 0 }, RW = { 6, 0, 0 }, LS = { 95, 0, 8 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
			shake = true, windupFx = { "sodaShake" }, fx = { { "beam", color = SODA, length = 10, width = 1.8, at = "hand" } }, text = "PSCHHH !", hitText = "SPLASH ! TOUT À L'ENVERS !",
		},
		-- Bouteille-fusée : il la secoue, la cale sur l'épaule comme un bazooka et la pression l'expédie droit sur l'adversaire
		S_side = {
			label = "Bouteille-fusée", kind = "projectile", startup = 0.22, active = 0, recovery = 0.45,
			damage = 14, kbBase = 30, kbGrowth = 60, kbAngle = 40,
			projectile = { speed = 85, angle = 0, gravity = 0, lifetime = 0.7, size = 2, color = BOTTLE, visual = "bottle" },
			windup = { Root = { 6, -24, 0, 0, -0.2, 0.25 }, Waist = { 8, -30, 0 }, Neck = { 4, 20, 0 }, RS = { 150, 0, 30 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -10 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			strike = { Root = { -10, 18, 0, 0, -0.3, -0.35 }, Waist = { -14, 24, 0 }, Neck = { 0, -14, 0 }, RS = { 96, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -14, 22, 0, 0, -0.34, -0.42 }, Waist = { -18, 28, 0 }, Neck = { 0, -16, 0 }, RS = { 100, 0, 6 }, RE = { 6, 0, 0 }, RW = { -8, 0, 0 }, LS = { 55, 0, -45 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			shake = true, hideProp = "bottle", windupFx = { "sodaShake" },
			fx = { { "burst", color = SODA, size = 2.5, at = "hand" }, { "particles", tex = "spark", color = SODA, dir = "front", at = "hand", time = 0.3, speed = 18, size = 0.5, rate = 80 } },
			text = "FUSÉE !", hitText = "CLONK !",
		},
		-- Rot sonique (après une esquive) : il gonfle le ventre… et le rot part en onde de choc sur tout le couloir, tête en avant, bras rejetés en arrière
		S_dodge = {
			label = "Rot sonique", startup = 0.15, active = 0.2, recovery = 0.45,
			damage = 12, hitbox = box(14, 6, 7, 1), kbBase = 42, kbGrowth = 35, kbAngle = 15,
			windup = { Root = { 8, 0, 0, 0, -0.3, 0.2 }, Waist = { 22, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 30, 0, -22 }, RE = { 105, 0, 0 }, LS = { 30, 0, 22 }, LE = { 105, 0, 0 } },
			strike = { Root = { -14, 0, 0, 0, -0.3, -0.4 }, Waist = { -26, 0, 0 }, Neck = { -20, 0, 0 }, RS = { -50, 0, 50 }, RE = { 15, 0, 0 }, LS = { -50, 0, -50 }, LE = { 15, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -16, 0, 0, 0, -0.32, -0.45 }, Waist = { -30, 0, 0 }, Neck = { -24, 0, 0 }, RS = { -58, 0, 55 }, RE = { 15, 0, 0 }, LS = { -58, 0, -55 }, LE = { 15, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			shake = true, fx = { "burp", { "ring", color = SODA, radius = 5, at = "front" }, { "beam", color = SODA, length = 14, width = 4, at = "head" } }, text = "BUUURP !", hitText = "BEURK !",
		},
		-- Gorgée et grand crachat : il boit au goulot (+1 bulle), gonfle les joues et crache un jet pétillant qui arrose tout le couloir et laisse une flaque glissante
		S_down = {
			label = "Gorgée et grand crachat", effect = "sip", startup = 0.2, active = 0.15, recovery = 0.5,
			hitbox = box(14, 5, 7, 0.8), kbBase = 26, kbGrowth = 45, kbAngle = 35,
			damage = 12, status = { name = "slippery", duration = 2 }, hitText = "PTOU ! ÇA GLISSE !",
			windup = { Root = { 6, 0, 0, 0, -0.1, 0.1 }, Waist = { 14, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 140, 0, -22 }, RE = { 118, 0, 0 }, RW = { -118, 0, 0 }, LS = { 10, 0, -30 }, LE = { 30, 0, 0 } },
			strike = { Root = { -14, 0, 0, 0, -0.3, -0.4 }, Waist = { -24, 0, 0 }, Neck = { -22, 0, 0 }, RS = { 30, 0, 40 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -10 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { -14, 0, 0, 0, -0.32, -0.45 }, Waist = { -26, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 25, 0, 42 }, RE = { 40, 0, 0 }, RW = { -10, 0, 0 }, LS = { 95, 0, -12 }, LE = { 10, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			hold = 0.15, windupFx = { "sip" }, fx = { "puddle", { "beam", color = SODA, length = 14, width = 2, at = "head" }, { "particles", tex = "spark", color = SODA, dir = "front", at = "head", time = 0.25, speed = 20, size = 0.5, rate = 80 } }, text = "GLOU… PTOU !",
		},
		-- Lampadaire-catapulte (↑L) : accroupi, il s'accroche au lampadaire qui jaillit du sol ; le lampadaire se plie comme une
		-- catapulte et le lance en diagonale vers l'avant, bouteille tendue, jambes qui traînent derrière
		S_up = {
			label = "Lampadaire-catapulte", startup = 0.1, active = 0.3, recovery = 0.4,
			damage = 13, hitbox = box(10, 11, 3, 4), kbBase = 32, kbGrowth = 50, kbAngle = 70, selfVelocity = Vector2.new(42, 80),
			windup = { Root = { 4, 0, 0, 0, -0.8, 0.1 }, Waist = { -12, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 150, 0, 20 }, RE = { 30, 0, 0 }, LS = { 150, 0, -20 }, LE = { 30, 0, 0 } },
			strike = { Root = { -42, 0, 0, 0, 0.4, -0.2 }, Waist = { -6, 0, 0 }, Neck = { 32, 0, 0 }, RS = { 172, 0, 10 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -35, 0, -30 }, LE = { 20, 0, 0 }, RH = { -25, 0, 5 }, RK = { -30, 0, 0 }, LH = { -15, 0, -5 }, LK = { -50, 0, 0 } },
			follow = { Root = { -46, 0, 0, 0, 0.45, -0.25 }, Waist = { -8, 0, 0 }, Neck = { 34, 0, 0 }, RS = { 176, 0, 12 }, RE = { 0, 0, 0 }, RW = { -8, 0, 0 }, LS = { -40, 0, -35 }, LE = { 20, 0, 0 }, RH = { -30, 0, 6 }, RK = { -35, 0, 0 }, LH = { -20, 0, -6 }, LK = { -55, 0, 0 } },
			trail = "bottle", fx = { "lamp", { "burst", color = SODA, size = 3, at = "feet" }, { "ring", color = SODA, radius = 5, at = "feet" }, { "particles", tex = "smoke", color = Color3.fromRGB(230, 230, 230), dir = "down", at = "feet", time = 0.35, speed = 12 } },
			text = "CATAPULTÉ !", hitText = "DING !",
		},
		-- Haleine-briquet (S maintenu) : briquet devant la bouche, il se penche et souffle une longue flamme cartoon qui traverse tout le couloir
		S_hold = {
			label = "Haleine-briquet", startup = 0.28, active = 0.3, recovery = 0.5,
			damage = 15, hitbox = box(15, 5, 7.5, 1), kbBase = 30, kbGrowth = 75, kbAngle = 30,
			windup = { Root = { 6, 0, 0, 0, -0.1, 0.2 }, Waist = { 10, 0, 0 }, Neck = { 8, 0, 0 }, RS = { 30, 0, 25 }, LS = { 115, 0, 22 }, LE = { 105, 0, 0 } },
			strike = { Root = { -12, 0, 0, 0, -0.3, -0.3 }, Waist = { -18, 0, 0 }, Neck = { -12, 0, 0 }, RS = { -25, 0, 40 }, LS = { 92, 0, 15 }, LE = { 75, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.35 } },
			follow = { Root = { -14, 0, 0, 0, -0.32, -0.38 }, Waist = { -22, 0, 0 }, Neck = { -16, 0, 0 }, RS = { -30, 0, 45 }, LS = { 95, 0, 12 }, LE = { 70, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			prop = "lighter", fx = { "fire", { "beam", color = Color3.fromRGB(255, 140, 40), length = 14, width = 3, at = "head" } }, text = "FOUUU !", hitText = "FLAMBÉ !",
		},
		-- Titubade folle (→→S) : charge en zigzag bras grands ouverts, il encaisse tout et fauche le couloir entier
		S_dash = {
			label = "Titubade folle", startup = 0.15, active = 0.35, recovery = 0.4,
			damage = 13, hitbox = box(14, 5, 6, 0.5), kbBase = 30, kbGrowth = 60, kbAngle = 35, selfVelocity = Vector2.new(60, 0), invuln = 0.2, armor = true,
			windup = { Root = { -10, 0, 0 }, RS = { 60, 0, 50 }, LS = { 60, 0, -50 } },
			strike = { Root = { -25, 0, 0 }, Waist = { -10, 0, 0 }, RS = { 80, 0, 70 }, RE = { 30, 0, 0 }, LS = { 80, 0, -70 }, LE = { 30, 0, 0 } },
			follow = { Root = { -22, 0, 0 }, Waist = { -8, 0, 0 }, RS = { 70, 0, 80 }, RE = { 40, 0, 0 }, LS = { 70, 0, -80 }, LE = { 40, 0, 0 } },
			wobble = true, trail = "body", fx = { "dust" }, hitText = "BOUM !",
		},
		-- Plongeon du comptoir (S en l'air) : plat ventre en piqué, bras tendus devant, il s'écrase sur l'adversaire
		S_air = {
			label = "Plongeon du comptoir", startup = 0.15, active = 0.35, recovery = 0.4,
			damage = 13, hitbox = box(6, 5, 2, -1), kbBase = 25, kbGrowth = 55, kbAngle = -35, selfVelocity = Vector2.new(25, -70),
			windup = { Root = { 20, 0, 0 }, Waist = { 10, 0, 0 }, RS = { 150, 0, 30 }, LS = { 150, 0, -30 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 60, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { -70, 0, 0 }, Waist = { -10, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 175, 0, 10 }, RE = { 0, 0, 0 }, LS = { 175, 0, -10 }, LE = { 0, 0, 0 }, RH = { -10, 0, 0 }, RK = { -10, 0, 0 }, LH = { -10, 0, 0 }, LK = { -25, 0, 0 } },
			follow = { Root = { -78, 0, 0 }, Waist = { -12, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 178, 0, 15 }, RE = { 0, 0, 0 }, LS = { 178, 0, -15 }, LE = { 0, 0, 0 }, RH = { -15, 0, 5 }, RK = { -30, 0, 0 }, LH = { -5, 0, -5 }, LK = { -15, 0, 0 } },
			trail = "body", hitText = "SPLAF !",
		},

		------------------------------------------------------------------ Suites d'enchaînement (voir LINKS en bas)
		-- J puis K : Savate en traître, petit coup de pied sec dans le tibia
		PK_combo = {
			label = "Savate en traître", startup = 0.1, active = 0.08, recovery = 0.2,
			damage = 7, hitbox = box(5, 3.5, 3, -0.5), kbBase = 22, kbGrowth = 30, kbAngle = 30,
			windup = { Root = { 4, -10, 0, 0, -0.2, 0.15 }, Waist = { 6, -12, 0 }, RS = { 40, 0, 30 }, RE = { 60, 0, 0 }, LS = { 50, 0, -30 }, LE = { 70, 0, 0 }, RH = { -20, 0, 8 }, RK = { -70, 0, 0 }, RA = { 0, 0, 0 } },
			strike = { Root = { -6, 10, 0, 0, -0.3, -0.2 }, Waist = { -8, 8, 0 }, RS = { 20, 0, 45 }, RE = { 40, 0, 0 }, LS = { 70, 0, -35 }, LE = { 60, 0, 0 }, RH = { 62, 0, 6 }, RK = { -5, 0, 0 }, RA = { -25, 0, 0 } },
			follow = { Root = { -8, 14, 0, 0, -0.32, -0.25 }, Waist = { -10, 10, 0 }, RS = { 15, 0, 48 }, RE = { 40, 0, 0 }, LS = { 72, 0, -35 }, LE = { 60, 0, 0 }, RH = { 66, 0, 0 }, RK = { -8, 0, 0 }, RA = { -25, 0, 0 } },
			trail = "rightFoot", hitText = "TOC !",
		},
		-- J K J : Crochet de comptoir, crochet du gauche (la droite tient la bouteille)
		PKP_combo = {
			label = "Crochet de comptoir", startup = 0.1, active = 0.08, recovery = 0.22,
			damage = 8, hitbox = box(5, 3.5, 2.5, 0.8), kbBase = 25, kbGrowth = 40, kbAngle = 35,
			windup = { Root = { 2, 22, 0, 0, -0.2, 0.1 }, Waist = { 4, 28, 0 }, RS = { 30, 0, 20 }, RE = { 80, 0, 0 }, LS = { 80, 0, -75 }, LE = { 100, 0, 0 }, LW = { 0, 0, 0 } },
			strike = { Root = { -8, -20, 0, 0, -0.3, -0.3 }, Waist = { -10, -34, 0 }, RS = { 20, 0, 25 }, RE = { 90, 0, 0 }, LS = { 95, 0, -15 }, LE = { 75, 0, 0 } },
			follow = { Root = { -10, -28, 0, 0, -0.32, -0.35 }, Waist = { -12, -44, 0 }, RS = { 18, 0, 28 }, RE = { 90, 0, 0 }, LS = { 90, 0, 10 }, LE = { 80, 0, 0 } },
			trail = "leftHand", hitText = "PAN !",
		},
		-- J J K : Balayette du pochtron, accroupi il tourne sur lui-même jambe tendue au ras du sol (fait décoller)
		PPK_combo = {
			label = "Balayette du pochtron", startup = 0.1, active = 0.14, recovery = 0.3,
			damage = 10, hitbox = box(7, 3.5, 2.5, -0.8), kbBase = 30, kbGrowth = 55, kbAngle = 80,
			windup = { Root = { -6, -20, 0, 0, -1.0, 0 }, Waist = { -18, -10, 0 }, RS = { 30, 0, 50 }, RE = { 30, 0, 0 }, LS = { 40, 0, -50 }, LE = { 30, 0, 0 } },
			strike = { Root = { -10, 0, 0, 0, -1.25, 0 }, Waist = { -20, 0, 0 }, RS = { 10, 0, 60 }, RE = { 20, 0, 0 }, LS = { 20, 0, -60 }, LE = { 20, 0, 0 }, RH = { 75, 0, 15 }, RK = { -5, 0, 0 }, RA = { -20, 0, 0 } },
			follow = { Root = { -10, 0, 0, 0, -1.2, 0 }, Waist = { -18, 0, 0 }, RS = { 15, 0, 62 }, RE = { 20, 0, 0 }, LS = { 25, 0, -62 }, LE = { 20, 0, 0 }, RH = { 72, 0, 18 }, RK = { -8, 0, 0 }, RA = { -20, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "rightFoot", hitText = "ZOUIP !",
		},
		-- K puis J : Coup de coude, il pivote et enfonce le coude droit
		KP_combo = {
			label = "Coup de coude", startup = 0.09, active = 0.08, recovery = 0.2,
			damage = 7, hitbox = box(5, 3.5, 2.5, 0.8), kbBase = 22, kbGrowth = 35, kbAngle = 30,
			windup = { Root = { 2, -25, 0, 0, -0.15, 0.15 }, Waist = { 4, -30, 0 }, RS = { 40, 0, 60 }, RE = { 140, 0, 0 }, LS = { 60, 0, -20 }, LE = { 90, 0, 0 } },
			strike = { Root = { -8, 22, 0, 0, -0.3, -0.35 }, Waist = { -12, 30, 0 }, RS = { 90, 0, -10 }, RE = { 145, 0, 0 }, LS = { 30, 0, -30 }, LE = { 100, 0, 0 } },
			follow = { Root = { -10, 28, 0, 0, -0.32, -0.4 }, Waist = { -14, 36, 0 }, RS = { 92, 0, -18 }, RE = { 145, 0, 0 }, LS = { 25, 0, -32 }, LE = { 100, 0, 0 } },
			hitText = "CRAC !",
		},
		-- K J K : Ruade arrière, il se retourne et rue des deux… enfin d'une jambe, comme un âne
		KPK_combo = {
			label = "Ruade arrière", startup = 0.1, active = 0.1, recovery = 0.32,
			damage = 11, hitbox = box(5, 3.5, 3, 0.5), kbBase = 32, kbGrowth = 75, kbAngle = 30,
			windup = { Root = { 0, 90, 0, 0, -0.3, 0 }, Waist = { -10, 20, 0 }, Neck = { 0, -60, 0 }, RS = { 40, 0, 40 }, RE = { 60, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 } },
			strike = { Root = { 35, 170, 0, 0, -0.35, 0 }, Waist = { 10, 0, 0 }, Neck = { -30, 0, 0 }, RS = { 70, 0, 30 }, RE = { 30, 0, 0 }, LS = { 70, 0, -30 }, LE = { 30, 0, 0 }, RH = { -80, 0, 0 }, RK = { -5, 0, 0 }, RA = { -30, 0, 0 }, LH = { 30, 0, 0 }, LK = { -35, 0, 0 } },
			follow = { Root = { 40, 172, 0, 0, -0.35, 0 }, Waist = { 12, 0, 0 }, Neck = { -34, 0, 0 }, RS = { 75, 0, 32 }, RE = { 30, 0, 0 }, LS = { 75, 0, -32 }, LE = { 30, 0, 0 }, RH = { -88, 0, 0 }, RK = { -5, 0, 0 }, RA = { -30, 0, 0 }, LH = { 35, 0, 0 }, LK = { -38, 0, 0 } },
			trail = "rightFoot", hitText = "HI-HAN !",
		},
		-- K K J : Uppercut à la bouteille, de l'accroupi jusqu'au ciel (fait décoller)
		KKP_combo = {
			label = "Uppercut à la bouteille", startup = 0.1, active = 0.1, recovery = 0.3,
			damage = 10, hitbox = box(5, 5, 2.5, 2.5), kbBase = 34, kbGrowth = 60, kbAngle = 85,
			windup = { Root = { -6, -15, 0, 0, -0.7, 0.1 }, Waist = { -20, -15, 0 }, RS = { -30, 0, 25 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -30 }, LE = { 80, 0, 0 } },
			strike = { Root = { 8, 15, 0, 0, 0.2, -0.2 }, Waist = { 15, 20, 0 }, RS = { 170, 0, 10 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { -10, 0, -30 }, LE = { 40, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			follow = { Root = { 10, 18, 0, 0, 0.25, -0.25 }, Waist = { 18, 22, 0 }, RS = { 178, 0, 5 }, RE = { 10, 0, 0 }, RW = { -10, 0, 0 }, LS = { -15, 0, -32 }, LE = { 40, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			trail = "bottle", hitText = "WOUSH !",
		},
		-- → J J : Double revers, la bouteille revient dans l'autre sens
		P_side2 = {
			label = "Double revers", startup = 0.08, active = 0.08, recovery = 0.2,
			damage = 7, hitbox = box(5, 3.5, 3, 0.5), kbBase = 22, kbGrowth = 35, kbAngle = 25, selfVelocity = Vector2.new(15, 0),
			windup = { Root = { -10, 40, 0, 0, -0.4, -0.4 }, Waist = { -14, 50, 0 }, RS = { 90, 0, -45 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { -30, 0, -40 }, LE = { 40, 0, 0 } },
			strike = { Root = { -6, -20, 0, 0, -0.35, -0.45 }, Waist = { -10, -34, 0 }, RS = { 95, 0, 55 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 70, 0, 0 } },
			follow = { Root = { -6, -28, 0, 0, -0.35, -0.5 }, Waist = { -10, -44, 0 }, RS = { 85, 0, 75 }, RE = { 20, 0, 0 }, RW = { -15, 0, 0 }, LS = { 45, 0, -30 }, LE = { 70, 0, 0 } },
			trail = "bottle", hitText = "PAF PAF !",
		},
		-- → J K : Genou dans la foulée
		P_sideK = {
			label = "Genou dans la foulée", startup = 0.1, active = 0.1, recovery = 0.22,
			damage = 8, hitbox = box(5, 3.5, 2.5, 0.5), kbBase = 26, kbGrowth = 45, kbAngle = 45, selfVelocity = Vector2.new(22, 0),
			windup = { Root = { 4, -6, 0, 0, -0.2, 0.1 }, RS = { 30, 0, 40 }, LS = { 40, 0, -35 }, RH = { -20, 0, 0 }, RK = { -60, 0, 0 } },
			strike = { Root = { -14, 6, 0, 0, 0.05, -0.4 }, Waist = { -12, 4, 0 }, RS = { -20, 0, 45 }, RE = { 50, 0, 0 }, LS = { -20, 0, -45 }, LE = { 50, 0, 0 }, RH = { 105, 0, 0 }, RK = { -125, 0, 0 }, RA = { -30, 0, 0 } },
			follow = { Root = { -16, 8, 0, 0, 0.08, -0.45 }, Waist = { -14, 4, 0 }, RS = { -25, 0, 48 }, RE = { 50, 0, 0 }, LS = { -25, 0, -48 }, LE = { 50, 0, 0 }, RH = { 112, 0, 0 }, RK = { -128, 0, 0 }, RA = { -30, 0, 0 } },
			trail = "rightLeg", hitText = "GNOC !",
		},
		-- ↓ J J : Remontée du goulot, uppercut qui part de l'accroupi
		P_down2 = {
			label = "Remontée du goulot", startup = 0.1, active = 0.1, recovery = 0.25,
			damage = 8, hitbox = box(5, 5, 2.5, 2), kbBase = 30, kbGrowth = 45, kbAngle = 80,
			windup = { Root = { -10, -10, 0, 0, -0.9, 0.1 }, Waist = { -24, -10, 0 }, RS = { -20, 0, 20 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -30 }, LE = { 80, 0, 0 } },
			strike = { Root = { 6, 12, 0, 0, 0.15, -0.2 }, Waist = { 14, 16, 0 }, RS = { 160, 0, 5 }, RE = { 15, 0, 0 }, RW = { 0, 0, 0 }, LS = { 0, 0, -30 }, LE = { 60, 0, 0 } },
			follow = { Root = { 8, 14, 0, 0, 0.2, -0.25 }, Waist = { 16, 18, 0 }, RS = { 175, 0, 0 }, RE = { 8, 0, 0 }, RW = { -20, 0, 0 }, LS = { -5, 0, -32 }, LE = { 60, 0, 0 } },
			trail = "bottle", hitText = "HOP LÀ !",
		},
		-- ↓ J K : Double croche-patte, cette fois avec la jambe gauche
		P_downK = {
			label = "Double croche-patte", startup = 0.1, active = 0.08, recovery = 0.22,
			damage = 7, hitbox = box(5, 3.5, 2.5, -0.6), kbBase = 28, kbGrowth = 30, kbAngle = 75,
			windup = { Root = { -8, 18, 0, 0, -0.75, 0.2 }, Waist = { -16, 10, 0 }, RS = { 50, 0, 30 }, RE = { 55, 0, 0 }, LS = { 30, 0, -38 }, LE = { 45, 0, 0 }, LH = { -15, 0, -18 }, LK = { -60, 0, 0 }, LA = { 0, 0, 0 } },
			strike = { Root = { -12, -22, 0, 0, -0.9, -0.1 }, Waist = { -22, -16, 0 }, RS = { 75, 0, 30 }, RE = { 40, 0, 0 }, LS = { 10, 0, -48 }, LE = { 30, 0, 0 }, LH = { 62, 0, -10 }, LK = { -6, 0, 0 }, LA = { -20, 0, 0 } },
			follow = { Root = { -12, -32, 0, 0, -0.9, -0.15 }, Waist = { -22, -26, 0 }, RS = { 80, 0, 28 }, RE = { 40, 0, 0 }, LS = { 5, 0, -50 }, LE = { 30, 0, 0 }, LH = { 58, 0, 12 }, LK = { -8, 0, 0 }, LA = { -20, 0, 0 } },
			trail = "leftFoot", hitText = "RE-OUPS !",
		},
		-- ↑ J K : Coup de pied du hoquet, un hoquet lui envoie la jambe tout en haut
		P_upK = {
			label = "Coup de pied du hoquet", startup = 0.1, active = 0.1, recovery = 0.3,
			damage = 9, hitbox = box(5, 5, 2.5, 2.5), kbBase = 30, kbGrowth = 55, kbAngle = 85,
			windup = { Root = { 6, 0, 0, 0, -0.3, 0.1 }, Waist = { 8, 0, 0 }, RS = { 40, 0, 50 }, LS = { 40, 0, -50 }, RH = { 60, 0, 0 }, RK = { -110, 0, 0 } },
			strike = { Root = { 20, 0, 0, 0, -0.1, 0 }, Waist = { 20, 0, 0 }, Neck = { 10, 0, 0 }, RS = { -20, 0, 70 }, RE = { 20, 0, 0 }, LS = { -20, 0, -70 }, LE = { 20, 0, 0 }, RH = { 150, 0, 0 }, RK = { -5, 0, 0 }, RA = { 20, 0, 0 } },
			follow = { Root = { 24, 0, 0, 0, -0.1, 0.05 }, Waist = { 22, 0, 0 }, Neck = { 12, 0, 0 }, RS = { -25, 0, 72 }, RE = { 20, 0, 0 }, LS = { -25, 0, -72 }, LE = { 20, 0, 0 }, RH = { 160, 0, 0 }, RK = { -5, 0, 0 }, RA = { 20, 0, 0 } },
			trail = "rightFoot", fx = { "hiccup" }, hitText = "HIC-POW !",
		},
		-- → K J : Coup de tête après le genou
		K_sideP = {
			label = "Coup de tête", startup = 0.1, active = 0.1, recovery = 0.25,
			damage = 9, hitbox = box(5, 3.5, 2.5, 1), kbBase = 28, kbGrowth = 55, kbAngle = 40,
			windup = { Root = { 12, 0, 0, 0, -0.1, 0.2 }, Waist = { 18, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 60, 0, 30 }, RE = { 90, 0, 0 }, LS = { 60, 0, -30 }, LE = { 90, 0, 0 } },
			strike = { Root = { -15, 0, 0, 0, -0.25, -0.45 }, Waist = { -30, 0, 0 }, Neck = { -30, 0, 0 }, RS = { 20, 0, 40 }, RE = { 60, 0, 0 }, LS = { 20, 0, -40 }, LE = { 60, 0, 0 } },
			follow = { Root = { -18, 0, 0, 0, -0.28, -0.5 }, Waist = { -34, 0, 0 }, Neck = { -34, 0, 0 }, RS = { 15, 0, 42 }, RE = { 60, 0, 0 }, LS = { 15, 0, -42 }, LE = { 60, 0, 0 } },
			fx = { "headStar" }, hitText = "BOING !",
		},
		-- ↑ K J : Bouteille sur le crâne
		K_upP = {
			label = "Bouteille sur le crâne", startup = 0.1, active = 0.1, recovery = 0.28,
			damage = 9, hitbox = box(5, 4, 2.5, 1.2), kbBase = 28, kbGrowth = 50, kbAngle = 60,
			windup = { Root = { 8, -6, 0, 0, 0.05, 0.15 }, Waist = { 14, -8, 0 }, RS = { 190, 0, 10 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 40, 0, 0 } },
			strike = { Root = { -12, 8, 0, 0, -0.35, -0.3 }, Waist = { -28, 10, 0 }, RS = { 80, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { -10, 0, -30 }, LE = { 50, 0, 0 } },
			follow = { Root = { -14, 10, 0, 0, -0.4, -0.35 }, Waist = { -32, 12, 0 }, RS = { 55, 0, 5 }, RE = { 5, 0, 0 }, RW = { -25, 0, 0 }, LS = { -15, 0, -32 }, LE = { 50, 0, 0 } },
			trail = "bottle", hitText = "CLING !",
		},
		-- J →J : Coup de bedaine, il rentre le ventre puis le projette en avant, bras rejetés en arrière
		P_belly = {
			label = "Coup de bedaine", startup = 0.1, active = 0.1, recovery = 0.25,
			damage = 8, hitbox = box(5, 4, 2.5, 0.5), kbBase = 34, kbGrowth = 40, kbAngle = 20, selfVelocity = Vector2.new(20, 0),
			windup = { Root = { -10, 0, 0, 0, -0.3, 0.3 }, Waist = { -25, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 60, 0, 30 }, RE = { 60, 0, 0 }, LS = { 60, 0, -30 }, LE = { 60, 0, 0 } },
			strike = { Root = { 18, 0, 0, 0, -0.2, -0.6 }, Waist = { 25, 0, 0 }, Neck = { -20, 0, 0 }, RS = { -50, 0, 35 }, RE = { 20, 0, 0 }, LS = { -50, 0, -35 }, LE = { 20, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.4 } },
			follow = { Root = { 22, 0, 0, 0, -0.2, -0.7 }, Waist = { 30, 0, 0 }, Neck = { -24, 0, 0 }, RS = { -60, 0, 40 }, RE = { 25, 0, 0 }, LS = { -60, 0, -40 }, LE = { 25, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.45 } },
			text = "BEDAINE !", hitText = "BLOING !",
		},
		-- J J ←J : Repli du pochtron, petit saut en arrière en balayant devant lui avec la bouteille
		P_retreat = {
			label = "Repli du pochtron", startup = 0.08, active = 0.08, recovery = 0.2,
			damage = 6, hitbox = box(5, 3.5, 2.5, 0.5), kbBase = 22, kbGrowth = 30, kbAngle = 30, selfVelocity = Vector2.new(-28, 0),
			windup = { Root = { 6, -10, 0, 0, -0.3, 0 }, Waist = { 10, -10, 0 }, RS = { 140, 0, 30 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -40 }, LE = { 60, 0, 0 } },
			strike = { Root = { 14, 10, 0, 0, 0.1, 0.5 }, Waist = { 8, 10, 0 }, Neck = { -10, 0, 0 }, RS = { 75, 0, 5 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { -40, 0, -40 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0.4 }, FL = { 0, 0, 0, 0, 0.4, 0.3 } },
			follow = { Root = { 16, 12, 0, 0, 0, 0.6 }, Waist = { 10, 12, 0 }, Neck = { -12, 0, 0 }, RS = { 55, 0, 0 }, RE = { 10, 0, 0 }, RW = { -20, 0, 0 }, LS = { -45, 0, -42 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0, 0.5 }, FL = { 0, 0, 0, 0, 0, 0.5 } },
			trail = "bottle", text = "OUSTE !", hitText = "PIF !",
		},
		-- J J J K : Savate de fin de tournée, il titube en moulinant des bras puis lance un grand coup de pied haut
		PPPK_combo = {
			label = "Savate de fin de tournée", startup = 0.1, active = 0.12, recovery = 0.35,
			damage = 11, hitbox = box(5, 3.5, 3, 0.5), kbBase = 34, kbGrowth = 85, kbAngle = 42, selfVelocity = Vector2.new(15, 0),
			windup = { Root = { -12, -20, 8, 0, -0.35, 0.2 }, Waist = { -10, -15, 0 }, Neck = { 10, 0, 0 }, RS = { 120, 0, 60 }, RE = { 30, 0, 0 }, LS = { 30, 0, -70 }, LE = { 40, 0, 0 }, RH = { 95, 0, 0 }, RK = { -130, 0, 0 }, RA = { -20, 0, 0 } },
			strike = { Root = { 24, 10, -6, 0, -0.05, -0.3 }, Waist = { 14, 5, 0 }, Neck = { -10, 0, 0 }, RS = { -30, 0, 75 }, RE = { 10, 0, 0 }, LS = { 70, 0, -80 }, LE = { 10, 0, 0 }, RH = { 105, 0, 0 }, RK = { -4, 0, 0 }, RA = { 15, 0, 0 } },
			follow = { Root = { 28, 14, -8, 0, -0.05, -0.35 }, Waist = { 16, 6, 0 }, Neck = { -12, 0, 0 }, RS = { -38, 0, 80 }, RE = { 10, 0, 0 }, LS = { 75, 0, -85 }, LE = { 10, 0, 0 }, RH = { 115, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 } },
			trail = "rightFoot", fx = { "slipper" }, text = "ET DE QUATRE !", hitText = "SBOING !",
		},
		-- ↑ J J : Gros hoquet, accroupi il gonfle… et un hoquet énorme le fait décoller, bras au ciel
		P_up2 = {
			label = "Gros hoquet", startup = 0.1, active = 0.12, recovery = 0.25,
			damage = 8, hitbox = box(5.5, 6, 2.5, 3.5), kbBase = 30, kbGrowth = 40, kbAngle = 88, selfVelocity = Vector2.new(0, 40),
			windup = { Root = { -14, 0, 0, 0, -1.0, 0 }, Waist = { -30, 0, 0 }, Neck = { -25, 0, 0 }, RS = { 10, 0, 20 }, RE = { 100, 0, 0 }, LS = { 15, 0, -20 }, LE = { 100, 0, 0 } },
			strike = { Root = { 10, 0, 0, 0, 0.6, 0 }, Waist = { 24, 0, 0 }, Neck = { 38, 0, 0 }, RS = { 172, 0, 25 }, RE = { 5, 0, 0 }, LS = { 168, 0, -25 }, LE = { 5, 0, 0 }, RH = { -10, 0, 0 }, RK = { -40, 0, 0 }, LH = { 10, 0, 0 }, LK = { -60, 0, 0 } },
			follow = { Root = { 14, 0, 0, 0, 0.7, 0 }, Waist = { 28, 0, 0 }, Neck = { 44, 0, 0 }, RS = { 178, 0, 32 }, RE = { 10, 0, 0 }, LS = { 175, 0, -32 }, LE = { 10, 0, 0 }, RH = { -15, 0, 0 }, RK = { -50, 0, 0 }, LH = { 15, 0, 0 }, LK = { -70, 0, 0 } },
			shake = true, fx = { "hiccup" }, text = "HIIIIC !", hitText = "HIC-BOUM !",
		},
		-- ↑ K K : Ciseaux vers le ciel, petit saut : la jambe gauche monte, puis la droite la croise tout en haut
		K_upK = {
			label = "Ciseaux vers le ciel", startup = 0.1, active = 0.12, recovery = 0.3,
			damage = 10, hitbox = box(5, 5, 2.5, 2.5), kbBase = 30, kbGrowth = 55, kbAngle = 85,
			windup = { Root = { 10, 0, 0, 0, 0.2, 0 }, Waist = { 10, 0, 0 }, RS = { 40, 0, 50 }, RE = { 40, 0, 0 }, LS = { 40, 0, -50 }, LE = { 40, 0, 0 }, LH = { 130, 0, 0 }, LK = { -20, 0, 0 }, RH = { -10, 0, 0 }, RK = { -40, 0, 0 } },
			strike = { Root = { 25, 0, 0, 0, 0.5, 0 }, Waist = { 10, 0, 0 }, Neck = { 15, 0, 0 }, RS = { -35, 0, 65 }, RE = { 20, 0, 0 }, LS = { -35, 0, -65 }, LE = { 20, 0, 0 }, RH = { 155, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { -20, 0, 0 }, LK = { -30, 0, 0 } },
			follow = { Root = { 30, 0, 0, 0, 0.55, 0 }, Waist = { 12, 0, 0 }, Neck = { 18, 0, 0 }, RS = { -40, 0, 70 }, RE = { 20, 0, 0 }, LS = { -40, 0, -70 }, LE = { 20, 0, 0 }, RH = { 165, 0, 0 }, RK = { 0, 0, 0 }, RA = { 20, 0, 0 }, LH = { -25, 0, 0 }, LK = { -35, 0, 0 } },
			trail = "rightFoot", hitText = "CRIC-CRAC !",
		},
		-- → K K : Talon retourné, il tourne sur le pied gauche, jambe droite tendue comme une aiguille de montre
		K_side2 = {
			label = "Talon retourné", startup = 0.1, active = 0.16, recovery = 0.32,
			damage = 12, hitbox = box(6, 3.5, 2.5, 0.5), kbBase = 32, kbGrowth = 75, kbAngle = 35,
			windup = { Root = { 4, -40, 0, 0, -0.25, 0.1 }, Waist = { 4, -20, 0 }, Neck = { 0, 30, 0 }, RS = { 50, 0, 40 }, RE = { 60, 0, 0 }, LS = { 60, 0, -40 }, LE = { 60, 0, 0 }, RH = { 40, 0, 0 }, RK = { -100, 0, 0 } },
			strike = { Root = { 25, 0, 0, 0, -0.1, 0 }, Waist = { 5, 0, 0 }, Neck = { -15, 0, 0 }, RS = { 40, 0, 80 }, RE = { 10, 0, 0 }, LS = { 50, 0, -80 }, LE = { 10, 0, 0 }, RH = { 75, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 } },
			follow = { Root = { 28, 0, 0, 0, -0.1, 0 }, Waist = { 6, 0, 0 }, Neck = { -18, 0, 0 }, RS = { 35, 0, 85 }, RE = { 10, 0, 0 }, LS = { 45, 0, -85 }, LE = { 10, 0, 0 }, RH = { 80, 0, 0 }, RK = { -5, 0, 0 }, RA = { 15, 0, 0 } },
			spin = { axis = "y", degrees = 360 }, trail = "rightFoot", hitText = "SPLANG !",
		},
		-- ↓ K K : Roulé-boulé de la flaque, sorti de la glissade il roule en boule et repart les deux pieds devant
		K_downK = {
			label = "Roulé-boulé de la flaque", startup = 0.1, active = 0.22, recovery = 0.3,
			damage = 9, hitbox = box(6, 3.5, 2.5, -0.5), kbBase = 30, kbGrowth = 50, kbAngle = 70, selfVelocity = Vector2.new(30, 0),
			windup = { Root = { -15, 0, 0, 0, -0.9, 0.1 }, Waist = { -30, 0, 0 }, Neck = { -25, 0, 0 }, RS = { 70, 0, 20 }, RE = { 90, 0, 0 }, LS = { 70, 0, -20 }, LE = { 90, 0, 0 } },
			strike = { Root = { -30, 0, 0, 0, -0.6, -0.3 }, Waist = { -40, 0, 0 }, Neck = { -30, 0, 0 }, RS = { 60, 0, 20 }, RE = { 110, 0, 0 }, LS = { 60, 0, -20 }, LE = { 110, 0, 0 }, RH = { 120, 0, 0 }, RK = { -140, 0, 0 }, LH = { 120, 0, 0 }, LK = { -140, 0, 0 } },
			follow = { Root = { 20, 0, 0, 0, -1.0, -0.6 }, Waist = { -10, 0, 0 }, Neck = { -15, 0, 0 }, RS = { -30, 0, 40 }, RE = { 20, 0, 0 }, LS = { -30, 0, -40 }, LE = { 20, 0, 0 }, RH = { 80, 0, 0 }, RK = { 0, 0, 0 }, RA = { 15, 0, 0 }, LH = { 70, 0, 0 }, LK = { -10, 0, 0 }, LA = { 15, 0, 0 } },
			spin = { axis = "x", degrees = 360 }, trail = "bothFeet", fx = { "puddle" }, hitText = "PATAPOUF !",
		},
		-- ↓ K J : Coup de boule remontant, du sol il se redresse d'un bond, tête la première
		K_downP = {
			label = "Coup de boule remontant", startup = 0.1, active = 0.1, recovery = 0.28,
			damage = 9, hitbox = box(5, 4, 2.5, 1.2), kbBase = 30, kbGrowth = 50, kbAngle = 70, selfVelocity = Vector2.new(20, 0),
			windup = { Root = { -20, 0, 0, 0, -1.2, 0.2 }, Waist = { -35, 0, 0 }, Neck = { -30, 0, 0 }, RS = { -20, 0, 30 }, RE = { 60, 0, 0 }, LS = { -20, 0, -30 }, LE = { 60, 0, 0 } },
			strike = { Root = { -28, 0, 0, 0, 0.1, -0.6 }, Waist = { -20, 0, 0 }, Neck = { -25, 0, 0 }, RS = { -60, 0, 30 }, RE = { 10, 0, 0 }, LS = { -60, 0, -30 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0 }, FL = { 0, 0, 0, 0, 0.2, -0.3 } },
			follow = { Root = { -30, 0, 0, 0, 0.25, -0.7 }, Waist = { -22, 0, 0 }, Neck = { -28, 0, 0 }, RS = { -65, 0, 32 }, RE = { 10, 0, 0 }, LS = { -65, 0, -32 }, LE = { 10, 0, 0 }, FR = { 0, 0, 0, 0, 0.4, 0 }, FL = { 0, 0, 0, 0, 0.3, -0.3 } },
			fx = { "headStar" }, hitText = "TONK !",
		},
		-- dash J J : Plateau du serveur, après l'épaule il ramène la bouteille en grand arc comme un plateau
		P_dash2 = {
			label = "Plateau du serveur", startup = 0.1, active = 0.1, recovery = 0.22,
			damage = 8, hitbox = box(5, 3.5, 2.5, 0.8), kbBase = 26, kbGrowth = 45, kbAngle = 30, selfVelocity = Vector2.new(15, 0),
			windup = { Root = { -6, -40, 0, 0, -0.3, 0.1 }, Waist = { -6, -30, 0 }, Neck = { 0, 25, 0 }, RS = { 100, 0, 70 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -30 }, LE = { 80, 0, 0 } },
			strike = { Root = { -10, 30, 0, 0, -0.35, -0.3 }, Waist = { -10, 30, 0 }, Neck = { 0, -20, 0 }, RS = { 95, 0, -20 }, RE = { 10, 0, 0 }, RW = { 0, 0, 0 }, LS = { -20, 0, -40 }, LE = { 40, 0, 0 } },
			follow = { Root = { -10, 42, 0, 0, -0.35, -0.35 }, Waist = { -10, 40, 0 }, Neck = { 0, -26, 0 }, RS = { 90, 0, -45 }, RE = { 15, 0, 0 }, RW = { -15, 0, 0 }, LS = { -25, 0, -45 }, LE = { 40, 0, 0 } },
			trail = "bottle", hitText = "PLONG !",
		},

		------------------------------------------------------------------ Finitions avec L (dans un enchaînement)
		-- Gerbe de soda : il secoue et arrose devant lui en balayant (de près)
		S_finish_spray = {
			label = "Gerbe de soda", startup = 0.16, active = 0.2, recovery = 0.3,
			damage = 9, hitbox = box(7, 4, 4, 0.5), kbBase = 30, kbGrowth = 50, kbAngle = 30,
			windup = { Root = { 0, -12, 0, 0, -0.2, 0.1 }, Waist = { 0, -18, 0 }, RS = { 75, 0, 5 }, RE = { 95, 0, 0 }, RW = { 15, 0, 0 }, LS = { 65, 0, 20 }, LE = { 85, 0, 0 } },
			strike = { Root = { -6, -10, 0, 0, -0.25, -0.15 }, Waist = { -8, -10, 0 }, RS = { 92, 0, 15 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 85, 0, 25 }, LE = { 25, 0, 0 } },
			follow = { Root = { -6, 18, 0, 0, -0.25, -0.2 }, Waist = { -8, 24, 0 }, RS = { 95, 0, -25 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 88, 0, 0 }, LE = { 30, 0, 0 } },
			shake = true, windupFx = { "sodaShake" }, fx = { "spray" }, text = "SPLOOOSH !", hitText = "SPLASH !",
		},
		-- Toupie de bouteille : bras écartés, il tourne deux fois sur lui-même
		S_finish_spin = {
			label = "Toupie de bouteille", startup = 0.1, active = 0.3, recovery = 0.3,
			damage = 11, hitbox = box(8, 4, 0, 0.5), kbBase = 32, kbGrowth = 65, kbAngle = 45,
			windup = { Root = { 0, -30, 0, 0, -0.3, 0 }, Waist = { 0, -20, 0 }, RS = { 60, 0, 40 }, LS = { 60, 0, -40 } },
			strike = { Root = { 0, 0, 0, 0, -0.1, 0 }, Neck = { -10, 0, 0 }, RS = { 90, 0, 85 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -85 }, LE = { 0, 0, 0 } },
			follow = { Root = { 0, 0, 0, 0, -0.1, 0 }, Neck = { -10, 0, 0 }, RS = { 90, 0, 88 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -88 }, LE = { 0, 0, 0 } },
			spin = { axis = "y", degrees = 720 }, trail = "bottle", text = "TOUPIIIE !", hitText = "VLOUF !",
		},
		-- Bouchon explosif : bouteille pointée, il fait sauter la capsule du pouce
		S_finish_cap = {
			label = "Bouchon explosif", kind = "projectile", startup = 0.12, active = 0, recovery = 0.28,
			damage = 8, kbBase = 30, kbGrowth = 55, kbAngle = 40,
			projectile = { speed = 90, angle = 5, gravity = 0, lifetime = 0.25, size = 1.2, color = Color3.fromRGB(220, 50, 40), visual = "cap" },
			windup = { Root = { 0, -10, 0, 0, -0.15, 0.1 }, Waist = { 0, -12, 0 }, RS = { 80, 0, -10 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, 15 }, LE = { 60, 0, 0 } },
			strike = { Root = { 8, 10, 0, 0, -0.2, 0.2 }, Waist = { 10, 12, 0 }, RS = { 95, 0, 0 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -30 }, LE = { 30, 0, 0 } },
			follow = { Root = { 10, 12, 0, 0, -0.2, 0.25 }, Waist = { 12, 14, 0 }, RS = { 110, 0, 0 }, RE = { 5, 0, 0 }, RW = { -10, 0, 0 }, LS = { 55, 0, -35 }, LE = { 30, 0, 0 } },
			shake = true, windupFx = { "sodaShake" }, text = "POP !", hitText = "POP !",
		},
		-- Pluie de soda (en l'air + ↓ + L) : il arrose vers le bas et la giclée fonce sur l'adversaire, le jet le fait remonter
		S_air_down = {
			label = "Pluie de soda", kind = "projectile", startup = 0.15, active = 0, recovery = 0.4,
			damage = 12, kbBase = 25, kbGrowth = 45, kbAngle = -45, selfVelocity = Vector2.new(0, 35),
			projectile = { speed = 80, angle = -70, gravity = 0, lifetime = 0.6, size = 2, color = SODA, visual = "soda" },
			windup = { Root = { -10, 0, 0 }, RS = { 100, 0, 20 }, RE = { 60, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -40 }, LE = { 40, 0, 0 }, RH = { 60, 0, 0 }, RK = { -90, 0, 0 }, LH = { 50, 0, 0 }, LK = { -90, 0, 0 } },
			strike = { Root = { -20, 0, 0 }, Waist = { -20, 0, 0 }, RS = { 40, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 90, 0, -60 }, LE = { 20, 0, 0 }, RH = { 30, 0, 0 }, RK = { -60, 0, 0 }, LH = { 20, 0, 0 }, LK = { -70, 0, 0 } },
			follow = { Root = { -16, 0, 0 }, Waist = { -18, 0, 0 }, RS = { 35, 0, 5 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 95, 0, -65 }, LE = { 20, 0, 0 }, RH = { 25, 0, 0 }, RK = { -55, 0, 0 }, LH = { 15, 0, 0 }, LK = { -65, 0, 0 } },
			shake = true, windupFx = { "sodaShake" }, text = "PSCHHH !", hitText = "SPLOTCH !",
		},

		------------------------------------------------------------------ Supers
		-- Tournée générale (Y) : un plateau de six bouteilles apparaît, il les jette toutes à deux mains et elles foncent sur l'adversaire en rafale (tout à l'envers)
		SUPER = {
			label = "Tournée générale !", kind = "projectile", startup = 0.35, active = 0, recovery = 0.6,
			damage = 4, kbBase = 25, kbGrowth = 40, kbAngle = 40,
			projectile = { speed = 70, gravity = 0, lifetime = 1.0, size = 1.8, color = BOTTLE, visual = "bottle", fan = { count = 6, from = -15, to = 45 } },
			status = { name = "inverted", duration = 3 },
			windup = { Root = { 0, 0, 0, 0, -0.85, 0.15 }, Waist = { -25, 0, 0 }, RS = { 60, 0, -40 }, RE = { 90, 0, 0 }, LS = { 60, 0, 40 }, LE = { 90, 0, 0 } },
			strike = { Root = { 0, 0, 0, 0, 0.3, 0 }, Waist = { 20, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 150, 0, 70 }, RE = { 0, 0, 0 }, LS = { 150, 0, -70 }, LE = { 0, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			follow = { Root = { 4, 0, 0, 0, 0.2, 0 }, Waist = { 24, 0, 0 }, Neck = { 30, 0, 0 }, RS = { 160, 0, 80 }, RE = { 5, 0, 0 }, LS = { 160, 0, -80 }, LE = { 5, 0, 0 } },
			windupFx = { "super", { "symbols", symbols = { "🥤" }, count = 6, radius = 3, color = SODA } }, text = "TOURNÉE GÉNÉRALE !", hitText = "GLOUPS !",
		},
		-- Bouteille-boomerang (→Y) : il fait tournoyer la bouteille au-dessus de sa tête et la lance à plat : elle traverse le couloir
		-- en fauchant tout le monde, puis revient dans sa main (il la rattrape d'un geste de rock star)
		SUPER_side = {
			label = "Bouteille-boomerang !", kind = "projectile", startup = 0.38, active = 0, recovery = 0.65,
			damage = 24, kbBase = 46, kbGrowth = 96, kbAngle = 34,
			projectile = { speed = 85, angle = 0, gravity = 0, lifetime = 0.9, size = 3, color = BOTTLE, visual = "bottle", returns = true, pierce = true },
			status = { name = "inverted", duration = 2 },
			windup = { Root = { 6, -36, 0, 0, -0.3, 0.3 }, Waist = { 10, -40, 0 }, Neck = { 10, 24, 0 }, RS = { 176, 0, 30 }, RE = { 40, 0, 0 }, RW = { 0, 0, 0 }, LS = { 70, 0, -20 }, LE = { 60, 0, 0 } },
			strike = { Root = { -16, 26, 0, 0, -0.34, -0.5 }, Waist = { -18, 30, 0 }, Neck = { -6, -18, 0 }, RS = { 94, 0, -6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 50, 0, -40 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -18, 30, 0, 0, -0.36, -0.55 }, Waist = { -22, 34, 0 }, Neck = { -8, -20, 0 }, RS = { 98, 0, -8 }, RE = { 4, 0, 0 }, RW = { 6, 0, 0 }, LS = { 46, 0, -44 }, LE = { 60, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.52 } },
			spin = { axis = "y", degrees = 360 }, hideProp = "bottle", windupFx = { "super", { "symbols", symbols = { "🍾" }, count = 6, radius = 3, color = SODA } },
			fx = { { "burst", color = SODA, size = 3, at = "hand" }, { "ring", color = SODA, radius = 4, at = "front" }, { "shake", amount = 0.3 } },
			text = "BOOMERANG !", hitText = "FAUCHÉ !",
		},
		-- Geyser de soda douteux (↑Y) : accroupi, il secoue la bouteille entre ses genoux et la pointe au ciel : le bouchon saute,
		-- un geyser de soda roule sur tout le couloir et emporte tout au plafond, lui en vrille
		SUPER_up = {
			label = "Geyser de soda douteux !", startup = 0.35, active = 0.3, recovery = 0.7,
			damage = 24, hitbox = box(16, 12, 8, 5), kbBase = 45, kbGrowth = 95, kbAngle = 86, invuln = 0.3,
			windup = { Root = { -10, 0, 0, 0, -0.95, 0 }, Waist = { -32, 0, 0 }, Neck = { -20, 0, 0 }, RS = { 40, 0, -20 }, RE = { 110, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, 20 }, LE = { 110, 0, 0 } },
			strike = { Root = { 6, 0, 0, 0, 0.5, 0 }, Waist = { 18, 0, 0 }, Neck = { 50, 0, 0 }, RS = { 186, 0, 6 }, RE = { 0, 0, 0 }, RW = { 0, 0, 0 }, LS = { 60, 0, -80 }, LE = { 10, 0, 0 }, RH = { 40, 0, 10 }, RK = { -90, 0, 0 }, LH = { 20, 0, -15 }, LK = { -60, 0, 0 } },
			follow = { Root = { 10, 0, 0, 0, 0.55, 0 }, Waist = { 24, 0, 0 }, Neck = { 56, 0, 0 }, RS = { 188, 0, 10 }, RE = { 0, 0, 0 }, RW = { -10, 0, 0 }, LS = { 70, 0, -88 }, LE = { 10, 0, 0 }, RH = { 60, 0, 20 }, RK = { -110, 0, 0 }, LH = { 10, 0, -25 }, LK = { -40, 0, 0 } },
			hold = 0.2, shake = true, spin = { axis = "y", degrees = 360 }, selfVelocity = Vector2.new(0, 55),
			windupFx = { "super", "sodaShake" }, trail = "bottle", fx = { { "pillar", color = SODA, height = 22, width = 3, at = "front" }, { "beam", color = SODA, length = 16, width = 5, at = "feet" }, { "burst", color = Color3.fromRGB(255, 240, 150), size = 4, at = "above" }, { "particles", tex = "spark", color = SODA, dir = "down", at = "feet", time = 0.5, speed = 14 }, { "ring", color = SODA, radius = 6, at = "feet" } }, text = "SANTÉ !", hitText = "PLOP !",
		},
		-- Karaoké de fin de soirée (↓Y) : micro à la main gauche, bras droit tendu vers le ciel, il chante faux à pleins poumons : les ondes assomment tout l'écran
		SUPER_down = {
			label = "Karaoké de fin de soirée !", startup = 0.4, active = 0.2, recovery = 0.7,
			damage = 20, hitbox = box(70, 50, 0, 10), kbBase = 10, kbGrowth = 10, kbAngle = 60,
			status = { name = "stunned", duration = 2 },
			windup = { Root = { 0, 10, 0, 0, -0.2, 0 }, Neck = { 10, 0, 0 }, RS = { 120, 0, 60 }, RE = { 20, 0, 0 }, LS = { 110, 0, 0 }, LE = { 110, 0, 0 } },
			strike = { Root = { 6, 0, -6, 0, -0.1, 0 }, Waist = { 25, 0, -6 }, Neck = { 35, 0, 0 }, RS = { 170, 0, 40 }, RE = { 0, 0, 0 }, LS = { 100, 0, 0 }, LE = { 100, 0, 0 } },
			follow = { Root = { 8, 0, 8, 0, -0.15, 0 }, Waist = { 28, 0, 8 }, Neck = { 40, 0, 6 }, RS = { 165, 0, 55 }, RE = { 10, 0, 0 }, LS = { 102, 0, 0 }, LE = { 105, 0, 0 } },
			hold = 0.5, prop = "mic", windupFx = { "super" }, fx = { "karaoke" }, text = "♪ LALALAAA ♪", hitText = "AÏE MES OREILLES !",
		},

		------------------------------------------------------------------ Chope (bouton ✋) et projections
		-- Accolade de pote : bras grands ouverts, il referme les bras pour attraper l'adversaire contre sa bedaine
		GRAB = {
			label = "Accolade de pote", kind = "grab", startup = 0.1, active = 0.12, recovery = 0.35,
			damage = 0, hitbox = box(4, 4, 2, 0.5),
			windup = { Root = { 4, 0, 0, 0, -0.1, 0.1 }, Waist = { 10, 0, 0 }, Neck = { 12, 0, 0 }, RS = { 120, 0, 60 }, RE = { 10, 0, 0 }, LS = { 120, 0, -60 }, LE = { 10, 0, 0 } },
			strike = { Root = { -8, 0, 0, 0, -0.2, -0.3 }, Waist = { -14, 0, 0 }, RS = { 82, 0, -22 }, RE = { 80, 0, 0 }, LS = { 82, 0, 22 }, LE = { 80, 0, 0 } },
			follow = { Root = { -6, 0, 0, 0, -0.15, -0.3 }, Waist = { -10, 0, 0 }, RS = { 86, 0, -28 }, RE = { 88, 0, 0 }, LS = { 86, 0, 28 }, LE = { 88, 0, 0 } },
			fx = { "hug" }, text = "VIENS LÀ !", hitText = "T'ES MON POTE !",
		},
		-- ✋ puis → : Glissade de comptoir, il ramène la victime contre lui puis la fait glisser au loin comme un verre sur le zinc
		THROW_fwd = {
			label = "Glissade de comptoir", kind = "throw", startup = 0.32, active = 0.08, recovery = 0.3,
			damage = 9, kbBase = 40, kbGrowth = 55, kbAngle = 8,
			carry = { { 0, 2.4, 0.4 }, { 0.14, 1.6, 0.2 }, { 0.32, 4.5, -1.2 } },
			windup = { Root = { 6, 25, 0, 0, -0.35, 0.3 }, Waist = { 8, 20, 0 }, Neck = { 0, -15, 0 }, RS = { 70, 0, 10 }, RE = { 70, 0, 0 }, LS = { 70, 0, -10 }, LE = { 70, 0, 0 } },
			strike = { Root = { -22, -10, 0, 0, -0.5, -0.5 }, Waist = { -20, -10, 0 }, Neck = { 10, 0, 0 }, RS = { 75, 0, 0 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 75, 0, 0 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { -26, -14, 0, 0, -0.55, -0.6 }, Waist = { -22, -12, 0 }, Neck = { 14, 0, 0 }, RS = { 80, 0, -5 }, RE = { 5, 0, 0 }, RW = { 0, 0, 0 }, LS = { 80, 0, 5 }, LE = { 5, 0, 0 }, FL = { 0, 0, 0, 0, 0, -0.55 } },
			fx = { "dust" }, text = "ET UN SODA, UN !", hitText = "ZIOUUU !",
		},
		-- ✋ puis ← : Suplex de fin de soirée, il s'accroupit, soulève la victime et bascule en arrière par-dessus sa tête
		THROW_back = {
			label = "Suplex de fin de soirée", kind = "throw", back = true, startup = 0.42, active = 0.1, recovery = 0.4,
			damage = 12, kbBase = 35, kbGrowth = 70, kbAngle = 45,
			carry = { { 0, 2.2, 0.3 }, { 0.12, 1.4, -0.3 }, { 0.26, 0.6, 3.2 }, { 0.36, -1.5, 2.2 }, { 0.42, -2.6, -1.8 } },
			windup = { Root = { -8, 0, 0, 0, -0.7, 0.1 }, Waist = { -15, 0, 0 }, RS = { 70, 0, -20 }, RE = { 70, 0, 0 }, LS = { 70, 0, 20 }, LE = { 70, 0, 0 } },
			strike = { Root = { 55, 0, 0, 0, -0.9, 0.4 }, Waist = { 35, 0, 0 }, Neck = { 40, 0, 0 }, RS = { 200, 0, -10 }, RE = { 20, 0, 0 }, LS = { 200, 0, 10 }, LE = { 20, 0, 0 } },
			follow = { Root = { 62, 0, 0, 0, -1.0, 0.5 }, Waist = { 40, 0, 0 }, Neck = { 45, 0, 0 }, RS = { 210, 0, -10 }, RE = { 20, 0, 0 }, LS = { 210, 0, 10 }, LE = { 20, 0, 0 } },
			fx = { "dust" }, text = "SUPLEEEX !", hitText = "BADABOUM !",
		},
		-- ✋ puis ↑ : Bouteille vide au recyclage, il plie les genoux et lance la victime vers le ciel comme une bouteille vide
		THROW_up = {
			label = "Bouteille vide au recyclage", kind = "throw", startup = 0.3, active = 0.08, recovery = 0.35,
			damage = 9, kbBase = 38, kbGrowth = 60, kbAngle = 88,
			carry = { { 0, 2.2, 0.3 }, { 0.14, 1.8, -0.8 }, { 0.3, 0.8, 4.0 } },
			windup = { Root = { -10, 0, 0, 0, -0.8, 0.1 }, Waist = { -18, 0, 0 }, Neck = { -5, 0, 0 }, RS = { 45, 0, -15 }, RE = { 40, 0, 0 }, LS = { 45, 0, 15 }, LE = { 40, 0, 0 } },
			strike = { Root = { 8, 0, 0, 0, 0.3, -0.1 }, Waist = { 15, 0, 0 }, Neck = { 35, 0, 0 }, RS = { 175, 0, 10 }, RE = { 5, 0, 0 }, LS = { 175, 0, -10 }, LE = { 5, 0, 0 }, FR = { 0, 0, 0, 0, 0.25, 0 }, FL = { 0, 0, 0, 0, 0.25, 0 } },
			follow = { Root = { 10, 0, 0, 0, 0.35, -0.1 }, Waist = { 18, 0, 0 }, Neck = { 42, 0, 0 }, RS = { 180, 0, 20 }, RE = { 5, 0, 0 }, LS = { 180, 0, -20 }, LE = { 5, 0, 0 }, FR = { 0, 0, 0, 0, 0.3, 0 }, FL = { 0, 0, 0, 0, 0.3, 0 } },
			text = "AU RECYCLAGE !", hitText = "ZWIIING !",
		},
		-- ✋ puis ↓ : Assis sur le pote, il soulève la victime, la plaque au sol et s'assoit dessus en levant sa bouteille
		THROW_down = {
			label = "Assis sur le pote", kind = "throw", startup = 0.4, active = 0.1, hold = 0.25, recovery = 0.35,
			damage = 10, kbBase = 30, kbGrowth = 25, kbAngle = 75,
			carry = { { 0, 2.2, 0.3 }, { 0.14, 1.8, 1.8 }, { 0.28, 1.4, -2.0 }, { 0.4, 0.8, -2.3 } },
			windup = { Root = { 12, 0, 0, 0, 0.1, 0.1 }, Waist = { 16, 0, 0 }, Neck = { 20, 0, 0 }, RS = { 160, 0, -10 }, RE = { 30, 0, 0 }, LS = { 160, 0, 10 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0.2, 0 }, FL = { 0, 0, 0, 0, 0.2, 0 } },
			strike = { Root = { 8, 0, 0, 0, -1.3, -0.6 }, Waist = { 6, 0, 0 }, Neck = { 10, 0, 0 }, RS = { 60, 0, 30 }, RE = { 30, 0, 0 }, LS = { 50, 0, -40 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0, -0.7 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			follow = { Root = { 4, 0, 0, 0, -1.25, -0.6 }, Waist = { 10, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 165, 0, 15 }, RE = { 15, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -45 }, LE = { 30, 0, 0 }, FR = { 0, 0, 0, 0, 0, -0.7 }, FL = { 0, 0, 0, 0, 0, -0.5 } },
			fx = { "dust" }, text = "ASSIS !", hitText = "OUILLE !",
		},
	},

	-- Séquences relatives à l'adversaire : forward = vers lui, back = à l'opposé
	-- 1er fatal offert, 2e au niveau de maîtrise 5, 3e au niveau 15 (voir shared/Progression.lua)
	fatals = {
		{ id = "derniere_tournee", label = "La Dernière Tournée", sequence = { "forward", "down", "back" } },
		{
			id = "gueule_de_bois", label = "Gueule de bois", sequence = { "down", "down", "up" },
			-- l'adversaire s'endort, Gégé lui dessine une moustache au feutre et s'endort à côté
			scene = {
				{ "text", "Zzz…" },
				{ "fx", { "symbols", symbols = { "Z", "z", "💤" }, count = 6, color = Color3.fromRGB(170, 200, 255) } },
				{ "spin", 90, axis = "z", time = 0.5 },
				{ "spawn", at = "target", offset = Vector3.new(0, 1.2, -1.1), life = 4, pieces = {
					{ "Moustache", "", "block", Vector3.new(1.6, 0.25, 0.2), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), Color3.fromRGB(20, 20, 20) },
				} },
				{ "fxAttacker", { "text", text = "HÉ HÉ…", color = Color3.fromRGB(255, 230, 120) } },
				{ "wait", 0.8 },
				{ "fxAttacker", { "symbols", symbols = { "Z", "z" }, count = 5, color = Color3.fromRGB(170, 200, 255) } },
				{ "text", "RONFLEMENTS EN STÉRÉO" },
				{ "wait", 1.2 },
			},
		},
		{
			id = "le_bouchon", label = "Le Bouchon", sequence = { "back", "forward", "forward" },
			-- Gégé secoue la bouteille, le bouchon part avec l'adversaire dessus : étoile filante
			scene = {
				{ "fxAttacker", { "particles", at = "hand", tex = "smoke", color = SODA, dir = "up", time = 0.8, speed = 10 } },
				{ "fxAttacker", { "text", text = "PSCHHH…", color = SODA } },
				{ "wait", 0.7 },
				{ "spawn", at = "target", offset = Vector3.new(0, -2.6, 0), life = 2.5, name = "Bouchon", pieces = {
					{ "Bouchon", "", "cyl", Vector3.new(1.2, 2.4, 2.4), Vector3.new(0, 0, 0), Vector3.new(0, 0, 90), Color3.fromRGB(150, 100, 60), "Wood" },
				} },
				{ "fx", { "burst", at = "feet", color = SODA, size = 4 } },
				{ "text", "POP !" },
				{ "launch", Vector3.new(40, 90, 0), time = 0.9 },
				{ "fx", { "burst", color = Color3.fromRGB(255, 240, 150), size = 5 } },
				{ "wait", 0.4 },
			},
		},
	},

	-- Mécanique : jauge de Bulles (Petite gorgée, ↓S), voir server/Mechanics.lua
	passive = { kind = "bulles", name = "Bulles", icon = "🫧" },

	-- Recharge d'énergie (maintenir T / bouton ⚡) : Gégé boit au goulot à grandes gorgées en se tapotant
	-- la bedaine, puis lâche un petit rot. keys = { temps, pose partielle } joués en boucle sur loop secondes ;
	-- beats = effets lancés à ce moment de chaque boucle (voir client/Fx.lua).
	charge = {
		label = "Recharge au soda",
		loop = 1.6,
		lockWrist = true, -- le poignet tient la bouteille au goulot, il ne pend pas
		color = Color3.fromRGB(120, 220, 255),
		keys = {
			{ 0.0, { Root = { 4, 0, 0, 0, -0.15, 0 }, Waist = { 14, 6, 0 }, Neck = { 32, -10, 0 }, RS = { 148, 0, -22 }, RE = { 110, 0, 0 }, RW = { -122, 0, 0 }, LS = { 25, 0, -2 }, LE = { 100, 0, 0 }, LW = { -30, 0, 0 } } },
			{ 0.25, { Root = { 5, 0, 0, 0, -0.17, 0 }, Waist = { 16, 6, 0 }, Neck = { 36, -10, 0 }, RS = { 152, 0, -22 }, RE = { 108, 0, 0 }, RW = { -125, 0, 0 }, LS = { 30, 0, -2 }, LE = { 82, 0, 0 }, LW = { -10, 0, 0 } } },
			{ 0.5, { Root = { 4, 0, 0, 0, -0.15, 0 }, Waist = { 14, 6, 0 }, Neck = { 32, -10, 0 }, RS = { 148, 0, -22 }, RE = { 110, 0, 0 }, RW = { -122, 0, 0 }, LS = { 25, 0, -2 }, LE = { 100, 0, 0 }, LW = { -30, 0, 0 } } },
			{ 0.75, { Root = { 5, 0, 0, 0, -0.17, 0 }, Waist = { 16, 6, 0 }, Neck = { 36, -10, 0 }, RS = { 152, 0, -22 }, RE = { 108, 0, 0 }, RW = { -125, 0, 0 }, LS = { 30, 0, -2 }, LE = { 82, 0, 0 }, LW = { -10, 0, 0 } } },
			{ 1.0, { Root = { 4, 0, 0, 0, -0.15, 0 }, Waist = { 14, 6, 0 }, Neck = { 32, -10, 0 }, RS = { 148, 0, -22 }, RE = { 110, 0, 0 }, RW = { -122, 0, 0 }, LS = { 25, 0, -2 }, LE = { 100, 0, 0 }, LW = { -30, 0, 0 } } },
			{ 1.2, { Root = { -8, 0, 0, 0, -0.4, 0.05 }, Waist = { -14, 6, 0 }, Neck = { -12, -10, 0 }, RS = { 105, 0, -18 }, RE = { 120, 0, 0 }, RW = { -95, 0, 0 }, LS = { 40, 0, -10 }, LE = { 95, 0, 0 }, LW = { -20, 0, 0 } } },
			{ 1.32, { Root = { 6, 0, 0, 0, -0.25, 0.1 }, Waist = { 10, 6, 0 }, Neck = { 20, -10, 0 }, RS = { 110, 0, -18 }, RE = { 120, 0, 0 }, RW = { -95, 0, 0 }, LS = { 40, 0, -10 }, LE = { 95, 0, 0 }, LW = { -20, 0, 0 } } },
			{ 1.6, { Root = { 4, 0, 0, 0, -0.15, 0 }, Waist = { 14, 6, 0 }, Neck = { 32, -10, 0 }, RS = { 148, 0, -22 }, RE = { 110, 0, 0 }, RW = { -122, 0, 0 }, LS = { 25, 0, -2 }, LE = { 100, 0, 0 }, LW = { -30, 0, 0 } } },
		},
		beats = {
			{ 0.05, "chug" },
			{ 1.22, "burp" },
		},
	},
}

-- Pendant qu'il tient quelqu'un (après GRAB, avant la projection) : bras devant à hauteur de poitrine qui
-- serrent le « pote », penché en arrière pour le porter, un peu de travers comme tout bon pochtron.
data.grabHold = {
	Root = { 6, 4, 4, 0, -0.2, 0.1 },
	Waist = { 8, 6, -3 },
	Neck = { 10, -8, 6 },
	RS = { 84, 0, -22 },
	RE = { 35, 0, 0 },
	RW = { 0, 0, 0 },
	LS = { 88, 0, 18 },
	LE = { 42, 0, 0 },
}

-- Retour après une chute (comme la plateforme de Smash) : Gégé descend du ciel assis sur une caisse de soda
-- accrochée à un parachute, lève sa bouteille (« À LA VÔTRE ! »), boit un coup et se met en garde.
-- platform = plateforme construite par server/Match.lua ; duration = durée de l'entrée (il ne bouge pas avant) ;
-- keys / beats : même principe que charge, joués une seule fois.
data.respawn = {
	platform = "sodaCrate",
	duration = 1.8,
	keys = {
		{ 0.0, { Root = { -4, 0, 0, 0, -1.0, 0.15 }, Waist = { 8, 0, 0 }, Neck = { 6, 0, 0 }, RS = { 40, 0, 12 }, RE = { 70, 0, 0 }, LS = { 25, 0, -20 }, LE = { 55, 0, 0 } } },
		{ 0.3, { Root = { -2, 6, 3, 0, -1.0, 0.15 }, Waist = { 10, 4, 0 }, Neck = { 10, 8, 0 }, RS = { 45, 0, 18 }, RE = { 70, 0, 0 }, LS = { 30, 0, -25 }, LE = { 55, 0, 0 } } },
		{ 0.6, { Root = { -8, 0, 0, 0, -1.05, 0.1 }, Waist = { 4, 0, 0 }, Neck = { 0, 0, 0 }, RS = { 35, 0, 12 }, RE = { 70, 0, 0 }, LS = { 25, 0, -20 }, LE = { 55, 0, 0 } } },
		{ 0.85, { Root = { 2, 0, 0, 0, -0.35, 0 }, Waist = { 10, 0, 0 }, Neck = { 25, 0, 0 }, RS = { 170, 0, 15 }, RE = { 15, 0, 0 }, RW = { 0, 0, 0 }, LS = { 40, 0, -45 }, LE = { 30, 0, 0 } } },
		{ 1.05, { Root = { 2, 0, 0, 0, -0.3, 0 }, Waist = { 12, 0, 0 }, Neck = { 28, 0, 0 }, RS = { 172, 0, 18 }, RE = { 20, 0, 0 }, RW = { 0, 0, 0 }, LS = { 45, 0, -50 }, LE = { 30, 0, 0 } } },
		{ 1.3, { Root = { 4, 0, 0, 0, -0.15, 0 }, Waist = { 14, 6, 0 }, Neck = { 32, -10, 0 }, RS = { 148, 0, -22 }, RE = { 110, 0, 0 }, RW = { -122, 0, 0 }, LS = { 25, 0, -2 }, LE = { 100, 0, 0 } } },
		{ 1.55, { Waist = { -2, 6, 0 }, Neck = { 0, -10, 0 }, RS = { 30, 0, 14 }, RE = { 60, 0, 0 }, LS = { 75, 0, 30 }, LE = { 120, 0, 0 } } },
		{ 1.8, {} },
	},
	beats = {
		{ 0.6, "thud" },
		{ 0.85, "toast" },
		{ 1.3, "chug" },
	},
}

-- Arbre d'enchaînements (façon Tekken). Lecture : après le coup de gauche, appuyer sur le bouton
-- (avec la direction s'il y en a une) lance le coup de droite. Presque toutes les chaînes peuvent finir sur L
-- (les coups sans suite, comme J J J K ou les smashs aériens ↓, sont des finitions à vraie éjection).

-- en l'air (après un saut) : J et K s'alternent, une flèche choisit la version directionnelle,
-- L finit, ↓ L arrose vers le bas, ↑ L reste la remontée
local function airAfterP()
	return { K = "K_air", fwd_K = "K_air_side", up_K = "K_air_up", down_K = "K_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end
local function airAfterK()
	return { P = "P_air", fwd_P = "P_air_side", up_P = "P_air_up", down_P = "P_air_down", down_S = "S_air_down", up_S = "S_up", S = "S_air" }
end

local LINKS = {
	-- au sol, sans direction : J…
	P_neutral = { P = "P_combo2", K = "PK_combo", fwd_P = "P_belly", up_P = "P_down2", down_K = "P_downK", back_K = "KPK_combo", S = "S_finish_spray" },
	P_combo2 = { P = "P_combo3", K = "PPK_combo", back_P = "P_retreat", up_K = "P_upK", S = "S_finish_spray" }, -- J J
	P_combo3 = { K = "PPPK_combo", S = "S_finish_spin" }, -- J J J (J J J K : 4e coup, finition sans suite)
	PPK_combo = { S = "S_finish_spray" }, -- J J K
	PK_combo = { P = "PKP_combo", fwd_P = "P_belly", S = "S_finish_spin" }, -- J K
	PKP_combo = { K = "K_combo3", S = "S_finish_cap" }, -- J K J
	P_belly = { P = "P_combo3", K = "K_side2", S = "S_finish_spray" }, -- J →J (bedaine)
	P_retreat = { fwd_P = "P_belly", P = "P_side2", S = "S_finish_cap" }, -- J J ←J (repli)
	-- au sol, sans direction : K…
	K_neutral = { K = "K_combo2", P = "KP_combo", fwd_P = "K_sideP", up_K = "K_upK", S = "S_finish_spin" },
	K_combo2 = { K = "K_combo3", P = "KKP_combo", fwd_K = "K_side2", down_K = "PPK_combo", S = "S_finish_spin" }, -- K K
	K_combo3 = { K = "K_air_side", S = "S_air" }, -- K K K (il décolle : K K K K = savate volante)
	KKP_combo = { S = "S_finish_cap" }, -- K K J
	KP_combo = { K = "KPK_combo", P = "P_combo3", S = "S_finish_spray" }, -- K J
	KPK_combo = { S = "S_finish_spin" }, -- K J K
	-- avec une flèche : chaque direction ouvre sa propre chaîne
	P_side = { P = "P_side2", K = "P_sideK", S = "S_finish_spin" }, -- → J
	P_side2 = { K = "P_sideK", fwd_P = "P_belly", S = "S_finish_spray" }, -- → J J
	P_sideK = { P = "K_sideP", S = "S_finish_cap" }, -- → J K
	P_down = { P = "P_down2", K = "P_downK", S = "S_finish_spray" }, -- ↓ J
	P_downK = { P = "P_down2", K = "K_downP", S = "S_finish_cap" }, -- ↓ J K
	P_down2 = { up_K = "K_upK", S = "S_finish_cap" }, -- ↓ J J
	P_up = { P = "P_up2", K = "P_upK", S = "S_finish_spray" }, -- ↑ J
	P_up2 = { K = "K_air_up", P = "P_air_up", S = "S_air" }, -- ↑ J J (le hoquet le fait décoller)
	P_upK = { S = "S_finish_cap" }, -- ↑ J K
	K_side = { P = "K_sideP", K = "K_side2", up_K = "K_combo3", S = "S_finish_spin" }, -- → K
	K_side2 = { S = "S_finish_spin" }, -- → K K
	K_sideP = { S = "S_finish_spray" }, -- → K J
	K_down = { P = "K_downP", K = "K_downK", up_P = "P_down2", S = "S_finish_spray" }, -- ↓ K
	K_downK = { S = "S_finish_spin" }, -- ↓ K K
	K_downP = { K = "K_upK", S = "S_finish_cap" }, -- ↓ K J
	K_up = { P = "K_upP", K = "K_upK", S = "S_finish_cap" }, -- ↑ K
	K_upK = { S = "S_finish_cap" }, -- ↑ K K
	K_upP = { S = "S_finish_spin" }, -- ↑ K J
	P_dash = { P = "P_dash2", K = "P_sideK", S = "S_finish_spray" }, -- dash J
	P_dash2 = { K = "P_sideK", S = "S_finish_spin" }, -- dash J J
	K_dash = { P = "K_sideP", S = "S_finish_cap" }, -- dash K
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
