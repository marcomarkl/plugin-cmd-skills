# DESIGN — Entwurfsnotizen zum `cmd`-Plugin

Maintainer-Dokumentation: warum die Skills so gebaut sind, welche Stellschrauben es gibt und welche Ansätze geprüft und **verworfen** wurden. Die Nutzungsanleitung steht in [`cmd/README.md`](cmd/README.md), der Einstieg im [Root-README](README.md).

## Namespace, Autoentdeckung, Umbenennen

Skills werden automatisch aus `cmd/skills/` entdeckt; kein Eintrag im Manifest nötig. Der **Aufrufname folgt dem Ordnernamen** (`plan-execute` → `/cmd:plan-execute`); das Frontmatter-`name` ist dabei nur ein Anzeige-Label.

Willst du das Präfix ändern, passe `name` in `cmd/.claude-plugin/plugin.json` an (früher trug jeder Command ein `my-`-Dateipräfix; diese Rolle übernimmt jetzt der Plugin-Namespace) — und trag den alten Namen in die `renames`-Map der `.claude-plugin/marketplace.json` ein, sonst bricht jede bestehende Installation.

## Lokaler Entwicklungs-Loop

Laden/testen: `claude --plugin-dir ./cmd`, nach Änderungen `/reload-plugins`. Manifeste prüfen: `claude plugin validate . --strict` **und** `claude plugin validate ./cmd --strict` — der Root-Aufruf erfasst nur das Marketplace-Manifest, das Plugin-Manifest braucht den zweiten. Verhaltens-Rauchtest: `bash scripts/smoke.sh` — startet echte Modell-Läufe, prüft nur den Eröffnungszug je Skill. Die erwartete Form der vollen Flows steht in [`examples/transcripts.md`](examples/transcripts.md).

**Ausrollen ist etwas anderes als Testen.** `--plugin-dir` ist der einzige Weg, der den Arbeitsverzeichnis-Stand zeigt; der Marketplace-Weg geht über GitHub und braucht drei Schritte (`git push`, `marketplace update`, `plugin update`) — `marketplace update` allein hebt die installierte Version nicht an, es legt sie nur in den Cache. Ablauf und Belege in `.claude/skills/marketplace-verwaltung/SKILL.md`.

## Frontmatter und Stellschrauben je Skill

Alle sieben Skills sind `disable-model-invocation: true` — nur manuell aufrufbar, kein Auto-Laden durch Claude. Das ist Absicht: es sind timing-kontrollierte Workflows.

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

Wendet fünf Disziplin-Kataloge gemeinsam auf eine bestehende `CLAUDE.md`/`AGENTS.md` an und verdichtet die Datei zuletzt in einem Token-Effizienz-Pass. Die Kataloge liegen in `references/` und werden **bedarfsgeladen** — der Body liest sie erst in Schritt 4 bzw. 7, nicht beim Aufruf.

Frontmatter: `model: opus`, `effort: xhigh` — der Skill plant alle Kataloge in *einem* Durchgang und schreibt die Datei einmal kohärent; das ist der aufwendigste Einzelschritt der Suite.

### project-settings

Frontmatter: `model: opus`, `effort: high`. Zwei `references/` werden bedarfsgeladen: `permission-kanon.md` (die zu setzenden Werte samt Belegen) und `kommunikationsprotokoll.md` (die Vorlage, die ins Zielprojekt kopiert wird).

**Warum die Werte auf zwei Scopes verteilt sind.** Der Skill schreibt fast alles in die Projekt-`.claude/settings.json`, aber `crossSessionInbound` und `isolatePeerMachines` in die Nutzer-Settings. Das ist keine Inkonsequenz, sondern erzwungen: Ein `crossSessionInbound`-Wert aus Projekt- oder Local-Settings gilt nur, wenn er auf der Leiter `accept < hold < refuse` **strenger** ist als der Wert aus den vertrauenswürdigen Quellen — ein `accept` wäre dort also wirkungslos. `isolatePeerMachines` steht daneben, weil Cross-Session-Messaging maschinenweit wirkt und nicht projektweise: Die Erreichbarkeit hängt an Maschine und Account, `ListAgents` listet Sessions aus allen Projekten. Projektweise gesetzt hinge das Nachrichtenverhalten davon ab, in welchem Ordner die Session gestartet wurde.

Aus demselben Grund fasst der Skill `autoMode` und `dialogExpiry` gar nicht an: beide werden aus Projekt- und Local-Settings **nicht gelesen**. Ein Eintrag dort erzeugt keinen Fehler, er wird stillschweigend ignoriert — genau die Fehlerklasse, gegen die dieses Repo sonst mit `claude plugin validate` arbeitet und die hier kein Werkzeug abfängt.

**Warum der Permission-Kanon so aussieht.** `Read(//**)` mit einer deny-Liste für Schlüssel, Cloud-Credentials und Keychain ist eine Entscheidung für **eine** Maschine und **ein** Arbeitsprofil, keine allgemeine Empfehlung — der Block liegt in einem öffentlichen Repo und wird sonst als Vorlage gelesen. Zwei Grenzen sind bewusst in Kauf genommen und im Kanon dokumentiert: Die deny-Liste schützt das Read-Tool, nicht die Shell (`cat` und Verwandte gehören zum eingebauten Read-only-Satz und laufen prompt-frei; die sechs `Bash(cat …)`-Einträge decken nur den naheliegendsten Umweg), und `git restore` bleibt ungefragt, obwohl es uncommittete Arbeit löscht — eine ask-Regel unterbräche den dokumentierten Rückweg aus einem Fehlversuch bei jedem Gebrauch.

**Warum ein Hook und nicht nur ein Skill.** Das Kommunikationsprotokoll soll in jeder Session gelten, aber ein Skill kann sich nicht selbst auslösen, und `disable-model-invocation: true` verhindert zusätzlich das automatische Laden. Der einzige Auslöser, der bei jedem Sessionstart feuert, ist ein `SessionStart`-Hook. Er gibt die markierte Kurzfassung auf stdout aus, was bei diesem Event als Kontext übernommen wird; `jq` braucht er nur für `sessionTitle` und fällt ohne es sauber auf den reinen Text zurück. Nicht möglich ist eine Handlung **vor** dem ersten Prompt: `initialUserMessage` erzeugt zwar einen Turn, gilt aber nur im Non-Interactive-Modus mit `-p`. Das Protokoll wirkt daher ab dem ersten Turn — das ist die Grenze des Mechanismus, nicht der Umsetzung.

Der Hook trägt in seiner ersten Zeile die Marke `# cmd:project-settings:session-protocol`. Sie ist der Wiedererkennungsanker für spätere Läufe: Claude Code dedupliziert gleiche Handler nur über verschiedene Settings-Dateien hinweg, nicht innerhalb eines Arrays — ein Vergleich über den vollständigen Kommandotext legte nach jeder Textänderung einen zweiten Eintrag an.

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
