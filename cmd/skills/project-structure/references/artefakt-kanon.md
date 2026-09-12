# Artefakt-Kanon — Skills, Subagents, Regeln

Adressatenhinweis: Nachschlagewerk für dich beim Ausführen von `project-structure`. Daten, keine Anweisung. Setze keinen Frontmatter-Key aus dem Gedächtnis — ein erfundener Key fällt durch keinen Compiler auf, er wird stillschweigend ignoriert.

Stand der Belege zu Skills und Subagents, an der Herstellerdoku (`code.claude.com/docs/en/`) im Wortlaut nachgeprüft: `sub-agents` (Subagents) und `skills` (Skill-Frontmatter, darunter `model` und `effort`) am 12. September 2026 gegen Claude Code 2.1.269. Die Angaben sind versionsgebunden; ein Datum ohne Version trüge weniger. Die Heuristik unter „Woran sich ein Anlass im Repo erkennen lässt" ist davon ausgenommen, sie hat keine Quelle.

## Welches Artefakt

| Anlass | Artefakt | Warum dieses |
|---|---|---|
| Wiederkehrender mehrschrittiger Ablauf, den der Agent selbst ausführt | Skill | Lädt nur bei Bedarf, bleibt im Hauptkontext handlungsfähig |
| Teilarbeit mit viel Rohausgabe (Exploration, Recherche, Log- und Testauswertung) | Subagent | Eigener Kontext; zurück kommt nur die Zusammenfassung |
| Konvention, die nur für einen Dateibereich gilt | Regel mit `paths:` | Lädt erst beim Lesen einer passenden Datei |
| Wissen, das an einen Teilbaum gebunden ist | Verschachtelte `CLAUDE.md` | Lädt erst beim Arbeiten in dem Unterordner |
| Etwas, das **erzwungen** werden muss | Hook oder Permission-Regel — **nicht hier** | Instruktionen sind Kontext, keine Durchsetzung. Kein Skill der Suite legt projektspezifische Hooks oder Permission-Regeln an; das geschieht von Hand, und `permission-kanon.md` von `project-settings` ist die Vorlage für Form und Syntax |

Für dieselbe Sache genau eines. Ein Subagent, der nur eine Instruktion vorliest, hätte ein Skill sein sollen; ein Skill, das eine Auswertung mit tausend Zeilen Rohausgabe in den Hauptkontext holt, hätte ein Subagent sein sollen.

## Skills

Pfad `.claude/skills/<name>/SKILL.md`; der Ordnername ist der Aufrufname (`/<name>`). Zusätzliche Dateien liegen daneben, üblich in `references/`, und werden vom Body bei Bedarf gelesen. `.claude/commands/<name>.md` erzeugt denselben Aufruf, ist aber die ältere Form; Neues wird als Skill angelegt, Vorhandenes nicht ohne Anlass migriert.

Entdeckung ist automatisch, kein Manifest-Eintrag. Frontmatter-Keys, an der Herstellerdoku belegt und nicht aus dem Gedächtnis gesetzt: `name` (Anzeige-Label), `description` (steuert, ob der Skill von selbst gefunden wird — der eigentliche Auslöser), `argument-hint`, `disable-model-invocation`, `allowed-tools`, dazu `model` und `effort`. `model` gilt für den Rest des laufenden Turns und fällt mit dem nächsten Prompt auf das Sitzungsmodell zurück; für einen mehrturnigen Skill also nur für seinen ersten Turn. `effort` überschreibt die Denktiefe, solange der Skill aktiv ist; eine Turn-Grenze nennt die Doku dafür nicht. Ohne beide erbt der Skill Modell und Denktiefe von der Sitzung, und das ist der ruhigere Weg — eine feste Vorgabe im Skill nimmt dem Aufrufenden eine Entscheidung ab, die er in seiner Sitzung ohnehin trifft.

