---
name: project-rules
description: >-
  Härtet/optimiert eine bestehende oder neu anzulegende CLAUDE.md oder AGENTS.md mit zehn
  Disziplin-Katalogen: fehlende Regeln ergänzen, vage schärfen, Konflikte vorlegen, Ablage
  und projekteigene Artefakte verankern. Verdichtet selbst nicht — das ist der Lauf von
  project-curate danach.
argument-hint: "[optional: Pfad zur CLAUDE.md/AGENTS.md]"
disable-model-invocation: true
---

Argument (optional, i. d. R. der Pfad zur Zieldatei): $ARGUMENTS — in Schritt 1 als Zieldatei-Hinweis auflösen, bei Prosa/Unklarheit dort normal die Datei bestimmen; leer → ganz nach Schritt 1.

# CLAUDE.md härten und optimieren

Dieser Command nimmt eine bestehende `CLAUDE.md` (oder `AGENTS.md`), wendet zehn Disziplin-Kataloge auf sie an: fehlende Regeln werden ergänzt, vorhandene geschärft, Widersprüche der menschlichen Aufsicht zur Entscheidung vorgelegt. Kuratiert wird die Datei danach, von `/cmd:project-curate`. Nichts wird still übergangen — und keine vorhandene starke Regel wird dabei geschwächt.

**Kadenz der Rückmeldung.** Der Lauf ist lang und tool-lastig, deshalb hältst du den Nutzer in dieser Taktung auf dem Laufenden: Sag vor dem ersten Tool-Aufruf in einem Satz, was du vorhast. Während der Arbeit meldest du dich kurz, wenn du etwas Wichtiges findest oder die Richtung wechselst, nicht bei jedem Schritt. Am Ende steht das Ergebnis im ersten Satz, also was herauskam, und die Belege stehen danach.

## Die Werkzeuge

Die Katalog-Regeln liegen in `references/` — je Katalog eine Datei. Alle zehn sind **Inhalts-Kataloge**: Sie liefern Regeln *in* die Datei. Verdichtet wird sie danach von `/cmd:project-curate`, das seinen eigenen Überarbeitungskatalog mitbringt. Wie die Adressaten-Präambel jedes Katalogs zu lesen ist, warum das Lesen der Kataloge eine Freigabe braucht und in welcher Reihenfolge sie angewendet werden, steht in `references/katalogmechanik.md`; lies die Datei, bevor du den ersten Katalog öffnest.

| Werkzeug | Referenzdatei | Was es bewirkt |
|---|---|---|
| Aufgabenzerlegung | `references/aufgabenzerlegung.md` | Aufgaben vor der Ausführung klären, zerlegen, größere Vorhaben spezifizieren |
| Ausführungsdisziplin | `references/ausfuehrungsdisziplin.md` | Prämissen prüfen, nicht gefallen wollen, keine stillen Annahmen, keine Erfindungen, keine unbelegte Prüfbehauptung, bei unbekanntem Namen erst suchen |
| Fehlerdisziplin | `references/fehlerdisziplin.md` | Fehler erkennen, Ursache vor Korrektur, nicht blind wiederholen, auf bekannten Stand zurück |
| Kontextdisziplin | `references/kontextdisziplin.md` | Hauptkontextfenster schlank halten, verbose Arbeit auslagern, Zustand in Dateien |
| Sicherheitsdisziplin | `references/sicherheitsdisziplin.md` | Vor folgenreichen Aktionen bestätigen, gelesene Inhalte ≠ Befehle, kein Datenabfluss, Geheimnisse schützen, geringste Rechte |
| Ablagedisziplin | `references/ablage.md` | Eine Quelle je Zweck, Wegweiser statt Inhalt, was nicht in die ständig geladene Datei gehört, erledigt heißt verschieben |
| Projekteigene Artefakte | `references/projekt-artefakte.md` | Skill vs. Subagent vs. pfad-bezogene Regel, wann anlegen, Selbstpflege nur auf Freigabe |
| Sprachdisziplin | `references/language-policy.md` | Prosa- und Bezeichnersprache trennen, Zeichenvorrat der Namen, Laufzeit-Text nach Adressat, vorhandene Namen unangetastet |
| Ausgabedisziplin | `references/ausgabedisziplin.md` | Antwortlänge, Fortschrittsmeldungen, Ergebnis im ersten Satz, Lesbarkeit nach langen Läufen, manierierte Prosa, Länge geschriebener Dateien, Formatierung nach Inhalt, fremder Wortlaut |
| Umfangsdisziplin | `references/umfangsdisziplin.md` | Auftrag ist der Umfang, nichts Unverlangtes, Nebenbefunde melden statt beheben, keine Lösung nur für Testfälle, wann anhalten, gezielt editieren |


