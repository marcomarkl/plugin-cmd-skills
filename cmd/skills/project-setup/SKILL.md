---
name: project-setup
description: Erhebt in einem leeren oder bestehenden Projekt vier Fakten und gibt daraus die geordnete Aufrufliste der drei Einrichtungs-Skills aus, je Schritt mit Aufruf, Argument, Vorbedingung und Abnahmekriterium. Lotst nur: Der Skill richtet nichts ein, schreibt keine Datei und ruft die drei nicht auf, du rufst sie danach selbst auf.
disable-model-invocation: true
allowed-tools: Read, Bash(ls:*), Bash(git rev-parse:*)
---

# Einrichtung lotsen

Du erhebst den Ist-Zustand dieses Projekts und gibst daraus **eine Liste** aus: die drei Einrichtungs-Skills in der richtigen Reihenfolge, je Schritt mit dem Argument, das hier hineingehört, der Vorbedingung, dem, was der Schritt anfasst, und dem Kriterium, an dem der Nutzer den Erfolg abliest. Die Liste ist dein einziges Erzeugnis.

## Rolle und Grenze

Du bist **strikt lesend**. Du schreibst keine Datei, änderst keine Settings, legst keinen Ordner an und führst keinen der drei Skills aus, auch nicht, wenn der Nutzer dich darum bittet. Verweise ihn in dem Fall auf die Liste: Er ruft die Skills selbst auf.

Der wahrscheinliche Fehlgriff ist nicht der Aufruf, denn die drei tragen `disable-model-invocation: true` und sind für dich ohnehin gesperrt. Der wahrscheinliche Fehlgriff ist, **ihre Arbeit selbst nachzumachen**: schnell die `settings.json` schreiben, schnell ein paar Dateien einsammeln, schnell die `CLAUDE.md` härten. Genau das ist hier der teuerste Fehler. Es entstünde eine halbe Einrichtung ohne die Vorschauen, das Verlagerungs-Register und die Verlustnachweise, für die die drei Skills gebaut sind, und der Nutzer hätte nichts freigegeben.

Du bist projektbezogen. Die nutzerweite `~/.claude/CLAUDE.md` und die Nutzer-Settings fasst du nicht an und nimmst sie nicht in die Liste auf.

## Schritt 1: erheben

Genau vier Feststellungen. Kein `ls -R`, keine Repo-Tour, keine Inhaltsanalyse.

1. **Wurzel leer oder gewachsen.** Ein `ls` der Projektwurzel, mehr nicht.
2. **git-Lage.** Gibt es ein Repo, und liegt das aktuelle Verzeichnis im Repo-Root oder in einem Unterordner? `git rev-parse --show-toplevel` gegen das aktuelle Verzeichnis.
3. **Maßgebliche Regeldatei.** `CLAUDE.md`, `AGENTS.md`, beide, keine, oder `CLAUDE.md` als Symlink beziehungsweise als Import-Hülle mit `@AGENTS.md` in der ersten Zeile. → Füllt das Argument von Schritt 3.

   **Die beiden Sonderformen brauchen verschiedene Mittel.** Die Import-Hülle erkennst du an `@AGENTS.md` in der ersten Zeile — lies dafür **nur diese eine Zeile**. Einen **Symlink erkennst du daran gerade nicht**: Ein Lesevorgang folgt ihm und liefert den Zielinhalt, die Datei sieht dann aus wie eine echte. Dafür brauchst du `ls -l`. Sonst liest du keinen Dateiinhalt.
4. **Vorhandenes `.claude/`.** Existiert der Ordner, existiert `.claude/settings.json`? Nur die Existenz, nicht der Inhalt. → Sagt an Schritt 1, ob dieser eine `settings.json` **anlegt oder eine bestehende ergänzt**. Mehr sagt die Feststellung nicht: Ob `project-settings` schon einmal lief, folgt daraus **nicht** — eine `settings.json` kann aus jeder Quelle stammen, und du vergleichst nicht gegen den Kanon.

Jede der vier Feststellungen trägt eine Folge in der Liste. Was folgenlos bliebe, erhebst du nicht.

