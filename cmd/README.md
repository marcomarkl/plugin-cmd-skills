# cmd — Planungs-Toolkit für Claude Code

Zwölf Skills in drei Familien: Planen (klären, reviewen, umsetzen), Projekt einrichten (lotsen, Settings, Ablage, prüfen, härten, kuratieren) und Session (lernen, übergeben, wiederaufnehmen). Der Plugin-Name `cmd` (aus `.claude-plugin/plugin.json`) bildet den Namespace, deshalb beginnt jeder Aufruf mit `/cmd:`.

Installation und Überblick stehen im [Root-README](../README.md); die Entwurfsnotizen (Stellschrauben, verworfene Ansätze) in [`DESIGN.md`](../DESIGN.md).

> Die Skills sind **deutschsprachige Prompts** — sie steuern Claude auf Deutsch.

## Die Skills — und wann du welchen nimmst

| Aufruf | Was er tut | Wann |
|---|---|---|
| `/cmd:plan-grill [vorhaben]` | Interviewt dich zu einem Vorhaben, löst die Entscheidungen einzeln in Abhängigkeits- und Tragweitenreihenfolge auf, protokolliert sie revidierbar und legt sie nach deiner Bestätigung als Plan an. | **Am Anfang**, wenn das Vorhaben noch unscharf ist. |
| `/cmd:plan-review [fokus]` | Reviewt den zuletzt erstellten Plan in rotierenden Blickwinkeln und arbeitet die belastbaren Befunde direkt ein. | Sobald ein Plan steht — von `plan-grill` oder `/plan` —, bevor du freigibst. |
| `/cmd:plan-execute [hinweis]` | Setzt den freigegebenen Plan vollständig um und verifiziert jeden Schritt gegen ein beobachtbares Kriterium; hält bei einem Fund außerhalb des Plans oder einer Klassifikator-Blockade an und fragt nach. | **Nach** dem Verlassen des Plan-Modus. |
| `/cmd:project-setup` | Erhebt vier Fakten am Projekt und gibt die geordnete Aufrufliste der fünf Einrichtungs-Skills aus, je Schritt mit Argument, Vorbedingung und Abnahmekriterium. Richtet selbst nichts ein. | **Zuerst**, bevor du die fünf einrichtenden `project-`Skills fährst. |
| `/cmd:project-settings` | Setzt die `.claude/settings.json` auf einen festen Kanon, entdoppelt die Permission-Listen und legt den Zeitanker-Hook. | **Einmal** beim Einrichten eines Projekts, danach bei Bedarf erneut. |
| `/cmd:project-structure [fokus oder pfad]` | Bringt die Ablage auf einen belegten Kanon, sammelt Streudateien ein und schlägt projekteigene Skills, Subagents und `paths:`-Regeln vor, Subagents entlang eines Delegations-Maßstabs. Verschiebt nur mit Verlagerungs-Register und Verlustnachweis. | Wenn die `CLAUDE.md` zuwächst oder Wissen verstreut liegt. |
| `/cmd:project-audit [fokus oder pfad]` | Prüft den projekteigenen Prompttext gegen die vier Prompting-Leitfäden — Verifikations-Scaffolding, wiederholte Selbstprüfung, Formatierungsverbote, Denk-Wiedergabe, Narrations-Unterdrückung — und legt die Befunde als Plan zur Entfernung vor. Schreibt an keinen Zielort. | Vor `project-rules`, und der Weg für ein Projekt, das früher schon gehärtet wurde. |
| `/cmd:project-rules [pfad]` | Härtet eine bestehende `CLAUDE.md`/`AGENTS.md` mit zehn Disziplin-Katalogen. Verdichtet selbst nicht — das ist der Lauf von `project-curate` danach. | Eigenständig, wenn die Projektregeln Pflege brauchen. |
| `/cmd:project-curate [pfad]` | Kuratiert die fertig gehärtete Datei ohne Bedeutungsverlust: Floskeln und Redundanz raus, Format nach Inhalt, Wichtiges nach oben, auslagerungsreife Blöcke markieren. Schwächt keine Regel und verschiebt nichts. | Direkt nach `project-rules`; verdichten geht erst, wenn aller Inhalt steht. |
| `/cmd:session-learn [fokus]` | Reflektiert die laufende Session, leitet dauerhafte Learnings ab, legt sie als Plan an und verweist auf `/cmd:plan-review` und `/cmd:plan-execute`, die du selbst aufrufst. | Am **Ende** einer Session. |
| `/cmd:session-handoff [fokus]` | Verdichtet den laufenden Arbeitsstand in eine kurze `HANDOFF.md`, damit ein frisches Fenster ohne den bisherigen Verlauf weiterarbeiten kann. | Wenn das **Kontextfenster knapp** wird. |
| `/cmd:session-resume [pfad]` | Nimmt die Übergabedatei im frischen Fenster auf, prüft ihren Stand gegen das Projekt, legt den nächsten Schritt vor und räumt die Datei nach deiner Bestätigung weg. | **Im neuen Fenster**, direkt nach einem Handoff. |

