---
name: project-curate
description: >-
  Kuratiert eine fertig gehärtete CLAUDE.md oder AGENTS.md ohne Bedeutungsverlust: Floskeln
  und Redundanz raus, Format nach Inhalt, Wichtiges nach oben,
  auslagerungsreife Blöcke markieren und eine knappe Pflegeregel bedingt verankern. Schwächt
  keine Regel, verschiebt nichts, legt nichts an. Der letzte Schritt nach project-rules.
argument-hint: "[optional: Pfad zur CLAUDE.md/AGENTS.md]"
disable-model-invocation: true
---

Argument (optional, i. d. R. der Pfad zur Zieldatei): $ARGUMENTS — leer, dann bestimmst du die maßgebliche Datei wie unten.

# Regeldatei kuratieren

Du verdichtest eine Regeldatei, deren Inhalt schon steht. Verdichten heißt hier **kuratieren, nicht abmagern**: Das Ableitbare, Redundante und Selbstverständliche geht raus, die tragenden Regeln bleiben und werden nicht schwächer. Dieser Schritt kommt nach `/cmd:project-rules`, weil sich erst verdichten lässt, wenn aller Inhalt steht.

**Die Quelle.** `references/token-effizienz.md` — der Überarbeitungskatalog. **Lies ihn, bevor du die erste Zeile änderst**, und setze keine Regel aus dem Gedächtnis. **Teil A** ist Arbeitsanweisung an dich und kommt **nie** als Text in die Datei; **Teil B** ist der einzige Block, der bedingt als Inhalt übernommen wird. Die Datei liegt im Plugin-Verzeichnis außerhalb des Arbeitsverzeichnisses; das Lesen braucht dort eine Freigabe, die headless fehlt und interaktiv erfragt wird. Wird sie verweigert, halte an und nenne den Pfad, statt zu verdichten, ohne den Maßstab zu kennen.

## Schritt 1 — Zieldatei und Ausgangsmaß

Kläre zuerst, *welche* Datei kuratiert wird: die maßgebliche `CLAUDE.md`, oder `AGENTS.md`, wenn diese die maßgebliche ist. Ist sie nicht eindeutig, frag kurz nach, statt zu raten. Sichere sie vor dem Ändern (Git-Stand oder eine `.bak`-Kopie, wenn sie untrackt ist).

Halte das Ausgangsmaß fest, bevor du etwas änderst: Zeilen und Zeichen der Datei. Ohne diesen Wert ist am Ende nicht belegbar, was die Kuratierung gebracht hat, und die Bilanz im Protokoll wäre eine Schätzung.

## Schritt 2 — Die nicht kürzbaren Stellen feststellen

Das ist der Schritt, ohne den die Kuratierung genau das beschädigt, was sie schützen soll. Einzelne Katalogregeln sind **als nicht kürzbar markiert**, und die Marke steht im Verbuchungshinweis des Katalogs, nicht in der Zieldatei. Du musst sie dir also beschaffen:

