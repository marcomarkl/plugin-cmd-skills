# Kontextdisziplin

Die folgenden Regeln richten sich an den später gesteuerten Agenten ("du"), nicht an dich als einsetzende KI; übernimm sie als Inhalt in die Zieldatei. Sie regeln, wie der Agent sein Hauptkontextfenster über lange Aufgaben hinweg schlank hält.

**Verbuchungshinweis an dich — kommt nicht in die Zieldatei.** Dieser Katalog regelt allein, **ob** ausgelagert wird und wo die Grenze liegt; ob aus wiederkehrender Auslagerung ein eigenes Artefakt wird, regelt `projekt-artefakte.md`. Führe beide nicht zusammen und wiederhole die Beispielliste der Teilarbeiten nicht in beiden. Die drei Ausnahmen unter „Verbose Arbeit in separaten Kontext auslagern" werden nicht gekürzt und nicht zusammengezogen, auch nicht beim Kuratieren durch `/cmd:project-curate`: Ohne sie gilt die Auslagerungsregel auch für Arbeit, die eine Rückfrage braucht oder deren Rohmaterial ohnehin in den Hauptkontext muss, und dort übersteigt der Schaden die Ersparnis. Kürzbar sind dagegen die Beispiele der Teilarbeiten.

## Nur einlesen, was nötig ist
- Lies große Dateien und rohe Tool-Ausgaben nicht vollständig ein. Begrenze jeden Read auf den benötigten Bereich und filtere umfangreiche Kommando-Ausgaben, bevor sie in den Kontext gelangen.
- Nutze bei der Suche den schlanksten Ausgabemodus (nur Trefferdateien oder Anzahl), solange der volle Inhalt nicht gebraucht wird.
- Halte vor einer Runde Tool-Aufrufe zunächst für dich fest, was du als Nächstes brauchst, und fordere dann alles in einem Zug an, was nicht auf dem Ergebnis eines anderen Aufrufs aufbaut. Jeder zusätzliche Zug kostet Tokens, eine Laufzeit und eine Runde.
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

Was eine Verdichtung bewahren muss, steht im Wortlaut im Leitfaden „Prompting Claude Fable 5.1" (Abschnitt „Tell the model what to preserve in compaction summaries") und ist deshalb unübersetzt übernommen. Weggelassen ist allein der einleitende Satz des Originals, der die Ausgabe in `<summary>`-Tags verlangt; er richtet sich an eine clientseitige Verdichtung, während hier gilt, **was** zu bewahren ist:

> Be sure to preserve: (1) any difficulties or problems that came up, and how they were handled or resolved; (2) any possibilities, options, or approaches that were raised, tried, or set aside, and why; (3) anything that was asked for, decided, agreed, ruled out, or established as a preference, constraint, or boundary — stated exactly; (4) exactly where things stand now — what has been covered, settled, or completed so far; (5) anything still open, unresolved, promised, or expected to happen next; (6) specific details that would be hard to reconstruct — names, numbers, dates, exact wording, links or references — kept exactly. Be complete on these even at the cost of length; keep everything else concise. Weight the two voices differently: keep what the user said, asked for, shared, or established carefully and close to their own words; your own explanations and reasoning can be condensed much further, to what they concluded or produced — as long as nothing in the six items above is dropped.
