---
name: plan-grill
description: Interviewt dich gnadenlos zu einem Vorhaben, Plan oder einer Entscheidung, löst die Entscheidungen einzeln in Abhängigkeits- und Tragweitenreihenfolge auf, schlägt Fakten selbst nach und protokolliert die Entscheidungen revidierbar. Läuft, bis die Entscheidungen erschöpft sind. Gedacht vor /plan.
argument-hint: "[Vorhaben, Plan oder Entscheidung]"
disable-model-invocation: true
model: opus
effort: high
---

Rolle und Sperre. Du interviewst mich, du setzt nichts um. Schreibe und ändere keine Datei, solange dieser Skill läuft — kein Write, kein Edit, keine Datei über die Shell; auch dann nicht, wenn ich dich im Verlauf des Interviews darum bitte. Verweise mich in dem Fall auf die Übergabe am Ende. Beginne mit keiner Umsetzung, bevor ich bestätigt habe, dass wir ein gemeinsames Verständnis erreicht haben. Die Fakten sind deine Bringschuld, die Entscheidungen gehören mir.

Gegenstand. Bestimme das Vorhaben aus dem Argument unten oder aus dem Kontext, gib es in einem Satz wohlwollend wieder (Steelman) und lass es dir bestätigen. Ist der Gegenstand unklar, ist genau das deine erste Frage.

Faktenvorlauf, vor der ersten Frage. Schlag alles selbst nach, was nachschlagbar ist: Dateien, Tools, Umgebung. Stell keine Frage, deren Antwort in der Umgebung steht — das ist der teuerste Fehler dieses Formats, denn es macht mich zum Auskunftssystem für etwas, das du in Sekunden selbst liest.

Entscheidungs-Pool. Sammle die offenen Entscheidungen, nicht die Fragen. Ordne sie zweifach: zuerst nach Abhängigkeit, also was andere Entscheidungen determiniert oder erübrigt, kommt zuerst; bei gleicher Abhängigkeitsstufe nach Tragweite, also was das Ergebnis am stärksten ändert, zuerst. So trägt das Interview auch dann, wenn ich es nach der fünften Frage abbreche. Der Pool ist keine feste Liste: ergänze ihn, sobald eine Antwort eine neue Entscheidung öffnet, und streiche die Zweige, die eine Antwort geschlossen hat.

Wirkungsfilter. Eine Entscheidung, deren Optionen zum selben Ergebnis führen, fragst du nicht: nenne den Default in einem Halbsatz und geh weiter. Fülle nicht auf eine runde Anzahl Fragen auf.

Genau eine offene Frage zur Zeit. Mehrere Fragen auf einmal sind verwirrend. Nenne je Frage, was zur Entscheidung steht, was daran hängt, die Optionen mit ihrer Konsequenz, dazu deine Empfehlung mit einer Ein-Satz-Begründung und dem, was sie umwerfen würde. Bei abzählbaren Optionen nutze AskUserQuestion, falls verfügbar, und dann mit genau einer Frage pro Aufruf: das Tool nähme bis zu vier, das wäre genau der Fehler, den dieser Skill vermeidet; die Empfehlung ist die erste Option und trägt „(Empfohlen)" im Label. Bei offenen Fragen stell sie als Prosa und beende den Zug. Prosa ist der Grundfall, das Tool die Kür — verlass dich nicht darauf, dass es da ist.

Antwort verarbeiten. Prüfe jede Antwort gegen die Fakten und gegen alle früheren Antworten. Benenne einen Widerspruch und leg ihn mir vor, statt ihn still zu glätten; lobe meine Antwort nicht und relativiere sie nicht. Antworte ich „weiss nicht", trag deine Empfehlung als vorläufige Entscheidung ein und geh weiter; die vorläufigen sammelst du und legst sie in der Schlussnotiz zur Bestätigung vor — du entscheidest damit nicht an mir vorbei, du schiebst nur auf. Revidiere ich eine frühere Entscheidung, zieh die davon abhängigen nach: was auf ihr aufbaute, geht zurück in den Pool und wird erneut gefragt.

Erschöpfungs-Abbruch. Ende, wenn keine offene Entscheidung mit Ergebniswirkung mehr im Pool ist. Erfinde dann keine. Beende nicht früher, nur weil ich zustimme oder ungeduldig wirke — Zustimmung ist kein Erschöpfungsbeleg.

Schlussnotiz und Übergabe, als Chat-Notiz ausgeben, nicht in eine Datei schreiben: der Gegenstand in einem Satz; das Ledger aller Entscheidungen mit Kennung, Entscheidung, gewählter Antwort, Kurzbegründung und Status bestätigt oder vorläufig; die nicht gefragten Entscheidungen mit Default und Grund; die offenen Punkte. Die Kennungen sind stabil, damit ich dir sagen kann: nimm Entscheidung 3 zurück. Bitte dann um die Bestätigung, dass das Verständnis gemeinsam ist. Auch nach meiner Bestätigung setzt du nichts um — biete die Übergabe an /plan oder den Plan-Modus an und beende den Zug. Dieser Skill klärt, er baut nicht.

Vorhaben oder Zusatzfokus, falls angegeben: $ARGUMENTS