Alle zwölf sind `disable-model-invocation: true` — sie laden **nur auf deinen Aufruf hin**, nie automatisch. Das ist Absicht: es sind timing-kontrollierte Workflows.

Keiner setzt ein Modell oder eine Denktiefe: Sie laufen mit der Einstellung deiner Session. Willst du für einen Lauf mehr Tiefe — `plan-review`, `project-rules` und `project-audit` sind die aufwendigsten —, heb den Effort der Session, statt im Skill zu suchen.

**grill und review teilen sich den Plan nach Gegenstand**, nicht nach Reihenfolge: grill klärt die **Entscheidungen** und legt sie als Plan an, review prüft den **fertigen Plan** in Runden und härtet ihn. Beide schreiben in dieselbe Plandatei, und beide machen ihr Ergebnis über **stabile Kennungen** zurücknehmbar (grill „nimm Entscheidung 3 zurück“, review „nimm Änderung 2.3 zurück“).

## Pipeline

Die drei plan-Skills bilden eine Kette um den Plan-Modus, jede Naht mit einem klaren Vertrag:

```
plan-grill        →  plan-review  →  ExitPlanMode  →  plan-execute
 (klärt und baut)    (härtet)                         (setzt um)
```

- **grill → review:** grill interviewt, gibt die Schlussnotiz aus und legt **nach deiner Bestätigung** den Plan an — mit Context, ausgeformten Vorgaben, dem Entscheidungs-Ledger und den im Interview erhobenen Belegen. Ist der Plan-Modus nicht aktiv, bietet er vorher `EnterPlanMode` an; ein Plan außerhalb des Plan-Modus wäre für review und execute nicht dasselbe Artefakt. **`/plan` ist damit kein Pflichtglied mehr** — nutze es, wenn du ohne Interview direkt planen willst.
- **grill/plan → review:** review arbeitet auf dem existierenden Plan und härtet ihn in Runden; das Ergebnis ersetzt den Plan. **Stammt der Plan nicht aus `plan-grill`** (aus `/plan` oder direkt geschrieben), endet der Plan-Modus davor mit seiner Freigabefrage: Die lehnst du ab und rufst `plan-review` auf; freigegeben wird erst vor `plan-execute`. `plan-grill` selbst stellt diese Frage nicht, bei jedem anderen Plan ist der Handgriff Harness-Verhalten und nicht abschaltbar.
- **review → execute:** execute setzt den **freigegebenen** Plan um. **Vertrag:** execute erwartet, dass der Plan **pro Schritt ein beobachtbares Verifikationskriterium** trägt. Fehlt eins, leitet execute das schwächste hinreichende selbst ab.

Jeder Skill ist einzeln nutzbar; die Kette ist die Kür, nicht die Pflicht.

`session-learn` steht **quer** zu dieser Kette: es reflektiert eine ganze Session und erzeugt selbst einen Plan — aber über die *Arbeitsweise* (Learnings für künftige Sessions), nicht über eine Aufgabe. Weil der Plan damit schon existiert, tritt es bei `plan-review` in die Kette ein, nicht bei `/plan`.

`session-handoff` steht **quer zur Zeitachse**: Es unterbricht die Kette an beliebiger Stelle — typischerweise mitten in `plan-execute`, dem einzigen langlaufenden Skill — und reicht den Stand an ein frisches Fenster weiter, wo `session-resume` ihn aufnimmt und die Kette dort fortsetzt, wo sie abbrach.

**Zwei der drei `session-*`-Skills teilen sich die Session nach Haltbarkeit**, und danach wählst du: `session-learn` nimmt das **Dauerhafte** (Learnings, die künftige Sessions besser machen) und legt es projektlokal ab; `session-handoff` nimmt das **Flüchtige** (wo die Arbeit gerade steht) und gibt es ans nächste Fenster. Am Sessionende sinnvoll beides, in dieser Reihenfolge — `session-learn` belegt die Plandatei, auf die `session-handoff` danach nur noch verweisen muss. `session-resume` teilt dagegen nichts: Es ist das **zeitliche Gegenstück** zu `session-handoff`, derselbe Stand eine Sitzung später und in die andere Richtung.

Die `project-*`-Skills stehen **vor** der Kette und sind keine Pipeline-Glieder: **fünf** bilden die Einrichtungsreihe, ein **sechster** lotst nur durch sie. Unter den einrichtenden gilt eine Reihenfolge, und zwar aus je eigenem Grund:

```
project-setup  ⇢  project-settings  →  project-structure  →  project-audit  →  project-rules  →  project-curate
 (lotst, führt      (Settings, holt      (Ablage, lagert      (prüft den        (härtet)        (verdichtet)
  nichts aus)        Auto-Memory rein)     Inhalt aus)          Prompttext)
```

`project-setup` steht davor, ist aber **kein Glied**: Es erhebt vier Fakten am Projekt und gibt die Reihe als Liste aus, mit dem Argument je Aufruf, der Vorbedingung und dem Abnahmekriterium. Ausgeführt wird nichts, deshalb der gestrichelte Pfeil. Aufrufen musst du sie weiterhin selbst, und genau das ist Absicht: Ihre Sperre `disable-model-invocation` hält Claude von ihnen fern, und sie aufzuheben, um eine Verkettung zu ermöglichen, öffnete ausgerechnet die schreibenden Skills fürs automatische Laden.

