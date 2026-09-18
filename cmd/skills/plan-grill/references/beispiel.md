# Beispiel — eine vollständige Schlussnotiz

Diese Datei zeigt die **Form** der Schlussnotiz an einem erfundenen Vorhaben. Sie ist Arbeitsanweisung an dich, kein Zieltext: Nichts hieraus wird in eine Plandatei kopiert, und keine Entscheidung daraus gilt für das Vorhaben, das du gerade klärst. Sie lädt selbst keine weitere Datei.

Das Beispiel klärt die Umstellung eines Wetterdaten-Imports von stündlichem Polling auf Webhooks. Entscheidend daran: Der Block trägt ohne den Interviewverlauf, die Vorläufigen stehen getrennt von den Bestätigten, und die nicht gefragten Entscheidungen nennen ihren Default samt Grund.

```
## Ziel
Der Wetterdaten-Import empfängt Aktualisierungen künftig per Webhook statt sie stündlich abzufragen, ohne dass Lücken entstehen, wenn der Anbieter einen Aufruf verliert.

## Bestätigte Entscheidungen, als Vorgaben
1. Der Webhook-Empfänger läuft im bestehenden Service, nicht als eigener Dienst.
2. Polling bleibt als Rückfall bestehen, getaktet auf sechs Stunden statt einer.
3. Zustellungen werden über die Ereignis-ID entdoppelt; die ID kommt vom Anbieter.
4. Ein verlorener Webhook wird beim nächsten Polling-Lauf still nachgeholt, ohne Alarm.
5. Die Umstellung läuft je Anbieter, beginnend mit dem kleinsten.

## Nicht gefragte Entscheidungen, mit Default und Grund
- Signaturprüfung nach dem Verfahren des Anbieters: ohne Alternative, jeder Anbieter schreibt eines vor.
- Die Webhook-Route liegt unter dem bestehenden Präfix `/hooks`: ändert am Ergebnis nichts.

## Vorläufig, zur Bestätigung
- V1: Die Aufbewahrung der Roh-Ereignisse steht auf 30 Tagen. Antwort war „weiß nicht", die Empfehlung ist eingetragen; entscheidet sich an der Frage, ob ein Nachlauf über einen Monat hinaus je gebraucht wurde.

## Offene Punkte für den Plan
- Ob der Anbieter Zustellungen bei 5xx wiederholt, steht in seiner Doku nicht; im Faktenvorlauf nicht belegbar gewesen.
- Der Lasttest für gleichzeitige Zustellungen fehlt noch und gehört als eigener Schritt in den Plan.

## Entscheidungs-Ledger
| # | Entscheidung | Gewählt | Kurzbegründung | Status |
|---|---|---|---|---|
| 1 | Eigener Dienst oder bestehender Service | bestehender Service | kein Betriebs-Overhead für einen Endpunkt | bestätigt |
| 2 | Polling abschalten oder behalten | behalten, sechs Stunden | deckt verlorene Zustellungen ohne Alarmkette ab | bestätigt |
| 3 | Entdoppelung über Ereignis-ID oder Zeitstempel | Ereignis-ID | Zeitstempel kollidieren bei Nachlieferungen | bestätigt |
| 4 | Alarm bei verlorenem Webhook | kein Alarm, stilles Nachholen | Entscheidung 2 fängt den Fall bereits | bestätigt |
| 5 | Reihenfolge der Anbieter | kleinster zuerst | begrenzt den Schaden eines Fehlversuchs | bestätigt |
| 6 | Aufbewahrung der Roh-Ereignisse | 30 Tage | Empfehlung, Antwort war „weiß nicht" | vorläufig |
```

Danach folgt die Bitte um Bestätigung, dass das Verständnis gemeinsam ist — und erst nach ihr die Plandatei.
