# Beispiel — eine vollständige Schlussnotiz

Diese Datei zeigt die **Form** der Schlussnotiz an einem erfundenen Projekt. Sie ist Arbeitsanweisung an dich, kein Zieltext: Nichts hieraus wird in eine Projektdatei kopiert, und kein Befund daraus gilt für das Projekt, das du prüfst. Sie lädt selbst keine weitere Datei.

Das Beispiel prüft ein TypeScript-Monorepo, das Wetterdaten importiert und vor einem Jahr schon einmal gehärtet wurde. Entscheidend daran: Jeder Befund nennt Datei, Zeile und Klasse, die verworfenen stehen mit Begründung da, und die Beobachtungen ohne Klasse sind von den Befunden getrennt.

```
## Geprüfter Bestand
CLAUDE.md (138 Zeilen) · packages/adapters/CLAUDE.md (24) · .claude/skills/anbieter-anbinden/SKILL.md (61)
· .claude/rules/adapter.md (18) · .claude/agents/log-sichter.md (22) · .claude/settings.json (nur gelesen, ein UserPromptSubmit-Hook)
Nicht geprüft: packages/*/src — kein Prompttext.

## Befunde, als Plan angelegt
| Kennung | Datei:Zeile | Klasse | Wortlaut | Vorschlag | Schwere |
|---|---|---|---|---|---|
| A1 | CLAUDE.md:44 | A, Verifikations-Scaffolding | „## Vor „fertig" verifizieren" samt „Erkläre nichts für erledigt, ohne es zu prüfen." | Abschnitt entfernen; die Zeile „Behaupte keine Prüfung, keinen Test und keinen Schritt, den du nicht tatsächlich durchgeführt hast" wandert unter „Arbeitsweise", und „pnpm test --filter vor dem Commit, Exit 0 erwartet" bleibt, weil das Kriterium von außen kommt | Hoch |
| A2 | CLAUDE.md:51 | A | „Verifiziere jede Teilaufgabe gegen ihr Kriterium, bevor du zur nächsten gehst, statt erst am Ende." | entfernen | Mittel |
| B1 | .claude/skills/anbieter-anbinden/SKILL.md:18 | B, wiederholte Selbstprüfung | „Prüfe das Ergebnis noch einmal, bevor du antwortest." | entfernen | Mittel |
| C1 | CLAUDE.md:12 | C, Anti-Formatierungsregel | „Antworte immer in Fließtext, ohne Aufzählungen und ohne Überschriften." | ersetzen durch die inhaltsgebundene Fassung aus dem Beleg | Hoch |
| D1 | .claude/agents/log-sichter.md:9 | D, Denk-Wiedergabe | „Gib deinen Denkprozess im Antworttext wieder, damit ich ihn nachvollziehen kann." | ersetzen durch „Nenne die Begründung deines Ergebnisses"; die Klasse trifft das Wiedergeben des internen Denkens, nicht das Begründen | Blocker |
| E1 | CLAUDE.md:29 | E, Narrations-Unterdrückung | „Melde dich während der Arbeit nicht, berichte erst am Ende." | ersetzen durch eine Kadenz: ein Satz vor dem ersten Tool-Aufruf, kurze Meldung bei Wichtigem, Ergebnis im ersten Satz | Hoch |
| K1 | CLAUDE.md:33 | K, Altlast | „Verfeinere das Verständnis, bis kein Raum für Fehldeutung bleibt." | ersetzen durch die Wesentlichkeitsschwelle: nachfragen nur, wo verschiedene Lesarten zu wesentlich verschiedener Arbeit führen | Mittel |

## Verworfen, mit Begründung
- CLAUDE.md:61 „Vor dem Deploy die Migration gegen die Staging-Datenbank fahren" — sieht nach Klasse A aus, trägt aber ein Kriterium von außen und einen bekannten Fehlerfall. Bleibt.
- .claude/rules/adapter.md:7 „Jeder Adapter implementiert fetch, normalize und validate" — Klasse I erwogen und verworfen: Die drei Namen sind keine Varianten desselben Verhaltens, sondern eine Schnittstelle.
- packages/adapters/CLAUDE.md:14 „Sei besonders sorgfältig bei Zeitzonen" — vage, aber keine Klasse dieses Skills deckt Vagheit ab. Gehört zu /cmd:project-rules, nicht hierher.

## Beobachtungen ohne Klasse
- `.claude/settings.json` trägt einen UserPromptSubmit-Hook, der neben der Systemzeit auch den aktuellen git-Branch ausgibt. Fremdinhalt je Turn im Kontext ist eine Injektionsfläche; das ist kein Leitfaden-Befund, sondern eine Sicherheitsfrage. Geändert wird die Datei von /cmd:project-settings.
- Die `description` von `.claude/agents/log-sichter.md` ist 340 Wörter lang und lädt in jeder Sitzung mit.
- In der nutzerweiten `~/.claude/CLAUDE.md` steht „double-check deine Antworten" (Klasse B). Außerhalb des Projekts, deshalb nicht im Plan: Der Handgriff liegt beim Nutzer.

## Nächster Schritt
Plan angelegt mit sieben Befunden. Härten mit `/cmd:plan-review`, danach anwenden mit `/cmd:plan-execute`.
```

Ein Lauf ohne Befund endet stattdessen mit dem geprüften Bestand, den verworfenen Kandidaten und dem Satz, dass kein Plan entstanden ist.
