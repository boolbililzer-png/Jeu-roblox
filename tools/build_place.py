#!/usr/bin/env python3
"""Fabrique BagarreBizarre.rbxlx (place Roblox à ouvrir dans Studio) à partir du dossier src/.

Même convention que Rojo : un dossier = Folder, *.server.lua = Script, *.client.lua = LocalScript,
*.lua = ModuleScript. Usage : python3 tools/build_place.py
"""
import os
from xml.sax.saxutils import escape

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, "src")
SERVICES = {"ReplicatedStorage": "ReplicatedStorage", "ServerScriptService": "ServerScriptService",
            "StarterPlayer": "StarterPlayer"}
CONTAINERS = {"StarterPlayerScripts": "StarterPlayerScripts", "StarterCharacterScripts": "StarterCharacterScripts"}
counter = [0]


def ref():
    counter[0] += 1
    return str(counter[0])


def item(cls, name, inner="", extra=""):
    return ('<Item class="%s" referent="%s"><Properties><string name="Name">%s</string>%s</Properties>%s</Item>'
            % (cls, ref(), escape(name), extra, inner))


def script(cls, name, source):
    run = '<token name="RunContext">0</token>' if cls == "Script" else ""
    src = '<string name="Source"><![CDATA[%s]]></string>' % source.replace("]]>", "]]]]><![CDATA[>")
    return item(cls, name, extra=run + src)


def walk(path, cls_override=None):
    out = []
    for entry in sorted(os.listdir(path)):
        full = os.path.join(path, entry)
        if os.path.isdir(full):
            cls = CONTAINERS.get(entry, "Folder")
            out.append(item(cls, entry, "".join(walk(full))))
        elif entry.endswith(".lua"):
            src = open(full, encoding="utf-8").read()
            base = entry[:-4]
            if base.endswith(".server"):
                out.append(script("Script", base[:-7], src))
            elif base.endswith(".client"):
                out.append(script("LocalScript", base[:-7], src))
            else:
                out.append(script("ModuleScript", base, src))
    return out


def main():
    body = []
    for folder, cls in SERVICES.items():
        body.append(item(cls, folder, "".join(walk(os.path.join(SRC, folder)))))
    xml = '<roblox version="4">' + "".join(body) + "</roblox>"
    out = os.path.join(ROOT, "BagarreBizarre.rbxlx")
    with open(out, "w", encoding="utf-8") as fh:
        fh.write(xml)
    print("écrit", os.path.relpath(out, ROOT), "(%d objets)" % counter[0])


if __name__ == "__main__":
    main()