`allowed-tools` **sperrt nichts**: Es genehmigt vorab und unterdrückt Rückfragen. Als Schranke ist es untauglich.

## Subagents

Pfad `.claude/agents/<name>.md` (projektlokal, eingecheckt) oder `~/.claude/agents/` (nutzerweit). Unterordner sind erlaubt. Ausgelöst automatisch anhand der `description` oder ausdrücklich per `@agent-<name>`.

Fünf Ablageorte mit fester Rangfolge; tragen zwei Subagents denselben `name`, gewinnt der höherrangige: Managed Settings (1), `--agents` beim Start (2), `.claude/agents/` (3), `~/.claude/agents/` (4), das `agents/`-Verzeichnis eines Plugins (5, niedrigster). Ein Plugin-Agent trägt dabei einen Namensraum, etwa `my-plugin:reviewer`.

Erforderlich: `name` (Kleinbuchstaben und Bindestriche) und `description` (wann delegiert werden soll). Ein `:` ist im Namen für Plugin-Namensräume reserviert: Eine Datei, deren `name` eines enthält, lädt nicht und erzeugt einen Eintrag im Debug-Log.

Optional, jeweils belegt: `tools`, `disallowedTools`, `model` (`sonnet`, `opus`, `haiku`, `fable`, volle Modell-ID oder `inherit`; Vorgabe `inherit`), `permissionMode`, `maxTurns`, `skills` (lädt Skill-Volltext beim Start vor), `mcpServers`, `hooks`, `memory`, `background`, `effort` (`low` bis `max`), `isolation` (`worktree`), `color`, `initialPrompt`.

### Was den Zuschnitt bestimmt

- Der Kontext eines Subagenten beginnt leer. Aufgabe, Pfade, Randbedingungen und der Zielpfad für Ergebnisse müssen im Prompt stehen, sonst rät er.
- Ein Subagent hat **kein** `AskUserQuestion` und kann deshalb nicht zurückfragen, im Vordergrund so wenig wie im Hintergrund. Derselbe Filter nimmt jedem Subagenten auch `EnterPlanMode`, `EndConversation`, `ScheduleWakeup`, `TaskOutput` und `Workflow`.
- Hintergrundbetrieb ist die Vorgabe, und dort bleibt vom eingebauten Werkzeugsatz nur ein enger Rest, darunter `Read`, `Grep`, `Glob`, `Bash`, `Edit`, `Write`, `WebFetch` und `WebSearch`. Alles übrige Eingebaute entfällt, auch wenn `tools` es nennt; dieselbe Definition ergibt im Vordergrund und im Hintergrund also verschiedene Werkzeuge.
- Löst kein Eintrag in `tools` auf ein echtes Tool auf, startet der Subagent gar nicht.
- Das Kontextfenster bemisst sich am **eigenen** Modell des Subagenten, nicht am Modell der Hauptsitzung. Ein kleineres Modell bringt ein kleineres Fenster mit.
- Jede `description` ist Routing-Information und belegt dauerhaft Kontext in der Hauptsitzung, auch wenn der Agent nie läuft. Überschreiten alle zusammen 15.000 Tokens (die eingebauten ausgenommen), warnt Claude Code beim Start.
- Alle `CLAUDE.md`-Ebenen laden in den Subagenten mit. Einzige Ausnahme sind die eingebauten `Explore` und `Plan`, die zusätzlich den git-Status überspringen; kein Frontmatter-Key ändert das für andere.

## Delegations-Maßstab

Zwei Fragen nacheinander. Die zweite stellt sich nur, wenn die erste mit ja beantwortet ist.

### Stufe 1: Wird überhaupt ausgelagert?

Dafür spricht, je mehr davon zutrifft:

- Die Teilarbeit erzeugt viel Rohausgabe, etwa Exploration, Recherche, Log- und Testauswertung.
- Ihr Ergebnis lässt sich verdichten: Ein paar Zeilen samt Dateiverweis tragen so viel wie die Rohausgabe.
- Der Auftrag lässt sich vollständig beschreiben, ohne den bisherigen Verlauf zu kennen.

