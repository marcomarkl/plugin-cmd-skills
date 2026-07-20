---
name: project-rules
description: >-
  Härtet/optimiert eine bestehende CLAUDE.md oder AGENTS.md mit fünf Disziplin-
  Katalogen plus Token-Effizienz-Pass: fehlende Regeln ergänzen, vage schärfen,
  Konflikte vorlegen, ohne Bedeutungsverlust verdichten.
argument-hint: "[optional: Pfad zur CLAUDE.md/AGENTS.md]"
disable-model-invocation: true
model: opus
effort: xhigh
---

Argument (optional, i. d. R. der Pfad zur Zieldatei): $ARGUMENTS — in Schritt 1 als Zieldatei-Hinweis auflösen, bei Prosa/Unklarheit dort normal die Datei bestimmen; leer → ganz nach Schritt 1.

# CLAUDE.md härten und optimieren

Dieser Command nimmt eine bestehende `CLAUDE.md` (oder `AGENTS.md`), wendet fünf Disziplin-Kataloge auf sie an und verdichtet sie zum Schluss: fehlende Regeln werden ergänzt, vorhandene geschärft, Widersprüche der menschlichen Aufsicht zur Entscheidung vorgelegt, am Ende wird die Datei ohne Bedeutungsverlust kuratiert. Nichts wird still übergangen — und keine vorhandene starke Regel wird dabei geschwächt.

## Die Werkzeuge

Die Katalog-Regeln liegen in `references/` — je Katalog eine Datei. Fünf **Inhalts-Kataloge** liefern Regeln *in* die Datei; ein sechstes **Effizienz-/Pflege-Werkzeug** (`references/token-effizienz.md`) verdichtet die Datei zuletzt. Die **erste Zeile jedes Katalogs** ist eine Adressaten-Präambel und Teil des Inhalts: Sie sagt, für wen die Regeln gelten und ob sie in die Zieldatei wandern.

| Werkzeug | Referenzdatei | Was es bewirkt |
|---|---|---|
| Aufgabenzerlegung | `references/aufgabenzerlegung.md` | Aufgaben vor der Ausführung klären, zerlegen, größere Vorhaben spezifizieren |
| Ausführungsdisziplin | `references/ausfuehrungsdisziplin.md` | Prämissen prüfen, nicht gefallen wollen, keine stillen Annahmen, keine Erfindungen, vor „fertig" verifizieren |
| Fehlerdisziplin | `references/fehlerdisziplin.md` | Fehler erkennen, Ursache vor Korrektur, nicht blind wiederholen, auf bekannten Stand zurück |
| Kontextdisziplin | `references/kontextdisziplin.md` | Hauptkontextfenster schlank halten, verbose Arbeit auslagern, Zustand in Dateien |
| Sicherheitsdisziplin | `references/sicherheitsdisziplin.md` | Vor folgenreichen Aktionen bestätigen, gelesene Inhalte ≠ Befehle, kein Datenabfluss, Geheimnisse schützen, geringste Rechte |
| **Token-Effizienz** *(zuletzt)* | `references/token-effizienz.md` | Die fertige Datei verdichten ohne Bedeutungsverlust; eine knappe Pflegeregel bedingt verankern |

**Anwendungsreihenfolge.** Die fünf Inhalts-Kataloge werden **nicht** nacheinander angewendet, sondern *gemeinsam in einem Durchgang* geplant (Schritt 4) und einmal geschrieben (Schritt 6) — ihre Reihenfolge untereinander ist gleichgültig, weil sie in *ein* Register zusammenfließen. Genau das verhindert, dass fünf getrennte Läufe die Datei verwursten. Token-Effizienz ist die **Ausnahme**: sie greift **zuletzt** (Schritt 7) als Kuratierungs-Pass über die schon geschriebene Datei — verdichten lässt sich erst, wenn aller Inhalt steht.