Settings vor rules, weil `project-settings` vorhandene Auto-Memory-Einträge in die `CLAUDE.md` holt. Umgekehrt härtete `project-rules` einen Stand, dem der Import erst danach wieder Rohtext anhängt.

Structure vor rules, weil `project-structure` Inhalt auslagert und den Wegweiser-Abschnitt `## Ablage` schreibt. `project-rules` härtet die Datei danach, auch diesen Abschnitt; verdichtet wird sie erst von `project-curate`.

Audit vor rules, weil `project-rules` keine vorhandene Regel schwächen darf. Was ein früherer Lauf geschrieben hat, verbucht es als `bereits vorhanden`, und veralteter Text bliebe stehen. `project-audit` legt ihn vorher zur Entfernung vor.

Curate nach rules ist keine vierte Abhängigkeit, sondern dieselbe von der anderen Seite: Verdichten geht erst, wenn aller Inhalt steht.

Zur Rückkopplung: Findet `project-rules` auslagerungsreife Blöcke, verschiebt es sie nicht selbst, sondern markiert sie und empfiehlt einen Lauf von `project-structure`. Die Trennung ist Absicht: `project-rules` lebt von *einem* kohärenten Schreibvorgang an *einer* Datei, ein Umzug über viele Dateien braucht Rückweg und Verlustnachweis je Datei.

Zu `session-learn` ist das Verhältnis komplementär: `project-settings` schaltet das Memory-System ab und leert es einmalig, `session-learn` hat es ohnehin nie genutzt.

Die Präfixe ordnen die Skills: `plan-*` wirken am Plan-Lebenszyklus, `project-*` am Projekt als Ganzem (an seinen Artefakten `CLAUDE.md`, `.claude/settings.json` und Ablage, oder wie `project-setup` am Weg dorthin), `session-*` an der Arbeitssession selbst.

## Referenz je Skill

Je Skill dieselben sieben Angaben in derselben Reihenfolge. Wie eine fertige Ausgabe aussieht, steht nicht hier: Sechs Skills führen ein vollständiges Beispiel in ihrem `references/beispiel.md`, und die Form der mehrturnigen Abläufe zeigt [`examples/transcripts.md`](../examples/transcripts.md). Die Einordnung in die Ketten steht oben unter „Pipeline“: `plan-*` wirkt am Plan-Lebenszyklus, `project-*` am Projekt, `session-*` an der Arbeitssession. Das Feld „Vorbedingung“ nennt die Reihenfolge je Skill konkret.

### /cmd:plan-grill

- Aufruf: `/cmd:plan-grill` · `/cmd:plan-grill Umstellung des Imports auf Webhooks`
- Argument: das Vorhaben, ein bestehender Plan oder eine einzelne Entscheidung. Leer bestimmt der Skill den Gegenstand aus dem Gespräch; ist er unklar, ist das seine erste Frage.
- Vorbedingung: keine.
- Fasst an: während des Interviews nichts. Danach genau eine Datei, den Plan.
- Freigabe: zwei. Erst bestätigst du die Schlussnotiz, dann den Wechsel in den Plan-Modus, falls er nicht aktiv ist. `ExitPlanMode` ruft der Skill nicht auf; die Freigabe des Plans kommt erst vor `plan-execute`.
- Ergebnis: eine Plandatei mit Context, ausgeformten Vorgaben, Entscheidungs-Ledger und den im Faktenvorlauf erhobenen Belegen, dazu die Schlussnotiz im Chat. Über die Kennung im Ledger nimmst du einzelne Entscheidungen später zurück.
- Randfälle: keine besonderen.

### /cmd:plan-review

- Aufruf: `/cmd:plan-review` · `/cmd:plan-review Reversibilität und Rückweg`
- Argument: ein Zusatzfokus, der in den Blickwinkel-Pool aufgenommen wird. Leer stellt der Skill den Pool selbst aus der Aufgabe auf.
- Vorbedingung: ein Plan existiert, aus `plan-grill`, aus `/plan` oder selbst geschrieben.
- Fasst an: den Plan. Quell- und Projektdateien bleiben unberührt.
- Freigabe: keine. Der Skill läuft in Runden, bis die Blickwinkel erschöpft sind.
- Ergebnis: der überarbeitete Plan ersetzt den alten, dazu eine Schlussnotiz mit den genutzten Blickwinkeln, dem Ledger der eingearbeiteten Befunde und den verworfenen samt Begründung.
- Randfälle: Stammt der Plan nicht aus `plan-grill`, stellt der Plan-Modus vorher seine Freigabefrage. Die lehnst du ab und rufst den Skill auf; freigegeben wird erst vor `plan-execute`.

### /cmd:plan-execute

