#!/bin/bash
# Launcher script for Chatty

echo "🎙️ Starting Chatty..."

# Activate virtual environment
source whisper_env/bin/activate

# Check if model exists
if [ ! -d "vosk_model/vosk-model-small-en-us-0.15" ]; then
    echo "❌ Vosk model not found!"
    echo "💡 Run ./install.sh first"
    exit 1
fi

# Disable system beep
xset -b 2>/dev/null || true

# Run Chatty
python3 src/chatty.py