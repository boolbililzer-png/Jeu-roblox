# BAGARRE BIZARRE — Roster v1 (20 combattants)

*Titre provisoire. Jeu de combat 1v1 en 2.5D sur Roblox, pensé d'abord pour le téléphone.*

---

## 1. Les contrôles sur téléphone

> **Mise à jour :** depuis le passage au gameplay façon Brawlhalla, les contrôles à jour sont dans [gameplay-progression.md](gameplay-progression.md) (bouton SAUT, ESQUIVE à la place de la garde ; depuis la v0.7 la chope est sur le bouton ✋, qui sert aussi à ramasser et lancer les armes). Les coups des persos ne changent pas.

Règle d'or : **un seul bouton à la fois, jamais deux en même temps.** Le pouce gauche tient la direction, le pouce droit tape un seul bouton. Pas de quart de cercle ni de « Hadoken » : sur un écran tactile ça rate une fois sur deux et le joueur mobile abandonne.

```
   [ JOYSTICK ]                         (⭐ SUPER)
   8 directions                    (P)  (K)
   à gauche                        (S)  (C)
```

| Bouton | Rôle |
|---|---|
| **P** (rouge) | Attaque rapide |
| **K** (bleu) | Attaque lourde |
| **S** (jaune) | Technique spéciale |
| **C** (vert) | Chope (et anti-chope si on le tape quand on se fait attraper) |
| **⭐ SUPER** | S'allume quand la jauge Super est pleine |

### Grille de coups identique pour tous (24 coups propres par perso)

| Catégorie | Entrées | Nb |
|---|---|---|
| Normaux | P · K · →P · →K · ↓P · ↓K · ←P · ←K · (saut) P · (saut) K | 10 |
| Chope | C | 1 |
| Spéciaux | S · →S · ←S · ↓S · ↑S · S maintenu · →→S · (saut) S | 8 |
| Supers | ⭐ · ↓⭐ | 2 |
| Coups fatals | 3 flèches + ⭐ | 3 |

