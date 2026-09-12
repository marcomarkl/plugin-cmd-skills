# cmd — Planungs-Toolkit für Claude Code

Zehn Skills rund um Klären, Planen, Reviewen, Umsetzen, Lotsen, Einrichten, Strukturieren, Lernen, Übergeben und Wiederaufnehmen. Der Plugin-Name `cmd` (aus `.claude-plugin/plugin.json`) bildet den Namespace, deshalb beginnt jeder Aufruf mit `/cmd:`.

Installation und Überblick stehen im [Root-README](../README.md); die Entwurfsnotizen (Stellschrauben, verworfene Ansätze) in [`DESIGN.md`](../DESIGN.md).

> Die Skills sind **deutschsprachige Prompts** — sie steuern Claude auf Deutsch.

## Die Skills — und wann du welchen nimmst

| Skill | Was er tut | Wann |
|---|---|---|
| `/cmd:plan-grill` | Interviewt dich zu einem Vorhaben, löst die Entscheidungen einzeln in Abhängigkeits- und Tragweitenreihenfolge auf, protokolliert sie revidierbar und legt sie nach deiner Bestätigung als Plan an. | **Am Anfang**, wenn das Vorhaben noch unscharf ist. |
| `/cmd:plan-review` | Reviewt den zuletzt erstellten Plan in rotierenden Blickwinkeln und arbeitet die belastbaren Befunde direkt ein. | Sobald ein Plan steht — von `plan-grill` oder `/plan` —, bevor du freigibst. |
| `/cmd:plan-execute` | Setzt den freigegebenen Plan vollständig um und verifiziert jeden Schritt gegen ein beobachtbares Kriterium; hält bei einem Fund außerhalb des Plans oder einer Klassifikator-Blockade an und fragt nach. | **Nach** dem Verlassen des Plan-Modus. |
| `/cmd:project-setup` | Erhebt vier Fakten am Projekt und gibt die geordnete Aufrufliste der drei Einrichtungs-Skills aus, je Schritt mit Argument, Vorbedingung und Abnahmekriterium. Richtet selbst nichts ein. | **Zuerst**, bevor du die drei anderen `project-`Skills fährst. |
| `/cmd:project-rules` | Härtet eine bestehende `CLAUDE.md`/`AGENTS.md` mit acht Disziplin-Katalogen und verdichtet sie token-effizient. | Eigenständig, wenn die Projektregeln Pflege brauchen. |
| `/cmd:project-settings` | Setzt die `.claude/settings.json` auf einen festen Kanon, entdoppelt die Permission-Listen und legt den Zeitanker-Hook. | **Einmal** beim Einrichten eines Projekts, danach bei Bedarf erneut. |
| `/cmd:project-structure` | Bringt die Ablage auf einen belegten Kanon, sammelt Streudateien ein und schlägt projekteigene Skills, Subagents und `paths:`-Regeln vor, Subagents entlang eines Delegations-Maßstabs. Verschiebt nur mit Verlagerungs-Register und Verlustnachweis. | Wenn die `CLAUDE.md` zuwächst oder Wissen verstreut liegt. |
| `/cmd:session-learn` | Reflektiert die laufende Session, leitet dauerhafte Learnings ab und übergibt sie als Plan an `plan-review`/`plan-execute`. | Am **Ende** einer Session. |
| `/cmd:session-handoff` | Verdichtet den laufenden Arbeitsstand in eine kurze `HANDOFF.md`, damit ein frisches Fenster ohne den bisherigen Verlauf weiterarbeiten kann. | Wenn das **Kontextfenster knapp** wird. |
| `/cmd:session-resume` | Nimmt die Übergabedatei im frischen Fenster auf, prüft ihren Stand gegen das Projekt, legt den nächsten Schritt vor und räumt die Datei nach deiner Bestätigung weg. | **Im neuen Fenster**, direkt nach einem Handoff. |

Alle zehn sind `disable-model-invocation: true` — sie laden **nur auf deinen Aufruf hin**, nie automatisch. Das ist Absicht: es sind timing-kontrollierte Workflows.

Keiner setzt ein Modell oder eine Denktiefe: Sie laufen mit der Einstellung deiner Session. Willst du für einen Lauf mehr Tiefe — `plan-review` und `project-rules` sind die aufwendigsten —, heb den Effort der Session, statt im Skill zu suchen.

