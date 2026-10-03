"""Apparence 3D des 20 combattants (source unique pour le jeu ET la visionneuse).

Chaque accessoire = une Part soudée à une partie du rig :
    A(partie, forme, taille, position, rotation_deg, couleur, matiere, transparence, arme)
- forme : "Block", "Ball" (ellipsoïde : Part + SpecialMesh Sphere), "Cyl" (cylindre, axe X comme Roblox)
- position : relative au centre de la partie d'attache, dans son repère (le perso regarde vers -Z)
- rotation : degrés (X, Y, Z), ordre CFrame.Angles
- arme=True : visible seulement quand le perso a ramassé sa Caisse Bizarre
"""

def A(attach, shape, size, pos, rot=(0, 0, 0), color="#ffffff", mat="Plastic", tr=0.0, weapon=False):
    return {"attach": attach, "shape": shape, "size": list(size), "pos": list(pos), "rot": list(rot),
            "color": color, "mat": mat, "tr": tr, "weapon": weapon}

VERT = (0, 0, 90)      # cylindre vertical (axe Y)
FWD = (0, 90, 0)       # cylindre pointé vers l'avant (axe -Z)

def body(skin, torso, hips, uarm, larm, hand, uleg, lleg, foot, head=None):
    return {"head": head or skin, "torso": torso, "hips": hips, "uarm": uarm, "larm": larm,
            "hand": hand, "uleg": uleg, "lleg": lleg, "foot": foot}

def both(attach_l, attach_r, shape, size, pos, rot=(0, 0, 0), color="#fff", mat="Plastic", tr=0.0, weapon=False):
    """Accessoire symétrique (le X de la position est inversé côté gauche)."""
    x, y, z = pos
    return [A(attach_r, shape, size, (x, y, z), rot, color, mat, tr, weapon),
            A(attach_l, shape, size, (-x, y, z), rot, color, mat, tr, weapon)]

LOOKS = {}

# 1 — Gégé le Pochtron
LOOKS["gege"] = {
    "scale": [1.0, 1.1],
    "body": body("#f2c6a0", "#f4f1e8", "#3b4a6b", "#f2c6a0", "#f2c6a0", "#f2c6a0", "#3b4a6b", "#3b4a6b", "#4a3b2a"),
    "face": {"eyes": "#1b1b1b", "mouth": "#7b3a2a"},
    "acc": [
        A("Head", "Block", (1.32, 0.55, 1.32), (0.05, 0.62, 0), (0, 0, -12), "#c0392b", "Fabric"),
        A("Head", "Block", (1.36, 0.2, 1.36), (0.0, 0.4, 0), (0, 0, -12), "#922b21", "Fabric"),
        A("Head", "Ball", (0.38, 0.38, 0.38), (0.25, 1.0, 0), (0, 0, 0), "#e74c3c", "Fabric"),
        A("Head", "Ball", (0.36, 0.36, 0.36), (0, -0.02, -0.68), (0, 0, 0), "#ff2a2a", "Neon"),
        A("UpperTorso", "Block", (1.8, 0.9, 0.4), (0, -0.3, -0.55), (0, 0, 0), "#f4f1e8"),
        A("UpperTorso", "Ball", (0.45, 0.35, 0.06), (-0.4, -0.2, -0.77), (0, 0, 0), "#d4ac0d", "Plastic", 0.3),
        A("UpperTorso", "Ball", (0.3, 0.25, 0.06), (0.35, 0.15, -0.53), (0, 0, 0), "#d4ac0d", "Plastic", 0.3),
        A("Head", "Block", (0.9, 0.18, 0.1), (0, -0.48, -0.6), (0, 0, 0), "#6d5a45"),  # barbe de 3 jours
        # Arme : bouteille de soda douteux
        A("RightHand", "Cyl", (1.0, 0.42, 0.42), (0, 0, -0.65), FWD, "#2ecc40", "Glass", 0.25, True),
        A("RightHand", "Cyl", (0.45, 0.18, 0.18), (0, 0, -1.35), FWD, "#2ecc40", "Glass", 0.25, True),
        A("RightHand", "Ball", (0.22, 0.22, 0.22), (0, 0.1, -1.65), (0, 0, 0), "#d5f5e3", "Neon", 0.2, True),
    ],
}

