"""Rig R15 commun à tous les combattants.

Coordonnées en studs, origine au sol, Y vers le haut, le personnage regarde vers -Z
(comme le LookVector Roblox). Chaque partie est définie par son centre et sa taille
en pose de repos ; chaque articulation (Motor6D) par son point de pivot.
Le jeu (Lua) et la visionneuse 3D (JS) calculent C0/C1 de la même façon :
    C0 = pivot - centre(Part0)      C1 = pivot - centre(Part1)
"""

PARTS = {
    # nom              centre               taille
    "HumanoidRootPart": ((0.0, 2.8, 0.0), (2.0, 2.0, 1.0)),
    "LowerTorso":       ((0.0, 2.4, 0.0), (1.8, 0.4, 1.0)),
    "UpperTorso":       ((0.0, 3.3, 0.0), (2.0, 1.4, 1.0)),
    "Head":             ((0.0, 4.6, 0.0), (1.2, 1.2, 1.2)),
    "RightUpperArm":    ((1.5, 3.5, 0.0), (1.0, 1.0, 1.0)),
    "RightLowerArm":    ((1.5, 2.6, 0.0), (0.9, 0.8, 0.9)),
    "RightHand":        ((1.5, 2.05, 0.0), (0.8, 0.3, 0.8)),
    "LeftUpperArm":     ((-1.5, 3.5, 0.0), (1.0, 1.0, 1.0)),
    "LeftLowerArm":     ((-1.5, 2.6, 0.0), (0.9, 0.8, 0.9)),
    "LeftHand":         ((-1.5, 2.05, 0.0), (0.8, 0.3, 0.8)),
    "RightUpperLeg":    ((0.5, 1.7, 0.0), (0.95, 1.0, 1.0)),
    "RightLowerLeg":    ((0.5, 0.75, 0.0), (0.9, 0.9, 0.9)),
    "RightFoot":        ((0.5, 0.15, -0.1), (0.9, 0.3, 1.2)),
    "LeftUpperLeg":     ((-0.5, 1.7, 0.0), (0.95, 1.0, 1.0)),
    "LeftLowerLeg":     ((-0.5, 0.75, 0.0), (0.9, 0.9, 0.9)),
    "LeftFoot":         ((-0.5, 0.15, -0.1), (0.9, 0.3, 1.2)),
}

# Hauteur du bas du HumanoidRootPart au sol (Humanoid.HipHeight) à l'échelle 1.
HIP_HEIGHT = 1.8

JOINTS = [
    # nom              part0             part1             pivot
    ("Root",          "HumanoidRootPart", "LowerTorso",    (0.0, 2.4, 0.0)),
    ("Waist",         "LowerTorso",      "UpperTorso",     (0.0, 2.6, 0.0)),
    ("Neck",          "UpperTorso",      "Head",           (0.0, 4.0, 0.0)),
    ("RightShoulder", "UpperTorso",      "RightUpperArm",  (1.5, 3.8, 0.0)),
    ("RightElbow",    "RightUpperArm",   "RightLowerArm",  (1.5, 3.0, 0.0)),
    ("RightWrist",    "RightLowerArm",   "RightHand",      (1.5, 2.2, 0.0)),
    ("LeftShoulder",  "UpperTorso",      "LeftUpperArm",   (-1.5, 3.8, 0.0)),
    ("LeftElbow",     "LeftUpperArm",    "LeftLowerArm",   (-1.5, 3.0, 0.0)),
    ("LeftWrist",     "LeftLowerArm",    "LeftHand",       (-1.5, 2.2, 0.0)),
    ("RightHip",      "LowerTorso",      "RightUpperLeg",  (0.5, 2.2, 0.0)),
    ("RightKnee",     "RightUpperLeg",   "RightLowerLeg",  (0.5, 1.2, 0.0)),
    ("RightAnkle",    "RightLowerLeg",   "RightFoot",      (0.5, 0.3, 0.0)),
    ("LeftHip",       "LowerTorso",      "LeftUpperLeg",   (-0.5, 2.2, 0.0)),
    ("LeftKnee",      "LeftUpperLeg",    "LeftLowerLeg",   (-0.5, 1.2, 0.0)),
    ("LeftAnkle",     "LeftLowerLeg",    "LeftFoot",       (-0.5, 0.3, 0.0)),
]

# Groupe de couleur de chaque partie (les looks donnent une couleur par groupe).
COLOR_GROUP = {
    "Head": "head", "UpperTorso": "torso", "LowerTorso": "hips",
    "RightUpperArm": "uarm", "LeftUpperArm": "uarm",
    "RightLowerArm": "larm", "LeftLowerArm": "larm",
    "RightHand": "hand", "LeftHand": "hand",
    "RightUpperLeg": "uleg", "LeftUpperLeg": "uleg",
    "RightLowerLeg": "lleg", "LeftLowerLeg": "lleg",
    "RightFoot": "foot", "LeftFoot": "foot",
}
