# Chatty

Voice-to-text application with real-time animated interface.

## Features

- **Compact Interface** - Small 220×140 window positioned in top-right corner
- **Visual Options** - Choose between animated dots or flowing waveform visualization
- **Audio-Reactive** - Visual elements respond dynamically to voice levels
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

1. **Press hotkey** (default: Ctrl) - Start recording (visual elements turn blue and react to voice)
2. **Press hotkey again** - Stop and auto-paste text
3. **Press Alt+V** - Cycle between visual modes (dots ↔ waveform)
4. **Press Escape** - Cancel/clear text

### Visual Modes

**Dots Mode** (default): Four animated dots that bounce and change size based on audio levels. Classic, compact visualization.

**Waveform Mode**: Flowing waveform with smooth curves and floating particles. Inspired by modern voice assistants, provides a dynamic audio visualization.

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

## Desktop Launcher Troubleshooting

If the Chatty icon doesn't appear in your applications menu after installation:

1. **Run the diagnostic tool:**
   ```bash
   ./validate-desktop.sh
   ```

2. **Common fixes:**
   - Log out and log back in to refresh your desktop environment
   - Run: `update-desktop-database ~/.local/share/applications/`
   - Run: `xdg-desktop-menu forceupdate`
   - Look for "Chatty" under the "AudioVideo" category in your applications menu

3. **Manual desktop file location:**
   - Desktop file: `~/.local/share/applications/chatty.desktop`
   - Icons: `~/.local/share/icons/chatty.svg` and `~/.local/share/icons/chatty.png`

4. **Alternative launch methods:**
   - Use `./start.sh` from the terminal
   - Double-click the desktop file directly

## Project Structure

```
chatty/
├── src/
│   └── chatty.py        # Main application
├── vosk_model/          # Speech recognition model (40MB)
├── chatty/              # Python virtual environment  
├── config.json          # Configuration file (hotkey settings)
├── chatty.desktop       # Desktop launcher template
├── chatty.svg           # Application icon (SVG)
├── chatty.png           # Application icon (PNG fallback)
├── install.sh           # Installation script
├── start.sh             # Launch script
├── validate-desktop.sh  # Desktop integration diagnostics
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