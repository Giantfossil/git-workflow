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
| [`README.md`](file:///home/giant/.local/src/public/git-hook-rechtschreibung/README.md) | Statische Dokumentation der Hook-Infrastruktur |

---

## Voraussetzungen & Installation

### 1. Systempakete (Arch Linux)

```bash
# Basis-Paket codespell
sudo pacman -S codespell

# Deutsches Wörterbuch für codespell (AUR)
yay -S --needed codespell-dictionaries-git
```

### 2. Python (Alternative via pip)

```bash
pip install -r requirements.txt
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
