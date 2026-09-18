# Beispiel — ein vollständiger Bericht mit aufgehender Bilanz

Diese Datei zeigt die **Form** eines fertigen Berichts an einem erfundenen Projekt. Sie ist Arbeitsanweisung an dich, kein Zieltext: Nichts hieraus wird in eine Projektdatei kopiert. Sie lädt selbst keine weitere Datei.

Das Beispiel ist ein TypeScript-Monorepo, das Wetterdaten importiert. Entscheidend daran ist die Bilanz: Sie geht Zeile für Zeile auf, und die entfallenen Strukturzeilen stehen einzeln da, nie als Sammelposten.

```
## Struktur: wetterdaten-import
Kanon-Abgleich: 3 übernommen / 0 umbenannt / 3 angelegt / 1 weggelassen

### Vorgefunden und übernommen
- Aufgaben → GitHub Issues (maßgeblich, unverändert)
- Wissen → docs/ (maßgeblich, unverändert)
- Erledigtes → CHANGELOG.md und git-Historie (maßgeblich, unverändert)

### Umbenannt
- keine

### Angelegt
- docs/decisions/ — Grund: zwei Architekturentscheidungen lagen bisher in NOTES.md · Rückweg: `rmdir docs/decisions`
- backlog/tasks/ — Grund: fünf offene Punkte aus TODO.md, tool-gebundener Pfad, ausdrücklich zugestimmt · Rückweg: `rmdir backlog/tasks`
- .claude/skills/anbieter-anbinden/ — Grund: der siebenschrittige Ablauf aus der CLAUDE.md, dreimal in der Historie durchgeführt · Rückweg: `rmdir` nach Entfernen der SKILL.md

### Verschoben
- CLAUDE.md#Neuen Anbieter anbinden, Zeilen 96–123 → .claude/skills/anbieter-anbinden/SKILL.md (28) · Rückweg: `git restore CLAUDE.md`

### Aufgeteilt
- NOTES.md → docs/wetterdaten-import.md (38) + docs/decisions/0001-datenmodell.md (21)
- TODO.md → backlog/tasks/task-001-…md bis task-005-…md (20)

### Geblieben
- NOTES.md, Zeilen 1–5 — Grund: Kopfzeilen mit Projektbezug, tragen keine eigene Aussage über die Ziele hinaus, aber auch keine Entsprechung im Ziel

### Entfallene Strukturzeilen
- NOTES.md:7 „## Sammlung" — ersetzt durch docs/wetterdaten-import.md:1 „# Wetterdaten-Import"
- NOTES.md:23 „---" — ersetzt durch die Abschnittsgrenze in docs/wetterdaten-import.md:19
- NOTES.md:41 „## Offene Gedanken" — ersetzt durch docs/decisions/0001-datenmodell.md:5 „## Kontext"
- NOTES.md:58, 59 (leer) — ersetzt durch den Absatzumbruch in docs/decisions/0001-datenmodell.md:12
- TODO.md:1 „# TODO" — ersetzt durch die fünf Dateinamen unter backlog/tasks/
- TODO.md:9 „---" — ersetzt durch die Dateigrenze
- TODO.md:22 (leer) — ersetzt durch das Frontmatter-Ende in task-005

### Artefakte vorgeschlagen
- Skill .claude/skills/anbieter-anbinden/SKILL.md — Anlass: konkret aus diesem Projekt, der Ablauf steht dreimal in der git-Historie · angelegt
- Subagent — Anlass: aus Anhaltspunkten (Testlauf mit rund 4.000 Zeilen Ausgabe), unbestätigt · abgelehnt, die Ausgabe ist bereits gefiltert

### Offen
- Die Umbenennung von docs/ nach documentation/ wurde vorgeschlagen und abgelehnt; docs/ gilt für dieses Projekt als kanonisch

### Bilanz
229 = 107 (in Zielen) + 114 (verblieben) + 8 (entfallene Strukturzeilen) — jede Quelle verbucht.
Zweiter Lauf ohne zwischenzeitliche Änderung: diff-frei.
```

Der Wegweiser `## Ablage` kommt mit sechs Zeilen neu in die `CLAUDE.md`; er ist eine Ergänzung und keine Verschiebung und steht deshalb außerhalb der Bilanz.
