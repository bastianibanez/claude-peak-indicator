#!/bin/bash
# Installer for claude-peak-indicator SwiftBar plugin
set -euo pipefail

REPO_RAW="https://raw.githubusercontent.com/bastianibanez/claude-peak-indicator/main"
PLUGIN_NAME="claude-peak.1m.sh"

# ── macOS check ──────────────────────────────────────────────────────────────
if [[ "$(uname)" != "Darwin" ]]; then
  echo "❌ This plugin requires macOS. Exiting."
  exit 1
fi

# ── Homebrew check ───────────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  echo "❌ Homebrew is required but not installed."
  echo "   Install it from: https://brew.sh"
  exit 1
fi

# ── Install SwiftBar ─────────────────────────────────────────────────────────
SWIFTBAR_APP=$(mdfind "kMDItemCFBundleIdentifier == 'com.ameba.SwiftBar'" 2>/dev/null | head -1)

if [[ -z "$SWIFTBAR_APP" ]]; then
  echo "📦 Installing SwiftBar via Homebrew..."
  brew reinstall --cask swiftbar
else
  echo "✅ SwiftBar already installed at $SWIFTBAR_APP"
fi

# ── Detect plugin directory ──────────────────────────────────────────────────
PLUGIN_DIR=$(defaults read com.ameba.SwiftBar PluginDirectory 2>/dev/null || true)

if [[ -z "$PLUGIN_DIR" ]]; then
  PLUGIN_DIR="$HOME/Library/Application Support/SwiftBar/plugins"
  echo "📂 Setting plugin directory to: $PLUGIN_DIR"
  mkdir -p "$PLUGIN_DIR"
  defaults write com.ameba.SwiftBar PluginDirectory -string "$PLUGIN_DIR"
fi

# Expand ~ if present
PLUGIN_DIR="${PLUGIN_DIR/#\~/$HOME}"

if [[ ! -d "$PLUGIN_DIR" ]]; then
  mkdir -p "$PLUGIN_DIR"
fi

# ── Download plugin ──────────────────────────────────────────────────────────
DEST="$PLUGIN_DIR/$PLUGIN_NAME"

if [[ -f "$DEST" ]]; then
  echo "📋 Backing up existing plugin to ${PLUGIN_NAME}.bak"
  cp "$DEST" "${DEST}.bak"
fi

echo "⬇️  Downloading plugin..."
curl -fsSL "$REPO_RAW/plugins/$PLUGIN_NAME" -o "$DEST"
chmod +x "$DEST"

# ── Launch SwiftBar ──────────────────────────────────────────────────────────
if ! pgrep -q SwiftBar; then
  echo "🚀 Launching SwiftBar..."
  open -a SwiftBar
else
  echo "🔄 Refreshing SwiftBar..."
  open -g "swiftbar://refreshplugin?name=claude-peak"
fi

# ── Status ───────────────────────────────────────────────────────────────────
ET_HOUR=$(TZ="America/New_York" date +%-H)
ET_DOW=$(TZ="America/New_York" date +%u)

if [[ $ET_DOW -le 5 && $ET_HOUR -ge 8 && $ET_HOUR -lt 14 ]]; then
  echo "⏰ Current status: Peak Hours (Mon-Fri 8AM-2PM ET)"
else
  echo "🌙 Current status: Off-Peak (2x usage bonus)"
fi

echo ""
echo "✅ claude-peak-indicator installed successfully!"
echo "   Plugin location: $DEST"
