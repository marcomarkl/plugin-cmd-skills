# Eval-Suite

**Drei Testartefakte, drei Zuständigkeiten.** Diese Suite besitzt die **Qualität der Ausgabe**: drei Läufe je Fall, deterministische Grader gegen Datei, Verlauf und Antwort, verglichen wird Plugin-Stand gegen Plugin-Stand. Den billigen Ladecheck besitzt `scripts/smoke.sh` (ein Lauf je Skill, Mustervergleich auf den Eröffnungszug), die Form der vollen mehrturnigen Flows besitzt `examples/transcripts.md`.

## Aufrufe

```
claude plugin eval ./cmd --tag messbar --ablation none --max-cost-usd 40 \
  --concurrency 2 --trust-plugin --no-publish --scaffold --allow-tools Write Edit
claude plugin eval ./cmd --case <name> --runs 1 --max-cost-usd 5 \
  --ablation none --concurrency 1 --trust-plugin --no-publish --scaffold --allow-tools Write Edit
```

## Was die Suite messen kann und was nicht

- **Kein Slash-Aufruf.** Der Runner löst einen gesperrten Skill über seinen Slash-Befehl nicht aus. Die Fälle lassen den Skilltext stattdessen **lesen**: Das `fixture.sh` kopiert den `skills/`-Baum in den Workspace, der Prompt nennt den Pfad. Gemessen wird damit immer der Stand des Arbeitsverzeichnisses.
- **Acht Fälle, sechs messbar.** `project-structure` und `session-resume` tragen `braucht-bash` und laufen nicht: Die Bash-Sandbox verweigert den Start, weil der Docker-Credential-Store unter `~/.docker` einen Symlink enthält. Der Lauf bricht bei 0 Turns und 0,00 USD ab. Ein eigenes `DOCKER_CONFIG` hilft nicht, die Prüfung schaut fest auf `~/.docker`. Behandle das als **dauerhaften Umstand dieser Maschine**, nicht als offenen Punkt: Die Läufe filtern mit `--tag messbar`, und die beiden Fälle bleiben als Vorrat liegen, falls sich die Lage ändert.
- **Fünf Skills haben keinen Fall.** `plan-grill`, `plan-review` und `plan-execute` hängen an Harness-Zuständen, die ein Lauf nicht herstellt; `session-learn` und `session-handoff` an einem Gesprächsverlauf, ohne den sie nach eigener Regel ehrlich leer bleiben.
- **Der Plan-Modus fehlt.** Ein Fall, dessen Skill einen Plan erzeugt, misst die Schlussnotiz statt der Plandatei und weist den Lauf im Prompt an, `EnterPlanMode` zu überspringen.
- **Grader prüfen per Default die letzte Chat-Nachricht.** Das Produkt der meisten Skills ist eine Datei, deshalb steht bei jedem Grader ausdrücklich, was er prüft: `target: { source: file, path: … }`, `target: trace` oder die Antwort.
- **Unter `.claude/` kann kein Lauf schreiben.** Der Pfad ist geschützt, die Schutzprüfung läuft **vor** den allow-Regeln, und der Runner arbeitet im `dontAsk`-Modus — der Schreibversuch wird abgelehnt, auch mit `--allow-tools Write Edit`. Am Trace belegt (18.09.2026): `project-settings` erstellt die Vorschau, sichert korrekt zuerst die `.bak` und wird dann abgewiesen. Ein Grader, der eine Datei unter `.claude/` prüft, misst deshalb den Modus des Runners und nicht den Skill; solche Fälle prüfen den Verlauf.
- **`tool_used` mit nur `max: 0`** wird als `1..0` gelesen und ist unerfüllbar. Wer „ruft dieses Tool nie auf" prüfen will, setzt `min: 0` dazu.

Ergebnisse liegen unter `results/` und sind per `.gitignore` ausgenommen.