- **Erstweg:** Lief `/cmd:project-rules` in derselben Sitzung, nennt sein Änderungsprotokoll die Marken als Liste („nicht kürzbar: <Regel> → <Abschnitt>"). Nimm sie von dort.
- **Rückfallweg, und er ist der verlässliche:** Liegt keine Liste vor, lies die Verbuchungshinweise der Kataloge unter `../project-rules/references/` selbst — die Marke steht dort jeweils im Absatz unter der Adressaten-Präambel. Betroffen sind `ausfuehrungsdisziplin.md`, `kontextdisziplin.md`, `ausgabedisziplin.md` und `umfangsdisziplin.md`; prüfe die übrigen mit, eine Marke kann jederzeit dazukommen.

Eine markierte Regel wird **weder gekürzt noch mit einer Nachbarregel zusammengezogen**, auch wenn sie wie eine Aufzählung aussieht. Kommst du an die Marken nicht heran, verdichte die betroffenen Abschnitte nicht und sag im Bericht, welchen Weg du genommen hast.

## Schritt 3 — Kuratieren (Teil A)

Wende Teil A des Katalogs auf die ganze Datei an, ohne die Bedeutung zu verändern: knappe Fachnotiz statt Floskeln und Höflichkeitsrahmen, Verben statt Nominalisierungen, Redundanz weg (dieselbe Regel zweimal in anderen Worten kostet doppelt und schärft nichts), Format nach Inhalt wählen, Wichtiges nach oben. **Vage Regeln schärfst du nicht** — das verlangt ein im Projekt belegtes Werkzeug und gehört zu `/cmd:project-rules`; der Katalog sagt, warum. Den Maßstab im Einzelnen gibt der Katalog, nicht dieser Absatz.

**Gezielt editieren, nicht neu schreiben.** Ändere die Stellen, die fallen, statt die Datei als Ganzes neu zu setzen: Ein Komplett-Diff verdeckt, was die Kuratierung geändert hat, und genau daran hängt die Treue-Prüfung aus Schritt 6. Fällt bei einer durchgreifenden Umstrukturierung fast jede Zeile, ist Neuschreiben zulässig — dann vermerkst du es im Protokoll.

**Die Grenze — hier hört Kürzen auf:**

- Verdichten ist reine Formarbeit. Verändert eine Umformulierung die Aussage, ist sie keine Verdichtung — lass die Stelle stehen.
- Opfere **nie** einen Vorbehalt bei korrektheitskritischer Arbeit, eine nötige Disambiguierung oder die entscheidende Ausnahme der Kürze. Und schwäche **nie** eine Regel, um Tokens zu sparen. Im Zweifel zugunsten der eindeutigen, vollständigen Aussage.
- Ein als **Original** gekennzeichneter Block bleibt wörtlich stehen, samt seinem Einleitungssatz: Seine Wirkung hängt am Wortlaut, eine gekürzte Fassung ist keine gemessene mehr. Kürzbar ist nur der Rahmen um ihn.
- Die Marken aus Schritt 2 gelten hier.

## Schritt 4 — Auslagerungsreifes markieren, nicht verschieben

**Dieser Skill verschiebt nichts und legt nichts an.** Er bleibt bei der Zieldatei. Findest du auslagerungsreife Blöcke — situatives Wissen, ein mehrschrittiges Runbook, Regeln, die nur einen Dateibereich betreffen —, dann *markiere* sie mit dem vorgesehenen Ziel und lass sie stehen. Ausgeführt wird der Umzug von `/cmd:project-structure`, das dafür ein Verlagerungs-Register führt und eine eigene Freigabe einholt. Reiß hier keine Inhalte heraus, für die es noch kein Ziel gibt — das wäre genau der Informationsverlust, den die Ablagedisziplin verhindert.

## Schritt 5 — Pflegeregel verankern (Teil B), bedingt

- Nur wenn der Agent diese Datei selbst fortschreibt, übernimm die knappe Pflegeregel aus Teil B unter einen passenden Abschnitt; gibt es schon eine Stil- oder Pflegeregel, schärfe sie, statt sie zu doppeln.
- Wird die Datei ausschließlich von Menschen gepflegt, lass sie weg und vermerke das — sonst verbrauchst du Budget für eine selbstbezügliche Regel.

## Schritt 6 — Prüfen

Lies die Datei neu und prüfe:

- **Verdichtet, aber bedeutungstreu:** Keine Redundanz, keine Floskeln, Wichtiges oben, Root möglichst unter ~200 Zeilen — und kein Vorbehalt, keine Disambiguierung, keine entscheidende Ausnahme der Kürze geopfert?
- **Keine Regel geschwächt:** Ist jede Regel nach der Kuratierung mindestens so streng und so spezifisch wie vorher? Eine lockerer oder generischer gewordene Regel ist ein Fehler, kein Fortschritt.
- **Marken gehalten:** Steht jede als nicht kürzbar markierte Regel unverändert? Steht jeder Originalblock wörtlich?
- **Treue:** Behaupte keine Änderung, die du nicht vorgenommen hast. Verstecke keine inhaltliche Änderung als Formänderung — das ist hier der naheliegende Fehler, weil beides wie Umformulieren aussieht.

Bei einem Fund: korrigieren, dann erneut prüfen.

## Schritt 7 — Verdichtungsprotokoll

```
## Kuratiert: <Pfad zur maßgeblichen Datei>
Maß: <Zeilen vorher> → <Zeilen nachher> · <Zeichen vorher> → <Zeichen nachher>
Marken: <aus dem Protokoll von project-rules / selbst aus den Katalogen gelesen / nicht erreichbar>
Schreibweise: <gezielt editiert / neu geschrieben, weil …>

### Zusammengeführt
- <Thema>: <zwei Fassungen> → <eine>, am Ort <Abschnitt>

### Gekürzt
- <Abschnitt>: <was raus ist — Floskel, Dopplung, ableitbare Stack-Angabe>

### Unangetastet geblieben
- <Regel/Block> — Grund: <Marke / Originalblock / Vorbehalt / Ausnahme>

### Auslagerungsreif markiert (nicht verschoben)
- <Block> → <vorgesehenes Ziel>

### Pflegeregel
<verankert / bewusst nicht (Grund)>
```

Steht unter „Auslagerungsreif markiert" mindestens ein Eintrag, empfiehl einen Lauf von `/cmd:project-structure`. Lief der in diesem Projekt schon — erkennbar am Wegweiser-Abschnitt `## Ablage` —, leg die Entscheidung vor („dieser Block gehört nach X, dort wurde er bisher nicht hingelegt — soll er?"), statt einen weiteren Lauf zu empfehlen. Zwei Skills, die einander im Wechsel empfehlen, schicken den Nutzer im Kreis.

Die Maß-Zeile ist der Beleg, nicht die Behauptung: Sie nennt gemessene Werte aus Schritt 1 und vom Ende. Ein vollständig ausgefülltes Protokoll steht in `references/beispiel.md`; lies es, bevor du deines schreibst. Geht die Datei dabei nicht zurück, sag das so — eine Datei, die schon knapp war, wird durch Kuratieren nicht kürzer, und ein erfundener Gewinn wäre schlimmer als keiner.
