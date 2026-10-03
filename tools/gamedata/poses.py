"""Poses et gabarits d'animation procédurale (partagés jeu + visionneuse).

Une pose = {articulation: (rotX, rotY, rotZ)} en degrés, appliquée à Motor6D.Transform
via CFrame.Angles (ordre X, Y, Z). "RootPos" = décalage (x, y, z) du bassin.
Conventions (perso qui regarde vers -Z) :
  Epaule X+ = bras vers l'avant/haut   Epaule Z+ (droite) / Z- (gauche) = bras sur le côté
  Coude X+ = avant-bras plié vers l'avant   Hanche X+ = jambe vers l'avant   Genou X- = tibia plié
  Waist X- = se penche en avant   Waist Y+ = torse tourné (bras droit vers l'avant)
  Root = tout le corps autour du bassin.

Chaque coup suit 4 phases : AVANT (garde) -> ELAN (windup) -> FRAPPE (strike) -> RETOUR (garde).
"""

GARDE = {
    "RightShoulder": (35, 0, 12), "RightElbow": (95, 0, 0),
    "LeftShoulder": (50, 0, -12), "LeftElbow": (85, 0, 0),
    "Waist": (0, -12, 0), "Neck": (0, 10, 0),
    "RightHip": (-10, 0, 4), "RightKnee": (-18, 0, 0),
    "LeftHip": (18, 0, -4), "LeftKnee": (-22, 0, 0),
    "RootPos": (0, -0.12, 0),
}

SQUAT = {"RightHip": (80, 0, 6), "RightKnee": (-125, 0, 0), "LeftHip": (80, 0, -6), "LeftKnee": (-125, 0, 0),
         "RightAnkle": (40, 0, 0), "LeftAnkle": (40, 0, 0), "RootPos": (0, -0.95, 0)}

def P(*dicts, **kw):
    out = {}
    for d in dicts:
        out.update(d)
    out.update(kw)
    return out

