# Changelog

Versionen des `cmd`-Plugins. Quelle der Wahrheit für die Versionsnummer ist `cmd/.claude-plugin/plugin.json`.

## 0.8.0

- **`plan-grill` schreibt jetzt den Plan.** Nach der bestätigten Schlussnotiz legt der Skill die Plandatei selbst an, statt um die Übergabe an `/plan` zu bitten. Ist der Plan-Modus nicht aktiv, bietet er vorher `EnterPlanMode` an — eine frei abgelegte Datei wäre für `plan-review` (arbeitet auf dem zuletzt erstellten Plan) und `plan-execute` (auf dem über `ExitPlanMode` freigegebenen) nicht dasselbe Artefakt.
- **Die alte Begründung war zirkulär** und ist gestrichen: grill übergebe an `/plan`, „weil vor `/plan` noch kein Plan zum Ändern existiert" — der Plan fehlte aber nur, weil grill ihn nicht anlegte. Das begründet, warum grill nichts *ändert*, nicht, warum es nichts *erstellt*.
- **Der eigentliche Gewinn ist der Faktenvorlauf, nicht der gesparte Zug.** Er ist der teuerste Teil des Interviews, und der Übergabeblock sah für Belege keinen Platz vor — ein frischer `/plan`-Lauf musste sie glauben oder neu erheben. Sie wandern jetzt mit Quelle in den Plan, ebenso das **Entscheidungs-Ledger** als eigener Abschnitt: Der Chat ist flüchtig, nach einer Kürzung fehlte sonst die Begründung jeder Entscheidung, und „nimm Entscheidung 3 zurück" trüge nicht mehr.
- **Die Schreibsperre bleibt hart, nur zeitlich gefasst:** während des Interviews keine Datei, auch nicht auf Bitte; danach genau die Plandatei und weiterhin keine Umsetzung. Dass eine Prosa-Sperre auf genau eine Datei hält, belegt `plan-review` im eigenen Bestand seit Längerem. Die Bestätigung der Schlussnotiz bleibt als Kontrollpunkt erhalten und wird nicht vorweggenommen.
- **Pipeline:** `/plan` ist kein Pflichtglied mehr — die Kette lautet `plan-grill → plan-review → ExitPlanMode → plan-execute`. `/plan` bleibt nutzbar, wenn ohne Interview direkt geplant werden soll. Die Arbeitsteilung grill/review trennt jetzt nach **Gegenstand** (Entscheidungen vs. fertiger Plan) statt nach Reihenfolge.
- README (Root und `cmd/`), `DESIGN.md`, `examples/transcripts.md` und der Kommentar in `scripts/smoke.sh` nachgezogen; der Schreibpfad wird headless nicht erreicht, weil ihm die Bestätigung fehlt. Die Manifest-`description`s bleiben unverändert gültig.

## 0.7.0

