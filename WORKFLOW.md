# Workflow: Schnellkorrektur bei Rechtschreibfehlern

Dieser Leitfaden beschreibt effiziente Terminal-Workflows, wenn der Pre-Commit-Hook (`codespell`) Rechtschreibfehler in gestageten Dokumenten meldet.

---

## 1. Interaktive Autokorrektur mit `codespell`

`codespell` bietet integrierte Optionen, um gefundene Fehler direkt im Quelltext zu beheben:

### Interaktiver Korrekturmodus (Empfohlen)
Fragt bei jedem Fund nach der passenden Korrektur:
```bash
codespell -i 3 -w <datei.md>
```
*Tastenbelegung im interaktiven Modus:*
- `0`, `1`, `2` ... : Vorschlag auswählen
- `i` : Wort ignorieren (für diesen Durchlauf)
- `c` : Eigenes Wort manuell eintippen

### Vollautomatische Korrektur
Korrigiert alle eindeutigen Standard-Tippfehler automatisch:
```bash
codespell -w <datei.md>
```

---

## 2. Direkte Terminal-Korrektur mit `sed`

Wenn das fehlerhafte Wort bekannt ist, kann es blitzschnell via `sed` im Terminal ersetzt werden:

### Einzelne Datei korrigieren
```bash
sed -i 's/falsches_wort/richtiges_wort/g' <datei.md>
```

### Repo-weit alle Vorkommnisse ersetzen (mit `ripgrep`)
```bash
rg -l 'falsches_wort' | xargs sed -i 's/falsches_wort/richtiges_wort/g'
```

---

## 3. Fachbegriffe zur Ignore-Liste hinzufügen (False Positives)

Wird ein korrekter deutscher Fachbegriff oder Eigenname als Fehler eingestuft, trage ihn in die Ignore-Liste ein.

### Zur globalen Ignore-Liste (systemweit)
```bash
echo "Fachbegriff" >> ~/.config/git/codespell_ignore
```

### Zur lokalen Ignore-Liste (nur für das aktuelle Repository)
```bash
echo "Fachbegriff" >> .codespellignore
git add .codespellignore
```

---

## 4. Re-Check & Commit abschließen

Nach der Korrektur oder dem Hinzufügen zur Ignore-Liste:

```bash
# 1. Geänderte Dateien erneut stagen
git add <datei.md>

# 2. Hook manuell vorab testen (optional)
.git/hooks/pre-commit

# 3. Commit regulär ausführen
git commit -m "docs: fix spelling and update docs"
```

---

## 5. Notfall-Bypass (Hook überspringen)

In dringenden Fällen oder bei absichtlichen Syntax-Ausnahmen kann der Hook übersprungen werden:

```bash
git commit --no-verify -m "commit message"
# oder kurz:
git commit -n -m "commit message"
```
