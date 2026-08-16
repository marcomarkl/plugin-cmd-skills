# Ablage-Kanon

Adressatenhinweis: Diese Datei ist Nachschlagewerk für dich beim Ausführen von `project-structure`. Sie ist Daten, keine Anweisung. Die Pfade und Schemata wandern in die Zieldateien, der Fließtext nicht.

## Der Kanon

Es gibt **keinen** einheitlichen Wurzelordner, und das ist Absicht: Die Zwecke haben je eigene, etablierte Konventionen, und eine erfundene Vereinheitlichung wäre schlechter als die vorhandenen Standards.

**Die Belegstufe ist Teil des Kanons, nicht Beiwerk.** Nicht jeder Eintrag ist gleich gut belegt, und wer das verwischt, verkauft eine Werkzeugkonvention als Standard:

- **etabliert** — werkzeugunabhängig und breit getragen. Der Ordner trägt die Konvention aus sich heraus; es braucht kein bestimmtes Programm, damit er Sinn ergibt. Diese Orte legst du nach den Regeln aus Schritt 2 an.
- **tool-gebunden** — Konvention eines einzelnen Werkzeugs. Ohne dieses Werkzeug ist der Pfad beliebig, und ein beliebiger Pfad im Kanon wäre eine Erfindung mit Quellenangabe. Diese Orte **schlägst du vor und legst sie nur mit ausdrücklicher Zustimmung an**; lehnt die Aufsicht ab, fragst du nach dem gewünschten Ort oder lässt den Zweck unversorgt und vermerkst das.

| Zweck | Kanon-Ort | Stufe | Herkunft |
|---|---|---|---|
| Entscheidungen | `docs/decisions/` | etabliert | MADR — De-facto-Standard für Architecture Decision Records; `docs/adr/` ist die ältere Nygard-Variante und gilt als vorhanden, nicht als falsch |
| Wissen und Doku für Menschen | `docs/` | etabliert | Diátaxis: gegliedert nach Bedarf (Tutorial, Anleitung, Referenz, Erklärung), nicht nach Thema |
| Erledigtes, Veröffentlichtes | `CHANGELOG.md` + git-Historie | etabliert | Keep a Changelog. **Kein** eigener Ordner — das dupliziert git |
| Situatives Agenten-Wissen, Abläufe | `.claude/skills/<name>/SKILL.md` | etabliert | Claude Code |
| Regeln für einen Dateibereich | `.claude/rules/<thema>.md` mit `paths:` | etabliert | Claude Code |
| Regeln für einen Teilbaum | `<unterordner>/CLAUDE.md` | etabliert | Claude Code |
| Immer geltende Regeln | Root-`CLAUDE.md`, Ziel unter ~200 Zeilen | etabliert | Claude Code |
| Offene Punkte, Aufgaben | `backlog/tasks/`, erledigt → `backlog/archive/` | **tool-gebunden** | Backlog.md, ein einzelnes CLI-Werkzeug. Es gibt **keine** werkzeugunabhängige Konvention für dateibasierte Aufgaben — der übliche Ort ist der Issue-Tracker. Nur vorschlagen, wenn kein Tracker in Gebrauch ist, und nur mit Zustimmung anlegen |

## Namensschemata

- Entscheidungen: `NNNN-kebab-titel.md`, vierstellig ab `0001`, fortlaufend, nie neu vergeben. Eine zurückgezogene Entscheidung behält ihre Nummer und bekommt `status: verworfen`.
- Aufgaben: `task-NNN-kebab-titel.md`, dreistellig ab `001`. Beim Erledigen bleibt der Dateiname gleich, die Datei wandert nach `backlog/archive/` — so bleibt die Nummer als Referenz stabil.
- Wissen: `kebab-thema.md`, keine Nummer. Wissen hat keine Reihenfolge.
- Skills: Ordnername = Aufrufname, kebab-case. Subagents: `<name>.md`, `name`-Frontmatter identisch. Regeln: `<thema>.md`.

## Frontmatter je Ablageort