**grill und review teilen sich den Plan nach Gegenstand**, nicht nach Reihenfolge: grill klärt die **Entscheidungen** und legt sie als Plan an, review prüft den **fertigen Plan** in Runden und härtet ihn. Beide schreiben in dieselbe Plandatei, und beide machen ihr Ergebnis über **stabile Kennungen** zurücknehmbar (grill „nimm Entscheidung 3 zurück", review „nimm Änderung 2.3 zurück").

## Pipeline

Die drei plan-Skills bilden eine Kette um den Plan-Modus, jede Naht mit einem klaren Vertrag:

```
plan-grill        →  plan-review  →  ExitPlanMode  →  plan-execute
 (klärt und baut)    (härtet)                         (setzt um)
```

- **grill → review:** grill interviewt, gibt die Schlussnotiz aus und legt **nach deiner Bestätigung** den Plan an — mit Context, ausgeformten Vorgaben, dem Entscheidungs-Ledger und den im Interview erhobenen Belegen. Ist der Plan-Modus nicht aktiv, bietet er vorher `EnterPlanMode` an; ein Plan außerhalb des Plan-Modus wäre für review und execute nicht dasselbe Artefakt. **`/plan` ist damit kein Pflichtglied mehr** — nutze es, wenn du ohne Interview direkt planen willst.
- **grill/plan → review:** review arbeitet auf dem existierenden Plan und härtet ihn in Runden; das Ergebnis ersetzt den Plan.
- **review → execute:** execute setzt den **freigegebenen** Plan um. **Vertrag:** execute erwartet, dass der Plan **pro Schritt ein beobachtbares Verifikationskriterium** trägt. Fehlt eins, leitet execute das schwächste hinreichende selbst ab.

Jeder Skill ist einzeln nutzbar; die Kette ist die Kür, nicht die Pflicht.

`session-learn` steht **quer** zu dieser Kette: es reflektiert eine ganze Session und erzeugt selbst einen Plan — aber über die *Arbeitsweise* (Learnings für künftige Sessions), nicht über eine Aufgabe. Weil der Plan damit schon existiert, tritt es bei `plan-review` in die Kette ein, nicht bei `/plan`.

`session-handoff` steht **quer zur Zeitachse**: Es unterbricht die Kette an beliebiger Stelle — typischerweise mitten in `plan-execute`, dem einzigen langlaufenden Skill — und reicht den Stand an ein frisches Fenster weiter, wo `session-resume` ihn aufnimmt und die Kette dort fortsetzt, wo sie abbrach.

**Zwei der drei `session-*`-Skills teilen sich die Session nach Haltbarkeit**, und danach wählst du: `session-learn` nimmt das **Dauerhafte** (Learnings, die künftige Sessions besser machen) und legt es projektlokal ab; `session-handoff` nimmt das **Flüchtige** (wo die Arbeit gerade steht) und gibt es ans nächste Fenster. Am Sessionende sinnvoll beides, in dieser Reihenfolge — `session-learn` belegt die Plandatei, auf die `session-handoff` danach nur noch verweisen muss. `session-resume` teilt dagegen nichts: Es ist das **zeitliche Gegenstück** zu `session-handoff`, derselbe Stand eine Sitzung später und in die andere Richtung.

Die `project-*`-Skills stehen **vor** der Kette und sind keine Pipeline-Glieder: **drei** richten ein, ein **vierter** lotst nur durch die drei. Unter den einrichtenden gilt eine Reihenfolge, und zwar aus je eigenem Grund:

```
project-setup  ⇢  project-settings  →  project-structure  →  project-rules
 (lotst, führt      (Settings, holt      (Ablage, lagert      (härtet und
  nichts aus)        Auto-Memory rein)     Inhalt aus)          verdichtet)
```

`project-setup` steht davor, ist aber **kein Glied**: Es erhebt vier Fakten am Projekt und gibt die Reihe als Liste aus, mit dem Argument je Aufruf, der Vorbedingung und dem Abnahmekriterium. Ausgeführt wird nichts, deshalb der gestrichelte Pfeil. Aufrufen musst du die drei weiterhin selbst, und genau das ist Absicht: Ihre Sperre `disable-model-invocation` hält Claude von ihnen fern, und sie aufzuheben, um eine Verkettung zu ermöglichen, öffnete ausgerechnet die schreibenden Skills fürs automatische Laden.

