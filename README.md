# Chatty

Voice-to-text application with real-time animated interface.

## Features

- **Animated Interface** - 4 bouncing dots that react to voice levels
- **Simple Controls** - Just use Ctrl key to toggle recording
- **Auto-paste** - Transcribed text automatically types at cursor location
- **Offline** - Uses Vosk for local speech recognition

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

1. **Press Ctrl** - Start recording (dots turn green)
2. **Press Ctrl again** - Stop and auto-paste text
3. **Press Escape** - Cancel/clear text

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