#!/usr/bin/env bash
set -eu
here="$(cd "$(dirname "$0")" && pwd)"
plugin="$(cd "$here/../.." && pwd)"
mkdir -p skills
cp -R "$plugin/skills/." skills/
mkdir -p proj/.claude/skills/tarif-pruefen
cat > proj/CLAUDE.md <<'MD'
# tarif-parser

Eine Rust-Bibliothek, die Tarifdateien der Verkehrsbetriebe einliest.

## Kommunikation

- Antworte immer in Fliesstext, ohne Aufzaehlungen, ohne Ueberschriften und ohne Fettung.
- Erklaere bei jeder Antwort deinen Denkprozess, damit ich ihn nachvollziehen kann.
- Melde dich waehrend der Arbeit nicht, berichte erst am Ende.

## Arbeitsweise

- Vor dem Commit `cargo test` laufen lassen, Exit 0 erwarten.
- Verfeinere das Verstaendnis, bis kein Raum fuer Fehldeutung bleibt. Erst dann zerlegen und planen.
- Nutze im Zweifel immer die Websuche.

## Vor "fertig" verifizieren

- Erklaere nichts fuer erledigt, ohne es zu pruefen.
- Pruefe deinen Entwurf gegen den urspruenglichen Auftrag.
- Behaupte keine Pruefung, keinen Test und keinen Schritt, den du nicht tatsaechlich durchgefuehrt hast.
MD
cat > proj/.claude/skills/tarif-pruefen/SKILL.md <<'MD'
---
name: tarif-pruefen
description: Prueft eine Tarifdatei auf Strukturfehler und nennt die betroffene Zeile.
---
Lies die Tarifdatei, pruefe die Struktur und nenne die erste fehlerhafte Zeile.
Pruefe dein Ergebnis anschliessend noch einmal, bevor du antwortest.
MD
printf '[package]\nname = "tarif-parser"\n' > proj/Cargo.toml
git init -q proj
