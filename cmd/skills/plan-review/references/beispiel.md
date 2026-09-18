# Beispiel — eine vollständige Schlussnotiz

Diese Datei zeigt die **Form** der Schlussnotiz an einem erfundenen Plan. Sie ist Arbeitsanweisung an dich, kein Zieltext: Nichts hieraus wird in den Plan geschrieben, und kein Befund daraus gilt für den Plan, den du gerade reviewst. Sie lädt selbst keine weitere Datei.

Das Beispiel reviewt einen Plan, der einen Wetterdaten-Import von Polling auf Webhooks umstellt. Entscheidend daran: Das Ledger nennt je Befund den betroffenen Planschritt, die verworfenen Befunde stehen mit Begründung da statt zu verschwinden, und eine Runde mit nur geringen Befunden hat die Schleife nicht beendet.

```
## Blickwinkel je Runde
1. Vollständigkeit gegen das Ziel
2. Annahmen und Randfälle
3. Reversibilität und Rückweg
4. Auswirkung auf abhängige Stellen
5. Fehlende Gegenprobe

## Ledger der eingearbeiteten Befunde
| Kennung | Kurzbefund | Schwere | Planschritt |
|---|---|---|---|
| 1.1 | Die Reihenfolge der Anbieter stand im Ziel, aber in keinem Schritt | Hoch | 3 |
| 1.2 | Kein Schritt schaltet das stündliche Polling auf sechs Stunden herunter | Blocker | 5, neu |
| 2.1 | Bei gleichzeitiger Zustellung derselben Ereignis-ID war das Verhalten offen | Hoch | 4 |
| 2.2 | Die Signaturprüfung fehlte für den Fall eines rotierten Schlüssels | Mittel | 4 |
| 3.1 | Kein Rückweg, wenn der Webhook-Endpunkt in Produktion Fehler liefert | Blocker | 7, neu |
| 3.2 | Der Rückweg für die Datenbankmigration war nicht benannt | Hoch | 6 |
| 4.1 | Der Monitoring-Alarm auf „keine Daten seit 90 Minuten" schlägt nach der Umstellung fälschlich an | Mittel | 8, neu |
| 5.1 | Kein Schritt belegt, dass nach der Umstellung dieselben Datensätze ankommen wie vorher | Hoch | 9, neu |

## Verworfen, mit Begründung
- Runde 1: „Der Plan nennt keine Testabdeckung" — der Plan verweist auf die bestehende Suite, eine Zahl wäre hier keine Verbesserung.
- Runde 2: „Zeitzonen der Ereignisse prüfen" — die Normalisierung liegt im Adapter und ist vom Transportweg unberührt.
- Runde 3: „Feature-Flag für die Umstellung" — die anbieterweise Reihenfolge aus Entscheidung 5 leistet dasselbe ohne zusätzlichen Schalter.
- Runde 4: „Rate-Limit des Empfängers" — der Anbieter liefert nach eigener Doku höchstens ein Ereignis je Minute und Station.
- Runde 5: keine verworfenen Befunde.

## Status
Blickwinkel erschöpft nach 5 Runden. Runde 4 brachte nur einen Befund mittlerer Schwere und hat die Schleife nicht beendet.
```

Über die Kennung lässt sich danach gezielt zurücknehmen, etwa: „nimm Änderung 3.1 im Plan zurück".
