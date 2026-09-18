# Vorlage für das Änderungsprotokoll

Diese Datei gehört zu Schritt 8 von `/cmd:project-rules`. Sie ist **Arbeitsanweisung an dich**: die Form der Ausgabe, nicht Zieltext für die gehärtete Datei. Die Regeln dazu, was in der Abdeckungszeile stehen darf und wann `/cmd:project-structure` empfohlen wird, stehen im Skill-Body.

```
## Gehärtet: <Pfad zur maßgeblichen Datei>
Projektprofil: <gewähltes Profil> (bestätigt: ja/nein)
Prosasprache: <de/en> · AGENTS.md/CLAUDE.md-Drift: <eine Quelle / Symlink vorgeschlagen / n/a>

### Ergänzt
- <Werkzeug> → <Abschnitt>: <Regel in Kurzform, im Projekt verankert>

### Geschärft
- <Werkzeug> → <Abschnitt>: <vorher vage „…" → jetzt testbar „…">

### Bereits vorhanden / stärker behalten (nicht angefasst)
- <Werkzeug>: <Regel> — schon abgedeckt bzw. vorhandene Fassung war stärker (Best-of)

### Bewusst weggelassen
- <Werkzeug>: <Regel> — Grund: <… / ableitbar aus Code / Projekt braucht es nicht>

### Konflikte
- <vorhanden> ↔ <Katalog> → Entscheidung: <…> (durch Aufsicht / Fallback strenger)

### Nicht kürzbar — Übergabe an project-curate
- <Regel> → <Abschnitt in der Zieldatei>: markiert in <Katalog>, wird beim Kuratieren nicht gekürzt

### Ablage und Artefakte
- Vorgefunden: <Orte aus der Inventur, je Zweck der maßgebliche>
- Verankert: <welcher Zweck zeigt auf welchen Pfad>
- Auslagerungsreif markiert (nicht verschoben): <Block → vorgesehenes Ziel>
- Empfohlen anzulegen: <Ort/Artefakt> — Grund: <…>

### Abdeckung
Alle zehn Inhalts-Kataloge durchgegangen, jede Regel in genau einer Kategorie verbucht.
```
