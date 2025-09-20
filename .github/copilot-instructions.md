# Chatty Voice-to-Text Application

Chatty is a Python desktop application that provides real-time voice-to-text transcription with an animated interface. The application uses Vosk for offline speech recognition and provides auto-paste functionality to any text field.

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

## Working Effectively

### Bootstrap and Install Dependencies
- Install system dependencies: `sudo apt update && sudo apt install -y python3 python3-pip python3-venv python3-tk xdotool xclip portaudio19-dev`
- Run the installation script: `./install.sh` -- takes 2-5 minutes depending on network speed. NEVER CANCEL. Set timeout to 10+ minutes.
- Installation creates Python virtual environment (`whisper_env/`) and downloads Vosk model (~40MB)
- Installation may fail due to network/firewall limitations with error messages about pip timeouts or wget failures

### Build and Run
- ALWAYS run installation first: `./install.sh`
- Start the application: `./start.sh` -- starts immediately, no build step required
- Application requires X11 environment (Linux desktop) to function properly
- No compilation or build process - it's a pure Python application

### Installation Troubleshooting
- `pip install` commands may fail due to network timeouts or firewall restrictions
- `wget` download of Vosk model may fail with exit code 4 (network error)
- If installation fails, document the specific error - common issues are "ReadTimeoutError" from pip and wget connection failures
- Virtual environment creation usually succeeds even if pip packages fail

## Validation Scenarios

### Manual Testing Requirements
After making changes, ALWAYS test the following scenarios:
1. **Application Startup**: Run `./start.sh` and verify the GUI opens with 4 animated dots
2. **Model Loading**: Check console output for "✓ Vosk model loaded successfully" 
3. **Interface Responsiveness**: Verify the animated dots are bouncing and interface is responsive
4. **Key Bindings**: Test Ctrl key for recording toggle and Escape key for clearing text
5. **Audio System**: If microphone is available, test voice recording (dots should turn green when recording)

### Known Limitations in Testing Environment
- **Cannot test actual voice transcription** - requires microphone and may have audio system limitations
- **Cannot test auto-paste functionality** - requires proper X11 desktop environment
- **Pip installations often fail** - network restrictions in CI/CD environments
- **Model download may fail** - external dependency on alphacephei.com

## Project Structure and Key Files

### Repository Layout
```
chatty/
├── src/
│   └── chatty.py        # Main application (442 lines)
├── vosk_model/          # Speech recognition model (created by install.sh)
├── whisper_env/         # Python virtual environment (created by install.sh)  
├── install.sh           # Installation script
├── start.sh             # Launch script
├── README.md           # Project documentation
└── .gitignore          # Git ignore rules
```

### Key Components
- **src/chatty.py**: Single-file Python application containing the entire GUI and voice processing logic
- **install.sh**: Handles system dependencies, Python virtual environment setup, and Vosk model download
- **start.sh**: Activates virtual environment and launches application with proper error checking

## Dependencies and Requirements

### System Requirements
- Python 3.7+ (tested with Python 3.12.3)
- Linux with X11 (for xdotool/xclip functionality)
- ~200MB disk space (including 40MB Vosk model)
- Microphone access for voice input
- Desktop environment for GUI display

### Python Dependencies
- **vosk**: Offline speech recognition (main dependency)
- **sounddevice**: Audio input/output
- **numpy**: Audio data processing  
- **pyperclip**: Clipboard operations
- **pynput**: Global keyboard hotkey handling
- **tkinter**: GUI framework (usually included with Python)

### External Dependencies
- **xdotool**: Text injection at cursor location
- **xclip**: Clipboard operations
- **portaudio19-dev**: Audio system development headers

## Common Tasks and Expected Timings

### Installation Process
- `sudo apt update`: 30-60 seconds
- `sudo apt install` of system packages: 1-2 minutes  
- Python virtual environment creation: 10-15 seconds
- `pip install` of Python packages: 1-3 minutes (if network allows)
- Vosk model download: 30-60 seconds for 40MB file (if network allows)
- **Total installation time**: 2-5 minutes under normal conditions
- **NEVER CANCEL** installation commands - set timeout to 10+ minutes minimum

### Runtime Performance
- Application startup: 1-2 seconds
- GUI initialization: Immediate
- Vosk model loading: 2-3 seconds
- Voice transcription: Real-time (dependent on speech length)

## Development Guidelines

### Code Organization
- All application logic is in single file `src/chatty.py`
- No separate test files or build configuration
- Uses standard Python imports and tkinter for GUI
- Follows object-oriented design with single `Chatty` class

### Making Changes
- Edit `src/chatty.py` for application logic changes
- Modify `install.sh` for dependency or installation changes
- Update `start.sh` for startup process changes
- Test changes by running `./start.sh` after installation

### Debugging Common Issues
- **"Model not found" error**: Run `./install.sh` to download Vosk model
- **GUI not appearing**: Check X11 environment and display settings
- **Audio errors**: Verify microphone permissions and PulseAudio/ALSA setup
- **xdotool failures**: Ensure X11 environment and proper window manager

## Testing and Validation

### What CAN be tested
- ✅ Installation script execution (with network limitations noted)
- ✅ Application startup and GUI initialization  
- ✅ Python syntax and import validation
- ✅ Virtual environment creation
- ✅ Basic tkinter GUI functionality

### What CANNOT be fully tested in CI
- ❌ Actual voice recording and transcription (requires microphone)
- ❌ Auto-paste functionality (requires proper desktop environment)
- ❌ Pip package installation (often blocked by network restrictions)
- ❌ Vosk model download (external dependency may be blocked)
- ❌ Real-time audio processing

### Always Document Network Failures
When pip or wget commands fail, include the specific error in any bug reports:
- "pip install fails due to ReadTimeoutError from pypi.org"
- "wget download fails with exit code 4 (network error)"
- "Vosk model download blocked by firewall restrictions"

## Troubleshooting Network Issues

### Common Installation Failures
- **Pip timeout errors**: Use `pip install --timeout 300 --no-cache-dir <package>`
- **Wget download failures**: Check network connectivity and firewall rules
- **Model not downloaded**: Manually verify https://alphacephei.com access
- **Virtual environment works but packages don't install**: Document as known limitation

### Alternative Installation Methods
If standard installation fails:
- Try system package manager: `sudo apt install python3-vosk` (if available)
- Manual package download and installation
- Use different model source or pre-downloaded model files

Remember: The goal is to document what works and what doesn't, not to make broken commands appear functional.