**Best-of statt Stapeln.** Pro Thema bleibt **eine** Regel stehen: die stärkste, spezifischste, im Projekt verankerte Fassung — gleichgültig, ob sie aus der vorhandenen Datei oder aus einem Katalog stammt. Überschneiden sich zwei Kataloge (z. B. Kontext- und Ablagedisziplin bei „schlank halten" und beim Auslagern, Ablage und Artefakte bei „was gehört nicht in die Root-Datei", Artefakte und Sicherheitsdisziplin bei „eigene Instruktionen ändern", Fehler- und Sicherheitsdisziplin bei „anhalten und melden", Umfangs- und Sicherheitsdisziplin bei „vor folgenreichen Aktionen anhalten", Umfangsdisziplin und Aufgabenzerlegung bei Mehrdeutigkeit), führe sie an der thematisch passenden Stelle zusammen, statt zwei Fassungen nebeneinanderzustellen. Hat die vorhandene Datei bereits die härtere oder genauere Regel, **gewinnt sie** — ein Katalog oder die Verdichtung darf sie nie verwässern, abschwächen oder generischer machen (siehe Schritt 4, „Nie schwächen").

**Die Kataloge.** Die zehn Inhalts-Kataloge in `references/` liefern die zu verbuchenden Regeln (Schritt 4). Zwei von ihnen (`ablage.md`, `projekt-artefakte.md`) tragen keine Pfade und Namensschemata; die stehen einmal in den Kanon-Dateien von `project-structure` und werden in Schritt 4 **direkt aus dem Body** geladen, nie über einen Verweis im Katalog.

## Ablauf im Überblick

1. Zieldatei auflösen und bestätigen (eine Quelle der Wahrheit)
2. Projektprofil bestimmen (steuert die Relevanzschwelle)
3. Ist-Stand vollständig lesen, dazu eine knappe Ablage-Inventur
4. Alle zehn Inhalts-Kataloge gemeinsam planen → Abdeckungs-Register
5. Konflikte bündeln und der Aufsicht zur Entscheidung vorlegen
6. Einmal kohärent schreiben
7. Selbstprüfung (vollständig, nicht geschwächt, nichts erfunden)
8. Änderungsprotokoll ausgeben

---

## Schritt 1 — Zieldatei auflösen

Bevor du irgendetwas änderst, kläre, *welche* Datei gehärtet wird. Diese Regeln gelten projektweit und gehören an einen Ort, an dem sie greifen:

