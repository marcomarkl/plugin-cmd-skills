# cmd — persönliches Planungs-Toolkit

Ein Plugin mit vier Skills rund um Klären, Planen, Reviewen und Umsetzen. Der Plugin-Name `cmd` (aus `.claude-plugin/plugin.json`) bildet den Namespace, deshalb lauten die Aufrufe:

- `/cmd:plan-grill` — dich gnadenlos zu einem Vorhaben interviewen, die Entscheidungen einzeln in Abhängigkeits- und Tragweitenreihenfolge auflösen und revidierbar protokollieren. Gedacht vor `/plan`.
- `/cmd:plan-review` — den zuletzt erstellten Plan in rotierenden Blickwinkeln reviewen und die belastbaren Befunde einarbeiten. Gedacht nach `/plan`.
- `/cmd:plan-execute` — den freigegebenen Plan vollständig umsetzen und jeden Schritt gegen ein beobachtbares Kriterium verifizieren; hält bei einem Fund ausserhalb des Plans oder einer Klassifikator-Blockade an und fragt nach. Gedacht nach dem Verlassen des Plan-Modus.
- `/cmd:project-rules` — eine bestehende `CLAUDE.md`/`AGENTS.md` mit fünf Disziplin-Katalogen härten und token-effizient verdichten. Eigenständig nutzbar.

Alle vier sind `disable-model-invocation: true` (nur manuell aufrufbar, kein Auto-Laden durch Claude) — timing-kontrollierte Workflows.

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

**Kein Frontmatter-Schutz gegen Schreibzugriffe — die Nicht-Änderungs-Regel steht im Body.** Beide Kandidaten wurden geprüft und verworfen:
- `allowed-tools` **sperrt nichts**. Laut Doku „does not restrict which tools are available: every tool remains callable" — es ist eine Vorab-Genehmigung gegen Permission-Prompts, keine Whitelist. (Das gilt auch für die Liste in `plan-review`.)
- `disallowed-tools` ist zwar dokumentiert („Tools removed from Claude's available pool while this skill is active"), zeigte im Test aber **keine Wirkung**: mit dem Key im Frontmatter — sowohl als Komma-Liste als auch als YAML-Liste — blieben `Write` und `Edit` im Tool-Pool (geprüft via `claude --plugin-dir ./cmd -p "/cmd:plan-grill …"`, Skill nachweislich geladen). Deshalb ersatzlos gestrichen, statt einen wirkungslosen Key stehen zu lassen, der Schutz vortäuscht. **Nur headless geprüft; ob der Key interaktiv greift, ist offen.**

## plan-review — Tuning

Der Review läuft rundenweise mit rotierenden Blickwinkeln, bis die Blickwinkel erschöpft sind (kein vorzeitiger Ruhe-Abbruch). Anpassbar:
- **Blickwinkel-Untergrenze:** in der Regel mindestens 3, bevor „erschöpft" erklärt wird (im Body im Abschnitt „Abarbeitung und Erschöpfungs-Abbruch" verstellbar).

Frontmatter: `model: opus`, `effort: xhigh`. **Kein `allowed-tools`** — bis 0.2.0 stand hier eine Liste lesender Tools mit der Begründung „kein Schreibzugriff"; die war falsch: `allowed-tools` sperrt nichts, es genehmigt nur vorab und unterdrückt damit Permission-Prompts („does not restrict which tools are available: every tool remains callable"). Die Liste hat den Skill also nie am Schreiben gehindert. Ersatzlos gestrichen, statt einen Schutz vorzutäuschen; dass `plan-review` nichts umsetzt, trägt allein der erste Satz des Bodys. Spürbare Folge: bei `Read`/`Grep`/`git log` kann jetzt wieder ein Permission-Prompt kommen — willst du die weg, ist `allowed-tools` das richtige Mittel, aber als Bequemlichkeit deklariert, nicht als Schranke.