- **settings vor rules**, weil `project-settings` vorhandene Auto-Memory-Einträge in die `CLAUDE.md` holt. Umgekehrt verdichtete `project-rules` einen Stand, dem der Import erst danach wieder Rohtext anhängt.
- **structure vor rules**, weil `project-structure` Inhalt auslagert und den Wegweiser-Abschnitt `## Ablage` schreibt. `project-rules` härtet und verdichtet die Datei danach — auch diesen Abschnitt.
- **Rückkopplung:** Findet `project-rules` auslagerungsreife Blöcke, verschiebt es sie nicht selbst, sondern markiert sie und empfiehlt einen Lauf von `project-structure`. Die Trennung ist Absicht: `project-rules` lebt von *einem* kohärenten Schreibvorgang an *einer* Datei, ein Umzug über viele Dateien braucht Rückweg und Verlustnachweis je Datei.

Zu `session-learn` ist das Verhältnis komplementär: `project-settings` schaltet das Memory-System ab und leert es einmalig, `session-learn` hat es ohnehin nie genutzt.

Die Präfixe ordnen die Skills: `plan-*` wirken am Plan-Lebenszyklus, `project-*` am Projekt als Ganzem (an seinen Artefakten `CLAUDE.md`, `.claude/settings.json` und Ablage, oder wie `project-setup` am Weg dorthin), `session-*` an der Arbeitssession selbst.

## Voraussetzungen für `plan-execute`

Zielmodus für die Umsetzung ist **Auto mode**. Der Skill kann den Modus **nicht selbst setzen** — er muss vorher aktiv sein. Ohne Auto mode läuft er ebenfalls, dann mit Permission-Prompts statt automatischer Freigabe.

Auto mode aktivieren (einmaliges Opt-in):

1. Verfügbarkeit prüfen über den Shift+Tab-Zyklus oder `/status`. Erscheint Auto mode nicht, ist eine Voraussetzung nicht erfüllt (Version, Modell oder Owner-Freigabe bei Team/Enterprise).
2. `claude --enable-auto-mode`, dann per Shift+Tab auf Auto mode wechseln.
3. Dauerhaft: `permissions.defaultMode: "auto"` **nur** in `~/.claude/settings.json` (projektbezogene Settings werden für diesen Wert ignoriert).

> **Auto mode ist ein Research Preview ohne Sicherheitsgarantie** — nur in isolierter Umgebung nutzen.

## Gut zu wissen

