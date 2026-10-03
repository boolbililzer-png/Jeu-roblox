# BAGARRE BIZARRE — Gameplay et progression (inspiré de Brawlhalla)

*Complète [roster-20-personnages.md](roster-20-personnages.md) et [maps-20-arenes.md](maps-20-arenes.md).*

---

## 1. Ce qu'on reprend de Brawlhalla, et pourquoi ça marche

Brawlhalla rapporte beaucoup alors qu'il est gratuit, grâce à quatre piliers :
1. **Un combat très simple à prendre en main** (une direction + un bouton), mais profond à maîtriser.
2. **Des parties courtes et chaotiques à plusieurs** (jusqu'à 4 joueurs), on relance « une dernière ».
3. **Une rotation gratuite de persos chaque semaine** : on essaie, on accroche, on veut le garder.
4. **Il ne vend aucun avantage en combat** : il vend des persos (qu'on peut aussi gagner en jouant), des skins, des effets, un pass de saison. C'est ce qui garde les joueurs, donc ceux qui paient.

Le point 4 est important pour ta demande sur les capacités : voir la section 5.

---

## 2. Le combat : passage en « jeu de plateformes » à la Brawlhalla

### Ce qui change
- **Arènes avec plateformes** : un sol principal suspendu dans le vide et 2 ou 3 plateformes flottantes. On peut tomber.
- **Pas de barre de vie classique : une jauge de dégâts en %** au-dessus de chaque joueur. Plus elle monte, plus les coups l'envoient loin.
- **On perd une vie en sortant de l'écran.** 3 vies par joueur. Le dernier debout gagne.
- **Jusqu'à 4 joueurs dans la même arène**, ce qui va très bien avec Roblox où l'on joue entre amis.
- **Bonus réseau** : ce style tolère bien mieux la latence du téléphone que le 1v1 à la Street Fighter. C'est un vrai gain de faisabilité.

### Ce qui ne change pas
- **Les 20 persos, leurs coups, leurs mécaniques et leurs coups fatals.** La grille « direction + bouton » est déjà exactement celle de Brawlhalla.
- **Les statuts loufoques** (inversion, fou rire…) : 3 s max, toujours.

### Les coups fatals dans ce système
La jauge de dégâts devient **rouge à partir de 150 %**. Si l'adversaire est **sur sa dernière vie et dans le rouge**, l'écran affiche « TERMINE-LE ! » et le joueur peut entrer son fatal (3 flèches + ⭐). Sinon, l'éjection classique hors de l'écran reste possible. À 4 joueurs, le fatal ne gèle pas la partie : il se joue en petit, au premier plan, pendant que les autres continuent.

### Nouveaux contrôles (toujours un seul bouton à la fois)

```
   [ JOYSTICK ]                        (⭐) ← apparaît quand la jauge Super est pleine
                                  (P)  (K)  (S)
                                    (SAUT) (ESQUIVE)
```

| Bouton | Rôle |
|---|---|
| **P** | Attaque légère (inchangé) |
| **K** | Attaque lourde (inchangé) |
| **S** | Technique spéciale (inchangé) |
| **SAUT** | Saut, double saut en l'air. Le joystick ↑ ne sert plus à sauter, ce qui évite les sauts involontaires sur téléphone. |
| **ESQUIVE** | Remplace la garde, comme dans Brawlhalla. Seul = esquive sur place ; avec une direction = esquive dans cette direction. |
| **⭐** | Super, inchangé |

- **Chope** : → + ESQUIVE quand on touche l'adversaire. On garde la règle « une direction + un bouton », et le bouton C disparaît.
- **Remontée** : ↑S en l'air sert à revenir sur l'arène (chaque perso a déjà un ↑S qui monte : lampadaire de Gégé, envol de châle de Mamie, etc.).
- **Garde** : supprimée, l'esquive la remplace. ← sert seulement à reculer.
- **Coups « arrière » réattribués** (découvert en codant le prototype) : dans ce style de jeu, pousser ← retourne le perso, donc ←P / ←K / ←S ne peuvent plus exister à part. Ils deviennent :
  - ←P et ←K → **↑P et ↑K** (c'étaient déjà surtout des anti-airs) ;
  - ←S → **ESQUIVE puis S** (« spécial d'esquive » : parfait pour les contres, boucliers et murs de la plupart des persos) ;
  - →P / →K / →S deviennent des coups « de côté », qui partent dans la direction poussée.

---

## 3. Les modes de jeu

| Mode | Joueurs | Pour qui | Débloque |
|---|---|---|---|
| **Bagarre générale** | 4 en chacun pour soi | Mode principal, parties de 3 min | Pièces, XP |
| **Duel** | 1 contre 1 | Ceux qui veulent du « Street Fighter » | Pièces, XP |
| **Classé** | 1v1 et 2v2 | Compétition, saisons de 2 mois, rangs Carton → Bronze → … → Légende Bizarre | Récompenses de fin de saison (skins exclusifs, titres) |
| **Duo** | 2 contre 2 | Jouer avec un ami | Pièces, XP |
| **Partie privée** | 2 à 8 | Entre amis, réglages libres (pièges ON, objets ON) | Rien (anti-triche) |
| **Aventure** | Solo ou à 2 contre des bots | Débutants, joueurs mobiles en déplacement | Pièces, XP |
| **Mode fun du week-end** | 4 à 6 | Rotation : *Foot de rue* (un ballon, deux buts, comme le Brawlball), *Tous Gégé* (tout le monde a les commandes inversées), *Pluie de pigeons*… | Pièces doublées |

**Objets en arène** (modes non classés, comme les armes de Brawlhalla) : objets loufoques qui tombent du ciel (baguette de pain, pelote géante, extincteur à soda…). Ça mixe les parties et ça fait des moments drôles à partager.

**Des bots partout** pour remplir les parties quand il n'y a pas assez de joueurs, surtout au lancement.

---

## 4. Débloquer les personnages

### Le principe
- **6 persos gratuits pour toujours** : Gégé, Mamie Tricot, Dylan, Sumo Gélatine, Marcel, Roi Pigeon.
- **Rotation gratuite de 4 persos chaque semaine**, parmi les 14 autres. C'est le moteur des ventes : le joueur essaie Lola ou Bébé Colosse, accroche, et veut le garder.
- **Chaque perso payant s'achète au choix** :
  - en **Pièces** (gagnées en jouant), ou
  - en **Robux**, directement.
- **Pack « Tous les persos »** : tous les persos actuels **et futurs**, en Game Pass. C'est souvent la meilleure vente de ce type de jeu.

### Ordres de grandeur (à ajuster après les premiers tests)

| Produit | En Pièces | En Robux |
|---|---|---|
| Un perso | 3 000 pièces (≈ 8 à 10 h de jeu) | 149 à 199 R$ |
| Un nouveau perso, sa première semaine | Pas en pièces | 249 R$ (puis repasse au prix normal) |
| Pack « Tous les persos » (actuels et futurs) | — | 1 499 à 1 999 R$ |
| Pack perso + son arène + 1 skin | — | 399 R$ |

*Repère : on gagne ~30 pièces par partie, plus les missions quotidiennes (~150 pièces/jour). Il faut qu'un joueur régulier sans Robux débloque un perso toutes les 1 à 2 semaines. S'il n'en débloque jamais, il part ; s'il les a tous en un mois, il n'achète rien.*

---

## 5. Techniques et capacités : mon avis franc

### Le risque
Si on peut **acheter des capacités plus fortes** et les utiliser contre d'autres joueurs, le jeu devient « payer pour gagner » (pay-to-win). Sur Roblox, ça se paie cher :
- les joueurs qui perdent contre des payeurs partent, et ils sont la grande majorité ;
- les notes et la rétention baissent, or c'est ce que l'algorithme de Roblox utilise pour recommander un jeu ;
- les payeurs eux-mêmes partent quand il n'y a plus personne à battre.

Brawlhalla a réussi justement parce qu'il ne fait pas ça.

### Ce que je propose à la place (tout aussi vendeur)

**a) Niveau de maîtrise par perso (1 à 30), en jouant.** Chaque niveau débloque quelque chose, mais jamais de la puissance :

| Niveau | Récompense |
|---|---|
| 2 | Couleur alternative n°1 |
| 5 | **2ᵉ coup fatal** |
| 8 | Provocation |
| 10 | **Variante de Super** (voir plus bas) |
| 15 | **3ᵉ coup fatal** |
| 20 | Titre + bordure de profil |
| 25 | Effet de KO personnalisé |
| 30 | Skin « Maître » doré |

Chaque palier peut aussi **s'acheter en Robux** pour ceux qui ne veulent pas attendre (« passer le niveau 5 maintenant »). C'est le même déblocage que tu voulais pour les techniques, sans avantage en combat.

**b) « Variantes » de techniques au lieu de techniques plus fortes.** Le kit de base de chaque perso est complet. À débloquer : des variantes d'**égale puissance mais différentes**. Exemple Gégé : *Tournée générale* (6 bouteilles en éventail) **ou** *Pluie de bulles* (bulles qui montent lentement et piègent). Le joueur choisit sa variante avant le match. Ça donne envie de tout collectionner sans déséquilibrer.

**c) ✅ Décision de YAZ : aucun bonus de stats, dans aucun mode.** Tous les persos ont la même puissance partout (Aventure comprise). Tout ce qui se débloque, en jouant ou en Robux, ce sont des fatals, des variantes de Super, des skins et autres cosmétiques.

---

## 6. Ce qui fait revenir chaque jour (et dépenser)

| Système | Comment ça marche | Ce que ça vend |
|---|---|---|
| **Missions quotidiennes** | 3 missions simples (« fais 2 KO avec Mamie »), relancées chaque jour | Habitude quotidienne, essai des persos en rotation |
| **Série de connexion** | Bonus croissant sur 7 jours | Retour quotidien |
| **Pass de Combat** (saison de 2 mois) | 50 paliers, piste gratuite + piste payante (~399 R$) : skins, fatals exclusifs, emotes, pièces | Revenu régulier, le plus important après les persos |
| **Boutique rotative** | 6 objets qui changent chaque jour : skins, variantes d'arène, emotes, effets de KO | Achats d'impulsion, envie de revenir voir |
| **Skins** | 2 à 5 par perso, dont des séries thématiques (Halloween, Noël, « Super-héros ratés »…) | **Le revenu principal à long terme** |
| **Acolytes** | Petit compagnon qui flotte à côté du perso (un pigeon, un chat, un mini-colis) | Cosmétique pas cher, très collectionné par les jeunes joueurs |
| **Saisons classées** | Récompenses exclusives selon le rang atteint | Motivation à jouer beaucoup |
| **Événements** | Mode spécial + skins limités 2 semaines (Halloween, Noël, été) | Pics de dépenses |
| **VIP** (abonnement Roblox mensuel) | Pièces x1,5, 1 skin exclusif par mois, salon VIP | Revenu récurrent |

### La boutique et le casier (modèle Brawlhalla)

Comme la boutique de Brawlhalla : **tout s'achète directement**, sans coffre au hasard, et **rien ne rend plus fort**.

| Catégorie | Ce que c'est | Prix indicatif | Dans le prototype |
|---|---|---|---|
| **Persos** | voir section 4 | 3 000 🪙 ou 149 à 199 R$ | — |
| **Skins** | tenue complète d'un perso | 2 500 🪙 ou 149 R$ | — |
| **Skins d'armes** | gants dorés, poêle en or, baguette fluo… (même forme, même portée) | 1 500 🪙 ou 99 R$ | — |
| **Emotes** | provocations jouées en match (roue de 4) | 1 000 🪙 ou 79 R$ | ✅ roue 😀 + 10 emotes |
| **Effets de KO** | animation jouée quand **tu** éjectes quelqu'un (ou quand tu tombes tout seul) | 1 500 🪙 ou 99 R$ | ✅ 7 effets |
| **Podiums** | ce sur quoi le gagnant monte à la fin de la manche | 2 000 🪙 ou 129 R$ | ✅ 5 podiums |
| **Acolytes** | petit compagnon qui flotte à côté du perso | 1 000 🪙 ou 79 R$ | — |
| **Titres et avatars** | affichés sur la carte du joueur | 500 🪙 | — |

- **Trois sortes d'objets** : *gratuits* (tout le monde les a : 4 emotes, l'effet « Fumée et étoiles », le podium « Caisses de soda »), *boutique* (pièces ou Robux), *Pass de Combat* (paliers de la saison, ne s'achètent pas à l'unité).
- **Promo de la semaine** : comme Brawlhalla, environ 2 skins, 2 skins d'armes, 1 emote et 1 acolyte à -30 ou -40 % chaque semaine. Une vraie réduction sur un vrai prix, jamais de faux compte à rebours.
- **Objets d'événement** (Halloween, Noël, été) : en vente seulement pendant l'événement. On peut les remettre l'année suivante ; Brawlhalla ne le fait pas pour ses podiums, mais les rendre introuvables pousse à l'achat panique chez un public jeune, donc je déconseille.
- **Remboursement** : Brawlhalla rembourse sur demande pendant 90 jours (3 fois maximum). Sur Roblox, un achat en Robux ne se rembourse pas tout seul ; on peut proposer l'équivalent : rendre les pièces d'un cosmétique acheté en pièces, une fois par semaine. Rassurant pour les parents.
- **Le casier** (bouton 🎒, touche C) : on choisit ses 4 emotes, son effet de KO et son podium. Les objets verrouillés affichent 🔒 et leur prix. Dans le prototype, `UNLOCK_ALL_COSMETICS = true` débloque tout pour tester ; il faudra le mettre à `false` quand les achats et la sauvegarde seront branchés.