# 2 — Mamie Tricot
LOOKS["mamie"] = {
    "scale": [0.8, 0.95],
    "body": body("#f5d3bd", "#c77dba", "#6b4a7a", "#c77dba", "#c77dba", "#f5d3bd", "#6b4a7a", "#e8c9b0", "#5b3a29"),
    "face": {"eyes": "#1b1b1b", "mouth": "#a0522d"},
    "acc": [
        A("Head", "Ball", (1.32, 0.55, 1.32), (0, 0.42, 0.05), (0, 0, 0), "#d9d9e3", "Fabric"),
        A("Head", "Ball", (0.6, 0.6, 0.6), (0, 0.82, 0.25), (0, 0, 0), "#d9d9e3", "Fabric"),
        *both("Head", "Head", "Cyl", (0.06, 0.42, 0.42), (0.27, 0.1, -0.63), FWD, "#333333", "Glass", 0.3),
        A("UpperTorso", "Block", (2.15, 0.5, 1.12), (0, 0.48, 0), (0, 0, 0), "#8e44ad", "Fabric"),
        A("UpperTorso", "Ball", (0.6, 0.45, 0.8), (0.72, 0.95, 0.15), (0, 0, 0), "#e67e22", "Fabric"),
        A("UpperTorso", "Ball", (0.42, 0.42, 0.42), (0.72, 1.18, -0.2), (0, 0, 0), "#e67e22", "Fabric"),
        A("UpperTorso", "Ball", (0.6, 0.45, 0.8), (-0.72, 0.95, 0.15), (0, 0, 0), "#7f8c8d", "Fabric"),
        A("UpperTorso", "Ball", (0.42, 0.42, 0.42), (-0.72, 1.18, -0.2), (0, 0, 0), "#7f8c8d", "Fabric"),
        A("LowerTorso", "Block", (1.9, 0.9, 1.1), (0, -0.4, 0), (0, 0, 0), "#6b4a7a", "Fabric"),  # jupe
        # Arme : sac à main + canne
        A("LeftHand", "Block", (0.75, 0.55, 0.3), (0, -0.5, 0), (0, 0, 0), "#7a4a2a", "Plastic", 0, True),
        A("LeftHand", "Block", (0.1, 0.4, 0.05), (0, -0.05, 0), (0, 0, 0), "#7a4a2a", "Plastic", 0, True),
        A("RightHand", "Cyl", (2.0, 0.16, 0.16), (0, -0.9, 0), VERT, "#6e4b2a", "Wood", 0, True),
    ],
}

# 3 — Dylan le Livreur
LOOKS["dylan"] = {
    "scale": [1.0, 1.0],
    "body": body("#c98e63", "#1abc9c", "#2c3e50", "#1abc9c", "#c98e63", "#333333", "#2c3e50", "#2c3e50", "#ecf0f1"),
    "face": {"eyes": "#1b1b1b", "mouth": "#5d3a2a"},
    "acc": [
        A("Head", "Ball", (1.38, 0.85, 1.38), (0, 0.42, 0), (0, 0, 0), "#f1c40f"),
        A("Head", "Block", (0.15, 0.55, 0.32), (0.55, 0.75, -0.3), (0, 0, 0), "#111111"),
        A("UpperTorso", "Block", (1.9, 1.9, 1.4), (0, 0.3, 1.2), (0, 0, 0), "#16a085"),
        A("UpperTorso", "Block", (1.0, 0.35, 0.05), (0, 0.6, 1.92), (0, 0, 0), "#ecf0f1"),
        A("UpperTorso", "Block", (0.25, 1.2, 0.1), (0.55, 0.1, -0.52), (0, 0, 0), "#111111"),  # bretelle
        # Arme : trottinette
        A("RightHand", "Cyl", (2.4, 0.16, 0.16), (0, -1.1, -0.3), VERT, "#7f8c8d", "Metal", 0, True),
        A("RightHand", "Block", (0.45, 0.1, 1.8), (0, -2.3, -0.9), (0, 0, 0), "#34495e", "Plastic", 0, True),
        A("RightHand", "Cyl", (0.2, 0.4, 0.4), (0, -2.4, -1.8), (0, 0, 0), "#111111", "Plastic", 0, True),
    ],
}

# 4 — Bernard du Guichet
LOOKS["bernard"] = {
    "scale": [1.0, 1.05],
    "body": body("#f0c8a8", "#d8c7a3", "#8d7d62", "#d8c7a3", "#d8c7a3", "#f0c8a8", "#8d7d62", "#8d7d62", "#4e342e"),
    "face": {"eyes": "#1b1b1b", "mouth": "#7b5a45"},
    "acc": [
        A("Head", "Block", (1.26, 0.18, 1.26), (0, 0.62, 0), (0, 0, 4), "#6d5a45"),
        A("Head", "Block", (0.95, 0.12, 0.05), (0, 0.0, -0.63), (0, 0, 0), "#333333"),
        A("UpperTorso", "Block", (0.8, 0.3, 0.05), (0, 0.5, -0.52), (0, 0, 0), "#ffffff"),
        A("UpperTorso", "Block", (0.25, 0.95, 0.05), (0, 0.0, -0.53), (0, 0, 0), "#2e4053"),
        A("UpperTorso", "Block", (0.35, 0.12, 0.05), (0.6, 0.2, -0.53), (0, 0, 0), "#c0392b"),  # stylo
        A("LeftHand", "Cyl", (0.48, 0.42, 0.42), (0, -0.3, -0.2), VERT, "#ffffff"),               # mug
        # Arme : tampon géant
        A("RightHand", "Cyl", (0.7, 0.28, 0.28), (0, -0.45, 0), VERT, "#8b5a2b", "Wood", 0, True),
        A("RightHand", "Block", (1.0, 0.4, 1.0), (0, -0.95, 0), (0, 0, 0), "#c0392b", "Plastic", 0, True),
        A("RightHand", "Block", (0.9, 0.06, 0.9), (0, -1.18, 0), (0, 0, 0), "#1b1b1b", "Plastic", 0, True),
    ],
}