- **`plan-grill` schreibt während des Interviews nichts** und legt nach deiner Bestätigung genau eine Datei an: den Plan. Umgesetzt wird auch danach nichts — dafür ist `plan-execute` da.
- **`session-learn` schreibt nichts an die Zielorte.** Es reflektiert und übergibt sein Ergebnis; angewendet wird es erst über den Plan. Die Plandatei selbst schreibt es.
- **`project-settings` holt genau eine Freigabe.** Alle Änderungen kommen gesammelt in einer Vorschau, mit dem Rückweg je Datei (`git restore` bei getrackten, `.bak` bei untrackten). Die Nutzer-Settings fasst der Skill nicht an.
- **`project-settings` ist wiederholbar.** Ein zweiter Lauf ohne zwischenzeitliche Änderung erzeugt keinen Diff. Fremde Einstellungen und fremde Permission-Einträge bleiben unangetastet; nur die Kanon-Werte werden gesetzt.
- **`project-settings` setzt seit 0.21.0 einen Zeitanker.** Ein `UserPromptSubmit`-Hook gibt jedem Turn die Systemzeit, weil Claude Code von sich aus nur das Datum liefert und dieses beim Sessionstart festschreibt. Ohne Uhr sieht ein Messwert aus einem früheren Turn so frisch aus wie beim Erheben. Der Hook macht den Verzug nur sichtbar; die Pflicht, vor einer Aussage neu zu messen, kommt aus dem Regelkatalog von `project-rules` und wirkt auch ohne ihn. Zwei Dinge gehören dazu gesagt: Wird die `settings.json` in diesem Lauf **neu angelegt**, greift der Hook voraussichtlich erst nach `/hooks` oder in einer neuen Session, denn der Settings-Watcher beobachtet nur Verzeichnisse, die beim Start schon eine Settings-Datei hatten. Und er ist **nicht** die Altlast aus dem nächsten Punkt: Der entfernte `SessionStart`-Hook des Session-Protokolls ist ein anderes Event und ein anderer Zweck.
- **`project-settings` räumt zwei Altlasten weg.** In Projekten, die vor 0.10.0 eingerichtet wurden, liegen ein `SessionStart`-Hook und `.claude/skills/session-protocol/SKILL.md` — sie laden bis heute bei jedem Sessionstart, obwohl das Protokoll aus dem Plugin entfernt ist. Der Skill erkennt beides an einer festen Marke, legt die Entfernung in dieselbe Vorschau wie alles andere und lässt fremde `SessionStart`-Hooks stehen. Zwei Keys in `~/.claude/settings.json` (`crossSessionInbound`, `isolatePeerMachines`) meldet er nur — die liegen außerhalb des Projekts und können bewusst gesetzt sein. Dazu kommt seit 0.18.0 das **projektlokale Planverzeichnis**: Wo ein Lauf bis 0.17.0 `plansDirectory: "./plans"` gesetzt hat, nimmt er den Key zurück, und die `.gitignore`-Zeile nur mit ihm zusammen und nur, wenn `plans/` leer ist — liegen Pläne darin, bleibt sie stehen, damit sie nicht plötzlich untrackt auftauchen. Den Ordner selbst fasst er nie an; vorhandene Pläne bleiben liegen, neue entstehen wieder in `~/.claude/plans/`. In einem Projekt ohne diese Spuren taucht der Punkt nicht auf.
- **Nach `project-settings` greifen die `allow`-Regeln erst nach dem Workspace-Trust-Dialog** für den Ordner — `deny` und `ask` sofort. Direkt nach dem Lauf sind also die Einschränkungen aktiv und die Erleichterungen noch nicht; das ist erwartet, kein Fehlschlag.
- **`project-rules` verschiebt nichts und legt nichts an.** Es bleibt bei der einen Zieldatei. Auslagerungsreife Blöcke markiert es mit dem vorgesehenen Ziel und empfiehlt `project-structure` — herausgelöst wird nichts, wofür es noch kein Ziel gibt.
- **`project-structure` erkennt, bevor es anlegt.** Ein genutzter Issue-Tracker verhindert `backlog/`, ein vorhandenes `docs/adr/` ein zweites `docs/decisions/`, ein generiertes `docs/` jede Ablage darin. Umbenennungen auf den Kanon werden vorgeschlagen, nicht vorausgesetzt — bei Ablehnung gilt der vorhandene Name.
- **`project-structure` bewegt nichts ohne Verlagerungs-Register.** Jede Quelle landet in genau einem Ziel, verschoben wird per `git mv` (Historie bleibt erhalten), und der Bericht schließt mit einer Zeilenbilanz. Geht sie nicht auf, meldet der Skill das als Fehler, statt die Differenz zu glätten. Verschieben ist dabei reine Ortsänderung: gekürzt oder umformuliert wird nichts — das macht danach `project-rules`.
- **`project-structure` schreibt genau einen Abschnitt in die `CLAUDE.md`**, den Wegweiser unter der festen Überschrift `## Ablage`. Den Rest der Datei fasst es nicht an.
- **Vorgeschlagene Skills und Subagents brauchen eine eigene Bestätigung.** Schreiben unter `.claude/` ist gesondert geschützt: Eine vorab erteilte Freigabe genügt dort nicht, der Prompt kommt trotzdem. Lehnst du ab, bleibt der Inhalt an seinem alten Platz stehen — der Skill entfernt eine Quelle nie, deren Ziel er nicht schreiben konnte. Der Vorschlag steht dann als offener Punkt im Bericht.
- **Ein Subagent-Vorschlag hat zwei Ausgänge, die verschieden enden.** Bildet `project-structure` den Anlass aus Anhaltspunkten im Projekt, legt es ihn in der Vorschau zur Bestätigung vor. Bestätigst du ihn nicht, entsteht kein Vorschlag, und es bleibt auch nichts offen — anders als bei einer verweigerten Freigabe, die den Vorschlag als offenen Punkt stehen lässt. Was `project-rules` in die `CLAUDE.md` schreibt, sagt dir, wann Auslagern sich lohnt und wann es unterbleibt; die Wahl der Form steht im Kanon des Skills, nicht in deiner Regeldatei.
- **`session-learn` holt eine Freigabe, nicht zwei.** Die Learnings werden nicht vorab bestätigt: Der Skill schreibt den Plan im selben Zug wie die Schlussnotiz. Die verbleibende Zustimmung ist der Wechsel in den Plan-Modus — die lässt sich nicht streichen, ohne die Kette zu brechen, weil `plan-review` auf dem zuletzt erstellten Plan und `plan-execute` auf dem über `ExitPlanMode` freigegebenen arbeitet. Zurückgenommen wird stattdessen am Plan, über die stabile Kennung je Learning.
- **`session-learn` belegt die Plandatei** und ersetzt damit den aktuellen Plan-Kontext — schließe laufende Aufgaben erst ab, bevor du es startest.
- **`session-learn` schreibt ausschließlich projektlokal** (Projekt-`CLAUDE.md`, `references/`, Repo) — nie in user-globale Ablagen.
- **`session-handoff` schreibt die Datei ungefragt** — der Aufruf ist die Freigabe. Anders als sonst in dieser Suite holt er keine Bestätigung ein: Eine Rückfrage kostet genau den Zug, für den der Kontext nicht mehr reicht. Er nennt dafür den Rückweg, wenn er die Datei neu angelegt oder überschrieben hat, und sichert eine untrackte Datei vorher als `.bak`.
- **`session-handoff` schreibt genau eine Datei** und hört dort auf — er setzt die Arbeit nicht fort, auch nicht auf Bitte. Die Datei ist die Übergabe; im neuen Fenster nimmt `/cmd:session-resume` sie auf. Das Fenster öffnest du selbst: Der Skill tut nach der Datei nichts mehr.
- **`session-handoff` braucht eine Session mit Inhalt.** Ohne Gesprächsverlauf schreibt er keine Datei, sondern sagt das, **auch wenn `git status` und `git log` etwas hergeben**: Der Verlauf ist die Bedingung, der Projektzustand nur das Belegmittel. Konkret heißt das: Ziel und offene Punkte ließen sich nur aus dem Dateistand zurückraten, und eine Übergabe, die vollständig aussieht und es nicht ist, ist schlechter als keine.
- **Der Abschnitt „Unsicher" ist der Punkt des Skills**, nicht Beiwerk. Der Skill läuft genau dann, wenn sein eigener Verlauf schon gekürzt ist — er verdichtet also ein Bild, das er nur teilweise sieht. Was er nicht belegen kann, landet dort samt Quelle und Prüfweg, statt weggelassen oder glattgeschrieben zu werden. Ein fehlender Abschnitt behauptet, es sei nichts unsicher gewesen.
- **`session-resume` löscht auf eine einzelne Ja-Nein-Frage hin** — darin unterscheidet er sich von `project-settings`, das ebenfalls entfernt, aber eine an fester Marke erkannte Altlast im Rahmen seiner Gesamtvorschau. Hier geht es um genau eine Datei, die Übergabe, die der Skill selbst als solche erkannt hat, und nur nach deiner ausdrücklichen Bestätigung. Er nennt vorher den Rückweg je nach git-Lage; ohne Antwort bleibt die Datei liegen und steht als offener Punkt im Bericht. Danach arbeitet er nicht weiter: Die Übergabe ist angenommen, nicht abgearbeitet.
- **`session-resume` prüft, statt zu glauben.** Er hält die Datei gegen den beobachteten Projektstand, benennt Abweichungen und greift jeden Punkt aus „Unsicher" einzeln auf. Fehlt dieser Abschnitt, ist auch das ein Befund — sein Fehlen behauptet, es sei nichts unsicher gewesen.
- **Ein Skill je Session, besonders bei der `project-*`-Kette.** Installiert kosten die Skills nichts: Ein Sessionstart mit dem Plugin und einer ohne unterscheiden sich um 0 Tokens. Teuer ist nicht der Skilltext, sondern was ein Lauf an Arbeit auslöst, und beides bleibt bis zum Sessionende im Fenster. Gemessen an einer realen Sitzung: ein `plan-grill`-Lauf rund 77.000 Tokens, davon 2.500 Skilltext; über drei Skill-Aufrufe hinweg stammten 83 Prozent der Belastung aus Tool-Aufrufen und ihren Ergebnissen und 5 Prozent aus den Skilltexten. Wer die vier `project-*`-Schritte hintereinander in derselben Sitzung fährt, trägt sie alle gleichzeitig. Nimm einen Schritt je Session, dann kostet dich nur der, den du gerade brauchst. Die Messungen dahinter stehen in [`DESIGN.md`](../DESIGN.md) unter „Kontextlast der Skills".

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
    │   └── references/                     # acht Disziplin-Kataloge plus Token-Effizienz-Pass
    ├── project-settings/
    │   ├── SKILL.md
    │   └── references/permission-kanon.md  # die zu setzenden Werte samt Belegen
    ├── project-setup/SKILL.md
    ├── project-structure/
    │   ├── SKILL.md
    │   └── references/                     # Ablage-Kanon und Artefakt-Kanon samt Belegen
    ├── session-handoff/SKILL.md
    ├── session-learn/SKILL.md
    └── session-resume/SKILL.md
```

Skills werden automatisch aus `skills/` entdeckt; der **Aufrufname folgt dem Ordnernamen** (`plan-execute` → `/cmd:plan-execute`). Details zu Namespace, Umbenennen und Entwicklungs-Loop stehen in [`DESIGN.md`](../DESIGN.md).
