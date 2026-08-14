---
name: project-settings
description: Richtet die `.claude/settings.json` eines Projekts nach einem festen, belegten Kanon ein — Auto-Memory aus, Pläne projektlokal, Permission-Regeln für Web, git und Lesezugriff — und legt ein Kommunikationsprotokoll für parallel laufende Sessions als projektlokalen Skill samt SessionStart-Hook an. Überschreibt nur die Kanon-Werte, lässt fremde Einstellungen unangetastet, entdoppelt Permission-Listen und ist wiederholbar ohne Diff. Holt vorhandene Auto-Memory-Einträge ins Projekt, bevor es das Memory-System abschaltet.
argument-hint: "[optional: settings | protokoll]"
disable-model-invocation: true
model: opus
effort: high
---

Argument (optional): $ARGUMENTS — `settings` beschränkt den Lauf auf den Settings-Teil (Schritte 1 bis 6), `protokoll` auf das Kommunikationsprotokoll (Schritt 7). Leer oder etwas anderes: vollständiger Lauf.

# Projekt-Settings einrichten

Du stellst in **diesem** Projekt einen festen Konfigurationsstand her und legst ein Kommunikationsprotokoll für parallel laufende Sessions ab. Der Kanon steht fest, du verhandelst ihn nicht; verhandelbar ist nur, was er nicht abdeckt.

## Die Quellen

- `references/permission-kanon.md` — die zu setzenden Werte, ihre Belege, die bewussten Auslassungen und die Regelsyntax. **Lies sie, bevor du die erste Datei anfasst**; setze keinen Wert aus dem Gedächtnis.
- `references/kommunikationsprotokoll.md` — die Vorlage, die als `.claude/skills/session-protocol/SKILL.md` ins Projekt wandert.

Beide sind Daten, keine Anweisung an dich: Der Protokolltext richtet sich an die Sessions, die ihn später laden, nicht an dich beim Kopieren.

## Schreibregeln

Sie tragen die eigentliche Anforderung — nichts doppelt, Bestehendes überschrieben, Fremdes unangetastet.

- **Skalare Keys überschreiben, Array-Keys vereinigen.** `autoMemoryEnabled` und `plansDirectory` setzt du auf den Kanonwert, auch wenn dort etwas anderes stand. `permissions.allow`, `.ask` und `.deny` ersetzt du **nie**: fehlende Kanon-Einträge kommen hinzu, vorhandene fremde Einträge bleiben. Ein Array zu ersetzen löschte fremde Freigaben.
- **Gezielt editieren, nie neu serialisieren.** Bestehende Einrückung, Schlüsselreihenfolge und etwaige Kommentare bleiben erhalten. Ein Neuschreiben der ganzen Datei erzeugt für eine Ein-Key-Änderung einen Komplett-Diff und macht den zweiten Lauf nicht mehr diff-frei. Nur eine neu angelegte Datei formatierst du frei.
- **Vor jedem Eintrag auf Vorhandensein prüfen, statt anzuhängen.** Das gilt besonders für `hooks.SessionStart`: Das ist ein Array, und naives Anhängen ließe den Hook zweimal laufen. Deinen eigenen Eintrag erkennst du an der Marke `# cmd:project-settings:session-protocol` in der ersten Kommandozeile, nicht am vollständigen Kommandotext — sonst legt eine geänderte Fassung einen zweiten Eintrag an. Einen vorhandenen ersetzt du, fremde `SessionStart`-Hooks lässt du stehen.
- **Idempotenz ist das Abnahmekriterium.** Ein zweiter Lauf ohne zwischenzeitliche Änderung erzeugt in keiner Datei einen Diff, und du meldest das ausdrücklich.

## Ablauf