- Aufruf: `/cmd:plan-execute` · `/cmd:plan-execute zuerst die Migration, dann die Tests`
- Argument: ein Hinweis zur Ausführung. Leer arbeitet der Skill allein nach dem Plan.
- Vorbedingung: ein über `ExitPlanMode` freigegebener Plan. Auto mode ist der Zielmodus, aber keine Bedingung; ohne ihn kommen Permission-Prompts.
- Fasst an: was der Plan vorsieht.
- Freigabe: der Skill hält an und fragt, wenn er einen substanziellen Fund außerhalb des Plans macht oder der Sicherheitsklassifikator eine Aktion blockiert. Abweichungen innerhalb eines Planschritts korrigiert er selbst.
- Ergebnis: der umgesetzte Plan, dazu ein Abschlussbericht mit dem Verifikationskriterium je Schritt, den Abweichungen samt Ursache und etwaigen offenen Blockern. Committet wird nicht ungefragt.
- Randfälle: keine besonderen.

### /cmd:project-setup

- Aufruf: `/cmd:project-setup`
- Argument: keines. Der Skill nimmt keins an.
- Vorbedingung: keine. Er läuft im leeren Ordner und ohne Repo.
- Fasst an: nichts. Er ist strikt lesend und führt auch keinen der Skills aus, die er nennt.
- Freigabe: keine.
- Ergebnis: die geordnete Aufrufliste der fünf Einrichtungs-Skills als Chat-Notiz, je Schritt mit Aufruf, Vorbedingung, angefasstem Bereich und Abnahmekriterium. Jedes Kriterium ist gekennzeichnet, ob es am Projekt oder nur im Bericht des Laufs ablesbar ist.
- Randfälle: Im Unterordner eines bestehenden Repos legt er beide Deutungen offen, statt eine zu wählen. Ohne Repo ist der Projekt-Root das Startverzeichnis. Existieren `CLAUDE.md` und `AGENTS.md` beide als echte Dateien, gibt er den Konflikt weiter, statt das Argument zu setzen. Im leeren Ordner sagt er, dass das Projektprofil von dir kommen muss.

### /cmd:project-settings

- Aufruf: `/cmd:project-settings`
- Argument: keines. Der Kanon steht fest.
- Vorbedingung: keine. Er läuft ohne Repo und im leeren Ordner.
- Fasst an: `.claude/settings.json`. Trägt das Projekt Altlasten früherer Läufe, dazu `.gitignore` und `.claude/skills/`, und zum Reinholen der Auto-Memory-Einträge das Memory-Verzeichnis. Die Nutzer-Settings bleiben unberührt.
- Freigabe: eine, gesammelt. Alle Änderungen stehen in einer Vorschau, mit dem Rückweg je Datei: `git restore` bei getrackten, eine `.bak`-Kopie bei untrackten. Den Zeitanker-Hook weist der Skill darin eigens aus, weil ein Hook etwas tut und eine Permission-Regel nur etwas erlaubt. Er gibt jedem Turn die Systemzeit, weil Claude Code von sich aus nur das Datum liefert und es beim Sessionstart festschreibt; ohne Uhr sieht ein Messwert aus einem früheren Turn so frisch aus wie beim Erheben.
- Ergebnis: die geschriebene Datei und ein Bericht. Am Projekt ablesbar ist `autoMemoryEnabled: false`; das ist eine Stichprobe, nicht der ganze Kanon. Ein zweiter Lauf ohne zwischenzeitliche Änderung erzeugt keinen Diff.
- Randfälle: Ohne Repo entfällt der `.gitignore`-Teil der Altlast-Räumung. Legt der Lauf die `settings.json` neu an, greift der Zeitanker voraussichtlich erst nach `/hooks` oder in einer neuen Session. Nicht parsebares JSON ist ein Abbruchgrund, dann überschreibt er nichts. Die `allow`-Regeln wirken erst nach dem Workspace-Trust-Dialog, `deny` und `ask` sofort.

### /cmd:project-structure