### Les outils Roblox à utiliser
- **Game Pass** : achats permanents (pack « Tous les persos », VIP permanent).
- **Developer Products** : achats répétables (persos à l'unité, skins, pass de saison, monnaie).
- **Abonnements d'expérience** : le VIP mensuel.
- **Premium Payouts** : Roblox te paie aussi selon le temps passé par ses abonnés Premium dans ton jeu. Encore une raison de privilégier la rétention plutôt que le blocage.
- **Serveurs privés payants** : pour jouer entre amis.

---

## 7. À éviter absolument

- **Payer pour gagner en PvP** (voir section 5).
- **Coffres aléatoires payants** : Roblox impose d'afficher les probabilités, et c'est interdit ou encadré dans plusieurs pays (Belgique, Pays-Bas). La boutique rotative à achat direct fait le même travail sans le risque.
- **Faux compte à rebours ou fausse rareté** : le public de Roblox est jeune, Roblox sanctionne les pratiques trompeuses, et les parents se plaignent (remboursements, mauvaise réputation).
- **Murs de progression** : un joueur gratuit doit toujours pouvoir tout débloquer en jouant, même lentement. C'est lui qui fait vivre les parties des joueurs qui paient.

---

## 8. Conséquences sur les autres documents

- **Arènes** : chaque arène doit maintenant avoir un sol principal suspendu, 2 ou 3 plateformes et des bords dans le vide. Les décors et les pièges restent les mêmes.
- **Roster** : les coups ne changent pas. La garde est remplacée par l'esquive, la chope passe sur → + ESQUIVE, et le saut a son bouton.
