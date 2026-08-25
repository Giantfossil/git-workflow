# Git Workflow & Pre-Commit Automation

Automated Git workflow toolkit featuring multi-language pre-commit spellchecking (`codespell` for German & English), rapid terminal fix routines, and comprehensive repository publishing guidelines.

---

## Table of Contents

- [Overview](#overview)
- [Architecture & How It Works](#architecture--how-it-works)
- [Directory Structure](#directory-structure)
- [Prerequisites & Installation](#prerequisites--installation)
- [Deployment](#deployment)
- [Configuration & Ignore Lists](#configuration--ignore-lists)
- [Terminal Fix Workflows](#terminal-fix-workflows)
- [Repository Publishing Guidelines](#repository-publishing-guidelines)

---

## Overview

Documentation and commit messages frequently suffer from typos and language-mixing errors. This repository provides an automated Git `pre-commit` hook that scans staged text files before they enter version control, combined with terminal workflows to resolve findings within seconds.

---

## Architecture & How It Works

When running `git commit`, the hook executes the following pipeline:

```text
┌────────────────────────┐
│      git commit        │
└───────────┬────────────┘
            │
            ▼
┌────────────────────────┐
│  Filter Staged Files   │ ──► Matches .md, .txt, .rst, .adoc
└───────────┬────────────┘
            │
            ▼
┌────────────────────────┐
│    Run codespell       │ ──► Loads dictionaries & ignore lists
└───────────┬────────────┘
            │
     ┌──────┴──────┐
     ▼             ▼
 [Clean / Valid] [Errors Found]
     │             │
     ▼             ▼
 Commit OK     Commit rejected (Exit 1)
```

1. **Selective Scanning:** Only staged modifications in text files are processed.
2. **Safe Path Handling:** File paths are parsed with null-byte termination (`-z`) to prevent whitespace issues.
3. **Layered Dictionaries & Exclusions:**
   - Global German dictionary (optional): `~/.config/git/codespell_de.txt`
   - Global ignore list: `~/.config/git/codespell_ignore`
   - Project-local ignore list: `.codespellignore` or `.codespell_ignore`

---

## Directory Structure

| Path | Description |
| :--- | :--- |
| [`hooks/pre-commit`](file:///home/giant/.local/src/public/git-workflow/hooks/pre-commit) | Executable Bash pre-commit hook script |
| [`deployment.sh`](file:///home/giant/.local/src/public/git-workflow/deployment.sh) | Installation script for local or global hook deployment |
| [`requirements.txt`](file:///home/giant/.local/src/public/git-workflow/requirements.txt) | Python dependencies (`codespell`) |
| [`WORKFLOW.md`](file:///home/giant/.local/src/public/git-workflow/WORKFLOW.md) | Terminal reference guide for rapid spellcheck fixes |
| [`docs/git-publishing.md`](file:///home/giant/.local/src/public/git-workflow/docs/git-publishing.md) | Comprehensive public publishing guide (English: GitHub CLI, licenses, GDPR, `.gitignore`) |
| [`docs/git-publizierung.md`](file:///home/giant/.local/src/public/git-workflow/docs/git-publizierung.md) | Leitfaden für die Veröffentlichung von Repositories (Deutsch) |
| [`README.md`](file:///home/giant/.local/src/public/git-workflow/README.md) | Main repository documentation |

---

## Prerequisites & Installation

### 1. System Packages

#### Debian / Ubuntu / Linux Mint
```bash
sudo apt update
sudo apt install codespell
```

#### Arch Linux
```bash
sudo pacman -S codespell

# Optional: German dictionary package from AUR
yay -S --needed codespell-dictionaries-git
```

### 2. Python (Alternative via pip / pipx)

```bash
pip install -r requirements.txt
# or isolated via pipx:
# pipx install codespell
```

---

## Deployment

### Option A: Global for All Git Repositories (Recommended)

Configures the hook globally in `~/.config/git/hooks/`:

```bash
bash deployment.sh global
git config --global core.hooksPath ~/.config/git/hooks
```

### Option B: Local to Current Repository Only

Installs the hook inside `.git/hooks/pre-commit`:

```bash
bash deployment.sh local
```

---

## Configuration & Ignore Lists

- **Global Ignore List:** Add terms to `~/.config/git/codespell_ignore` (one word per line).
- **Project-Specific Ignore List:** Create a `.codespellignore` file in the root of your target repository.

---

## Terminal Fix Workflows

Detailed instructions on rapid terminal fix strategies (interactive `codespell -i 3 -w`, `sed`, `ripgrep`, ignore management, and emergency bypass) can be found in [`WORKFLOW.md`](file:///home/giant/.local/src/public/git-workflow/WORKFLOW.md).

---

## Repository Publishing Guidelines

Before publishing code publicly to GitHub or other git hosts, review our best practices covering:
- **Security & Privacy:** Redacting PII (GDPR/DSGVO) and company secrets.
- **Clean `.gitignore`:** Excluding build artifacts, OS files, and environment files.
- **Licensing & Architecture:** Choosing appropriate open-source licenses.
- **GitHub CLI:** Direct terminal deployment via `gh repo create`.

For the complete guide, see:
- [English Publishing Guide](file:///home/giant/.local/src/public/git-workflow/docs/git-publishing.md)
- [Deutscher Leitfaden zur Veröffentlichung](file:///home/giant/.local/src/public/git-workflow/docs/git-publizierung.md)
