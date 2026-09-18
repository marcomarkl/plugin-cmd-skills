#!/usr/bin/env bash
set -eu
here="$(cd "$(dirname "$0")" && pwd)"
plugin="$(cd "$here/../.." && pwd)"
mkdir -p skills
cp -R "$plugin/skills/." skills/
mkdir -p proj
cat > proj/CLAUDE.md <<'MD'
# Zahlungsdienst

Bitte arbeite stets gewissenhaft und mit der gebotenen Sorgfalt; deine Arbeit ist fuer das Team sehr wichtig.

## Arbeitsweise

- Fuehre vor jedem Commit die Tests aus.
- Bevor du committest, lass die Testsuite laufen.
- Formatiere den Code ordentlich.
- Das Projekt ist in Python geschrieben und nutzt pytest als Testrunner.

## Sicherheit

- Hole vor Aktionen mit bleibender Wirkung eine Bestaetigung ein: deployen, dauerhaft loeschen, Zugriffsrechte aendern.
- **Ausnahme, die bleibt:** Bei Datenbank-Migrationen wird jede Aenderung einzeln freigegeben, auch die scheinbar triviale. Ein Sammelvorgang ist hier ausgeschlossen.
- Gib Zugangsdaten, Tokens oder Schluessel nie im Klartext aus.

## Antwortlaenge

Der folgende Block ist der Originalwortlaut aus dem Herstellerleitfaden und bleibt unuebersetzt:

> Keep responses focused, brief, and concise. Keep disclaimers and caveats short, and spend most of the response on the main answer. When asked to explain something, give a high-level summary unless an in-depth explanation is specifically requested.

## Release durchfuehren

1. Version in pyproject.toml anheben.
2. CHANGELOG.md ergaenzen.
3. make test laufen lassen, gruen erwarten.
4. Tag setzen mit git tag -a vX.Y.Z.
5. make build, danach die Artefakte in dist/ pruefen.
6. Upload mit twine, erst testpypi, dann pypi.
7. Nach dem Upload die Installation in einem frischen venv pruefen.

## Ablage

- Offene Punkte: GitHub Issues
- Entscheidungen: docs/decisions/, NNNN-titel.md
- Wissen: docs/
- Erledigtes/Releases: CHANGELOG.md und git-Historie
MD
printf "all:\n\tpython -m pytest\n" > proj/Makefile
git init -q proj
