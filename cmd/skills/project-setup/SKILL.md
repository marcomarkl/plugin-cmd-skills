---
name: project-setup
description: Erhebt in einem leeren oder bestehenden Projekt vier Fakten und gibt daraus die geordnete Aufrufliste der fünf Einrichtungs-Skills aus, je Schritt mit Aufruf, Argument, Vorbedingung und Abnahmekriterium. Lotst nur: Der Skill richtet nichts ein, schreibt keine Datei und ruft keinen von ihnen auf, du rufst sie danach selbst auf.
disable-model-invocation: true
allowed-tools: Read, Bash(ls:*), Bash(git rev-parse:*)
---

# Einrichtung lotsen

Du erhebst den Ist-Zustand dieses Projekts und gibst daraus **eine Liste** aus: die fünf Einrichtungs-Skills in der richtigen Reihenfolge, je Schritt mit Argument, Vorbedingung, Gegenstand und dem Kriterium, an dem der Nutzer den Erfolg abliest. Die Liste ist dein einziges Erzeugnis.

## Rolle und Grenze

Du bist **strikt lesend**. Du schreibst keine Datei, änderst keine Settings, legst keinen Ordner an und führst keinen von ihnen aus, auch nicht, wenn der Nutzer dich darum bittet. Verweise ihn in dem Fall auf die Liste: Er ruft die Skills selbst auf.

Der wahrscheinliche Fehlgriff ist nicht der Aufruf — alle tragen `disable-model-invocation: true` und sind für dich gesperrt —, sondern **ihre Arbeit selbst nachzumachen**: schnell die `settings.json` schreiben, schnell Dateien einsammeln, schnell die `CLAUDE.md` härten. Dabei entstünde eine halbe Einrichtung ohne die Vorschauen, das Verlagerungs-Register und die Verlustnachweise, für die diese Skills gebaut sind, und der Nutzer hätte nichts freigegeben.

Du bist projektbezogen. Die nutzerweite `~/.claude/CLAUDE.md` und die Nutzer-Settings fasst du nicht an und nimmst sie nicht in die Liste auf.

## Schritt 1: erheben

Genau vier Feststellungen. Kein `ls -R`, keine Repo-Tour, keine Inhaltsanalyse.

1. **Wurzel leer oder gewachsen.** Ein `ls` der Projektwurzel, mehr nicht.
2. **git-Lage.** Gibt es ein Repo, und liegt das aktuelle Verzeichnis im Repo-Root oder in einem Unterordner? `git rev-parse --show-toplevel` gegen das aktuelle Verzeichnis.
3. **Maßgebliche Regeldatei.** `CLAUDE.md`, `AGENTS.md`, beide, keine, oder `CLAUDE.md` als Symlink beziehungsweise als Import-Hülle mit `@AGENTS.md` in der ersten Zeile. → Füllt das Argument der Schritte 4 und 5.

   **Die beiden Sonderformen brauchen verschiedene Mittel.** Die Import-Hülle erkennst du an `@AGENTS.md` in der ersten Zeile — lies dafür **nur diese eine Zeile**. Einen **Symlink erkennst du daran gerade nicht**: Ein Lesevorgang folgt ihm und liefert den Zielinhalt, die Datei sieht dann aus wie eine echte. Dafür brauchst du `ls -l`. Sonst liest du keinen Dateiinhalt.
4. **Vorhandenes `.claude/`.** Existiert der Ordner, existiert `.claude/settings.json`? Nur die Existenz, nicht der Inhalt. → Sagt an Schritt 1, ob dieser eine `settings.json` **anlegt oder eine bestehende ergänzt**. Mehr sagt die Feststellung nicht: Ob `project-settings` schon einmal lief, folgt daraus **nicht** — eine `settings.json` kann aus jeder Quelle stammen, und du vergleichst nicht gegen den Kanon.

Jede der vier Feststellungen trägt eine Folge in der Liste. Was folgenlos bliebe, erhebst du nicht.

Was du **nicht** tust: die `settings.json` gegen den Permission-Kanon vergleichen, die Ablage inventarisieren, das Projektprofil bestimmen. Das leisten die Skills selbst, und dort gehört es hin. Du stellst deshalb auch nicht fest, welcher Schritt schon einmal gelaufen ist.

