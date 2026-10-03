# Écrire la fiche d'un personnage

Chaque perso tient dans un seul module : `src/ReplicatedStorage/Shared/Characters/<Id>.lua`, au même format
que `Gege.lua` (le modèle à suivre). Il est chargé par `CharacterList.lua` dans l'ordre de `Roster.lua`.
Rien à importer dans Roblox : costume, accessoires, animations et effets sont décrits en données.

Vérifier une fiche : `python3 tools/check_characters.py <Id>` (le binaire `luau` doit être dans le PATH ou
dans la variable `LUAU`). Le script contrôle la fiche et joue toutes ses animations hors Roblox.

## Caisse Bizarre : mains nues, puis une des 3 armes du perso

- **Sans caisse** : P et K sont les coups à mains nues communs à tous (`BareMoves.lua`), mais les **L restent
  ceux du perso** (ses `S_…` non préfixés : portée supérieure aux J / K), ainsi que ses 4 Supers (Y), sa saisie,
  ses fatals et sa mécanique. Les dégâts sont réduits (`Config.UNARMED_DAMAGE`).
- **L maintenu** (au sol : L, →L, ↓L) : le même spécial part au relâchement avec une portée allongée, jusqu'à
  +80 % (`Config.S_HOLD_RANGE`) : couloir plus long, projectile qui vole plus loin, élan plus grand.
- **La Caisse Bizarre** 📦 tombe dans l'arène. Celui qui l'ouvre (✋) sort **une de ses 3 armes, au hasard**
  (`data.weapons`). Chaque arme a ses coups J / K / L / Y et sa **capacité** passive. Ouvrir une autre caisse
  change d'arme. L'arme est perdue à l'éjection (ou jetée avec ✋).
- Les 4 Supers (Y, →Y, ↑Y, ↓Y) existent dans chaque jeu : ceux du perso (`SUPER…` non préfixés) sans arme et
  avec l'arme n° 1, ceux de l'arme avec les armes n° 2 et 3.

## Les 3 armes (`weapons`)

```lua
weapons = {
	-- n° 1 : l'arme emblématique. Ses coups sont ceux de data.moves (non préfixés), son objet est le
	-- `visible = true` de look.props. Pas de moves ici.
	{ id = "bouteille", name = "Bouteille de soda douteux", icon = "🍾",
	  ability = { speed = 1.1, text = "Gégé trottine 10 % plus vite" } },
	-- n° 2 et 3 : un objet en main (même format qu'un prop de look.props, construit caché et montré quand
	-- l'arme est sortie), une capacité et SES coups. Les clés sont les mêmes que dans moves ; ce que l'arme
	-- n'écrit pas (air avec flèche, combos, S_dash, S_dodge…) retombe sur les coups du perso.
	{ id = "canettes", name = "Pack de canettes", icon = "🥫",
	  prop = { name = "PropPack", hand = "Right", pieces = { { "Canette", "", "cyl", Vector3.new(0.4, 0.8, 0.4), Vector3.new(0, -0.6, 0), Vector3.new(0, 0, 0), Color3.fromRGB(200, 40, 40), "Metal" } } },
	  ability = { reach = 1.2, text = "Portée +20 %" },
	  moves = { P_neutral = { … }, …, SUPER_down = { … } },
	  links = { P_neutral = { P = "P_combo2" } },   -- facultatif : suites propres à l'arme
	},
	{ … },
}
```

