---
name: plan-review
description: Reviewt den zuletzt erstellten Plan in mehreren Runden mit rotierenden Blickwinkeln, hinterfragt jeden Befund, arbeitet die belastbaren ein und protokolliert Befunde und Blickwinkel revidierbar. Läuft, bis die Blickwinkel erschöpft sind. Fachgebietsunabhängig. Nutzen nach /plan.
argument-hint: "[optionaler Zusatzfokus]"
disable-model-invocation: true
model: opus
effort: xhigh
---

Bleibe im Plan-Modus und ändere keine Quell- oder Projektdateien, du setzt nichts um. Den Plan selbst aktualisierst du hingegen, das gehört zum Plan-Modus. Implementiere nichts.

Arbeite in Runden. Jede Runde besteht aus Review aus einem Blickwinkel, Hinterfragen und Einarbeiten; ab Runde 2 zu Beginn zusätzlich eine kurze Bestandsprüfung.

Blickwinkel-Rotation. Die Runden ziehen aus einem aufgabenspezifischen Kandidaten-Pool an Blickwinkeln, den du in Schritt A1 bei der Einordnung aufstellst. Der Pool ist keine feste Liste: ergänze ihn, sobald unterwegs ein neuer tragfähiger Blickwinkel auftaucht. Führe ein Protokoll der bereits genutzten Blickwinkel. Wähle zu Beginn jeder Runde einen Blickwinkel aus dem Pool, der sich von allen bisher genutzten unterscheidet und zur Aufgabe passt. Mögliche Blickwinkel als Anregung für den Pool: Korrektheit des Geänderten, Konsistenz gegen den unveränderten Bestand, Auswirkung auf abhängige Stellen, fehlende Gegenprobe oder Verifikation, Annahmen und Randfälle, Vollständigkeit, Reversibilität. Wähle, was für diese Aufgabe wirklich trägt. Notiere den gewählten Blickwinkel je Runde.

Abarbeitung und Erschöpfungs-Abbruch. Arbeite die Blickwinkel des Pools ab, Runde für Runde je einen noch nicht genutzten. Eine Runde mit keinen oder nur geringen Befunden beendet die Schleife nicht — laufe mit dem nächsten Blickwinkel weiter. Beende erst, wenn du ehrlich keinen substanziell neuen Blickwinkel mehr findest, der nicht bloss einen genutzten wiederholt; erfinde dann keinen, sondern halte fest, dass die Blickwinkel erschöpft sind, und gib die Schlussnotiz aus. Erkläre die Blickwinkel in der Regel nicht vor mindestens 3 durchlaufenen für erschöpft; bietet die Aufgabe ehrlich weniger tragfähige Blickwinkel, endet es entsprechend früher.

Schritt A0, Bestandsprüfung, ab Runde 2. Prüfe zu Beginn der Runde kurz, ob die bereits im Ledger eingearbeiteten Punkte noch Bestand haben und die letzte Fassung keinen früheren Befund untergraben hat. Falls doch, behandle das als neuen Befund dieser Runde mit eigener Kennung.

Schritt A1, Review aus dem Blickwinkel dieser Runde. In Runde 1 zuerst Einordnung: bestimme in einem Satz die Aufgabenart (etwa Code, Recherche, Text, Konzept, Entscheidung), gib das Ziel des Plans in einem Satz wohlwollend wieder (Steelman) und stelle den Kandidaten-Pool an Blickwinkeln auf; wähle daraus den Blickwinkel dieser Runde. Dann prüfe den Plan konsequent und in der Tiefe aus dem für diese Runde gewählten Blickwinkel, nicht breit über alle. Belaste den Plan, statt ihn zu bestätigen. Nutze die lesenden Tools nur, wenn du eine Aussage sonst nicht belegen kannst. Belege jeden Befund am konkreten Schritt. Melde so viele Befunde, wie dieser Blickwinkel wirklich hergibt, ohne feste Zahl, und fülle nicht auf eine runde Anzahl auf. Nummeriere sie und ordne jedem eine Schwere zu: Blocker, Hoch, Mittel oder Gering, mit konkreter Gegenmaßnahme.

Schritt A2, Hinterfragen. Prüfe vor dem Einarbeiten jeden Befund dieser Runde einzeln gegen sich selbst: Trifft er auf den aktuellen Planstand wirklich zu, ist er nicht schon adressiert, und verbessert die Gegenmaßnahme den Plan tatsächlich, statt ihn nur umzuschichten? Formuliere je Befund das stärkste Gegenargument. Verwirf den Befund, wenn er es nicht übersteht, behalte ihn, wenn er belastbar bleibt. Verwirf nicht, nur um den Review vorzeitig zu beenden. Sammle die verworfenen Befunde mit je einer Ein-Satz-Begründung.

Schritt B, Einarbeiten. Arbeite alle belastbaren Befunde dieser Runde in den Plan ein, sodass die überarbeitete Fassung den bisherigen Plan ersetzt und zur neuen Grundlage wird. Implementiere nicht. Vergib jedem eingearbeiteten Befund eine stabile Kennung im Format Runde.Nummer, etwa 2.3, und trage ihn in ein laufendes Ledger ein: Kennung, Kurzbefund, Schwere, betroffener Planschritt. Das Ledger ist ein internes Arbeitsprotokoll, das du nur in der Schlussnotiz ausgibst und nicht in den Plan schreibst, damit der Plan sauber bleibt. Vergebene Kennungen bleiben über alle Runden stabil. Danach beginnt die nächste Runde mit Schritt A0 auf dem überarbeiteten Plan und einem neuen Blickwinkel, sofern noch ein tragfähiger Blickwinkel offen ist.

Schlussnotiz, als Chat-Notiz ausgeben, nicht in den Plan schreiben: die je Runde genutzten Blickwinkel in Reihenfolge, das vollständige Ledger aller eingearbeiteten Befunde, die verworfenen Befunde je Runde mit Begründung, sowie den Status Blickwinkel erschöpft plus Anzahl gelaufener Runden. Über die Kennung kannst du danach gezielt zurücknehmen, indem du mir als Folgeanweisung etwa sagst: nimm Änderung 2.3 im Plan zurück.

Zusatzfokus für die Reviews, falls angegeben: $ARGUMENTS
