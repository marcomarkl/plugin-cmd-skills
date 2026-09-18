#!/usr/bin/env bash
set -eu
here="$(cd "$(dirname "$0")" && pwd)"
plugin="$(cd "$here/../.." && pwd)"
mkdir -p skills
cp -R "$plugin/skills/." skills/
mkdir -p proj
cat > proj/HANDOFF.md <<MD
# Uebergabe

Stand: 2026-09-01 14:20 CEST

## Ziel
Retry-Logik im HTTP-Client fertigstellen.

## Fertig
- Commit a1b2c3d: Grundgeruest des Clients

## Offen
- Backoff-Strategie waehlen und implementieren
- Tests fuer den Fehlerfall schreiben

## Unsicher
- Ob der Parser UTF-8 mit BOM vertraegt; im Verlauf nicht mehr nachvollziehbar, pruefbar an tests/test_parser.py
MD
printf 'print("client")\n' > proj/client.py
git init -q proj
