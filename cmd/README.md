# cmd — Planungs-Toolkit für Claude Code

Sechs Skills rund um Klären, Planen, Reviewen, Umsetzen, Lernen und Übergeben. Der Plugin-Name `cmd` (aus `.claude-plugin/plugin.json`) bildet den Namespace, deshalb beginnt jeder Aufruf mit `/cmd:`.

Installation und Überblick stehen im [Root-README](../README.md); die Entwurfsnotizen (Stellschrauben, verworfene Ansätze) in [`DESIGN.md`](../DESIGN.md).

> Die Skills sind **deutschsprachige Prompts** — sie steuern Claude auf Deutsch.

## Die Skills — und wann du welchen nimmst

| Skill | Was er tut | Wann |
|---|---|---|
| `/cmd:plan-grill` | Interviewt dich zu einem Vorhaben, löst die Entscheidungen einzeln in Abhängigkeits- und Tragweitenreihenfolge auf und protokolliert sie revidierbar. | **Vor** `/plan`, wenn das Vorhaben noch unscharf ist. |
| `/cmd:plan-review` | Reviewt den zuletzt erstellten Plan in rotierenden Blickwinkeln und arbeitet die belastbaren Befunde direkt ein. | **Nach** `/plan`, bevor du freigibst. |
| `/cmd:plan-execute` | Setzt den freigegebenen Plan vollständig um und verifiziert jeden Schritt gegen ein beobachtbares Kriterium; hält bei einem Fund außerhalb des Plans oder einer Klassifikator-Blockade an und fragt nach. | **Nach** dem Verlassen des Plan-Modus. |
| `/cmd:project-rules` | Härtet eine bestehende `CLAUDE.md`/`AGENTS.md` mit fünf Disziplin-Katalogen und verdichtet sie token-effizient. | Eigenständig, wenn die Projektregeln Pflege brauchen. |
| `/cmd:session-learn` | Reflektiert die laufende Session, leitet dauerhafte Learnings ab und übergibt sie als Plan an `plan-review`/`plan-execute`. | Am **Ende** einer Session. |
| `/cmd:session-handoff` | Verdichtet den laufenden Arbeitsstand in eine kurze `HANDOFF.md`, damit ein frisches Fenster ohne den bisherigen Verlauf weiterarbeiten kann. | Wenn das **Kontextfenster knapp** wird. |

Alle sechs sind `disable-model-invocation: true` — sie laden **nur auf deinen Aufruf hin**, nie automatisch. Das ist Absicht: es sind timing-kontrollierte Workflows.

**grill und review gehen unterschiedlich mit ihrem Ergebnis um**, und zwar nach einer Frage: *existiert schon ein Plan zum Ändern?* grill läuft davor — es gibt noch keinen Plan, also übergibt es die Entscheidungen als selbsttragenden Block, statt zu schreiben. review läuft danach — der Plan existiert, also arbeitet es die Befunde direkt in ihn ein. Beide machen ihr Ergebnis über **stabile Kennungen** zurücknehmbar (grill „nimm Entscheidung 3 zurück", review „nimm Änderung 2.3 zurück").

## Pipeline

Die drei plan-Skills bilden eine Kette um den Plan-Modus, jede Naht mit einem klaren Vertrag:

```
plan-grill  →  /plan  →  plan-review  →  ExitPlanMode  →  plan-execute
 (klärt)      (baut)     (härtet)                         (setzt um)
```

- **grill → /plan:** grill schreibt nichts, sondern gibt einen selbsttragenden, `/plan`-tauglichen Übergabeblock aus (Ziel, feststehende Vorgaben, offene Punkte). `/plan` übernimmt ihn verlustarm als Eingabe.
- **/plan → review:** review arbeitet auf dem existierenden Plan und härtet ihn in Runden; das Ergebnis ersetzt den Plan.
- **review → execute:** execute setzt den **freigegebenen** Plan um. **Vertrag:** execute erwartet, dass der Plan **pro Schritt ein beobachtbares Verifikationskriterium** trägt. Fehlt eins, leitet execute das schwächste hinreichende selbst ab.

Jeder Skill ist einzeln nutzbar; die Kette ist die Kür, nicht die Pflicht.

`session-learn` steht **quer** zu dieser Kette: es reflektiert eine ganze Session und erzeugt selbst einen Plan — aber über die *Arbeitsweise* (Learnings für künftige Sessions), nicht über eine Aufgabe. Es betritt die Pipeline wieder bei `/plan`.

`session-handoff` steht **quer zur Zeitachse**: Es unterbricht die Kette an beliebiger Stelle — typischerweise mitten in `plan-execute`, dem einzigen langlaufenden Skill — und reicht den Stand an ein frisches Fenster weiter, wo die Kette dort fortgesetzt wird, wo sie abbrach.

