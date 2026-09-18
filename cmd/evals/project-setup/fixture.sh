#!/usr/bin/env bash
# Legt den Workspace fuer diesen Fall an: den zu bewertenden Skilltext plus ein
# Fixture-Projekt. Laeuft als der Aufrufende, ausserhalb der Agent-Sandbox, nur mit --scaffold.
set -eu
here="$(cd "$(dirname "$0")" && pwd)"
plugin="$(cd "$here/../.." && pwd)"
mkdir -p skills
cp -R "$plugin/skills/." skills/
mkdir -p proj/.claude
cat > proj/CLAUDE.md <<'MD'
# Beispielprojekt

Arbeite sorgfaeltig und teste deine Aenderungen.
MD
printf '{\n  "permissions": { "allow": ["Read"] }\n}\n' > proj/.claude/settings.json
git init -q proj