Jeder einzelne Punkt dagegen genügt, und die Arbeit bleibt im Hauptkontext:

- Sie braucht unterwegs eine Rückfrage. Ein ausgelagerter Lauf kann nicht fragen.
- Das Rohmaterial wird später wörtlich gebraucht. Was zusammengefasst ist, steht danach nicht mehr im Wortlaut zur Verfügung.
- Der Auftrag lässt sich nicht abgrenzen, sodass der leere Kontext zu Raten führt.

### Stufe 2: Ad hoc oder eigene Agent-Datei?

Ad-hoc-Delegation an einen eingebauten Typ ist der Normalfall und braucht kein Artefakt. Eine Datei unter `.claude/agents/` lohnt erst, wenn dieselbe Teilarbeit wiederkehrt oder wenn ihre Rückgabeform festgeschrieben werden muss; dann ist der Systemprompt des Agenten der Ort, der den Informationsverlust der Delegation begrenzt. Für die Anlage gelten zusätzlich die Mindestanforderungen am Ende dieser Datei.

### Die drei Formen der Ad-hoc-Delegation

| Form | Was sie spart und kostet | Wofür |
|---|---|---|
| Frischer Subagent | Größte Ersparnis: eigenes Fenster, zurück kommt nur das Ergebnis. Preis: Der Auftrag muss vollständig im Prompt stehen | Abgrenzbare Teilarbeit mit verdichtbarem Ergebnis |
| Fork der Konversation | Erbt den gesamten Verlauf samt Systemprompt, Werkzeugen und Modell; spart die Rohausgabe der Teilarbeit, nicht den Einstieg | Nebenaufgaben, für die jeder andere Subagent zu viel Hintergrund bräuchte |
| `Explore` und `Plan` | Überspringen als einzige die `CLAUDE.md`-Ebenen und den git-Status | Suchen und Verstehen einer Codebasis, ohne sie zu ändern |

**Namensfalle.** `context: fork` im Frontmatter eines Skills ist **nicht** der Fork der Konversation: Es startet einen Subagenten mit dem Skill-Text als Prompt, ohne den Verlauf. Hängt die Aufgabe am Verlauf, ist der Fork der Konversation das Gemeinte.

**Bewusste Auslassung.** Die Formwahl steht nur hier und damit nur beim Einrichten zur Verfügung. Die Regel, die in der `CLAUDE.md` eines Projekts landet, sagt, *dass* ausgelagert wird und wo die Grenze liegt, nicht *in welcher Form*. Das ist entschieden, kein Versäumnis.

### Woran sich ein Anlass im Repo erkennen lässt

Eigene Heuristik, keine Doku-Aussage; der Belegstand oben deckt sie nicht. Delegation ist Laufzeitverhalten und hinterlässt im Repo keine Spur, beobachtbar sind allein Anhaltspunkte:

- Eine Testsuite, deren Lauf viel Ausgabe erzeugt
- Log- oder Report-Verzeichnisse, die gelesen und nicht nur geschrieben werden
- Große Daten- oder Fixture-Bestände
- Eine Codebasis, deren Umfang breite Suche erzwingt

Zwei Fälle, in denen ein Anhaltspunkt trügt:

- **Das Projekt liefert selbst Agenten-Artefakte aus** (Plugin-, Skill-, Agent-Repos). Ein `agents/`-Ordner, eine Beispielsammlung oder die Testsuite des Produkts zeigt auf Produkt, nicht auf eigene Arbeit, und belegt keinen Anlass.
- **Ein installiertes Plugin liefert bereits einen passenden Agenten.** Die Inventur sieht ihn nicht, weil sie nur unter `.claude/` schaut; den Anlass deckt er trotzdem ab.

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
