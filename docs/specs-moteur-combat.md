# SPÉCIFICATIONS TECHNIQUES POUR IA : MOTEUR DE COMBAT (BRAWLHALLA-LIKE) SUR ROBLOX LUA

## 1. Architecture Globale : Jauge de Dégâts (%) et Condition d'Élimination
Ce jeu n'utilise pas de système de points de vie (HP) classique. Le système de combat repose sur une jauge d'accumulation de dégâts :
*   **Initialisation :** Chaque joueur commence à 0 %.
*   **Accumulation (Damage Accumulation) :** Les dégâts infligés par une attaque s'additionnent au total actuel de la victime. Par exemple, une attaque infligeant 5 % de dégâts fait passer un joueur de 120 % à 125 %.
*   **Indicateur Visuel :** La jauge de pourcentage doit changer de couleur (passer au rouge) lorsque le joueur atteint le seuil critique de 150 %.
*   **Condition de KO (Blast Zones) :** Atteindre 150 % ou 300 % ne tue pas le joueur. La seule condition d'élimination est que la vélocité de l'éjection (Knockback) pousse le `HumanoidRootPart` du joueur en dehors des limites physiques de l'arène (Killboxes invisibles).

## 2. Moteur Physique : La Formule d'Éjection (Knockback)
L'éjection d'un joueur ne doit jamais être une force statique. Tu dois implémenter une fonction de calcul de force dynamique qui prend en compte deux variables définies dans les paramètres de chaque attaque :
1.  **Base Knockback (Éjection de base) :** La force propulsive minimale et garantie par le coup, appliquée même si la cible est à 0 %.
2.  **Knockback Scaling (Multiplicateur d'éjection) :** Le coefficient (souvent exponentiel ou linéaire) qui amplifie la force du coup proportionnellement aux dégâts actuels de la victime.

**Formule mathématique à implémenter :**
`Force_Finale = Base_Knockback + (Pourcentage_Degats_Cible * Knockback_Scaling)`

## 3. Différenciation des Attaques : Combos vs Finisseurs
Le système de combat doit gérer deux profils d'attaques distincts, définis par les variables ci-dessus, pour rendre les combos possibles.

### A. Les Attaques Légères (Bouton P) — Orientées Combos
*   **Paramètres :** `Base_Knockback` faible, `Knockback_Scaling` très proche de zéro.
*   **Comportement :** Ces attaques n'éjectent pas. Que l'adversaire soit à 0 % ou à 150 %, il subira le même micro-recul.
*   **Objectif :** Maintenir la cible à portée de mêlée pour permettre au joueur d'enchaîner 2 à 4 coups rapides (combos) et faire monter le pourcentage de dégâts.

### B. Les Signatures / Attaques Lourdes (Bouton S) — Orientées Éjection
*   **Paramètres :** `Base_Knockback` moyen, `Knockback_Scaling` très élevé.
*   **Comportement :** À 10 %, la cible recule de quelques studs. À 150 %, la formule s'emballe et propulse la cible à très grande vitesse vers la Killbox.
*   **Mécanique de Charge :** Maintenir la touche enfoncée doit multiplier les statistiques. Tu dois implémenter un `Charge_Multiplier` (par exemple de 1.0 à 1.5 selon le temps de charge) qui s'applique sur les Dégâts, le `Base_Knockback` et le `Knockback_Scaling` au relâchement.

## 4. Directives d'Implémentation Lua (Roblox Studio)
Pour garantir la fluidité et éviter les bugs de physique réseau, respecte strictement ces directives d'intégration :

*   **Application de la Vélocité :** Ne **jamais** utiliser les anciens `BodyMovers` (`BodyVelocity`, `BodyForce`) qui sont obsolètes. Utilise exclusivement la méthode `HumanoidRootPart:ApplyImpulse()` ou modifie directement la propriété `AssemblyLinearVelocity` du joueur ciblé.
*   **Vecteurs Directionnels (Vector3) :** Chaque attaque de la table de données doit inclure un angle fixe de projection (`DirectionVector`). La `Force_Finale` doit être multipliée par ce vecteur (ex: `Vector3.new(1, 1, 0).Unit` pour une éjection en diagonale haute).
*   **Hitstun (Temps d'étourdissement) :** Lorsqu'un joueur subit une attaque, son script de contrôle doit être désactivé temporairement (impossible de sauter, dasher ou attaquer). Ce temps de Hitstun n'est pas fixe : il doit être calculé dynamiquement en fonction de la `Force_Finale` reçue à l'impact.
*   **Détection des Hitboxes (Hit Registration) :** Il est strictement interdit d'utiliser l'événement natif `.Touched` pour les coups (trop de latence et de faux positifs). Utilise des requêtes spatiales instantanées comme `workspace:GetPartBoundsInBox()` ou des `Shapecasts` pour vérifier si l'adversaire est dans la zone de frappe au moment exact de la frame active de l'animation.