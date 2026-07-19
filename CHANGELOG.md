# Changelog

Versionen des `cmd`-Plugins. Quelle der Wahrheit für die Versionsnummer ist `cmd/.claude-plugin/plugin.json`.

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
