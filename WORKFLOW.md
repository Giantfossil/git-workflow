# Workflow: Rapid Terminal Fixes for Spellcheck Errors

This guide outlines efficient command-line workflows when the pre-commit hook (`codespell`) detects spelling mistakes in staged files.

---

## 1. Interactive Auto-Correction with `codespell`

`codespell` provides built-in flags to fix detected typos directly in the source code:

### Interactive Correction Mode (Recommended)
Prompts for each finding so you can select the appropriate fix:
```bash
codespell -i 3 -w <file.md>
```
*Key controls in interactive mode:*
- `0`, `1`, `2` ... : Select suggested replacement
- `i` : Ignore word (for this run)
- `c` : Enter custom replacement manually

### Fully Automated Correction
Automatically fixes all unambiguous standard typos:
```bash
codespell -w <file.md>
```

---

## 2. Direct Terminal Correction with `sed`

When you already know the correct spelling, you can replace it quickly from the terminal:

### Fix a single file
```bash
sed -i 's/misspelled_word/correct_word/g' <file.md>
```

### Replace across the entire repository (using `ripgrep`)
```bash
rg -l 'misspelled_word' | xargs sed -i 's/misspelled_word/correct_word/g'
```

---

## 3. Adding Technical Terms to the Ignore List (False Positives)

If a valid technical term, library name, or proper noun is flagged as a typo, add it to your ignore list.

### Global Ignore List (System-wide)
```bash
echo "TechnicalTerm" >> ~/.config/git/codespell_ignore
```

### Local Ignore List (Current Repository Only)
```bash
echo "TechnicalTerm" >> .codespellignore
git add .codespellignore
```

---

## 4. Re-Checking & Completing the Commit

After fixing typos or updating the ignore lists:

```bash
# 1. Re-stage modified files
git add <file.md>

# 2. Test the hook manually (optional)
.git/hooks/pre-commit

# 3. Complete the commit
git commit -m "docs: fix spelling and update documentation"
```

---

## 5. Emergency Bypass (Skip Pre-Commit Hook)

In rare cases where an immediate commit is needed without running the verification:

```bash
git commit --no-verify -m "commit message"
# or shorthand:
git commit -n -m "commit message"
```
