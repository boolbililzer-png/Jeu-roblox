-- Réglages globaux du prototype. Tout l'équilibrage de base se règle ici.
local Config = {}

-- Règles de match, comme dans Smash Bros
Config.MATCH_MODE = "time" -- "time" : aux points (temps limité, vies illimitées) ; "stock" : aux vies, le dernier debout gagne
Config.MATCH_TIME = 180 -- durée d'un match aux points (secondes)
Config.TEAMS = false -- true : équipes Rouge et Bleu, les points de l'équipe s'additionnent
Config.TEAM_ATTACK = false -- coups entre coéquipiers
Config.KO_CREDIT_TIME = 8 -- éjecté moins de 8 s après un coup : +1 pour celui qui a frappé (sinon chute seule)
Config.SUDDEN_DEATH_DAMAGE = 300 -- égalité à la fin du temps : mort subite, tout le monde à 300 %
Config.STOCKS = 3 -- vies par joueur (mode "stock" et mort subite : 1)
Config.RED_DAMAGE = 150 -- % à partir duquel la jauge passe au rouge (coup fatal possible sur la dernière vie)
Config.MAX_SUPER = 100
Config.DEFAULT_CHARACTER = "Gege"

-- Déplacements
Config.WALK_SPEED = 24
Config.JUMP_POWER = 62
Config.AIR_JUMPS = 2 -- comme Brawlhalla : 1 saut au sol + 2 sauts en l'air, puis la remontée (↑L)
Config.AIR_JUMP_VELOCITY = 62
Config.DASH_SPEED = 62 -- double tap gauche ou droite : ruée rapide…
Config.DASH_TIME = 0.22 -- …pendant ce temps…
Config.RUN_SPEED = 34 -- …puis on court tant que la direction reste tenue
Config.ATTACK_MOVE_SPEED = 0.55 -- on peut marcher pendant un coup au sol, à 55 % de la vitesse
Config.DROP_HOLD = 0.2 -- ↓ tenu ce temps sur une plateforme fine : on passe au travers

-- Esquive
Config.DODGE_SPEED = 70
Config.DODGE_DURATION = 0.3
Config.DODGE_INVULN = 0.35
Config.DODGE_COOLDOWN = 0.9
-- Esquive de poursuite (Brawlhalla « chase dodge ») : après avoir touché quelqu'un, l'esquive revient très vite
-- pour le suivre et continuer le combo
Config.CHASE_DODGE_COOLDOWN = 0.25
Config.CHASE_DODGE_WINDOW = 0.8 -- l'esquive de poursuite est possible ce temps après la touche
-- Gravity cancel : esquive en l'air puis P / K = coup « au sol » en plein vol (pendant ce temps après l'esquive)
Config.GRAVITY_CANCEL_WINDOW = 0.35
-- Chute rapide : ↓ maintenu en l'air (sans attaquer) = on tombe beaucoup plus vite
Config.FAST_FALL_SPEED = 95

