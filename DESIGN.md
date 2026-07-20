# DESIGN — Entwurfsnotizen zum `cmd`-Plugin

Maintainer-Dokumentation: warum die Skills so gebaut sind, welche Stellschrauben es gibt und welche Ansätze geprüft und **verworfen** wurden. Die Nutzungsanleitung steht in [`cmd/README.md`](cmd/README.md), der Einstieg im [Root-README](README.md).

## Namespace, Autoentdeckung, Umbenennen

Skills werden automatisch aus `cmd/skills/` entdeckt; kein Eintrag im Manifest nötig. Der **Aufrufname folgt dem Ordnernamen** (`plan-execute` → `/cmd:plan-execute`); das Frontmatter-`name` ist dabei nur ein Anzeige-Label.

Willst du das Präfix ändern, passe `name` in `cmd/.claude-plugin/plugin.json` an (früher trug jeder Command ein `my-`-Dateipräfix; diese Rolle übernimmt jetzt der Plugin-Namespace) — und trag den alten Namen in die `renames`-Map der `.claude-plugin/marketplace.json` ein, sonst bricht jede bestehende Installation.

## Lokaler Entwicklungs-Loop

Laden/testen: `claude --plugin-dir ./cmd`, nach Änderungen `/reload-plugins`. Manifeste prüfen: `claude plugin validate .` (vom Repo-Root). Verhaltens-Rauchtest: `bash scripts/smoke.sh` — startet echte Modell-Läufe, prüft nur den Eröffnungszug je Skill. Die erwartete Form der vollen Flows steht in [`examples/transcripts.md`](examples/transcripts.md).

## Frontmatter und Stellschrauben je Skill

Alle fünf Skills sind `disable-model-invocation: true` — nur manuell aufrufbar, kein Auto-Laden durch Claude. Das ist Absicht: es sind timing-kontrollierte Workflows.

### plan-execute

- `effort: high` ist fest gesetzt.
- `model: opus` ist eine Übernahme; bei Bedarf ändern oder entfernen.
- Bewusst **kein** `allowed-tools`: Der Skill erbt so die Session-Rechte des aktiven Modus.

### plan-grill

Das Interview läuft, bis keine offene Entscheidung mit Ergebniswirkung mehr im Pool ist (kein Abbruch, nur weil du zustimmst). Anpassbar:

- **Rückfrage-Form:** `AskUserQuestion` bei abzählbaren Optionen, Prosa als Grundfall — im Body im Abschnitt „Genau eine offene Frage zur Zeit". Ob `AskUserQuestion` über alle Surfaces (CLI/IDE/headless) verfügbar ist, ist **nicht dokumentiert**; deshalb ist Prosa der Grundfall und das Tool nur die Kür.

Frontmatter: `model: opus`, `effort: high` (nicht `xhigh` wie `plan-review`: interaktiv, viele kurze Züge). Beobachtbares Kriterium zum Nachschärfen auf `xhigh`: Der Skill stellt Fragen, deren Antwort im Faktenvorlauf auffindbar gewesen wäre, oder ordnet den Pool erkennbar nicht nach Abhängigkeit.

### plan-review

Der Review läuft rundenweise mit rotierenden Blickwinkeln, bis die Blickwinkel erschöpft sind (kein vorzeitiger Ruhe-Abbruch). Anpassbar:

- **Blickwinkel-Untergrenze:** in der Regel mindestens 3, bevor „erschöpft" erklärt wird (im Body im Abschnitt „Abarbeitung und Erschöpfungs-Abbruch" verstellbar).

Frontmatter: `model: opus`, `effort: xhigh`.

### session-learn

Die Retrospektive läuft, bis kein tragfähiges Learning mehr offen ist. Zu beachten:

- **Schreibt selbst nichts an die Zielorte** — die einzige Ausgabe ist ein Plan, den `plan-review` härtet und `plan-execute` anwendet. Die Ziele sind **projektlokal** (Projekt-CLAUDE.md/`references`/Repo, nie user-global; das Memory-System bleibt unangetastet) und damit git-reversibel. Wie bei `plan-grill` trägt diese Nicht-Schreiben-Regel allein die Body-Prosa, kein Frontmatter-Schutz.
- **End-of-Session gedacht:** der erzeugte Plan belegt die Plandatei und ersetzt den aktuellen Plan-Kontext — erst laufende Aufgaben abschließen und committen.
- **Frontmatter:** `model: opus`, `effort: high`.

### project-rules

Wendet fünf Disziplin-Kataloge gemeinsam auf eine bestehende `CLAUDE.md`/`AGENTS.md` an und verdichtet die Datei zuletzt in einem Token-Effizienz-Pass. Die Kataloge liegen in `references/` und werden **bedarfsgeladen** — der Body liest sie erst in Schritt 4 bzw. 7, nicht beim Aufruf.