# 5 — Chef Flambé
LOOKS["chef"] = {
    "scale": [1.0, 1.05],
    "body": body("#f3c9a5", "#ffffff", "#2d2d2d", "#ffffff", "#ffffff", "#f3c9a5", "#2d2d2d", "#2d2d2d", "#111111"),
    "face": {"eyes": "#1b1b1b", "mouth": None},
    "acc": [
        A("Head", "Cyl", (1.6, 1.12, 1.12), (0, 1.35, 0), VERT, "#ffffff", "Fabric"),
        A("Head", "Ball", (1.55, 0.75, 1.55), (0, 2.2, 0), (0, 0, 0), "#ffffff", "Fabric"),
        A("Head", "Cyl", (0.25, 1.26, 1.26), (0, 0.6, 0), VERT, "#ecf0f1", "Fabric"),
        A("Head", "Block", (0.9, 0.16, 0.1), (0, -0.15, -0.65), (0, 0, 0), "#2b1d10"),
        *both("Head", "Head", "Ball", (0.28, 0.28, 0.28), (0.5, -0.05, -0.62), (0, 0, 0), "#2b1d10"),
        A("UpperTorso", "Block", (1.6, 1.0, 0.06), (0, -0.25, -0.53), (0, 0, 0), "#ecf0f1", "Fabric"),
        A("UpperTorso", "Ball", (0.4, 0.4, 0.06), (0.35, -0.35, -0.57), (0, 0, 0), "#c0392b"),
        A("LowerTorso", "Block", (1.6, 1.3, 0.06), (0, -0.55, -0.53), (0, 0, 0), "#ecf0f1", "Fabric"),
        A("UpperTorso", "Block", (0.6, 0.2, 0.1), (0, 0.6, -0.5), (0, 0, 0), "#c0392b"),  # foulard
        # Arme : poêle + rouleau
        A("RightHand", "Cyl", (1.0, 0.18, 0.18), (0, 0, -0.6), FWD, "#5d4037", "Wood", 0, True),
        A("RightHand", "Cyl", (0.15, 1.35, 1.35), (0, 0, -1.75), VERT, "#333333", "Metal", 0, True),
        A("LeftHand", "Cyl", (1.7, 0.32, 0.32), (0, -0.2, 0), (0, 0, 0), "#d4a056", "Wood", 0, True),
    ],
}

# 6 — Marcel le Mime
LOOKS["marcel"] = {
    "scale": [1.0, 0.9],
    "body": body("#ffffff", "#ffffff", "#1b1b1b", "#ffffff", "#ffffff", "#ffffff", "#1b1b1b", "#1b1b1b", "#111111"),
    "face": {"eyes": "#111111", "mouth": "#c0392b"},
    "acc": [
        *[A("UpperTorso", "Block", (2.02, 0.12, 1.02), (0, y, 0), (0, 0, 0), "#1b2a49") for y in (0.45, 0.15, -0.15, -0.45)],
        *both("LeftUpperArm", "RightUpperArm", "Block", (1.02, 0.12, 1.02), (0, 0.2, 0), (0, 0, 0), "#1b2a49"),
        A("Head", "Cyl", (0.25, 1.4, 1.4), (0.12, 0.66, 0), (0, 0, 98), "#111111", "Fabric"),
        A("Head", "Block", (0.08, 0.22, 0.08), (0.12, 0.86, 0), (0, 0, 0), "#111111"),
        *both("Head", "Head", "Block", (0.05, 0.38, 0.05), (0.25, 0.12, -0.61), (0, 0, 0), "#111111"),
        A("UpperTorso", "Block", (0.5, 0.2, 0.1), (0, 0.62, -0.5), (0, 0, 0), "#c0392b"),  # foulard rouge
        # Arme : accessoires invisibles (canne + valise fantômes)
        A("RightHand", "Cyl", (2.2, 0.14, 0.14), (0, 0, -1.1), FWD, "#e8f8ff", "Glass", 0.7, True),
        A("LeftHand", "Block", (1.1, 0.8, 0.35), (0, -0.6, 0), (0, 0, 0), "#e8f8ff", "Glass", 0.7, True),
    ],
}

# 7 — Bébé Colosse
LOOKS["bebe"] = {
    "scale": [1.45, 1.4],
    "body": body("#ffd6c0", "#ffd6c0", "#ffffff", "#ffd6c0", "#ffd6c0", "#ffd6c0", "#ffd6c0", "#ffd6c0", "#ffd6c0"),
    "face": {"eyes": "#1b1b1b", "mouth": None},
    "acc": [
        A("Head", "Ball", (1.36, 0.95, 1.36), (0, 0.35, 0.05), (0, 0, 0), "#a0522d", "Fabric"),
        *both("Head", "Head", "Ball", (0.45, 0.45, 0.45), (0.5, 0.78, 0.1), (0, 0, 0), "#a0522d", "Fabric"),
        A("Head", "Cyl", (0.08, 0.45, 0.45), (0, -0.28, -0.65), FWD, "#5dade2"),
        A("Head", "Ball", (0.16, 0.16, 0.16), (0, -0.28, -0.72), (0, 0, 0), "#ffffff"),
        A("LowerTorso", "Block", (1.95, 0.85, 1.08), (0, -0.2, 0), (0, 0, 0), "#ffffff", "Fabric"),
        *both("LowerTorso", "LowerTorso", "Ball", (0.18, 0.18, 0.18), (0.8, 0, -0.55), (0, 0, 0), "#5dade2"),
        A("UpperTorso", "Ball", (1.9, 1.3, 1.2), (0, -0.25, -0.15), (0, 0, 0), "#ffd6c0"),  # gros ventre
        # Arme : hochet géant
        A("RightHand", "Cyl", (1.0, 0.22, 0.22), (0, 0, -0.5), FWD, "#f9e79f", "Plastic", 0, True),
        A("RightHand", "Ball", (0.95, 0.95, 0.95), (0, 0, -1.35), (0, 0, 0), "#ff6fa8", "Plastic", 0, True),
    ],
}

