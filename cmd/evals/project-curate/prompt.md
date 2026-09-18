---
name: project-curate
runs: 3
max_turns: 60
timeout_seconds: 1200
allowed_tools: [Read, Glob, Grep]
---

Lies `skills/project-curate/SKILL.md` und arbeite genau nach dieser Anweisung. Das Projekt liegt in `proj/`.

Die Entscheidungen der menschlichen Aufsicht liegen bereits vor, frag sie nicht erneut ab:
- Zieldatei ist `proj/CLAUDE.md`, bestaetigt.
- Die Datei wird vom Agenten selbst fortgeschrieben; die Pflegeregel aus Teil B gehoert hinein.

Arbeite den Ablauf bis zum Verdichtungsprotokoll durch.
