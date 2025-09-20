# Chatty

Voice-to-text application with real-time animated interface.

## Features

- **Compact Interface** - Small 220×140 window positioned in top-right corner
- **Animated Interface** - 4 bouncing dots that react to voice levels
- **Configurable Hotkeys** - Customize the recording trigger key (Ctrl, Alt, Space, F1-F4)
- **Desktop Integration** - Install as desktop application with icon launcher
- **Auto-paste** - Transcribed text automatically types at cursor location
- **Offline** - Uses Vosk for local speech recognition
- **Always on Top** - Stays visible above other windows

## Quick Start

1. Install dependencies:
```bash
./install.sh
```

2. Run Chatty:
```bash
./start.sh
```

Or click the **Chatty** icon in your applications menu (after installation).

## Usage

1. **Press hotkey** (default: Ctrl) - Start recording (dots turn green)
2. **Press hotkey again** - Stop and auto-paste text
3. **Press Escape** - Cancel/clear text

## Configuration

Chatty supports configurable hotkeys through the `config.json` file. The default configuration uses the Ctrl key:

```json
{
  "hotkey": "ctrl",
  "display_name": "Ctrl"
}
```

### Supported Hotkeys

- **ctrl** - Left or Right Ctrl key (default)
- **alt** - Left or Right Alt key  
- **shift** - Left or Right Shift key
- **space** - Spacebar
- **f1** through **f4** - Function keys

### Changing the Hotkey

1. Edit `config.json` in the installation directory
2. Set `"hotkey"` to your preferred key
3. Set `"display_name"` to how you want it shown in the UI
4. Restart Chatty

Example for using Alt key:
```json
{
  "hotkey": "alt", 
  "display_name": "Alt"
}
```

## Project Structure

```
chatty/
├── src/
│   └── chatty.py        # Main application
├── vosk_model/          # Speech recognition model (40MB)
├── chatty/              # Python virtual environment  
├── config.json          # Configuration file (hotkey settings)
├── chatty.desktop       # Desktop launcher template
├── chatty.svg           # Application icon
├── install.sh           # Installation script
├── start.sh             # Launch script
└── README.md           # This file
```

## About Vosk Model

This project uses **Vosk** - an offline speech recognition toolkit. The `vosk_model` folder contains:
- **vosk-model-small-en-us-0.15** - A lightweight English model (~40MB)
- Processes speech locally without internet
- Provides real-time transcription with low latency

The model is downloaded during installation and enables completely offline speech recognition.

## Requirements

- Python 3.7+
- Linux with X11 (for xdotool)
- Microphone access
- ~200MB disk space (including model)