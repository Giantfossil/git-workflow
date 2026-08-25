# git public

Abhängigkeiten
----------------------------------
`sudo pacman -S github-cli git`

Lokale Repository
----------------------------------
```bash
cd /.../repo
git init
git add .
git commit -m "Initial commit: IHK-Abschlussarbeit"
```

Github Anmeldung
----------------------------------
`gh auth login`
    - GitHub.com
    - HTTPS
    - Login with a web browser
    - Code kopieren und ihn im Browser bestätigen
`gh auth status`

Remote Repository erstellen
----------------------------------
`gh repo create <NAME> --public --source=. --remote=origin --push`

Remote manuell setzen falls bereits im Browser erstellt wurde
----------------------------------
```bash
git remote add origin https://github.com/<USER>/<REPO>.git
git branch -M main
git push -u origin main
git remote -v
```
* [Richtig]: `origin` mit Fetch/Push-URLs sichtbar
* [Falsch]: `git remote remove origin`

Öffentlichkeit
----------------------------------
1. Urheberrecht & IHK-Regeln
* [Urheber]: Du bist der Urheber deiner Arbeit → du darfst sie veröffentlichen.
* [Schriftliche Freigabe]: Inhalte Ausbildungsbetrieb (z. B. interne Daten, Screenshots, Code, Prozesse)
* [Datenschutz/DSGVO]: Keine personenbezogenen Daten (Kunden, Mitarbeiter, Lieferanten)
* [Firmengeheimnisse]: Keine Betriebsgeheimnise (interne KPIs, Architekturdiagramm, Quellcode des Unternehmens)
* [Lizenzen]: Damit Andere meine Arbeit nutzen dürfen mÜssen die LICENSE-Datei hinzugefügt werden.
    - **Empfehlung**: MIT, CC-BY-4.0, CC-BY-NC-SA
* [PDF-Schwärzen]: Anhänge besonders prüfen, keine geheime Inhalte.

Grundstruktur
----------------------------------
```
ihk-abschlussarbeit/
│
├── docs/
│   ├── abschlussarbeit.pdf
│   ├── präsentation.pdf
│   └── anhänge/
│
├── src/                # Software-Anteil
│   └── ...
├── data/               # anonymisierte Daten oder eigene fikite aber funktionelle Daten
│   └── ...
│
├── README.md
├── LICENSE
└── .gitignore
```

README.md
------------------------------------
> *Recruiter* lesen immer zuerst das README.
* Inhalt
    - Titel der Arbeit
    - Kurzebeschreibung (5-7 Sätze)
    - Ziel des Projekts & Problemstellung des Projekts
    - gewählte Technik ^v Methode
    - Resultat
    - Resume
    - Link zur Dokumentation (`*.pdf` in Markdown)
    - Kontakt, Portfolio, Linkedin/xing-Adresse
* Stil: Wie ein Heldenbrief bei DSA
    - **Technik**
    - **gelöstest Problem**
    - **messbartes Ergebnis**
    - **anonymisierte Code-Beispiel**: dazu eine Erläuterung (Pipeline, Nginx.conf, git-init-workflow, dockerfile)

GitHub-Pages
----------------------------------------
Repository -> statische Website
- Projektübersicht
- Diagramme
- Screenshots

Misc
----------------------------------------
- große Dateien? -> Git LFS (Large File Storage)
- Badges (z. B. CC‑Lizenz, PDF‑Download)
- Tags / Releases (z. B. v1.0 der Abschlussarbeit)
- Issues nutzen, um Verbesserungen zu dokumentieren
- Project Board für deine Lernreise

[.gitignore](# ...)
```
# -----------------------------
# Allgemeine Systemdateien
# -----------------------------
.DS_Store
Thumbs.db

# -----------------------------
# Office / Dokumentbearbeitung
# -----------------------------
~$*.docx
~$*.xlsx
*.tmp
*.bak
*.swp
*.lock

# -----------------------------
# PDF- und Export-Artefakte
# (PDF selbst kannst du behalten, aber
# temporäre Dateien sollten raus)
# -----------------------------
*.aux
*.log
*.out
*.toc
*.lof
*.lot
*.fls
*.fdb_latexmk
*.synctex.gz

# -----------------------------
# LaTeX Build-Ordner
# -----------------------------
build/
latex-build/
out/

# -----------------------------
# Diagramm-Tools
# -----------------------------
*.drawio.bkp
*.drawio~*

# -----------------------------
# Code-Projekt (falls Softwareteil)
# -----------------------------
node_modules/
dist/
target/
venv/
.env
.env.*

# -----------------------------
# Daten (nur anonymisierte Daten committen!)
# -----------------------------
*.csv
*.xlsx
*.json
*.sqlite
*.db

# -----------------------------
# IDE / Editor
# -----------------------------
.vscode/
.idea/
*.iml

# -----------------------------
# Backup- und Versionsreste
# -----------------------------
*.old
*.orig
*.backup
```
