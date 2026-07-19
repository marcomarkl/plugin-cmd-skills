# cmd — persönliches Planungs-Toolkit

Ein Plugin mit vier Skills rund um Klären, Planen, Reviewen und Umsetzen. Der Plugin-Name `cmd` (aus `.claude-plugin/plugin.json`) bildet den Namespace, deshalb lauten die Aufrufe:

- `/cmd:plan-grill` — dich gnadenlos zu einem Vorhaben interviewen, die Entscheidungen einzeln in Abhängigkeits- und Tragweitenreihenfolge auflösen und revidierbar protokollieren. Gedacht vor `/plan`.
- `/cmd:plan-review` — den zuletzt erstellten Plan in rotierenden Blickwinkeln reviewen und die belastbaren Befunde einarbeiten. Gedacht nach `/plan`.
- `/cmd:plan-execute` — den freigegebenen Plan vollständig umsetzen und jeden Schritt gegen ein beobachtbares Kriterium verifizieren; hält bei einem Fund ausserhalb des Plans oder einer Klassifikator-Blockade an und fragt nach. Gedacht nach dem Verlassen des Plan-Modus.
- `/cmd:project-rules` — eine bestehende `CLAUDE.md`/`AGENTS.md` mit fünf Disziplin-Katalogen härten und token-effizient verdichten. Eigenständig nutzbar.

`plan-grill` und `plan-review` gehen unterschiedlich mit ihrem Ergebnis um, und zwar nach einer Frage: **existiert schon ein Plan zum Ändern?** grill läuft vor `/plan` — es gibt noch keinen Plan, also übergibt es die Entscheidungen als selbsttragenden, `/plan`-tauglichen Block, statt zu schreiben. review läuft nach `/plan` — der Plan existiert, also arbeitet es die Befunde direkt in ihn ein. Beide machen ihr Ergebnis über stabile Kennungen zurücknehmbar (grill „nimm Entscheidung 3 zurück", review „nimm Änderung 2.3 zurück"); der Unterschied ist nur, woran die Kennung hängt — an der noch offenen Entscheidung oder am schon geänderten Plan. (`plan-execute` und `project-rules` schreiben ohnehin und fallen nicht unter diese Regel.)

Alle vier sind `disable-model-invocation: true` (nur manuell aufrufbar, kein Auto-Laden durch Claude) — timing-kontrollierte Workflows.

## Pipeline

Die drei plan-Skills bilden eine Kette um den Plan-Modus, jede Naht mit einem klaren Vertrag:

```
plan-grill  →  /plan  →  plan-review  →  ExitPlanMode  →  plan-execute
 (klärt)      (baut)     (härtet)                         (setzt um)
```

- **grill → /plan:** grill schreibt nichts, sondern gibt einen selbsttragenden, `/plan`-tauglichen Übergabeblock aus (Ziel, feststehende Vorgaben, offene Punkte). `/plan` übernimmt ihn verlustarm als Eingabe.
- **/plan → review:** review arbeitet auf dem existierenden Plan und härtet ihn in Runden; das Ergebnis ersetzt den Plan.
- **review → execute:** execute setzt den **freigegebenen** Plan um. **Vertrag:** execute erwartet, dass der Plan **pro Schritt ein beobachtbares Verifikationskriterium** trägt. Fehlt eins, leitet execute das schwächste hinreichende selbst ab (siehe execute-Body) — der Plan-Modus-Workflow verlangt ohnehin eine Verifikationssektion, die Kriterien sind also erwartbar vorhanden.

Jeder Skill ist einzeln nutzbar; die Kette ist die Kür, nicht die Pflicht.

## Struktur

```
cmd/
├── .claude-plugin/plugin.json      # Manifest; name "cmd" setzt den Namespace
├── README.md                       # diese Datei
└── skills/
    ├── plan-execute/SKILL.md
    ├── plan-grill/SKILL.md
    ├── project-rules/SKILL.md
    └── plan-review/SKILL.md
```