Frontmatter: `model: opus`, `effort: xhigh` — der Skill plant alle Kataloge in *einem* Durchgang und schreibt die Datei einmal kohärent; das ist der aufwendigste Einzelschritt der Suite.

## Kein Frontmatter- oder Hook-Schutz gegen Schreibzugriffe

`plan-grill` und `session-learn` dürfen nichts schreiben. Diese Regel trägt **allein die Body-Prosa** — nicht das Frontmatter und kein Hook. Alle Kandidaten wurden geprüft und verworfen:

- `allowed-tools` **sperrt nichts**. Laut Doku „does not restrict which tools are available: every tool remains callable" — Vorab-Genehmigung gegen Permission-Prompts, keine Whitelist.
- `disallowed-tools` ist dokumentiert, taugt aber für einen **mehrschrittigen** Skill prinzipiell nicht: die Einschränkung „clears when you send your next message" — im Interview fiele sie schon nach der ersten Antwort weg. Unabhängig davon blieb der Key im headless-Test (`-p`) wirkungslos (`Write`/`Edit` im Pool). Beides zusammen: als Sperre unbrauchbar.
- Ein **PreToolUse-Hook** wäre der dokumentierte Weg, einen Tool-Call hart zu blocken — aber es gibt **keinen dokumentierten Weg, ihn skill-genau zu bedingen**: der Hook-Input kennt `tool_name`/`tool_input`, nicht den aktiven Skill (`context.currentSkill` ist nicht real). Ein Plugin-Hook auf `Write|Edit` feuerte damit über **alle** Skills und bräche `plan-review`/`plan-execute`, die schreiben müssen. Ein Hook im Skill-Frontmatter verfällt wiederum wie `disallowed-tools` nach der nächsten Nachricht — dieselbe Mehrschritt-Lücke.
- **Fazit:** Runtime-Enforcement ist mit dokumentierten, robusten Mitteln nicht erreichbar. Die Sperre steht als erster Absatz im jeweiligen Skill-Body („du interviewst mich, du setzt nichts um … kein Write, kein Edit … auch dann nicht, wenn ich dich darum bitte").

### Historie: die gestrichene `allowed-tools`-Liste in plan-review

Bis 0.2.0 stand bei `plan-review` eine Liste lesender Tools mit der Begründung „kein Schreibzugriff". Die war falsch: `allowed-tools` sperrt nichts, es genehmigt nur vorab und unterdrückt damit Permission-Prompts. Die Liste hat den Skill also nie am Schreiben gehindert. Ersatzlos gestrichen, statt einen Schutz vorzutäuschen; dass `plan-review` nichts umsetzt, trägt allein der erste Satz des Bodys. Spürbare Folge: bei `Read`/`Grep`/`git log` kann wieder ein Permission-Prompt kommen — willst du die weg, ist `allowed-tools` das richtige Mittel, aber als Bequemlichkeit deklariert, nicht als Schranke.

## Konventionen — geteiltes Vokabular

Die Skills teilen Vokabular. Diese Begriffe wortgleich halten, damit die Suite nicht auseinanderläuft:

- **Steelman** — den Gegenstand in einem Satz *wohlwollend* wiedergeben, bevor man ihn belastet (grill, review).
- **Erschöpfungs-Abbruch** — die Schleife endet erst, wenn nichts Neues mehr trägt (Entscheidungen bei grill, Blickwinkel bei review, Learnings bei session-learn), nie auf Zustimmung oder Ungeduld hin.
- **beobachtbares Kriterium** — ein prüfbarer Beleg (Testlauf, Exit-Code, Datei-/Lesezustand), kein „fehlerfrei"-Versprechen (execute; verwandt reviews „Befund am konkreten Schritt belegen").
- **stabile Kennung / revidierbar** — jedem eingearbeiteten Punkt eine über den Lauf stabile Kennung geben, damit gezielt zurückgenommen werden kann.

Drei Divergenzen sind **absichtlich** — nicht angleichen:

- **„als Chat-Notiz ausgeben, nicht …"** — grill: *nicht in eine Datei* (grill schreibt nichts); review: *nicht in den Plan* (review schreibt in den Plan, nur die Schlussnotiz nicht); execute schreibt Projektdateien, nur der Abschlussbericht bleibt im Chat. Der Zusatz kodiert, was der Skill *sonst* darf.
- **Ledger vs. Protokoll** — grill/review führen ein **Ledger** (Register mit Rücknahme-Kennung); execute führt ein **laufendes Protokoll** (Abweichungen/Ursachen/Korrekturen, ohne Kennung). Verschiedene Dinge, verschiedene Wörter — nicht gleichsetzen.
- **Kennungs-Schema** — grill flach („Entscheidung 3", rundenlos), review rundenbasiert („2.3"). Folgt der Struktur des jeweiligen Laufs.
