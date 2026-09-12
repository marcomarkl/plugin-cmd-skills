# Kontextdisziplin

Die folgenden Regeln richten sich an den später gesteuerten Agenten ("du"), nicht an dich als einsetzende KI; übernimm sie als Inhalt in die Zieldatei. Sie regeln, wie der Agent sein Hauptkontextfenster über lange Aufgaben hinweg schlank hält.

**Verbuchungshinweis an dich — kommt nicht in die Zieldatei.** Dieser Katalog regelt allein, **ob** ausgelagert wird und wo die Grenze liegt; ob aus wiederkehrender Auslagerung ein eigenes Artefakt wird, regelt `projekt-artefakte.md`. Führe beide nicht zusammen und wiederhole die Beispielliste der Teilarbeiten nicht in beiden. Die drei Ausnahmen unter „Verbose Arbeit in separaten Kontext auslagern" werden nicht gekürzt und nicht zusammengezogen, auch nicht im Token-Effizienz-Pass: Ohne sie gilt die Auslagerungsregel auch für Arbeit, die eine Rückfrage braucht oder deren Rohmaterial ohnehin in den Hauptkontext muss, und dort übersteigt der Schaden die Ersparnis. Kürzbar sind dagegen die Beispiele der Teilarbeiten.

## Nur einlesen, was nötig ist
- Lies große Dateien und rohe Tool-Ausgaben nicht vollständig ein. Begrenze jeden Read auf den benötigten Bereich und filtere umfangreiche Kommando-Ausgaben, bevor sie in den Kontext gelangen.
- Nutze bei der Suche den schlanksten Ausgabemodus (nur Trefferdateien oder Anzahl), solange der volle Inhalt nicht gebraucht wird.
- Was einmal im Kontext liegt, kostet bis zur nächsten Verdichtung auf jedem Schritt erneut. Hol es deshalb gar nicht erst unnötig herein.

## Verbose Arbeit in separaten Kontext auslagern
- Lagere ausgabestarke Teilarbeiten (Exploration, Recherche, Log- und Testauswertung) in einen separaten Kontext aus, statt sie im Hauptkontext anzuhäufen.
- Prüfe dabei zweierlei: ob sich das Ergebnis auf wenige Zeilen samt Dateiverweis verdichten lässt, und ob der Auftrag vollständig übergeben werden kann. Trifft beides zu, lagere aus.
- **Drei Ausnahmen, in denen die Arbeit im Hauptkontext bleibt:** Sie braucht unterwegs eine Rückfrage, denn ein ausgelagerter Lauf kann nicht fragen; ihr Rohmaterial muss ohnehin in den Hauptkontext, denn dann spart die Auslagerung nichts und kostet den Umweg; oder der Auftrag lässt sich nicht abgrenzen, sodass der leere Kontext zu Raten führt.
- Gib einem ausgelagerten Lauf alles Nötige explizit mit: Aufgabe, Pfade, Constraints und den Zielpfad für Ergebnisse. Sein Kontext startet leer; der Prompt ist der einzige Kanal.
- Lass ihn Details in eine Datei schreiben und nur eine Zusammenfassung samt Dateiverweis zurückgeben.

## Untersuchungen eng fassen
- Erkunde nicht ungescoped das ganze Projekt. Benenne konkrete Dateien, Pfade oder Bereiche, statt breit zu explorieren und das Fenster mit irrelevantem Material zu fluten.
- Ist breite Exploration nötig, lagere sie in einen separaten Kontext aus (siehe oben), statt sie im Hauptkontext anzuhäufen.

## Dauerhaften Zustand in Dateien halten
- Halte dauerhafte Regeln und Befunde in Dateien, nicht im Gesprächsverlauf. Eine Verdichtung kann frühe Details aus dem Verlauf verlieren; Dateien überstehen sie.
- Schreibe Zwischenergebnisse laufend in eine Befund- oder Übergabedatei, sodass eine frische Sitzung daran anknüpfen kann, ohne den alten Verlauf mitzuschleppen.

## Wissen bedarfsgeladen ablegen
- Vergrößere die ständig geladene Root-CLAUDE.md nicht mit situativem oder selten gebrauchtem Wissen. Lege es in bedarfsgeladene Mechanismen (projekteigene Skills, pfad-bezogene Regeln, verschachtelte CLAUDE.md), die erst im passenden Kontext laden.
- Formuliere abgelegte Regeln als faktische, überprüfbare Aussagen, nicht als vage Vorgaben.

## Verdichtung bewusst behandeln
- Verlasse dich nicht auf die automatische Zusammenfassung als Speicher. Sie ist verlustbehaftet und verliert frühe Details. Sichere Wichtiges vorher in einer Datei.
- Bewahre bei einer Verdichtung den Arbeitskern: aktuelles Ziel, bearbeitete Dateien, offene Punkte, getroffene Entscheidungen, nächste Schritte.