- Aufruf: `/cmd:project-structure` · `/cmd:project-structure nur Entscheidungen` · `/cmd:project-structure docs/`
- Argument: ein Fokus oder ein Pfad, auf den die Inventur eingegrenzt wird. Leer nimmt er das ganze Projekt.
- Vorbedingung: keine gegenüber `project-settings`; die beiden sind unabhängig.
- Fasst an: die Ablage. Er verschiebt Bestand, benennt nach Zustimmung um, legt fehlende Orte an und schreibt einen Abschnitt in die maßgebliche Regeldatei, den Wegweiser unter `## Ablage`. Den Rest der Datei lässt er unberührt. Vorhandenes erkennt er, bevor er anlegt: Ein genutzter Issue-Tracker verhindert `backlog/`, ein vorhandenes `docs/adr/` ein zweites `docs/decisions/`, ein generiertes `docs/` jede Ablage darin.
- Freigabe: eine, gesammelt, über alles. Schreiben unter `.claude/` verlangt zusätzlich eine eigene interaktive Bestätigung, weil der Pfad geschützt ist und eine vorab erteilte Freigabe dort nicht greift. Tool-gebundene Orte wie `backlog/` legt er nur mit ausdrücklicher Zustimmung an.
- Ergebnis: die bewegten Dateien und ein Bericht, der mit einer Zeilenbilanz schließt. Geht sie nicht auf, meldet er das als Fehler. Verschieben läuft per `git mv`, die Historie bleibt erhalten.
- Randfälle: Ein Subagent-Vorschlag endet auf zwei Wegen verschieden. Bildet der Skill den Anlass aus Anhaltspunkten im Projekt, legt er ihn zur Bestätigung vor; bestätigst du ihn nicht, entsteht kein Vorschlag und es bleibt nichts offen. Eine verweigerte Schreibfreigabe dagegen lässt den Vorschlag als offenen Punkt im Bericht stehen, und die Quelle bleibt an ihrem Platz. Ohne Repo entfällt `git mv`, jede Quelle wird vorher als `.bak` gesichert, und der Skill sagt, dass der Umzug dort schlechter umkehrbar ist. Im leeren Ordner legt er die `CLAUDE.md` mit nichts als dem Wegweiser an, Rückweg `rm`. Existiert nur eine `AGENTS.md`, trägt sie den Wegweiser. Ist ein Zielname vergeben, nimmt er die nächste freie Nummer; liegt am Zielpfad eine Datei statt eines Verzeichnisses, geht der Konflikt in den Bericht.

### /cmd:project-audit

- Aufruf: `/cmd:project-audit` · `/cmd:project-audit nur die Skills` · `/cmd:project-audit .claude/rules/`
- Argument: ein Fokus oder ein Pfad. Leer prüft er den ganzen projekteigenen Prompttext.
- Vorbedingung: vorhandener Prompttext. In der Kette steht er vor `project-rules`, weil dieses keine vorhandene Regel schwächen darf.
- Fasst an: nichts. Er liest die Regeldatei samt verschachtelten, die projekteigenen Skills mit ihren `references/`, Agents, Regeln und `.claude/settings.json`, letztere nur lesend.
- Freigabe: eine, der Wechsel in den Plan-Modus. Die Befunde bestätigst du nicht vorab; die Kontrolle liegt am Plan.
- Ergebnis: ein Plan mit stabiler Kennung je Befund, dazu eine Schlussnotiz mit dem geprüften Bestand, den verworfenen Kandidaten und den Beobachtungen ohne Klasse. Angewendet wird er über `plan-review` und `plan-execute`.
- Randfälle: Gibt es weder Regeldatei noch `.claude/`, sagt er das und erzeugt keinen Plan. Übersteht kein Befund seine eigene Prüfung, bleibt er ehrlich leer. Ist die `CLAUDE.md` ein Symlink oder eine Import-Hülle, ist `AGENTS.md` der Gegenstand. Befunde außerhalb des Projekts, etwa in der nutzerweiten `CLAUDE.md`, nennt er als Beobachtung, ohne sie in den Plan zu nehmen.

### /cmd:project-rules

- Aufruf: `/cmd:project-rules` · `/cmd:project-rules AGENTS.md` · `/cmd:project-rules ~/.claude/CLAUDE.md`
- Argument: der Pfad zur Zieldatei. Leer bestimmt der Skill die maßgebliche Datei und fragt, wenn sie nicht eindeutig ist. Die dritte Form zeigt, dass auch die nutzerweite Regeldatei ein zulässiges Ziel ist, wenn die Regeln über alle Projekte gelten sollen.
- Vorbedingung: keine harte. Der Skill läuft eigenständig. Empfohlen ist der Lauf nach `project-structure`, weil dann der Wegweiser `## Ablage` existiert und mitgehärtet wird; das ist ein Reihenfolge-Hinweis, keine Sperre.
- Fasst an: genau diese eine Datei. Er verschiebt nichts und legt nichts an.
- Freigabe: das Projektprofil bestätigst du vorab, die Zieldatei nur, wenn sie nicht eindeutig ist. Alle Konflikte kommen gesammelt in einer Entscheidungsrunde; ohne Antwort übernimmt er die strengere Fassung und vermerkt das.
- Ergebnis: die gehärtete Datei und ein Änderungsprotokoll im Chat. Am Projekt gibt es kein Kriterium, weil der Skill keine Marke hinterlässt; das schwächste hinreichende ist das Abdeckungs-Register in seiner Ausgabe.
- Randfälle: Existiert keine Regeldatei, bietet er an, eine aus den Katalogen zu erzeugen. Liegen `CLAUDE.md` und `AGENTS.md` beide als echte Dateien, benennt er das Drift-Risiko und härtet nur die maßgebliche. Auslagerungsreife Blöcke markiert er und empfiehlt `project-structure`, höchstens einmal.

### /cmd:project-curate

