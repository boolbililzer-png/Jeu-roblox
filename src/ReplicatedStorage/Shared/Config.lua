-- Réglages globaux de Bagarre Bizarre (façon Brawlhalla / Smash Bros).
-- Toutes les vitesses sont en studs/s, les durées en secondes.

local Config = {
	-- Partie
	Stocks = 3, -- vies par joueur
	MatchTime = 300, -- 5 min max, puis départage (vies puis % le plus bas)
	BotsToFill = 1, -- bots ajoutés si pas assez de joueurs (modifiable dans le menu)
	MaxFighters = 4,
	TrapsEnabled = true, -- « Pièges ON/OFF » (OFF en classé)
	CountdownTime = 3,
	RespawnDelay = 1.6,
	RespawnInvuln = 2.5, -- protection du « Retour 🪂 »
	EndScreenTime = 8,

	-- Monde
	Gravity = 110,
	WalkSpeed = 24,
	AirSpeed = 22,
	JumpVelocity = 58,
	AirJumpVelocity = 52,
	AirJumps = 2, -- sauts aériens (Brawlhalla : 2 + la remontée)
	FastFallSpeed = 75,
	MaxFallSpeed = 62,
	WallSlideSpeed = 8,
	WallJumpPush = 34,
	GlideFallSpeed = 9,

	-- Esquive (invulnérabilité courte + temps de recharge)
	DodgeInvuln = 0.32,
	DodgeSpeed = 46,
	DodgeDuration = 0.22,
	DodgeCooldownGround = 1.0,
	DodgeCooldownAir = 1.4,

	-- Éjection : Force = Base + % * Scaling (puis / poids)  -> vitesse en studs/s
	KnockbackToVelocity = 1.0,
	HitstunPerForce = 0.0085, -- hitstun = Force * 0.0085 s
	HitstunMinLight = 0.42, -- assez long pour enchaîner 2 à 4 coups légers
	HitstunMin = 0.18,
	HitstunMax = 1.4,
	KnockbackDrag = 1.1, -- ralentissement horizontal pendant l'éjection
	ChargeMaxTime = 1.0, -- maintenir S : multiplicateur 1.0 -> 1.5
	ChargeMaxMult = 1.5,
	CriticalPercent = 150, -- la jauge passe au rouge
	MaxPercent = 999,

	-- Statuts loufoques : 3 s max, pas de cumul, 5 s d'immunité au même statut
	StatusMax = 3,
	StatusImmunity = 5,

	-- Caisse Bizarre (arme)
	CrateFirstDelay = 5,
	CrateInterval = { 7, 12 },
	CrateMax = 2,
	CrateLife = 20,
	PickupRange = 6,
	WeaponThrow = { dmg = 8, bkb = 22, kbs = 0.3, speed = 85 },

	-- Saisie ✋ (mains nues, sans caisse à portée)
	Grab = { range = 4.5, hold = 0.45, dmg = 7, bkb = 30, kbs = 0.35, angle = 45 },

	-- Pièges d'arène
	TrapInterval = { 18, 26 },
	TrapWarning = 2,

	-- Débogage : affiche les hitbox en rouge
	DebugHitboxes = false,

	-- Mobile
	InputBuffer = 0.15, -- tampon d'entrée de 150 ms
}

return Config
