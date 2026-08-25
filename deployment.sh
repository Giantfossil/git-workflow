#!/usr/bin/env bash
set -euo pipefail

# Deployment-Skript für den Rechtschreib-Pre-Commit-Hook

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_HOOK="${SCRIPT_DIR}/hooks/pre-commit"

TARGET_MODE="${1:-global}" # 'global' oder 'local'

echo "=================================================="
echo " Rechtschreib-Hook Deployment (${TARGET_MODE})"
echo "=================================================="

# 1. Sicherstellen, dass die Quelldatei existiert und ausführbar ist
if [ ! -f "${SOURCE_HOOK}" ]; then
  echo "❌ Quelldatei '${SOURCE_HOOK}' nicht gefunden!"
  exit 1
fi
chmod +x "${SOURCE_HOOK}"

# 2. Globale Git-Konfigurationsordner vorbereiten
GLOBAL_HOOKS_DIR="${HOME}/.config/git/hooks"
GLOBAL_CONFIG_DIR="${HOME}/.config/git"
mkdir -p "${GLOBAL_HOOKS_DIR}"

# 3. Basis-Ignore-Datei anlegen, falls noch nicht vorhanden
if [ ! -f "${GLOBAL_CONFIG_DIR}/codespell_ignore" ]; then
  echo "📝 Erstelle Basis-Ignoredatei unter ${GLOBAL_CONFIG_DIR}/codespell_ignore..."
  cat << 'EOF' > "${GLOBAL_CONFIG_DIR}/codespell_ignore"
# Globale Ignore-Liste für codespell
API
ArchLinux
CSS
HTML
JSON
KDE
EOF
fi

if [ "${TARGET_MODE}" = "global" ]; then
  echo "📦 Installiere Hook global nach: ${GLOBAL_HOOKS_DIR}/pre-commit"
  ln -sf "${SOURCE_HOOK}" "${GLOBAL_HOOKS_DIR}/pre-commit"
  echo "✅ Globaler Hook erfolgreich verlinkt."
  echo "💡 Falls noch nicht gesetzt, aktiviere globale Hooks mit:"
  echo "   git config --global core.hooksPath ~/.config/git/hooks"

elif [ "${TARGET_MODE}" = "local" ]; then
  if [ ! -d ".git" ]; then
    echo "❌ Kein Git-Repository im aktuellen Verzeichnis gefunden (.git fehlt)!"
    exit 1
  fi
  LOCAL_TARGET=".git/hooks/pre-commit"
  mkdir -p ".git/hooks"
  ln -sf "${SOURCE_HOOK}" "${LOCAL_TARGET}"
  echo "✅ Lokaler Hook erfolgreich nach ${LOCAL_TARGET} verlinkt."

else
  echo "❌ Unbekannter Modus: '${TARGET_MODE}'"
  echo "Verwendung: $0 [global|local]"
  exit 1
fi

echo "✨ Fertig!"
