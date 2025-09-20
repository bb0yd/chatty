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
python3 -m venv chatty
source chatty/bin/activate

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

# Install desktop file for GUI launcher
echo "🖥️ Installing desktop launcher..."
INSTALL_DIR="$(pwd)"
mkdir -p ~/.local/share/applications

# Create desktop file with correct paths
sed "s|INSTALL_PATH|$INSTALL_DIR|g" chatty.desktop > ~/.local/share/applications/chatty.desktop
chmod +x ~/.local/share/applications/chatty.desktop

# Update desktop database if available
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database ~/.local/share/applications/ 2>/dev/null || true
fi

echo "✓ Desktop launcher installed"

echo ""
echo "✅ Installation complete!"
echo ""
echo "To run Chatty:"
echo "  ./start.sh"
echo "  or click the Chatty icon in your applications menu"