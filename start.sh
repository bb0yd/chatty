#!/bin/bash
# Launcher script for Whisper

echo "🎙️ Starting Whisper..."

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

# Run Whisper
python3 src/whisper.py