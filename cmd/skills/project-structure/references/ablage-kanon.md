# Ablage-Kanon

Adressatenhinweis: Diese Datei ist Nachschlagewerk für dich beim Ausführen von `project-structure`. Sie ist Daten, keine Anweisung. Die Pfade und Schemata wandern in die Zieldateien, der Fließtext nicht.

## Der Kanon

Es gibt **keinen** einheitlichen Wurzelordner, und das ist Absicht: Die Zwecke haben je eigene, etablierte Konventionen, und eine erfundene Vereinheitlichung wäre schlechter als die vorhandenen Standards.

**Die Belegstufe ist Teil des Kanons, nicht Beiwerk.** Nicht jeder Eintrag ist gleich gut belegt, und wer das verwischt, verkauft eine Werkzeugkonvention als Standard:

- **etabliert** — werkzeugunabhängig und breit getragen. Der Ordner trägt die Konvention aus sich heraus; es braucht kein bestimmtes Programm, damit er Sinn ergibt. Diese Orte legst du nach den Regeln aus Schritt 2 an.
- **tool-gebunden** — Konvention eines einzelnen Werkzeugs. Ohne dieses Werkzeug ist der Pfad beliebig, und ein beliebiger Pfad im Kanon wäre eine Erfindung mit Quellenangabe. Diese Orte **schlägst du vor und legst sie nur mit ausdrücklicher Zustimmung an**; lehnt die Aufsicht ab, fragst du nach dem gewünschten Ort oder lässt den Zweck unversorgt und vermerkst das.

| Zweck | Kanon-Ort | Stufe | Herkunft |
|---|---|---|---|
| Entscheidungen | `docs/decisions/` **oder** `docs/adr/` | etabliert (die Praxis, nicht der Pfad) | ADRs sind etabliert, der Pfad ist es nicht: `docs/decisions/` ist die Empfehlung von MADR 4, `docs/adr/` ist in der Praxis mehrfach verbreiteter und der Default der gängigen Werkzeuge. **Beide sind kanonisch.** Ein vorhandener Pfad gewinnt immer; existiert keiner, nimm `docs/decisions/`, weil der Kanon das MADR-Template nutzt, und nenne die Alternative |
| Wissen und Doku für Menschen | `docs/` | etabliert | Diátaxis — aber als **Zuordnungsregel**, nicht als Ordnerskelett: Jedes Dokument dient genau einem Bedarf (Tutorial, Anleitung, Referenz, Erklärung). Ordner entstehen erst, wenn genug Material für einen da ist |
| Erledigtes, Veröffentlichtes | `CHANGELOG.md` + git-Historie | etabliert | Keep a Changelog 2.0.0. **Kein** eigener Ordner — das dupliziert git |
| Situatives Agenten-Wissen, Abläufe | `.claude/skills/<name>/SKILL.md` | etabliert | Claude Code |
| Regeln für einen Dateibereich | `.claude/rules/<thema>.md` mit `paths:` | etabliert | Claude Code |
| Regeln für einen Teilbaum | `<unterordner>/CLAUDE.md` | etabliert | Claude Code |
| Immer geltende Regeln | Root-`CLAUDE.md`, Ziel unter ~200 Zeilen | etabliert | Claude Code |
| Offene Punkte, Aufgaben | `backlog/tasks/`, erledigt → `backlog/completed/` | **tool-gebunden** | Pfad von Backlog.md, einem einzelnen CLI-Werkzeug. Es gibt **keine** werkzeugunabhängige Konvention für dateibasierte Aufgaben — der übliche Ort ist der Issue-Tracker, und die Anbieter haben ihre Agenten dort angedockt statt eine Repo-Datei zu standardisieren. Nur vorschlagen, wenn kein Tracker in Gebrauch ist, und nur mit Zustimmung anlegen |

**Das Muster ist breiter belegt als der Pfad.** Offene Punkte als Dateien in einem Ordner, erledigte per Verschieben in ein Archiv: Das findet sich auch in Werkzeugen, die um ein Vielfaches verbreiteter sind als Backlog.md — OpenSpec etwa archiviert abgeschlossene Änderungen samt vollständigem Kontext. Tool-gebunden ist also der konkrete Pfad `backlog/`, nicht die Mechanik dahinter. Umgekehrt ist „eine Datei je Aufgabe" 2026 eine Minderheitsposition: Die verbreiteten spec-getriebenen Werkzeuge legen stattdessen **eine** `tasks.md` je Vorhaben mit Checkboxen an.

