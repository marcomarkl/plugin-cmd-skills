# Artefakt-Kanon — Skills, Subagents, Regeln

Adressatenhinweis: Nachschlagewerk für dich beim Ausführen von `project-structure`. Daten, keine Anweisung. Setze keinen Frontmatter-Key aus dem Gedächtnis — ein erfundener Key fällt durch keinen Compiler auf, er wird stillschweigend ignoriert.

## Welches Artefakt

| Anlass | Artefakt | Warum dieses |
|---|---|---|
| Wiederkehrender mehrschrittiger Ablauf, den der Agent selbst ausführt | Skill | Lädt nur bei Bedarf, bleibt im Hauptkontext handlungsfähig |
| Teilarbeit mit viel Rohausgabe (Exploration, Recherche, Log- und Testauswertung) | Subagent | Eigener Kontext; zurück kommt nur die Zusammenfassung |
| Konvention, die nur für einen Dateibereich gilt | Regel mit `paths:` | Lädt erst beim Lesen einer passenden Datei |
| Wissen, das an einen Teilbaum gebunden ist | Verschachtelte `CLAUDE.md` | Lädt erst beim Arbeiten in dem Unterordner |
| Etwas, das **erzwungen** werden muss | Hook oder Permission-Regel — **nicht hier** | Instruktionen sind Kontext, keine Durchsetzung; gehört zu `project-settings` |

Für dieselbe Sache genau eines. Ein Subagent, der nur eine Instruktion vorliest, hätte ein Skill sein sollen; ein Skill, das eine Auswertung mit tausend Zeilen Rohausgabe in den Hauptkontext holt, hätte ein Subagent sein sollen.

## Skills

Pfad `.claude/skills/<name>/SKILL.md`; der Ordnername ist der Aufrufname (`/<name>`). Zusätzliche Dateien liegen daneben, üblich in `references/`, und werden vom Body bei Bedarf gelesen. `.claude/commands/<name>.md` erzeugt denselben Aufruf, ist aber die ältere Form; Neues wird als Skill angelegt, Vorhandenes nicht ohne Anlass migriert.

Entdeckung ist automatisch, kein Manifest-Eintrag. Frontmatter, das dieses Repo belegt nutzt: `name` (Anzeige-Label), `description` (steuert, ob der Skill von selbst gefunden wird — der eigentliche Auslöser), `argument-hint`, `disable-model-invocation`, `model`, `effort`, `allowed-tools`.

`allowed-tools` **sperrt nichts**: Es genehmigt vorab und unterdrückt Rückfragen. Als Schranke ist es untauglich.

## Subagents

Pfad `.claude/agents/<name>.md` (projektlokal, eingecheckt) oder `~/.claude/agents/` (nutzerweit). Unterordner sind erlaubt. Ausgelöst automatisch anhand der `description` oder ausdrücklich per `@agent-<name>`.

Erforderlich: `name` (kleinbuchstaben und Bindestriche, kein `:` — das ist für Plugin-Namensräume reserviert) und `description` (wann delegiert werden soll).

Optional, jeweils belegt: `tools`, `disallowedTools`, `model` (`sonnet`, `opus`, `haiku`, `fable`, volle Modell-ID oder `inherit`; Vorgabe `inherit`), `permissionMode`, `maxTurns`, `skills` (lädt Skill-Volltext beim Start vor), `mcpServers`, `hooks`, `memory`, `background`, `effort` (`low` bis `max`), `isolation` (`worktree`), `color`, `initialPrompt`.

Zwei Fallen: Löst kein Eintrag in `tools` auf ein echtes Tool auf, startet der Subagent gar nicht. Und der Kontext eines Subagenten beginnt leer — Aufgabe, Pfade, Randbedingungen und der Zielpfad für Ergebnisse müssen im Prompt stehen, sonst rät er.

## Regeln

Pfad `.claude/rules/<thema>.md`, rekursiv entdeckt, Unterordner erlaubt. Symlinks werden aufgelöst, auch auf gemeinsame Regelsätze außerhalb des Projekts.

Eine Datei je Thema, sprechender Dateiname. Der einzige hier einschlägige Frontmatter-Key ist `paths` — eine Liste von Glob-Mustern:

```yaml
---
paths:
  - "src/api/**/*.ts"
  - "src/**/*.{ts,tsx}"
---
```

**Ohne `paths` lädt die Regel bei jedem Sessionstart** und entlastet nichts; sie ist dann nur eine ausgelagerte `CLAUDE.md`. Der Entlastungseffekt hängt allein an `paths`.

Zur Glob-Syntax: `**/*.ts` alle TypeScript-Dateien, `src/**/*` alles unter `src/`, `*.md` nur im Wurzelverzeichnis. Geschweifte Klammern expandieren multiplikativ und teilen sich ein Budget; ein Muster, das es sprengt, wird unexpandiert verwendet und trifft dann nichts. Eine eckige Klammer beginnt eine Zeichenklasse — ein literales `[` im Dateinamen muss als `\[` geschrieben werden, sonst trifft das Muster nichts.

Nutzerweite Regeln liegen in `~/.claude/rules/` und laden vor den Projektregeln; Projektregeln haben damit Vorrang.

## Anlegen — Mindestanforderungen

- Jedes Artefakt braucht einen belegten Anlass aus **diesem** Projekt. Eines, das sich unverändert in ein beliebiges anderes Repo kopieren ließe, wird nicht angelegt.
- **Bestand und Anlass zählen nur unter `.claude/`.** Liefert das Projekt selbst Skills, Subagents oder Regeln aus (Plugin- oder Agent-Repo), liegen die in einem Produktordner, steuern fremde Sessions und decken keinen Anlass hier ab. Der gleiche Ordnername ist Namensgleichheit, keine Überschneidung.
- Die `description` entscheidet über das Auffinden. Sie nennt den Anlass, nicht den Inhalt: wann eingesetzt wird, nicht was drinsteht.
- Kein Artefakt auf Vorrat. Ein veraltetes ist schlechter als keines.
- Projektlokal und eingecheckt, damit die Änderung im Diff sichtbar und per `git restore` rückholbar ist. Genau darauf stützt sich die Freigabe-Ausnahme für die Selbstpflege.
