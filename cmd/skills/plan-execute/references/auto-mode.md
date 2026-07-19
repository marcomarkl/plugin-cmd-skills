# Auto mode — Detailverhalten bei Blockaden

Gilt, sobald der Sicherheitsklassifikator im Auto mode einen Schritt blockiert. Grundregel: die Blockade nie umgehen, keinen Trick, keinen Umweg.

- **Anhalten statt erzwingen:** Halte nur den betroffenen Schritt an, stelle dem Nutzer die Frage und beende den Zug, bis er freigibt oder anweist. Klar unabhängige Schritte setzt du fort.
- **Unbeaufsichtigte Session:** Kommt keine Antwort, wird der blockierte Schritt zum offenen Blocker und am Ende gelistet — nie umgangen und nie erzwungen.
- **Geschützte Verzeichnisse:** Schreibzugriffe auf geschützte bzw. werkzeug- und IDE-eigene Verzeichnisse (etwa `.git` oder `.claude`) werden auch im Auto mode nicht automatisch freigegeben, sondern gehen an den Klassifikator. Das ist erwartet.
- **Riskante Löschungen** im Wurzel- oder Home-Verzeichnis verlangen weiterhin eine manuelle Freigabe. Auch das ist erwartet.
- **Eskalation:** Eskaliert die Session dabei an den Nutzer, brich sauber ab und berichte den Stand, statt die Grenze zu unterlaufen.
