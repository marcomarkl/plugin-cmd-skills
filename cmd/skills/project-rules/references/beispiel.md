# Beispiel — ein vollständiges Änderungsprotokoll

Diese Datei zeigt die **Form** eines fertigen Protokolls an einem erfundenen Projekt. Sie ist Arbeitsanweisung an dich, kein Zieltext: Nichts hieraus wird in die gehärtete Datei kopiert, und keine Regel daraus gilt für das Projekt, an dem du arbeitest. Sie lädt selbst keine weitere Datei.

Das Beispiel ist ein TypeScript-Monorepo, das Wetterdaten importiert, Profil „Software/Coding mit Mensch im Loop". Es zeigt, wie konkret die Einträge sein müssen: jeder nennt Werkzeug, Abschnitt und die im Projekt verankerte Fassung.

```
## Gehärtet: CLAUDE.md
Projektprofil: Software/Coding mit Mensch im Loop (bestätigt: ja)
Prosasprache: de · AGENTS.md/CLAUDE.md-Drift: eine Quelle

### Ergänzt
- Ausführungsdisziplin → Arbeitsweise: Versionen von Wetter-APIs vor dem Nennen per Websuche prüfen, statt sie aus dem Gedächtnis zu setzen
- Fehlerdisziplin → Arbeitsweise: Einen fehlgeschlagenen Import nicht wiederholen, bevor geklärt ist, ob der Anbieter drosselt (429) oder das Schema gewechselt hat
- Kontextdisziplin → Arbeitsweise: `pnpm test` nur mit `--filter` auf das betroffene Paket laufen lassen; ein voller Lauf im Monorepo erzeugt rund 4.000 Zeilen Ausgabe
- Sicherheitsdisziplin → Sicherheit: Der API-Schlüssel steht in `.env.local` und wird nie in Fixtures, Logs oder Testdaten kopiert
- Umfangsdisziplin → Arbeitsweise: Beim Beheben eines Import-Fehlers keine benachbarten Adapter mitrefaktorieren; Nebenbefunde in den Bericht
- Ausgabedisziplin → Kommunikation: Der englische Originalblock zur Antwortlänge, mit deutschem Einleitungssatz davor
- Projekteigene Artefakte → Artefakte: Regel, wann ein eigener Skill fällig wird — beim dritten gleichen Handgriff

### Geschärft
- Ausführungsdisziplin → Arbeitsweise: vorher vage „Teste deine Änderungen" → jetzt testbar „Vor dem Commit `pnpm test --filter <paket>`, erwartet wird Exit 0"
- Ablagedisziplin → Ablage: vorher vage „Dokumentiere Entscheidungen" → jetzt testbar „Entscheidungen als `docs/decisions/NNNN-titel.md`, vierstellig ab 0001"

### Bereits vorhanden / stärker behalten (nicht angefasst)
- Sprachdisziplin: „Bezeichner englisch, Kommentare deutsch" — die vorhandene Fassung nennt zusätzlich Branch-Namen und DB-Spalten und ist damit spezifischer als die Katalogregel (Best-of)
- Sicherheitsdisziplin: „Kein `git push --force` auf `main`" — schon abgedeckt und schärfer als „vor folgenreichen Aktionen bestätigen"

### Bewusst weggelassen
- Sicherheitsdisziplin: MCP-Regeln — Grund: kein MCP-Server im Projekt, keine autonomen Aktionen nach außen
- Kontextdisziplin: Auslagerung an Subagenten — Grund: die Testausgabe ist bereits gefiltert, kein zweiter Kontext nötig

### Konflikte
- vorhanden „Antworte immer ausführlich und erkläre jeden Schritt" ↔ Ausgabedisziplin „Keep responses focused, brief, and concise" → Entscheidung: Katalogfassung, durch Aufsicht; die vorhandene Regel stammte aus der Einarbeitungszeit und ist im Protokoll vermerkt

### Nicht kürzbar — Übergabe an project-curate
- Messwerte altern an der Turn-Grenze, samt Unbekannt-Klausel → Abschnitt „Arbeitsweise": markiert in ausfuehrungsdisziplin.md, wird beim Kuratieren nicht gekürzt
- Die drei Ausnahmen der Auslagerung → Abschnitt „Arbeitsweise": markiert in kontextdisziplin.md
- Englischer Originalblock zur Antwortlänge → Abschnitt „Kommunikation": markiert in ausgabedisziplin.md, bleibt wörtlich

### Ablage und Artefakte
- Vorgefunden: GitHub Issues (Aufgaben), `docs/` (Wissen), `CHANGELOG.md` (Erledigtes), kein Ort für Entscheidungen
- Verankert: Aufgaben → Issues · Wissen → `docs/` · Erledigtes → `CHANGELOG.md` und git-Historie
- Auslagerungsreif markiert (nicht verschoben): Der siebenschrittige Ablauf „Neuen Anbieter anbinden" → eigener Skill unter `.claude/skills/anbieter-anbinden/`
- Empfohlen anzulegen: `docs/decisions/` — Grund: zwei Architekturentscheidungen stehen bisher nur in Issue-Kommentaren

### Abdeckung
Alle zehn Inhalts-Kataloge durchgegangen, jede Regel in genau einer Kategorie verbucht.
```

Danach folgt der Hinweis auf `/cmd:project-curate` als nächsten Aufruf, und — weil unter „Auslagerungsreif markiert" ein Eintrag steht — die Empfehlung, `/cmd:project-structure` laufen zu lassen.