- Aufruf: `/cmd:project-curate` · `/cmd:project-curate AGENTS.md`
- Argument: der Pfad zur Zieldatei. Leer bestimmt der Skill sie wie `project-rules` und fragt bei Mehrdeutigkeit.
- Vorbedingung: eine Regeldatei, deren Inhalt steht. Verdichten geht erst, wenn aller Inhalt steht, deshalb der Lauf nach `project-rules`. Eine Sperre ist das nicht: Lief `project-rules` nicht in derselben Sitzung, liest der Skill die Nichtkürzbarkeits-Marken selbst aus den Katalogen.
- Fasst an: dieselbe Datei, nur verdichtend. Er verschiebt nichts und legt nichts an.
- Freigabe: keine für die Änderungen selbst. Ist die Zieldatei nicht eindeutig, fragt er einmal danach. Gesichert wird sie vor dem Ändern, über den Git-Stand oder eine `.bak`-Kopie, wenn sie untrackt ist.
- Ergebnis: die kuratierte Datei und ein Verdichtungsprotokoll, das mit einer Maß-Zeile beginnt: Zeilen und Zeichen vorher und nachher. Geht die Datei nicht zurück, steht das so da.
- Randfälle: keine besonderen. Kommt er an die Nichtkürzbarkeits-Marken nicht heran, verdichtet er die betroffenen Abschnitte nicht und sagt im Bericht, welchen Weg er genommen hat.

### /cmd:session-learn

- Aufruf: `/cmd:session-learn` · `/cmd:session-learn nur die Fehlgriffe`
- Argument: ein Fokus für die Retrospektive. Leer wertet er die ganze Session aus.
- Vorbedingung: eine Session mit Verlauf. Schließe laufende Aufgaben vorher ab, denn der Skill belegt die Plandatei.
- Fasst an: nichts an den Zielorten. Geschrieben wird allein der Plan.
- Freigabe: eine, der Wechsel in den Plan-Modus. Die Learnings bestätigst du nicht vorab; zurückgenommen wird am Plan über die Kennung je Learning.
- Ergebnis: ein Plan mit Ziel-Ort, Beleg und Maßnahme je Learning, dazu eine Schlussnotiz mit den verworfenen Kandidaten. Angewendet wird er über `plan-review` und `plan-execute`.
- Randfälle: Übersteht kein Kandidat den Filter, erzeugt er keinen Plan. Gibt es im Projekt noch keinen Ort für solches Wissen, schlägt er einen vor, statt auf ein user-globales Ziel auszuweichen. Ein Learning ohne Projektbezug vermerkt er als außerhalb des Scopes.

### /cmd:session-handoff

- Aufruf: `/cmd:session-handoff` · `/cmd:session-handoff Schwerpunkt auf die offene Migration`
- Argument: ein Fokus für die Übergabe. Leer verdichtet er den ganzen Stand.
- Vorbedingung: eine Session mit Inhalt. Der Gesprächsverlauf ist die Bedingung, der Projektzustand nur das Belegmittel.
- Fasst an: die Übergabedatei. Ist sie untrackt, schreibt er vorher deren `.bak`-Kopie.
- Freigabe: keine. Der Aufruf ist die Freigabe, weil eine Rückfrage genau den Zug kostet, für den der Kontext nicht mehr reicht.
- Ergebnis: eine Übergabedatei von höchstens 60 Zeilen, die für sich steht, dazu eine Schlussnotiz mit ihrem Pfad und dem nächsten Schritt. Ihr Abschnitt „Unsicher“ ist der Punkt des Skills und nicht Beiwerk: Er läuft, wenn sein eigener Verlauf schon gekürzt ist, verdichtet also ein Bild, das er nur teilweise sieht. Was er nicht belegen kann, landet dort samt Quelle und Prüfweg. Den Rückweg nennt er, wenn er die Datei neu angelegt oder überschrieben hat.
- Randfälle: Ohne tragfähigen Stand schreibt er keine Datei. Fehlt der Verlauf, gilt das auch dann, wenn `git status` und `git log` etwas hergeben. Eine vorhandene Übergabedatei patcht er, statt eine zweite anzulegen. Nach der Datei arbeitet er nicht weiter.

### /cmd:session-resume

- Aufruf: `/cmd:session-resume` · `/cmd:session-resume docs/HANDOFF.md`
- Argument: der Pfad zur Übergabedatei. Er überschreibt die Suche. Leer sucht der Skill im Projektroot, am Ort des Ablage-Wegweisers und in einem vorhandenen Doku-Verzeichnis.
- Vorbedingung: eine Übergabedatei aus einer früheren Session.
- Fasst an: zunächst nichts, er liest und prüft. Gelöscht wird die Übergabedatei nur nach ausdrücklicher Bestätigung, mit einem einzelnen `rm` auf genau den genannten Pfad.
- Freigabe: eine, die Löschfrage am Ende. Ohne Antwort bleibt die Datei liegen und steht als offener Punkt.
- Ergebnis: eine Arbeitsliste als Chat-Notiz, mit dem ersten Schritt konkret ausformuliert, dem Alter der Übergabe und jeder Abweichung zwischen Datei und Projektzustand. Den Abschnitt „Unsicher“ greift er Punkt für Punkt auf.
- Randfälle: Findet er keine Übergabedatei, sagt er das und endet, statt eine aus git zu rekonstruieren. Bei mehreren Kandidaten nennt er alle mit Pfad und Datum und wählt keinen. Dateien auf `.bak` sind keine Kandidaten. Verweist die Übergabe auf eine Plandatei, liest er den Plan und schlägt `plan-execute` vor.