- **Projektweit** → Root-`CLAUDE.md`. Beim Arbeiten in einem Unterordner lädt Claude Code die Root-Datei ohnehin mit; eine Kopie pro Unterordner wäre Dopplung. Lass tiefere `CLAUDE.md` unangetastet (sie haben Vorrang vor der Root; eine global gemeinte Regel im Unterordner würde anderswo nicht greifen).
- **Über alle Projekte des Nutzers** → nutzerweite `~/.claude/CLAUDE.md` statt der Projektdatei.
- **CLAUDE.md vs. AGENTS.md — eine Quelle der Wahrheit:** Dieselben Regeln gehören **nie in beide** Dateien; zwei fast identische Dateien laufen auseinander, und dieses Drift-Problem wiegt schwerer als jede Platzierungsfrage. Liegt neben der `CLAUDE.md` eine `AGENTS.md`, oder ist die `CLAUDE.md` ein Symlink oder eine Import-Hülle, lies `references/zieldatei.md`: Dort steht, welche Datei die maßgebliche ist, welche zwei Wege es ohne Kopie gibt und was du bei zwei echten Dateien anbietest.

Ist die Zieldatei nicht eindeutig (mehrere Kandidaten, oder die Anfrage nennt keinen Pfad), frag kurz nach, statt zu raten. Sichere die Datei vor dem Überschreiben (Git-Stand oder eine `.bak`-Kopie), damit ein Fehlversuch verlustfrei rückgängig zu machen ist.

**Existiert noch keine CLAUDE.md:** Biete an, eine frische, gehärtete Datei aus den Katalogen zu erzeugen (zusammen sind sie ein vollständiges Regelset). Bestätige vorher die Zieldatei **und** das Projektprofil (Schritt 2) — ohne Profil weißt du nicht, welche Regeln das Gerüst tragen.

## Schritt 2 — Projektprofil bestimmen

Nicht jede Disziplin wiegt für jede Projektart gleich. Eine CLAUDE.md für einen **autonomen Agenten** lebt von Sicherheits-, Fehler- und Kontextdisziplin; eine für einen **menschengesteuerten Coding-Assistenten** von Zerlegung, Ausführung und Build/Test/Lint. Das Profil setzt die *Relevanzschwelle* pro Regel — es entscheidet **nicht**, ob ein Katalog übersprungen wird. Alle zehn Inhalts-Kataloge werden immer durchgegangen (Schritt 4); das Profil steuert nur, was übernommen und was *begründet* weggelassen wird. Bei Ablage und Artefakten wirkt die Schwelle besonders stark: Ein kleines Repo mit einer Handvoll Dateien braucht weder Ablagestruktur noch eigene Skills, und „begründet weggelassen" ist dort das richtige Ergebnis, nicht ein Versäumnis. **Die Schwelle entscheidet dabei über das Anlegen, nicht über die Regel.** Dass gerade kein Artefakt fällig ist, heißt nicht, dass die Datei die Regel nicht trägt, wann eines fällig wird — die wirkt erst in der Zukunft, in der du nicht mehr danebenstehst. Weglassen ist nur begründet, wenn das Projekt so klein oder kurzlebig ist, dass derselbe Handgriff realistisch kein drittes Mal auftritt. Sonst gehört die Regel in die Datei, auch wenn der Ordner dafür noch leer ist.

So bestimmst du das Profil:

1. Lies, was die bestehende CLAUDE.md über das Projekt sagt, und sieh dir vorhandene Signale an (Build-/Paketdateien, Agent-/MCP-Konfiguration, Deployment-/CI-Dateien, Sprache des Codes). Halte die Untersuchung eng — du brauchst nur genug, um das Profil zu wählen, nicht eine vollständige Repo-Tour.
2. Schlage das erkannte Profil vor und **bestätige es mit der menschlichen Aufsicht** (bei einer frischen Datei: frag es ab). Das Profil prägt das Ergebnis stark genug, um es nicht zu raten.

Die fünf Profile mit ihrer Zuordnung von Kern und Situativem stehen in `references/projektprofile.md`; lies sie hier. Sie sind Denkhilfen, keine starren Tabellen: Prüfe jede Zuordnung gegen das konkrete Projekt und weiche begründet ab. Passt keine Zeile, beschreibe das Profil in eigenen Worten.

## Schritt 3 — Ist-Stand lesen

