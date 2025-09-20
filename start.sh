#!/bin/bash
# Launcher script for Chatty

echo "🎙️ Starting Chatty..."

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Activate virtual environment
source chatty/bin/activate

# Check if model exists
if [ ! -d "vosk_model/vosk-model-small-en-us-0.15" ]; then
    echo "❌ Vosk model not found!"
    echo "💡 Run ./install.sh first"
    exit 1
fi

# Disable system beep
xset -b 2>/dev/null || true

# Run Chatty with debug flag if provided
if [ "$1" = "--debug" ]; then
    echo "🔧 Running in debug mode..."
    python3 src/chatty.py --debug
else
    python3 src/chatty.py
fi