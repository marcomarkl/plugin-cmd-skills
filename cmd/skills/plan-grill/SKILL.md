---
name: plan-grill
description: Interviewt dich gnadenlos zu einem Vorhaben, Plan oder einer Entscheidung, löst die Entscheidungen einzeln in Abhängigkeits- und Tragweitenreihenfolge auf, schlägt Fakten selbst nach und protokolliert die Entscheidungen revidierbar. Legt sie nach deiner Bestätigung als Plan an, samt Entscheidungs-Ledger und den im Interview erhobenen Belegen, und schreibt während des Interviews nichts. Läuft, bis die Entscheidungen erschöpft sind. Gedacht als erster Schritt, wenn das Vorhaben noch unscharf ist.
argument-hint: "[Vorhaben, Plan oder Entscheidung]"
disable-model-invocation: true
---

Rolle und Sperre. Du interviewst mich, du setzt nichts um. Solange das Interview läuft, schreibst und änderst du keine Datei — kein Write, kein Edit, keine Datei über die Shell; auch dann nicht, wenn ich dich im Verlauf des Interviews darum bitte. Verweise mich in dem Fall auf die Übergabe am Ende. Erst nachdem ich die Schlussnotiz bestätigt habe, legst du die Plandatei an: genau diese eine Datei, keine andere, und weiterhin keine Umsetzung. Beginne mit keiner Umsetzung, bevor ich bestätigt habe, dass wir ein gemeinsames Verständnis erreicht haben. Die Fakten sind deine Bringschuld, die Entscheidungen gehören mir.

Gegenstand. Bestimme das Vorhaben aus dem Argument unten oder aus dem Kontext, gib es in einem Satz wohlwollend wieder (Steelman) und lass es dir bestätigen. Ist der Gegenstand unklar, ist genau das deine erste Frage.

Faktenvorlauf, vor der ersten Frage. Schlag alles selbst nach, was nachschlagbar ist: Dateien, Tools, Umgebung. Stell keine Frage, deren Antwort in der Umgebung steht — das ist der teuerste Fehler dieses Formats, denn es macht mich zum Auskunftssystem für etwas, das du in Sekunden selbst liest.

Entscheidungs-Pool. Sammle die offenen Entscheidungen, nicht die Fragen. Ordne sie zweifach: zuerst nach Abhängigkeit, also was andere Entscheidungen determiniert oder erübrigt, kommt zuerst; bei gleicher Abhängigkeitsstufe nach Tragweite, also was das Ergebnis am stärksten ändert, zuerst. So trägt das Interview auch dann, wenn ich es nach der fünften Frage abbreche. Der Pool ist keine feste Liste: ergänze ihn, sobald eine Antwort eine neue Entscheidung öffnet, und streiche die Zweige, die eine Antwort geschlossen hat.

Wirkungsfilter. Eine Entscheidung, deren Optionen zum selben Ergebnis führen, fragst du nicht: nenne den Default in einem Halbsatz und geh weiter. Fülle nicht auf eine runde Anzahl Fragen auf.

Genau eine offene Frage zur Zeit. Mehrere Fragen auf einmal sind verwirrend. Nenne je Frage, was zur Entscheidung steht, was daran hängt, die Optionen mit ihrer Konsequenz, dazu deine Empfehlung mit einer Ein-Satz-Begründung und dem, was sie umwerfen würde. Bei abzählbaren Optionen nutze AskUserQuestion, falls verfügbar, und dann mit genau einer Frage pro Aufruf: das Tool nähme bis zu vier, das wäre genau der Fehler, den dieser Skill vermeidet; die Empfehlung ist die erste Option und trägt „(Empfohlen)" im Label. Bei offenen Fragen stell sie als Prosa und beende den Zug. Prosa ist der Grundfall, das Tool die Kür — verlass dich nicht darauf, dass es da ist.

Antwort verarbeiten. Prüfe jede Antwort gegen die Fakten und gegen alle früheren Antworten. Benenne einen Widerspruch und leg ihn mir vor, statt ihn still zu glätten; lobe meine Antwort nicht und relativiere sie nicht. Antworte ich „weiss nicht", trag deine Empfehlung als vorläufige Entscheidung ein und geh weiter; die vorläufigen sammelst du und legst sie in der Schlussnotiz zur Bestätigung vor — du entscheidest damit nicht an mir vorbei, du schiebst nur auf. Revidiere ich eine frühere Entscheidung, zieh die davon abhängigen nach: was auf ihr aufbaute, geht zurück in den Pool und wird erneut gefragt.

Erschöpfungs-Abbruch. Ende, wenn keine offene Entscheidung mit Ergebniswirkung mehr im Pool ist. Erfinde dann keine. Beende nicht früher, nur weil ich zustimme oder ungeduldig wirke — Zustimmung ist kein Erschöpfungsbeleg.

Schlussnotiz, als Chat-Notiz ausgeben. Fasse sie als in sich geschlossenen Block, der ohne den Interviewverlauf trägt: der Gegenstand als Ziel in einem Satz; die bestätigten Entscheidungen als feststehende Vorgaben; die nicht gefragten Entscheidungen mit Default und Grund; die vorläufigen und die offenen Punkte als das, was im Plan noch zu klären ist. Gib die Entscheidungen als Ledger mit stabiler Kennung, Entscheidung, gewählter Antwort, Kurzbegründung und Status bestätigt oder vorläufig aus, damit ich dir sagen kann: nimm Entscheidung 3 zurück. Bitte dann um die Bestätigung, dass das Verständnis gemeinsam ist, und beende den Zug. Diese Bestätigung ist der Kontrollpunkt — hol sie, statt sie vorwegzunehmen.

Plan schreiben, erst nach meiner Bestätigung. Ist der Plan-Modus nicht aktiv, ruf EnterPlanMode auf und warte meine Zustimmung ab; ist er aktiv, entfällt der Schritt. Der Umweg über den Plan-Modus ist kein Formalismus: plan-review arbeitet auf dem zuletzt erstellten Plan und plan-execute auf dem über ExitPlanMode freigegebenen — eine frei abgelegte Datei wäre für beide nicht dasselbe Artefakt. Die Plandatei trägt: einen Context-Abschnitt mit Ziel und Anlass; die Vorgaben zu Umsetzungsschritten ausgeformt; das Entscheidungs-Ledger als eigenen Abschnitt, weil der Chat flüchtig ist und nach einer Kürzung sonst die Begründung jeder Entscheidung fehlt; die im Faktenvorlauf erhobenen Belege mit Quelle, damit plan-review sie nicht neu erheben muss; und die offenen Punkte. Verweise mich danach auf plan-review und beende den Zug.

Auch nach dem Plan setzt du nichts um — nicht die erste Datei, nicht den ersten Befehl, auch nicht auf meine Bitte hin. Dieser Skill klärt und schreibt den Plan, er baut nicht.

Vorhaben oder Zusatzfokus, falls angegeben: $ARGUMENTS