# 8 — Gloria Zumba
LOOKS["gloria"] = {
    "scale": [1.0, 0.95],
    "body": body("#a86b4a", "#39ff14", "#39ff14", "#a86b4a", "#a86b4a", "#a86b4a", "#ff4fa3", "#ffeb3b", "#ffffff"),
    "face": {"eyes": "#1b1b1b", "mouth": "#c0392b"},
    "acc": [
        A("Head", "Ball", (1.36, 0.95, 1.36), (0, 0.5, 0.12), (0, 0, 0), "#3b2314", "Fabric"),
        A("Head", "Ball", (0.85, 0.85, 0.85), (0, 0.9, 0.45), (0, 0, 0), "#3b2314", "Fabric"),
        A("Head", "Cyl", (0.2, 1.28, 1.28), (0, 0.35, 0), VERT, "#00e5ff", "Fabric"),
        A("UpperTorso", "Block", (0.9, 0.6, 0.5), (-1.25, 0.98, 0.05), (0, 0, 0), "#222222"),
        A("UpperTorso", "Cyl", (0.06, 0.36, 0.36), (-1.45, 0.98, -0.22), FWD, "#39ff14", "Neon"),
        A("UpperTorso", "Cyl", (0.06, 0.36, 0.36), (-1.05, 0.98, -0.22), FWD, "#ff4fa3", "Neon"),
        *both("LeftLowerLeg", "RightLowerLeg", "Block", (1.0, 0.5, 1.0), (0, -0.1, 0), (0, 0, 0), "#ff4fa3", "Fabric"),
        # Arme : enceinte fluo tenue à la main
        A("RightHand", "Block", (1.0, 0.75, 0.65), (0, -0.55, -0.2), (0, 0, 0), "#222222", "Plastic", 0, True),
        A("RightHand", "Cyl", (0.06, 0.55, 0.55), (0, -0.55, -0.55), FWD, "#39ff14", "Neon", 0, True),
    ],
}

# 9 — Lola Filtre
LOOKS["lola"] = {
    "scale": [1.0, 0.95],
    "body": body("#f6d0b8", "#ffb3da", "#ffffff", "#f6d0b8", "#f6d0b8", "#f6d0b8", "#f6d0b8", "#ffffff", "#ffffff"),
    "face": {"eyes": None, "mouth": "#e75480"},
    "acc": [
        A("Head", "Ball", (1.36, 1.0, 1.36), (0, 0.35, 0.15), (0, 0, 0), "#f7dc6f"),
        A("Head", "Block", (1.2, 1.5, 0.4), (0, -0.4, 0.5), (0, 0, 0), "#f7dc6f"),
        *both("Head", "Head", "Ball", (0.38, 0.32, 0.08), (0.27, 0.1, -0.63), (0, 0, 0), "#ff2d7a", "Neon"),
        A("LowerTorso", "Block", (1.95, 0.6, 1.1), (0, -0.25, 0), (0, 0, 0), "#ffffff"),
        # Arme : perche à selfie + ring light
        A("RightHand", "Cyl", (2.4, 0.1, 0.1), (0, 1.1, -0.2), VERT, "#c0c0c0", "Metal", 0, True),
        A("RightHand", "Block", (0.5, 0.85, 0.08), (0, 2.45, -0.2), (0, 0, 0), "#ff8fc7", "Plastic", 0, True),
        A("LeftHand", "Cyl", (0.12, 1.4, 1.4), (0, 0, -0.45), FWD, "#ffffff", "Neon", 0.2, True),
    ],
}

# 10 — Jordan « RageQuit »
LOOKS["jordan"] = {
    "scale": [1.0, 1.0],
    "body": body("#e6b48f", "#2b2b2b", "#3a3a5a", "#2b2b2b", "#2b2b2b", "#e6b48f", "#3a3a5a", "#3a3a5a", "#ff0055"),
    "face": {"eyes": "#1b1b1b", "mouth": "#7b3a2a"},
    "acc": [
        A("Head", "Block", (1.26, 0.32, 1.26), (0, 0.55, 0.05), (0, 0, 0), "#4a3020"),
        A("UpperTorso", "Block", (1.4, 0.6, 0.5), (0, 0.65, 0.45), (0, 0, 0), "#1a1a1a", "Fabric"),
        A("Head", "Block", (1.45, 0.15, 0.22), (0, 0.72, 0), (0, 0, 0), "#111111"),
        *both("Head", "Head", "Cyl", (0.32, 0.62, 0.62), (0.7, 0.05, 0), (0, 0, 0), "#00ffcc", "Neon"),
        A("Head", "Block", (0.1, 0.1, 0.6), (0.55, -0.25, -0.45), (0, 0, 0), "#111111"),
        A("UpperTorso", "Block", (0.8, 0.5, 0.06), (0, -0.2, -0.53), (0, 0, 0), "#ff00aa", "Neon"),  # logo
        # Arme : manette + clavier
        A("RightHand", "Block", (0.95, 0.32, 0.55), (0, -0.3, -0.2), (0, 0, 0), "#111111", "Plastic", 0, True),
        A("RightHand", "Cyl", (1.6, 0.07, 0.07), (0, -1.2, -0.2), VERT, "#111111", "Plastic", 0, True),
        A("LeftHand", "Block", (1.9, 0.12, 0.65), (0, -0.2, -0.3), (0, 0, 0), "#333333", "Plastic", 0, True),
        A("LeftHand", "Block", (1.85, 0.04, 0.1), (0, -0.13, -0.6), (0, 0, 0), "#00ffcc", "Neon", 0, True),
    ],
}