- **Neuer Skill `project-settings`:** setzt die `.claude/settings.json` eines Projekts auf einen festen, belegten Kanon (Auto-Memory aus, `plansDirectory: "./plans"`, Permission-Regeln für Web, git und Lesezugriff), entdoppelt die Permission-Listen und legt ein Kommunikationsprotokoll für parallel laufende Sessions als projektlokalen Skill samt `SessionStart`-Hook ab.
- **Skalare überschreiben, Arrays vereinigen.** Die eigentliche Anforderung („nichts doppelt, Bestehendes überschrieben, Fremdes unangetastet") lässt sich nicht einheitlich lösen: `permissions.allow` zu *ersetzen* löschte fremde Freigaben, es *nicht anzufassen* setzte den Kanon nicht durch. Ebenso wird nie neu serialisiert, sondern gezielt editiert — ein Full-Reformat erzeugte für eine Ein-Key-Änderung einen Komplett-Diff in einer eingecheckten Datei und bräche die Diff-Freiheit des zweiten Laufs. Idempotenz ist das Abnahmekriterium, inklusive `hooks.SessionStart`: das ist ein Array, und naives Anhängen ließe den Hook zweimal laufen.
- **Zwei Freigabestufen entlang der Versionierungsgrenze:** Repo-Änderungen gesammelt (Rückweg `git restore`, bei untrackten Dateien eine `.bak`-Kopie wie bei `session-handoff`), `~/.claude/settings.json` getrennt mit vorheriger `.bak`. Dorthin gehen nur `crossSessionInbound: "accept"` und `isolatePeerMachines: true` — erzwungen, nicht willkürlich: ein `accept` aus Projekt-Settings wird verworfen, weil dort nur *strengere* Werte gelten, und Cross-Session-Messaging wirkt maschinenweit statt projektweise.
- **`autoMode`, `dialogExpiry` und `language` werden bewusst nicht gesetzt.** Die ersten beiden werden aus Projekt- und Local-Settings belegt nicht gelesen — ein Eintrag dort wird stillschweigend ignoriert statt zu fehlschlagen; `language` steht bereits user-global und wäre die Doppelung, die der Skill vermeiden soll.
- **Auto-Memory wird geleert, nicht nur abgeschaltet:** vorhandene Einträge werden mit Zielvorschlag vorgelegt, nach Freigabe in die Projekt-`CLAUDE.md` geschrieben und anschließend nach `imported/` **verschoben** statt gelöscht — die Dateien liegen außerhalb jeder Versionierung, und `autoMemoryEnabled: false` schaltet nur das Auto-Memory ab, nicht den Lesezugriff des Skills.
- **Zwei Grenzen ausdrücklich benannt statt kaschiert:** Die deny-Liste schützt das Read-Tool, nicht die Shell (`cat` und Verwandte gehören zum eingebauten Read-only-Satz und laufen prompt-frei; sechs `Bash(cat …)`-Einträge decken nur den naheliegendsten Umweg), und `git restore` bleibt ungefragt, obwohl es uncommittete Arbeit löscht — eine ask-Regel unterbräche den dokumentierten Rückweg aus einem Fehlversuch. Beides steht im Abschlussbericht des Skills.
- **Workspace-Trust dokumentiert:** `permissions.allow` aus Projekt-Settings greift erst nach Annahme des Trust-Dialogs, `deny` und `ask` sofort. Direkt nach dem Lauf sind also die Einschränkungen aktiv und die Erleichterungen noch nicht; ohne diesen Hinweis wirkt der Skill fehlgeschlagen. In `claude -p` erscheint der Dialog nie, weshalb `smoke.sh` die Permission-Wirkung nicht abdecken kann.
- **Der Hook nutzt `${CLAUDE_PROJECT_DIR}` und eine Erkennungsmarke.** Ein relativer Pfad bräche still, sobald Claude Code aus einem Unterverzeichnis startet; `jq` wird nur für `sessionTitle` gebraucht und fehlt es, fällt der Hook auf reines stdout zurück, das bei `SessionStart` ohnehin als Kontext übernommen wird. Warum überhaupt ein Hook: ein Skill kann sich nicht selbst auslösen, und `initialUserMessage` gilt belegt nur unter `-p`.
- README (Root und `cmd/`), `DESIGN.md`, `examples/transcripts.md`, `scripts/smoke.sh` und beide Manifest-`description`s um den siebten Skill erweitert; Reihenfolge zu `project-rules` (erst importieren, dann verdichten) in `cmd/README.md` festgehalten.

## 0.6.0

- **Neuer Skill `session-handoff`:** verdichtet den laufenden Arbeitsstand in eine kurze `HANDOFF.md` (Obergrenze 60 Zeilen), damit ein frisches Fenster ohne den bisherigen Verlauf weiterarbeiten kann. Belegt den Stand am beobachteten Projektzustand statt am Gedächtnis und nennt uncommittete, ungetestete und nebenläufige Stände ausdrücklich. Gibt es keinen tragfähigen Stand, schreibt er **keine** Datei.
- **Eigener Abschnitt „Unsicher"** in der Übergabedatei (Vermutung, Quelle, Prüfweg). Der Skill läuft definitionsgemäß auf einem gekürzten Verlauf; sein gefährlichster Fehler ist die glatte Übergabe, deren Lücken das nächste Fenster nicht bemerken kann. Sein Fehlen behauptet, es sei nichts unsicher gewesen.
- **Schreibt ohne Plan und ohne Rückfrage** — der Aufruf ist die Freigabe, weil eine Rückfrage genau den Zug kostet, für den der Kontext nicht mehr reicht. Als Gegengewicht nennt er den Rückweg, sobald er eine Datei angelegt oder überschrieben hat, und sichert eine untrackte Datei vorher als `.bak`. Abgrenzung zu `plan-execute` in `DESIGN.md`.
- **Endet bei der Datei:** kein neues Fenster, keine neue Session, kein Shell-Skript, keine IDE-Annahme.
- **Headless-Testgrenzen dokumentiert:** `claude -p` hat keinen Gesprächsverlauf und erlaubt ohne `--permission-mode acceptEdits` kein `Write`. `scripts/smoke.sh` prüft deshalb nur den nebenwirkungsfreien Zweig, damit der Test keine Datei ins Arbeitsverzeichnis legt. Ob ein Plugin geladen ist, gehört objektiv geprüft (`--output-format stream-json`, `system/init`); die Selbstauskunft des Modells über seine Skill-Liste ist headless unzuverlässig.
- README (Root und `cmd/`), `DESIGN.md`, `examples/transcripts.md` und beide Manifest-`description`s um den sechsten Skill erweitert; Arbeitsteilung der beiden `session-*`-Skills nach Haltbarkeit (dauerhaft vs. flüchtig) in `cmd/README.md` beschrieben.

## 0.5.0

- **Neuer Skill `session-learn`:** reflektiert die laufende Session, leitet dauerhafte, belegbare Learnings für künftige Sessions ab, routet jedes an den passenden **projektlokalen** Ort (Projekt-CLAUDE.md / `references` / Repo, nie user-global; Memory-System unangetastet) und erzeugt daraus einen Plan, den `plan-review` härtet und `plan-execute` anwendet — schreibt selbst nichts an die Zielorte.
- README: fünfter Skill in Liste/Pipeline/Struktur; Präfix-Logik (`plan-*`/`project-*`/`session-*`) notiert.
- `examples/transcripts.md` und `scripts/smoke.sh` um `session-learn` erweitert.
- **Vorbereitung der Veröffentlichung:** Root-`README.md` mit Installationsanleitung, `DESIGN.md` (ausgelagerte Entwurfsnotizen), `LICENSE` (MIT); `cmd/README.md` als reine Nutzerdoku neu geschrieben (Struktur-Block um die `references/` korrigiert); Manifeste um `homepage`, `repository`, `license` und `keywords` ergänzt, Autor-E-Mail entfernt; `.gitignore` um `.claude/settings.local.json`.

## 0.4.0

- **plan-execute gehärtet:** Fallback für fehlendes Verifikationskriterium (schwächstes hinreichendes ableiten, sonst als erledigt-ohne-unabhängige-Verifikation melden); Fortschrittsliste tool-agnostisch; definierter End-/Commit-Zustand im Abschlussbericht; Auto-mode-Degradation klargestellt (läuft auch außerhalb Auto mode, dann mit Prompts).
- **Single-Sourcing:** Auto-mode-Detailverhalten nach `cmd/skills/plan-execute/references/auto-mode.md` ausgelagert (bedarfsgeladen, spart Kontext im Normalfall).
- **README:** Pipeline-Vertrag (grill→/plan→review→execute, inkl. execute-Abhängigkeit von Per-Schritt-Kriterien) und Konventionen-Glossar (geteiltes Vokabular plus die absichtlichen Divergenzen) ergänzt.
- **grill-Schreibsperre:** belegt, warum weder `disallowed-tools` (verfällt nach der nächsten Nachricht) noch ein Hook (keine dokumentierte skill-genaue Bedingung; pauschal bräche er review/execute) sie halten können — die Sperre trägt allein die Body-Prosa.
- **Verhaltens-Verifikation:** `scripts/smoke.sh` (Eröffnungszug je Skill) und `examples/transcripts.md` (erwartete Form der vollen Flows).

## 0.3.1

- plan-grill/plan-review: unterschiedlicher Umgang mit dem Ergebnis explizit gemacht (grill übergibt an `/plan`, review arbeitet in den bestehenden Plan ein); README-Kontrast-Absatz zur Regel „existiert schon ein Plan?".

## 0.3.0

- Ausgangsstand dieses Changelogs.
