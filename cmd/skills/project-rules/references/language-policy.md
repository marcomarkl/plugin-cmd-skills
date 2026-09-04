# Sprachdisziplin

Die folgenden Regeln richten sich an den später gesteuerten Agenten ("du"), nicht an dich als einsetzende KI; übernimm sie als Inhalt in die Zieldatei. Sie regeln, welche Sprache welche Textsorte trägt: die erklärende Prosa, die Namen, den zur Laufzeit ausgegebenen Text.

**Verbuchungshinweis an dich — kommt nicht in die Zieldatei.** Fallen Prosa- und Bezeichnersprache zusammen, wie in einem durchgehend englischsprachigen Projekt, ist „Prosa und Bezeichner trennen" gegenstandslos. Verbuche den Abschnitt dann als `weggelassen` mit genau diesem Grund, statt eine Nullaussage in die ständig geladene Datei zu schreiben. Zeichenvorrat, Nutzersprache und Bestandsteil tragen weiter.

## Prosa und Bezeichner trennen
- Erklärender Text folgt der **Prosasprache** des Projekts: Kommentare, Docstrings, README, Doku, Changelog.
- Was aufgerufen, importiert oder als Schlüssel geschrieben wird, folgt der **Bezeichnersprache**: Datei- und Verzeichnisnamen, Module, Klassen, Funktionen, Parameter, Konstanten, Konfig- und JSON-Schlüssel, DB-Tabellen und -Spalten, Branch-Namen.
- Die Bezeichnersprache ist im Regelfall Englisch, weil Schlüsselwörter, Standardbibliotheken und Ökosystem-Konventionen es sind: Ein anderssprachiger Name steht ohnehin neben englischen Nachbarn. Weicht das Projekt begründet ab, etwa in einer Fachdomäne ohne brauchbare Übersetzung, hält es die Abweichung in dieser Datei fest.
- **Keine Ausnahme**, auch nicht für funktionslokale Namen und nicht für Testcode. Eine Regel ohne Fallunterscheidung stimmt auch nach einem Umbau noch, während die Grenze „verlässt die Funktion nicht" sich verschiebt, sobald eine lokale Variable zum Parameter wird.
- Trägt ein Dateiname einen beschreibenden Mittelteil, ist er trotzdem ein Name und folgt der Bezeichnersprache.

## Zeichenvorrat der Namen
- Alle oben als Bezeichner genannten Namen bestehen aus ASCII-Zeichen.
- Der Grund ist technisch, nicht stilistisch: Portabilität über Dateisysteme, Encoding, Terminals, Diffs, Suchwerkzeuge und git-Refs. Er trägt auch dort, wo die Bezeichnersprache eine andere als Englisch ist, und unabhängig davon, ob die Programmiersprache Unicode-Bezeichner erlaubt.
- **Diese Regel folgt nicht aus der vorigen und wird nicht mit ihr verschmolzen.** Ein transkribierter Name wie `pruefung` erfüllt den Zeichenvorrat und verletzt die Sprachwahl trotzdem. Wer beide zusammenzieht, verliert genau diesen Fall.

## Laufzeit-Text nach Adressat
- Diagnostik für Entwickler, also Fehlermeldungen des Codes, Logs und Stacktraces, folgt der Bezeichnersprache: Sie steht neben den Meldungen der verwendeten Bibliotheken und muss im Wortlaut auffindbar bleiben.
- Nutzergerichteter Text, also Ausgaben und Oberfläche, folgt der **Nutzersprache**. Sie ist eine Entscheidung über die Zielgruppe, keine Entwicklungskonvention: Benenne sie in dieser Datei, wenn das Projekt solchen Text hat, statt sie aus der Prosasprache abzuleiten.
- Übersetzungsschlüssel sind Schlüssel und folgen der Bezeichnersprache; nur ihre Werte folgen der Nutzersprache.

## Commit-Nachrichten
- Folgen der Prosasprache, weil sie zum Changelog gehören und mit ihm gelesen werden. Nutzt das Projekt ein Präfix-Schema, ist der Typ-Präfix ein Schlüssel und folgt der Bezeichnersprache; nur die Beschreibung dahinter folgt der Prosa.

## Vorhandene Namen und fremde Konventionen
- Die Regeln gelten für neuen und geänderten Code. Vorhandene Namen bleiben, bis eine Umbenennung ausdrücklich beauftragt wird: Sie bricht Imports, öffentliche Schnittstellen und git-Refs, deren Reichweite du beim Ändern nicht überblickst.
- Hat das Projekt bereits eine gelebte Sprachkonvention, gilt sie, und diese Regeln treten zurück. Eine Konvention ist eine Setzung, keine Härte, und ihr Wechsel entwertete den gesamten Bestand.
