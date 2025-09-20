#!/bin/bash
# Chatty Installation Script

echo "🎙️ Chatty Installation"
echo "======================"

# Install system dependencies
echo "📦 Installing system dependencies..."
sudo apt update
sudo apt install -y python3 python3-pip python3-venv python3-tk xdotool xclip portaudio19-dev

# Create virtual environment
echo "🐍 Creating Python virtual environment..."
python3 -m venv whisper_env
source whisper_env/bin/activate

# Install Python packages
echo "📦 Installing Python packages..."
pip install --upgrade pip
pip install vosk sounddevice numpy pyperclip pynput

# Download Vosk model
if [ ! -d "vosk_model/vosk-model-small-en-us-0.15" ]; then
    echo "📥 Downloading Vosk model (40MB)..."
    mkdir -p vosk_model
    cd vosk_model
    wget -q https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip
    unzip -q vosk-model-small-en-us-0.15.zip
    rm vosk-model-small-en-us-0.15.zip
    cd ..
    echo "✓ Model downloaded"
else
    echo "✓ Model already exists"
fi

# Make scripts executable
chmod +x start.sh

echo ""
echo "✅ Installation complete!"
echo ""
echo "To run Chatty:"
echo "  ./start.sh"