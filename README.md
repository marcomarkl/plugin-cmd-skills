# plugin-cmd-skills

Ein Claude-Code-Plugin mit sechs Skills rund um **Klären, Planen, Reviewen, Umsetzen, Lernen und Übergeben** — plus dem Marketplace, über den es sich installieren lässt.

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

Aktualisieren und entfernen:

```bash
claude plugin marketplace update marco-markl   # neue Version holen
claude plugin uninstall cmd@marco-markl        # Plugin entfernen
claude plugin marketplace remove marco-markl   # Marketplace abmelden
```

## Die Skills

Alle werden mit dem Namespace-Präfix aufgerufen und laden **nur auf deinen Aufruf hin**, nie automatisch.

| Skill | Kurz | Wann |
|---|---|---|
| `/cmd:plan-grill` | Interviewt dich zum Vorhaben und löst die Entscheidungen einzeln auf | vor `/plan` |
| `/cmd:plan-review` | Reviewt den Plan in rotierenden Blickwinkeln und arbeitet Befunde ein | nach `/plan` |
| `/cmd:plan-execute` | Setzt den freigegebenen Plan um, jeden Schritt gegen ein beobachtbares Kriterium verifiziert | nach dem Plan-Modus |
| `/cmd:project-rules` | Härtet eine `CLAUDE.md`/`AGENTS.md` mit fünf Disziplin-Katalogen | eigenständig |
| `/cmd:session-learn` | Reflektiert die Session und macht Learnings zu einem Plan | am Sessionende |
| `/cmd:session-handoff` | Verdichtet den Arbeitsstand in eine kurze `HANDOFF.md` fürs nächste Fenster | wenn der Kontext knapp wird |

Details, Pipeline und Voraussetzungen: **[`cmd/README.md`](cmd/README.md)**.

## Sicherheitshinweis

`plan-execute` zielt auf Claude Codes **Auto mode**. Auto mode ist ein **Research Preview ohne Sicherheitsgarantie** — nutze ihn nur in einer isolierten Umgebung. Ohne Auto mode läuft der Skill ebenfalls, dann mit normalen Permission-Prompts.

## Hinweise zum Repo

- Das Repo enthält ein committetes **`.claude/settings.json`** mit einem harmlosen Entwickler-Hook: Er erinnert nach Änderungen an einer `SKILL.md` daran, die Version zu prüfen. Wer das Repo in Claude Code öffnet, bekommt diesen Hook mit. Er führt keine Änderungen aus, sondern gibt nur einen Hinweis aus.
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