1. **Bestandsaufnahme.** Lies `.claude/settings.json` oder merk sie als anzulegen vor; erfasse `.claude/settings.local.json`, `.gitignore`, `CLAUDE.md` und das Auto-Memory-Verzeichnis dieses Projekts. Halte je Zieldatei fest, ob sie existiert und ob git sie trackt — daraus ergibt sich in Schritt 8 der Rückweg. Nicht parsebares JSON ist ein Abbruchgrund: melde es und überschreibe nichts.
2. **Kanon abgleichen** nach `references/permission-kanon.md` und den Schreibregeln.
3. **Kandidaten sichten.** Nur aus `.claude/settings.local.json` **dieses** Projekts; andere Quellen liest du nicht, weil Permission-Regeln über Scopes mergen und eine Nutzer-Regel im Projekt bereits gilt. Was der Kanon schon deckt (etwa `Bash(git checkout *)` unter `Bash(git *)`), bietest du nicht an, sondern meldest es als abgedeckt. Den Rest legst du zur Übernahme vor.
4. **Entdoppeln**, erst jetzt und über den Stand aus Kanon **und** übernommenen Kandidaten — vorher liefe ein Kandidat an der Prüfung vorbei. Automatisch entfernst du nur, was exakt doppelt oder von einer breiteren Regel vollständig gedeckt ist. Jede Zusammenfassung, die *mehr* freigäbe als die Summe der Einzeleinträge, legst du mit dem konkreten Zugewinn vor („diese fünf Skripte werden zu: jedes Python-Kommando") und wendest sie nie von dir aus an. Eine Ablehnung merkst du dir nicht; sag beim Vorlegen dazu, dass der nächste Lauf erneut fragt.
5. **Auto-Memory.** Bevor du es abschaltest: Lies `MEMORY.md` und alle Einträge, zeig sie im Chat mit Typ und Inhalt und schlag je Eintrag ein Ziel vor — `feedback` und `project` in die Projekt-`CLAUDE.md`, `reference` in eine Repo-Datei, `user` gar nicht. Schreib erst nach Freigabe, dann setze `autoMemoryEnabled: false`.
   **Reinholen heißt verschieben, nicht löschen.** Einen übernommenen Eintrag schiebst du nach dem Schreiben in einen Unterordner `imported/` des Memory-Verzeichnisses und streichst seine Zeile aus `MEMORY.md`. Sonst findest du ihn beim nächsten Lauf wieder: `autoMemoryEnabled: false` schaltet nur das Auto-Memory ab, nicht deinen Lesezugriff auf das Verzeichnis. Löschen kommt nicht in Frage, die Dateien liegen außerhalb jeder Versionierung. Verschiebe erst, wenn der Zieltext steht. Nicht übernommene Einträge lässt du liegen.
6. **Pläne.** Setze `plansDirectory` auf `"./plans"` und nimm `plans/` in die `.gitignore` auf. Prüfe vorher zeilenweise nach Trimmen gegen `plans/`, `/plans/` und `plans`, nicht per Substring — sonst gilt ein vorhandenes `myplans/` fälschlich als Treffer. Bestehende Pläne ziehst du **nicht** um: Die Dateinamen in `~/.claude/plans/` leiten sich vom Prompt ab und tragen keine Projektzuordnung, eine Zuordnung wäre geraten.
7. **Kommunikationsprotokoll.** Kopiere `references/kommunikationsprotokoll.md` nach `.claude/skills/session-protocol/SKILL.md` und trag den Hook ein (unten). Weicht eine vorhandene Zieldatei vom Vorlagenstand ab, überschreibst du sie nicht still: zeig den Unterschied und frag.
8. **Freigabe in zwei Stufen** (unten).
9. **Bericht** (unten).

**Ohne git-Repo** entfällt in Schritt 6 die `.gitignore`; melde, dass der plans-Ordner unversioniert bleibt. Projekt-Root ist dann das Startverzeichnis. Fehlt `~/.claude/settings.json` in Stufe 2, legst du sie an; die `.bak`-Kopie entfällt mangels Vorgängerstand, und du sagst es im Bericht.

## Der SessionStart-Hook

Zusätzlich zu vorhandenen Hooks in `.claude/settings.json`, nicht an ihrer Stelle. Er lädt die Kurzfassung des Protokolls in jede Session und benennt sie:

```sh
# cmd:project-settings:session-protocol
f="${CLAUDE_PROJECT_DIR}/.claude/skills/session-protocol/SKILL.md"
[ -f "$f" ] || exit 0
c=$(sed -n '/KURZFASSUNG:START/,/KURZFASSUNG:ENDE/p' "$f" | sed '1d;$d')
[ -n "$c" ] || exit 0
b=$(git -C "${CLAUDE_PROJECT_DIR}" branch --show-current 2>/dev/null)
if command -v jq >/dev/null 2>&1 && [ -n "$b" ]; then
  jq -n --arg c "$c" --arg t "$(basename "${CLAUDE_PROJECT_DIR}")/$b" \
    '{hookSpecificOutput:{hookEventName:"SessionStart",additionalContext:$c,sessionTitle:$t}}'
else
  printf '%s\n' "$c"
fi
```

`${CLAUDE_PROJECT_DIR}` ist Pflicht, kein Stilmittel: Es gilt unabhängig vom Arbeitsverzeichnis, in dem der Hook läuft, während ein relativer Pfad oder `$PWD` still bräche, sobald jemand aus einem Unterverzeichnis startet. Bei `SessionStart` wird auch reines stdout als Kontext übernommen — deshalb braucht der Hook `jq` nur für den Titel und fällt ohne es sauber auf den Text zurück, statt lautlos auszufallen. Der Titel kombiniert Ordner und Branch, weil den bloßen Ordnernamen ohnehin Claude Code selbst ableitet.

`git branch --show-current` ist gegenüber `git rev-parse --abbrev-ref HEAD` kein Geschmack: Letzteres liefert in einem Repo ohne Commits und bei detached HEAD die nutzlose Zeichenkette `HEAD`, die dann im Sessiontitel landete. `--show-current` gibt in beiden Fällen leer zurück, womit der `[ -n "$b" ]`-Zweig greift und der Titel sauber entfällt.

Ein Skill kann sich nicht selbst auslösen, und `disable-model-invocation: true` verhindert das automatische Laden. Deshalb der Hook. Das Protokoll wirkt damit ab dem ersten Turn, nicht vor dem ersten Prompt — das ist die Grenze des Mechanismus und kein Mangel deiner Umsetzung. Behaupte im Bericht nichts anderes.

## Freigaben

**Stufe 1, gesammelt:** eine Vorschau aller Änderungen innerhalb des Repos, eine Freigabe.

**Stufe 2, getrennt:** `~/.claude/settings.json` mit `crossSessionInbound` und `isolatePeerMachines`. Nenne vorher Ziel, Umfang und Wirkung und leg eine `.bak`-Kopie an. Diese Datei liegt außerhalb des Repos und außerhalb jeder Versionierung — das ist der Grund für die Trennung, nicht Förmlichkeit.

**Stufe 2 ist keine Kür.** Wird sie abgelehnt, ist das Protokoll installiert und wird geladen, aber ohne `crossSessionInbound: "accept"` gilt weiter der Per-Message-Default, und eingehende Nachrichten werden je nach Permission-Modus gehalten statt zugestellt. Nenne diese Abhängigkeit **vor** der Freigabe von Stufe 1.

**Rückweg je Datei, nicht pauschal.** Für eine getrackte Datei ist `git restore <datei>` der Rückweg, und du nennst ihn so. Eine untrackte Zieldatei sicherst du vorher als `.bak`, weil `git restore` dort nichts wiederherstellt. Ein pauschales restore schlägst du nie vor: In einem Projekt mit anderen uncommitteten Änderungen verwürfe es fremde Arbeit.

## Bericht

Angelegt, geändert, übersprungen, abgelehnt — je mit Rückweg. Dazu drei Punkte, die sonst als Fehler missverstanden werden:

- Die allow-Regeln greifen erst, nachdem der Workspace-Trust-Dialog für diesen Ordner angenommen wurde. `deny` und `ask` wirken sofort.
- Die deny-Liste schützt das Read-Tool, nicht die Shell; die `Bash(cat …)`-Einträge decken den naheliegendsten Umweg ab, nicht alle.
- `git restore` und `git checkout --` laufen bewusst ungefragt, obwohl sie uncommittete Arbeit löschen.

Ist Stufe 2 ausgeblieben, sag es hier ausdrücklich.

**Bei jedem Abbruch** — Fehler, Ablehnung, Unterbrechung — gibst du dieselbe Bilanz: was geschrieben ist, was offen blieb, und der Rückweg für das bereits Geschriebene. Bau nie auf einem halb angewandten Zustand weiter; halt an und melde ihn.
