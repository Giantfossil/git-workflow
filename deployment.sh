#!/usr/bin/env bash
set -euo pipefail

# Deployment script for git spellcheck pre-commit hook

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_HOOK="${SCRIPT_DIR}/hooks/pre-commit"

TARGET_MODE="${1:-global}" # 'global' or 'local'

echo "=================================================="
echo " Git Spellcheck Hook Deployment (${TARGET_MODE})"
echo "=================================================="

# 1. Ensure source file exists and is executable
if [ ! -f "${SOURCE_HOOK}" ]; then
  echo "❌ Source file '${SOURCE_HOOK}' not found!"
  exit 1
fi
chmod +x "${SOURCE_HOOK}"

# 2. Prepare global Git configuration directories
GLOBAL_HOOKS_DIR="${HOME}/.config/git/hooks"
GLOBAL_CONFIG_DIR="${HOME}/.config/git"
mkdir -p "${GLOBAL_HOOKS_DIR}"

# 3. Create starter ignore file if not present
if [ ! -f "${GLOBAL_CONFIG_DIR}/codespell_ignore" ]; then
  echo "📝 Creating initial ignore list at ${GLOBAL_CONFIG_DIR}/codespell_ignore..."
  cat << 'EOF' > "${GLOBAL_CONFIG_DIR}/codespell_ignore"
# Global ignore list for codespell
API
ArchLinux
CSS
HTML
JSON
KDE
EOF
fi

if [ "${TARGET_MODE}" = "global" ]; then
  echo "📦 Installing hook globally to: ${GLOBAL_HOOKS_DIR}/pre-commit"
  ln -sf "${SOURCE_HOOK}" "${GLOBAL_HOOKS_DIR}/pre-commit"
  echo "✅ Global hook linked successfully."
  echo "💡 If not already active, enable global hooks with:"
  echo "   git config --global core.hooksPath ~/.config/git/hooks"

elif [ "${TARGET_MODE}" = "local" ]; then
  if [ ! -d ".git" ]; then
    echo "❌ No Git repository found in current directory (.git missing)!"
    exit 1
  fi
  LOCAL_TARGET=".git/hooks/pre-commit"
  mkdir -p ".git/hooks"
  ln -sf "${SOURCE_HOOK}" "${LOCAL_TARGET}"
  echo "✅ Local hook linked successfully to ${LOCAL_TARGET}."

else
  echo "❌ Unknown mode: '${TARGET_MODE}'"
  echo "Usage: $0 [global|local]"
  exit 1
fi

echo "✨ Done!"
