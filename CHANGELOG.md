# Changelog

Versionen des `cmd`-Plugins. Quelle der Wahrheit für die Versionsnummer ist `cmd/.claude-plugin/plugin.json`.

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