-- Fenêtres d'entrée (secondes)
Config.DOUBLE_TAP_WINDOW = 0.3
Config.DASH_S_WINDOW = 0.4 -- dash puis S = spécial de dash
Config.DODGE_S_WINDOW = 0.4 -- esquive puis S = spécial d'esquive
Config.HOLD_TIME = 0.35 -- S maintenu au-delà = spécial chargé
Config.FATAL_INPUT_GAP = 1 -- délai max entre deux flèches du coup fatal
Config.FATAL_RANGE = 20
Config.GRAB_RANGE = 5
Config.GRAB_HOLD = 1.2 -- temps max pour choisir la direction de la projection (sinon projection vers l'avant)

-- Enchaînements (voir links dans Characters/Gege.lua)
Config.COMBO_GRACE = 0.45 -- on peut encore enchaîner ce temps après le retour en garde du coup
Config.COMBO_BUFFER = 0.4 -- un appui un peu trop tôt est gardé en mémoire et part dès que la fenêtre s'ouvre

-- Frappes chargées (maintenir J ou K au sol), comme les smashs : plus on charge, plus ça tape fort
Config.SMASH_HOLD = 0.18 -- maintenu au-delà = la charge commence (en dessous : coup normal au relâchement)
Config.SMASH_MAX_TIME = 1 -- charge maximale (le coup part tout seul)
Config.SMASH_DAMAGE_BONUS = 0.4 -- +40 % de dégâts à pleine charge
Config.SMASH_KB_BONUS = 0.5 -- +50 % d'éjection à pleine charge
Config.SMASH_MOVES = { P_neutral = true, P_side = true, P_down = true, P_up = true, K_neutral = true, K_side = true, K_down = true, K_up = true }

-- Énergie des spéciaux (L / S) : rechargée en maintenant O (bouton ⚡ sur téléphone)
Config.ENERGY_MAX = 100
Config.ENERGY_START = 100 -- au début du match et à chaque nouvelle vie
Config.ENERGY_S_COST = 25 -- coût par défaut d'un spécial (chaque coup peut préciser energyCost)
Config.ENERGY_CHARGE_RATE = 45 -- énergie gagnée par seconde de recharge
-- Portée des spéciaux (L / S) : zones de frappe plus larges et projectiles qui vont plus loin (appliqué au chargement
-- des persos dans CharacterList, pour tous les spéciaux, avec ou sans Caisse Bizarre)
Config.S_RANGE = 1.8 -- largeur et allonge des zones de frappe au corps à corps (minimum, voir S_LANE)
-- Signatures « sûres de toucher » : un L / →L / ↓L au corps à corps frappe tout le couloir devant le perso
-- (S_LANE studs de long, S_LANE_HEIGHT de haut : tout adversaire à la même hauteur de plateforme est touché).
-- Les Supers (Y) ont un couloir SUPER_LANE_SCALE fois plus grand. Les projectiles des L et des Y visent
-- l'adversaire le plus proche à S_AIM_RANGE studs et foncent droit sur lui (S_AIM_HOMING = suivi en vol).
Config.S_LANE = 16
Config.S_LANE_HEIGHT = 6
Config.SUPER_LANE_SCALE = 1.3
Config.S_AIM_RANGE = 48
Config.S_AIM_HOMING = 0.9
-- ↑L : on décolle en diagonale vers l'avant, comme la remontée de Brawlhalla (élan minimal en X et en Y),
-- et on frappe tout ce qui est sur le passage
Config.S_UP_LAUNCH = Vector2.new(42, 80)
-- Persos qui savent voler (champ flying = true de la fiche) : leur ↑L est un coup très puissant (× S_UP_FLYER_DAMAGE)
Config.S_UP_FLYER_DAMAGE = 1.6
-- Plus de jauge : les L et les Y se font à l'infini (l'énergie, la jauge Super et les compteurs des persos ne
-- bloquent plus rien et ne sont plus affichés)
Config.INFINITE_SPECIALS = true
Config.S_DAMAGE = 1.35 -- les signatures (L) frappent plus fort que les autres coups…
Config.S_DAMAGE_OVER_LIGHT = 3 -- …et toujours au moins 3 de plus que la plus forte attaque P / K du perso
Config.LIGHT_RANGE = 1.15 -- attaques P / K un peu plus larges : les combos touchent plus souvent
-- Sans Caisse Bizarre, chaque perso garde ses propres coups (tous différents) mais sans son arme : dégâts réduits
Config.UNARMED_DAMAGE = 0.8
Config.S_PROJECTILE_RANGE = 1.4 -- durée de vol des projectiles (donc leur distance)

-- Éjection façon Smash : plus la jauge de % est haute, plus on vole loin
-- vitesse = (kbBase * KB_BASE_SCALE + kbGrowth * KB_GROWTH_SCALE * % / 100 * (1 + % / KB_RAMP)) * KB_SCALE
Config.KB_SCALE = 1 -- réglage global de la distance d'éjection
Config.KB_BASE_SCALE = 0.5 -- part fixe (à 0 %, on recule à peine)
Config.KB_GROWTH_SCALE = 1 -- part qui grandit avec les %
Config.KB_RAMP = 250 -- au-delà de 100 %, l'éjection s'emballe
Config.COMBO_KB_SCALE = 0.35 -- les coups qui ont une suite (combo) repoussent beaucoup moins…
Config.COMBO_HITSTUN = 0.55 -- …et sonnent assez longtemps pour que la suite touche (vrais combos à la Brawlhalla)
Config.COMBO_POP = 0.6 -- un coup de combo soulève un peu l'adversaire (il reste à portée, en l'air, pour la suite)
Config.KB_DRAG = 1.8 -- freinage de l'éjection pendant qu'on est sonné (par seconde)
Config.HITSTUN_PER_KB = 0.004
Config.HITSTUN_MIN = 0.12
Config.HITSTUN_MAX = 1.2

