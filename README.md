# Bagarre Bizarre

Jeu de combat de plateforme pour Roblox, façon Brawlhalla et Super Smash Bros, pensé d'abord pour le
téléphone. Il est construit sur le prototype v7 (`BagarreBizarre_7.rbxlx`).

Au programme :
- 20 combattants loufoques et 20 arènes avec leur piège ;
- une jauge de dégâts en %, des éjections hors de l'arène et 3 coups fatals par perso ;
- la Caisse Bizarre, qui donne l'arme de chaque perso ;
- des bots pour jouer seul ou compléter une partie.

Tout est construit par code : costumes, accessoires, animations, effets et arènes. Il n'y a aucun modèle ni
aucune animation à importer.

## Lancer le jeu dans Roblox Studio

1. Ouvre `BagarreBizarre.rbxlx` dans Roblox Studio (Fichier > Ouvrir), puis lance **Play** (F5).
2. Dans le salon, choisis un mode, un perso et une arène, puis appuie sur **PRÊT !**.

Les places libres sont prises par des bots.

- **Méthode Rojo** (pour développer) : lance `rojo serve` dans ce dossier, puis connecte le plugin Rojo.
- **Régénérer la place** à partir de `src/` : `python3 tools/build_place.py`.
- **Sauvegarde des profils** (pièces, persos achetés, maîtrise) : il faut publier le jeu et activer
  *Game Settings > Security > Enable Studio Access to API Services*. Sans cela, le profil ne dure que le
  temps de la session.

## Contrôles

On ne combine jamais deux boutons : la direction tenue au moment de l'appui choisit le coup.