## Für welches Modell das gebaut ist

Das Plugin ist für **Claude Opus 5** optimiert und läuft **mit Einschränkungen auf Fable 5.1 und Fable 5**.

Der Grund liegt im Abgleich mit den Prompting-Leitfäden, den Version 0.24.0 vorgenommen hat. Die vier Leitfäden widersprechen sich an vier Punkten, und Opus 5 entscheidet sie, weil es der Claude-Code-Default ist. Genau diese vier Punkte sind die Einschränkungen:

| Punkt | Auf Opus 5 | Auf Fable 5 und 5.1 |
|---|---|---|
| Verifikation | Die Kataloge haben Verifikationsanweisungen verloren, weil Opus 5 von selbst verifiziert und solche Anweisungen Über-Verifikation erzeugen | Fable will für lange Läufe ausdrückliche Selbstverifikation. Die fehlt hier; wer lange autonome Läufe fährt, ergänzt sie im Projekt selbst |
| Fortschrittstext | Eine Kadenz statt eines Verbots, weil Opus 5 von selbst viel narriert | Fable schreibt eher zu wenig. Die Kadenz ist positiv formuliert und trägt deshalb auch dort, dämpft aber nichts, was gedämpft werden müsste |
| Subagenten | Der Delegations-Maßstab begrenzt, weil Opus 5 bereitwillig delegiert | Fable soll häufig delegieren. Der Maßstab bremst dort, wo der Leitfaden Tempo will |
| Ausführlichkeit | Längenkalibrierung statt Formatierungsverboten | Fable schreibt dichter. Die Bitte um Kürze kann dort übersteuern |

Für Sonnet, Haiku und ältere Modelle gibt es **keine Messung**, deshalb auch keine Empfehlung, in keine Richtung. Was sich ohne Messung sagen lässt: Die Läufe sind lang und mehrschrittig, in der Eval-Suite acht bis 26 Turns je Fall, und sie hängen an Instruktionstreue über viele Turns sowie an Registern und Bilanzen als Korrektheitsmechanismus. Wer ein kleineres Modell einsetzt, prüft das am eigenen Fall.

Was gemessen ist: Alle Eval-Läufe dieses Plugins liefen auf Claude Opus 5 gegen Claude Code 2.1.276 und 2.1.277. Kein Skill setzt `model` oder `effort` im Frontmatter, sie laufen mit der Einstellung deiner Session. Die Modellwahl bleibt damit deine Entscheidung und nicht die des Plugins.

Ein Teil der Katalogregeln ist auf Opus 5 in Claude Code redundant, weil dessen Systemprompt mehrere Leitfaden-Blöcke bereits nahezu wortgleich trägt. Sie stehen trotzdem in den Katalogen, denn die schreiben in fremde Regeldateien, auch für Werkzeuge ohne diesen Harness. Der Befund samt Vorbehalt steht in [`DESIGN.md`](../DESIGN.md).

## Voraussetzungen für `plan-execute`

Zielmodus für die Umsetzung ist **Auto mode**. Der Skill kann den Modus **nicht selbst setzen** — er muss vorher aktiv sein. Ohne Auto mode läuft er ebenfalls, dann mit Permission-Prompts statt automatischer Freigabe.

Auto mode aktivieren (einmaliges Opt-in):

1. Verfügbarkeit prüfen über den Shift+Tab-Zyklus oder `/status`. Erscheint Auto mode nicht, ist eine Voraussetzung nicht erfüllt (Version, Modell oder Owner-Freigabe bei Team/Enterprise).
2. `claude --enable-auto-mode`, dann per Shift+Tab auf Auto mode wechseln.
3. Dauerhaft: `permissions.defaultMode: "auto"` **nur** in `~/.claude/settings.json` (projektbezogene Settings werden für diesen Wert ignoriert).

> **Auto mode ist ein Research Preview ohne Sicherheitsgarantie** — nur in isolierter Umgebung nutzen.

## Voraussetzung für die Skills mit `references/`

Acht Skills laden Referenzdateien nach, sobald sie laufen: `plan-execute` (eine, nur bei einer Klassifikator-Blockade), `plan-grill` und `plan-review` (je ein Ausgabebeispiel), `project-rules` (zehn Kataloge und sechs Arbeitsdateien, dazu die zwei Kanon-Dateien von `project-structure`), `project-audit` (zwei), `project-curate` (zwei, dazu situativ die Kataloge von `project-rules`), `project-settings` (eine) und `project-structure` (drei). Diese 27 Dateien liegen im Plugin-Verzeichnis, also außerhalb deines Projekts, im Normalfall unter `~/.claude/plugins/cache/`. **Lesen außerhalb des Arbeitsverzeichnisses braucht eine Freigabe.** Gemessen am 12. September 2026 gegen Claude Code 2.1.269, im Standardmodus, ohne Projekt-Settings: Interaktiv kommt je Datei ein Prompt, headless (`claude -p`) scheitert jeder Zugriff, und der Skill hält an, statt aus dem Gedächtnis zu arbeiten. `project-settings` setzt mit `Read(//**)` genau die Regel, die das deckt; sie wirkt aber erst nach dem Workspace-Trust-Dialog, also nicht im Lauf, der sie gerade schreibt. Rechne beim ersten Lauf im Projekt mit den Prompts, oder nimm sie über den Trust-Dialog vorweg. Im Dev-Loop mit `--plugin-dir` gilt dasselbe; dort hilft `--add-dir` auf das Plugin-Verzeichnis.