-- Objets à ramasser (voir shared/Items.lua), comme les armes de Brawlhalla
Config.ITEMS = true
Config.ITEM_FIRST_DELAY = 5 -- premier objet après le début du match
Config.ITEM_INTERVAL_MIN = 6 -- puis un objet toutes les 6 à 11 s…
Config.ITEM_INTERVAL_MAX = 11
Config.ITEMS_MAX = 3 -- …avec au plus 3 objets au sol en même temps
Config.ITEM_LIFETIME = 25 -- un objet que personne ne ramasse disparaît
Config.PICKUP_RANGE = 5
Config.BOMB_FUSE = 20 -- la bombe ramassée explose en main au bout de 20 s
Config.BOMB_RADIUS = 9 -- explosion d'une bombe qui rate sa cible
Config.CROUSTY_TIME = 3 -- gavé de croustillant : immobile, aucune éjection, mais les dégâts s'accumulent
Config.CROUSTY_FRAGILE_TIME = 2 -- ensuite, le premier coup reçu dans ce délai éjecte beaucoup plus loin
Config.CROUSTY_FRAGILE_KB = 1.7
Config.BANANA_TIME = 12 -- une peau de banane reste au sol ce temps

-- Statuts loufoques : 3 s max, non cumulables, puis immunité
Config.STATUS_MAX_DURATION = 3
Config.STATUS_IMMUNITY = 5

-- Arène et zones d'éjection
Config.BLAST = { left = -130, right = 130, top = 110, bottom = -50 }
Config.ARENA_HAZARDS = true -- geysers de soda sur les rebords (à couper en classé)
Config.MOVING_PLATFORM = { y = 41, amplitude = 30, speed = 0.45, width = 14 } -- plateau qui va et vient tout en haut
-- Points d'apparition au début du match (sur le sol principal)
Config.SPAWN_POINTS = {
	Vector3.new(-30, 6, 0),
	Vector3.new(30, 6, 0),
	Vector3.new(-10, 6, 0),
	Vector3.new(10, 6, 0),
}
-- Où les objets tombent (au-dessus des sols et plateformes de server/Arena.lua)
Config.ITEM_POINTS = {
	Vector3.new(-36, 3, 0), Vector3.new(-14, 3, 0), Vector3.new(14, 3, 0), Vector3.new(36, 3, 0),
	Vector3.new(-28, 16.5, 0), Vector3.new(28, 16.5, 0), Vector3.new(0, 30.5, 0),
	Vector3.new(-56, 27.5, 0), Vector3.new(56, 27.5, 0), Vector3.new(-63, -5.5, 0), Vector3.new(63, -5.5, 0),
}
-- Réapparition : le perso arrive sur sa plateforme (au-dessus de l'arène) avec son animation d'entrée,
-- invincible tant qu'il y reste, puis encore RESPAWN_INVULN secondes après l'avoir quittée
-- dessus des plateformes de retour : on revient sur celle qui est la plus loin des adversaires
Config.RESPAWN_POINTS = {
	Vector3.new(-32, 54, 0),
	Vector3.new(0, 56, 0),
	Vector3.new(32, 54, 0),
}
Config.RESPAWN_DELAY = 1 -- temps avant de revenir
Config.RESPAWN_DROP = 18 -- la plateforme descend de cette hauteur
Config.RESPAWN_DESCENT = 0.6
Config.RESPAWN_PLATFORM_TIME = 4 -- au-delà, la plateforme disparaît d'elle-même
Config.RESPAWN_INVULN = 1.5
Config.SPECTATOR_POINT = Vector3.new(0, 90, -20) -- où attendent les joueurs éliminés

-- Tests
Config.DEBUG_HITBOXES = false -- true = affiche les zones de frappe en rouge
Config.SHOW_MOVE_NAMES = false -- true = affiche le nom du coup au-dessus de la tête
Config.ANIM_DEBUG = true -- affiche quelques secondes l'état des articulations trouvées (à couper une fois que tout bouge)
Config.SPAWN_DUMMY = true -- mannequin d'entraînement
Config.FORCE_TOUCH_UI = false -- affiche les boutons tactiles même sur PC

-- Visuel
Config.SOUNDS = true
Config.TURN_TO_CAMERA = 0.36 -- les persos se tournent un peu vers la caméra (0 = profil strict) pour qu'on voie bras et bouteille
Config.CAMERA_SHAKE = true
Config.HITSTOP = true -- micro-arrêt sur image à l'impact

return Config
