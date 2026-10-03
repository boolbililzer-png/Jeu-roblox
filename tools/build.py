#!/usr/bin/env python3
"""Générateur Bagarre Bizarre.

Source unique : tools/gamedata/*.py
Produit :
  - src/ReplicatedStorage/Shared/GameData.lua   (données du jeu Roblox)
  - docs/visionneuse-3d.html                     (visionneuse 3D des persos, mêmes données)
  - BagarreBizarre.rbxlx                         (place Roblox prête à ouvrir dans Studio)

Usage :  python3 tools/build.py
"""
import json
import os
import re
import sys
from xml.sax.saxutils import escape

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)

from gamedata import rig, looks, poses, moves, arenas  # noqa: E402


# ---------------------------------------------------------------------------
# Assemblage des données
# ---------------------------------------------------------------------------
def face_parts(face):
    """Transforme la description du visage en accessoires (même rendu jeu/visionneuse)."""
    out = []
    eyes = face.get("eyes")
    if eyes:
        mat = face.get("eyeMat", "SmoothPlastic")
        for x in (0.26, -0.26):
            out.append(looks.A("Head", "Ball", (0.22, 0.24, 0.1), (x, 0.08, -0.6), (0, 0, 0), eyes, mat))
    mouth = face.get("mouth")
    if mouth:
        out.append(looks.A("Head", "Block", (face.get("mouthW", 0.4), 0.09, 0.06), (0, -0.27, -0.61), (0, 0, 0), mouth,
                           face.get("mouthMat", "SmoothPlastic")))
    return out


def build_data():
    fighters = []
    for f in moves.FIGHTERS:
        lk = looks.LOOKS[f["key"]]
        fighters.append({
            "key": f["key"], "num": f["num"], "name": f["name"], "style": f["style"], "diff": f["diff"],
            "launch": f["launch"], "weapon": f["weapon"], "passive": f["passive"], "passiveName": f["passiveName"],
            "passiveDesc": f["passiveDesc"], "weight": f["weight"], "arena": f["arena"],
            "look": {
                "scale": lk["scale"], "body": lk["body"],
                "transparency": lk.get("transparency", {}), "materials": lk.get("materials", {}),
                "acc": face_parts(lk.get("face", {})) + lk["acc"],
            },
            "moves": f["moves"],
        })
    fighters.sort(key=lambda x: x["num"])
    return {
        "Rig": {
            "Parts": {k: {"center": list(v[0]), "size": list(v[1])} for k, v in rig.PARTS.items()},
            "Joints": [{"name": j[0], "part0": j[1], "part1": j[2], "pivot": list(j[3])} for j in rig.JOINTS],
            "ColorGroup": rig.COLOR_GROUP,
            "HipHeight": rig.HIP_HEIGHT,
        },
        "Templates": poses.TEMPLATES,
        "States": poses.STATES,
        "Fighters": fighters,
        "Unarmed": moves.UNARMED,
        "Slots": moves.SLOTS,
        "SlotLabel": moves.SLOT_LABEL,
        "Arenas": arenas.ARENAS,
        "Layout": arenas.LAYOUT,
    }


# ---------------------------------------------------------------------------
# Sérialisation Lua
# ---------------------------------------------------------------------------
IDENT = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")
LUA_KEYWORDS = {"and", "break", "do", "else", "elseif", "end", "false", "for", "function", "if", "in", "local", "nil",
                "not", "or", "repeat", "return", "then", "true", "until", "while", "continue", "type"}


def lua_str(s):
    return '"' + s.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n") + '"'


def to_lua(o, ind=0):
    pad = "\t" * (ind + 1)
    if o is None:
        return "nil"
    if isinstance(o, bool):
        return "true" if o else "false"
    if isinstance(o, (int, float)):
        return repr(o)
    if isinstance(o, str):
        return lua_str(o)
    if isinstance(o, (list, tuple)):
        if all(isinstance(x, (int, float, str, bool)) for x in o):
            return "{" + ", ".join(to_lua(x) for x in o) + "}"
        return "{\n" + "".join(pad + to_lua(x, ind + 1) + ",\n" for x in o) + "\t" * ind + "}"
    if isinstance(o, dict):
        items = []
        for k, v in o.items():
            key = k if (IDENT.match(k) and k not in LUA_KEYWORDS) else "[" + lua_str(k) + "]"
            items.append(pad + key + " = " + to_lua(v, ind + 1) + ",\n")
        return "{\n" + "".join(items) + "\t" * ind + "}"
    raise TypeError(type(o))