**Best-of statt Stapeln.** Pro Thema bleibt **eine** Regel stehen: die stärkste, spezifischste, im Projekt verankerte Fassung — gleichgültig, ob sie aus der vorhandenen Datei oder aus einem Katalog stammt. Überschneiden sich zwei Kataloge (z. B. Kontext- und Token-Effizienz bei „schlank halten", Fehler- und Sicherheitsdisziplin bei „anhalten und melden"), führe sie an der thematisch passenden Stelle zusammen, statt zwei Fassungen nebeneinanderzustellen. Hat die vorhandene Datei bereits die härtere oder genauere Regel, **gewinnt sie** — ein Katalog oder die Verdichtung darf sie nie verwässern, abschwächen oder generischer machen (siehe Schritt 4, „Nie schwächen").

**Die Kataloge.** Die fünf Inhalts-Kataloge in `references/` liefern die zu verbuchenden Regeln (Schritt 4). Der Token-Effizienz-Katalog (`references/token-effizienz.md`) ist anders gebaut: **Teil 2A** ist Arbeitsanweisung an dich (verdichten/formatieren — kommt **nie** als Text in die Datei), **Teil 2B** ist eine knappe Pflegeregel, die **bedingt** in die Datei wandert (siehe Schritt 7).

## Warum diese Vorgehensweise

Vier Fehler liegen bei dieser Aufgabe nahe, und die Schritte sind gegen genau sie gebaut:

- **Fünf getrennte Durchläufe** verwursten die Datei: jeder Lauf hängt einen eigenen Block an, dieselbe Überschrift erscheint mehrfach, die Datei wird inkohärent. Gegenmittel: **einmal lesen → alle Kataloge gemeinsam planen → einmal schreiben → zuletzt verdichten.**
- **Stilles Weglassen** untergräbt „vollständig". Wenn du eine Katalogregel übergehst, ohne es zu vermerken, kann niemand prüfen, ob die Datei wirklich gehärtet ist. Gegenmittel: ein **Abdeckungs-Register**, das jede einzelne Katalogregel verbucht.
- **Alles blind übernehmen** bläht die Datei auf und verwässert die Regeln, die zählen — jede Zeile kostet Kontext in *jeder* Session. Streiche, was Claude ohnehin richtig macht oder aus Code und Konfiguration ableiten kann (Stack-Fakten, Build-Befehle als bloße Aufzählung); behalte nur die wirklich tragenden, nicht ableitbaren Regeln. **Eine kurze, kuratierte Datei schlägt eine lange generierte.** Gegenmittel: die **Projektart** setzt die Relevanzschwelle, der **Token-Effizienz-Pass** (Schritt 7) verdichtet zum Schluss; was das Projekt nachweislich nicht braucht, wird *begründet* weggelassen.
- **Nur generische Disziplinen einsetzen** ergibt eine dünne, beliebige Datei — ein Katalog-Skelett, das in jedes Repo passte und dem konkreten Projekt nichts gibt. Kürzen heißt also *kuratieren, nicht abmagern*: jede übernommene Regel im Projekt verankern (in dessen Befehlen, Tools, Dateitypen, Workflows, Risiken), nicht nur Zeilen zählen. Eine Regel, die sich unverändert in jedes Repo kopieren ließe, ist noch nicht fertig. Dieser Punkt und der vorige spannen den Zielkorridor auf: **kurz und konkret und tragend** — nicht aufgebläht, aber auch nicht dünn-generisch.

## Ablauf im Überblick

1. Zieldatei auflösen und bestätigen (eine Quelle der Wahrheit)
2. Projektprofil bestimmen (steuert die Relevanzschwelle)
3. Ist-Stand vollständig lesen
4. Alle fünf Inhalts-Kataloge gemeinsam planen → Abdeckungs-Register
5. Konflikte bündeln und der Aufsicht zur Entscheidung vorlegen
6. Einmal kohärent schreiben
7. Token-Effizienz-/Kuratierungs-Pass (zuletzt)
8. Selbstprüfung (vollständig, nicht geschwächt, verdichtet)
9. Änderungsprotokoll ausgeben

---

## Schritt 1 — Zieldatei auflösen

Bevor du irgendetwas änderst, kläre, *welche* Datei gehärtet wird. Diese Regeln gelten projektweit und gehören an einen Ort, an dem sie greifen:

- **Projektweit** → Root-`CLAUDE.md`. Beim Arbeiten in einem Unterordner lädt Claude Code die Root-Datei ohnehin mit; eine Kopie pro Unterordner wäre Dopplung. Lass tiefere `CLAUDE.md` unangetastet (sie haben Vorrang vor der Root; eine global gemeinte Regel im Unterordner würde anderswo nicht greifen).
- **Über alle Projekte des Nutzers** → nutzerweite `~/.claude/CLAUDE.md` statt der Projektdatei.
- **CLAUDE.md vs. AGENTS.md — eine Quelle der Wahrheit:** `CLAUDE.md` liest Claude; `AGENTS.md` ist die werkzeugübergreifende Konvention, die Cursor, Codex, Copilot, Gemini CLI u. a. nativ lesen. Schreibe dieselben Regeln **nie in beide** Dateien — das ist keine sinnvolle Redundanz, sondern zwei fast identische Dateien, die auseinanderlaufen: sobald du eine editierst, ist die andere veraltet. Dieses **Drift-Problem wiegt schwerer als jede Platzierungsfrage.** Pflege genau **eine** maßgebliche Datei. Sollen mehrere Werkzeuge dieselben Regeln sehen, mach die zweite zu einem **Symlink** auf die erste (üblich: `CLAUDE.md` → `AGENTS.md`), statt den Inhalt zu kopieren. Ist `CLAUDE.md` schon ein Symlink auf `AGENTS.md`, bearbeite `AGENTS.md`. Existieren beide als getrennte echte Dateien mit überlappendem Inhalt, benenne das Drift-Risiko, härte nur die maßgebliche und biete an, die andere per Symlink zu konsolidieren.

Ist die Zieldatei nicht eindeutig (mehrere Kandidaten, oder die Anfrage nennt keinen Pfad), frag kurz nach, statt zu raten. Sichere die Datei vor dem Überschreiben (Git-Stand oder eine `.bak`-Kopie), damit ein Fehlversuch verlustfrei rückgängig zu machen ist.

**Existiert noch keine CLAUDE.md:** Biete an, eine frische, gehärtete Datei aus den Katalogen zu erzeugen (zusammen sind sie ein vollständiges Regelset). Bestätige vorher die Zieldatei **und** das Projektprofil (Schritt 2) — ohne Profil weißt du nicht, welche Regeln das Gerüst tragen.

## Schritt 2 — Projektprofil bestimmen

Nicht jede Disziplin wiegt für jede Projektart gleich. Eine CLAUDE.md für einen **autonomen Agenten** lebt von Sicherheits-, Fehler- und Kontextdisziplin; eine für einen **menschengesteuerten Coding-Assistenten** von Zerlegung, Ausführung und Build/Test/Lint. Das Profil setzt die *Relevanzschwelle* pro Regel — es entscheidet **nicht**, ob ein Katalog übersprungen wird. Alle fünf Inhalts-Kataloge werden immer durchgegangen (Schritt 4); das Profil steuert nur, was übernommen und was *begründet* weggelassen wird.

So bestimmst du das Profil:

1. Lies, was die bestehende CLAUDE.md über das Projekt sagt, und sieh dir vorhandene Signale an (Build-/Paketdateien, Agent-/MCP-Konfiguration, Deployment-/CI-Dateien, Sprache des Codes). Halte die Untersuchung eng — du brauchst nur genug, um das Profil zu wählen, nicht eine vollständige Repo-Tour.
2. Schlage das erkannte Profil vor und **bestätige es mit der menschlichen Aufsicht** (bei einer frischen Datei: frag es ab). Das Profil prägt das Ergebnis stark genug, um es nicht zu raten.

Die Profile sind **Denkhilfen, keine starren Tabellen**: Prüfe jede Zuordnung gegen das konkrete Projekt und weiche begründet ab, wenn es passt.

| Projektart | Kern (gründlich übernehmen) | Situativ (nur bei Anlass) |
|---|---|---|
| **Software/Coding (Mensch im Loop)** | Aufgabenzerlegung, Ausführung (inkl. Build/Test/Lint), Fehler | Sicherheit: commit/push/Geheimnisse ja, MCP/Deploy nur bei Evidenz · Kontext bei großem Repo |
| **Autonomer Agent / agentisches System** | Sicherheit, Fehler, Kontext, Ausführung | Aufgabenzerlegung je nach Aufgabenkomplexität |
| **Daten / Analyse / Research** | Ausführung (v. a. keine Erfindung), Kontext | Zerlegung · Sicherheit v. a. Datenabfluss/Geheimnisse · Fehler geringer |
| **Infrastruktur / DevOps** | Sicherheit (Deploy, CI, Secrets), Fehler (Rollback) | Zerlegung, Ausführung · Kontext bei großen Systemen |
| **Bibliothek / Framework** | Ausführung, Aufgabenzerlegung | Fehler/Kontext situativ · Sicherheit v. a. Secrets/geringste Rechte |

Passt keine Zeile, beschreibe das Profil in eigenen Worten anhand derselben Frage: *Handelt der Agent selbstständig nach außen? Läuft er lang? Berührt er Geheimnisse/Deploys? Wird gebaut und getestet?* Daraus folgt, welche Disziplinen tragen.

## Schritt 3 — Ist-Stand lesen

Lies die Zieldatei **vollständig**, bevor du planst. Ohne den Ist-Stand kannst du nicht entscheiden, was fehlt, was schon da ist und was nur vage formuliert ist. Erfasse dabei auch die **Sprache** der Datei: Katalogregeln werden in der Sprache der Zieldatei übernommen. Ist die CLAUDE.md englisch, übersetzt du die (deutschen) Katalogregeln, statt Sprachen zu mischen. Merke dir, **welche Regeln schon stark und spezifisch** sind — sie genießen Bestandsschutz (Schritt 4, „Nie schwächen").

## Schritt 4 — Alle fünf Inhalts-Kataloge gemeinsam planen (Abdeckungs-Register)

Das ist der Kern. **Lies jetzt die fünf mit diesem Skill gebündelten Inhalts-Kataloge unter `references/`** (`aufgabenzerlegung.md`, `ausfuehrungsdisziplin.md`, `fehlerdisziplin.md`, `kontextdisziplin.md`, `sicherheitsdisziplin.md`; Pfade relativ zum Skill-Ordner) und klassifiziere **jede einzelne Regel** in genau eine Kategorie. Das Ergebnis ist ein Register — gleichzeitig dein Arbeitsplan und der Nachweis der Vollständigkeit. Keine Regel verlässt diesen Schritt unverbucht. (Token-Effizienz ist kein Inhalts-Katalog und wird hier nicht verbucht, sondern in Schritt 7 angewendet.)

Kategorien:

- **`bereits vorhanden`** — Die Zieldatei deckt die Regel inhaltlich schon ab. Nichts tun. (Nimm keine Regel auf, die das Modell ohnehin befolgt oder die schon dasteht — Dopplung bläht auf und schwächt beide Fassungen.)
- **`geschärft`** — Eine vorhandene Regel verfolgt denselben Zweck, ist aber vage oder schwächer. Schreibe die *vorhandene* in eine testbare Direktive um, statt eine zweite danebenzustellen. Beispiel: aus „arbeite sorgfältig" wird die passende prüfbare Katalogregel. Schärfen geht nur in eine Richtung: vage→testbar, schwächer→stärker.
- **`ergänzt`** — Die Regel fehlt und ist für die Projektart relevant. Übernimm sie unter dem thematisch passenden vorhandenen Abschnitt; nur wenn keiner passt, lege einen neuen an.
- **`weggelassen`** — Die Regel ist für diese Projektart nicht relevant oder das Projekt braucht sie nachweislich nicht. **Immer mit kurzem Grund** (z. B. „kein MCP/keine autonomen Aktionen im Projekt" oder „kein Build-Schritt"). Das ist der einzige legitime Weg, eine Regel nicht zu übernehmen — still weglassen ist es nicht.
- **`konflikt`** — Die Regel widerspricht einer vorhandenen (Ton, Nachfrageverhalten, Kürze, Vorgehen). Nicht still überschreiben. Sammle sie für Schritt 5.

Leitplanken beim Klassifizieren:
- **Nie schwächen (Best-of):** Ist die vorhandene Regel strenger, spezifischer oder besser im Projekt verankert als die Katalogregel, behalte die vorhandene — verbuche sie als `bereits vorhanden`, nicht als `geschärft`. Eine Änderung, die eine vorhandene Regel lockerer, vager oder generischer macht, ist ein Fehler, kein Fortschritt. Pro Thema überlebt genau die stärkste Fassung, ihre Quelle (Datei oder Katalog) ist egal; überlappende Katalogregeln führst du zusammen, statt sie zu stapeln.
- **Sprache** der Zieldatei verwenden (siehe Schritt 3).
- **Im Projekt verankern:** Plane jede `ergänzt`- und `geschärft`-Regel in den konkreten Begriffen des Projekts — seine Befehle (die echten Build-/Test-/Lint-Skripte, nicht „führe Tests aus"), Tools (MCP-Server, git, Deploy-Ziel), Dateitypen (Notebooks, Komponenten, Stores) und Risiken. Die generische Katalogregel ist die Quelle, nicht das Ergebnis. Erfinde dabei keine Konventionen, die das Projekt nicht hergibt — das verstieße gegen die Ausführungsdisziplin; verankere nur in dem, was Datei, Prompt und sichtbare Signale tatsächlich zeigen.
- **Instruktionsbudget — kuratieren, nicht abmagern:** Streiche, was Claude ohnehin tut oder aus Code/Konfiguration ableiten kann (Stack-Fakten, reine Befehlsaufzählungen), und übernimm nichts doppelt. Schlank heißt: das Ableitbare, Redundante und Selbstverständliche weg — nicht: wenige, vage oder generische Regeln. Was bleibt, ist tragend und im Projekt verankert. Den eigentlichen Verdichtungsschliff macht Schritt 7.
- **Bedarfsgeladenes Wissen** nicht in die ständig geladene Root-CLAUDE.md zwingen: situatives oder selten gebrauchtes Wissen gehört in bedarfsgeladene Mechanismen (Skills, pfad-bezogene Regeln, verschachtelte CLAUDE.md). Das ist selbst eine Regel der Kontextdisziplin — wende sie auch auf deine eigenen Ergänzungen an.

## Schritt 5 — Konflikte bündeln und vorlegen

Sammle **alle** Konflikte aus Schritt 4 und lege sie der menschlichen Aufsicht in **einer** Entscheidungsrunde vor (nicht fünfmal unterbrechen). Nutze dafür eine strukturierte Rückfrage. Pro Konflikt nennst du:

- die **vorhandene** Regel (wörtlich),
- die **Katalog**-Regel (wörtlich),
- deine **Empfehlung**: in der Regel die strengere oder spezifischere Fassung, mit kurzer Begründung.

Die Entscheidung trifft die Aufsicht. **Fallback ohne menschliche Entscheidung** (z. B. unbeaufsichtigter Lauf): übernimm die strengere oder spezifischere Fassung und vermerke den Konflikt samt getroffener Wahl im Protokoll. Überschreibe nie still.

## Schritt 6 — Einmal kohärent schreiben

Jetzt erst editierst du die Datei — in *einem* Durchgang, der das ganze Register umsetzt:

- Ergänzungen unter den thematisch passenden Abschnitt, neue Abschnitte nur, wenn nötig. Verwandte Regeln aus verschiedenen Katalogen gehören zusammen (z. B. alle Sicherheitsregeln in einen Abschnitt), nicht in fünf nach Werkzeug getrennte Blöcke.
- Schärfungen ersetzen die vage Fassung an Ort und Stelle — immer vage→testbar, nie umgekehrt. Eine vorhandene starke Regel bleibt stark (Best-of, Schritt 4).
- Konfliktauflösungen nach der Entscheidung aus Schritt 5.
- **Im Projekt verankern (siehe Schritt 4):** Schreibe jede Regel in den konkreten Begriffen des Projekts — echte Befehle, Tools, Dateitypen, Workflows, Risiken — statt in generischen Formeln. Erhalte und schärfe die projektspezifische Substanz, die schon in der Datei steht, statt sie auf ein Disziplin-Gerüst einzudampfen. Eine gehärtete Datei soll konkreter und tragfähiger sein als vorher, nicht dünner.
- Struktur und Ton der vorhandenen Datei beibehalten. Formuliere Regeln als faktische, überprüfbare Aussagen, nicht als vage Vorgaben. (Den Feinschliff der Form macht Schritt 7 — hier zählt erst der Inhalt.)

## Schritt 7 — Token-Effizienz-/Kuratierungs-Pass (zuletzt)

Erst wenn aller Inhalt steht, **liest du jetzt `references/token-effizienz.md`** und wendest ihn an — als letzten Schliff über die ganze Datei. **Teil 2A** ist Arbeitsanweisung an dich und kommt **nie** als Text in die Datei; **Teil 2B** ist die einzige Stelle, die als Inhalt übernommen wird (bedingt, s. u.).

Verdichten (Teil 2A), ohne die Bedeutung zu verändern:
- Knappe Fachnotiz: Floskeln, Höflichkeitsrahmen und überflüssige Qualifizierer raus; Verben statt Nominalisierungen.
- Redundanz entfernen, auch katalogübergreifende: dieselbe Regel zweimal in anderen Worten kostet doppelt und schärft nichts — eine Fassung, am thematisch richtigen Ort.
- Falls beim Schreiben etwas Vages durchgerutscht ist: faktisch machen („vor dem Commit Tests laufen lassen" statt „Änderungen testen") — das spart Wörter *und* verbessert die Befolgbarkeit.
- Markdown; Listen für gleichartige Mengen (Regeln, Schritte, Werte, Pfade), Prosa für zusammenhängende Logik. Wichtiges nach oben. Root-Datei möglichst unter ~200 Zeilen — darüber situatives/selten Gebrauchtes in Skills oder pfad-bezogene Rules auslagern, nicht quetschen.

Die Grenze — hier hört Kürzen auf:
- Verdichten ist reine Formarbeit. Verändert eine Umformulierung die Aussage, ist sie keine Verdichtung — lass die Stelle stehen.
- Opfere **nie** einen Vorbehalt bei korrektheitskritischer Arbeit, eine nötige Disambiguierung oder die entscheidende Ausnahme der Kürze. Und schwäche **nie** eine starke Regel (vorhandene oder gerade ergänzte), um Tokens zu sparen — Best-of (Schritt 4) gilt auch hier. Im Zweifel zugunsten der eindeutigen, vollständigen Aussage.

Pflegeregel verankern (Teil 2B) — **bedingt:**
- Nur wenn der Agent diese Datei selbst fortschreibt, übernimm die knappe Pflegeregel aus Teil 2B (`references/token-effizienz.md`) unter einen passenden Abschnitt; gibt es schon eine Stil-/Pflegeregel, schärfe sie, statt sie zu doppeln.
- Wird die Datei ausschließlich von Menschen gepflegt, lass sie weg und vermerke das — sonst verbrauchst du Budget für eine selbstbezügliche Regel.

## Schritt 8 — Selbstprüfung

Lies die geschriebene Datei neu und prüfe:

- **Vollständig:** Steht jede Regel aller fünf Inhalts-Kataloge im Register (in *irgendeiner* der fünf Kategorien)? Eine unverbuchte Regel ist eine Lücke — schließe sie.
- **Nicht geschwächt (Best-of):** Wurde keine vorhandene starke Regel verwässert, gelockert oder generischer? Steht jedes Thema in genau einer, der stärksten Fassung — keine zwei konkurrierenden Versionen?
- **Verdichtet, aber bedeutungstreu:** Keine Redundanz, keine Floskeln, Wichtiges oben, Root möglichst unter ~200 Zeilen — und kein Vorbehalt, keine Disambiguierung, keine entscheidende Ausnahme der Kürze geopfert?
- **Eine Quelle:** Nur die maßgebliche Datei bearbeitet? Stehen dieselben Regeln **nicht** zusätzlich in einer zweiten Datei (CLAUDE.md *und* AGENTS.md), die driften würde?
- **Fehlerfrei / Sprache:** Keine Regel doppelt, keine Überschrift mehrfach, nichts Vorhandenes versehentlich gelöscht oder verfälscht, keine Mischung aus deutscher und englischer Regelsprache.
- **Treue:** Behaupte keine Änderung, die du nicht vorgenommen hast, und keine Prüfung, die du nicht durchgeführt hast. Verstecke keine inhaltliche Änderung als Formänderung.

Bei einem Fund: korrigieren, dann erneut prüfen — nicht auf unsauberem Stand abschließen.

## Schritt 9 — Änderungsprotokoll ausgeben

Gib zum Schluss ein knappes Protokoll aus. Es ist die menschenlesbare Form des Abdeckungs-Registers und macht das Ergebnis prüfbar:

```
## Gehärtet: <Pfad zur maßgeblichen Datei>
Projektprofil: <gewähltes Profil> (bestätigt: ja/nein)
Sprache: <de/en> · AGENTS.md/CLAUDE.md-Drift: <eine Quelle / Symlink vorgeschlagen / n/a>

### Ergänzt
- <Werkzeug> → <Abschnitt>: <Regel in Kurzform, im Projekt verankert>

### Geschärft
- <Werkzeug> → <Abschnitt>: <vorher vage „…" → jetzt testbar „…">

### Bereits vorhanden / stärker behalten (nicht angefasst)
- <Werkzeug>: <Regel> — schon abgedeckt bzw. vorhandene Fassung war stärker (Best-of)

### Bewusst weggelassen
- <Werkzeug>: <Regel> — Grund: <… / ableitbar aus Code / Projekt braucht es nicht>

### Konflikte
- <vorhanden> ↔ <Katalog> → Entscheidung: <…> (durch Aufsicht / Fallback strenger)

### Verdichtet (Token-Effizienz)
- <zusammengeführt / gekürzt / ausgelagert>; Pflegeregel: <verankert / bewusst nicht (Grund)>

### Abdeckung
<X von Y Katalogregeln verbucht> — alle fünf Inhalts-Kataloge durchgegangen, Token-Effizienz-Pass angewendet.
```

Die letzte Zeile ist der Vollständigkeitsbeleg: Sind alle Katalogregeln in einer der Kategorien gelandet und ist verdichtet, ist die Datei nachweislich vollständig, gehärtet und tokeneffizient — ohne dass eine starke Regel geschwächt wurde.
