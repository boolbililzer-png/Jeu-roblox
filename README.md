# Bagarre Bizarre

Jeu de combat de plateforme pour Roblox, inspiré de Brawlhalla et Super Smash Bros. Il est pensé d'abord pour le téléphone.

20 combattants loufoques, 20 arènes, une jauge de dégâts en %, des éjections hors de l'arène, des Caisses Bizarres qui donnent l'arme de chaque perso, et des bots pour jouer seul.

## Lancer le jeu dans Roblox Studio

**Méthode simple** : ouvre `BagarreBizarre.rbxlx` dans Roblox Studio (Fichier > Ouvrir), puis clique sur **Play** (F5). Tu arrives au salon : choisis un perso puis clique **PRÊT !**. Un bot est ajouté automatiquement si tu es seul.

**Méthode Rojo** (pour développer) : `rojo serve` dans ce dossier, puis connecte le plugin Rojo dans Studio. Le fichier `default.project.json` décrit l'arborescence.

Pour jouer à plusieurs : publie la place sur Roblox (Fichier > Publier sur Roblox).

## Contrôles

| Action | PC | Manette | Téléphone |
|---|---|---|---|
| Se déplacer / viser une direction | ZQSD, WASD ou flèches | stick gauche | joystick |
| Sauter (1 au sol + 2 en l'air) | Espace | A | bouton SAUT |
| **P** attaque légère (combos) | J | X | bouton P rouge |
| **S** signature (maintenir = charger ×1,5) | K | Y | bouton S bleu |
| Esquive | L ou Maj | B | bouton ESQ |
| ✋ ramasser / lancer l'arme / saisir | E ou H | R1 | bouton ✋ |

On ne combine jamais deux boutons : la direction tenue au moment de l'appui choisit le coup.

- **P** : neutre, côté (→), bas (↓), et en l'air (neutre, côté, bas).
- **S** : neutre, côté (→), bas (↓), remontée (↑) et plongeon (↓ en l'air).

Maintenir **bas** sur une plateforme permet de la traverser. Maintenir **bas** en l'air fait chuter plus vite. Contre un mur, on glisse et on peut faire un saut mural.

## Règles (façon Brawlhalla)

- Chaque joueur a **3 vies** et commence à **0 %**. Les coups font monter le % ; la jauge passe au rouge à 150 %.
- Avoir beaucoup de % ne tue pas : on perd une vie seulement quand on est éjecté hors des **Blast Zones**.
- **Éjection** : `Force = Éjection de base + % de la cible × Multiplicateur`, divisée par le poids du perso. Elle est appliquée via `AssemblyLinearVelocity`. Le temps d'étourdissement (hitstun) dépend de la force reçue.
- **Attaques légères (P)** : éjection faible et presque fixe, pour enchaîner 2 à 4 coups.
- **Signatures (S)** : éjection qui s'emballe avec le %. Maintenir S charge le coup jusqu'à ×1,5.
- **Caisse Bizarre** : on commence à mains nues (moveset commun). Ramasser une caisse avec ✋ équipe l'arme du perso et son moveset 100 % unique. ✋ relance l'arme, et l'arme est perdue à chaque vie perdue.
- Après une chute, retour en parachute 🪂 avec quelques secondes d'invulnérabilité.
- **Statuts loufoques** (inversion, fou rire, gel…) : 3 s maximum, pas de cumul, puis 5 s d'immunité.
- **Pièges d'arène** : un par arène, annoncé 2 s avant. Ils se désactivent dans le salon (Pièges ON/OFF).
- Fin de partie : dernier survivant, ou à la fin du chrono (5 min). Le départage se fait aux vies restantes, puis au % le plus bas.

## Ce qui est dans le dépôt

```
docs/
  visionneuse-3d.html        Atelier 3D : les 20 persos et chaque coup animé (avant le coup, élan, frappe, retour)
  design-personnages.html    Planche de design 2D des 20 persos
  roster-20-personnages.md, maps-20-arenes.md, specs-moteur-combat.md, grille-combos-signatures.pdf
tools/
  gamedata/                  SOURCE UNIQUE des données : rig, looks 3D, poses, 220 coups, 20 arènes
  build.py                   génère GameData.lua + la visionneuse + BagarreBizarre.rbxlx
src/
  ReplicatedStorage/Shared/  code partagé client/serveur
    GameData.lua             (généré) toutes les données du jeu
    CharacterBuilder.lua     construit le perso 3D (rig R15 + accessoires, arme cachée/visible)
    MotorController.lua      déplacements Brawlhalla (sauts, mur, esquive, plateformes, éjection)
    Pose.lua                 animations procédurales (même calcul que la visionneuse)
    Knockback.lua            formule d'éjection, hitstun, charge
  ServerScriptService/
    Main.server.lua          démarrage, groupes de collision, réception des actions
    Server/Combat.lua        coups, hitbox spatiales, projectiles, pièges, murs, contres, dashs
    Server/Passives.lua      les 20 passifs (Jauge de Bulles, Note client, Tempo, Likes, Rage…)
    Server/Match.lua         salon, compte à rebours, vies, KO, résultats
    Server/Bot.lua           IA des bots
    Server/ArenaBuilder.lua, ArenaTraps.lua, Crates.lua, Fighter.lua
  StarterPlayer/StarterPlayerScripts/
    Client.client.lua        démarrage client
    ClientModules/           Controller (entrées + prédiction), Animator, CameraRig, Hud, Menu, Fx, MobileButtons
```

## Modifier le jeu

Les persos, coups, poses et arènes se règlent dans `tools/gamedata/*.py`. Ensuite, lance :

```
python3 tools/build.py
```

Cette commande régénère d'un coup `src/ReplicatedStorage/Shared/GameData.lua`, la visionneuse 3D et la place `BagarreBizarre.rbxlx`. Le jeu et la visionneuse lisent les mêmes données, donc ce que tu vois dans l'atelier 3D est ce qui tourne dans Roblox.

Pour afficher les hitbox en rouge pendant les tests, mets `DebugHitboxes = true` dans `src/ReplicatedStorage/Shared/Config.lua`. Ce fichier contient aussi la gravité, les sauts, le hitstun, le nombre de vies, etc.

## Choix techniques

- **Hitbox** : uniquement des requêtes spatiales instantanées (`GetPartBoundsInBox`, `GetPartBoundsInRadius`), jamais `.Touched`.
- **Vélocité** : uniquement `AssemblyLinearVelocity` (aucun BodyMover obsolète). Pendant le hitstun, l'Humanoid passe en état `Physics` pour ne pas freiner l'éjection.
- **Réseau** : l'animation part tout de suite chez le joueur qui appuie (prédiction). C'est le serveur qui valide les touches, les dégâts et les éjections.
- **2.5D** : déplacements bloqués sur l'axe X, ce qui simplifie la synchronisation.
- **Animations** : procédurales (Motor6D.Transform), sans asset à importer. Ça reste lisible et facile à retoucher dans `poses.py`.

## Limites connues / prochaines étapes

- Les sons utilisent quelques sons intégrés à Roblox. Il faudra les remplacer par des sons du Creator Store (bruitages, musiques d'arène).
- Les Supers ⭐, les coups fatals et la jauge Super du premier roster ne sont pas codés, car la Grille des Combos ne garde que P et S. Ils pourront revenir comme mode bonus.
- Les animations procédurales peuvent être remplacées plus tard par des animations faites dans l'Animation Editor ou Moon Animator.
- Il manque encore le matchmaking classé, la monétisation (packs perso + arène, skins, pass de saison) et la sauvegarde de progression (DataStore).
