---
name: plan-execute
description: Setzt den freigegebenen Plan vollständig um, verifiziert jeden Schritt gegen ein beobachtbares Kriterium, korrigiert Abweichungen selbstständig, hält bei einem Fund ausserhalb des Plans oder einer Klassifikator-Blockade an und fragt nach, und berichtet am Ende. Für Auto mode nach dem Verlassen des Plan-Modus gedacht.
argument-hint: "[optionaler Hinweis zur Ausführung]"
disable-model-invocation: true
model: opus
effort: high
---

Ziel: den freigegebenen Plan vollständig umsetzen und dabei jeden Schritt gegen ein beobachtbares Kriterium prüfen.

Plan-Modus verlassen: Bist du noch im Plan-Modus, rufe ExitPlanMode auf, um den freigegebenen Plan umzusetzen. Zielmodus für die Umsetzung ist Auto mode. Beginne mit der Umsetzung erst, nachdem der Modus verlassen und die Ausführung freigegeben ist.

Quelle: Behandle den freigegebenen Plan als verbindliche, alleinige Quelle. Setze ihn vollständig und in der vorgesehenen Reihenfolge um. Gehe nicht über den Plan hinaus und ergänze nichts, was er nicht vorsieht. Stösst du bei der Umsetzung auf einen substanziellen Punkt ausserhalb des Plans, der bearbeitet gehört, setze ihn weder eigenmächtig um noch verwirf ihn still, sondern stelle dem Nutzer die Frage und pausiere den betroffenen Schritt, indem du den Zug beendest, bis er antwortet; Geringfügiges bleibt weg. Substanziell ist, was die Korrektheit, die Sicherheit oder den Umfang des gelieferten Ergebnisses berührt oder ändern würde, was der Nutzer freigegeben hat. Dies betrifft nur umfangserweiternde Funde ausserhalb des Plans; Abweichungen innerhalb eines Planschritts, die das vorgesehene Ergebnis wahren, behandelst du weiter autonom wie unten unter „Bei Abweichung".

Schritt für Schritt: Halte die Planschritte zu Beginn fest, etwa in einer TodoWrite-Liste, und markiere jeden Schritt erst nach bestandener Verifikation als erledigt, damit der Fortschritt für den Nutzer sichtbar bleibt; diese Liste verfolgt nur den Schrittfortschritt (offen oder erledigt), während das laufende Protokoll (siehe unten) Abweichungen, Ursachen und Korrekturen erfasst. Arbeite jeden Planschritt einzeln ab. Nach jedem Schritt verifiziere das Ergebnis gegen ein beobachtbares Kriterium aus Plan oder Projekt, etwa Testlauf, Build, Exit-Code oder erwarteter Datei- und Ausgabezustand. Behaupte nicht "fehlerfrei", sondern belege den Erfolg jedes Schritts am beobachteten Kriterium.

Bei Abweichung: Weicht das beobachtete vom erwarteten Ergebnis ab, korrigiere selbstständig und fahre fort, ohne zurückzufragen. Halte Abweichung, Ursache und Korrektur je Schritt in einem laufenden Protokoll fest; dieses Protokoll führst du intern und gibst es nur im Abschlussbericht aus, nicht laufend während der Ausführung.

Verhalten in Auto mode: Blockiert der Sicherheitsklassifikator eine Aktion, umgehe die Blockade nicht und suche keinen Trick und keinen Umweg. Halte stattdessen den betroffenen Schritt an, stelle dem Nutzer die Frage und beende den Zug, bis er freigibt oder anweist, statt den Schritt eigenmächtig auf anderem Weg zu erzwingen. Das Anhalten betrifft nur den blockierten Schritt; klar unabhängige Schritte setzt du fort. Läuft die Session unbeaufsichtigt, sodass keine Antwort kommt, wird der blockierte Schritt zum offenen Blocker (siehe unten) und am Ende gelistet — nie umgangen und nie erzwungen. Schreibzugriffe auf geschützte bzw. werkzeug- und IDE-eigene Verzeichnisse (etwa .git oder .claude) werden auch im Auto mode nicht automatisch freigegeben, sondern gehen an den Klassifikator; riskante Löschungen im Wurzel- oder Home-Verzeichnis verlangen weiterhin eine manuelle Freigabe. Beides ist erwartet. Eskaliert die Session dabei an den Nutzer, brich sauber ab und berichte den Stand, statt die Grenze zu unterlaufen.

Nicht behebbarer Blocker: Lässt sich ein Schritt trotz Korrektur nicht erfüllen, überspringe ihn nicht stillschweigend. Vermerke ihn als offenen Blocker mit Begründung, setze die übrigen unabhängigen Schritte fort und liste den Blocker am Ende.

Abschlussbericht als Chat-Notiz: Was je Planschritt umgesetzt wurde. Womit jeder Schritt verifiziert wurde und mit welchem Ergebnis. Welche Abweichungen auftraten und wie du sie korrigiert hast. Welche Aktionen der Klassifikator blockiert hat und wie du reagiert hast. Welche substanziellen Funde ausserhalb des Plans auftraten und wie der Nutzer entschied. An welchen Stellen du wegen einer Blockade angehalten und den Nutzer gefragt oder auf ihn gewartet hast. Etwaige offene Blocker.

Zusatzhinweis zur Ausführung, falls angegeben: $ARGUMENTS
