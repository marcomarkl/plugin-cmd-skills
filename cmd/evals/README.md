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
- **Acht Fälle, sechs messbar.** `project-structure` und `session-resume` tragen `braucht-bash` und laufen nicht, solange der Docker-Credential-Store der Maschine einen Symlink enthält; die Läufe filtern deshalb mit `--tag messbar`.
- **Fünf Skills haben keinen Fall.** `plan-grill`, `plan-review` und `plan-execute` hängen an Harness-Zuständen, die ein Lauf nicht herstellt; `session-learn` und `session-handoff` an einem Gesprächsverlauf, ohne den sie nach eigener Regel ehrlich leer bleiben.
- **Der Plan-Modus fehlt.** Ein Fall, dessen Skill einen Plan erzeugt, misst die Schlussnotiz statt der Plandatei und weist den Lauf im Prompt an, `EnterPlanMode` zu überspringen.
- **Grader prüfen per Default die letzte Chat-Nachricht.** Das Produkt der meisten Skills ist eine Datei, deshalb steht bei jedem Grader ausdrücklich, was er prüft: `target: { source: file, path: … }`, `target: trace` oder die Antwort.
- **`tool_used` mit nur `max: 0`** wird als `1..0` gelesen und ist unerfüllbar. Wer „ruft dieses Tool nie auf" prüfen will, setzt `min: 0` dazu.

Ergebnisse liegen unter `results/` und sind per `.gitignore` ausgenommen.
