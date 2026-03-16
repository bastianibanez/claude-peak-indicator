#!/bin/bash
# Uninstaller for claude-peak-indicator SwiftBar plugin
set -euo pipefail

PLUGIN_NAME="claude-peak.1m.sh"

# ── Detect plugin directory ──────────────────────────────────────────────────
PLUGIN_DIR=$(defaults read com.ameba.SwiftBar PluginDirectory 2>/dev/null || true)

if [[ -z "$PLUGIN_DIR" ]]; then
  PLUGIN_DIR="$HOME/Library/Application Support/SwiftBar/plugins"
fi

PLUGIN_DIR="${PLUGIN_DIR/#\~/$HOME}"
DEST="$PLUGIN_DIR/$PLUGIN_NAME"

# ── Remove plugin ────────────────────────────────────────────────────────────
if [[ -f "$DEST" ]]; then
  rm "$DEST"
  echo "🗑  Removed $PLUGIN_NAME"
else
  echo "ℹ️  Plugin not found at: $DEST (already removed?)"
fi

# ── Remove backup ────────────────────────────────────────────────────────────
if [[ -f "${DEST}.bak" ]]; then
  rm "${DEST}.bak"
  echo "🗑  Removed ${PLUGIN_NAME}.bak"
fi

# ── Refresh SwiftBar ─────────────────────────────────────────────────────────
if pgrep -q SwiftBar; then
  open -g "swiftbar://refreshplugin?name=claude-peak"
  echo "🔄 SwiftBar refreshed"
fi

echo ""
echo "✅ claude-peak-indicator uninstalled."
echo "   SwiftBar was left installed (you may have other plugins)."