Skills werden automatisch aus `skills/` entdeckt; kein Eintrag im Manifest nötig. Der **Aufrufname folgt dem Ordnernamen** (`plan-execute` → `/cmd:plan-execute`); das Frontmatter-`name` ist dabei nur ein Anzeige-Label. Willst du das Präfix ändern, passe `name` in `plugin.json` an (früher trug jeder Command ein `my-`-Dateipräfix; diese Rolle übernimmt jetzt der Plugin-Namespace) — und trag den alten Namen in die `renames`-Map der `marketplace.json` ein, sonst bricht jede bestehende Installation.

Lokal laden/testen: `claude --plugin-dir ./cmd`, nach Änderungen `/reload-plugins`. Manifest prüfen: `claude plugin validate ./cmd`.

## plan-execute — Auto mode

Zielmodus für die Umsetzung ist **Auto mode**. Der Skill kann den Modus **nicht selbst setzen** — er muss vorher aktiv sein.

Auto mode aktivieren (einmaliges Opt-in):
1. Verfügbarkeit prüfen über den Shift+Tab-Zyklus oder `/status`. Erscheint Auto mode nicht, ist eine Voraussetzung nicht erfüllt (Version, Modell oder Owner-Freigabe bei Team/Enterprise).
2. `claude --enable-auto-mode`, dann per Shift+Tab auf Auto mode wechseln.
3. Dauerhaft: `permissions.defaultMode: "auto"` **nur** in `~/.claude/settings.json` (projektbezogene Settings werden für diesen Wert ignoriert).

Auto mode ist ein **Research Preview ohne Sicherheitsgarantie** — nur in isolierter Umgebung nutzen.

Design-Notizen zum Frontmatter:
- `effort: high` ist fest gesetzt.
- `model: opus` ist eine Übernahme; bei Bedarf ändern oder entfernen.
- Bewusst **kein** `allowed-tools`: Der Skill erbt so die Session-Rechte des aktiven Modus.

## plan-grill — Tuning

Das Interview läuft, bis keine offene Entscheidung mit Ergebniswirkung mehr im Pool ist (kein Abbruch, nur weil du zustimmst). Anpassbar:
- **Rückfrage-Form:** `AskUserQuestion` bei abzählbaren Optionen, Prosa als Grundfall — im Body im Abschnitt „Genau eine offene Frage zur Zeit". Ob `AskUserQuestion` über alle Surfaces (CLI/IDE/headless) verfügbar ist, ist **nicht dokumentiert**; deshalb ist Prosa der Grundfall und das Tool nur die Kür.

Frontmatter: `model: opus`, `effort: high` (nicht `xhigh` wie `plan-review`: interaktiv, viele kurze Züge). Beobachtbares Kriterium zum Nachschärfen auf `xhigh`: Der Skill stellt Fragen, deren Antwort im Faktenvorlauf auffindbar gewesen wäre, oder ordnet den Pool erkennbar nicht nach Abhängigkeit.

