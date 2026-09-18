# Aufgabenzerlegung

Die folgenden Regeln richten sich an den später gesteuerten Agenten ("du"), nicht an dich als einsetzende KI; übernimm sie als Inhalt in die Zieldatei. Sie sorgen dafür, dass Aufgaben vor der Ausführung geklärt und zerlegt und größere Vorhaben spezifiziert werden.

## Mehrdeutigkeit nach Wirkung klären
- Triff routinemäßige Auslegungsentscheidungen selbst und frag nur dort nach, wo verschiedene Lesarten zu wesentlich verschiedener Arbeit führen. Sonst nenne die gewählte Lesart und arbeite weiter, statt das Verständnis über den Bedarf hinaus zu verfeinern.

## Vor dem Bauen zerlegen
- Zerlege eine nicht-triviale Aufgabe vor der Ausführung in kleinere Teilaufgaben. Eine zu groß angefasste Aufgabe ist eine der häufigsten Fehlerquellen.
- Trenne unabhängige Teile (parallelisierbar, berühren nicht dieselben Dateien) von abhängigen (laufen in Reihenfolge, ein Ergebnis speist das nächste).
- Halte jede Teilaufgabe klein genug, um sie einzeln prüfen zu können.

## Abhängigkeiten und Reihenfolge klären
- Mach Abhängigkeiten explizit: Braucht eine Teilaufgabe das Ergebnis einer früheren, benenne genau, welches.
- Lege die Reihenfolge nach den Abhängigkeiten fest, nicht nach Bequemlichkeit. Bedenke, wie ein Fehler in einem Schritt die folgenden trifft, statt blind weiterzulaufen.
- Prüfe die Zerlegung auf Vollständigkeit: Deckt sie alle Teile des Ziels ab? Selbst erzeugte Zerlegungen lassen leicht Schritte aus.

## Fortschritt verfolgen
- Arbeite die Teilaufgaben in der festgelegten Reihenfolge ab und halte ihren Stand fest (offen, in Arbeit, erledigt), damit über lange Aufgaben nichts verloren geht oder doppelt läuft.

## Bei größeren Vorhaben erst spezifizieren
- Schreibe für ein größeres Vorhaben vor dem Code eine knappe, eigenständige Spezifikation und arbeite gegen sie. Sie ist die gemeinsame Referenz, nicht der erste Prompt.
- Eine brauchbare Spec benennt: das Ziel, die betroffenen Dateien und Schnittstellen, was ausdrücklich nicht zum Umfang gehört, bereits getroffene Entscheidungen sowie Abnahmekriterien mit einer End-to-End-Prüfung, die den Erfolg belegt.
- Ohne expliziten Umfang füllt der Agent Lücken mit eigenen Annahmen und läuft schnell in die falsche Richtung.
- Auch ohne volle Spec: Berühren Änderungen mehrere Dateien, erkläre den Ansatz vorab, bevor du ausführst.

## Spec lebendig halten
- Weicht die Umsetzung von der Spec ab, aktualisiere die Spec und arbeite weiter gegen sie, statt nur den Einzelfall zu flicken. Sonst driften Absicht und Ergebnis auseinander.

## Aufwand richtig dosieren
- Zerlege und spezifiziere nach Bedarf, nicht maximal. Eine kleine, klar umrissene Aufgabe braucht keine eigene Spec; dort kostet der Planungs-Overhead mehr, als er bringt.
- Anhaltspunkt für "größer": mehrere Dateien oder Komponenten, echte Designentscheidungen, mehrdeutiger Umfang oder Arbeit über mehrere Sitzungen. Trifft nichts davon zu, reicht direktes Vorgehen.
