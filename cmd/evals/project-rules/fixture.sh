#!/usr/bin/env bash
set -eu
here="$(cd "$(dirname "$0")" && pwd)"
plugin="$(cd "$here/../.." && pwd)"
mkdir -p skills
cp -R "$plugin/skills/." skills/
mkdir -p proj
cat > proj/CLAUDE.md <<MD
# Beispielprojekt

Ein kleines Python-Werkzeug. Build und Tests laufen ueber make.

## Arbeitsweise
- Arbeite sorgfaeltig.
- Teste deine Aenderungen.
- Sei vorsichtig bei riskanten Aktionen.
MD
printf "all:\n\tpython -m pytest\n" > proj/Makefile
git init -q proj
