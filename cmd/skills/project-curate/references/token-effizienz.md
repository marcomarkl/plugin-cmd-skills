# Token-Effizienz — Teil A/B

Dieser Katalog ist anders gebaut als die zehn Inhalts-Kataloge und wird in **Schritt 7** angewendet, nicht in Schritt 4 verbucht. **Teil A** richtet sich an dich als einsetzende KI und kommt **nie** als Text in die Zieldatei; **Teil B** ist der einzige Block, der (bedingt) als Inhalt übernommen wird.

## Teil A — Überarbeitungskatalog (Arbeitsanweisung, nicht Inhalt der Datei)

Die folgenden Regeln richten sich an dich als einsetzende KI und steuern, wie du die Zieldatei verdichtest und formatierst. Übernimm sie nicht als Text in die Datei.

### Die richtige Datei zuerst
- Verdichte zuerst die permanent geladene Root-CLAUDE.md, da dort jede Zeile auf jedem Turn zählt. An bedarfsgeladenen Dateien und selten gelesener Doku bringt aggressive Kürzung wenig.
- Halte die Root-Datei unter der Schwelle von rund 200 Zeilen; ist sie länger, lagere situatives oder selten gebrauchtes Wissen aus, statt es zu quetschen. Diese Schwelle ist die Herstellerempfehlung und eine Konvention, kein gemessener Schwellwert: Belegt trägt sie das **Token-Argument** (jede Zeile kostet auf jedem Turn). Die Begründung, längere Dateien senkten die Befolgung, steht so in der Herstellerdoku selbst und ist trotzdem nicht belastbar — eine kontrollierte Studie über 1.650 Claude-Code-Sitzungen fand zwischen 25 und 500 Zeilen keinen Unterschied und stützt den Null-Effekt für Dateigröße sogar positiv. Kürze also, weil Kontext knapp ist, nicht weil Länge angeblich ungehorsam macht.
- **Zähle Regeln, nicht nur Zeilen.** Für die *Anzahl* gleichzeitig geltender Instruktionen ist Degradation dagegen gemessen: Bei mehreren hundert Einzelanweisungen fällt die Befolgungsgenauigkeit auch bei Spitzenmodellen deutlich ab. Zwei knappe Regeln, die dasselbe Thema zerlegen, sind darum schlechter als eine tragende — Zusammenführen schlägt Kürzen.

### Dichter formulieren, nicht Inhalt streichen
- Schreib wie eine knappe Fachnotiz: Floskeln und Höflichkeitsrahmen raus, überflüssige Qualifizierer und Füllwörter streichen, Verben statt Nominalisierungen.
- Entferne Redundanz. Dieselbe Regel zweimal in anderen Worten kostet doppelt und schärft nichts.
- Ersetze vage Vorgaben durch faktische, überprüfbare. "2 Leerzeichen einrücken" statt "sauber formatieren", "vor dem Commit die Tests laufen lassen" statt "deine Änderungen testen". Das spart Wörter und verbessert zugleich die Befolgbarkeit.

### Format nach Inhalt wählen
- Markdown als Standard, weil token-leicht und zugleich strukturiert. Schwerere Formate (JSON, XML, HTML) nur, wo sie einen echten Zweck haben; sie blähen denselben Inhalt auf.
- Struktur für Mengen gleichartiger Dinge (Regeln, Schritte, Felder, erlaubte Werte, Pfade): Liste oder Tabelle. Prosa für zusammenhängende Logik (mehrstufiger Vorgang, Begründung, Bedingung mit Ausnahmen, Verhaltensziel). Wende Struktur nicht um ihrer selbst willen an und presse keine Gedankengänge in verschachtelte Bullets.
- Bei Claude trennen XML-Tags Abschnitte unmissverständlich, kosten aber Tokens. Nutze sie gezielt bei Verwechslungsgefahr zwischen Abschnitten, nicht als Auszeichnung über jede Zeile.
- Verlass dich nicht auf eine bestimmte Formatwahl als Leistungshebel. Ihre Wirkung ist modell- und versionsabhängig; setz auf Klarheit, die über Modelle hinweg trägt.

### Anordnung
- Das Wichtigste nach oben, nicht in die Mitte einer langen Datei, da Inhalt in der Mitte am unzuverlässigsten genutzt wird. Teile lange Dateien an thematischen Grenzen, statt sie wachsen zu lassen. Für die Wirkung der Position auf die Befolgung gibt es allerdings keinen Nachweis in beide Richtungen — behandle die Reihenfolge als Lesbarkeitsfrage, nicht als Steuerhebel, und begründe damit keine Umbauten.

### Bedeutung bewahren (die Grenze)
- Lass Vorbehalte bei korrektheitskritischer Arbeit, nötige Disambiguierung und die entscheidende Ausnahme stehen, auch wenn sie Tokens kosten. Ein weggelassener Vorbehalt oder eine zweideutige Anweisung kostet über Fehlversuche und Rework mehr, als die Kürzung spart.
- Kürzen hat eine Grenze, und sie verläuft an der Korrektheit. Im Zweifel zugunsten der eindeutigen, vollständigen Aussage entscheiden, nicht zugunsten der kürzeren.
- Kataloge markieren einzelne Regeln in ihrem Verbuchungshinweis als nicht kürzbar. Diese Marken gelten hier: Eine so markierte Regel wird weder gekürzt noch mit einer Nachbarregel zusammengezogen, auch wenn sie wie eine Aufzählung aussieht. Die Marken stehen nicht in der Zieldatei, sondern im Verbuchungshinweis der Kataloge unter `../project-rules/references/`; wie du sie beschaffst, steht in Schritt 2 des Skill-Bodys.

## Teil B — Verankerte Pflegeregel (Inhalt, der in die Datei übernommen wird)

Anders als Teil A wird der folgende Block als Inhalt in die Zieldatei übernommen. Er richtet sich an den Agenten, der diese Datei pflegt, und greift nur, wenn dieser sie selbst fortschreibt (siehe Schritt 7). Halte ihn knapp, sonst widerspricht er seinem eigenen Zweck.

### Diese Datei pflegen
- Formuliere neue oder geänderte Regeln knapp und faktisch überprüfbar; keine Floskeln, keine Redundanz.
- Strukturiere gleichartige Mengen (Regeln, Schritte, Werte) als Listen, zusammenhängende Logik als Prosa; nutze Markdown.
- Halte diese Datei unter rund 200 Zeilen und lagere situatives oder selten gebrauchtes Wissen in Skills oder pfad-bezogene Rules aus.
- Opfere Vorbehalte, nötige Disambiguierung und entscheidende Ausnahmen nicht der Kürze.