## Wenn dein Projekt schon einmal gehärtet wurde

`project-settings` räumt zwei Altlasten dieses Plugins weg, sobald es läuft. In Projekten, die vor 0.10.0 eingerichtet wurden, liegen ein `SessionStart`-Hook und `.claude/skills/session-protocol/SKILL.md`; sie laden bis heute bei jedem Sessionstart, obwohl das Protokoll aus dem Plugin entfernt ist. Dazu kommt seit 0.18.0 der Key `plansDirectory`, aber nur beim exakten Wert `"./plans"`, den ein Lauf bis 0.17.0 gesetzt hat. Beides erkennt der Skill an einer festen Marke, fremde Hooks und abweichende Werte bleiben stehen, und die Entfernung steht in derselben Vorschau wie alles andere. Die `.gitignore`-Zeile geht nur zusammen mit dem Key und nur, wenn `plans/` leer ist; den Ordner selbst fasst er nie an. In einem Projekt ohne diese Spuren passiert nichts.

Zwei Dinge holt ein neuer `project-rules`-Lauf **nicht** nach. Beide sind erwartetes Verhalten, kein Fehler:

- **Was ein früherer Lauf geschrieben hat, bleibt stehen.** Die Best-of-Regel verbucht Vorhandenes als `bereits vorhanden` und schwächt es nie — das schützt deine eigenen Regeln, hält aber auch Text fest, den die Prompting-Leitfäden inzwischen zum Entfernen empfehlen. Frühere Fassungen dieses Plugins haben unter anderem einen Abschnitt `## Vor "fertig" verifizieren`, eine Teilaufgaben-Verifikation und den Satz „Verfeinere das Verständnis, bis kein Raum für Fehldeutung bleibt“ in fremde Regeldateien geschrieben. Dafür ist **`/cmd:project-audit`** da: Es findet diese Stellen im Wortlaut, prüft jede gegen den Beleg und legt sie als Plan zur Entfernung vor. Ein Lauf lohnt sich auch dann, wenn die Datei sonst in Ordnung wirkt.
- **Eine deutsche Paraphrase wird nicht durch das englische Original ersetzt.** Steht in deiner Datei eine eigene Fassung einer Regel, die die Kataloge heute als unübersetzten Originalblock führen, lässt `project-rules` sie stehen. Der Grund ist derselbe: Vorhandenes wird nicht überschrieben. Willst du den gemessenen Wortlaut, entfernst du die Paraphrase selbst und lässt den Lauf die Lücke füllen.

## Ein Skill je Session, besonders in der `project-`Kette

Installiert kosten die Skills nichts: Ein Sessionstart mit dem Plugin und einer ohne unterscheiden sich um 0 Tokens. Teuer ist nicht der Skilltext, sondern was ein Lauf an Arbeit auslöst, und beides bleibt bis zum Sessionende im Fenster. Gemessen an einer realen Sitzung: ein `plan-grill`-Lauf rund 77.000 Tokens, davon 2.500 Skilltext; über drei Skill-Aufrufe hinweg stammten 83 Prozent der Belastung aus Tool-Aufrufen und ihren Ergebnissen und 5 Prozent aus den Skilltexten. Wer die fünf Kettenglieder hintereinander in derselben Sitzung fährt, trägt sie alle gleichzeitig. Nimm einen Schritt je Session, dann kostet dich nur der, den du gerade brauchst. Die Messungen dahinter stehen in [`DESIGN.md`](../DESIGN.md) unter „Kontextlast der Skills“.

## Struktur

```
cmd/
├── .claude-plugin/plugin.json              # Manifest; name "cmd" setzt den Namespace
├── README.md                               # diese Datei
└── skills/
    ├── plan-execute/
    │   ├── SKILL.md
    │   └── references/auto-mode.md         # bedarfsgeladen bei Klassifikator-Blockade
    ├── plan-grill/
    │   ├── SKILL.md
    │   └── references/beispiel.md           # Schlussnotiz als Vorbild
    ├── plan-review/
    │   ├── SKILL.md
    │   └── references/beispiel.md           # Schlussnotiz als Vorbild
    ├── project-audit/
    │   ├── SKILL.md
    │   └── references/                     # Befundklassen mit Originalbelegen, Beispiel
    ├── project-curate/
    │   ├── SKILL.md
    │   └── references/                     # Token-Effizienz-Pass, Beispiel
    ├── project-rules/
    │   ├── SKILL.md
    │   └── references/                     # zehn Disziplin-Kataloge, Registermechanik, Beispiel
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