Coups obligatoires d'une arme n° 2 ou 3 : `P_neutral, P_side, P_down, P_up, P_air, P_dash, K_neutral, K_side,
K_down, K_up, K_air, K_dash, S_neutral, S_side, S_down, S_up, S_air, SUPER, SUPER_side, SUPER_up, SUPER_down`.
Ils suivent les mêmes règles que les autres (couloir, visée, ↑L en diagonale, Y 1,3 fois plus large) et doivent
être **différents** d'une arme à l'autre : chaque arme donne un style de jeu (lourde et lente, à projectiles,
rapide et courte…). `trail = "prop"` fait traîner l'objet de l'arme.

`ability` (une ou plusieurs, plus `text`, la phrase du menu) :

| clé | effet |
|---|---|
| `speed = 1.15` | vitesse de déplacement × 1,15 |
| `jumps = 1` | un saut en l'air de plus |
| `damage = 1.2` | dégâts × 1,2 |
| `knockback = 1.25` | éjection × 1,25 |
| `reach = 1.2` | portée de tous les coups × 1,2 (zones, projectiles, élans) |
| `superCooldown = 0.5` | recharge des Supers × 0,5 |
| `heal = 0.3` | 30 % des dégâts infligés sont retirés de sa propre jauge |
| `armor = true` | les spéciaux (L) encaissent sans être éjectés |
| `status = { name = "slowed", duration = 2 }` | les spéciaux (L) infligent ce statut |

## Sources

- **Grille des Combos & Signatures (PDF)** : l'arme de chaque perso, ses P (neutre, côté, bas, aériens) et
  ses S (neutre, côté, bas, remontée, plongeon). C'est le moveset de la caisse, prioritaire.
- **Roster** : look, style, mécanique, K, les S restants, Supers, saisie et projections, recharge,
  retour et fatals.
- **Gameplay** : ←P et ←K deviennent ↑P et ↑K ; ←S devient ESQUIVE puis S (`S_dodge`) ; la chope passe
  sur ✋ (`GRAB`).

## Correspondance des entrées

| Entrée | Clé | Source |
|---|---|---|
| P · →P · ↓P · ↑P (ex-←P) | `P_neutral` `P_side` `P_down` `P_up` | PDF, sinon roster |
| P en l'air (neutre / → / ↑ / ↓) | `P_air` `P_air_side` `P_air_up` `P_air_down` | PDF (Aérien) |
| K · →K · ↓K · ↑K (ex-←K) | `K_neutral` `K_side` `K_down` `K_up` | roster |
| K en l'air | `K_air` (+ `K_air_side` `K_air_up` `K_air_down`) | roster (saut K) |
| dash puis P / K (ou pendant la ruée) | `P_dash` `K_dash` | à inventer, dans l'esprit du perso |
| S · →S · ↓S | `S_neutral` `S_side` `S_down` | PDF Signatures |
| ↑S (remontée, gratuite : `energyCost = 0`) | `S_up` | PDF Remontée |
| ↓S en l'air (plongeon) | `S_air_down` | PDF Plongeon |
| ESQUIVE puis S (ex-←S) | `S_dodge` | roster ←S |
| S maintenu | (le même L, portée allongée : `Config.S_HOLD_RANGE`) | moteur |
| →→S | `S_dash` | roster |
| S en l'air | `S_air` | roster (saut) S |
| →⭐ (ou ⭐ seul) · ↑⭐ · ↓⭐ (`superCost = 100`) | `SUPER` `SUPER_up` `SUPER_down` | roster (↑⭐ : anti-air à inventer) |
| (plus utilisés : pas de saisie, ✋ sert seulement aux objets) | `GRAB` `THROW_*` | gardés dans les fiches |
| suites d'enchaînement | `P_combo2` `P_combo3` `K_combo2` `K_combo3` `PK_combo` `KP_combo`… | à inventer |

Quand le PDF prend une case dont le roster parlait aussi (par ex. ↓S), le coup du roster peut devenir une
finition d'enchaînement (`S_finish_…`, voir les `links` de Gégé) ou une variante.

Visez une **quarantaine de coups** : les 27 obligatoires, les 6 aériens directionnels, `S_air_down` et des
suites d'enchaînement (avec `links`).

## Squelette de la fiche

```lua
-- <Nom> : <une ligne de présentation>. Arme sortie de la Caisse Bizarre : <arme>.
local function box(width, height, forward, up)
	return { size = Vector3.new(width, height, 6), offset = Vector2.new(forward, up) }
end