Lies die Zieldatei **vollständig**, bevor du planst. Ohne den Ist-Stand kannst du nicht entscheiden, was fehlt, was schon da ist und was nur vage formuliert ist. Erfasse dabei auch die **Sprache** der Datei: Katalogregeln werden in der Sprache der Zieldatei übernommen. Ist die CLAUDE.md englisch, übersetzt du die (deutschen) Katalogregeln, statt Sprachen zu mischen. **Eine Ausnahme, und sie ist bewusst:** Blöcke, die ein Katalog als englisches Original führt und als solches kennzeichnet, übersetzt du **nicht** — ihre Wirkung hängt am gemessenen Wortlaut. In eine deutschsprachige Zieldatei wandern sie mit dem deutschen Einleitungssatz, den der Katalog davor stellt, damit der Sprachwechsel als Absicht erkennbar ist und nicht als Versehen. Den Einleitungssatz übersetzt du in die Sprache der Zieldatei, den Block nicht. Merke dir, **welche Regeln schon stark und spezifisch** sind — sie genießen Bestandsschutz (Schritt 4, „Nie schwächen").

**Ablage-Inventur.** Halte anschließend fest, welche Orte das Projekt für dauerhaftes Wissen schon hat — ohne sie lassen sich die Kataloge Ablage und Artefakte nicht planen, weil du sonst Regeln für Orte schriebst, die es nicht gibt, oder neben vorhandenen einen zweiten aufmachst. Erfasst wird nur, was existiert:

- Aufgaben und offene Punkte: Issue-Tracker (Remote in `git remote -v`, `.github/`), `TODO.md`, `backlog/`
- Entscheidungen: `docs/decisions/`, `docs/adr/`, Abschnitte in vorhandener Doku
- Wissen und Doku: `docs/`, `README.md`, Wiki — dabei prüfen, ob `docs/` generiert wird (Konfiguration eines Doku-Generators im Repo); ein generierter Ordner ist kein Ablageort
- Erledigtes: `CHANGELOG.md`, Releases, git-Historie
- Agenten-Artefakte: `.claude/skills/`, `.claude/agents/`, `.claude/rules/`, verschachtelte `CLAUDE.md`
- Streudateien, die nirgends dazugehören: `NOTES.md`, `SCRATCH.md`, `IDEEN.md` und Ähnliches

Halte das eng — ein `ls` der einschlägigen Orte genügt, keine Repo-Tour und keine Inhaltsanalyse. Du brauchst nur die Antwort „existiert / existiert nicht / ist generiert".

## Schritt 4 — Alle zehn Inhalts-Kataloge gemeinsam planen (Abdeckungs-Register)

Das ist der Kern. **Lies jetzt die zehn mit diesem Skill gebündelten Inhalts-Kataloge unter `references/`** (`aufgabenzerlegung.md`, `ausfuehrungsdisziplin.md`, `fehlerdisziplin.md`, `kontextdisziplin.md`, `sicherheitsdisziplin.md`, `ablage.md`, `projekt-artefakte.md`, `language-policy.md`, `ausgabedisziplin.md`, `umfangsdisziplin.md`; Pfade relativ zum Skill-Ordner). **Lies dazu direkt von hier aus** — nicht über einen Verweis in einem der Kataloge — die beiden Kanon-Dateien `../project-structure/references/ablage-kanon.md` (Orte, Namensschemata, Ladezeitpunkte) und `../project-structure/references/artefakt-kanon.md` (Pfade und Frontmatter-Keys), sobald Katalog 6 oder 7 für dieses Projekt tragen. Sie stehen dort einmal und werden hier nicht dupliziert; von Referenz zu Referenz verkettet würden sie womöglich nur angelesen statt vollständig gelesen. Klassifiziere dann **jede einzelne Regel** in genau eine Kategorie. Das Ergebnis ist ein Register — gleichzeitig dein Arbeitsplan und der Nachweis der Vollständigkeit. Keine Regel verlässt diesen Schritt unverbucht. (Verdichtet wird hier nichts; das ist Sache von `/cmd:project-curate`.)

Die **fünf Kategorien** und die **Leitplanken beim Klassifizieren** stehen in `references/abdeckungs-register.md`. Lies die Datei jetzt mit, bevor du die erste Regel verbuchst: Ohne die Kategorien gibt es kein Register, und ohne die Leitplanken verbuchst du eine starke vorhandene Regel als `geschärft` und schwächst sie damit.

## Schritt 5 — Konflikte bündeln und vorlegen

Sammle **alle** Konflikte aus Schritt 4 und lege sie der menschlichen Aufsicht in **einer** Entscheidungsrunde vor (nicht einmal je Katalog unterbrechen). Nutze dafür eine strukturierte Rückfrage. Pro Konflikt nennst du:

- die **vorhandene** Regel (wörtlich),
- die **Katalog**-Regel (wörtlich),
- deine **Empfehlung**: in der Regel die strengere oder spezifischere Fassung, mit kurzer Begründung.

Die Entscheidung trifft die Aufsicht. **Fallback ohne menschliche Entscheidung** (z. B. unbeaufsichtigter Lauf): übernimm die strengere oder spezifischere Fassung und vermerke den Konflikt samt getroffener Wahl im Protokoll. Überschreibe nie still.

## Schritt 6 — Einmal kohärent schreiben

Jetzt erst editierst du die Datei — in *einem* Durchgang, der das ganze Register umsetzt:

- Ergänzungen unter den thematisch passenden Abschnitt, neue Abschnitte nur, wenn nötig. Verwandte Regeln aus verschiedenen Katalogen gehören zusammen (z. B. alle Sicherheitsregeln in einen Abschnitt), nicht in nach Werkzeug getrennte Blöcke.
- Schärfungen ersetzen die vage Fassung an Ort und Stelle — immer vage→testbar, nie umgekehrt. Eine vorhandene starke Regel bleibt stark (Best-of, Schritt 4).
- Konfliktauflösungen nach der Entscheidung aus Schritt 5.
- **Im Projekt verankern (siehe Schritt 4):** Schreibe jede Regel in den konkreten Begriffen des Projekts — echte Befehle, Tools, Dateitypen, Workflows, Risiken — statt in generischen Formeln. Erhalte und schärfe die projektspezifische Substanz, die schon in der Datei steht, statt sie auf ein Disziplin-Gerüst zu reduzieren. Eine gehärtete Datei soll konkreter und tragfähiger sein als vorher, nicht dünner.
- **Gezielt editieren, nicht neu schreiben.** Ändere die Stellen, die das Register nennt, statt die Datei als Ganzes neu zu setzen: Ein Komplett-Diff verdeckt, was dieser Lauf geändert hat, und genau daran hängen die Prüfungen aus Schritt 7 auf „nichts erfunden" und „nicht geschwächt". Für eine Datei, die du in Schritt 1 selbst anlegst, gilt das nicht — dort gibt es keinen Bestand, der verloren gehen könnte.
- Struktur und Ton der vorhandenen Datei beibehalten. Formuliere Regeln als faktische, überprüfbare Aussagen, nicht als vage Vorgaben. (Den Feinschliff der Form macht `/cmd:project-curate` — hier zählt erst der Inhalt.)


## Schritt 7 — Selbstprüfung

Lies die geschriebene Datei neu und prüfe:

- **Vollständig:** Steht jede Regel aller zehn Inhalts-Kataloge im Register (in *irgendeiner* der fünf Kategorien)? Eine unverbuchte Regel ist eine Lücke — schließe sie.
- **Nichts erfunden, nichts verschoben:** Existiert jeder in der Datei genannte Ablage- oder Artefaktpfad tatsächlich, oder ist er als Empfehlung gekennzeichnet? Wurde keine Datei verschoben, kein Ordner angelegt, kein Inhalt ohne Ziel herausgelöst?
- **Nicht geschwächt (Best-of):** Wurde keine vorhandene starke Regel verwässert, gelockert oder generischer? Steht jedes Thema in genau einer, der stärksten Fassung — keine zwei konkurrierenden Versionen?
- **Eine Quelle:** Nur die maßgebliche Datei bearbeitet? Stehen dieselben Regeln **nicht** zusätzlich in einer zweiten Datei (CLAUDE.md *und* AGENTS.md), die driften würde?
- **Fehlerfrei / Sprache:** Keine Regel doppelt, keine Überschrift mehrfach, nichts Vorhandenes versehentlich gelöscht oder verfälscht, keine Mischung aus deutscher und englischer Regelsprache — **ausgenommen die als Original gekennzeichneten Blöcke** samt ihrem Einleitungssatz (Schritt 3). Geprüft wird dort zweierlei: dass der Block wörtlich steht und dass die Einleitung davor in der Sprache der Zieldatei ist.
- **Treue:** Behaupte keine Änderung, die du nicht vorgenommen hast, und keine Prüfung, die du nicht durchgeführt hast. Verstecke keine inhaltliche Änderung als Formänderung.

Bei einem Fund: korrigieren, dann erneut prüfen — nicht auf unsauberem Stand abschließen.

## Schritt 8 — Änderungsprotokoll ausgeben

Gib zum Schluss ein knappes Protokoll aus. Es ist die menschenlesbare Form des Abdeckungs-Registers und macht das Ergebnis prüfbar:

Die Form des Protokolls steht in `references/protokollvorlage.md`; lies sie hier und gib das Protokoll in dieser Form aus. Ein vollständig ausgefülltes Beispiel steht in `references/beispiel.md`; lies es mit, sonst triffst du die Form, aber nicht die Konkretheit, an der das Protokoll prüfbar wird.

**Keine Zahl in dieser Zeile.** Eine Quote wie „38 von 38" sieht nach Messung aus, ist aber keine: Was als *eine* Regel zählt — Listenpunkt, Satz, Unterabschnitt —, ist nirgends festgelegt, also kommt ein zweiter Lauf auf ein anderes Ergebnis, und beide klingen gleich sicher. Ein Fehlschätzer fällt hier nicht auf, weil nichts ihn prüft. Die Zeile behauptet deshalb nur, was du tatsächlich getan hast. Steht auch nur eine Katalogregel unverbucht, ist sie falsch und du korrigierst das Register, statt die Zeile zu relativieren.

Steht unter „Auslagerungsreif markiert" oder „Empfohlen anzulegen" mindestens ein Eintrag, empfiehl ausdrücklich einen Lauf von `/cmd:project-structure` — es führt den Umzug mit Verlagerungs-Register und Verlustnachweis aus. Ohne diesen Hinweis bleibt die Datei bei der nächsten Sitzung so lang wie zuvor.

**Empfiehl es aber höchstens einmal.** Lief `project-structure` in diesem Projekt bereits — erkennbar am Wegweiser-Abschnitt `## Ablage` in der Zieldatei —, sind übrig gebliebene Blöcke solche, die jener Lauf bewusst liegen ließ. Dann legst du die Entscheidung vor („dieser Block gehört nach X, dort wurde er bisher nicht hingelegt — soll er?"), statt einen weiteren Lauf zu empfehlen. Zwei Skills, die einander im Wechsel empfehlen, schicken den Nutzer im Kreis.

Die letzte Zeile ist der Vollständigkeitsbeleg: Sind alle Katalogregeln in einer der Kategorien gelandet und ist verdichtet, ist die Datei vollständig, gehärtet und tokeneffizient — ohne dass eine starke Regel geschwächt wurde. Den Nachweis trägt das Register aus Schritt 4, nicht diese Zeile; sie referiert es nur.
