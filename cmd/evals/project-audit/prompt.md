---
name: project-audit
runs: 3
max_turns: 60
timeout_seconds: 1200
allowed_tools: [Read, Glob, Grep]
---

Lies `skills/project-audit/SKILL.md` und arbeite genau nach dieser Anweisung. Das zu pruefende Projekt liegt in `proj/`.

Zwei Vorgaben zur Umgebung, damit du nicht daran haengen bleibst:
- Der Plan-Modus steht hier nicht zur Verfuegung. Ruf `EnterPlanMode` nicht auf; gib die Befunde stattdessen vollstaendig in der Schlussnotiz aus, in der Form, die der Skill dafuer vorsieht.
- Aendere keine Datei. Der Skill schreibt ohnehin an keinen Zielort.

Arbeite den Ablauf bis zur Schlussnotiz durch.