**Scheitert eine Erhebung** — ein Shell-Aufruf ist nicht zugelassen, ein Verzeichnis nicht lesbar —, brich nicht ab und rate nicht. Gib die Liste trotzdem aus und kennzeichne die betroffene Feststellung als **unbekannt**, die daran hängenden Hinweise als **unbestimmt**. Die Liste ist in jeder Lage dieselbe; nur ihre Hinweise hängen an der Erhebung.

## Schritt 2: die Liste ausgeben

**Alle fünf Schritte stehen immer in der Liste.** Was die Erhebung ergeben hat, wird zum **Hinweis am Schritt**, nie zu seiner Streichung. Du weißt nicht, was schon lief, und ein weggelassener Schritt behauptete genau das.

Je Eintrag **genau vier Angaben, keine davon leer**: der Aufruf so, wie er zu tippen ist, samt Argument; die Vorbedingung; was der Schritt in diesem Projekt anfasst; das Abnahmekriterium. Eine Angabe, die du weglässt, fehlt dem Nutzer hinterher. Kennzeichne durchgehend, welcher Art ein Kriterium ist: **am Projekt** ist später am Dateizustand ablesbar, **im Bericht** nur in der Ausgabe des Laufs, der gerade stattfand.

Die Vorbedingungen sind **Reihenfolge-Hinweise, keine Sperren**: Jeder Skill läuft auch für sich allein. Sag, was ein Vorgriff kostet, statt einen Schritt zu blockieren.

| # | Aufruf | Vorbedingung | Fasst an | Abnahme |
|---|---|---|---|---|
| 0 | `git init` — **nur wenn kein Repo existiert** | keine | das Verzeichnis selbst | **am Projekt:** `.git/` existiert |
| 1 | `/cmd:project-settings` — nimmt kein Argument | keine, läuft auch ohne Repo und im leeren Ordner | `.claude/settings.json`; bei Altlast aus einem früheren Lauf dazu `.gitignore` und `.claude/skills/` | **am Projekt:** `autoMemoryEnabled: false` steht darin — eine Stichprobe, nicht der ganze Kanon |
| 2 | `/cmd:project-structure`, optional Fokus oder Pfad | keine gegenüber Schritt 1 | die Ablage, verschiebt Bestand, schreibt den Wegweiser `## Ablage` | **am Projekt:** der Abschnitt steht in der Datei · **im Bericht:** die Zeilenbilanz geht auf |
| 3 | `/cmd:project-audit`, optional Fokus oder Pfad | nur sinnvoll bei vorhandenem Prompttext | nichts — liest und erzeugt einen Plan | **im Bericht:** Plan mit Befunden oder die ausdrückliche Feststellung, dass keiner standhielt |
| 3a | `/cmd:plan-review`, dann `/cmd:plan-execute` | Schritt 3 hat einen Plan erzeugt | erst der Plan, dann die Dateien, die er nennt | **am Projekt:** die im Plan genannten Stellen sind geändert |
| 4 | `/cmd:project-rules`, optional Pfad zur Zieldatei | Schritt 2 gelaufen, Zieldatei und Projektprofil bestätigt | genau die eine Regeldatei | **kein Kriterium am Projekt** — der Skill hinterlässt keine Marke; das schwächste hinreichende ist das Abdeckungs-Register in seiner Ausgabe |
| 5 | `/cmd:project-curate`, optional Pfad zur Zieldatei | Schritt 4 gelaufen | dieselbe Regeldatei, nur verdichtend | **im Bericht:** die Maß-Zeile nennt Zeilen und Zeichen vorher und nachher |

**Vier Hinweise, die sonst als Defekt gelesen werden.** Setze sie an den betroffenen Schritt, nicht als Sammelhinweis:

- **Schritt 0:** Alle schreibenden Skills laufen auch ohne Repo; sie sichern untrackte Dateien dann als `.bak`. Was fehlt, ist zweierlei: `project-structure` verschiebt nicht per `git mv`, die Historie geht verloren, und `git restore` als Rückweg entfällt. Ob der Ordner ein Repo werden soll, entscheidet der Nutzer.
- **Schritt 1:** Legt er die `settings.json` **neu an**, greift der Zeitanker-Hook voraussichtlich erst nach `/hooks` oder in einer neuen Session — der Settings-Watcher beobachtet nur Verzeichnisse, die beim Sessionstart schon eine Settings-Datei hatten. Ergänzt er eine bestehende, greift er sofort. Woher du das weißt, sagt Feststellung 4.
- **Schritt 2:** Im leeren Ordner legt `project-structure` die `CLAUDE.md` selbst an, mit nichts als dem Wegweiser; die Abnahme ist dann diese Datei, und der Bericht nennt sie unter „Angelegt" mit dem Rückweg `rm`. Existiert nur eine `AGENTS.md`, trägt sie den Wegweiser, und nichts wird angelegt.
- **Schritt 3:** Der Audit schreibt an keinen Zielort. Ohne die beiden Schritte unter 3a bleibt sein Ergebnis ein Plan, den niemand anwendet — nenne sie deshalb zusammen mit ihm, nicht als Nachtrag.

**Zur Reihenfolge: ein Halbsatz je belegter Abhängigkeit, und keiner, wo es keine gibt.** Belegt sind drei. *Settings vor rules*, weil `project-settings` vorhandene Auto-Memory-Einträge in die `CLAUDE.md` holt, die `project-rules` sonst nach dem Verdichten als Rohtext vorfindet. *Structure vor rules*, weil `project-structure` Inhalt auslagert und den Wegweiser schreibt, den `project-rules` danach mithärtet. *Audit vor rules*, weil `project-rules` keine vorhandene Regel schwächen darf: Was ein früherer Lauf geschrieben hat, verbucht es als `bereits vorhanden`, und veralteter Text bliebe stehen. *Curate nach rules* ist keine vierte Abhängigkeit, sondern dieselbe von der anderen Seite: Verdichten geht erst, wenn aller Inhalt steht. Für die Naht **Schritt 1 → Schritt 2 gibt es keine Begründung**: Die beiden sind unabhängig, ihre Reihenfolge ist Konvention. Sag das so, statt die Lücke mit einem sachfremden Grund zu füllen.

## Randfälle

Jeder erzeugt einen konkreten Zusatz am betroffenen Schritt, keinen allgemeinen Hinweis.

- **Aufruf aus einem Unterordner.** `project-rules` meint die Root-`CLAUDE.md`, `project-settings` die Settings des Repo-Roots. Scharf ist ein neuer Unterordner **innerhalb** eines bestehenden Repos: `git rev-parse --show-toplevel` meldet den übergeordneten Root, und die Liste bezöge sich stillschweigend auf ein fremdes Projekt. Leg den erkannten Root offen und stell beide Deutungen nebeneinander, statt eine zu wählen.
- **Kein git-Repo.** Projekt-Root ist dann das Startverzeichnis von Claude Code. Nenne das, weil die Pfadbezüge der Folgeschritte daran hängen.
- **`CLAUDE.md` und `AGENTS.md` existieren beide als echte Dateien.** Rate nicht, welche gemeint ist. `project-rules` verlangt in dieser Lage, das Drift-Risiko zu benennen und nur die maßgebliche Datei zu härten. Gib den Konflikt an Schritt 4 weiter, statt das Argument zu setzen.
- **`AGENTS.md` maßgeblich, oder `CLAUDE.md` ist Symlink oder Import-Hülle.** Setz das Argument der Schritte 4 und 5 entsprechend.
- **Leerer Ordner.** Die Datei legt Schritt 2 an (siehe den Hinweis dort), und das Argument der Schritte 4 und 5 zeigt auf sie. Neu ist hier nur: `project-rules` verlangt das Projektprofil, das ein leerer Ordner nicht hergibt — das muss vom Nutzer kommen. Sag ihm das am Schritt, nicht erst wenn er dort steht.

## Abschluss

Die Liste ist fertig, dein Teil ist beendet. Setze nichts um, biete auch nicht an, mit Schritt 1 zu beginnen, und arbeite nicht weiter. Der Nutzer ruft die Skills selbst auf, und zwar in der Reihenfolge, in der sie dastehen.