| Action | PC | Téléphone |
|---|---|---|
| Se déplacer, viser une direction | ZQSD / WASD / flèches | joystick |
| Sauter (double saut en l'air) | Espace | SAUT |
| **P** attaque rapide | J | P (rouge) |
| **K** attaque lourde | K | K (bleu) |
| **S** spécial (maintenu = S chargé) | L | S (jaune) |
| Esquive (puis S = spécial d'esquive) | Maj | ESQ |
| ⭐ 3 Supers (jauge pleine) : ↑Y, →Y (ou Y), ↓Y ; et coup fatal | Y | ⭐ |
| ⚡ Recharger l'énergie des spéciaux | T (maintenu) | ⚡ |
| ✋ Ramasser une caisse ou un objet, lancer l'objet, **jeter son arme** (pas de saisie) | U | ✋ |
| 😀 Emotes | 1, 2, 3, 4 | 😀 |
| Aide des touches | H | — |

- **Double tap ← ou →** : ruée. P, K ou S pendant la ruée ou juste après donnent un coup de dash, qui garde
  l'élan. On peut aussi marcher pendant un coup (plus lentement).
- **Spéciaux (L)** : neutre, ↑, →, ↓, maintenu, en l'air… Ils ont une plus grande portée (`Config.S_RANGE`).
- **↓ maintenu** sur une plateforme fine : on passe au travers.
- **J et K maintenus au sol** : frappe chargée, comme les smashs.
- **↑S** sert de remontée et ne coûte pas d'énergie.

## Règles

- **Bagarre générale** : 4 combattants, chacun pour soi, 3 minutes. +1 point par éjection, −1 par chute.
  En cas d'égalité, mort subite à 300 %.
- **Duel** : 1 contre 1, 3 vies.
- **Aventure** : 5 combats contre des bots de plus en plus forts, chacun dans l'arène de l'adversaire,
  avec un boss à la fin. On peut la faire à deux.
- **Entraînement** : le mannequin, sans chrono. Le bouton ⏏ QUITTER ramène au salon.
- **Jeter son arme** : avec la caisse ouverte, ✋ lance l'arme sur l'adversaire, même pendant qu'on se fait
  frapper ; ça casse alors le combo adverse (0,5 s d'invulnérabilité). On repasse à mains nues, et l'arme
  retombe en Caisse Bizarre que n'importe qui peut reprendre.
- **Caisse Bizarre** 📦 : on entre à mains nues, avec des coups communs à tous. Ouvrir une caisse avec ✋
  sort l'arme du perso, et P, K et S deviennent son moveset unique jusqu'à la prochaine éjection. La
  saisie, les Supers, les fatals et la mécanique du perso marchent toujours.
- **Jauge de dégâts** : elle passe au rouge à 150 %. Un adversaire sur sa dernière vie et dans le rouge
  peut être achevé par un **coup fatal** : 3 flèches puis ⭐. Les séquences débloquées s'affichent à
  l'écran.
- **Statuts loufoques** (inversion, fou rire, gel, éternuements…) : 3 s maximum, un seul à la fois, puis
  5 s d'immunité.
- **Pièges d'arène** : un par arène, annoncé 2 s avant, environ 5 % de dégâts. Pièges ON/OFF se règle
  dans le salon.

## Progression

> **Phase de test** : `Roster.UNLOCK_ALL = true` rend les 20 persos et tous leurs fatals jouables par tout le
> monde. Passe-le à `false` au moment de mettre les persos en vente.


Il n'y a **aucun bonus de stats**, dans aucun mode.

- **Persos gratuits** : Gégé, Mamie Tricot, Dylan, Sumo Gélatine, Marcel et le Roi Pigeon.
- **Rotation** : 4 autres persos sont gratuits chaque semaine.
- **Achat** : chaque autre perso coûte 3 000 pièces.
- **Gains** : environ 30 pièces par partie.
- **Maîtrise** (niveau 1 à 30 par perso) : 2ᵉ coup fatal au niveau 5, 3ᵉ au niveau 15.
- Les réglages se trouvent dans `src/ReplicatedStorage/Shared/Roster.lua`.

## Organisation du code

```
src/ReplicatedStorage/Shared/
  Characters/<Id>.lua   les 20 fiches de persos (look, ~40 coups, fatals, mécanique, recharge, retour)
  BareMoves.lua         coups à mains nues (sans caisse), communs à tous
  CommonMoves.lua       lancer d'objet ; saisie et projections par défaut
  CharacterList.lua     charge les fiches dans l'ordre de Roster.lua
  Roster.lua            ordre, gratuits, rotation, prix, maîtrise, modes, fiches du menu
  Arenas.lua            les 20 arènes (décor, lumière, public, piège)
  AnimCore.lua, Poses.lua   animation procédurale (poses, ressorts, pieds au sol)
  Statuses.lua          statuts loufoques et bonus passagers
  MoveSets.lua          coups avec ou sans la Caisse Bizarre
  Items.lua, Config.lua objets à ramasser ; réglages globaux
src/ServerScriptService/Server/
  Main.server.lua       démarrage
  Lobby.lua             salon, modes, bots de remplissage, Aventure, récompenses
  Match.lua             vies, points, éjections, retour sur la plateforme, coups fatals
  Combat.lua            coups, zones de frappe, projectiles, saisies
  Specials.lua          pièges, murs, contres, aspiration, grappin
  Mechanics.lua         la mécanique de chaque perso (Bulles, Likes, Rage, Tempo…)
  Fighters.lua          dégâts, éjection, statuts
  Bot.lua               IA des bots
  Arena.lua, Hazards.lua   construction de l'arène et pièges
  Pickups.lua           Caisse Bizarre et objets
  Profile.lua           pièces, persos achetés, maîtrise (DataStore)
  Costumes.lua, Fatals.lua, Dummy.lua
src/StarterPlayer/StarterPlayerScripts/Client/
  Main.client.lua       commandes, déplacements, coups
  Menu.lua              salon et résultats
  Hud.lua, Fx.lua, Animator.lua, CameraRig.lua, Controls.lua
tools/
  build_place.py        génère BagarreBizarre.rbxlx depuis src/
  check_characters.py   vérifie les fiches et joue toutes leurs animations hors Roblox
docs/
  fiche-perso.md        comment écrire la fiche d'un perso
  roster-20-personnages.md, grille-combos-signatures.*, maps-20-arenes.md, gameplay-progression.md
```

Pour ajouter ou retoucher un perso, voir [docs/fiche-perso.md](docs/fiche-perso.md). Pour vérifier une
fiche : `python3 tools/check_characters.py <Id>` (il faut le binaire `luau`).