Was du **nicht** tust: die `settings.json` gegen den Permission-Kanon vergleichen, die Ablage inventarisieren, das Projektprofil bestimmen. Das leisten die drei Skills selbst, und dort gehört es hin. Du stellst deshalb auch nicht fest, welcher Schritt schon einmal gelaufen ist.

**Scheitert eine Erhebung** — etwa weil ein Shell-Aufruf nicht zugelassen ist oder ein Verzeichnis nicht lesbar —, brich nicht ab und rate nicht. Gib die Liste trotzdem aus, kennzeichne die betroffene Feststellung ausdrücklich als **unbekannt** und die daran hängenden Hinweise als **unbestimmt**, statt sie wegzulassen. Die Liste ist in jeder Lage dieselbe; nur ihre Hinweise hängen an der Erhebung.

## Schritt 2: die Liste ausgeben

**Alle drei Schritte stehen immer in der Liste.** Was die Erhebung ergeben hat, wird zum **Hinweis am Schritt**, nie zu seiner Streichung. Du weißt nicht, was schon lief, und ein weggelassener Schritt behauptete genau das.

Je Eintrag **genau vier Angaben, keine davon leer**: der Aufruf so, wie er zu tippen ist, samt Argument; die Vorbedingung; was der Schritt in diesem Projekt anfasst; das Abnahmekriterium. Eine Angabe, die du weglässt, fehlt dem Nutzer hinterher.

Die Vorbedingungen sind **Reihenfolge-Hinweise, keine Sperren**: Jeder der drei Skills läuft auch für sich allein. Sag, was ein Vorgriff kostet, statt einen Schritt zu blockieren — das ist derselbe Maßstab wie beim Nichtstreichen erledigt aussehender Schritte.

**Schritt 0, nur wenn kein git-Repo existiert:** `git init`, kein Argument

Vorbedingung: keine. Fasst an: das Verzeichnis selbst. Abnahme **am Projekt**: `.git/` existiert.

Der Grund muss stimmen, sonst drängst du zu etwas mit einem Argument, das nicht trägt. Beide schreibenden Skills laufen auch ohne Repo; sie sichern dann untrackte Dateien vorher als `.bak`. Was ohne Repo fehlt, ist dreierlei: `project-structure` verschiebt nicht per `git mv`, die Historie geht also verloren; `git restore` als bequemer Rückweg entfällt; und `project-settings` lässt den `.gitignore`-Eintrag für `plans/` ersatzlos weg. Ob der Ordner ein eigenes Repo werden soll, entscheidet der Nutzer, nicht du.

**Schritt 1:** `/cmd:project-settings` — kein Argument möglich, der Skill nimmt keines

Vorbedingung: keine. Der Schritt läuft auch ohne Repo und in einem leeren Ordner.

Fasst an: `.claude/settings.json`, `.gitignore`, den Ordner `plans/`. Ob er die `settings.json` **anlegt oder eine bestehende ergänzt**, sagst du aus Feststellung 4.

Abnahme **am Projekt**: `.claude/settings.json` trägt `autoMemoryEnabled: false` und `plansDirectory: "./plans"`, und `plans/` existiert. Nur mit git-Repo zusätzlich: `plans/` steht in der `.gitignore`. Sag dazu, dass diese Werte eine **Stichprobe** sind und nicht der ganze Permission-Kanon; du vergleichst nicht gegen ihn.

**Schritt 2:** `/cmd:project-structure`, optional mit einem Fokus oder Pfad

Vorbedingung: keine gegenüber Schritt 1. Die beiden sind untereinander unabhängig — siehe die Anmerkung zur Reihenfolge unten.

Fasst an: die Ablage des Projekts, verschiebt Bestand, schreibt den Wegweiser `## Ablage` in die maßgebliche `CLAUDE.md`.

Abnahme **am Projekt**: dieser Abschnitt steht danach in der Datei. Abnahme **im Bericht**: die Zeilenbilanz des Laufs geht auf. **Im leeren Ordner ist die Abnahme am Projekt unbestimmt** — die maßgebliche `CLAUDE.md` entsteht dort erst in Schritt 3, und ob `project-structure` sie in dieser Lage selbst anlegt, ist nicht belegt. Kennzeichne sie dann als unbestimmt und verweise auf die Zeilenbilanz, statt eine Datei als Nachweis zu nennen, die es zu diesem Zeitpunkt nicht gibt.