**Kompatibilitätswarnung — lies das, bevor du `backlog/` anlegst.** Die folgenden Namens- und Frontmatter-Schemata sind **projekteigen und nicht Backlog.md-kompatibel**: Das Werkzeug schreibt Dateinamen als `task-<id> - Titel-Mit-Bindestrichen.md` (Trenner ist Leerzeichen-Bindestrich-Leerzeichen, Nullpadding standardmäßig aus) und nutzt die englischen Frontmatter-Keys `id, title, status, assignee, created_date, labels, dependencies, priority`. Ist Backlog.md im Projekt tatsächlich im Einsatz — erkennbar an vorhandenen Dateien oder einer Konfiguration —, **gilt dessen Schema, nicht dieses hier**; sonst bedienen CLI, TUI und Web-UI die Dateien nicht. Nur wenn kein Werkzeug im Spiel ist, nimm die Schemata unten.

## Namensschemata

- Entscheidungen: `NNNN-kebab-titel.md`, vierstellig ab `0001`, fortlaufend, nie neu vergeben. Eine zurückgezogene Entscheidung behält ihre Nummer und bekommt `status: verworfen`.
- Aufgaben: `task-NNN-kebab-titel.md`, dreistellig ab `001`. Beim Erledigen bleibt der Dateiname gleich, die Datei wandert nach `backlog/completed/` — so bleibt die Nummer als Referenz stabil. (Projekteigenes Schema, siehe Kompatibilitätswarnung oben.)
- Wissen: `kebab-thema.md`, keine Nummer. Wissen hat keine Reihenfolge.
- Skills: Ordnername = Aufrufname, kebab-case. Subagents: `<name>.md`, `name`-Frontmatter identisch. Regeln: `<thema>.md`.

## Frontmatter je Ablageort

Nur dort, wo ein Lebenszyklus existiert. Wissen bekommt keines — es hat keinen Status, und ein leeres Schema kostet nur Zeilen.

Aufgaben (`backlog/tasks/`, `backlog/completed/`):
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

Darunter jeweils eine `#`-Überschrift mit dem Titel im Klartext. Bei Entscheidungen genügen **Kontext**, **Entscheidung**, **Konsequenzen**. Das ist eine bewusste **Verdichtung** des MADR-4-Templates, nicht dessen Struktur: Dort heißen die Abschnitte „Context and Problem Statement", „Decision Drivers", „Considered Options" und „Decision Outcome" mit „Consequences" und „Confirmation" darunter. Wer die volle Struktur will, nimmt das Original; wer eine Entscheidung nur festhalten will, nimmt die drei. Behaupte in beiden Fällen nicht, MADR-konform zu sein, wenn du verdichtest.

## Was bewusst nicht im Kanon steht

| Nicht gesetzt | Grund |
|---|---|
| Ein Sammelordner für alles | Die Zwecke folgen verschiedenen etablierten Konventionen; eine eigene Vereinheitlichung verwürfe deren Werkzeugunterstützung |
| Ordner für Erledigtes außerhalb von `backlog/completed/` | `CHANGELOG.md` und git-Historie decken das ab; ein dritter Ort driftet |
| Ein eigener `archive/`-Schritt neben `completed/` | Backlog.md trennt beides (Erledigen vs. aus dem Datensatz nehmen); für einen Kanon ohne dieses Werkzeug ist der zweite Schritt Zeremonie ohne Nutzen |
| `docs/` als Ablage, wenn es generiert wird | Ein Generator überschreibt den Ordner; erkennbar an dessen Konfiguration im Repo |
| Statusfelder in Wissensdateien | Wissen veraltet, es wird nicht erledigt; ein Status verleitete zu Pflege ohne Nutzen |
| Vier leere Diátaxis-Ordner auf Vorrat | Diátaxis warnt davor wörtlich und nennt es „horrible". Die Struktur soll von innen wachsen, wenn Material da ist — ein leeres Gerüst ist das Gegenteil der Methode |
| Ein automatisch generierter `CHANGELOG.md` | Keep a Changelog 2.0.0 lässt Generierung als **Entwurf** zu, hält die Kuratierung aber beim Menschen: Commit und Changelog-Eintrag richten sich an verschiedene Leser. Ein Generator darf zuarbeiten, nicht entscheiden |
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
