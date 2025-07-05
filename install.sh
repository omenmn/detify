#!/bin/bash

set -e

# Paths
APP_NAME="detify"
APP_HOME="$HOME/.local/share/$APP_NAME"
VENV_DIR="$APP_HOME/venv"
BIN_PATH="/usr/local/bin/$APP_NAME"
MUSIC_DIR="$HOME/Music"
PY_DEPS=("spotdl" "dbus-python")  # Add any other required packages here

echo "📦 Installing $APP_NAME..."

# Step 1: Create application directory
mkdir -p "$APP_HOME"
mkdir -p "$MUSIC_DIR"

# Step 2: Copy init.py to app home
cp init.py "$APP_HOME/init.py"

# Step 3: Create virtual environment
if [[ ! -d "$VENV_DIR" ]]; then
  echo "🐍 Creating virtualenv..."
  python3 -m venv "$VENV_DIR"
fi

# Step 4: Install Python dependencies
echo "📥 Installing Python packages..."
"$VENV_DIR/bin/pip" install --upgrade pip > /dev/null
"$VENV_DIR/bin/pip" install "${PY_DEPS[@]}"

# Step 5: Copy CLI script and make it executable
cp detify "$APP_HOME/$APP_NAME"
chmod +x "$APP_HOME/$APP_NAME"
sudo ln -sf "$APP_HOME/$APP_NAME" "$BIN_PATH"

# Optional: Write config (e.g., music dir)
echo "$MUSIC_DIR" > "$APP_HOME/config"

echo "✅ Installed! Run: $APP_NAME [download|auto]"

