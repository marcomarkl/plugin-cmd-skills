---
name: marketplace-verwaltung
description: Lokaler Maintainer-Pfad für den Marketplace marco-markl und das Plugin cmd — installieren, aktualisieren, deaktivieren, deinstallieren, neu registrieren. Nutze diesen Skill, wenn im Repo plugin-cmd-skills eine Marketplace- oder Plugin-Registrierung angefasst werden soll, wenn `claude plugin list` einen `cache-miss` meldet oder wenn ein Marketplace-Pfad nach Verschieben oder Umbenennen des Repo-Ordners tot ist.
---

# Marketplace und Plugin verwalten (lokaler Maintainer-Pfad)

Der **öffentliche** Installationsweg (für Fremde, über GitHub) steht im [Root-README](../../../README.md); hier geht es um den lokalen Maintainer-Pfad. Als CLI (`claude plugin …`); die meisten Befehle gibt es auch als `/plugin …` in der Session. Die remove/add-Sequenz weiter unten gilt für den **noch nicht registrierten** Fall — auf dieser Maschine ist `marco-markl` bereits registriert und das Plugin installiert.

## Repo-Änderung ausrollen: drei Schritte

**`marketplace update` allein genügt nicht.** Es aktualisiert den Marketplace-Klon und legt die neue Version in den Cache, hebt aber die *installierte* Version nicht an — eine neue Session lud danach messbar weiterhin die alte. Und weil `marco-markl` als **GitHub-Source** registriert ist (`known_marketplaces.json`: `{"source": "github", "repo": "marcomarkl/plugin-cmd-skills"}`), liest der Befehl vom Remote, nicht aus dem Arbeitsverzeichnis: ohne Push passiert gar nichts.

```
git push
claude plugin marketplace update marco-markl   # Marketplace holen, neue Version in den Cache
claude plugin update cmd@marco-markl           # installierte Version anheben ("restart required")
```

Danach `/reload-plugins` oder eine neue Session. Ergebnis objektiv prüfen am `system/init`-Event (`plugins[].version` **und** `path`), nicht an `claude plugin list` allein:

```
claude -p "hi" --output-format stream-json --verbose
```

Zum reinen Bauen und Testen brauchst du das alles nicht — `claude --plugin-dir ./cmd` lädt den Arbeitsverzeichnis-Stand direkt.

## Freigabe einholen

Diese Befehle wirken **außerhalb** des Repos in die Nutzer-Konfiguration (`marketplace add/remove`, `install/uninstall`, `enable/disable`, `--scope user`) — nicht ungefragt ausführen; nenne vorher Ziel, Umfang und Wirkung und hol die Freigabe ein. Je schwerer umkehrbar, desto höher die Hürde; bevorzuge den umkehrbaren Schritt (`marketplace update` plus `plugin update` statt uninstall/reinstall) — ausser der Pfad selbst ist tot, dann führt nur remove/add zum Ziel.

Die Befehle sind nicht gefahrlos wiederholbar: prüfe nach einem Fehlschlag erst den tatsächlichen Zustand (`claude plugin list`), statt sie ein zweites Mal auszulösen.

## Toter Marketplace-Pfad (`cache-miss`)

**Gilt nur bei einer Registrierung mit `source: directory`.** Aktuell ist `marco-markl` als GitHub-Source registriert, dort gibt es keinen lokalen Pfad, der sterben könnte — ein Verschieben oder Umbenennen des Repo-Ordners löst diesen Fall also nicht aus. Prüfe `known_marketplaces.json`, bevor du hier remove/add ansetzt: gegen ein Problem, das eine andere Ursache hat, ist das der destruktivste verfügbare Schritt.

**Bei totem Marketplace-Pfad hilft `marketplace update` nicht** — es liest den Pfad aus `known_marketplaces.json` und scheitert mit `ENOENT`. Auch ein korrigierter `extraKnownMarketplaces`-Pfad in `~/.claude/settings.json` allein reicht nicht: er wird nicht in `known_marketplaces.json` nachgezogen. Dann neu registrieren — `marketplace remove` leert dabei `enabledPlugins`, deshalb ist `install` danach zwingend:

```
claude plugin marketplace remove marco-markl
claude plugin marketplace add /absoluter/pfad/zum/repo --scope user
claude plugin install cmd@marco-markl        # stellt enabledPlugins wieder her
```

## Befehlsübersicht

```
claude plugin marketplace add /absoluter/pfad/zum/repo   # nur für source: directory. Absoluter Pfad; ein relativer bindet an das Arbeitsverzeichnis; optional --scope user|project|local
claude plugin marketplace add marcomarkl/plugin-cmd-skills   # GitHub-Source, so ist marco-markl aktuell registriert
claude plugin install   cmd@marco-markl
claude plugin marketplace update marco-markl   # Marketplace holen, neue Version in den Cache — hebt die installierte Version NICHT an
claude plugin update    cmd@marco-markl     # hebt die installierte Version an; danach Neustart bzw. /reload-plugins
claude plugin disable   cmd@marco-markl     # aus-/einschalten ohne Deinstall
claude plugin enable    cmd@marco-markl
claude plugin uninstall cmd@marco-markl     # Alias: remove / rm
claude plugin marketplace remove marco-markl
claude plugin list                          # Ist-Zustand, bevor du einen Fehlschlag wiederholst
```
