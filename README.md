# plugin-cmd-skills

Ein Claude-Code-Plugin mit zehn Skills rund um **Klären, Planen, Reviewen, Umsetzen, Lotsen, Einrichten, Strukturieren, Lernen, Übergeben und Wiederaufnehmen** — plus dem Marketplace, über den es sich installieren lässt.

Das ist ein **persönliches Toolkit, öffentlich geteilt**: gebaut für meine eigene Arbeitsweise, aber ohne projektspezifische Annahmen — wer ähnlich arbeitet, kann es direkt nutzen oder als Vorlage nehmen.

> **Sprache:** Die Skills sind **deutschsprachige Prompts**. Sie steuern Claude auf Deutsch und erwarten deutsche Antworten. Wer eine englische Fassung braucht, muss die `SKILL.md`-Dateien übersetzen.

## Installation

```bash
claude plugin marketplace add marcomarkl/plugin-cmd-skills
claude plugin install cmd@marco-markl
```

Oder in einer laufenden Session:

```
/plugin marketplace add marcomarkl/plugin-cmd-skills
/plugin install cmd@marco-markl
```

Aktualisieren braucht **zwei** Befehle — `marketplace update` allein legt die neue Version nur in den Cache und hebt die installierte Version nicht an:

```bash
claude plugin marketplace update marco-markl   # neue Version holen
claude plugin update cmd@marco-markl           # installierte Version anheben
```

Danach `/reload-plugins` oder eine neue Session starten. Entfernen:

```bash
claude plugin uninstall cmd@marco-markl        # Plugin entfernen
claude plugin marketplace remove marco-markl   # Marketplace abmelden
```

## Die Skills

Alle werden mit dem Namespace-Präfix aufgerufen und laden **nur auf deinen Aufruf hin**, nie automatisch.

| Skill | Kurz | Wann |
|---|---|---|
| `/cmd:plan-grill` | Interviewt dich zum Vorhaben, löst die Entscheidungen einzeln auf und legt sie als Plan an | am Anfang, wenn das Vorhaben unscharf ist |
| `/cmd:plan-review` | Reviewt den Plan in rotierenden Blickwinkeln und arbeitet Befunde ein | sobald ein Plan steht |
| `/cmd:plan-execute` | Setzt den freigegebenen Plan um, jeden Schritt gegen ein beobachtbares Kriterium verifiziert | nach dem Plan-Modus |
| `/cmd:project-setup` | Gibt die geordnete Aufrufliste der drei Einrichtungs-Skills aus, je Schritt mit Argument, Vorbedingung und Abnahmekriterium; richtet selbst nichts ein | vor der Einrichtung eines Projekts |
| `/cmd:project-rules` | Härtet eine `CLAUDE.md`/`AGENTS.md` mit zehn Disziplin-Katalogen | eigenständig |
| `/cmd:project-settings` | Setzt die `.claude/settings.json` auf einen festen Kanon, samt Zeitanker-Hook | beim Einrichten eines Projekts |
| `/cmd:project-structure` | Bringt die Ablage auf einen belegten Kanon und schlägt projekteigene Skills, Subagents und Regeln vor | wenn die `CLAUDE.md` zuwächst |
| `/cmd:session-learn` | Reflektiert die Session und macht Learnings zu einem Plan | am Sessionende |
| `/cmd:session-handoff` | Verdichtet den Arbeitsstand in eine kurze `HANDOFF.md` fürs nächste Fenster | wenn der Kontext knapp wird |
| `/cmd:session-resume` | Nimmt die Übergabedatei auf, prüft sie gegen den Projektstand und räumt sie nach Bestätigung weg | im neuen Fenster danach |

Details, Pipeline und Voraussetzungen: **[`cmd/README.md`](cmd/README.md)**.

## Sicherheitshinweis

`plan-execute` zielt auf Claude Codes **Auto mode**. Auto mode ist ein **Research Preview ohne Sicherheitsgarantie** — nutze ihn nur in einer isolierten Umgebung. Ohne Auto mode läuft der Skill ebenfalls, dann mit normalen Permission-Prompts.

`project-settings` schreibt **Permission-Regeln**, darunter ein weit gefasstes `Read(//**)` mit einer deny-Liste für Schlüssel und Credentials. Dieser Kanon ist eine Entscheidung für meine Maschine und mein Arbeitsprofil, **keine allgemeine Empfehlung**. Lies `cmd/skills/project-settings/references/permission-kanon.md`, bevor du ihn übernimmst — dort steht zu jeder Regel, was sie leistet und was sie ausdrücklich nicht leistet.