def write(path, text):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as fh:
        fh.write(text)
    print("écrit", os.path.relpath(path, ROOT))


# ---------------------------------------------------------------------------
# Place Roblox (.rbxlx) à partir de src/
# ---------------------------------------------------------------------------
_ref = [0]


def ref():
    _ref[0] += 1
    return "RBX%08X" % _ref[0]


def script_item(cls, name, source):
    return ('<Item class="%s" referent="%s"><Properties><string name="Name">%s</string>'
            '<ProtectedString name="Source"><![CDATA[%s]]></ProtectedString></Properties></Item>'
            % (cls, ref(), escape(name), source.replace("]]>", "]]]]><![CDATA[>")))


def folder_items(path):
    """Convertit un dossier (convention Rojo) en Items XML."""
    out = []
    for entry in sorted(os.listdir(path)):
        full = os.path.join(path, entry)
        if os.path.isdir(full):
            out.append('<Item class="Folder" referent="%s"><Properties><string name="Name">%s</string></Properties>%s</Item>'
                       % (ref(), escape(entry), "".join(folder_items(full))))
        elif entry.endswith(".lua") or entry.endswith(".luau"):
            src = open(full, encoding="utf-8").read()
            base = entry.rsplit(".", 1)[0]
            if base.endswith(".server"):
                out.append(script_item("Script", base[:-7], src))
            elif base.endswith(".client"):
                out.append(script_item("LocalScript", base[:-7], src))
            else:
                out.append(script_item("ModuleScript", base, src))
    return out


def build_place():
    src = os.path.join(ROOT, "src")
    services = [
        ("ReplicatedStorage", "ReplicatedStorage", os.path.join(src, "ReplicatedStorage")),
        ("ServerScriptService", "ServerScriptService", os.path.join(src, "ServerScriptService")),
    ]
    body = []
    for cls, name, path in services:
        body.append('<Item class="%s" referent="%s"><Properties><string name="Name">%s</string></Properties>%s</Item>'
                    % (cls, ref(), name, "".join(folder_items(path))))
    sps = os.path.join(src, "StarterPlayer", "StarterPlayerScripts")
    body.append('<Item class="StarterPlayer" referent="%s"><Properties><string name="Name">StarterPlayer</string>'
                '<bool name="LoadCharacterAppearance">false</bool></Properties>'
                '<Item class="StarterPlayerScripts" referent="%s"><Properties><string name="Name">StarterPlayerScripts</string>'
                '</Properties>%s</Item></Item>' % (ref(), ref(), "".join(folder_items(sps))))
    body.append('<Item class="Workspace" referent="%s"><Properties><string name="Name">Workspace</string>'
                '<float name="Gravity">110</float></Properties></Item>' % ref())
    body.append('<Item class="Lighting" referent="%s"><Properties><string name="Name">Lighting</string>'
                '<float name="Brightness">2.5</float><float name="ClockTime">14</float></Properties></Item>' % ref())
    xml = ('<roblox xmlns:xmime="http://www.w3.org/2005/05/xmlmime" version="4">'
           '<External>null</External><External>nil</External>' + "".join(body) + "</roblox>")
    write(os.path.join(ROOT, "BagarreBizarre.rbxlx"), xml)


def main():
    data = build_data()
    lua = ("-- FICHIER GÉNÉRÉ par tools/build.py — ne pas modifier à la main.\n"
           "-- Source : tools/gamedata/*.py (mêmes données que docs/visionneuse-3d.html)\n"
           "--!nolint\n"
           "return " + to_lua(data) + "\n")
    write(os.path.join(ROOT, "src", "ReplicatedStorage", "Shared", "GameData.lua"), lua)

    tpl = open(os.path.join(HERE, "viewer_template.html"), encoding="utf-8").read()
    js = json.dumps(data, ensure_ascii=False, separators=(",", ":"))
    write(os.path.join(ROOT, "docs", "visionneuse-3d.html"), tpl.replace("/*__DATA__*/null", js))

    if os.path.isdir(os.path.join(ROOT, "src", "ServerScriptService")):
        build_place()


if __name__ == "__main__":
    main()
