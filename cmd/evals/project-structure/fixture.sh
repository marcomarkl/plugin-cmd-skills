#!/usr/bin/env bash
set -eu
here="$(cd "$(dirname "$0")" && pwd)"
plugin="$(cd "$here/../.." && pwd)"
mkdir -p skills
cp -R "$plugin/skills/." skills/
mkdir -p proj/docs
cat > proj/CLAUDE.md <<MD
# Beispielprojekt

Ein kleines Python-Werkzeug.
MD
cat > proj/NOTES.md <<MD
# Notizen

- TODO: Retry-Logik fuer den HTTP-Client bauen
- Entscheidung: wir bleiben bei requests statt httpx, weil der Rest des Stacks es nutzt
- Der Parser erwartet UTF-8 ohne BOM, sonst bricht er still ab
MD
printf '# Alte Ideen\n\n- Caching vielleicht spaeter\n' > proj/IDEEN.md
printf '# Handbuch\n\nInstallation via pip.\n' > proj/docs/handbuch.md
git init -q proj