TEMPLATES = {
    "jab": {
        "windup": P(GARDE, RightShoulder=(55, 0, 10), RightElbow=(120, 0, 0), Waist=(0, -28, 0)),
        "strike": P(GARDE, RightShoulder=(92, 0, 0), RightElbow=(0, 0, 0), Waist=(0, 28, 0), RootPos=(0, -0.12, -0.25)),
        "alt": P(GARDE, LeftShoulder=(92, 0, 0), LeftElbow=(0, 0, 0), Waist=(0, -28, 0), RootPos=(0, -0.12, -0.25)),
    },
    "hook": {
        "windup": P(GARDE, RightShoulder=(10, 0, 95), RightElbow=(30, 0, 0), Waist=(0, -55, 0)),
        "strike": P(GARDE, RightShoulder=(10, 0, 95), RightElbow=(10, 0, 0), Waist=(0, 65, 0), RootPos=(0, -0.15, -0.3)),
    },
    "uppercut": {
        "windup": P(GARDE, SQUAT, RightShoulder=(-25, 0, 10), RightElbow=(100, 0, 0), Waist=(-18, -20, 0), RootPos=(0, -0.6, 0)),
        "strike": P(GARDE, RightShoulder=(172, 0, 0), RightElbow=(8, 0, 0), Waist=(12, 25, 0), Neck=(20, 0, 0),
                    RightHip=(0, 0, 0), LeftHip=(0, 0, 0), RightKnee=(0, 0, 0), LeftKnee=(0, 0, 0), RootPos=(0, 0.3, 0)),
    },
    "overhead": {
        "windup": P(GARDE, RightShoulder=(175, 0, 10), RightElbow=(40, 0, 0), LeftShoulder=(150, 0, -10), Waist=(18, 0, 0), Neck=(12, 0, 0)),
        "strike": P(GARDE, RightShoulder=(55, 0, 0), RightElbow=(0, 0, 0), LeftShoulder=(50, 0, 0), Waist=(-38, 0, 0), Neck=(-10, 0, 0),
                    RootPos=(0, -0.35, -0.3)),
    },
    "kick": {
        "windup": P(GARDE, RightHip=(75, 0, 0), RightKnee=(-95, 0, 0), RightShoulder=(25, 0, 35), LeftShoulder=(25, 0, -35)),
        "strike": P(GARDE, RightHip=(100, 0, 0), RightKnee=(0, 0, 0), LeftKnee=(-8, 0, 0), Waist=(14, 0, 0), RightShoulder=(15, 0, 45),
                    LeftShoulder=(15, 0, -45)),
    },
    "sidekick": {
        "windup": P(GARDE, RightHip=(45, 0, 45), RightKnee=(-100, 0, 0), Root=(0, -25, 0), Waist=(0, 0, 10)),
        "strike": P(GARDE, RightHip=(30, 0, 88), RightKnee=(0, 0, 0), Root=(0, 55, 0), Waist=(0, 0, -22), RightShoulder=(0, 0, 40),
                    LeftShoulder=(0, 0, -60)),
    },
    "sweep": {
        "windup": P(GARDE, SQUAT, RightHip=(10, 0, 75), RightKnee=(0, 0, 0), Root=(0, -45, 0), Waist=(-20, 0, 0),
                    RightShoulder=(20, 0, 30), LeftShoulder=(30, 0, -40)),
        "strike": P(GARDE, SQUAT, RightHip=(10, 0, 80), RightKnee=(0, 0, 0), Root=(0, 75, 0), Waist=(-25, 0, 0),
                    RightShoulder=(20, 0, 30), LeftShoulder=(30, 0, -40)),
    },
    "stomp": {
        "windup": P(GARDE, RightHip=(85, 0, 0), RightKnee=(-95, 0, 0), RightShoulder=(20, 0, 50), LeftShoulder=(20, 0, -50)),
        "strike": P(GARDE, RightHip=(12, 0, 0), RightKnee=(-4, 0, 0), Waist=(-22, 0, 0), RootPos=(0, -0.3, 0),
                    RightShoulder=(10, 0, 55), LeftShoulder=(10, 0, -55)),
    },
    "thrust": {
        "windup": P(GARDE, RightShoulder=(60, 0, 5), RightElbow=(125, 0, 0), Waist=(0, -38, 0)),
        "strike": P(GARDE, RightShoulder=(92, 0, 0), RightElbow=(0, 0, 0), Waist=(-10, 38, 0), RightHip=(45, 0, 0), RightKnee=(-45, 0, 0),
                    LeftHip=(-30, 0, 0), RootPos=(0, -0.35, -0.7)),
    },
    "throw": {
        "windup": P(GARDE, RightShoulder=(165, 0, 25), RightElbow=(95, 0, 0), LeftShoulder=(70, 0, -20), Waist=(10, -40, 0)),
        "strike": P(GARDE, RightShoulder=(75, 0, 0), RightElbow=(0, 0, 0), LeftShoulder=(-20, 0, -20), Waist=(-20, 40, 0),
                    RootPos=(0, -0.2, -0.3)),
    },
    "cast": {
        "windup": P(GARDE, RightShoulder=(55, 0, 25), LeftShoulder=(55, 0, -25), RightElbow=(115, 0, 0), LeftElbow=(115, 0, 0), Waist=(10, 0, 0)),
        "strike": P(GARDE, RightShoulder=(90, 0, 3), LeftShoulder=(90, 0, -3), RightElbow=(0, 0, 0), LeftElbow=(0, 0, 0), Waist=(-15, 0, 0),
                    RootPos=(0, -0.15, -0.2)),
    },
    "spin": {
        "windup": P(GARDE, RightShoulder=(0, 0, 90), LeftShoulder=(0, 0, -90), RightElbow=(0, 0, 0), LeftElbow=(0, 0, 0), Root=(0, -90, 0)),
        "strike": P(GARDE, RightShoulder=(0, 0, 90), LeftShoulder=(0, 0, -90), RightElbow=(0, 0, 0), LeftElbow=(0, 0, 0), Root=(0, 270, 0)),
    },
    "bodyslam": {
        "windup": P(GARDE, Root=(15, 0, 0), Waist=(22, 0, 0), RightShoulder=(-45, 0, 20), LeftShoulder=(-45, 0, -20)),
        "strike": P(GARDE, Root=(-22, 0, 0), Waist=(-12, 0, 0), RightShoulder=(-30, 0, 45), LeftShoulder=(-30, 0, -45), RootPos=(0, -0.1, -0.9)),
    },
    "airkick": {
        "windup": P(GARDE, RightHip=(80, 0, 0), RightKnee=(-120, 0, 0), LeftHip=(70, 0, 0), LeftKnee=(-120, 0, 0), Root=(-10, 0, 0)),
        "strike": P(GARDE, RightHip=(95, 0, 0), RightKnee=(0, 0, 0), LeftHip=(60, 0, 0), LeftKnee=(-110, 0, 0), Root=(20, 0, 0),
                    RightShoulder=(20, 0, 60), LeftShoulder=(20, 0, -60)),
    },
    "airdown": {
        "windup": P(GARDE, RightHip=(90, 0, 0), RightKnee=(-130, 0, 0), LeftHip=(90, 0, 0), LeftKnee=(-130, 0, 0), Waist=(-25, 0, 0)),
        "strike": P(GARDE, RightHip=(0, 0, 0), RightKnee=(0, 0, 0), LeftHip=(70, 0, 0), LeftKnee=(-110, 0, 0), Waist=(-10, 0, 0),
                    RightShoulder=(140, 0, 30), LeftShoulder=(140, 0, -30), RootPos=(0, -0.4, 0)),
    },
    "dash": {
        "windup": P(GARDE, Root=(-10, 0, 0), Waist=(-18, 0, 0), RightHip=(30, 0, 0), RightKnee=(-50, 0, 0)),
        "strike": P(GARDE, Root=(-30, 0, 0), Waist=(-10, 0, 0), RightShoulder=(90, 0, 10), LeftShoulder=(90, 0, -10), RightElbow=(10, 0, 0),
                    LeftElbow=(10, 0, 0), RightHip=(60, 0, 0), RightKnee=(-65, 0, 0), LeftHip=(-35, 0, 0), LeftKnee=(-40, 0, 0)),
    },
    "charge": {
        "windup": P(GARDE, SQUAT, Waist=(-25, 30, 0), RootPos=(0, -0.5, 0)),
        "strike": P(GARDE, Root=(-25, 0, 0), Waist=(0, 60, 0), RightShoulder=(20, 0, 45), LeftShoulder=(70, 0, -10), LeftHip=(55, 0, 0),
                    LeftKnee=(-65, 0, 0), RightHip=(-35, 0, 0), RootPos=(0, -0.2, -0.6)),
    },
    "trap": {
        "windup": P(GARDE, SQUAT, Waist=(-30, 0, 0), RightShoulder=(70, 0, 0), RightElbow=(40, 0, 0)),
        "strike": P(GARDE, SQUAT, Waist=(-45, 0, 0), RightShoulder=(35, 0, 0), RightElbow=(0, 0, 0)),
    },
    "drink": {
        "windup": P(GARDE, RightShoulder=(125, 0, -30), RightElbow=(115, 0, 0), Neck=(20, 0, 0)),
        "strike": P(GARDE, RightShoulder=(150, 0, -35), RightElbow=(100, 0, 0), Neck=(38, 0, 0), Waist=(10, 0, 0)),
    },
    "counter": {
        "windup": P(GARDE, RightShoulder=(100, 0, -35), LeftShoulder=(100, 0, 35), RightElbow=(95, 0, 0), LeftElbow=(95, 0, 0), RootPos=(0, -0.35, 0)),
        "strike": P(GARDE, RightShoulder=(92, 0, 0), RightElbow=(0, 0, 0), Waist=(0, 40, 0), RootPos=(0, -0.15, -0.4)),
    },
    "roar": {
        "windup": P(GARDE, RightShoulder=(20, 0, 30), LeftShoulder=(20, 0, -30), RightElbow=(100, 0, 0), LeftElbow=(100, 0, 0),
                    Neck=(-22, 0, 0), RootPos=(0, -0.5, 0)),
        "strike": P(GARDE, RightShoulder=(0, 0, 125), LeftShoulder=(0, 0, -125), RightElbow=(0, 0, 0), LeftElbow=(0, 0, 0),
                    Neck=(28, 0, 0), Waist=(12, 0, 0), RightHip=(0, 0, 22), LeftHip=(0, 0, -22), RightKnee=(0, 0, 0), LeftKnee=(0, 0, 0)),
    },
    "recovery": {
        "windup": P(GARDE, SQUAT, RightShoulder=(-40, 0, 15), LeftShoulder=(-40, 0, -15), RootPos=(0, -0.6, 0)),
        "strike": P(GARDE, RightShoulder=(176, 0, 12), LeftShoulder=(176, 0, -12), RightElbow=(0, 0, 0), LeftElbow=(0, 0, 0),
                    Neck=(25, 0, 0), RightHip=(-8, 0, 0), LeftHip=(10, 0, 0), RightKnee=(-10, 0, 0), LeftKnee=(-30, 0, 0), RootPos=(0, 0.2, 0)),
    },
    "groundpound": {
        "windup": P(GARDE, RightHip=(100, 0, 0), RightKnee=(-130, 0, 0), LeftHip=(100, 0, 0), LeftKnee=(-130, 0, 0), Root=(-20, 0, 0),
                    RightShoulder=(160, 0, 20), LeftShoulder=(160, 0, -20)),
        "strike": P(GARDE, Root=(-78, 0, 0), RightShoulder=(172, 0, 18), LeftShoulder=(172, 0, -18), RightElbow=(0, 0, 0), LeftElbow=(0, 0, 0),
                    RightHip=(0, 0, 0), LeftHip=(0, 0, 0), RightKnee=(0, 0, 0), LeftKnee=(0, 0, 0)),
    },
    "grab": {
        "windup": P(GARDE, RightShoulder=(80, 0, 35), LeftShoulder=(80, 0, -35), RightElbow=(25, 0, 0), LeftElbow=(25, 0, 0)),
        "strike": P(GARDE, RightShoulder=(88, 0, 4), LeftShoulder=(88, 0, -4), RightElbow=(70, 0, 0), LeftElbow=(70, 0, 0), Waist=(-15, 0, 0),
                    RootPos=(0, -0.15, -0.3)),
    },
}