# 11 — Dr Fraise
LOOKS["fraise"] = {
    "scale": [1.0, 1.0],
    "body": body("#f2c8a8", "#ffffff", "#ffffff", "#ffffff", "#ffffff", "#85c1e9", "#87a8c9", "#87a8c9", "#ffffff"),
    "face": {"eyes": "#1b1b1b", "mouth": "#ffffff", "mouthMat": "Neon", "mouthW": 0.6},
    "acc": [
        A("LowerTorso", "Block", (1.95, 1.0, 1.06), (0, -0.5, 0), (0, 0, 0), "#ffffff", "Fabric"),
        A("Head", "Block", (1.26, 0.25, 1.26), (0, 0.6, 0), (0, 0, 0), "#5d4037"),
        A("Head", "Cyl", (0.15, 1.26, 1.26), (0, 0.35, 0), VERT, "#333333"),
        A("Head", "Cyl", (0.15, 0.42, 0.42), (0, 0.35, -0.68), FWD, "#f7dc6f", "Neon"),
        A("UpperTorso", "Block", (0.3, 0.4, 0.06), (0.55, 0.2, -0.53), (0, 0, 0), "#5dade2"),  # poche
        # Arme : fraise géante + miroir
        A("RightHand", "Cyl", (0.9, 0.38, 0.38), (0, 0, -0.5), FWD, "#ecf0f1", "Plastic", 0, True),
        A("RightHand", "Cyl", (0.85, 0.12, 0.12), (0, 0, -1.35), FWD, "#bdc3c7", "Metal", 0, True),
        A("LeftHand", "Cyl", (0.9, 0.06, 0.06), (0, 0, -0.45), FWD, "#bdc3c7", "Metal", 0, True),
        A("LeftHand", "Cyl", (0.05, 0.38, 0.38), (0, 0, -0.95), VERT, "#d6eaf8", "Glass", 0.1, True),
    ],
}

# 12 — Sumo Gélatine
LOOKS["sumo"] = {
    "scale": [1.15, 1.6],
    "body": body("#7ee08a", "#7ee08a", "#ffffff", "#7ee08a", "#7ee08a", "#7ee08a", "#7ee08a", "#7ee08a", "#7ee08a"),
    "transparency": {"head": 0.3, "torso": 0.35, "uarm": 0.3, "larm": 0.3, "hand": 0.3, "uleg": 0.3, "lleg": 0.3, "foot": 0.3},
    "face": {"eyes": "#1e5631", "mouth": "#1e5631"},
    "acc": [
        A("Head", "Ball", (0.5, 0.38, 0.65), (0, 0.72, 0.15), (0, 0, 0), "#4caf50"),
        A("UpperTorso", "Ball", (2.2, 1.7, 1.5), (0, -0.2, -0.2), (0, 0, 0), "#7ee08a", "Plastic", 0.35),
        A("UpperTorso", "Ball", (0.55, 0.55, 0.55), (0.1, -0.25, -0.3), (0, 0, 0), "#ffd400"),
        A("UpperTorso", "Ball", (0.32, 0.32, 0.32), (0.4, 0.08, -0.3), (0, 0, 0), "#ffd400"),
        A("UpperTorso", "Block", (0.22, 0.08, 0.14), (0.6, 0.06, -0.3), (0, 0, 0), "#ff8c00"),
        A("LowerTorso", "Block", (1.95, 0.55, 1.12), (0, 0, 0), (0, 0, 0), "#ffffff", "Fabric"),
        # Arme : gants en guimauve
        A("RightHand", "Ball", (1.15, 1.15, 1.15), (0, -0.2, 0), (0, 0, 0), "#fdfefe", "Fabric", 0, True),
        A("LeftHand", "Ball", (1.15, 1.15, 1.15), (0, -0.2, 0), (0, 0, 0), "#fadbd8", "Fabric", 0, True),
    ],
}