Nur dort, wo ein Lebenszyklus existiert. Wissen bekommt keines — es hat keinen Status, und ein leeres Schema kostet nur Zeilen.

Aufgaben (`backlog/tasks/`, `backlog/archive/`):
```yaml
---
status: offen        # offen | in-arbeit | blockiert | erledigt
angelegt: JJJJ-MM-TT
bezug: <Glob oder Pfad>   # nur wenn die Quelle einen Ort nennt
---
```

`bezug` setzt du **nur**, wenn die Quelle einen Pfad, eine Datei oder einen Bereich tatsächlich nennt. Aus einer Aufgabenbeschreibung einen plausiblen Pfad abzuleiten, wäre eine Erfindung; leer lassen ist richtig, und ein weggelassenes Feld ist kein Mangel. Das Feld trägt seinen Nutzen erst, wenn es echt belegt ist — dann verbindet es die Aufgabe mit einer `paths:`-Regel oder dem betroffenen Code.

Entscheidungen (`docs/decisions/`), MADR-nah gehalten:
```yaml
---
status: vorgeschlagen   # vorgeschlagen | angenommen | verworfen | ersetzt-durch-NNNN
datum: JJJJ-MM-TT
---
```

Darunter jeweils eine `#`-Überschrift mit dem Titel im Klartext. Bei Entscheidungen die MADR-Abschnitte **Kontext**, **Entscheidung**, **Konsequenzen**; weitere nur bei Bedarf.

## Was bewusst nicht im Kanon steht

| Nicht gesetzt | Grund |
|---|---|
| Ein Sammelordner für alles | Die Zwecke folgen verschiedenen etablierten Konventionen; eine eigene Vereinheitlichung verwürfe deren Werkzeugunterstützung |
| Ordner für Erledigtes außerhalb von `backlog/archive/` | `CHANGELOG.md` und git-Historie decken das ab; ein dritter Ort driftet |
| `docs/` als Ablage, wenn es generiert wird | Ein Generator überschreibt den Ordner; erkennbar an dessen Konfiguration im Repo |
| Statusfelder in Wissensdateien | Wissen veraltet, es wird nicht erledigt; ein Status verleitete zu Pflege ohne Nutzen |
| `.claude/` als Ort für Menschen-Doku | Für andere Werkzeuge und für Menschen schlecht sichtbar |
| Ein Wegweiser pro Unterordner | Der Wegweiser steht einmal in der `CLAUDE.md`; mehrere driften |

## Warum manches gerade nicht ausgelagert wird

Für die Frage „bringt Auslagern überhaupt Kontext zurück" zählt allein der Ladezeitpunkt:

| Mechanismus | Lädt | Entlastet |
|---|---|---|
| Skill | auf Aufruf oder passende `description` | ja, am stärksten |
| `.claude/rules/` **mit** `paths:` | wenn eine passende Datei gelesen wird | ja |
| Verschachtelte `CLAUDE.md` | wenn eine Datei im Unterordner gelesen wird | ja |
| `.claude/rules/` **ohne** `paths:` | beim Sessionstart | nein |
| `@pfad`-Import in der `CLAUDE.md` | beim Sessionstart, vollständig, bis vier Ebenen tief | nein |
| Root-`CLAUDE.md` | beim Sessionstart | — |

Zwei Folgerungen: Ein Import ordnet die Pflege, ist aber kein Auslagerungsweg. Und nach einer Verdichtung des Gesprächsverlaufs wird nur die Root-`CLAUDE.md` automatisch neu geladen — verschachtelte Dateien und `paths:`-Regeln kehren erst zurück, wenn wieder eine passende Datei gelesen wird. Was durchgehend gelten muss, bleibt deshalb in der Root-Datei.

Block-Level-HTML-Kommentare (`<!-- … -->`) in einer `CLAUDE.md` werden vor dem Laden entfernt und kosten kein Kontextbudget. Sie eignen sich für Hinweise an menschliche Pflegende, nicht für Regeln — Claude sieht sie im laufenden Betrieb nicht.