**+ 5 actions communes, sans aucun bouton combiné** :
- **Garde** : maintenir la direction opposée à l'adversaire (←), comme dans Street Fighter. ↙ pour la garde basse. Le pouce droit reste libre, donc on peut riposter avec ←P / ←K / ←S directement depuis la garde.
- **Esquive** : double tap ← (pas arrière rapide avec un court instant d'invulnérabilité).
- **Dash** : double tap →.
- **Anti-chope** : taper C au moment où l'on se fait attraper.
- **Provocation** : petite icône d'emote près du portrait, hors de la zone de combat (pas de risque de la déclencher par erreur).
→ **29 actions par personnage**, mais le joueur n'a qu'**une seule grille à apprendre** : changer de perso, c'est changer d'effets, pas de manette. C'est ce qui rend 20 persos digestes sur mobile.

Aide mobile : option « **Combo auto** » (taper P en rafale enchaîne un combo de 3-4 coups), tampon d'entrée de 150 ms, boutons redimensionnables et déplaçables.

### Règles communes

- **Jauge Super** : se remplit en donnant et en recevant des coups.
- **Statuts loufoques** (inversion, fou rire, gel…) : **3 s max**, icône visible au-dessus de la tête, non cumulables, puis 5 s d'immunité au même statut. Indispensable pour que ce soit drôle et pas rageant.
- **Coup fatal** : quand l'adversaire passe **sous 15 % de vie dans la manche décisive**, l'écran crie **« TERMINE-LE ! »** pendant 4 s. Le joueur entre **3 flèches + ⭐**. Sur mobile, les icônes de la séquence s'affichent à l'écran pour les fatals débloqués (pas besoin de les mémoriser). Raté = victoire normale.
- **Fatals 100 % cartoon** : transformation, rapetissement, envoi en orbite, emballage… Ni sang ni démembrement (interdit par Roblox hors 17+, et on veut l'audience jeune).
- Par perso : **1 fatal offert, 2 à débloquer** (progression ou Robux, on en parlera à l'étape monétisation).

Légende : ★ = difficulté (★ facile, ★★★ technique).

---

## 2. Les 20 combattants

### 1. Gégé le Pochtron
**Look** : bonnet de travers, marcel taché, nez rouge qui clignote, bouteille verte de « soda douteux » qui pétille bizarrement et n'est jamais vide.
**Style** : Piégeur imprévisible ★★ · **Mécanique** : *Jauge de Bulles* (3 gorgées de soda douteux). Chaque gorgée renforce ses coups mais il titube ; à 3, ses déplacements deviennent illisibles pour l'adversaire.

**Normaux** — P Coup de goulot · K Savate molle · →P Revers de bouteille · →K Genou bancal · ↓P Croche-patte · ↓K Glissade sur flaque · ←P Hoquet repoussant (anti-air) · ←K Chute volontaire (esquive basse qui frappe) · saut P Bouteille plongeante · saut K Ruade titubante
**Chope** — *Accolade de pote* : « t'es mon meilleur ami toi », câlin, puis il le pousse par terre.
**Spéciaux**
- S **Jet de soda douteux** : giclée pétillante qui **inverse gauche/droite** de l'adversaire pendant 3 s.
- →S Bouteille lancée : projectile en cloche qui rebondit une fois.
- ←S Rot sonique : onde courte qui repousse.
- ↓S Petite gorgée : +1 gorgée (vulnérable pendant l'animation).
- ↑S Lampadaire : un lampadaire pousse du sol, il s'y accroche et retombe pied en avant.
- S maintenu : Haleine-briquet, flamme cartoon devant lui (plus long = plus loin).
- →→S Titubade folle : avance en zigzag et encaisse un coup sans broncher.
- (saut) S Plongeon du comptoir.
**Supers** — ⭐ *Tournée générale* : 6 bouteilles en éventail, chaque touche inverse les commandes · ↓⭐ *Karaoké de fin de soirée* : il chante faux, ondes qui étourdissent tout l'écran 2 s.
**Recharge ⚡** (maintenir O / bouton ⚡, remplit la barre d'énergie des spéciaux) — boit au goulot à grandes gorgées en se tapotant la bedaine, puis lâche un petit rot (« GLOU GLOU »). *Codé dans le prototype v0.5.*

**Retour 🪂** (après une chute, protégé quelques instants sur sa plateforme) — descend du ciel assis sur une caisse de soda accrochée à un parachute, atterrit lourdement, lève la bouteille vers le public (« À LA VÔTRE ! »), une gorgée et un revers de manche. *Codé dans le prototype v0.6.*

**Saisie ✋** (bouton ✋ au contact, puis ✋ ou une flèche pour projeter) — Accolade de pote : bras grands ouverts, il serre l'adversaire contre sa bedaine. Devant : *Glissade de comptoir* (il le fait glisser comme un verre sur le zinc). Derrière : *Suplex de fin de soirée*. En l'air : *Bouteille vide au recyclage* (il le lance comme dans un conteneur). Au sol : *Assis sur le pote*. *Codé dans le prototype v0.7.*

**Avec les gants 🥊** (arme à ramasser : J et K changent de style) — La boxe de l'homme saoul : il tangue, tombe exprès en arrière pour mieux frapper bas, se penche en hamac pour esquiver puis contre-attaque, moulinets de bras. *Codé dans le prototype v0.7 (19 coups).*
**Coups fatals**
- →↓← ⭐ **La Dernière Tournée** : l'adversaire est aspiré dans la bouteille, bouchonné et posé sur une étagère, étiquette « Cuvée 2026 ».
- ↓↓↑ ⭐ **Gueule de bois** : l'adversaire s'endort, Gégé lui dessine une moustache au feutre et s'endort à côté. Ronflements en stéréo.
- ←→→ ⭐ **Le Bouchon** : Gégé secoue la bouteille, le bouchon part avec l'adversaire dessus ; on le voit passer en étoile filante.

---

### 2. Mamie Tricot (Germaine)
**Look** : 1,40 m, lunettes triple foyer, châle, sac à main en cuir, deux chats sur les épaules.
**Style** : Zoneuse ★★★ · **Mécanique** : *Pelotes-pièges* (3 max au sol).

**Normaux** — P Coup de sac à main · K Coup de canne · →P Aiguille à tricoter (longue portée) · →K Pantoufle · ↓P Pincement de joue · ↓K Balayage de canne · ←P Parapluie (anti-air) · ←K Recul prudent · saut P Sac plongeant · saut K Dentier volant qui mord
**Chope** — *Bisou baveux* : l'adversaire est étourdi de honte.
**Spéciaux**
- S Pelote lancée : projectile droit.
- →S Lancer de chat : le chat griffe 3 fois puis revient.
- ←S Pose de pelote : piège au sol qui ligote 1 s.
- ↓S Écharpe-fouet : longue portée basse.
- ↑S Envol de châle : plane un court instant.
- S maintenu : Tricot express, un pull-bouclier qui absorbe le prochain projectile.
- →→S Charge du déambulateur.
- (saut) S Pluie de bonbons à la menthe en diagonale.
**Supers** — ⭐ *Armée de chats* : 6 chats chargent à travers l'écran · ↓⭐ *« De mon temps… »* : monologue interminable, l'adversaire s'endort 2,5 s.
**Recharge ⚡** (maintenir O / bouton ⚡, remplit la barre d'énergie des spéciaux) — s'assoit dans un rocking-chair qui sort du sol et tricote à toute vitesse pendant que les deux chats ronronnent.

**Retour 🪂** (après une chute, protégé quelques instants sur sa plateforme) — arrive dans son rocking-chair suspendu à une pelote de laine géante qui se déroule depuis le ciel, se lève en se tenant les reins et brandit ses aiguilles.

**Saisie ✋** (bouton ✋ au contact, puis ✋ ou une flèche pour projeter) — Prise au sac à main : elle accroche le cou de l'adversaire avec la anse. Devant : *Coup de cabas* qui l'envoie valser. Derrière : *Retour à l'envoyeur* par-dessus l'épaule. En l'air : *Chat lancé* (les deux chats le propulsent). Au sol : *Assis sur le tabouret* (elle s'assoit dessus en tricotant).

**Avec les gants 🥊** (arme à ramasser : J et K changent de style) — Boxe de mamie : petits coups secs et précis en gardant les coudes collés, s'arrête au milieu d'un combo pour remonter ses lunettes, finit par un uppercut « de mon temps on savait se battre ».
**Coups fatals**
- ↓→↓ ⭐ **Le Pull de Noël** : tricoté dans un pull géant et moche, seule la tête dépasse, photo de famille forcée.
- ←←→ ⭐ **Finis ta soupe** : l'adversaire rétrécit et finit dans un bol de soupe.
- ↑↓↑ ⭐ **La Pelote** : roulé en pelote, les chats se le renvoient jusqu'à ce qu'il roule hors de l'écran.

---

### 3. Dylan le Livreur
**Look** : casque avec support smartphone, sac cube isotherme énorme, trottinette électrique, toujours en retard.
**Style** : Rushdown ★★ · **Mécanique** : *Note client* (1 à 5 étoiles). Enchaîner monte la note et sa vitesse ; se faire toucher la fait baisser.

**Normaux** — P Jab de klaxon · K Coup de trottinette · →P Coup de sac cube · →K Kick de béquille · ↓P Ticket de caisse coupant · ↓K Roue avant dans le tibia · ←P Uppercut casque (anti-air) · ←K Freinage arrière · saut P Colis piqué · saut K Wheelie aérien
**Chope** — *Signature électronique* : fait signer l'adversaire sur le téléphone puis lui écrase le colis sur la tête.
**Spéciaux**
- S Pizza frisbee : projectile rapide.
- →S Rush trottinette : dash percutant sur tout l'écran.
- ←S « Livré ! » : pose un colis piégé qui explose en confettis.
- ↓S Dérapage : balayage long.
- ↑S Saut de trottoir (anti-air).
- S maintenu : Charge batterie, rallonge le prochain rush.
- →→S Raccourci GPS : courte téléportation derrière l'adversaire.
- (saut) S Livraison parachutée.
**Supers** — ⭐ *Commande groupée* : 20 colis tombent du ciel · ↓⭐ *Mode Turbo* : vitesse x2 pendant 5 s.
**Recharge ⚡** (maintenir O / bouton ⚡, remplit la barre d'énergie des spéciaux) — regarde son téléphone sur le casque, valide une livraison (« ding, +1 pourboire ») et pique une frite dans le sac isotherme.

**Retour 🪂** (après une chute, protégé quelques instants sur sa plateforme) — descend en trottinette électrique sur un gros colis en parachute, sonne au bout du doigt (« Livraison ! ») et fait signer le vide.

**Saisie ✋** (bouton ✋ au contact, puis ✋ ou une flèche pour projeter) — Prise de colis : il soulève l'adversaire comme un carton fragile. Devant : *Livraison express* (lancer en courant). Derrière : *Retour colis* par-dessus la tête. En l'air : *Livraison par drone*. Au sol : *Colis écrasé* (il le pose et tamponne « endommagé »).

**Avec les gants 🥊** (arme à ramasser : J et K changent de style) — Boxe pressée : rafales ultra rapides sans regarder, l'œil sur son téléphone, jab-jab-jab puis crochet « j'ai une autre commande ».
**Coups fatals**
- →→↓ ⭐ **Retour à l'expéditeur** : emballé, scotché, étiquette « FRAGILE », chargé dans un camion.
- ↓←→ ⭐ **Livré en 30 minutes** : transformé en pizza 4 fromages et livré au public.
- ↑→↑ ⭐ **1 étoile** : une pluie d'avis « ★☆☆☆☆ » géants l'aplatit comme une crêpe.

---

### 4. Bernard du Guichet
**Look** : costume beige, lunettes en demi-lune, tampon encreur géant, mug « Vivement vendredi ».
**Style** : Contrôle ★★★ · **Mécanique** : *Paperasse*. Chaque touche colle un formulaire sur l'adversaire ; à 3, il est « en attente » (ralenti 2 s).

**Normaux** — P Coup de tampon · K Pied de chaise · →P Classeur claqué · →K Agrafeuse · ↓P Trombone piquant · ↓K Pied de bureau · ←P « Suivant ! » coup de mug (anti-air) · ←K Recul en chaise de bureau · saut P Tampon aérien · saut K Plongeon de dossier
**Chope** — *« Il manque un justificatif »* : il le renvoie au bout de l'écran.
**Spéciaux**
- S Avion en papier : projectile qui colle un formulaire.
- →S Tampon « REFUSÉ » : gros coup qui renverse.
- ←S File d'attente : une rangée de figurants bloque les projectiles.
- ↓S Pause café : petite régénération (vulnérable).
- ↑S Pile de dossiers qui monte (anti-air).
- S maintenu : Ticket numéroté, l'adversaire touché sera figé 1,5 s quand « son numéro est appelé ».
- →→S Glissade en chaise à roulettes.
- (saut) S Pluie de Post-it.
**Supers** — ⭐ *Grève générale* : tout le monde est figé 3 s sauf Bernard · ↓⭐ *Formulaire Cerfa 12-B* : mini-jeu, l'adversaire doit taper la séquence affichée sinon il prend de gros dégâts.
**Recharge ⚡** (maintenir O / bouton ⚡, remplit la barre d'énergie des spéciaux) — tamponne une pile de formulaires à la chaîne (CHTONK CHTONK) et sirote son mug « Vivement vendredi ».

**Retour 🪂** (après une chute, protégé quelques instants sur sa plateforme) — tombe assis derrière son guichet qui se pose en grinçant, tamponne un ticket « VOTRE TOUR » et rabat la vitre d'un coup sec.

**Saisie ✋** (bouton ✋ au contact, puis ✋ ou une flèche pour projeter) — Prise administrative : il attrape l'adversaire par le col en soupirant. Devant : *Dossier refusé* (coup de tampon qui l'expulse). Derrière : *Au service d'à côté*. En l'air : *Classement vertical* (il le range tout en haut d'une étagère imaginaire). Au sol : *Mis en attente* (il le plaque et pose son mug dessus).

**Avec les gants 🥊** (arme à ramasser : J et K changent de style) — Boxe réglementaire : un coup, une pause pour vérifier un formulaire, un coup ; ses combos sont lents mais chaque crochet tamponne un formulaire de Paperasse.
**Coups fatals**
- ←↓← ⭐ **Classé sans suite** : aplati dans un classeur, rangé dans une archive qui défile à l'infini.
- →↑→ ⭐ **Revenez demain** : jour/nuit en accéléré, l'adversaire attend toujours au guichet avec une barbe blanche jusqu'aux pieds.
- ↓↓↓ ⭐ **VALIDÉ** : un tampon géant l'imprime à plat sur le sol comme un autocollant.

---

### 5. Chef Flambé
**Look** : toque d'un mètre, moustache en guidon, tablier taché de sauce, poêle et rouleau à pâtisserie.
**Style** : Polyvalent ★★ · **Mécanique** : *Cuisson*. Ses coups de feu laissent une brûlure cartoon (visage noirci, dégâts dans la durée).

**Normaux** — P Coup de louche · K Sabot de cuisine · →P Poêle frontale · →K Rouleau à pâtisserie · ↓P Fouet rapide · ↓K Balayage de tablier · ←P Couvercle (anti-air) · ←K Retourné de crêpe · saut P Poêle en chute · saut K Coup de toque
**Chope** — *Assaisonnement* : sel, poivre, éternuement, claque de poêle.
**Spéciaux**
- S Crêpe volante : projectile planant.
- →S Flambage : jet de flammes court.
- ←S Sol huilé : flaque glissante.
- ↓S Oignon émincé : l'adversaire pleure, son écran devient flou 2 s.
- ↑S Sauté à la poêle : fait sauter l'adversaire comme une crêpe (anti-air).
- S maintenu : Mijotage, la prochaine attaque brûle.
- →→S Service rapide (dash avec plateau).
- (saut) S Pluie de spaghettis qui ligote.
**Supers** — ⭐ *Flambée Impériale* : colonne de feu géante · ↓⭐ *Menu Dégustation* : enchaînement de 7 plats servis au visage.
**Recharge ⚡** (maintenir O / bouton ⚡, remplit la barre d'énergie des spéciaux) — goûte sa sauce à la cuillère, sale d'un geste théâtral du coude et embrasse ses doigts (« Parfait ! »).

**Retour 🪂** (après une chute, protégé quelques instants sur sa plateforme) — atterrit dans une marmite géante qui fume, en sort d'un bond en faisant tourner sa poêle et lance « Service ! ».

**Saisie ✋** (bouton ✋ au contact, puis ✋ ou une flèche pour projeter) — Prise du chef : il saisit l'adversaire comme un poulet à farcir. Devant : *Envoyé en salle* (lancé comme une assiette). Derrière : *Retourné à la poêle* (comme une crêpe). En l'air : *Flambé* (il le fait sauter et souffle une flamme dessous). Au sol : *Écrasé au rouleau*.

**Avec les gants 🥊** (arme à ramasser : J et K changent de style) — Boxe de cuisine : enchaînements de hachoir, crochets qui « assaisonnent », le dernier coup laisse une brûlure cartoon (gant fumant).
**Coups fatals**
- →↓→ ⭐ **Le Soufflé** : l'adversaire gonfle comme un soufflé et s'envole par la cheminée.
- ←→↓ ⭐ **Croque-Monsieur** : coincé entre deux tranches de pain géantes, passé au grill, ressort en sandwich grognon.
- ↓↑↓ ⭐ **Zéro étoile** : un critique gastronomique lui colle « 0 étoile » et on l'emporte sur un plateau d'argent.

---

### 6. Marcel le Mime
**Look** : visage blanc, marinière, béret, ne parle jamais (ses bulles de dialogue sont vides).
**Style** : Défense et pièges ★★★ · **Mécanique** : *Murs invisibles* (2 max) qui bloquent projectiles et adversaires.

**Normaux** — P Fausse claque · K Pied imaginaire · →P Corde tirée (attire) · →K Canne invisible · ↓P Marche d'escalier invisible · ↓K Glissade « contre le vent » · ←P Parapluie invisible (anti-air) · ←K Moonwalk arrière · saut P Ascenseur qui descend · saut K Ballon invisible
**Chope** — *La Boîte* : enferme l'adversaire, qui tape contre les parois.
**Spéciaux**
- S Mur invisible : en pose un.
- →S Corde invisible : tire l'adversaire vers lui.
- ←S Contre silencieux : parade qui renvoie le coup.
- ↓S Peau de banane invisible : piège glissade.
- ↑S Échelle invisible : grimpe puis plonge.
- S maintenu : Vent violent, repousse fort.
- →→S Vélo invisible (dash).
- (saut) S Piano invisible lâché.
**Supers** — ⭐ *Le Silence* : pendant 4 s, l'adversaire n'a plus de son ni d'interface (barres de vie et jauges invisibles) · ↓⭐ *La Boîte ultime* : cage invisible + combo.
**Recharge ⚡** (maintenir O / bouton ⚡, remplit la barre d'énergie des spéciaux) — se branche une pompe à vélo invisible dans le nombril et se regonfle, bulle de dialogue vide qui grossit.

**Retour 🪂** (après une chute, protégé quelques instants sur sa plateforme) — descend lentement accroché à un ballon invisible, le lâche, ouvre une porte invisible et salue le public.

**Saisie ✋** (bouton ✋ au contact, puis ✋ ou une flèche pour projeter) — Prise invisible : il mime une corde, et l'adversaire se retrouve vraiment attaché. Devant : *Tir à la corde* (il tire et l'adversaire part). Derrière : *Valise lourde* (il le soulève en peinant et le jette). En l'air : *Lâcher de ballon*. Au sol : *Coincé dans la boîte* (il referme les parois invisibles).

**Avec les gants 🥊** (arme à ramasser : J et K changent de style) — Boxe mimée : il frappe dans le vide à côté, mais les coups touchent quand même ; fait semblant de se prendre un mur invisible pour esquiver, puis riposte.
**Coups fatals**
- ←→← ⭐ **La Boîte** : il plie la boîte invisible encore et encore jusqu'à la taille d'un mouchoir, qu'il range dans sa poche.
- ↓↓→ ⭐ **Le Piano** : on n'entend qu'un « plonk », l'adversaire reste aplati comme un tapis.
- ↑←↑ ⭐ **Le Ballon** : il gonfle l'adversaire comme un ballon et le lâche au vent.

---

### 7. Bébé Colosse
**Look** : bébé de 2,50 m en couche, tétine, bonnet à oreilles d'ours, hochet géant.
**Style** : Choppeur ★★ · **Mécanique** : *Caprice*. Les coups reçus remplissent une jauge ; pleine, il pique une crise et encaisse sans broncher 5 s.

**Normaux** — P Hochet · K Petit pied potelé · →P Gifle de bébé · →K Coup de couche · ↓P Pincement · ↓K Roulade à quatre pattes · ←P Tétine (anti-air) · ←K Assis par terre (garde basse) · saut P Plat ventre · saut K Atterrissage fesses
**Chope** — *Câlin d'ours* : serre très fort.
**Spéciaux**
- S Purée lancée : projectile qui ralentit.
- →S Charge à quatre pattes : chope à l'impact.
- ←S Biberon : se soigne (vulnérable).
- ↓S Colère : fait trembler le sol, renverse.
- ↑S Saut du lit : chope aérienne.
- S maintenu : Hurlement, onde de cri chargée.
- →→S Rampe éclair.
- (saut) S Plongeon dodo (chope en chute).
**Supers** — ⭐ *Crise de larmes* : un torrent de larmes balaie l'écran · ↓⭐ *« Encore ! »* : fait tourner l'adversaire comme un jouet 10 fois et le jette.
**Recharge ⚡** (maintenir O / bouton ⚡, remplit la barre d'énergie des spéciaux) — tète un biberon géant assis par terre, puis rot de bébé qui fait trembler l'écran.

**Retour 🪂** (après une chute, protégé quelques instants sur sa plateforme) — arrive dans un landau volant tiré par des cigognes, en sort à quatre pattes puis se dresse en tapant sur son torse avec son hochet.

**Saisie ✋** (bouton ✋ au contact, puis ✋ ou une flèche pour projeter) — Câlin de bébé : il serre l'adversaire comme un doudou. Devant : *Jouet jeté* hors du parc. Derrière : *Pas mangé !* (il le jette par-dessus l'épaule comme une assiette de purée). En l'air : *Avion ! Vroum !* Au sol : *Assis sur le doudou*.

**Avec les gants 🥊** (arme à ramasser : J et K changent de style) — Boxe de colère : moulinets maladroits des deux bras en pleurant, gros coups lents mais énormes, finit par taper des pieds au sol.
**Coups fatals**
- →←↓ ⭐ **Le Doudou** : l'adversaire rétrécit en peluche, Bébé le câline et s'endort.
- ↓→↑ ⭐ **La Berceuse** : un mobile géant descend, l'adversaire y est accroché et tourne en musique.
- ←↑→ ⭐ **Rangé !** : jeté dans le coffre à jouets, le couvercle claque.

---

### 8. Gloria Zumba
**Look** : justaucorps fluo, bandeau, jambières, enceinte portable à l'épaule.
**Style** : Rythme ★★★ · **Mécanique** : *Tempo*. Un métronome visuel pulse ; les coups tapés sur le temps font +30 % de dégâts.

**Normaux** — P Clap · K High kick · →P Coude salsa · →K Grand écart frappé · ↓P Squat-punch · ↓K Twist balayé · ←P Bras en l'air (anti-air) · ←K Pas chassé arrière · saut P Saut étoile · saut K Ciseaux aériens
**Chope** — *Tango forcé* : fait danser l'adversaire puis le renverse.
**Spéciaux**
- S Onde de basse : projectile sonore.
- →S Pas de conga : avance en plusieurs coups.
- ←S Pirouette : esquive tournante qui frappe.
- ↓S Piétinement sismique : onde au sol.
- ↑S Saut pom-pom (anti-air).
- S maintenu : Échauffement, bonus de vitesse.
- →→S Glissé disco : passe derrière l'adversaire.
- (saut) S Boule à facettes qui aveugle.
**Supers** — ⭐ *Cours collectif* : l'adversaire est forcé de danser 3 s ; s'il réussit les flèches affichées, il se libère plus vite · ↓⭐ *Final disco*.
**Recharge ⚡** (maintenir O / bouton ⚡, remplit la barre d'énergie des spéciaux) — pas de zumba sur place, bras en l'air, l'enceinte crache trois notes (« WOOH ! »).

**Retour 🪂** (après une chute, protégé quelques instants sur sa plateforme) — descend sur une boule à facettes géante en tournant, saute au sol en écart et pointe le doigt (« ON SE BOUGE ! »).

**Saisie ✋** (bouton ✋ au contact, puis ✋ ou une flèche pour projeter) — Prise de danse : elle entraîne l'adversaire dans une salsa. Devant : *Passe et lâche* (elle le fait tourner et lâche). Derrière : *Renversé de tango*. En l'air : *Porté de lift*. Au sol : *Grand écart* (elle se laisse tomber en écart et l'écrase).

**Avec les gants 🥊** (arme à ramasser : J et K changent de style) — Boxe-fitness : coups en rythme de cardio-boxe (« et un, et deux ! »), les coups tapés sur le temps du métronome font plus mal.
**Coups fatals**
- →→← ⭐ **Jusqu'au bout de la nuit** : l'adversaire danse sans pouvoir s'arrêter et sort de l'écran en chenille avec le public.
- ↓↑→ ⭐ **100 burpees** : forcé à faire 100 burpees, il s'effondre en flaque de sueur cartoon.
- ←↓↑ ⭐ **Boule à facettes** : transformé en boule à facettes accrochée au plafond.

---

### 9. Lola Filtre
**Look** : perche à selfie, lunettes en cœur, ring light en bouclier, téléphone à paillettes.
**Style** : Zoneuse ★★ · **Mécanique** : *Likes*. Chaque touche rapporte des likes ; à 1 000 elle « devient virale » (dégâts et projectiles renforcés 8 s).

**Normaux** — P Coup de perche · K Talon compensé · →P Ring light · →K Kick « pose photo » · ↓P Coup de smartphone · ↓K Glissade tendance · ←P Selfie vertical (flash anti-air) · ←K « Pas de photo ! » (recul) · saut P Perche plongeante · saut K Saut photogénique
**Chope** — *Selfie forcé* : photo avec l'adversaire, puis poussée.
**Spéciaux**
- S Flash : écran blanc chez l'adversaire 0,5 s.
- →S Hashtag lancé : projectile en forme de #.
- ←S Bloquer l'utilisateur : contre.
- ↓S Filtre chien : l'adversaire a des oreilles de chien et une portée réduite 3 s.
- ↑S Drone caméra qui tire en diagonale.
- S maintenu : Live, génère des likes.
- →→S Swipe (dash latéral).
- (saut) S Pluie de cœurs.
**Supers** — ⭐ *Virale* : avalanche de notifications · ↓⭐ *Collab* : un personnage aléatoire du roster débarque en assist (bonne vitrine pour les persos à débloquer).
**Recharge ⚡** (maintenir O / bouton ⚡, remplit la barre d'énergie des spéciaux) — selfie à la perche sous la ring light, des cœurs de likes montent et remplissent la barre.

**Retour 🪂** (après une chute, protégé quelques instants sur sa plateforme) — tombe sur une ring light plantée au sol, prend la pose en selfie, flash, puis cache son téléphone dans sa poche arrière.

**Saisie ✋** (bouton ✋ au contact, puis ✋ ou une flèche pour projeter) — Prise selfie : elle colle sa joue à celle de l'adversaire pour une photo. Devant : *Story en direct* (le flash l'aveugle et elle le pousse). Derrière : *Unfollow* (elle le jette derrière sans regarder). En l'air : *Mise en avant* (perche à selfie qui le propulse). Au sol : *Filtre écrasé*.

**Avec les gants 🥊** (arme à ramasser : J et K changent de style) — Boxe pour la caméra : elle pose entre chaque coup, garde un bras tendu vers le téléphone ; chaque touche rapporte des likes.
**Coups fatals**
- ↑↑↓ ⭐ **Filtre permanent** : l'adversaire reste coincé avec des oreilles de chien et la langue pendante.
- →↓← ⭐ **Story 24 h** : aplati dans un cadre photo, il disparaît quand le chrono « 24h » tombe à zéro.
- ↓←↓ ⭐ **Unfollow** : il se pixelise et part à la corbeille avec un « pouf ».

---

### 10. Jordan « RageQuit »
**Look** : casque gamer RGB, sweat à capuche, paquet de chips, manette filaire en nunchaku.
**Style** : Rushdown ★★★ · **Mécanique** : *Rage*. Monte quand il prend des coups ; à 100 % il « tilte » : +50 % de dégâts mais plus de garde.

**Normaux** — P Coup de manette · K Coup de chaise gaming · →P Câble-fouet · →K Clavier volant · ↓P Souris balancée · ↓K Glissade à roulettes · ←P Casque (anti-air) · ←K Esquive « AFK » · saut P Combo manette · saut K Smash de manette
**Chope** — *Spam bouton* : chope en rafale.
**Spéciaux**
- S Paquet de chips : projectile de miettes.
- →S Combo nunchaku-manette.
- ←S Freeze : l'adversaire touché saccade 1 s (*voir remarque faisabilité*).
- ↓S Câble tendu : piège qui fait trébucher.
- ↑S Rage jump (anti-air).
- S maintenu : Ventilo RGB, onde qui repousse.
- →→S Speedrun : dash traversant.
- (saut) S Écran bleu : chute qui fige 0,5 s à l'impact.
**Supers** — ⭐ *Rage Quit* : il casse tout, pluie de touches de clavier · ↓⭐ *Code de triche* : invincible 3 s, aura « GOD MODE ».
**Recharge ⚡** (maintenir O / bouton ⚡, remplit la barre d'énergie des spéciaux) — s'enfile une poignée de chips et martèle sa manette, le casque RGB clignote de plus en plus vite.

**Retour 🪂** (après une chute, protégé quelques instants sur sa plateforme) — réapparaît en pixels qui se recomposent comme un jeu qui recharge (« RESPAWN »), crie « LAG ! » et remet son casque.

**Saisie ✋** (bouton ✋ au contact, puis ✋ ou une flèche pour projeter) — Prise de rage : il attrape l'adversaire par la capuche. Devant : *Alt+F4* (lancé dans l'écran). Derrière : *Câble arraché* (comme une manette par-dessus l'épaule). En l'air : *Lancer de manette*. Au sol : *Clavier cassé* (il tape dessus comme sur des touches).

**Avec les gants 🥊** (arme à ramasser : J et K changent de style) — Boxe de tilt : rafales de coups frénétiques comme du « button mashing », de plus en plus rapides quand la rage monte.
**Coups fatals**
- ↓→→ ⭐ **Game Over** : l'adversaire devient du pixel art 8-bit et se désagrège.
- ←←↓ ⭐ **Ctrl+Z** : l'adversaire est rembobiné jusqu'à disparaître dans l'écran titre.
- ↑→↓ ⭐ **Désinstallé** : barre « Désinstallation… 100 % », l'adversaire s'efface.

---

### 11. Dr Fraise, dentiste
**Look** : blouse blanche, lampe frontale, sourire éblouissant, fraise de dentiste géante, fauteuil à roulettes.
**Style** : Contrôle ★★ · **Mécanique** : *Fou rire*. Le gaz hilarant empêche l'adversaire d'utiliser K et ⭐ pendant 3 s.

**Normaux** — P Miroir dentaire · K Pédale de fauteuil · →P Fraise vrombissante · →K Genou stérile · ↓P Fil dentaire · ↓K Fauteuil balayé · ←P Lampe aveuglante (anti-air) · ←K « Rincez ! » (recul) · saut P Pince plongeante · saut K Coup de fauteuil
**Chope** — *« Ouvrez grand »* : il arrache une dent cartoon, l'adversaire siffle en parlant le reste de la manche.
**Spéciaux**
- S Bulle de gaz hilarant : fou rire.
- →S Fraise perforante : coup en plusieurs touches.
- ←S Bain de bouche : flaque glissante.
- ↓S Lasso de fil dentaire : attire au sol.
- ↑S Fauteuil éjectable (anti-air).
- S maintenu : Anesthésie, les mouvements de l'adversaire deviennent mous.
- →→S Charge en fauteuil.
- (saut) S Pluie de dents en sucre.
**Supers** — ⭐ *Détartrage* : combo vrombissant · ↓⭐ *Grand fou rire* : gaz sur tout l'écran.
**Recharge ⚡** (maintenir O / bouton ⚡, remplit la barre d'énergie des spéciaux) — se brosse les dents à toute vitesse sur son fauteuil à roulettes, sourire qui étincelle (« TING ! »).

**Retour 🪂** (après une chute, protégé quelques instants sur sa plateforme) — descend assis sur son fauteuil de dentiste qui s'abaisse en sifflant, enfile un gant d'un claquement sec et sourit (« TING ! »).

**Saisie ✋** (bouton ✋ au contact, puis ✋ ou une flèche pour projeter) — Prise de dentiste : il installe l'adversaire dans son fauteuil à roulettes. Devant : *Ouvrez grand !* (le fauteuil part en roulant). Derrière : *Fauteuil basculé*. En l'air : *Extraction* (il le tire vers le haut comme une dent). Au sol : *Anesthésie* (il l'endort au sol).

**Avec les gants 🥊** (arme à ramasser : J et K changent de style) — Boxe chirurgicale : petits coups précis « au niveau des molaires », un uppercut qui fait rire l'adversaire.
**Coups fatals**
- →↓↑ ⭐ **Sourire parfait** : un sourire si éclatant que l'adversaire s'aveugle lui-même et tombe.
- ↓→↓ ⭐ **Appareil dentaire** : ficelé dans un appareil géant, il ne peut plus bouger.
- ←→↑ ⭐ **La petite souris** : une souris l'emporte sous un oreiller et laisse une pièce à la place.

---

### 12. Sumo Gélatine
**Look** : sumo fait de gelée verte translucide ; on voit un canard en plastique flotter dedans.
**Style** : Tank pour débutants ★ · **Mécanique** : *Rebond*. Les attaquants au corps à corps rebondissent légèrement sur lui.

**Normaux** — P Claque molle · K Shiko (piétinement) · →P Poussée de paume · →K Ventre-rebond · ↓P Coup de bide bas · ↓K Glissade gluante · ←P Bras-ressort (anti-air) · ←K Absorption (recul) · saut P Plat ventre · saut K Bombe gélatineuse
**Chope** — *Avalé tout cru* : coincé dans la gelée puis recraché.
**Spéciaux**
- S Boulette de gelée : projectile collant.
- →S Charge sumo.
- ←S Trampoline : renvoie les projectiles.
- ↓S Flaque : se liquéfie et passe sous les projectiles.
- ↑S Tremblote géante (anti-air).
- S maintenu : Gonflement, PV temporaires en plus mais plus lent.
- →→S Roulade gluante.
- (saut) S Splash.
**Supers** — ⭐ *Division* : se sépare en 3 mini-sumos pendant 6 s · ↓⭐ *Tsunami de gelée*.
**Recharge ⚡** (maintenir O / bouton ⚡, remplit la barre d'énergie des spéciaux) — rituel du sel puis il tape des pieds, toute la gelée tremblote et le canard en plastique tourne en rond.

**Retour 🪂** (après une chute, protégé quelques instants sur sa plateforme) — tombe du ciel, gros PLOUF qui fait trembler toute l'arène, la gelée oscille trois fois puis il lance du sel en l'air.

**Saisie ✋** (bouton ✋ au contact, puis ✋ ou une flèche pour projeter) — Absorption : l'adversaire s'enfonce dans sa gelée à côté du canard. Devant : *Recraché* (boing !). Derrière : *Rebond arrière*. En l'air : *Trampoline* (il le fait rebondir sur son ventre). Au sol : *Dodo dans la gelée* (il s'assoit dessus).

**Avec les gants 🥊** (arme à ramasser : J et K changent de style) — Boxe molle : ses gants rebondissent sur sa propre gelée, gros coups lents qui renvoient en ricochet, très facile à prendre en main.
**Coups fatals**
- ↓↓→ ⭐ **Le Dessert** : figé dans un moule à gelée, servi avec une cerise.
- →←→ ⭐ **Le Bain** : englouti, il flotte à côté du canard en plastique.
- ↑↓↓ ⭐ **Rebond infini** : rebondit sur le ventre du Sumo jusqu'à quitter l'atmosphère.

---

### 13. Ramsès le Patraque (momie hypocondriaque)
**Look** : momie aux bandelettes qui se défont, thermomètre en bouche, se plaint en permanence.
**Style** : Usure ★★ · **Mécanique** : *Contagion*. L'adversaire « enrhumé » éternue au hasard, ce qui coupe son action en cours.

**Normaux** — P Coup de bandelette · K Coup de sarcophage · →P Mouchoir-fouet · →K Pied plâtré · ↓P Thermomètre · ↓K Bandelette traînante · ←P Atchoum (anti-air) · ←K Malaise (esquive en tombant) · saut P Bandelette plongeante · saut K Sarcophage écrasé
**Chope** — *Momification* : l'enroule de bandelettes.
**Spéciaux**
- S Éternuement : projectile contagieux.
- →S Grappin de bandelette.
- ←S Arrêt maladie : invulnérable 1 s mais immobile.
- ↓S Mouchoirs usagés : pièges contagieux au sol.
- ↑S Sortie de sarcophage (anti-air).
- S maintenu : Fièvre, aura de chaleur.
- →→S Course en brancard.
- (saut) S Sirop gluant.
**Supers** — ⭐ *Le Grand Rhume* : nuage d'éternuements géant · ↓⭐ *Malédiction du pharaon* : nuée de scarabées cartoon.
**Recharge ⚡** (maintenir O / bouton ⚡, remplit la barre d'énergie des spéciaux) — se recolle des bandelettes avec du sparadrap, avale un comprimé et vérifie son thermomètre.

**Retour 🪂** (après une chute, protégé quelques instants sur sa plateforme) — sort d'un sarcophage qui se pose debout, éternue dans un nuage de poussière et réajuste ses bandelettes.

**Saisie ✋** (bouton ✋ au contact, puis ✋ ou une flèche pour projeter) — Prise momifiée : ses bandelettes s'enroulent autour de l'adversaire. Devant : *Toupie de bandelettes* (il tire, l'adversaire tourne et part). Derrière : *Sarcophage* (il le jette dans un sarcophage qui se referme et l'éjecte). En l'air : *Éternuement* (« ATCHOUM » qui le propulse). Au sol : *Pansement géant*.

**Avec les gants 🥊** (arme à ramasser : J et K changent de style) — Boxe hypocondriaque : il frappe en se plaignant (« aïe mon dos »), se tient le bras entre deux coups, un crochet sur trois fait éternuer l'adversaire.
**Coups fatals**
- ←↓→ ⭐ **Ne pas déranger** : momifié, rangé dans un sarcophage avec la pancarte.
- →↑← ⭐ **Le Grand Atchoum** : soufflé hors de la carte.
- ↓↓← ⭐ **Inapte** : reçoit un certificat « Inapte au combat » et repart dans une ambulance-jouet.

---

### 14. Capitaine Canard
**Look** : homme dans une bouée canard, masque de plongée, palmes, pistolet à eau.
**Style** : Aérien ★★ · **Mécanique** : *Flottaison*. Triple saut et plané ; jauge de pression d'eau pour ses tirs.

**Normaux** — P Coup de bouée · K Coup de palme · →P Jet court · →K Bec de bouée · ↓P Éclaboussure · ↓K Glissade palmée · ←P Bouée (anti-air) · ←K Dégonflage (recul) · saut P Plongeon bec · saut K Battement de palmes
**Chope** — *Bain forcé* : tête de l'adversaire plongée dans une piscine gonflable.
**Spéciaux**
- S Jet d'eau : projectile long.
- →S Torpille canard.
- ←S Coin-coin : onde qui étourdit.
- ↓S Piscine gonflable : zone qui ralentit.
- ↑S Envol de bouée : très haut, puis plane.
- S maintenu : Gonflage, rebondit sur le prochain coup reçu.
- →→S Toboggan aquatique.
- (saut) S Bombe à eau.
**Supers** — ⭐ *Raz-de-marée de canards en plastique* · ↓⭐ *Escadrille* : il s'envole et arrose tout l'écran.
**Recharge ⚡** (maintenir O / bouton ⚡, remplit la barre d'énergie des spéciaux) — gonfle sa bouée canard à la bouche, joues énormes, puis coin-coin de corne de brume.

**Retour 🪂** (après une chute, protégé quelques instants sur sa plateforme) — arrive en surfant sur sa bouée canard depuis une petite vague qui retombe, salut militaire et coin-coin de corne de brume.

**Saisie ✋** (bouton ✋ au contact, puis ✋ ou une flèche pour projeter) — Prise de bouée : il passe sa bouée canard autour de l'adversaire. Devant : *À l'eau !* (il le pousse comme dans une piscine). Derrière : *Plongeon arrière*. En l'air : *Jet de bouée* (il le gonfle et il s'envole). Au sol : *Bouée dégonflée* (il saute dessus, pschhh).

**Avec les gants 🥊** (arme à ramasser : J et K changent de style) — Boxe de plage : coups mouillés qui éclaboussent, avec des sauts de palmes ; ses gants font « couic » comme un jouet de bain.
**Coups fatals**
- ↑↑↑ ⭐ **Le Petit Bain** : transformé en canard en plastique dans une baignoire.
- →↓→ ⭐ **Le Dégonflé** : l'adversaire se dégonfle et s'envole en sifflant.
- ↓←↑ ⭐ **Les Dents de la piscine** : un requin gonflable l'avale et repart en surfant.

---

### 15. Gaston le Magnifique (magicien raté)
**Look** : cape trop grande, haut-de-forme avec un lapin grognon dedans, baguette qui crépite.
**Style** : Aléatoire ★★★ · **Mécanique** : *Tours ratés*. Chaque spécial a 3 résultats possibles ; l'icône du prochain résultat est affichée pour garder de la stratégie.

**Normaux** — P Coup de baguette · K Chaussure vernie · →P Cartes en éventail · →K Canne magique · ↓P Foulards sans fin · ↓K Trappe ratée · ←P Lapin mordeur (anti-air) · ←K Disparition ratée (recul en fumée) · saut P Chapeau plongeant · saut K Cape tournoyante
**Chope** — *Le Coffre* : enferme l'adversaire dans une boîte de magie, les épées ressortent avec des fleurs au bout.
**Spéciaux**
- S Tour aléatoire : colombe, confettis explosifs ou lapin.
- →S Cartes lancées.
- ←S Passe-passe : échange de position.
- ↓S Trappe : l'adversaire tombe et ressort du chapeau.
- ↑S Lévitation.
- S maintenu : Abracadabra, garantit le résultat du prochain tour.
- →→S Téléportation (rate parfois).
- (saut) S Pluie de colombes.
**Supers** — ⭐ *Le Grand Final* : rideau, l'adversaire disparaît et réapparaît étourdi · ↓⭐ *Vol à la tire* : vole la jauge Super adverse.
**Recharge ⚡** (maintenir O / bouton ⚡, remplit la barre d'énergie des spéciaux) — tente un tour de cartes, elles s'envolent partout ; le lapin grognon lui recharge la baguette à contrecœur.

**Retour 🪂** (après une chute, protégé quelques instants sur sa plateforme) — apparaît dans un nuage de fumée raté (il tousse), le lapin sort du chapeau, lève les yeux au ciel et lui rend sa baguette.

**Saisie ✋** (bouton ✋ au contact, puis ✋ ou une flèche pour projeter) — Prise magique : il fait disparaître l'adversaire dans son chapeau. Devant : *Et hop !* (il ressort devant, propulsé). Derrière : *Boîte coupée en deux* (elle se referme et l'éjecte derrière). En l'air : *Lapin furieux* (le lapin le bouscule vers le haut). Au sol : *Tour raté* (le chapeau lui tombe dessus).

**Avec les gants 🥊** (arme à ramasser : J et K changent de style) — Boxe de prestidigitateur : les gants changent de couleur à chaque coup et l'un des trois coups possibles part au hasard, avec l'icône du prochain affichée.
**Coups fatals**
- →←↑ ⭐ **La Disparition** : rideau, l'adversaire est devenu un lapin dans le chapeau.
- ↓↓↑ ⭐ **Coupé en deux** : tour de la boîte, les deux moitiés partent chacune de leur côté en se disputant.
- ←→↓ ⭐ **Tour raté** : Gaston se transforme lui-même en lapin, et c'est le vrai lapin qui achève l'adversaire d'une pichenette.

---

### 16. Gros Bob, le Yéti en vacances
**Look** : yéti en chemise hawaïenne, tongs, crème solaire sur le nez, glacière à la main.
**Style** : Choppeur ★★ · **Mécanique** : *Fraîcheur*. Jauge qui baisse quand il bouge ; haute, ses coups gèlent.

**Normaux** — P Claque poilue · K Coup de tong · →P Coup de glacière · →K Pied de yéti · ↓P Boule de neige basse · ↓K Glissade sur glace · ←P Parasol (anti-air) · ←K Bronzette (recul allongé) · saut P Avalanche de ventre · saut K Double tong
**Chope** — *Câlin glacial* : gèle l'adversaire et brise la glace.
**Spéciaux**
- S Boule de neige : projectile qui ralentit.
- →S Charge en luge.
- ←S Mur de glace.
- ↓S Granita : se soigne et remonte la fraîcheur.
- ↑S Avalanche ascendante (anti-air).
- S maintenu : Souffle polaire, gèle si chargé.
- →→S Glissade pingouin sur le ventre.
- (saut) S Grêlons.
**Supers** — ⭐ *Avalanche* · ↓⭐ *Bonhomme de neige* : chope qui transforme l'adversaire en bonhomme de neige, puis grosse claque.
**Recharge ⚡** (maintenir O / bouton ⚡, remplit la barre d'énergie des spéciaux) — se tartine de crème solaire, lunettes de soleil, et boit à la paille dans la glacière.

**Retour 🪂** (après une chute, protégé quelques instants sur sa plateforme) — descend en télésiège avec sa glacière et son transat, saute, enlève ses lunettes de soleil et grogne de plaisir.

**Saisie ✋** (bouton ✋ au contact, puis ✋ ou une flèche pour projeter) — Câlin glacé : il serre l'adversaire contre sa fourrure. Devant : *Glissade sur la banquise*. Derrière : *Bonhomme de neige jeté*. En l'air : *Boule de neige* (il le roule en boule et le lance). Au sol : *Assis sur la glacière*.

**Avec les gants 🥊** (arme à ramasser : J et K changent de style) — Boxe de yéti : gros coups lourds de paluche en tongs ; quand sa Fraîcheur est haute, les gants gèlent l'adversaire.
**Coups fatals**
- ↓→← ⭐ **Esquimau** : glacé sur un bâton et rangé dans la glacière.
- →→↑ ⭐ **Coup de soleil** : devient rouge homard et s'enfuit dans la mer.
- ←↓↓ ⭐ **Bonhomme de neige** : carotte en guise de nez, et un pigeon du Roi Pigeon vient s'y poser.

---

### 17. R-0B0, l'aspirateur
**Look** : robot aspirateur rond devenu humanoïde, tuyau en guise de bras, voix synthétique très polie.
**Style** : Anti-projectiles ★★ · **Mécanique** : *Réservoir*. Il aspire les projectiles adverses et peut les recracher.

**Normaux** — P Brosse rotative · K Coup de roulette · →P Tuyau-poing · →K Pare-chocs · ↓P Brosse basse · ↓K Coup de balai · ←P Aspiration verticale (anti-air) · ←K Retour à la base (recul) · saut P Tuyau plongeant · saut K Atterrissage capteur
**Chope** — *Aspiration du visage*.
**Spéciaux**
- S Aspiration : avale un projectile ou attire l'adversaire.
- →S Recrachat : renvoie ce qui est stocké.
- ←S Mode bordure : longe et passe derrière.
- ↓S Sac à poussière : nuage aveuglant.
- ↑S Turbo vertical (anti-air).
- S maintenu : Puissance max, attraction forte.
- →→S Nettoyage programmé : dash en zigzag.
- (saut) S Chute du disque.
**Supers** — ⭐ *Grand ménage* : tornade d'aspiration · ↓⭐ *Mise à jour* : 3 s de vitesse et d'armure.
**Recharge ⚡** (maintenir O / bouton ⚡, remplit la barre d'énergie des spéciaux) — se branche à une prise qui sort du sol, une barre de batterie s'affiche au-dessus de lui (« Recharge en cours, merci de patienter »).

**Retour 🪂** (après une chute, protégé quelques instants sur sa plateforme) — se pose sur son socle de charge, bip de démarrage, ses voyants clignotent et il fait un tour sur lui-même (« Nettoyage en cours »).

**Saisie ✋** (bouton ✋ au contact, puis ✋ ou une flèche pour projeter) — Aspiration : son tuyau colle l'adversaire. Devant : *Sac à poussière vidé* (il le recrache). Derrière : *Rejet par l'arrière*. En l'air : *Mode souffleur*. Au sol : *Nettoyage en profondeur* (il passe et repasse dessus).

**Avec les gants 🥊** (arme à ramasser : J et K changent de style) — Boxe programmée : coups en séquence parfaite « Enchaînement n°3, veuillez patienter », sa voix polie annonce chaque coup.
**Coups fatals**
- →→→ ⭐ **Aspiré** : on voit l'adversaire tourner dans le réservoir transparent.
- ↓↑← ⭐ **Sac plein** : vidé dans la poubelle. « Merci de votre confiance. »
- ←↓→ ⭐ **Erreur 404** : adversaire introuvable, il ne reste que ses chaussures.

---

### 18. Papi DJ (Gérard, 78 ans)
**Look** : lunettes noires, casque énorme, chaînes dorées, platines montées sur un tricycle.
**Style** : Zoneur sonore ★★ · **Mécanique** : *Playlist*. 3 morceaux qui changent ses bonus (Rap = vitesse, Slow = soin, Techno = dégâts).

**Normaux** — P Coup de vinyle · K Coup de charentaise · →P Scratch (double frappe) · →K Pied de micro · ↓P Bouton de volume · ↓K Câble jack · ←P Casque (anti-air) · ←K Rewind (recul) · saut P Vinyle plongeant · saut K Saut de scène
**Chope** — *Mégaphone* : lui hurle dans l'oreille.
**Spéciaux**
- S Vinyle-boomerang.
- →S Drop des basses : onde.
- ←S Rewind : revient à sa position d'il y a 2 s.
- ↓S Mur d'enceintes : bloque les projectiles.
- ↑S Slam (anti-air).
- S maintenu : Changer de piste.
- →→S Pas de danse rétro (dash).
- (saut) S Pluie de vinyles.
**Supers** — ⭐ *Le Drop ultime* · ↓⭐ *Le Slow* : l'adversaire est forcé de danser un slow pendant que Papi se soigne.
**Recharge ⚡** (maintenir O / bouton ⚡, remplit la barre d'énergie des spéciaux) — scratche sur ses platines, casque sur une oreille, déhanché raide, puis se tient le dos.

**Retour 🪂** (après une chute, protégé quelques instants sur sa plateforme) — descend sur ses platines suspendues à une boule à facettes, scratche une fois, se tient le dos puis lève le poing.

**Saisie ✋** (bouton ✋ au contact, puis ✋ ou une flèche pour projeter) — Prise de piste : il attrape l'adversaire et le fait tourner comme un vinyle. Devant : *Scratch* (il le lâche en plein scratch). Derrière : *Retour arrière* (rewind). En l'air : *Montée du son* (les basses le soulèvent). Au sol : *Drop* (tout s'arrête, puis boum).

**Avec les gants 🥊** (arme à ramasser : J et K changent de style) — Boxe à l'ancienne : garde de boxeur des années 60, petits pas de danse, coups au rythme du morceau en cours de sa Playlist.
**Coups fatals**
- →↓↓ ⭐ **Disque rayé** : l'adversaire répète le même mouvement en boucle jusqu'à disparaître.
- ↑↑→ ⭐ **Le 45 tours** : pressé en vinyle et posé sur la platine.
- ←→← ⭐ **Les Basses** : si fortes que l'adversaire vibre et part s'encastrer dans la boule à facettes.

---

### 19. Le Roi Pigeon
**Look** : marquis déchu en cape de plumes, couronne en capsule, une cinquantaine de pigeons sur lui. Il roucoule.
**Style** : Invocateur ★★★ · **Mécanique** : *Nuée* (6 pigeons max), qu'il envoie indépendamment.

**Normaux** — P Coup de baguette de pain · K Coup de pied royal · →P Baguette en estoc · →K Ruade de plumes · ↓P Picorage · ↓K Miettes glissantes · ←P Envol de pigeons (anti-air) · ←K Battement d'ailes (recul) · saut P Piqué · saut K Serres
**Chope** — *Roucoulade* : les pigeons picorent l'adversaire.
**Spéciaux**
- S Pigeon envoyé : projectile lent à tête chercheuse.
- →S Charge de la nuée.
- ←S Bouclier de plumes.
- ↓S Miettes : appât au sol, les pigeons foncent dessus (piège).
- ↑S Envol porté par les pigeons.
- S maintenu : Appel de la nuée, recharge les pigeons.
- →→S Dash de plumes.
- (saut) S Piqué collectif.
**Supers** — ⭐ *La Grande Volée* : 100 pigeons traversent l'écran · ↓⭐ *La Statue* : l'adversaire devient une statue de place publique 2 s, couverte de pigeons.
**Recharge ⚡** (maintenir O / bouton ⚡, remplit la barre d'énergie des spéciaux) — picore des miettes avec ses pigeons et se lisse les plumes de la cape en roucoulant.

**Retour 🪂** (après une chute, protégé quelques instants sur sa plateforme) — arrive porté par une nuée de pigeons qui le déposent, il réajuste sa couronne pendant qu'ils se posent sur ses épaules.

**Saisie ✋** (bouton ✋ au contact, puis ✋ ou une flèche pour projeter) — Prise de la nuée : les pigeons agrippent l'adversaire. Devant : *Envol royal* (la nuée l'emporte devant). Derrière : *Lâcher royal* (ils le lâchent derrière). En l'air : *Montgolfière de plumes*. Au sol : *Le trône* (le Roi s'assoit dessus, les pigeons applaudissent).

**Avec les gants 🥊** (arme à ramasser : J et K changent de style) — Boxe de cour : coups maniérés du bout des gants, petit doigt levé ; à chaque touche un pigeon picore en plus.
**Coups fatals**
- ↑→↑ ⭐ **Statue de bronze** : figé en statue, pigeons perchés dessus pour l'éternité.
- ↓→↓ ⭐ **Emporté** : la nuée l'emporte, on le voit passer devant la lune.
- ←←→ ⭐ **Le Nid** : transformé en nid ; l'œuf éclot et en sort un mini Roi Pigeon.

---

### 20. Madame Ventouse, plombière
**Look** : salopette, casquette à l'envers, ventouse géante, clé à molette, ceinture d'outils.
**Style** : Mobilité ★★ · **Mécanique** : *Grappin*. Sa ventouse s'accroche aux murs et au plafond de l'arène.

**Normaux** — P Clé à molette · K Coup de botte · →P Ventouse frontale (colle) · →K Coup de tuyau · ↓P Serre-joint · ↓K Glissade dans l'eau · ←P Ventouse (anti-air) · ←K Roulade arrière · saut P Ventouse plongeante · saut K Rodéo sur tuyau
**Chope** — *Débouchage* : ventouse sur le visage, « POP ! ».
**Spéciaux**
- S Jet de fuite : projectile d'eau.
- →S Ventouse grappin : attire l'adversaire.
- ←S Grappin mural : se propulse vers le mur arrière.
- ↓S Inondation : flaque glissante.
- ↑S Ventouse au plafond : se suspend.
- S maintenu : Pression, geyser chargé.
- →→S Glissade dans un tuyau : passe sous l'adversaire.
- (saut) S Chute ventouse.
**Supers** — ⭐ *Rupture de canalisation* : geysers sur tout le sol · ↓⭐ *Le Grand Débouchage* : ventouse géante qui aspire et recrache.
**Recharge ⚡** (maintenir O / bouton ⚡, remplit la barre d'énergie des spéciaux) — débouche un évier invisible à la ventouse, gros « GLOUGLOU » puis pouce levé.

**Retour 🪂** (après une chute, protégé quelques instants sur sa plateforme) — surgit d'une bouche d'égout comme un bouchon de champagne (POP), atterrit et fait tourner sa ventouse comme un revolver.

**Saisie ✋** (bouton ✋ au contact, puis ✋ ou une flèche pour projeter) — Prise à la ventouse : elle colle sa ventouse sur l'adversaire. Devant : *Débouchage* (pop ! il part). Derrière : *Clé à molette* (elle le fait tourner et le lance derrière). En l'air : *Grappin* (elle le tire vers le plafond). Au sol : *Au fond du siphon*.

**Avec les gants 🥊** (arme à ramasser : J et K changent de style) — Boxe de chantier : coups de gants serrés comme un écrou, uppercut « ça va débloquer », se sert du grappin pour rebondir entre deux coups.
**Coups fatals**
- ↓↓↑ ⭐ **Glouglou** : englouti par une bonde d'évier géante.
- →←→ ⭐ **Le Réseau** : aspiré dans un tuyau transparent, il voyage dans toute la tuyauterie et ressort goutte à goutte d'un robinet.
- ↑→↓ ⭐ **Ventouse à vie** : ventouse collée sur la tête, il ne peut plus l'enlever et part en boudant.

---

## 3. Avis franc sur la faisabilité

### En résumé
**Le concept est faisable sur Roblox, mais pas 20 persos d'un coup.** Le vrai mur, c'est le volume d'animations, pas la programmation.

### Contrôles mobiles : ✅ faisable
- La grille unique « 1 direction + 1 bouton » fonctionne bien au tactile. C'est le choix le plus important du document : ne pas le casser plus tard en ajoutant des manipulations à la Street Fighter.
- Points d'attention : joystick virtuel imprécis sur les diagonales (prévoir des zones généreuses), boutons de 70 px minimum, et tester très tôt sur un petit téléphone Android d'entrée de gamme, qui est le public majoritaire de Roblox.
- Les coups fatals à 3 flèches passent bien si la fenêtre est tolérante (1 s entre chaque flèche) et si la séquence est affichée à l'écran.

### Animations : ⚠️ le gros chantier
- 24 coups + ~15 animations de base (attente, marche, saut, accroupi, garde, coup reçu, chute, relevé, KO, victoire, intro…) ≈ **40 animations par perso, soit environ 800 pour 20 persos**, plus les effets visuels et les sons.
- Les persos non humains (bébé géant, gelée, aspirateur, yéti) demandent des rigs spécifiques, donc plus de travail. Conseil : garder un squelette R15 commun à tous et faire la différence avec les accessoires et les modèles 3D.
- Outils : Animation Editor intégré à Roblox Studio ou Moon Animator. Pour aller vite, faire appel à des animateurs freelance (Talent Hub / DevForum Roblox).

### Réseau : ⚠️ faisable avec des compromis de design
- Roblox n'offre pas de « rollback netcode » comme les jeux de combat pro. Sur mobile en 4G, la latence tourne autour de 80 à 250 ms.
- Conséquences de design à accepter dès maintenant :
  - Coups un peu plus lents à démarrer que dans Street Fighter et fenêtres de parade généreuses. Le jeu doit être lisible et fun, pas « à la frame près ».
  - L'animation part immédiatement chez le joueur qui appuie, mais c'est le serveur qui valide les touches (anti-triche), avec une petite compensation de latence.
  - Hitboxes faites avec des requêtes spatiales (`GetPartBoundsInBox`, shapecasts), pas avec l'événement `.Touched`, trop peu fiable.
  - Déplacements bloqués sur un axe (2.5D) : ça simplifie énormément la synchro.
- Le spécial « Freeze » de Jordan RageQuit peut être confondu avec un vrai lag. Je garderais l'idée en version très visible (effet glitch coloré) ou je le remplacerais.

### Équilibrage : ⚠️ le risque caché
Les statuts farfelus (inversion de touches, interface cachée, danse forcée, fou rire) font l'identité du jeu, mais ce sont aussi eux qui font quitter les joueurs s'ils durent trop longtemps. D'où les règles fixées plus haut : 3 s max, icône claire, pas de cumul, immunité temporaire.

### Ce qu'il faut en plus pour que ça tourne
- **Des bots IA** pour les combats quand il n'y a pas assez de joueurs en ligne. Indispensable au lancement, sinon les files d'attente vides tuent le jeu.
- **Un mode entraînement** avec la liste des coups affichée.

### Recommandation de lancement
**Sortir avec 6 persos**, puis ajouter 1 ou 2 persos par mise à jour. Chaque nouveau perso relance l'intérêt et c'est aussi un levier de vente, donc ce rythme sert directement la monétisation.

Proposition de 6 persos de départ, avec des styles variés et des looks très reconnaissables en miniature :
1. Gégé le Pochtron (piégeur)
2. Mamie Tricot (zoneuse)
3. Dylan le Livreur (rushdown)
4. Sumo Gélatine (tank pour débutants)
5. Marcel le Mime (défense)
6. Le Roi Pigeon (invocateur)

---

## 4. Conformité Roblox (à garder en tête)

- **Violence cartoon** : OK. **Sang et gore** : à éviter complètement, d'où des coups fatals 100 % comiques.
- **Gégé** : ✅ validé en version « soda douteux » (pas d'alcool à l'écran ni dans les textes). Le nez rouge et la démarche titubante suffisent pour le gag, sans faire monter la classification d'âge.
- **Rien qui se moque d'un handicap, d'une origine ou de la pauvreté** : le roster a été écrit dans ce sens (ex. Papi DJ sur tricycle plutôt que fauteuil roulant).
- **Objets aléatoires payants** (si on fait des coffres à Robux plus tard) : Roblox impose d'afficher les probabilités. On en reparlera à l'étape monétisation.

---

## 5. Prochaines étapes

1. ✅ 6 persos de lancement validés : Gégé, Mamie Tricot, Dylan, Sumo Gélatine, Marcel, Roi Pigeon.
2. **Maps** : arènes à thème liées aux persos (bar de quartier, guichet de mairie, cuisine de palace, piscine municipale, place aux pigeons…), avec éventuellement des éléments interactifs.
3. **Monétisation et rétention** : persos et coups fatals à débloquer, skins, pass de saison, défis quotidiens, classements. Ce roster est déjà pensé pour ça (2 fatals sur 3 à débloquer, assist « Collab » de Lola qui montre les autres persos).
