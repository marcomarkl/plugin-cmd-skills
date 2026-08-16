# DESIGN — Entwurfsnotizen zum `cmd`-Plugin

Maintainer-Dokumentation: warum die Skills so gebaut sind, welche Stellschrauben es gibt und welche Ansätze geprüft und **verworfen** wurden. Die Nutzungsanleitung steht in [`cmd/README.md`](cmd/README.md), der Einstieg im [Root-README](README.md).

## Namespace, Autoentdeckung, Umbenennen

Skills werden automatisch aus `cmd/skills/` entdeckt; kein Eintrag im Manifest nötig. Der **Aufrufname folgt dem Ordnernamen** (`plan-execute` → `/cmd:plan-execute`); das Frontmatter-`name` ist dabei nur ein Anzeige-Label.

Willst du das Präfix ändern, passe `name` in `cmd/.claude-plugin/plugin.json` an (früher trug jeder Command ein `my-`-Dateipräfix; diese Rolle übernimmt jetzt der Plugin-Namespace) — und trag den alten Namen in die `renames`-Map der `.claude-plugin/marketplace.json` ein, sonst bricht jede bestehende Installation.

## Lokaler Entwicklungs-Loop

Laden/testen: `claude --plugin-dir ./cmd`, nach Änderungen `/reload-plugins`. Manifeste prüfen: `claude plugin validate . --strict` **und** `claude plugin validate ./cmd --strict` — der Root-Aufruf erfasst nur das Marketplace-Manifest, das Plugin-Manifest braucht den zweiten. Verhaltens-Rauchtest: `bash scripts/smoke.sh` — startet echte Modell-Läufe, prüft nur den Eröffnungszug je Skill. Die erwartete Form der vollen Flows steht in [`examples/transcripts.md`](examples/transcripts.md).

**Ausrollen ist etwas anderes als Testen.** `--plugin-dir` ist der einzige Weg, der den Arbeitsverzeichnis-Stand zeigt; der Marketplace-Weg geht über GitHub und braucht drei Schritte (`git push`, `marketplace update`, `plugin update`) — `marketplace update` allein hebt die installierte Version nicht an, es legt sie nur in den Cache. Ablauf und Belege in `.claude/skills/marketplace-verwaltung/SKILL.md`.

## Frontmatter und Stellschrauben je Skill

Alle acht Skills sind `disable-model-invocation: true` — nur manuell aufrufbar, kein Auto-Laden durch Claude. Das ist Absicht: es sind timing-kontrollierte Workflows.

### plan-execute

- `effort: high` ist fest gesetzt.
- `model: opus` ist eine Übernahme; bei Bedarf ändern oder entfernen.
- Bewusst **kein** `allowed-tools`: Der Skill erbt so die Session-Rechte des aktiven Modus.

### plan-grill

Das Interview läuft, bis keine offene Entscheidung mit Ergebniswirkung mehr im Pool ist (kein Abbruch, nur weil du zustimmst). Anpassbar:

- **Rückfrage-Form:** `AskUserQuestion` bei abzählbaren Optionen, Prosa als Grundfall — im Body im Abschnitt „Genau eine offene Frage zur Zeit". Ob `AskUserQuestion` über alle Surfaces (CLI/IDE/headless) verfügbar ist, ist **nicht dokumentiert**; deshalb ist Prosa der Grundfall und das Tool nur die Kür.

Frontmatter: `model: opus`, `effort: high` (nicht `xhigh` wie `plan-review`: interaktiv, viele kurze Züge). Beobachtbares Kriterium zum Nachschärfen auf `xhigh`: Der Skill stellt Fragen, deren Antwort im Faktenvorlauf auffindbar gewesen wäre, oder ordnet den Pool erkennbar nicht nach Abhängigkeit.

**Warum grill den Plan seit 0.8.0 selbst schreibt.** Die alte Begründung („übergibt an `/plan`, weil vor `/plan` noch kein Plan zum Ändern existiert") war **zirkulär**: Sie begründet, warum grill nichts *ändert*, nicht, warum es nichts *erstellt* — der Plan fehlte ja nur, weil grill ihn nicht anlegte. Der Gewinn ist dabei weniger der gesparte Zug als der **Faktenvorlauf**: Er ist der teuerste Teil des Interviews, und der Übergabeblock sah für Belege gar keinen Platz vor. Ein frischer `/plan`-Lauf musste sie also glauben oder neu erheben. Jetzt wandern sie mit Quelle in den Plan, ebenso das Entscheidungs-Ledger — der Chat ist flüchtig, nach einer Kürzung fehlte sonst die Begründung jeder Entscheidung.

Das Gegenargument, die Schreibsperre werde dadurch weich, ist **am eigenen Bestand widerlegt**: `plan-review` schreibt längst in die Plandatei und hält dabei „Implementiere nichts" über viele Runden. „Nur die Plandatei, sonst nichts" trägt als Prosa-Regel. Der gefährliche Fall ist ohnehin ein anderer — grill fängt mitten im Interview an umzusetzen —, und den schließen ein definierter Zeitpunkt (nach der bestätigten Schlussnotiz) plus genau eine erlaubte Datei aus. Die Bestätigung bleibt als Kontrollpunkt erhalten; sie wird nicht vorweggenommen.

**Warum `EnterPlanMode` statt einer frei abgelegten Datei.** `plan-review` arbeitet auf dem zuletzt erstellten Plan, `plan-execute` auf dem über `ExitPlanMode` freigegebenen. Eine Datei irgendwo im Projekt wäre für beide nicht dasselbe Artefakt, und die Kette bräche. Das Tool verlangt laut eigener Beschreibung ohnehin die Zustimmung des Nutzers — der Moduswechsel ist also kein Alleingang des Skills. Läuft grill bereits im Plan-Modus, entfällt der Schritt ersatzlos.

### plan-review

Der Review läuft rundenweise mit rotierenden Blickwinkeln, bis die Blickwinkel erschöpft sind (kein vorzeitiger Ruhe-Abbruch). Anpassbar:

- **Blickwinkel-Untergrenze:** in der Regel mindestens 3, bevor „erschöpft" erklärt wird (im Body im Abschnitt „Abarbeitung und Erschöpfungs-Abbruch" verstellbar).

