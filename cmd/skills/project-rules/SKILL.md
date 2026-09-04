---
name: project-rules
description: >-
  Härtet/optimiert eine bestehende CLAUDE.md oder AGENTS.md mit acht Disziplin-
  Katalogen plus Token-Effizienz-Pass: fehlende Regeln ergänzen, vage schärfen,
  Konflikte vorlegen, Ablage und projekteigene Artefakte verankern, ohne
  Bedeutungsverlust verdichten.
argument-hint: "[optional: Pfad zur CLAUDE.md/AGENTS.md]"
disable-model-invocation: true
---

Argument (optional, i. d. R. der Pfad zur Zieldatei): $ARGUMENTS — in Schritt 1 als Zieldatei-Hinweis auflösen, bei Prosa/Unklarheit dort normal die Datei bestimmen; leer → ganz nach Schritt 1.

# CLAUDE.md härten und optimieren

Dieser Command nimmt eine bestehende `CLAUDE.md` (oder `AGENTS.md`), wendet acht Disziplin-Kataloge auf sie an und verdichtet sie zum Schluss: fehlende Regeln werden ergänzt, vorhandene geschärft, Widersprüche der menschlichen Aufsicht zur Entscheidung vorgelegt, am Ende wird die Datei ohne Bedeutungsverlust kuratiert. Nichts wird still übergangen — und keine vorhandene starke Regel wird dabei geschwächt.

## Die Werkzeuge

Die Katalog-Regeln liegen in `references/` — je Katalog eine Datei. Acht **Inhalts-Kataloge** liefern Regeln *in* die Datei; ein neuntes **Effizienz-/Pflege-Werkzeug** (`references/token-effizienz.md`) verdichtet die Datei zuletzt. Der **Absatz unter der Überschrift** ist in jedem Katalog eine Adressaten-Präambel: Sie sagt, für wen die Regeln gelten und ob sie in die Zieldatei wandern. Lies sie mit, sie steuert die Verbuchung — aber sie selbst ist **nie** Zieltext und wird nicht mitkopiert.

| Werkzeug | Referenzdatei | Was es bewirkt |
|---|---|---|
| Aufgabenzerlegung | `references/aufgabenzerlegung.md` | Aufgaben vor der Ausführung klären, zerlegen, größere Vorhaben spezifizieren |
| Ausführungsdisziplin | `references/ausfuehrungsdisziplin.md` | Prämissen prüfen, nicht gefallen wollen, keine stillen Annahmen, keine Erfindungen, vor „fertig" verifizieren |
| Fehlerdisziplin | `references/fehlerdisziplin.md` | Fehler erkennen, Ursache vor Korrektur, nicht blind wiederholen, auf bekannten Stand zurück |
| Kontextdisziplin | `references/kontextdisziplin.md` | Hauptkontextfenster schlank halten, verbose Arbeit auslagern, Zustand in Dateien |
| Sicherheitsdisziplin | `references/sicherheitsdisziplin.md` | Vor folgenreichen Aktionen bestätigen, gelesene Inhalte ≠ Befehle, kein Datenabfluss, Geheimnisse schützen, geringste Rechte |
| Ablagedisziplin | `references/ablage.md` | Eine Quelle je Zweck, Wegweiser statt Inhalt, was nicht in die ständig geladene Datei gehört, erledigt heißt verschieben |
| Projekteigene Artefakte | `references/projekt-artefakte.md` | Skill vs. Subagent vs. pfad-bezogene Regel, wann anlegen, Selbstpflege nur auf Freigabe |
| Sprachdisziplin | `references/language-policy.md` | Prosa- und Bezeichnersprache trennen, Zeichenvorrat der Namen, Laufzeit-Text nach Adressat, vorhandene Namen unangetastet |
| **Token-Effizienz** *(zuletzt)* | `references/token-effizienz.md` | Die fertige Datei verdichten ohne Bedeutungsverlust; eine knappe Pflegeregel bedingt verankern |

