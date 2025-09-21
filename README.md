# Chatty

Voice-to-text application with real-time animated interface.

## Features

- **Compact Interface** - Small 220×140 window positioned in top-right corner
- **Visual Options** - Choose between animated dots or flowing waveform visualization
- **Audio-Reactive** - Visual elements respond dynamically to voice levels
- **Simple Controls** - Just use Ctrl key to toggle recording
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

## Usage

1. **Press Ctrl** - Start recording (visual elements turn blue and react to voice)
2. **Press Ctrl again** - Stop and auto-paste text
3. **Press Alt+V** - Cycle between visual modes (dots ↔ waveform)
4. **Press Escape** - Cancel/clear text

### Visual Modes

**Dots Mode** (default): Four animated dots that bounce and change size based on audio levels. Classic, compact visualization.

**Waveform Mode**: Flowing waveform with smooth curves and floating particles. Inspired by modern voice assistants, provides a dynamic audio visualization.

## Project Structure

```
chatty/
├── src/
│   └── chatty.py        # Main application
├── vosk_model/          # Speech recognition model (40MB)
├── whisper_env/         # Python virtual environment
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