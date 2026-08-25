# Git-Hook Rechtschreibprüfung

Automatisierter Git Pre-Commit-Hook zur Rechtschreibprüfung von Dokumentations- und Textdateien (`.md`, `.txt`, `.rst`, `.adoc`) mittels `codespell`. Unterstützt mehrsprachige Prüfungen (Deutsch & Englisch) sowie globale und projektlokale Ausnahmelisten.

---

## Inhaltsverzeichnis

- [Übersicht](#übersicht)
- [Funktionsweise & Architektur](#funktionsweise--architektur)
- [Verzeichnisstruktur](#verzeichnisstruktur)
- [Voraussetzungen & Installation](#voraussetzungen--installation)
- [Deployment](#deployment)
- [Konfiguration & Ausnahmelisten](#konfiguration--ausnahmelisten)
- [Workflow zur Fehlerbehebung](#workflow-zur-fehlerbehebung)
- [Git Repositories publizieren (Best Practices)](#git-repositories-publizieren-best-practices)

---

## Übersicht

Dieser Hook verhindert fehlerhafte Schreibweisen in Dokumentationen und Versionsbeschreibungen bereits vor dem Commit. Er scannt ausschließlich die aktuell gestageten Textdateien und prüft diese gegen die Standard-Wörterbücher sowie optionale deutsche Begriffssammlungen.

---

## Funktionsweise & Architektur

Der Ablauf beim Ausführen von `git commit` gestaltet sich wie folgt:

```text
┌────────────────────────┐
│      git commit        │
└───────────┬────────────┘
            │
            ▼
┌────────────────────────┐
│  Staged Files filtern  │ ──► Nur .md, .txt, .rst, .adoc
└───────────┬────────────┘
            │
            ▼
┌────────────────────────┐
│   codespell ausführen  │ ──► Wörterbücher & Ignore-Listen laden
└───────────┬────────────┘
            │
     ┌──────┴──────┐
     ▼             ▼
 [Fehlerfrei]  [Rechtschreibfehler]
     │             │
     ▼             ▼
 Commit OK     Commit abgelehnt (Code 1)
```

1. **Selektive Prüfung:** Es werden nur modifizierte und im Git-Index gestagete Textdateien geprüft.
2. **Pfade mit Leerzeichen:** Dateinamen werden mit Null-Byte-Terminierung (`-z`) sicher verarbeitet.
3. **Kaskadierende Ausnahmelisten:**
   - Globales deutsches Wörterbuch: `~/.config/git/codespell_de.txt`
   - Globale Ignore-Liste: `~/.config/git/codespell_ignore`
   - Lokale Projekt-Ignore-Liste: `.codespellignore` oder `.codespell_ignore`

---

## Verzeichnisstruktur

| Pfad | Beschreibung |
| :--- | :--- |
| [`hooks/pre-commit`](file:///home/giant/.local/src/public/git-hook-rechtschreibung/hooks/pre-commit) | Der ausführbare Bash Pre-Commit-Hook |
| [`deployment.sh`](file:///home/giant/.local/src/public/git-hook-rechtschreibung/deployment.sh) | Installationsskript für lokales oder globales Deployment |
| [`requirements.txt`](file:///home/giant/.local/src/public/git-hook-rechtschreibung/requirements.txt) | Python-Paketabhängigkeiten (`codespell`) |
| [`WORKFLOW.md`](file:///home/giant/.local/src/public/git-hook-rechtschreibung/WORKFLOW.md) | Terminal-Leitfaden zur schnellen Fehlerkorrektur |
| [`docs/git_publizieren.md`](file:///home/giant/.local/src/public/git-hook-rechtschreibung/docs/git_publizieren.md) | Leitfaden für die Veröffentlichung von Repositories (GitHub, Lizenzen, DSGVO, Gitignore) |
| [`README.md`](file:///home/giant/.local/src/public/git-hook-rechtschreibung/README.md) | Statische Dokumentation der Hook-Infrastruktur |

---

## Voraussetzungen & Installation

### 1. Systempakete

#### Debian / Ubuntu / Linux Mint
```bash
sudo apt update
sudo apt install codespell
```

#### Arch Linux
```bash
sudo pacman -S codespell

# Optional: Deutsches Wörterbuch (AUR)
yay -S --needed codespell-dictionaries-git
```

### 2. Python (Alternative via pip / pipx)

```bash
pip install -r requirements.txt
# oder isoliert via pipx:
# pipx install codespell
```

---

## Deployment

### Option A: Global für alle Git-Repositories (Empfohlen)

Richtet den Hook zentral in `~/.config/git/hooks/` ein:

```bash
bash deployment.sh global
git config --global core.hooksPath ~/.config/git/hooks
```

### Option B: Nur für das aktuelle Repository

Richtet den Hook lokal unter `.git/hooks/pre-commit` ein:

```bash
bash deployment.sh local
```

---

## Konfiguration & Ausnahmelisten

- **Globale Ausnahmen:** Wörter in `~/.config/git/codespell_ignore` eintragen (ein Wort pro Zeile).
- **Projektbezogene Ausnahmen:** Datei `.codespellignore` im Wurzelverzeichnis des jeweiligen Repositories erstellen.

---

## Workflow zur Fehlerbehebung

Eine detaillierte Anleitung zur schnellen Behebung von Rechtschreibfehlern via Terminal (interaktives `codespell -i 3 -w`, `sed`, Ignore-Listen und Bypass) ist in [`WORKFLOW.md`](file:///home/giant/.local/src/public/git-hook-rechtschreibung/WORKFLOW.md) zu finden.

---

## Git Repositories publizieren (Best Practices)

Vor der Veröffentlichung von Repositories auf Plattformen wie GitHub sollten wesentliche Sicherheits- und Qualitätsstandards beachtet werden:

1. **Datenschutz & Geheimnisse:**
   - Keine personenbezogenen Daten (DSGVO).
   - Keine Betriebsgeheimnisse, internen Tokens oder Passwörter im Repository.
2. **Saubere `.gitignore`:**
   - Ausschluss von temporären Office-, LaTeX-, Build- und Editor-Dateien (z. B. `.env`, `*.tmp`, `node_modules/`, `*.bak`).
3. **Lizenzierung:**
   - Bereitstellung einer passenden `LICENSE`-Datei (z. B. MIT, CC-BY-4.0).
4. **GitHub CLI Workflow:**
   - Schnelles Publizieren direkt über das Terminal mittels `gh repo create <NAME> --public --source=. --remote=origin --push`.

Die vollständige Anleitung mit Beispielen und einer umfassenden `.gitignore`-Vorlage befindet sich in [`docs/git_publizieren.md`](file:///home/giant/.local/src/public/git-hook-rechtschreibung/docs/git_publizieren.md).
