---
name: project-rules-kompakt
runs: 3
max_turns: 80
timeout_seconds: 1200
allowed_tools: [Read, Glob, Grep]
---

Haerte die Regeldatei `proj/CLAUDE.md` dieses Projekts, damit sie einen Coding-Agenten verlaesslich steuert.

Gehe dabei so vor, wie du es fuer richtig haeltst. Ergaenze fehlende Regeln, schaerfe vage Formulierungen zu ueberpruefbaren Aussagen, schwaeche keine vorhandene starke Regel ab, verankere jede Regel in den konkreten Begriffen dieses Projekts und verdichte die Datei zum Schluss ohne Bedeutungsverlust. Gib am Ende ein knappes Protokoll aus, das ergaenzte, geschaerfte, unveraenderte und bewusst weggelassene Regeln unterscheidet.

Die Entscheidungen der menschlichen Aufsicht liegen vor: Zieldatei ist `proj/CLAUDE.md`, Projektprofil ist "Software/Coding mit Mensch im Loop", Konflikte loest du zugunsten der strengeren Fassung.