# 13 — Ramsès le Patraque
LOOKS["ramses"] = {
    "scale": [1.0, 0.95],
    "body": body("#efe3c2", "#efe3c2", "#efe3c2", "#efe3c2", "#efe3c2", "#efe3c2", "#efe3c2", "#efe3c2", "#e3d5b0"),
    "face": {"eyes": "#ffffff", "mouth": None},
    "acc": [
        A("Head", "Block", (0.95, 0.24, 0.05), (0, 0.1, -0.61), (0, 0, 0), "#3b2f1e"),
        A("Head", "Block", (1.26, 0.12, 1.26), (0, 0.32, 0), (0, 0, 8), "#cbbf9a"),
        A("Head", "Block", (1.26, 0.12, 1.26), (0, -0.25, 0), (0, 0, -6), "#cbbf9a"),
        A("UpperTorso", "Block", (2.1, 0.12, 1.06), (0, 0.2, 0), (0, 0, 12), "#cbbf9a"),
        A("UpperTorso", "Block", (2.1, 0.12, 1.06), (0, -0.3, 0), (0, 0, -10), "#cbbf9a"),
        A("LeftLowerArm", "Block", (0.2, 1.3, 0.05), (0.2, -0.6, 0.47), (0, 0, 20), "#cbbf9a"),
        A("Head", "Cyl", (0.7, 0.09, 0.09), (0.18, -0.25, -0.85), (0, 60, 0), "#ecf0f1"),
        A("Head", "Ball", (0.13, 0.13, 0.13), (0.45, -0.25, -1.05), (0, 0, 0), "#e74c3c"),
        # Arme : thermomètre géant
        A("RightHand", "Cyl", (2.0, 0.26, 0.26), (0, 0, -1.0), FWD, "#ecf0f1", "Glass", 0.1, True),
        A("RightHand", "Ball", (0.48, 0.48, 0.48), (0, 0, -2.05), (0, 0, 0), "#e74c3c", "Plastic", 0, True),
    ],
}

# 14 — Capitaine Canard
LOOKS["canard"] = {
    "scale": [1.0, 1.05],
    "body": body("#f1c27d", "#2980b9", "#2980b9", "#f1c27d", "#f1c27d", "#f1c27d", "#2980b9", "#f1c27d", "#f39c12"),
    "face": {"eyes": "#1b1b1b", "mouth": "#7b3a2a"},
    "acc": [
        A("LowerTorso", "Cyl", (0.75, 3.0, 3.0), (0, 0.25, 0), VERT, "#ffd400"),
        A("LowerTorso", "Ball", (0.95, 0.95, 0.95), (0, 0.85, -1.45), (0, 0, 0), "#ffd400"),
        A("LowerTorso", "Block", (0.5, 0.16, 0.42), (0, 0.75, -2.0), (0, 0, 0), "#ff8c00"),
        *both("LowerTorso", "LowerTorso", "Ball", (0.15, 0.15, 0.15), (0.2, 1.02, -1.85), (0, 0, 0), "#111111"),
        A("Head", "Block", (1.0, 0.45, 0.15), (0, 0.1, -0.66), (0, 0, 0), "#00bcd4", "Glass", 0.4),
        A("Head", "Cyl", (0.95, 0.13, 0.13), (0.66, 0.4, -0.1), VERT, "#ff7043"),
        *both("LeftFoot", "RightFoot", "Block", (1.05, 0.12, 1.7), (0, -0.1, -0.45), (0, 0, 0), "#f39c12"),
        # Arme : pistolet à eau
        A("RightHand", "Block", (0.42, 0.42, 1.25), (0, 0, -0.65), (0, 0, 0), "#ff7f50", "Plastic", 0, True),
        A("RightHand", "Ball", (0.55, 0.55, 0.55), (0, 0.38, -0.4), (0, 0, 0), "#5dade2", "Glass", 0.2, True),
    ],
}

# 15 — Gaston le Magnifique
LOOKS["gaston"] = {
    "scale": [1.0, 0.95],
    "body": body("#f0c9a8", "#1a1a1a", "#1a1a1a", "#1a1a1a", "#1a1a1a", "#ffffff", "#1a1a1a", "#1a1a1a", "#111111"),
    "face": {"eyes": "#1b1b1b", "mouth": None},
    "acc": [
        A("Head", "Cyl", (1.0, 0.98, 0.98), (0, 1.12, 0), VERT, "#111111"),
        A("Head", "Cyl", (0.1, 1.65, 1.65), (0, 0.63, 0), VERT, "#111111"),
        A("Head", "Cyl", (0.2, 1.0, 1.0), (0, 0.76, 0), VERT, "#a93226"),
        *both("Head", "Head", "Ball", (0.22, 0.75, 0.22), (0.18, 1.95, 0), (0, 0, 0), "#ffffff", "Fabric"),
        A("Head", "Block", (0.55, 0.08, 0.06), (0, -0.12, -0.62), (0, 0, 0), "#111111"),
        A("UpperTorso", "Block", (2.4, 2.8, 0.12), (0, -0.7, 0.62), (0, 0, 0), "#a93226", "Fabric"),
        A("UpperTorso", "Block", (2.25, 0.55, 0.15), (0, 0.82, 0.5), (0, 0, 0), "#a93226", "Fabric"),
        A("UpperTorso", "Block", (0.42, 0.16, 0.08), (0, 0.6, -0.53), (0, 0, 0), "#a93226"),
        A("UpperTorso", "Block", (0.5, 1.0, 0.04), (0, 0.0, -0.52), (0, 0, 0), "#ffffff"),  # plastron
        # Arme : baguette magique
        A("RightHand", "Cyl", (1.3, 0.13, 0.13), (0, 0, -0.65), FWD, "#111111", "Plastic", 0, True),
        A("RightHand", "Cyl", (0.25, 0.14, 0.14), (0, 0, -1.4), FWD, "#ffffff", "Plastic", 0, True),
        A("RightHand", "Ball", (0.32, 0.32, 0.32), (0, 0, -1.62), (0, 0, 0), "#f7dc6f", "Neon", 0, True),
    ],
}