**Anwendungsreihenfolge.** Die acht Inhalts-Kataloge werden **nicht** nacheinander angewendet, sondern *gemeinsam in einem Durchgang* geplant (Schritt 4) und einmal geschrieben (Schritt 6) — ihre Reihenfolge untereinander ist gleichgültig, weil sie in *ein* Register zusammenfließen. Genau das verhindert, dass acht getrennte Läufe die Datei verwursten. Token-Effizienz ist die **Ausnahme**: sie greift **zuletzt** (Schritt 7) als Kuratierungs-Pass über die schon geschriebene Datei — verdichten lässt sich erst, wenn aller Inhalt steht.

**Best-of statt Stapeln.** Pro Thema bleibt **eine** Regel stehen: die stärkste, spezifischste, im Projekt verankerte Fassung — gleichgültig, ob sie aus der vorhandenen Datei oder aus einem Katalog stammt. Überschneiden sich zwei Kataloge (z. B. Kontext-, Ablage- und Token-Effizienz bei „schlank halten" und beim Auslagern, Ablage und Artefakte bei „was gehört nicht in die Root-Datei", Artefakte und Sicherheitsdisziplin bei „eigene Instruktionen ändern", Fehler- und Sicherheitsdisziplin bei „anhalten und melden"), führe sie an der thematisch passenden Stelle zusammen, statt zwei Fassungen nebeneinanderzustellen. Hat die vorhandene Datei bereits die härtere oder genauere Regel, **gewinnt sie** — ein Katalog oder die Verdichtung darf sie nie verwässern, abschwächen oder generischer machen (siehe Schritt 4, „Nie schwächen").

**Die Kataloge.** Die acht Inhalts-Kataloge in `references/` liefern die zu verbuchenden Regeln (Schritt 4). Zwei von ihnen (`ablage.md`, `projekt-artefakte.md`) tragen keine Pfade und Namensschemata; die stehen einmal in den Kanon-Dateien von `project-structure` und werden in Schritt 4 **direkt aus dem Body** geladen, nie über einen Verweis im Katalog. Der Token-Effizienz-Katalog (`references/token-effizienz.md`) ist anders gebaut: **Teil A** ist Arbeitsanweisung an dich (verdichten/formatieren — kommt **nie** als Text in die Datei), **Teil B** ist eine knappe Pflegeregel, die **bedingt** in die Datei wandert (siehe Schritt 7).

## Warum diese Vorgehensweise

Vier Fehler liegen bei dieser Aufgabe nahe, und die Schritte sind gegen genau sie gebaut:

- **Getrennte Durchläufe je Katalog** verwursten die Datei: jeder Lauf hängt einen eigenen Block an, dieselbe Überschrift erscheint mehrfach, die Datei wird inkohärent. Gegenmittel: **einmal lesen → alle Kataloge gemeinsam planen → einmal schreiben → zuletzt verdichten.**
- **Stilles Weglassen** untergräbt „vollständig". Wenn du eine Katalogregel übergehst, ohne es zu vermerken, kann niemand prüfen, ob die Datei wirklich gehärtet ist. Gegenmittel: ein **Abdeckungs-Register**, das jede einzelne Katalogregel verbucht.
- **Alles blind übernehmen** bläht die Datei auf und verwässert die Regeln, die zählen — jede Zeile kostet Kontext in *jeder* Session. Streiche, was Claude ohnehin richtig macht oder aus Code und Konfiguration ableiten kann (Stack-Fakten, Build-Befehle als bloße Aufzählung); behalte nur die wirklich tragenden, nicht ableitbaren Regeln. **Eine kurze, kuratierte Datei schlägt eine lange generierte.** Gegenmittel: die **Projektart** setzt die Relevanzschwelle, der **Token-Effizienz-Pass** (Schritt 7) verdichtet zum Schluss; was das Projekt nachweislich nicht braucht, wird *begründet* weggelassen.
- **Nur generische Disziplinen einsetzen** ergibt eine dünne, beliebige Datei — ein Katalog-Skelett, das in jedes Repo passte und dem konkreten Projekt nichts gibt. Kürzen heißt also *kuratieren, nicht abmagern*: jede übernommene Regel im Projekt verankern (in dessen Befehlen, Tools, Dateitypen, Workflows, Risiken), nicht nur Zeilen zählen. Eine Regel, die sich unverändert in jedes Repo kopieren ließe, ist noch nicht fertig. Dieser Punkt und der vorige spannen den Zielkorridor auf: **kurz und konkret und tragend** — nicht aufgebläht, aber auch nicht dünn-generisch.

## Ablauf im Überblick

1. Zieldatei auflösen und bestätigen (eine Quelle der Wahrheit)
2. Projektprofil bestimmen (steuert die Relevanzschwelle)
3. Ist-Stand vollständig lesen, dazu eine knappe Ablage-Inventur
4. Alle acht Inhalts-Kataloge gemeinsam planen → Abdeckungs-Register
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
- **CLAUDE.md vs. AGENTS.md — eine Quelle der Wahrheit:** `CLAUDE.md` liest Claude; `AGENTS.md` ist die werkzeugübergreifende Konvention, die Cursor, Codex, Copilot, Gemini CLI u. a. nativ lesen. Schreibe dieselben Regeln **nie in beide** Dateien — das ist keine sinnvolle Redundanz, sondern zwei fast identische Dateien, die auseinanderlaufen: sobald du eine editierst, ist die andere veraltet. Dieses **Drift-Problem wiegt schwerer als jede Platzierungsfrage.** Pflege genau **eine** maßgebliche Datei. Claude Code liest `AGENTS.md` **nicht** von sich aus; es braucht immer eine `CLAUDE.md`. Sollen mehrere Werkzeuge dieselben Regeln sehen, gibt es dafür zwei Wege, beide ohne Kopie: ein **Symlink** `CLAUDE.md` → `AGENTS.md`, oder eine `CLAUDE.md`, die als erste Zeile `@AGENTS.md` importiert und darunter Claude-spezifische Zusätze trägt. Der Import ist der robustere Weg — er erlaubt den Zusatz und braucht unter Windows keine Administratorrechte, die ein Symlink dort verlangt. Ist `CLAUDE.md` schon Symlink oder Import-Hülle, bearbeite `AGENTS.md`; Claude-spezifische Regeln (Skills, Subagents, `.claude/rules/`) gehören dann unter den Import in die `CLAUDE.md`, nicht in die werkzeugübergreifende Datei, wo sie für andere Werkzeuge ins Leere zeigen. Existieren beide als getrennte echte Dateien mit überlappendem Inhalt, benenne das Drift-Risiko, härte nur die maßgebliche und biete an, die andere per Symlink zu konsolidieren.

Ist die Zieldatei nicht eindeutig (mehrere Kandidaten, oder die Anfrage nennt keinen Pfad), frag kurz nach, statt zu raten. Sichere die Datei vor dem Überschreiben (Git-Stand oder eine `.bak`-Kopie), damit ein Fehlversuch verlustfrei rückgängig zu machen ist.

**Existiert noch keine CLAUDE.md:** Biete an, eine frische, gehärtete Datei aus den Katalogen zu erzeugen (zusammen sind sie ein vollständiges Regelset). Bestätige vorher die Zieldatei **und** das Projektprofil (Schritt 2) — ohne Profil weißt du nicht, welche Regeln das Gerüst tragen.

## Schritt 2 — Projektprofil bestimmen

Nicht jede Disziplin wiegt für jede Projektart gleich. Eine CLAUDE.md für einen **autonomen Agenten** lebt von Sicherheits-, Fehler- und Kontextdisziplin; eine für einen **menschengesteuerten Coding-Assistenten** von Zerlegung, Ausführung und Build/Test/Lint. Das Profil setzt die *Relevanzschwelle* pro Regel — es entscheidet **nicht**, ob ein Katalog übersprungen wird. Alle acht Inhalts-Kataloge werden immer durchgegangen (Schritt 4); das Profil steuert nur, was übernommen und was *begründet* weggelassen wird. Bei Ablage und Artefakten wirkt die Schwelle besonders stark: Ein kleines Repo mit einer Handvoll Dateien braucht weder Ablagestruktur noch eigene Skills, und „begründet weggelassen" ist dort das richtige Ergebnis, nicht ein Versäumnis. **Die Schwelle entscheidet dabei über das Anlegen, nicht über die Regel.** Dass gerade kein Artefakt fällig ist, heißt nicht, dass die Datei die Regel nicht trägt, wann eines fällig wird — die wirkt erst in der Zukunft, in der du nicht mehr danebenstehst. Weglassen ist nur begründet, wenn das Projekt so klein oder kurzlebig ist, dass derselbe Handgriff realistisch kein drittes Mal auftritt. Sonst gehört die Regel in die Datei, auch wenn der Ordner dafür noch leer ist.

So bestimmst du das Profil:

1. Lies, was die bestehende CLAUDE.md über das Projekt sagt, und sieh dir vorhandene Signale an (Build-/Paketdateien, Agent-/MCP-Konfiguration, Deployment-/CI-Dateien, Sprache des Codes). Halte die Untersuchung eng — du brauchst nur genug, um das Profil zu wählen, nicht eine vollständige Repo-Tour.
2. Schlage das erkannte Profil vor und **bestätige es mit der menschlichen Aufsicht** (bei einer frischen Datei: frag es ab). Das Profil prägt das Ergebnis stark genug, um es nicht zu raten.

Die Profile sind **Denkhilfen, keine starren Tabellen**: Prüfe jede Zuordnung gegen das konkrete Projekt und weiche begründet ab, wenn es passt.

| Projektart | Kern (gründlich übernehmen) | Situativ (nur bei Anlass) |
|---|---|---|
| **Software/Coding (Mensch im Loop)** | Aufgabenzerlegung, Ausführung (inkl. Build/Test/Lint), Fehler, Sprache | Sicherheit: commit/push/Geheimnisse ja, MCP/Deploy nur bei Evidenz · Kontext bei großem Repo · Ablage ab mehreren Mitwirkenden oder langer Laufzeit; Artefakte *anlegen* dann, die Regel dafür schon ab langer Laufzeit |
| **Autonomer Agent / agentisches System** | Sicherheit, Fehler, Kontext, Ausführung, Ablage | Aufgabenzerlegung je nach Aufgabenkomplexität · Artefakte, sobald Abläufe sich wiederholen · Sprache, sobald das System selbst Code schreibt |
| **Daten / Analyse / Research** | Ausführung (v. a. keine Erfindung), Kontext, Ablage (Befunde überleben die Session) | Zerlegung · Sicherheit v. a. Datenabfluss/Geheimnisse · Fehler geringer · Artefakte für wiederkehrende Auswertungen · Sprache bei Bezeichnern in Notebooks und Skripten |
| **Infrastruktur / DevOps** | Sicherheit (Deploy, CI, Secrets), Fehler (Rollback), Artefakte (Runbooks als Skill), Sprache (Branch-Namen, Konfig-Schlüssel, DB-Spalten) | Zerlegung, Ausführung · Kontext bei großen Systemen · Ablage v. a. für Entscheidungen |
| **Bibliothek / Framework** | Ausführung, Aufgabenzerlegung, Ablage (Entscheidungen und öffentliche Doku), Sprache (öffentliche API-Namen wiegen hier am schwersten) | Fehler/Kontext situativ · Sicherheit v. a. Secrets/geringste Rechte · Artefakte *anlegen* selten nötig, die Regel dafür trotzdem ab langer Laufzeit |

Passt keine Zeile, beschreibe das Profil in eigenen Worten anhand derselben Frage: *Handelt der Agent selbstständig nach außen? Läuft er lang? Berührt er Geheimnisse/Deploys? Wird gebaut und getestet?* Daraus folgt, welche Disziplinen tragen.

## Schritt 3 — Ist-Stand lesen

Lies die Zieldatei **vollständig**, bevor du planst. Ohne den Ist-Stand kannst du nicht entscheiden, was fehlt, was schon da ist und was nur vage formuliert ist. Erfasse dabei auch die **Sprache** der Datei: Katalogregeln werden in der Sprache der Zieldatei übernommen. Ist die CLAUDE.md englisch, übersetzt du die (deutschen) Katalogregeln, statt Sprachen zu mischen. Merke dir, **welche Regeln schon stark und spezifisch** sind — sie genießen Bestandsschutz (Schritt 4, „Nie schwächen").

**Ablage-Inventur.** Halte anschließend fest, welche Orte das Projekt für dauerhaftes Wissen schon hat — ohne sie lassen sich die Kataloge Ablage und Artefakte nicht planen, weil du sonst Regeln für Orte schriebst, die es nicht gibt, oder neben vorhandenen einen zweiten aufmachst. Erfasst wird nur, was existiert:

- Aufgaben und offene Punkte: Issue-Tracker (Remote in `git remote -v`, `.github/`), `TODO.md`, `backlog/`
- Entscheidungen: `docs/decisions/`, `docs/adr/`, Abschnitte in vorhandener Doku
- Wissen und Doku: `docs/`, `README.md`, Wiki — dabei prüfen, ob `docs/` generiert wird (Konfiguration eines Doku-Generators im Repo); ein generierter Ordner ist kein Ablageort
- Erledigtes: `CHANGELOG.md`, Releases, git-Historie
- Agenten-Artefakte: `.claude/skills/`, `.claude/agents/`, `.claude/rules/`, verschachtelte `CLAUDE.md`
- Streudateien, die nirgends dazugehören: `NOTES.md`, `SCRATCH.md`, `IDEEN.md` und Ähnliches

Halte das eng — ein `ls` der einschlägigen Orte genügt, keine Repo-Tour und keine Inhaltsanalyse. Du brauchst nur die Antwort „existiert / existiert nicht / ist generiert".

## Schritt 4 — Alle acht Inhalts-Kataloge gemeinsam planen (Abdeckungs-Register)

Das ist der Kern. **Lies jetzt die acht mit diesem Skill gebündelten Inhalts-Kataloge unter `references/`** (`aufgabenzerlegung.md`, `ausfuehrungsdisziplin.md`, `fehlerdisziplin.md`, `kontextdisziplin.md`, `sicherheitsdisziplin.md`, `ablage.md`, `projekt-artefakte.md`, `language-policy.md`; Pfade relativ zum Skill-Ordner). **Lies dazu direkt von hier aus** — nicht über einen Verweis in einem der Kataloge — die beiden Kanon-Dateien `../project-structure/references/ablage-kanon.md` (Orte, Namensschemata, Ladezeitpunkte) und `../project-structure/references/artefakt-kanon.md` (Pfade und Frontmatter-Keys), sobald Katalog 6 oder 7 für dieses Projekt tragen. Sie stehen dort einmal und werden hier nicht dupliziert; von Referenz zu Referenz verkettet würden sie womöglich nur angelesen statt vollständig gelesen. Klassifiziere dann **jede einzelne Regel** in genau eine Kategorie. Das Ergebnis ist ein Register — gleichzeitig dein Arbeitsplan und der Nachweis der Vollständigkeit. Keine Regel verlässt diesen Schritt unverbucht. (Token-Effizienz ist kein Inhalts-Katalog und wird hier nicht verbucht, sondern in Schritt 7 angewendet.)

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
- **Bedarfsgeladenes Wissen** nicht in die ständig geladene Root-CLAUDE.md zwingen: situatives oder selten gebrauchtes Wissen gehört in bedarfsgeladene Mechanismen (Skills, `.claude/rules/` **mit** `paths:`, verschachtelte CLAUDE.md). Das ist selbst eine Regel der Kontext- und Ablagedisziplin: Sie geht als Inhalt in die Zieldatei **und** bindet dich beim Schreiben deiner Ergänzungen. Der „nicht an dich"-Satz der Präambel regelt nur, wessen Verhalten der Regeltext beschreibt, und hebt das nicht auf. Nicht bedarfsgeladen und damit keine Entlastung sind `@pfad`-Importe und `.claude/rules/` **ohne** `paths:`; beide laden beim Sessionstart mit.
- **Geltungsbereich lesen, nicht als Filter missdeuten.** Jede Katalogpräambel und mancher Abschnittstitel nennt eine Bedingung („bei größeren Vorhaben", „sobald Wissen situativ gebraucht wird"). Sie bedingt **das Verhalten, das die Regel beschreibt**, nie ihre Aufnahme in die Datei. Ausgeschlossen wird eine Regel allein über die Kategorie `weggelassen` und mit Grund — nie deshalb, weil ihr Auslöser gerade nicht vorliegt. Sie wirkt in der Zukunft, in der du nicht mehr danebenstehst. Für Artefakte schärft `projekt-artefakte.md` denselben Punkt noch enger.
- **Die Präambel bestimmt den Adressaten, nicht die Übernahme.** „Übernimm sie als Inhalt in die Zieldatei" heißt: Diese Regeln sind Zieltext und keine Anweisung an dich. *Ob* eine einzelne Regel hineinwandert, entscheidet erst dieses Register mit seinen fünf Kategorien. Beides gilt nebeneinander; ein Katalog wird nie am Register vorbei vollständig hineinkopiert.
- **Nur verankern, was es gibt:** Ablage- und Artefaktregeln nennen ausschließlich Orte, die die Inventur aus Schritt 3 belegt hat, oder solche, deren Anlegen du in Schritt 9 ausdrücklich empfiehlst. Ein Verweis auf einen nicht existierenden Pfad ist eine Erfindung und verstößt gegen die Ausführungsdisziplin.

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
- **Im Projekt verankern (siehe Schritt 4):** Schreibe jede Regel in den konkreten Begriffen des Projekts — echte Befehle, Tools, Dateitypen, Workflows, Risiken — statt in generischen Formeln. Erhalte und schärfe die projektspezifische Substanz, die schon in der Datei steht, statt sie auf ein Disziplin-Gerüst einzudampfen. Eine gehärtete Datei soll konkreter und tragfähiger sein als vorher, nicht dünner.
- Struktur und Ton der vorhandenen Datei beibehalten. Formuliere Regeln als faktische, überprüfbare Aussagen, nicht als vage Vorgaben. (Den Feinschliff der Form macht Schritt 7 — hier zählt erst der Inhalt.)

## Schritt 7 — Token-Effizienz-/Kuratierungs-Pass (zuletzt)

Erst wenn aller Inhalt steht, **liest du jetzt `references/token-effizienz.md`** und wendest ihn an — als letzten Schliff über die ganze Datei. **Teil A** ist Arbeitsanweisung an dich und kommt **nie** als Text in die Datei; **Teil B** ist die einzige Stelle, die als Inhalt übernommen wird (bedingt, s. u.).

Verdichten (Teil A), ohne die Bedeutung zu verändern:
- Knappe Fachnotiz: Floskeln, Höflichkeitsrahmen und überflüssige Qualifizierer raus; Verben statt Nominalisierungen.
- Redundanz entfernen, auch katalogübergreifende: dieselbe Regel zweimal in anderen Worten kostet doppelt und schärft nichts — eine Fassung, am thematisch richtigen Ort.
- Falls beim Schreiben etwas Vages durchgerutscht ist: faktisch machen („vor dem Commit Tests laufen lassen" statt „Änderungen testen") — das spart Wörter *und* verbessert die Befolgbarkeit.
- Markdown; Listen für gleichartige Mengen (Regeln, Schritte, Werte, Pfade), Prosa für zusammenhängende Logik. Wichtiges nach oben. Root-Datei möglichst unter ~200 Zeilen — darüber situatives/selten Gebrauchtes in Skills oder pfad-bezogene Rules auslagern, nicht quetschen.

**Dieser Skill verschiebt nichts und legt nichts an.** Er bleibt bei der Zieldatei. Findest du auslagerungsreife Blöcke — situatives Wissen, ein mehrschrittiges Runbook, Regeln, die nur einen Dateibereich betreffen —, dann *markiere* sie mit dem vorgesehenen Ziel und lass sie vorerst stehen. Ausgeführt wird der Umzug von `/cmd:project-structure`, das dafür ein Verlagerungs-Register führt und eine eigene Freigabe einholt. Der Grund für die Trennung: Ein Umzug über mehrere Dateien braucht Rückweg und Verlustnachweis je Datei; beides passt nicht in den einen kohärenten Schreibvorgang, von dem dieser Skill lebt. Reiß hier also keine Inhalte heraus, für die es noch kein Ziel gibt — das wäre der Informationsverlust, den die Ablagedisziplin gerade verhindern soll.

Die Grenze — hier hört Kürzen auf:
- Verdichten ist reine Formarbeit. Verändert eine Umformulierung die Aussage, ist sie keine Verdichtung — lass die Stelle stehen.
- Opfere **nie** einen Vorbehalt bei korrektheitskritischer Arbeit, eine nötige Disambiguierung oder die entscheidende Ausnahme der Kürze. Und schwäche **nie** eine starke Regel (vorhandene oder gerade ergänzte), um Tokens zu sparen — Best-of (Schritt 4) gilt auch hier. Im Zweifel zugunsten der eindeutigen, vollständigen Aussage.

Pflegeregel verankern (Teil B) — **bedingt:**
- Nur wenn der Agent diese Datei selbst fortschreibt, übernimm die knappe Pflegeregel aus Teil B (`references/token-effizienz.md`) unter einen passenden Abschnitt; gibt es schon eine Stil-/Pflegeregel, schärfe sie, statt sie zu doppeln.
- Wird die Datei ausschließlich von Menschen gepflegt, lass sie weg und vermerke das — sonst verbrauchst du Budget für eine selbstbezügliche Regel.

## Schritt 8 — Selbstprüfung

Lies die geschriebene Datei neu und prüfe:

- **Vollständig:** Steht jede Regel aller acht Inhalts-Kataloge im Register (in *irgendeiner* der fünf Kategorien)? Eine unverbuchte Regel ist eine Lücke — schließe sie.
- **Nichts erfunden, nichts verschoben:** Existiert jeder in der Datei genannte Ablage- oder Artefaktpfad tatsächlich, oder ist er als Empfehlung gekennzeichnet? Wurde keine Datei verschoben, kein Ordner angelegt, kein Inhalt ohne Ziel herausgelöst?
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
Prosasprache: <de/en> · AGENTS.md/CLAUDE.md-Drift: <eine Quelle / Symlink vorgeschlagen / n/a>

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
- <zusammengeführt / gekürzt>; Pflegeregel: <verankert / bewusst nicht (Grund)>

### Ablage und Artefakte
- Vorgefunden: <Orte aus der Inventur, je Zweck der maßgebliche>
- Verankert: <welcher Zweck zeigt auf welchen Pfad>
- Auslagerungsreif markiert (nicht verschoben): <Block → vorgesehenes Ziel>
- Empfohlen anzulegen: <Ort/Artefakt> — Grund: <…>

### Abdeckung
Alle acht Inhalts-Kataloge durchgegangen, jede Regel in genau einer Kategorie verbucht, Token-Effizienz-Pass angewendet.
```

**Keine Zahl in dieser Zeile.** Eine Quote wie „38 von 38" sieht nach Messung aus, ist aber keine: Was als *eine* Regel zählt — Listenpunkt, Satz, Unterabschnitt —, ist nirgends festgelegt, also kommt ein zweiter Lauf auf ein anderes Ergebnis, und beide klingen gleich sicher. Ein Fehlschätzer fällt hier nicht auf, weil nichts ihn prüft. Die Zeile behauptet deshalb nur, was du tatsächlich getan hast. Steht auch nur eine Katalogregel unverbucht, ist sie falsch und du korrigierst das Register, statt die Zeile zu relativieren.

Steht unter „Auslagerungsreif markiert" oder „Empfohlen anzulegen" mindestens ein Eintrag, empfiehl ausdrücklich einen Lauf von `/cmd:project-structure` — es führt den Umzug mit Verlagerungs-Register und Verlustnachweis aus. Ohne diesen Hinweis bleibt die Datei bei der nächsten Sitzung so lang wie zuvor.

**Empfiehl es aber höchstens einmal.** Lief `project-structure` in diesem Projekt bereits — erkennbar am Wegweiser-Abschnitt `## Ablage` in der Zieldatei —, sind übrig gebliebene Blöcke solche, die jener Lauf bewusst liegen ließ. Dann legst du die Entscheidung vor („dieser Block gehört nach X, dort wurde er bisher nicht hingelegt — soll er?"), statt einen weiteren Lauf zu empfehlen. Zwei Skills, die einander im Wechsel empfehlen, schicken den Nutzer im Kreis.

Die letzte Zeile ist der Vollständigkeitsbeleg: Sind alle Katalogregeln in einer der Kategorien gelandet und ist verdichtet, ist die Datei vollständig, gehärtet und tokeneffizient — ohne dass eine starke Regel geschwächt wurde. Den Nachweis trägt das Register aus Schritt 4, nicht diese Zeile; sie referiert es nur.
