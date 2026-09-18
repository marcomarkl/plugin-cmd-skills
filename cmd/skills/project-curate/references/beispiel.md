# Beispiel — ein vollständiges Verdichtungsprotokoll

Diese Datei zeigt die **Form** eines fertigen Protokolls an einem erfundenen Projekt. Sie ist Arbeitsanweisung an dich, kein Zieltext: Nichts hieraus wird in die kuratierte Datei kopiert. Sie lädt selbst keine weitere Datei.

Das Beispiel setzt den Lauf aus dem Protokoll von `project-rules` fort: dieselbe `CLAUDE.md` eines TypeScript-Monorepos, nach der Härtung 138 Zeilen lang. Entscheidend daran ist, dass die Maß-Zeile gemessene Werte nennt und dass „Unangetastet geblieben" je Eintrag den Grund trägt.

```
## Kuratiert: CLAUDE.md
Maß: 138 → 116 Zeilen · 9.340 → 7.610 Zeichen
Marken: aus dem Protokoll von project-rules
Schreibweise: gezielt editiert

### Zusammengeführt
- Tests vor dem Commit: „Vor dem Commit `pnpm test --filter <paket>`" und „Änderungen testen, bevor committet wird" → eine Fassung, am Ort „Arbeitsweise"
- Geheimnisse: die Regel zum API-Schlüssel stand in „Sicherheit" und in „Arbeitsweise" → eine Fassung, am Ort „Sicherheit"

### Gekürzt
- Kopfabsatz: „Bitte arbeite stets gewissenhaft" — Floskel ohne prüfbaren Gehalt
- Arbeitsweise: „Das Projekt nutzt pnpm, TypeScript 5 und Vitest" — aus package.json ableitbar
- Kommunikation: der erklärende Satz vor dem Originalblock von vier auf einen Satz

### Faktisch gemacht
- vorher vage „Halte die Importadapter konsistent" → jetzt prüfbar „Jeder Adapter implementiert `fetch`, `normalize` und `validate`; fehlt eine Methode, schlägt `pnpm test --filter adapters` fehl"

### Unangetastet geblieben
- Messwerte altern an der Turn-Grenze, samt Unbekannt-Klausel — Grund: Marke aus ausfuehrungsdisziplin.md
- Die drei Ausnahmen der Auslagerung — Grund: Marke aus kontextdisziplin.md
- Englischer Block zur Antwortlänge samt deutschem Einleitungssatz — Grund: Originalblock, Wirkung hängt am Wortlaut
- „Bei einem 429 des Anbieters erst die Drosselung klären, dann erneut versuchen" — Grund: Vorbehalt bei korrektheitskritischer Arbeit

### Auslagerungsreif markiert (nicht verschoben)
- Der Abschnitt „Fehlerbilder der Anbieter-APIs" (19 Zeilen, situativ) → `.claude/rules/adapter.md` mit `paths: ["packages/adapters/**"]`

### Pflegeregel
verankert unter „Arbeitsweise", drei Zeilen aus Teil B
```

Weil unter „Auslagerungsreif markiert" ein Eintrag steht und `## Ablage` bereits in der Datei steht, folgt keine erneute Empfehlung von `/cmd:project-structure`, sondern die Entscheidungsfrage an den Nutzer: Der Block gehört nach `.claude/rules/adapter.md`, dorthin wurde er beim letzten Lauf nicht gelegt — soll er?
