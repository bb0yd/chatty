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
chmod +x validate-desktop.sh

# Install desktop file for GUI launcher
echo "🖥️ Installing desktop launcher..."
INSTALL_DIR="$(pwd)"

# Create directories
echo "  Creating directories..."
mkdir -p ~/.local/share/applications || { echo "❌ Failed to create applications directory"; exit 1; }
mkdir -p ~/.local/share/icons || { echo "❌ Failed to create icons directory"; exit 1; }

# Copy icon to standard location
echo "  Installing icons..."
if [ -f "chatty.svg" ]; then
    cp chatty.svg ~/.local/share/icons/chatty.svg && echo "    ✓ SVG icon installed"
else
    echo "    ⚠ SVG icon not found"
fi

if [ -f "chatty.png" ]; then
    cp chatty.png ~/.local/share/icons/chatty.png && echo "    ✓ PNG icon installed" 
else
    echo "    ⚠ PNG icon not found"
fi

# Create desktop file with correct paths
echo "  Installing desktop file..."
if sed "s|INSTALL_PATH|$INSTALL_DIR|g" chatty.desktop > ~/.local/share/applications/chatty.desktop; then
    echo "    ✓ Desktop file created"
else
    echo "    ❌ Failed to create desktop file"
    exit 1
fi

# Desktop files should NOT be executable
chmod 644 ~/.local/share/applications/chatty.desktop

echo "✓ Desktop launcher installed to ~/.local/share/applications/chatty.desktop"
echo "✓ Icons installed to ~/.local/share/icons/"

# Verify installation
echo "  Verifying installation..."
if [ -f ~/.local/share/applications/chatty.desktop ]; then
    echo "    ✓ Desktop file exists"
else
    echo "    ❌ Desktop file missing"
fi

if [ -d ~/.local/share/icons ] && ls ~/.local/share/icons/chatty.* >/dev/null 2>&1; then
    echo "    ✓ Icons directory exists with Chatty icons"
    ls -la ~/.local/share/icons/chatty.*
else
    echo "    ❌ Icons missing or directory doesn't exist"
fi

# Update desktop database if available
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database ~/.local/share/applications/ 2>/dev/null || true
    echo "✓ Desktop database updated"
else
    echo "⚠ update-desktop-database not found, you may need to log out and back in"
fi

# Try to refresh the desktop environment
if command -v gtk-update-icon-cache &> /dev/null; then
    gtk-update-icon-cache ~/.local/share/icons/ 2>/dev/null || true
    echo "✓ Icon cache updated"
fi

echo ""
echo "🔍 Troubleshooting desktop launcher:"
echo "  1. Log out and log back in to refresh the desktop environment"
echo "  2. Look for 'Chatty' in your applications menu under 'AudioVideo' category"
echo "  3. Desktop file location: ~/.local/share/applications/chatty.desktop"
echo "  4. If icon doesn't appear, try: xdg-desktop-menu forceupdate"

echo ""
echo "✅ Installation complete!"
echo ""
echo "To run Chatty:"
echo "  ./start.sh"
echo "  or click the Chatty icon in your applications menu"
echo ""
echo "If the desktop icon doesn't appear:"
echo "  ./validate-desktop.sh    # Run diagnostics and troubleshooting"