Frontmatter: `model: opus`, `effort: xhigh`.

### session-learn

Die Retrospektive läuft, bis kein tragfähiges Learning mehr offen ist. Zu beachten:

- **Schreibt selbst nichts an die Zielorte** — die einzige Ausgabe ist ein Plan, den `plan-review` härtet und `plan-execute` anwendet. Die Ziele sind **projektlokal** (Projekt-CLAUDE.md/`references`/Repo, nie user-global; das Memory-System bleibt unangetastet) und damit git-reversibel. Wie bei `plan-grill` trägt auch diese Regel allein die Body-Prosa, kein Frontmatter-Schutz — dort in ihrer zeitlichen Fassung (während des Interviews nichts, danach nur die Plandatei), hier als vollständiges Nicht-Schreiben.
- **End-of-Session gedacht:** der erzeugte Plan belegt die Plandatei und ersetzt den aktuellen Plan-Kontext — erst laufende Aufgaben abschließen und committen.
- **Frontmatter:** `model: opus`, `effort: high`.

**Warum die Learnings nicht vorab bestätigt werden.** Der Skill lief bis 0.13.0 faktisch mit zwei Freigaben: erst die Learnings absegnen, dann den Plan-Modus. Nur die zweite war je entworfen — der Body verlangte nirgends eine Bestätigung, aber er erlaubte das Schreiben auch nicht ausdrücklich, und ohne diese Erlaubnis legt das Modell das Ergebnis ersatzweise in den Chat und bittet um sie. Dieselbe Beobachtung steht bei `session-handoff`; dort war die Zusage von Anfang an im Body. Die Vorab-Bestätigung sicherte auch nichts: An die Zielorte schreibt der Skill ohnehin nichts, der Plan ist eine Datei, und über die stabile Kennung nimmt der Nutzer jedes einzelne Learning gezielt zurück. Die inhaltliche Kontrolle liegt damit am Plan, nicht davor.

**Warum die zweite Freigabe bleibt.** Sie ist der Wechsel in den Plan-Modus, und der ist derselbe Mechanismus, der bei `plan-grill` ausformuliert steht: `plan-review` arbeitet auf dem zuletzt erstellten Plan, `plan-execute` auf dem über `ExitPlanMode` freigegebenen. Ein Skill, der die Learnings in eine frei abgelegte Datei schriebe, spart die Zustimmung und verliert die Kette — er stünde dann allein da, statt in `plan-review` einzutreten. Nebenbefund derselben Untersuchung: `EnterPlanMode` fehlte im Body ganz, obwohl der Skill im Plan-Modus schreiben soll; `plan-grill` hatte den Schritt, `session-learn` nicht.

**Warum der Auslöser generalisiert wird.** Ein Learning entsteht immer an einem Einzelfall, und die naheliegende Formulierung friert diesen Fall samt seiner Wortwahl ein. Anlass war eine Regel in der `CLAUDE.md` dieses Repos, die auf die Stichwörter „Best Practice" und „State of the Art" auslöste, obwohl das erwartete Verhalten an der Situation hängt und nicht an ihrer Benennung: Bei jeder anderen Formulierung derselben Frage hätte sie geschwiegen. Der Filter prüfte bis dahin, **ob** ein Learning etwas taugt (dauerhaft, neu, handlungsleitend), nie, **woran** es gebunden wird. Die Gegenprobe im Body setzt deshalb am Auslöser an und ausdrücklich nicht am Inhalt: Befehle, Pfade, Werkzeuge und Dateien bleiben konkret, sonst kippt die Korrektur ins Gegenteil und erzeugt generische Regeln ohne Halt im Projekt. Das ist dieselbe Linie, die `project-rules` mit „Im Projekt verankern" fährt.

### session-handoff

Verdichtet den laufenden Arbeitsstand in eine `HANDOFF.md`, damit ein frisches Fenster ohne den bisherigen Verlauf weiterarbeitet.