# 16 — Gros Bob, le Yéti en vacances
LOOKS["bob"] = {
    "scale": [1.35, 1.45],
    "body": body("#f4f6f7", "#e74c3c", "#f4f6f7", "#e74c3c", "#f4f6f7", "#f4f6f7", "#f4f6f7", "#f4f6f7", "#f4f6f7"),
    "materials": {"head": "Fabric", "larm": "Fabric", "hand": "Fabric", "uleg": "Fabric", "lleg": "Fabric", "foot": "Fabric", "hips": "Fabric"},
    "face": {"eyes": None, "mouth": "#5d6d7e"},
    "acc": [
        A("Head", "Ball", (0.95, 0.5, 0.95), (0, 0.6, 0), (0, 0, 0), "#f4f6f7", "Fabric"),
        A("Head", "Block", (1.05, 0.26, 0.06), (0, 0.1, -0.63), (0, 0, 0), "#111111"),
        A("Head", "Ball", (0.32, 0.22, 0.15), (0, -0.08, -0.66), (0, 0, 0), "#ffffff"),
        *[A("UpperTorso", "Ball", (0.32, 0.32, 0.06), p, (0, 0, 0), "#f9e79f") for p in ((-0.5, 0.3, -0.52), (0.45, 0.1, -0.52), (-0.2, -0.35, -0.52), (0.6, -0.45, -0.52))],
        A("UpperTorso", "Ball", (0.9, 0.5, 0.5), (0, 0.72, -0.1), (0, 0, 0), "#f4f6f7", "Fabric"),
        *both("LeftFoot", "RightFoot", "Block", (1.0, 0.08, 1.35), (0, -0.16, 0), (0, 0, 0), "#2e86c1"),
        # Arme : glacière
        A("RightHand", "Block", (1.25, 0.95, 0.85), (0, -0.65, 0), (0, 0, 0), "#2e86c1", "Plastic", 0, True),
        A("RightHand", "Block", (1.3, 0.2, 0.9), (0, -0.12, 0), (0, 0, 0), "#ecf0f1", "Plastic", 0, True),
    ],
}

# 17 — R-0B0, l'aspirateur
LOOKS["robo"] = {
    "scale": [0.95, 1.15],
    "body": body("#d5dbdb", "#95a5a6", "#566573", "#95a5a6", "#95a5a6", "#566573", "#566573", "#566573", "#2c3e50"),
    "materials": {"head": "Metal", "torso": "Metal", "uarm": "Metal", "larm": "Metal"},
    "face": {"eyes": "#2ecc71", "eyeMat": "Neon", "mouth": None},
    "acc": [
        A("Head", "Cyl", (0.5, 1.75, 1.75), (0, 0.45, 0), VERT, "#b2babb", "Metal"),
        A("Head", "Ball", (0.3, 0.3, 0.3), (0, 0.75, 0), (0, 0, 0), "#2ecc71", "Neon"),
        A("Head", "Block", (1.0, 0.42, 0.06), (0, 0.08, -0.61), (0, 0, 0), "#111111"),
        A("UpperTorso", "Cyl", (0.3, 2.25, 2.25), (0, -0.55, 0), VERT, "#2c3e50"),
        A("UpperTorso", "Cyl", (1.05, 0.85, 0.85), (0, 0, 0.75), VERT, "#aed6f1", "Glass", 0.4),
        A("UpperTorso", "Block", (0.5, 0.2, 0.06), (0, 0.3, -0.53), (0, 0, 0), "#2ecc71", "Neon"),
        # Arme : tuyau + brosse rotative
        A("RightHand", "Cyl", (1.6, 0.36, 0.36), (0, 0, -0.8), FWD, "#34495e", "Plastic", 0, True),
        A("RightHand", "Cyl", (0.3, 0.65, 0.65), (0, 0, -1.7), FWD, "#e74c3c", "Plastic", 0, True),
    ],
}