**Kein Frontmatter- oder Hook-Schutz gegen Schreibzugriffe — die Nicht-Änderungs-Regel steht im Body.** Alle Kandidaten wurden geprüft und verworfen:
- `allowed-tools` **sperrt nichts**. Laut Doku „does not restrict which tools are available: every tool remains callable" — Vorab-Genehmigung gegen Permission-Prompts, keine Whitelist. (Gilt auch für `plan-review`.)
- `disallowed-tools` ist dokumentiert, taugt aber für einen **mehrschrittigen** Skill prinzipiell nicht: die Einschränkung „clears when you send your next message" — im Interview fiele sie schon nach deiner ersten Antwort weg. Unabhängig davon blieb der Key im headless-Test (`-p`) wirkungslos (`Write`/`Edit` im Pool). Beides zusammen: als Sperre unbrauchbar.
- Ein **PreToolUse-Hook** wäre der dokumentierte Weg, einen Tool-Call hart zu blocken — aber es gibt **keinen dokumentierten Weg, ihn skill-genau zu bedingen**: der Hook-Input kennt `tool_name`/`tool_input`, nicht den aktiven Skill (`context.currentSkill` ist nicht real). Ein Plugin-Hook auf `Write|Edit` feuerte damit über **alle** Skills und bräche `plan-review`/`plan-execute`, die schreiben müssen. Ein Hook im Skill-Frontmatter verfällt wiederum wie `disallowed-tools` nach der nächsten Nachricht — dieselbe Mehrschritt-Lücke.
- **Fazit:** Runtime-Enforcement ist mit dokumentierten, robusten Mitteln nicht erreichbar. Die Schreibsperre trägt allein die Body-Prosa (erster Absatz: „du interviewst mich, du setzt nichts um … kein Write, kein Edit … auch dann nicht, wenn ich dich darum bitte").

## plan-review — Tuning

Der Review läuft rundenweise mit rotierenden Blickwinkeln, bis die Blickwinkel erschöpft sind (kein vorzeitiger Ruhe-Abbruch). Anpassbar:
- **Blickwinkel-Untergrenze:** in der Regel mindestens 3, bevor „erschöpft" erklärt wird (im Body im Abschnitt „Abarbeitung und Erschöpfungs-Abbruch" verstellbar).

Frontmatter: `model: opus`, `effort: xhigh`. **Kein `allowed-tools`** — bis 0.2.0 stand hier eine Liste lesender Tools mit der Begründung „kein Schreibzugriff"; die war falsch: `allowed-tools` sperrt nichts, es genehmigt nur vorab und unterdrückt damit Permission-Prompts („does not restrict which tools are available: every tool remains callable"). Die Liste hat den Skill also nie am Schreiben gehindert. Ersatzlos gestrichen, statt einen Schutz vorzutäuschen; dass `plan-review` nichts umsetzt, trägt allein der erste Satz des Bodys. Spürbare Folge: bei `Read`/`Grep`/`git log` kann jetzt wieder ein Permission-Prompt kommen — willst du die weg, ist `allowed-tools` das richtige Mittel, aber als Bequemlichkeit deklariert, nicht als Schranke.

## Konventionen

Die plan-Skills teilen Vokabular. Diese Begriffe wortgleich halten, damit die Suite nicht auseinanderläuft:

- **Steelman** — den Gegenstand in einem Satz *wohlwollend* wiedergeben, bevor man ihn belastet (grill, review).
- **Erschöpfungs-Abbruch** — die Schleife endet erst, wenn nichts Neues mehr trägt (Entscheidungen bei grill, Blickwinkel bei review), nie auf Zustimmung oder Ungeduld hin.
- **beobachtbares Kriterium** — ein prüfbarer Beleg (Testlauf, Exit-Code, Datei-/Lesezustand), kein „fehlerfrei"-Versprechen (execute; verwandt reviews „Befund am konkreten Schritt belegen").
- **stabile Kennung / revidierbar** — jedem eingearbeiteten Punkt eine über den Lauf stabile Kennung geben, damit gezielt zurückgenommen werden kann.

Drei Divergenzen sind **absichtlich** — nicht angleichen:

- **„als Chat-Notiz ausgeben, nicht …"** — grill: *nicht in eine Datei* (grill schreibt nichts); review: *nicht in den Plan* (review schreibt in den Plan, nur die Schlussnotiz nicht); execute schreibt Projektdateien, nur der Abschlussbericht bleibt im Chat. Der Zusatz kodiert, was der Skill *sonst* darf.
- **Ledger vs. Protokoll** — grill/review führen ein **Ledger** (Register mit Rücknahme-Kennung); execute führt ein **laufendes Protokoll** (Abweichungen/Ursachen/Korrekturen, ohne Kennung). Verschiedene Dinge, verschiedene Wörter — nicht gleichsetzen.
- **Kennungs-Schema** — grill flach („Entscheidung 3", rundenlos), review rundenbasiert („2.3"). Folgt der Struktur des jeweiligen Laufs.