- **Der Zweck liegt in der Erkenntnisdisziplin, nicht in der Dateibuchhaltung.** Wohin schreiben, wie kürzen, patchen statt neu anlegen — das macht ein fähiges Modell ohnehin brauchbar; solche Regeln bleiben deshalb knapp. Tragend ist das Gegenteil des Defaults: Der Skill läuft definitionsgemäß auf einem gekürzten Verlauf, Zusammenfassen glättet, und je weniger im Kontext steht, desto glatter wird es. Der Text ist entsprechend gewichtet — mehr als die Hälfte gilt dem belegten Stand, der Kontextgrenze und dem, was nicht mehr rekonstruierbar ist.
- **Abschnitt „Unsicher" statt bloßer Ermahnung.** Die Kontextgrenze hat einen festen Ort in der Datei: Vermutung, Quelle, Prüfweg. Der Abschnitt darf leer bleiben, aber sein Fehlen ist selbst eine Behauptung („nichts war unsicher"), die nach einem gekürzten Verlauf selten stimmt. Dorthin fließt auch der Wirkungsfilter: Was aus Unsicherheit wegbliebe, geht nicht in den Papierkorb, sondern unter „Unsicher".
- **Der einzige Skill, der ohne Plan und ohne Rückfrage schreibt.** `plan-execute` schreibt Projektdateien, aber auf Basis eines freigegebenen Plans; `plan-grill` schreibt ausschliesslich die Plandatei und erst nach der bestätigten Schlussnotiz; `session-learn` schreibt gar nicht. Vertretbar, weil die Zieldatei neu ist, nichts Bestehendes angefasst wird und der Rückweg trivial bleibt. Die Zusage „schreib ohne zu fragen" steht ausdrücklich im Body: Ohne sie legt das Modell den Stand ersatzweise in den Chat und bittet um Erlaubnis — im Kontextnotstand die teuerste mögliche Rückfrage. Gegengewicht: Der Skill nennt den Rückweg, sobald er angelegt oder überschrieben hat, und sichert eine untrackte Datei vorher als `.bak`.
- **Kein Fenster, keine Session, kein Skript.** Der Skill endet bei der Datei. `cmd/` enthält bewusst **keine** Nicht-Markdown-Dateien außer dem Manifest, und ein Skill, der ungefragt ein Fenster öffnet oder eine Session startet, verletzt die Freigabe-Regel aus `CLAUDE.md` §12. Ein Verbot dagegen steht **nicht** im Body: Nichts im Skill führt dorthin, und in einem kurzen Prompt kostet jede tote Regel Aufmerksamkeit.
- **Kein „Einstiegssatz" als Pflicht.** Naheliegend wäre, nach dem Wegfall des Fenster-Öffnens einen kopierfertigen Satz für das nächste Fenster zu verlangen. Die Kaltstart-Probe zeigt, dass er entbehrlich ist: Die Datei allein genügt, um den nächsten Schritt ohne Rückfrage auszuführen. Ein solcher Satz dupliziert sie also — die Schlussnotiz verlangt nur Pfad, nächsten Schritt und gegebenenfalls den Rückweg. Die tragende Anforderung steht stattdessen bei den Abschnitten: **Die Datei muss für sich stehen.**
- **Abschnitte als Richtschnur, nicht als Schema.** Das Modell passt Überschriften situationsgerecht an, und das Patchen trägt trotzdem, weil es semantisch abgleicht statt wörtlich. Stabile Überschriften bleiben erwünscht, aber als Vergleichbarkeit über mehrere Übergaben — nicht als Bedingung fürs Patchen.
- **Kommandos sind Beispiele, keine Vorschrift.** `git log`/`git status` stehen unter „etwa", der Nicht-Git-Zweig ist gleichrangig formuliert. Der Bestand enthält sonst genau ein konkretes Kommando (`git restore` in `session-learn`, als Rückweg-Hinweis), und `plan-execute` formuliert Verifikation bewusst generisch. Auch die Zeilenprüfung schreibt kein Werkzeug vor — der Agent hat die Datei selbst geschrieben.
- **Frontmatter:** `model: opus`, `effort: high`. `high` ist vorläufig — der Lauf ist kurz und weitgehend mechanisch, die Urteilslast steckt allein in der Auswahl. Beobachtbares Kriterium zum Senken auf `medium`: Bleibt die Datei über mehrere Läufe knapp und relevant, ist `high` überzahlt; schreibt der Skill dagegen Erledigtes und Verlauf mit, fehlt Auswahlurteil und `high` trägt.

**Testbarkeit, abweichend vom Rest der Suite.** `session-handoff` ist der einzige Skill, dessen voller Flow in *einem* Zug endet — er ließe sich anders als grill/review/execute vollständig headless prüfen. Zwei Hürden stehen dem entgegen und sind in `scripts/smoke.sh` berücksichtigt:

- Ein `claude -p`-Lauf hat **keinen Gesprächsverlauf**. Der Skill verweigert dann korrekt die Datei („kein tragfähiger Stand"), womit sich der Hauptpfad nur mit synthetischem Verlauf im Prompt testen lässt.
- `claude -p` erlaubt standardmäßig **kein `Write`**. Ohne `--permission-mode acceptEdits` schlägt das Schreiben fehl — ein Smoke-Test ohne dieses Flag meldet einen falschen FAIL.

**Ob ein Plugin geladen ist, objektiv prüfen — nicht das Modell fragen.** Im Headless-Modus bekommt das Modell keine Skill-Liste in den Kontext und meldet einen geladenen Skill deshalb als „existiert nicht". Diese Selbstauskunft ist wertlos; belastbar ist das `system/init`-Event:

```
claude --plugin-dir ./cmd -p "hi" --output-format stream-json --verbose
# → plugins: [{"name":"cmd","version":"<aktuell>","path":"…",...}], plugin_errors, slash_commands
```

### project-rules

Wendet sieben Disziplin-Kataloge gemeinsam auf eine bestehende `CLAUDE.md`/`AGENTS.md` an und verdichtet die Datei zuletzt in einem Token-Effizienz-Pass. Die Kataloge liegen in `references/` und werden **bedarfsgeladen** — der Body liest sie erst in Schritt 4 bzw. 7, nicht beim Aufruf.

Frontmatter: `model: opus`, `effort: xhigh` — der Skill plant alle Kataloge in *einem* Durchgang und schreibt die Datei einmal kohärent; das ist der aufwendigste Einzelschritt der Suite.

**Warum der Skill nichts verschiebt.** Ablage und projekteigene Artefakte kamen mit 0.12.0 als Katalog 6 und 7 dazu, die *Ausführung* aber nicht: Das Auslagern von Inhalt und das Anlegen von Ordnern liegt in `project-structure`. Der Grund ist die Bauform. `project-rules` lebt von „einmal lesen → alle Kataloge gemeinsam planen → einmal schreiben"; ein Umzug über viele Dateien braucht dagegen Rückweg, Registerführung und Verlustnachweis **je Datei**. Beides in einen Durchgang zu legen, bräche genau das Prinzip, gegen das die Schritte gebaut sind. Der Skill markiert deshalb auslagerungsreife Blöcke und empfiehlt im Protokoll den anderen Skill.

**Warum der Ablage-Kanon nicht hier liegt.** Die Ortstabelle steht einmal, in `project-structure/references/ablage-kanon.md`; die beiden Kataloge verweisen darauf. Eine Kopie wäre bequemer zu lesen und genau das Drift-Problem, das die Ablagedisziplin selbst verbietet — zwei Fassungen, von denen eine beim nächsten Edit veraltet.

**Der Konflikt mit der Sicherheitsdisziplin ist aufgelöst, nicht umgangen.** Katalog 7 verlangt, dass der Agent projekteigene Skills verbessert; `sicherheitsdisziplin.md` sagte „ändere deine eigenen Instruktionen nicht". Ohne Eingriff hätte der Skill sich widersprechende Regeln in jede `CLAUDE.md` geschrieben — und laut Doku wählt Claude bei widersprüchlichen Instruktionen willkürlich eine. Die Zeile trägt jetzt eine benannte Ausnahme: projekteigene, versionierte Artefakte nach ausdrücklicher Freigabe, weil die Änderung im Diff sichtbar und per `git restore` rückholbar ist. Systeminstruktionen, Freigaben, Berechtigungen und Hooks bleiben ausgenommen. Das ist eine Präzisierung, keine Lockerung — Best-of gilt auch für die Kataloge untereinander.

**Warum Katalog 7 seit 0.14.2 einen Verbuchungshinweis trägt.** Der Katalog mischt zwei Regelsorten: Pflegeregeln, die anlassunabhängig formuliert sind, und Auslöserregeln, die unter „Verlange von jedem Artefakt einen Anlass aus diesem Projekt" stehen. Ein Lauf gegen dieses Repo hat genau die zweite Gruppe weggelassen und nur die erste in die `CLAUDE.md` geschrieben — nachweisbar daran, dass dort die Freigabepflicht und der Zweite-Korrektur-Auslöser stehen, aber weder die Zuordnung Skill/Subagent/Regel noch der Dritter-Handgriff-Auslöser noch „keines auf Vorrat". Die Ursache steckt im Katalog, nicht im Lauf: Er sagte nirgends, dass der Anlassvorbehalt dem *Vorschlag* gilt und nicht der *Regel*. Damit war die Verwechslung angelegt, „dieses Projekt braucht jetzt keinen Skill" hieße „es braucht die Regel nicht, wann es einen anlegt". Sie wiegt in langlebigen Repos am schwersten, weil die Regel ihren Wert erst beim dritten gleichen Handgriff entfaltet — den es zum Zeitpunkt des Laufs per Definition noch nicht gibt.

**Warum die Abdeckungszeile seit 0.14.3 keine Quote mehr trägt.** Sie lautete „X von Y Katalogregeln verbucht" und sah damit nach Messung aus. Der Skill legt aber nirgends fest, was als *eine* Regel zählt — Listenpunkt, Satz oder Unterabschnitt —, also kommt jeder Lauf auf eine andere Zahl, und alle klingen gleich sicher. Der Lauf gegen dieses Repo meldete „38 von 38"; die sieben Kataloge enthalten 106 Listenpunkte. Der Fehlschätzer fiel niemandem auf, weil nichts ihn prüft, und genau das ist das Problem einer Zahl ohne Zähleinheit: Sie verleiht dem Protokoll eine Präzision, die es nicht hat. Die Alternative wäre gewesen, die Einheit zu definieren (ein Listenpunkt, `grep -c '^- '`); dagegen sprach der Aufwand eines 106-zeiligen Registers je Lauf. Die Zeile behauptet jetzt nur noch, was tatsächlich getan wurde, und der Nachweis liegt beim Register aus Schritt 4, wo er ohnehin lag.

**Warum die Profilschwelle denselben Schnitt bekam wie Katalog 7.** Der Verbuchungshinweis aus 0.14.2 trennt Vorschlag von Regel im Katalog; eine Ebene höher tat Schritt 2 dieselbe Vermischung. „Ein kleines Repo braucht weder Ablagestruktur noch eigene Skills" gilt fürs *Anlegen* und liest sich als Freibrief, auch die Regel wegzulassen. Die Tabelle verstärkte das: Beide Zeilen, die auf ein Plugin-Repo passen („Bibliothek/Framework: Artefakte selten nötig", „Software/Coding: ab mehreren Mitwirkenden oder langer Laufzeit"), senkten die Schwelle. Der Fix hätte allein aus 0.14.2 nicht gegriffen — dort war der Anlassvorbehalt gemeint, hier die Projektgröße; zwei Wege zum selben Ergebnis.

**Der zweite Hinweis betrifft eine Projektart, die dieses Repo selbst ist.** Ein Plugin-Repo trägt `cmd/skills/` und `.claude/skills/`: gleicher Ordnername, unvereinbare Rollen — das eine wird ausgeliefert und steuert fremde Sessions, das andere steuert die Arbeit im Repo. Eine Ablage-Inventur, die den Produktordner mitzählt, sieht eine erfüllte Artefaktlage, wo keine ist. Derselbe Punkt steht zusätzlich im Artefakt-Kanon unter den Mindestanforderungen, weil `project-structure` beim Vorschlagen auf dieselbe Verwechslung laufen kann und beide Skills den Kanon getrennt lesen.

### project-structure

Frontmatter: `model: opus`, `effort: high`. Zwei bedarfsgeladene References: `ablage-kanon.md` (Orte, Namensschemata, Ladezeitpunkte samt Belegen) und `artefakt-kanon.md` (Skills, Subagents, `paths:`-Regeln).

**Der Kanon ist recherchiert, nicht erfunden.** Ein selbst ausgedachter Sammelordner wäre einheitlicher gewesen und schlechter: Die Zwecke haben je eigene etablierte Konventionen, und wer sie verlässt, verliert deren Werkzeugunterstützung. Übernommen sind deshalb `docs/decisions/` bzw. `docs/adr/` mit `NNNN-titel.md` (MADR), `docs/` nach Diátaxis für Menschen-Doku, `CHANGELOG.md` plus git-Historie für Erledigtes und `backlog/tasks/` mit `completed/` (Backlog.md). Dass Entscheidungen unter `docs/` liegen und Aufgaben nicht, ist keine Inkonsistenz, sondern spiegelt zwei Communities.

**Was die Nachrecherche zu 0.12.1 korrigiert hat, und warum das lehrreich ist.** Der Kanon war beim ersten Wurf an drei Stellen genauer formuliert, als er belegt war — und zwar überall dort, wo eine Quellenangabe die Prüfung ersetzt hat. Der Archivpfad `backlog/archive/` war unter Berufung auf Backlog.md schlicht falsch (dort `completed/`), Datei- und Frontmatter-Schema sind mit dem Werkzeug gar nicht kompatibel, `docs/decisions/` ist gegen die Praxis der Minderheitspfad, die Abschnittsliste ist eine Verdichtung des MADR-Templates statt dessen Struktur, und die Diátaxis-Ordner widersprachen der ausdrücklichen Anwendungsanleitung ihres eigenen Urhebers. Jeder dieser Punkte hätte eine Quellen-URL getragen. Genau das macht sie gefährlicher als eine offene Erfindung: **Eine Quellenangabe belegt, dass eine Quelle existiert, nicht dass die Aussage aus ihr folgt.** Der Kanon führt seitdem Belegstufen, kennzeichnet Verdichtungen als solche und trennt die Konvention eines Werkzeugs vom Muster dahinter.

**Warum der Kanon Belegstufen führt.** Die Einträge sind nicht gleich gut belegt, und das zu verwischen wäre der eigentliche Fehler: MADR und Diátaxis sind werkzeugunabhängig — `docs/decisions/` ergibt ohne jedes MADR-Tooling Sinn, weil die Ordnerstruktur die Konvention trägt. `backlog/tasks/` dagegen ist die Konvention *eines* CLI-Werkzeugs; wer es nicht nutzt, hat keinen Grund für genau diesen Pfad, und eine werkzeugunabhängige Konvention für dateibasierte Aufgaben gibt es schlicht nicht — üblich ist der Issue-Tracker. Ein tool-gebundener Pfad ohne Zustimmung wäre eine Erfindung, die eine Quellenangabe trägt und dadurch schwerer als Erfindung zu erkennen ist. Deshalb trennt die Tabelle `etabliert` von `tool-gebunden`, und nur die erste Stufe legt der Skill nach den normalen Regeln an; die zweite braucht ausdrückliche Zustimmung unter Nennung des Werkzeugs.

**Warum sich die beiden Skills nicht gegenseitig im Kreis empfehlen.** `project-rules` empfiehlt am Ende `project-structure`, und dieses am Ende wieder `project-rules` — das konvergiert zwar, schickt beim ersten Mal aber hin und her. Beide Skills tragen deshalb einen Abbruch: `project-structure` benennt sich als letzten Schritt der Reihe, und `project-rules` empfiehlt den anderen Skill nur, solange kein `## Ablage`-Abschnitt existiert. Liegt er vor, sind übrige Blöcke solche, die der Umzug bewusst liegen ließ; dann legt der Skill die Entscheidung vor, statt einen weiteren Lauf vorzuschlagen.

**Warum „erkennen" vor „anlegen" steht.** Ein Projekt mit Issue-Tracker bekommt kein `backlog/`, eines mit `docs/adr/` kein zweites Entscheidungsverzeichnis, ein generiertes `docs/` gar keine Ablage. Andernfalls entstünde für einen Zweck ein zweiter Ort — dieselbe Drift, die der Skill bei `CLAUDE.md` vs. `AGENTS.md` verhindern soll. Umbenennungen auf den Kanon werden vorgeschlagen und nicht vorausgesetzt, weil sie Verweise aus README, CI und Lesezeichen brechen; bei Ablehnung gilt der vorhandene Name als kanonisch.

**Das Verlagerungs-Register ist der Verlustnachweis**, gebaut wie das Abdeckungs-Register von `project-rules`: Jede Quelle landet in genau einer von vier Kategorien, auch das Verbleibende wird verbucht, und der Bericht schließt mit einer Zeilenbilanz.

Die vierte Kategorie `entfällt` kam aus dem Testlauf, nicht aus dem Entwurf. Mit nur drei Kategorien verbuchte der Skill eine Container-Überschrift (`# Notizen`) als „entfällt" **außerhalb** des Schemas — sachlich richtig, aber damit ging die Bilanz nicht auf, und genau das hätte den Verlustnachweis entwertet. `entfällt` ist deshalb eng gefasst: nur reine Strukturzeilen ohne eigene Aussage, unter Nennung der ersetzenden Zielzeile, in der Bilanz einzeln statt als Sammelposten. Ein Sammelposten machte aus der Bilanz eine Restgröße, in der sich ein echter Verlust verstecken ließe. Im Zweifel gilt „verschieben" — eine überflüssige Überschrift kostet eine Zeile, eine verlorene Aussage ist der Fehler, gegen den der Skill gebaut ist. Ohne Register wird nicht bewegt. Verschieben ist dabei als reine Ortsänderung definiert — Kürzen und Umformulieren sind verboten, weil dabei genau die Vorbehalte und Ausnahmen verlorengehen, deretwegen der Text geschrieben wurde. Das Verdichten kommt danach, aus `project-rules`.

**`git mv` statt `mv`** erhält die Historie und zeigt den Umzug im Diff als Umbenennung statt als Löschen plus Neuanlegen. Ohne git-Repo entfällt beides; dann ist jede Quelle wie eine untrackte zu behandeln, also `.bak` vor jeder Bewegung — der Skill sagt ausdrücklich, dass der Umzug dort schlechter reversibel ist.

**Warum der Wegweiser von diesem Skill geschrieben wird und nicht von `project-rules`.** Nur `project-structure` weiß, was tatsächlich angelegt wurde; `project-rules` würde sonst auf Pfade verweisen, die es nicht gibt — eine Erfindung nach eigenem Maßstab. Der Abschnitt trägt die feste Überschrift `## Ablage`, damit beide Skills ihn finden: einer schreibt ihn, der andere härtet und verdichtet ihn.

### project-settings

Frontmatter: `model: opus`, `effort: high`. Ein `references/` wird bedarfsgeladen: `permission-kanon.md` (die zu setzenden Werte samt Belegen).

**Warum `autoMode` und `dialogExpiry` gar nicht angefasst werden:** beide werden aus Projekt- und Local-Settings **nicht gelesen**. Ein Eintrag dort erzeugt keinen Fehler, er wird stillschweigend ignoriert — genau die Fehlerklasse, gegen die dieses Repo sonst mit `claude plugin validate` arbeitet und die hier kein Werkzeug abfängt.

**Warum der Skill `plans/` selbst anlegt.** `plansDirectory: "./plans"` zu setzen, ohne den Ordner anzulegen, hinterlässt eine Konfiguration, die auf einen nicht existierenden Pfad zeigt. Ob die Runtime ihn beim Schreiben des ersten Plans selbst erzeugt, ist **nicht verifiziert** — der Skill legt ihn deshalb explizit an, und die Existenzprüfung davor macht den Schritt folgenlos, falls er redundant ist. Sie ist ohnehin nötig, damit der zweite Lauf diff-frei bleibt.

**Warum der Rückweg `rmdir` heißt.** Ein neu angelegtes `plans/` ist untrackt und steht zugleich in der `.gitignore`, `git restore` greift dort also nicht. `rm -rf plans` wäre der naheliegende Ersatz und genau deshalb falsch: Es löscht kommentarlos die Pläne mit, die inzwischen darin liegen. `rmdir` scheitert in dem Fall — der einzige Rückweg, der nur das rückgängig macht, was der Skill tatsächlich angelegt hat.

**Warum der Skill eine Altlast räumt, die er selbst nicht mehr kennt.** 0.10.0 hat das Kommunikationsprotokoll ersatzlos entfernt und dabei nur die *Quelle* beseitigt: Wo ein Lauf bis 0.9.0 den `SessionStart`-Hook und `.claude/skills/session-protocol/SKILL.md` abgelegt hatte, blieb beides liegen und lud weiter bei jedem Sessionstart. Das war im Changelog benannt, aber nicht behoben — eine entfernte Funktion, die in jedem eingerichteten Projekt weiterlief. Der Skill bekommt deshalb genau so viel Kenntnis des Protokolls zurück, wie das Erkennen braucht: die Marke `# cmd:project-settings:session-protocol`, die über alle Fassungen identisch ist. **Sie ist der Grund, warum die Räumung überhaupt möglich ist** — am Kommandotext wäre ein Eintrag aus 0.8.0 nicht mehr sicher von einem fremden Hook zu unterscheiden.

**Warum die Datei nicht auf Unversehrtheit geprüft wird.** Der naheliegende Wunsch wäre, eine unveränderte Kopie still zu entfernen und eine angepasste vorzulegen. Das geht nicht: Die Vorlage ist mit 0.10.0 aus dem Plugin verschwunden, es gibt keinen Vergleichsstand mehr im ausgelieferten Inhalt. Ihn aus der git-Historie zu holen scheidet aus, weil der Skill in fremden Projekten läuft, nicht in diesem Repo. Der Skill legt die Datei deshalb vor und sagt dazu, dass er den Zustand nicht prüfen konnte — eine behauptete Prüfung wäre schlimmer als die fehlende.

**Warum die beiden Nutzer-Settings-Keys nur gemeldet werden.** `crossSessionInbound` und `isolatePeerMachines` kann ein Lauf bis 0.9.0 in `~/.claude/settings.json` gesetzt haben. Sie zu entfernen hieße, die zweite Freigabestufe wieder einzuführen, die 0.10.0 gerade abgeschafft hat — der Skill schreibt seitdem nur im Projekt. Und anders als Hook und Datei sind sie nicht funktionslos geworden: Sie steuern die sessionübergreifende Zustellung, die es unabhängig von diesem Protokoll gibt, und können bewusst gesetzt sein. Ein Rückstand, der weiterhin etwas Sinnvolles tut, wird gemeldet und nicht beseitigt.

**Warum erst der Hook und dann die Datei entfernt wird.** Die Reihenfolge entscheidet, was ein Abbruch dazwischen hinterlässt. Hook zuerst: eine Datei, die niemand mehr lädt — folgenlos. Datei zuerst: ein Hook, dessen Ziel fehlt. Er ist durch sein eigenes `[ -f … ] || exit 0` zwar harmlos, aber er bleibt als Eintrag stehen, den ein späterer Leser deuten muss. Von zwei unvollständigen Zuständen ist der folgenlosere zu wählen.

**Warum der Punkt in einem sauberen Projekt gar nicht auftaucht.** Ein Bericht, der in jedem Projekt „keine Altlast gefunden" meldet, erklärt auf Dauer eine Funktion, die es seit 0.10.0 nicht mehr gibt. Gemeldet wird nur ein Fund. Das kostet die Bestätigung, dass geprüft wurde — vertretbar, weil die Prüfung drei Dateizugriffe sind und der Migrationsfall pro Projekt genau einmal eintritt.

**Warum der Permission-Kanon so aussieht.** `Read(//**)` mit einer deny-Liste für Schlüssel, Cloud-Credentials und Keychain ist eine Entscheidung für **eine** Maschine und **ein** Arbeitsprofil, keine allgemeine Empfehlung — der Block liegt in einem öffentlichen Repo und wird sonst als Vorlage gelesen. Zwei Grenzen sind bewusst in Kauf genommen und im Kanon dokumentiert: Die deny-Liste schützt das Read-Tool, nicht die Shell (`cat` und Verwandte gehören zum eingebauten Read-only-Satz und laufen prompt-frei; die sechs `Bash(cat …)`-Einträge decken nur den naheliegendsten Umweg), und `git restore` bleibt ungefragt, obwohl es uncommittete Arbeit löscht — eine ask-Regel unterbräche den dokumentierten Rückweg aus einem Fehlversuch bei jedem Gebrauch.

## Kein Frontmatter- oder Hook-Schutz gegen Schreibzugriffe

`session-learn` darf nichts schreiben, `plan-grill` während des Interviews nichts und danach ausschließlich die Plandatei. Diese Regeln tragen **allein die Body-Prosa** — nicht das Frontmatter und kein Hook. Alle Kandidaten wurden geprüft und verworfen:

- `allowed-tools` **sperrt nichts**. Laut Doku „does not restrict which tools are available: every tool remains callable" — Vorab-Genehmigung gegen Permission-Prompts, keine Whitelist.
- `disallowed-tools` ist dokumentiert, taugt aber für einen **mehrschrittigen** Skill prinzipiell nicht: die Einschränkung „clears when you send your next message" — im Interview fiele sie schon nach der ersten Antwort weg. Unabhängig davon blieb der Key im headless-Test (`-p`) wirkungslos (`Write`/`Edit` im Pool). Beides zusammen: als Sperre unbrauchbar.
- Ein **PreToolUse-Hook** wäre der dokumentierte Weg, einen Tool-Call hart zu blocken — aber es gibt **keinen dokumentierten Weg, ihn skill-genau zu bedingen**: der Hook-Input kennt `tool_name`/`tool_input`, nicht den aktiven Skill (`context.currentSkill` ist nicht real). Ein Plugin-Hook auf `Write|Edit` feuerte damit über **alle** Skills und bräche `plan-review`/`plan-execute`, die schreiben müssen. Ein Hook im Skill-Frontmatter verfällt wiederum wie `disallowed-tools` nach der nächsten Nachricht — dieselbe Mehrschritt-Lücke.
- **Fazit:** Runtime-Enforcement ist mit dokumentierten, robusten Mitteln nicht erreichbar. Die Sperre steht als erster Absatz im jeweiligen Skill-Body („du interviewst mich, du setzt nichts um … kein Write, kein Edit … auch dann nicht, wenn ich dich darum bitte").

### Historie: die gestrichene `allowed-tools`-Liste in plan-review

Bis 0.2.0 stand bei `plan-review` eine Liste lesender Tools mit der Begründung „kein Schreibzugriff". Die war falsch: `allowed-tools` sperrt nichts, es genehmigt nur vorab und unterdrückt damit Permission-Prompts. Die Liste hat den Skill also nie am Schreiben gehindert. Ersatzlos gestrichen, statt einen Schutz vorzutäuschen; dass `plan-review` nichts umsetzt, trägt allein der erste Satz des Bodys. Spürbare Folge: bei `Read`/`Grep`/`git log` kann wieder ein Permission-Prompt kommen — willst du die weg, ist `allowed-tools` das richtige Mittel, aber als Bequemlichkeit deklariert, nicht als Schranke.

## Konventionen — geteiltes Vokabular

Die Skills teilen Vokabular. Diese Begriffe wortgleich halten, damit die Suite nicht auseinanderläuft:

- **Steelman** — den Gegenstand in einem Satz *wohlwollend* wiedergeben, bevor man ihn belastet (grill, review).
- **Erschöpfungs-Abbruch** — die Schleife endet erst, wenn nichts Neues mehr trägt (Entscheidungen bei grill, Blickwinkel bei review, Learnings bei session-learn), nie auf Zustimmung oder Ungeduld hin. **Nicht** bei `session-handoff`: Der Skill hat keine Schleife über einen Pool, sondern schreibt einmal. Dort steht stattdessen der **Wirkungsfilter** (aus grill), der auf eine einmalige Auswahl passt. Den Begriff nicht ausdehnen — er ist über den leerlaufenden Pool definiert.
- **beobachtbares Kriterium** — ein prüfbarer Beleg (Testlauf, Exit-Code, Datei-/Lesezustand), kein „fehlerfrei"-Versprechen (execute; verwandt reviews „Befund am konkreten Schritt belegen").
- **stabile Kennung / revidierbar** — jedem eingearbeiteten Punkt eine über den Lauf stabile Kennung geben, damit gezielt zurückgenommen werden kann.

Drei Divergenzen sind **absichtlich** — nicht angleichen:

- **„als Chat-Notiz ausgeben, nicht …"** — grill und review: *nicht in den Plan*, aber aus verschiedenen Gründen. Bei review, weil es den Plan laufend ändert und nur die Schlussnotiz draußen bleiben soll; bei grill, weil die Schlussnotiz **vor** der Plandatei kommt und der Kontrollpunkt ist, an dem bestätigt wird. Execute schreibt Projektdateien, nur der Abschlussbericht bleibt im Chat. Der Zusatz kodiert, was der Skill *sonst* darf.
- **Ledger vs. Protokoll** — grill/review führen ein **Ledger** (Register mit Rücknahme-Kennung); execute führt ein **laufendes Protokoll** (Abweichungen/Ursachen/Korrekturen, ohne Kennung). Verschiedene Dinge, verschiedene Wörter — nicht gleichsetzen.
- **Kennungs-Schema** — grill flach („Entscheidung 3", rundenlos), review rundenbasiert („2.3"). Folgt der Struktur des jeweiligen Laufs.