# Poses d'état (hors coups)
STATES = {
    "garde": GARDE,
    "hurt": P(GARDE, Root=(18, 0, 0), Waist=(20, 0, 0), Neck=(28, 0, 0), RightShoulder=(40, 0, 65), LeftShoulder=(40, 0, -65),
              RightElbow=(20, 0, 0), LeftElbow=(20, 0, 0)),
    "jump": P(GARDE, RightHip=(55, 0, 0), RightKnee=(-80, 0, 0), LeftHip=(10, 0, 0), LeftKnee=(-40, 0, 0),
              RightShoulder=(30, 0, 45), LeftShoulder=(30, 0, -45)),
    "fall": P(GARDE, RightHip=(20, 0, 8), RightKnee=(-30, 0, 0), LeftHip=(35, 0, -8), LeftKnee=(-55, 0, 0),
              RightShoulder=(60, 0, 70), LeftShoulder=(60, 0, -70), RightElbow=(10, 0, 0), LeftElbow=(10, 0, 0)),
    "runA": P(GARDE, Root=(-12, 0, 0), RightHip=(50, 0, 0), RightKnee=(-25, 0, 0), LeftHip=(-40, 0, 0), LeftKnee=(-75, 0, 0),
              RightShoulder=(-40, 0, 8), LeftShoulder=(55, 0, -8), RightElbow=(70, 0, 0), LeftElbow=(70, 0, 0)),
    "runB": P(GARDE, Root=(-12, 0, 0), LeftHip=(50, 0, 0), LeftKnee=(-25, 0, 0), RightHip=(-40, 0, 0), RightKnee=(-75, 0, 0),
              LeftShoulder=(-40, 0, -8), RightShoulder=(55, 0, 8), RightElbow=(70, 0, 0), LeftElbow=(70, 0, 0)),
    "dodge": P(GARDE, Root=(14, 0, 0), RightShoulder=(100, 0, -35), LeftShoulder=(100, 0, 35), RightElbow=(110, 0, 0),
               LeftElbow=(110, 0, 0), RootPos=(0, -0.4, 0.3)),
    "victory": P(GARDE, RightShoulder=(172, 0, 18), RightElbow=(10, 0, 0), LeftShoulder=(20, 0, -30), Neck=(15, 0, 0)),
    "grabbed": P(GARDE, RightShoulder=(10, 0, 30), LeftShoulder=(10, 0, -30), RightElbow=(10, 0, 0), LeftElbow=(10, 0, 0), Neck=(-10, 0, 0),
                 RightKnee=(-40, 0, 0), LeftKnee=(-40, 0, 0)),
}