**Die beiden `session-*`-Skills teilen sich die Session nach Haltbarkeit**, und danach wählst du: `session-learn` nimmt das **Dauerhafte** (Learnings, die künftige Sessions besser machen) und legt es projektlokal ab; `session-handoff` nimmt das **Flüchtige** (wo die Arbeit gerade steht) und gibt es ans nächste Fenster. Am Sessionende sinnvoll beides, in dieser Reihenfolge — `session-learn` belegt die Plandatei, auf die `session-handoff` danach nur noch verweisen muss.

Die Präfixe ordnen die Skills: `plan-*` wirken am Plan-Lebenszyklus, `project-*` an Projekt-Artefakten (die `CLAUDE.md`), `session-*` an der Arbeitssession selbst.

## Voraussetzungen für `plan-execute`

Zielmodus für die Umsetzung ist **Auto mode**. Der Skill kann den Modus **nicht selbst setzen** — er muss vorher aktiv sein. Ohne Auto mode läuft er ebenfalls, dann mit Permission-Prompts statt automatischer Freigabe.

Auto mode aktivieren (einmaliges Opt-in):

1. Verfügbarkeit prüfen über den Shift+Tab-Zyklus oder `/status`. Erscheint Auto mode nicht, ist eine Voraussetzung nicht erfüllt (Version, Modell oder Owner-Freigabe bei Team/Enterprise).
2. `claude --enable-auto-mode`, dann per Shift+Tab auf Auto mode wechseln.
3. Dauerhaft: `permissions.defaultMode: "auto"` **nur** in `~/.claude/settings.json` (projektbezogene Settings werden für diesen Wert ignoriert).

> **Auto mode ist ein Research Preview ohne Sicherheitsgarantie** — nur in isolierter Umgebung nutzen.

## Gut zu wissen

- **`plan-grill` und `session-learn` schreiben nichts.** Sie klären bzw. reflektieren und übergeben ihr Ergebnis; angewendet wird es erst über den Plan.
- **`session-learn` belegt die Plandatei** und ersetzt damit den aktuellen Plan-Kontext — schließe laufende Aufgaben erst ab, bevor du es startest.
- **`session-learn` schreibt ausschließlich projektlokal** (Projekt-`CLAUDE.md`, `references/`, Repo) — nie in user-globale Ablagen.
- **`session-handoff` schreibt die Datei ungefragt** — der Aufruf ist die Freigabe. Anders als sonst in dieser Suite holt er keine Bestätigung ein: Eine Rückfrage kostet genau den Zug, für den der Kontext nicht mehr reicht. Er nennt dafür den Rückweg, wenn er die Datei neu angelegt oder überschrieben hat, und sichert eine untrackte Datei vorher als `.bak`.
- **`session-handoff` schreibt genau eine Datei** und hört dort auf — er setzt die Arbeit nicht fort, auch nicht auf Bitte. Die Datei ist die Übergabe; im neuen Fenster genügt „lies `<pfad>` und arbeite dort weiter". Das Fenster öffnest du selbst: Der Skill tut nach der Datei nichts mehr.
- **`session-handoff` braucht eine Session mit Inhalt.** Ohne Gesprächsverlauf schreibt er keine Datei, sondern sagt das: Ziel und offene Punkte ließen sich nur aus dem Dateistand zurückraten, und eine Übergabe, die vollständig aussieht und es nicht ist, ist schlechter als keine.
- **Der Abschnitt „Unsicher" ist der Punkt des Skills**, nicht Beiwerk. Der Skill läuft genau dann, wenn sein eigener Verlauf schon gekürzt ist — er verdichtet also ein Bild, das er nur teilweise sieht. Was er nicht belegen kann, landet dort samt Quelle und Prüfweg, statt weggelassen oder glattgeschrieben zu werden. Ein fehlender Abschnitt behauptet, es sei nichts unsicher gewesen.

## Struktur

```
cmd/
├── .claude-plugin/plugin.json              # Manifest; name "cmd" setzt den Namespace
├── README.md                               # diese Datei
└── skills/
    ├── plan-execute/
    │   ├── SKILL.md
    │   └── references/auto-mode.md         # bedarfsgeladen bei Klassifikator-Blockade
    ├── plan-grill/SKILL.md
    ├── plan-review/SKILL.md
    ├── project-rules/
    │   ├── SKILL.md
    │   └── references/                     # sechs Disziplin-Kataloge
    ├── session-handoff/SKILL.md
    └── session-learn/SKILL.md
```

Skills werden automatisch aus `skills/` entdeckt; der **Aufrufname folgt dem Ordnernamen** (`plan-execute` → `/cmd:plan-execute`). Details zu Namespace, Umbenennen und Entwicklungs-Loop stehen in [`DESIGN.md`](../DESIGN.md).