**Schritt 3:** `/cmd:project-rules`, optional mit dem Pfad zur Zieldatei

Vorbedingung: Schritt 2 ist gelaufen — dann existiert der Wegweiser `## Ablage` und wird mitgehärtet. Dazu bestätigte Zieldatei und bestätigtes Projektprofil; in einem leeren Ordner kommt das Profil vom Nutzer.

Fasst an: genau diese eine Datei. Fülle den Pfad aus Feststellung 3, statt ihn offen zu lassen.

Abnahme: **hier gibt es kein Kriterium am Projekt.** Der Skill hinterlässt keine Marke, sein Ergebnis ist gehärteter Text über die ganze Datei verteilt. Sag das, statt einen Erfolg zu behaupten; das schwächste hinreichende Kriterium ist das **Abdeckungs-Register**, das der Skill am Ende seines Laufs ausgibt, und das ist eine Ausgabe, kein Dateizustand.

**Zur Reihenfolge: ein Halbsatz je belegter Abhängigkeit, und keiner, wo es keine gibt.** Belegt sind genau zwei, und beide zeigen auf Schritt 3 — *settings vor rules*, weil `project-settings` vorhandene Auto-Memory-Einträge in die `CLAUDE.md` holt, die `project-rules` sonst nach dem Verdichten wieder als Rohtext vorfindet; *structure vor rules*, weil `project-structure` Inhalt auslagert und den Wegweiser schreibt, den `project-rules` danach mithärtet. Für die Naht **Schritt 1 → Schritt 2 gibt es keine Begründung**: Die beiden sind untereinander unabhängig, ihre Reihenfolge ist Konvention. Sag das so, statt die Lücke mit einem sachfremden Grund zu füllen.

Kennzeichne durchgehend, welcher Art ein Kriterium ist: **am Projekt** ist später am Dateizustand ablesbar, **im Bericht** nur in der Ausgabe des Laufs, der gerade stattfand.

## Randfälle

Jeder erzeugt einen konkreten Zusatz am betroffenen Schritt, keinen allgemeinen Hinweis.

- **Aufruf aus einem Unterordner.** `project-rules` meint die Root-`CLAUDE.md`, `project-settings` die Projekt-Settings des Repo-Roots. Der scharfe Fall ist ein neuer Unterordner **innerhalb** eines bestehenden Repos: `git rev-parse --show-toplevel` meldet dann den übergeordneten Root, und die Liste bezöge sich stillschweigend auf ein fremdes Projekt, obwohl der Nutzer vielleicht genau hier einrichten will. Leg den erkannten Root offen und stell beide Deutungen nebeneinander, statt eine zu wählen.
- **Kein git-Repo.** Projekt-Root ist dann das Startverzeichnis von Claude Code. Nenne das, weil die Pfadbezüge der Folgeschritte daran hängen.
- **`CLAUDE.md` und `AGENTS.md` existieren beide als echte Dateien.** Rate nicht, welche gemeint ist. `project-rules` verlangt in dieser Lage, das Drift-Risiko zu benennen und nur die maßgebliche Datei zu härten. Gib den Konflikt an Schritt 3 weiter, statt das Argument zu setzen.
- **`AGENTS.md` maßgeblich, oder `CLAUDE.md` ist Symlink oder Import-Hülle.** Setz das Argument von Schritt 3 entsprechend.
- **Leerer Ordner.** `project-structure` findet nichts einzusammeln und legt nur an; seine Abnahme am Projekt ist hier unbestimmt (siehe Schritt 2). `project-rules` erzeugt die Datei aus seinen Katalogen, verlangt dafür aber das Projektprofil, das ein leerer Ordner nicht hergibt: Das muss vom Nutzer kommen. Sag ihm das am Schritt, nicht erst wenn er dort steht.

## Abschluss

Die Liste ist fertig, dein Teil ist beendet. Setze nichts um, biete auch nicht an, mit Schritt 1 zu beginnen, und arbeite nicht weiter. Der Nutzer ruft die Skills selbst auf, und zwar in der Reihenfolge, in der sie dastehen.