local data = {
	id = "Mamie", name = "Mamie Tricot", costume = "Mamie", style = "granny",
	look = { … },        -- costume (voir plus bas)
	weapons = { … },     -- les 3 armes de la Caisse Bizarre (voir plus haut)
	moves = { … },       -- coups (arme n° 1 ; les L et les Y servent aussi sans arme)
	fatals = { … },      -- 3 coups fatals avec leur scène
	passive = { kind = "traps", name = "Pelotes", icon = "🧶", max = 3 },
	charge = { … },      -- recharge ⚡ (boucle de poses)
	fidgets = { … },     -- 2 ou 3 manies au repos
}
data.grabHold = { … }    -- pose pendant qu'il tient quelqu'un
data.respawn = { … }     -- retour 🪂 (plateforme + animation d'entrée)
-- liens d'enchaînement
local LINKS = { P_neutral = { P = "P_combo2", K = "PK_combo", S = "S_neutral" }, … }
for key, links in pairs(LINKS) do data.moves[key].links = links end
return data
```

`style` est l'un de : granny, hurry, bored, proud, mime, baby, dance, diva, gamer, doctor, jelly, sick, duck,
magician, yeti, robot, grandpa, pigeon, plumber (`Poses.styles`).

## Poses (voir l'en-tête de `Poses.lua`)

Une pose est `{ Articulation = { rx, ry, rz } }` (degrés), ou `{ rx, ry, rz, px, py, pz }` (studs) pour Root.

- Articulations : `Root`, `Waist`, `Neck`, `RS`, `RE`, `RW` (épaule, coude, poignet droits), `LS`, `LE`, `LW`,
  `RH`, `RK`, `RA` (hanche, genou, cheville droits), `LH`, `LK`, `LA`. Pieds : `FR`, `FL`.
- Épaule / hanche rx+ : le membre part vers l'avant (90 = horizontal devant, 180 = tendu en l'air).
- Épaule droite rz+ (gauche rz−) : le bras s'écarte sur le côté.
- Coude rx+ : l'avant-bras se plie vers l'avant. Genou rx− : la jambe se plie en arrière. Cheville rx− :
  pointe du pied vers le bas.
- Waist / Neck rx− : penché en avant ; ry+ : tourné vers la gauche.
- Root : rx− = bascule en avant, ry = rotation du bassin, py− = s'accroupit (−0,9 = très accroupi),
  pz− = avance.
- Au sol, ne précisez pas les jambes : les pieds restent plantés. `FR` / `FL` = `{ 0, 0, 0, dx, dy, dz }`
  déplace un pied (dz −0,5 = pas en avant). Une hanche précisée libère la jambe (coup de pied).
- En l'air (`*_air*`), les jambes sont libres : précisez `RH`, `RK`, `LH`, `LK`, jamais `FR` / `FL`.
- Restez dans des angles plausibles (de −180 à 200°) et des déplacements Root de moins de 2 studs.
- Le bras qui tient l'arme est le **droit** : poignet `RW`, l'arme part vers −Y de la main (le long de
  l'avant-bras quand le poignet est à 0).

## Signatures (L) et Supers (Y) : « sûrs de toucher », sans limite

Le moteur transforme lui-même ces coups au chargement (`CharacterList.lua`), la fiche n'écrit qu'un minimum :

- **L / →L / ↓L au corps à corps** : la zone devient un couloir de 16 studs devant le perso, 6 de haut, qui
  commence juste derrière lui. Tout adversaire à la même hauteur de plateforme est touché. Une zone déjà très
  large et centrée (onde, cri, monologue, `box(30, 8, 0, 2)`) est gardée des deux côtés.
- **↑L** : décollage en diagonale vers l'avant (élan ≥ (42, 80), comme la remontée de Brawlhalla) et couloir
  qui monte avec le perso. Écrire une pose de vol en diagonale. Un perso qui vole (`flying = true` dans la
  fiche : un saut en l'air de plus, plané) a un ↑L très puissant (dégâts × 1,6).
- **Projectiles** des L et des Y : ils visent l'adversaire le plus proche à 48 studs et foncent droit sur lui,
  en le suivant en vol (une pluie tombe sur lui, un éventail arrive sur lui en rafale). `aim = false` dans
  `projectile` pour garder une trajectoire libre (ex. une bombe posée).
- **Y (Supers)** : même chose avec un couloir 1,3 fois plus grand. Ils sont plus farfelus que les L.
- **Sans limite** : plus de jauge d'énergie ni de jauge Super, plus de `energyCost` / `superCost` / `meterCost`
  (ignorés). L'équilibrage se fait par `startup` (0,2 à 0,45 s) et `recovery` (0,4 à 0,9 s), plus longs que les P / K.
  Seule limite : les Supers (Y) ont un temps de recharge commun de `Config.SUPER_COOLDOWN` secondes (1,4 s) entre
  deux, géré par le moteur (attribut `SuperReadyAt` sur l'horloge serveur). La fiche n'a rien à écrire.
- Les dégâts des L sont relevés automatiquement au-dessus des P / K ; écrire 12 à 18 pour un L, 20 à 28 pour un Y.

## Un coup

```lua
P_side = {
	label = "Long coup d'aiguille", startup = 0.1, active = 0.1, recovery = 0.2,   -- secondes
	damage = 8, hitbox = box(6, 2.5, 3.5, 0.8), kbBase = 24, kbGrowth = 40, kbAngle = 20,
	selfVelocity = Vector2.new(20, 0),          -- élan (X = avant, Y = haut, 0 = garde la vitesse verticale)
	windup = { … }, strike = { … }, follow = { … }, -- élan → frappe → prolongement
	hold = 0.1,                                  -- figé dans la pose de frappe
	spin = { axis = "y", degrees = 360 },        -- ("x" : salto, multiple de 360)
	shake = true, wobble = true,                 -- tremble pendant l'élan / zigzague pendant la frappe
	trail = "prop",                              -- "prop" (arme), "rightHand", "leftHand", "bothHands",
	                                             -- "rightFoot", "leftFoot", "bothFeet", "rightLeg", "body", "head"
	prop = "aiguille",                           -- accessoire caché qui apparaît le temps du coup (PropAiguille)
	windupFx = { … }, fx = { … },                -- effets (voir plus bas)
	text = "TIENS !", hitText = "PIC !",          -- onomatopées à la frappe et à l'impact
},
```

Repères : P rapides (startup 0,06 à 0,12, dégâts 5 à 9), K lourds (0,15 à 0,25, dégâts 10 à 14,
kbGrowth 60 à 90), S de 8 à 16 dégâts (`energyCost` 20 à 35, 25 par défaut), Supers de 18 à 30.
kbAngle : 90 = vers le haut, négatif = vers le bas (smash aérien ↓ : −60 à −85).
Les coups qui ont une suite (`links`) éjectent deux fois moins pour que le combo continue.

### Types de coups (`kind`)

- `"melee"` (par défaut) : zone `hitbox = box(largeur, hauteur, avant, haut)`. `hits = 3` touche 3 fois
  pendant `active`.
- `"projectile"` :
  ```lua
  projectile = { speed = 70, angle = 0, gravity = 0, lifetime = 0.6, size = 1.6, color = …,
                 visual = { shape = "ball", size = 1.4, color = …, neon = true, spin = 10, text = "?",
                            parts = { { "block", Vector3.new(1, 0.2, 1), Vector3.new(0, 0.5, 0), couleur } } },
                 fan = { count = 3, from = -10, to = 25 },   -- éventail
                 bounce = 1, hits = 3, pierce = true, returns = true, homing = 0.4,
                 rain = { count = 6, spread = 8, ahead = 10, height = 22 },  -- tombe du ciel
                 linger = 2, from = "feet" }
  ```
  `returns` = boomerang (le chat qui griffe puis revient), `linger` = reste sur place (nuage, flaque).
- Tout spécial (S_…) doit frapper : un coup sans dégâts ressemble à une emote. Les emotes sont à part
  (bouton 😀, touches 1 à 4, `EMOTE_1` à `EMOTE_4` dans `CommonMoves.lua`).
- `"self"` : effet sur soi, avec `selfEffect = { heal = 5, energy = 30, meter = 1, bulles = 1, armor = 2,
  buff = { "turbo", 4 }, nextTrack = true }` et `teleport = 12` (studs devant). Bonus possibles : armor,
  caprice, turbo, viral, tilt, rap, slow, techno.
- `"trap"` : `trap = { size = Vector3.new(3, 2, 6), offset = 3, lifetime = 10, max = 3, visual = {…},
  color = …, persist = false }`. Le premier adversaire qui marche dessus prend le coup (damage, status…).
- `"wall"` : `wall = { size = Vector3.new(1.2, 8, 6), offset = 4, lifetime = 6, max = 2, visual = nil
  (invisible) ou {…}, reflect = true (renvoie les projectiles), absorbs = true (disparaît après un projectile),
  follow = true (suit le perso : bouclier), solid = false (ne bloque pas les persos) }`.
- `"counter"` : `counter = { window = 0.5, text = "CONTRE !", riposte = { damage = 12, kbBase = 40,
  kbGrowth = 70, kbAngle = 35, hitText = "…" } }`. Pendant la fenêtre, le prochain coup reçu est annulé.
- `"absorb"` : `absorb = { radius = 5, offset = 2.5 }`. Avale les projectiles pendant `active` ; avec un
  `hitbox`, frappe en plus.
- `"grapple"` : `grapple = { range = 28, angle = 45, speed = 85, pullEnemy = true }`. La ventouse attire
  l'adversaire touché, sinon le perso vole vers le décor.
- `"grab"` (GRAB) et `"throw"` (THROW_*) : comme Gégé, avec `carry` pour le trajet de la victime.

### Options communes

- `status = { name = "rooted", duration = 1 }` : stunned, asleep, frozen, statue, dancing, inverted,
  slowed, waiting, rooted, laughing, muted, blinded, sneezy, burning, slippery, dog, wet (3 s maximum).
- `burn = true` : brûlure (dégâts dans la durée, Chef).
- `pull = true` : attire vers le perso au lieu de repousser.
- `armor = true` : encaisse sans être éjecté pendant le coup.
- `invuln = 0.2` : invulnérable au début du coup.
- `meterCost = 20` : consomme la jauge du perso (pression du Canard, pigeons, réservoir).
- `energyCost`, `superCost` : ignorés (plus de jauges).
- `variants = { { label = "…", damage = …, status = … }, { … }, { … } }` : 3 résultats possibles (Gaston).
  Le prochain résultat est affiché au-dessus de lui. Seul le gameplay change, l'animation reste la même.
- `links = { P = "…", K = "…", S = "…", fwd_P = "…", up_K = "…", down_S = "…" }` : suites d'enchaînement.

### Effets (`fx`, `windupFx`, beats de recharge et de retour, étapes `fx` des fatals)

Tables génériques (voir `client/Fx.lua`) :

```lua
{ "ring", color = C, radius = 4, at = "front" }
{ "burst", color = C, size = 2.5, at = "front" }
{ "text", text = "ZIP !", color = C, at = "head" }
{ "particles", tex = "smoke" | "spark" | "fire", color = C, dir = "front" | "up" | "all" | "down",
  at = "hand", time = 0.4, speed = 8, size = 0.6, rate = 60 }
{ "pillar", color = C, height = 12, width = 2, at = "front" }
{ "puddle", color = C, width = 8 }
{ "toss", shape = "ball" | "cyl" | "flat", color = C, size = 1, count = 3, speed = 22 }
{ "rain", shape = "ball", color = C, count = 10, radius = 6, size = 0.6 }
{ "swarm", shape = "ball", color = C, count = 5, distance = 16 }
{ "symbols", symbols = { "♪", "♫" }, color = C, count = 6, radius = 4 }
{ "beam", color = C, length = 10, width = 1.6, at = "head" }
{ "screen", color = C, alpha = 0.3 }
{ "shake", amount = 0.5 }
```
`at` : "root", "front", "head", "above", "hand", "lhand", "feet".

## Costume (`look`)

```lua
look = {
	body = { head = peau, upper = haut, lower = bas, arms = bras, hands = mains, legs = jambes, feet = chaussures,
	         forearms = …, shins = … },        -- couleurs (Color3)
	cubeHead = 1.25,                           -- tête cubique (comme Gégé)
	parts = {                                  -- pièces soudées au corps
		{ "Chignon", "Head", "ball", Vector3.new(0.9, 0.7, 0.9), Vector3.new(0, 0.75, 0.2), Vector3.new(0, 0, 0),
		  Color3.fromRGB(220, 220, 225), "Fabric" },
		{ "Lunettes", "Head", "cyl", Vector3.new(0.05, 0.45, 0.45), Vector3.new(0.25, 0.1, -0.64), Vector3.new(0, 0, 0),
		  Color3.fromRGB(40, 40, 40), "SmoothPlastic", { axis = "z" } },
	},
	props = {                                  -- objets en main (copiés dans l'autre main pour le miroir)
		{ name = "PropSac", hand = "Right", visible = true, pieces = { … } },    -- l'arme (caisse)
		{ name = "PropAiguille", hand = "Right", visible = false, pieces = { … } }, -- n'apparaît que via prop = "aiguille"
	},
}
```

- Une pièce s'écrit `{ nom, partie du corps, forme, taille, position, rotation (degrés), couleur, matière,
  options }`. Formes : "ball", "block", "cyl" (axe `options.axis` "x", "y" ou "z", "y" par défaut), "wedge".
- Options : `{ neon = true, transparency = 0.3, light = { couleur, portée, luminosité }, reflect = 0.2,
  axis = "z" }`.
- Parties du corps : Head (cube de 1,25, face avant à z = −0,63), UpperTorso (≈ 2 × 1,6 × 1, avant à
  z = −0,5), LowerTorso, Left/RightUpperArm, LowerArm, Hand, UpperLeg, LowerLeg, Foot. Le perso regarde
  vers −Z.
- Dans `props`, les positions sont relatives à la main : l'objet pend vers −Y (une canne de 3 studs :
  pièce en (0, −1,3, 0), axe "y").
- Visez 10 à 25 pièces : silhouette lisible de loin (chapeau, coiffure, lunettes, nez, accessoires
  emblématiques).
- Matières (noms de Enum.Material) : "SmoothPlastic", "Plastic", "Fabric", "Wood", "WoodPlanks", "Metal",
  "Glass", "Neon", "Ice", "Foil", "Marble", "Slate", "Granite", "Sand", "Grass", "Cardboard", "Rubber",
  "Leather", "Concrete", "Brick".

## Fatals (3, séquence de 3 flèches)

```lua
fatals = {
	{ id = "pull_de_noel", label = "Le Pull de Noël", sequence = { "down", "forward", "down" }, scene = {
		{ "text", "UN PETIT PULL ?" },
		{ "spawn", at = "target", offset = Vector3.new(0, 0, 0), life = 4, pieces = { { "Pull", "", "block",
		  Vector3.new(3, 3.2, 1.6), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), Color3.fromRGB(200, 30, 40), "Fabric" } } },
		{ "fx", { "symbols", symbols = { "❄️", "🎄" }, count = 6 } },
		{ "wait", 1 },
		{ "fxAttacker", { "text", text = "CHEEESE !" } },
		{ "wait", 1 },
	} },
	…
}
```

- Flèches : "forward" (vers l'adversaire), "back", "up", "down". Reprenez celles du roster : → devient
  "forward", ← "back".
- Étapes possibles : text, wait, shrink / grow (échelle, time), spawn (pièces, at = target / attacker /
  between / above, offset, life), move (to, offset, time), lift (hauteur), launch (Vector3 avant / haut),
  spin (degrés, axis), orbit (rayon, turns), color (Color3), material ("Slate"…), squash, hide, show,
  fx (effet sur la victime), fxAttacker (effet sur le perso).
- 100 % cartoon (rapetisser, emballer, envoyer en orbite…). Pas de sang ni de démembrement.
- Le premier fatal est offert, le 2ᵉ se débloque au niveau de maîtrise 5 et le 3ᵉ au niveau 15.

## Mécanique (`passive`)

`kind` est l'une des valeurs listées en tête de `server/Mechanics.lua` : bulles, traps, walls, rating, forms,
burn, caprice, tempo, likes, rage, laugh, bounce, contagion, float, tricks, fresh, tank, playlist, flock,
grapple. Ajoutez `name` et `icon` ; les autres réglages ont des valeurs par défaut (max, gain…). Gaston :
`icons = { "🕊️", "💥", "🐇" }` pour annoncer ses 3 résultats.

## Recharge, retour, saisie, manies

```lua
charge = { label = "…", loop = 1.6, lockWrist = false, color = C,
	keys = { { 0, pose }, { 0.4, pose }, …, { 1.6, pose } },   -- la dernière clé égale la première (boucle)
	beats = { { 0.1, { "symbols", … } }, { 1.2, { "text", text = "…" } } } },
data.respawn = { duration = 1.8,
	platform = { pieces = { { "Fauteuil", "base", "block", Vector3.new(5, 1, 3), Vector3.new(0, -0.5, 0), Vector3.zero, C, "Wood" },
	                        { "Pelote", "", "ball", Vector3.new(4, 4, 4), Vector3.new(0, 9, 0), Vector3.zero, C, "Fabric" } } },
	keys = { { 0, pose }, …, { 1.8, {} } },
	beats = { { 0.6, { "burst", … } } } }
data.grabHold = { Root = …, RS = …, RE = …, LS = …, LE = … }
fidgets = { { duration = 2, lockWrist = false, keys = { { 0, {} }, { 0.5, pose }, …, { 2, {} } } }, … }
```

- Plateforme de retour : les pièces "base" portent le perso. Les positions sont relatives au dessus de la
  plateforme (y = 0 = sous les pieds ; une base de 1 d'épaisseur en (0, −0,5, 0)).
- Les clés de recharge, de retour et de manies sont des poses partielles ajoutées à la garde.