Seit 0.21.0 setzt derselbe Skill zusätzlich einen **Hook**, und das ist eine andere Klasse als eine Permission-Regel: Eine Regel erlaubt etwas, ein Hook führt etwas aus, hier `date` bei **jeder** Nachricht in diesem Projekt. Er gibt dem Modell die Systemzeit, weil Claude Code von sich aus nur das Datum liefert und es beim Sessionstart festschreibt. Er liest nichts, schreibt nichts und geht nicht ins Netz; wer ihn dennoch nicht will, nimmt ihn aus dem Kanon, bevor er den Skill laufen lässt, denn aus der Datei entfernt holt ihn der nächste Lauf zurück.

`project-settings` **entfernt Altlasten früherer Läufe**: den `SessionStart`-Hook und `.claude/skills/session-protocol/SKILL.md` des inzwischen gestrichenen Kommunikationsprotokolls (in Projekten, die vor Version 0.10.0 eingerichtet wurden), das dort sonst bei jedem Sessionstart weiterlädt — und seit 0.18.0 den Key `plansDirectory`, sofern er exakt auf `"./plans"` steht, wie ihn ein Lauf bis 0.17.0 gesetzt hat. Die `.gitignore`-Zeile geht nur zusammen mit diesem Key und nur, wenn `plans/` leer ist; den Ordner selbst fasst der Skill nie an, vorhandene Pläne bleiben liegen. Erkannt wird alles an einer festen Marke oder am exakten Wert, fremde `SessionStart`-Hooks und abweichende Werte bleiben stehen, und die Entfernung steht in derselben Vorschau wie alles andere. In einem Projekt ohne diese Spuren passiert nichts.

`project-structure` **verschiebt und benennt Dateien um** — er bewegt Bestand in großem Umfang, wo die übrigen Skills schreiben. Er tut das erst nach einer gesammelten Freigabe, per `git mv` (die Historie bleibt erhalten), mit einem Verlagerungs-Register und einer Zeilenbilanz als Verlustnachweis, und er nennt den Rückweg je Datei. Ohne git-Repo ist der Umzug schlechter reversibel; der Skill sagt das und sichert dann jede Quelle vorher als `.bak`. Sieh dir die Vorschau an, bevor du freigibst.

`session-resume` **löscht die Übergabedatei**, und war sie untrackt, bekommst du sie nicht ersetzt. Auch `project-settings` entfernt Dateien (siehe oben), dort aber eine an fester Marke erkannte Altlast innerhalb der Gesamtvorschau; hier hängt die Löschung an einer einzelnen Ja-Nein-Frage zu einer Datei, die der Skill selbst als Übergabe eingestuft hat. Er tut es nur nach ausdrücklicher Bestätigung, nur für die eine Datei, die er vorher benannt hat, und er nennt den Rückweg je nach git-Lage. Lehnst du ab, bleibt sie liegen.

## Hinweise zum Repo

- Das Repo enthält ein committetes **`.claude/settings.json`** mit einem harmlosen Entwickler-Hook: Er erinnert nach Änderungen an ausgeliefertem Plugin-Inhalt unter `cmd/skills/` daran, die Version zu prüfen. Wer das Repo in Claude Code öffnet, bekommt diesen Hook mit. Er führt keine Änderungen aus, sondern gibt nur einen Hinweis aus.
- `scripts/smoke.sh` startet **echte Modell-Läufe** und kostet entsprechend Tokens.

## Weiterlesen

| Datei | Inhalt |
|---|---|
| [`cmd/README.md`](cmd/README.md) | Nutzung der Skills, Pipeline, Voraussetzungen |
| [`DESIGN.md`](DESIGN.md) | Entwurfsnotizen: Stellschrauben, geprüfte und verworfene Ansätze |
| [`CLAUDE.md`](CLAUDE.md) | Arbeitsregeln für die Weiterentwicklung in diesem Repo |
| [`CHANGELOG.md`](CHANGELOG.md) | Versionshistorie |
| [`examples/transcripts.md`](examples/transcripts.md) | Erwartete Ausgabeform der Skills |

## Lizenz

[MIT](LICENSE) — © 2026 Marco Markl