# 18 — Papi DJ
LOOKS["papi"] = {
    "scale": [0.95, 1.0],
    "body": body("#e0b08a", "#7d3c98", "#1c2833", "#7d3c98", "#7d3c98", "#e0b08a", "#1c2833", "#1c2833", "#ffffff"),
    "face": {"eyes": None, "mouth": "#7b3a2a"},
    "acc": [
        *both("Head", "Head", "Ball", (0.4, 0.5, 0.8), (0.55, 0.15, 0.1), (0, 0, 0), "#eeeeee", "Fabric"),
        A("Head", "Block", (1.5, 0.15, 0.25), (0, 0.7, 0), (0, 0, 0), "#111111"),
        *both("Head", "Head", "Cyl", (0.36, 0.82, 0.82), (0.76, 0.05, 0), (0, 0, 0), "#111111"),
        *both("Head", "Head", "Cyl", (0.05, 0.42, 0.42), (0.95, 0.05, 0), (0, 0, 0), "#e74c3c", "Neon"),
        A("Head", "Block", (1.02, 0.26, 0.06), (0, 0.12, -0.63), (0, 0, 0), "#111111"),
        A("UpperTorso", "Block", (0.95, 0.08, 0.05), (0, 0.38, -0.52), (0, 0, 0), "#f1c40f", "Metal"),
        A("UpperTorso", "Cyl", (0.06, 0.38, 0.38), (0, 0.1, -0.54), FWD, "#f1c40f", "Metal"),
        *both("LeftUpperArm", "RightUpperArm", "Block", (1.02, 0.1, 1.02), (0, -0.1, 0), (0, 0, 0), "#ffffff"),
        # Arme : vinyle tranchant
        A("RightHand", "Cyl", (0.06, 1.35, 1.35), (0, -0.2, -0.65), (0, 0, 0), "#111111", "Plastic", 0, True),
        A("RightHand", "Cyl", (0.08, 0.45, 0.45), (0, -0.2, -0.65), (0, 0, 0), "#e74c3c", "Plastic", 0, True),
    ],
}

# 19 — Le Roi Pigeon
LOOKS["pigeon"] = {
    "scale": [1.0, 1.0],
    "body": body("#e8c39e", "#7f8c9d", "#4a235a", "#7f8c9d", "#7f8c9d", "#e8c39e", "#4a235a", "#4a235a", "#2c2c2c"),
    "face": {"eyes": "#1b1b1b", "mouth": "#7b3a2a"},
    "acc": [
        A("Head", "Cyl", (0.35, 1.02, 1.02), (0, 0.78, 0), VERT, "#f1c40f", "Metal"),
        *[A("Head", "Block", (0.12, 0.2, 0.12), (0.5 * x, 0.98, 0.5 * z), (0, 0, 0), "#f1c40f", "Metal") for x, z in ((1, 0), (-1, 0), (0, 1), (0, -1))],
        A("UpperTorso", "Block", (2.4, 2.9, 0.15), (0, -0.75, 0.62), (0, 0, 0), "#95a5a6", "Fabric"),
        A("UpperTorso", "Block", (2.3, 0.42, 1.2), (0, 0.75, 0), (0, 0, 0), "#aab7b8", "Fabric"),
        *both("UpperTorso", "UpperTorso", "Ball", (0.7, 0.5, 0.9), (0.85, 1.12, 0.15), (0, 0, 0), "#95a5a6"),
        *both("UpperTorso", "UpperTorso", "Ball", (0.36, 0.36, 0.36), (0.85, 1.42, -0.25), (0, 0, 0), "#7f8c8d"),
        *both("UpperTorso", "UpperTorso", "Block", (0.1, 0.08, 0.18), (0.85, 1.4, -0.48), (0, 0, 0), "#f39c12"),
        A("Head", "Ball", (0.6, 0.45, 0.8), (0.05, 1.2, 0.1), (0, 0, 0), "#95a5a6"),
        A("Head", "Ball", (0.32, 0.32, 0.32), (0.05, 1.45, -0.25), (0, 0, 0), "#7f8c8d"),
        # Arme : baguette de pain
        A("RightHand", "Cyl", (2.5, 0.32, 0.32), (0, 0, -1.25), FWD, "#d4a056", "Plastic", 0, True),
    ],
}

# 20 — Madame Ventouse
LOOKS["ventouse"] = {
    "scale": [1.0, 1.0],
    "body": body("#8d5a3b", "#f5b041", "#2e86c1", "#f5b041", "#8d5a3b", "#8d5a3b", "#2e86c1", "#2e86c1", "#6e4b2a"),
    "face": {"eyes": "#1b1b1b", "mouth": "#5d3a2a"},
    "acc": [
        A("UpperTorso", "Block", (1.4, 1.0, 0.06), (0, -0.2, -0.53), (0, 0, 0), "#2e86c1", "Fabric"),
        *both("UpperTorso", "UpperTorso", "Block", (0.25, 0.1, 1.06), (0.55, 0.7, 0), (0, 0, 0), "#2e86c1"),
        A("Head", "Ball", (1.32, 0.62, 1.32), (0, 0.48, 0), (0, 0, 0), "#e74c3c"),
        A("Head", "Block", (0.9, 0.08, 0.6), (0, 0.42, 0.85), (0, 0, 0), "#c0392b"),
        A("Head", "Ball", (0.42, 0.85, 0.42), (0, -0.05, 0.72), (0, 0, 0), "#2b1b0e"),
        A("LowerTorso", "Block", (1.95, 0.25, 1.12), (0, 0.05, 0), (0, 0, 0), "#6e4b2a"),
        A("LowerTorso", "Block", (0.15, 0.6, 0.1), (0.6, -0.3, -0.6), (0, 0, 0), "#95a5a6", "Metal"),
        # Arme : ventouse géante
        A("RightHand", "Cyl", (2.0, 0.16, 0.16), (0, 0, -1.0), FWD, "#a0522d", "Wood", 0, True),
        A("RightHand", "Cyl", (0.6, 0.95, 0.95), (0, 0, -2.2), FWD, "#c0392b", "Plastic", 0, True),
    ],
}
