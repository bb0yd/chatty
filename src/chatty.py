#!/usr/bin/env python3
"""
Chatty - Voice-to-Text with animated interface
Animated dots that bounce when speaking, with text display and smart controls
"""

import tkinter as tk
from tkinter import font as tkFont
import threading
import time
import math
import random
from datetime import datetime
from vosk import Model, KaldiRecognizer
import sounddevice as sd
import json
import numpy as np
import pyperclip
import subprocess
from pynput import keyboard

class Chatty:
    def __init__(self, root):
        self.root = root
        self.setup_window()
        self.setup_variables()
        self.setup_ui()
        self.setup_model()
        self.setup_audio()
        self.setup_hotkeys()
        self.start_animation()

    def setup_window(self):
        """Configure the main window"""
        self.root.title("🎙️ Chatty")
        self.root.geometry("220x140")
        self.root.configure(bg='#1a1a1a')
        self.root.resizable(False, False)

        # Make window stay on top
        self.root.attributes('-topmost', True)

        # Position in top-right corner with small margin
        screen_width = self.root.winfo_screenwidth()
        self.root.geometry("+{}+{}".format(
            screen_width - 240,  # 220 width + 20 margin from right edge
            20  # 20 pixels from top
        ))

    def setup_variables(self):
        """Initialize variables"""
        self.recording = False
        self.audio_buffer = []
        self.audio_stream = None
        self.hotkey_pressed = False
        self.cmd_pressed = False
        self.escape_pressed = False

        # Animation variables
        self.animation_running = True
        self.frame_count = 0
        self.current_text = ""
        self.text_visible = False

        # Audio level tracking
        self.audio_levels = [0, 0, 0, 0]  # 4 dots
        self.target_levels = [0, 0, 0, 0]

        # Key state tracking
        self.ctrl_pressed = False

    def setup_model(self):
        """Load the Vosk model"""
        model_path = "../vosk_model/vosk-model-small-en-us-0.15"
        try:
            self.model = Model(model_path)
            print("✓ Vosk model loaded successfully")
        except Exception as e:
            print(f"❌ Error loading model: {e}")
            return

    def setup_ui(self):
        """Create the compact interface"""
        # Main container with minimal padding
        main_frame = tk.Frame(self.root, bg='#1a1a1a')
        main_frame.pack(fill='both', expand=True, padx=8, pady=8)

        # Compact title
        title_label = tk.Label(main_frame,
                              text="Chatty",
                              bg='#1a1a1a',
                              fg='#ffffff',
                              font=('Arial', 14, 'bold'))
        title_label.pack(pady=(0, 5))

        # Compact animated dots container
        dots_frame = tk.Frame(main_frame, bg='#1a1a1a')
        dots_frame.pack(pady=(0, 5))

        self.dots_canvas = tk.Canvas(dots_frame,
                                   width=120, height=40,
                                   bg='#1a1a1a', highlightthickness=0)
        self.dots_canvas.pack()

        # Compact status text
        self.status_label = tk.Label(main_frame,
                                   text="Ctrl: start",
                                   bg='#1a1a1a',
                                   fg='#888888',
                                   font=('Arial', 9))
        self.status_label.pack()

        # Transcription text area (compact, hidden initially)
        self.text_frame = tk.Frame(main_frame, bg='#2a2a2a', relief='solid', bd=1)

        # Compact font for text
        self.text_font = tkFont.Font(family='Arial', size=10)

        self.text_label = tk.Label(self.text_frame,
                                 text="",
                                 bg='#2a2a2a',
                                 fg='#ffffff',
                                 font=self.text_font,
                                 wraplength=200,
                                 justify='left',
                                 anchor='nw')
        self.text_label.pack(padx=8, pady=8)

    def audio_callback(self, indata, frames, time, status):
        """Audio stream callback with dot animation data"""
        if status:
            print(f"Audio stream error: {status}")

        # Calculate audio levels for each dot
        audio_data = np.frombuffer(indata, dtype=np.float32)
        overall_level = np.sqrt(np.mean(audio_data**2)) * 200

        if self.recording:
            self.audio_buffer.extend(audio_data)

            # Create different levels for each dot with some randomness
            base_level = min(overall_level, 40)
            for i in range(4):
                variation = random.uniform(0.7, 1.3)
                self.target_levels[i] = base_level * variation
        else:
            # Idle state - minimal movement
            for i in range(4):
                self.target_levels[i] = random.uniform(0, 2)

    def setup_audio(self):
        """Initialize audio stream"""
        try:
            self.audio_stream = sd.RawInputStream(
                samplerate=16000,
                blocksize=1000,
                dtype="float32",
                channels=1,
                callback=self.audio_callback
            )
            self.audio_stream.start()
            print("✓ Audio stream initialized")
        except Exception as e:
            print(f"❌ Audio stream error: {e}")

    def start_recording(self):
        """Start audio recording"""
        if not self.recording:
            self.recording = True
            self.audio_buffer = []
            self.update_status("Listening...", '#00ff88')
            print("🎤 Recording started")

    def stop_recording(self):
        """Stop recording and process audio"""
        if self.recording:
            self.recording = False
            self.update_status("Processing...", '#ffaa00')
            print("⏹️ Recording stopped")

            # Process in separate thread
            threading.Thread(target=self.process_audio, daemon=True).start()

    def toggle_recording(self):
        """Toggle recording state"""
        if self.recording:
            self.stop_recording()
        else:
            self.start_recording()

    def process_audio(self):
        """Process recorded audio and transcribe"""
        if not self.audio_buffer:
            self.update_status("Ctrl: start", '#888888')
            print("No audio recorded")
            return

        print("🔍 Transcribing...")

        # Convert to format expected by Vosk
        audio_array = np.array(self.audio_buffer, dtype=np.float32)
        audio_data = (audio_array * 32768).astype(np.int16).tobytes()

        # Create recognizer for this session
        recognizer = KaldiRecognizer(self.model, 16000)

        try:
            # Process audio
            if recognizer.AcceptWaveform(audio_data):
                result = recognizer.Result()
                text = json.loads(result).get("text", "")
            else:
                result = recognizer.FinalResult()
                text = json.loads(result).get("text", "")

            if text.strip():
                final_text = text.strip()
                print(f"📝 Transcribed: '{final_text}'")

                # Show the transcribed text and auto-copy
                self.show_text(final_text)
                self.update_status("Auto-copying...", '#ffaa00')
                # Auto-copy after a brief delay to show the text
                threading.Thread(target=self.auto_copy_after_delay, daemon=True).start()

            else:
                print("🔇 No speech detected")
                self.update_status("No speech. Try again.", '#ff6600')
                time.sleep(2)
                self.update_status("Ctrl: start", '#888888')

        except Exception as e:
            print(f"❌ Transcription error: {e}")
            self.update_status("Error. Try again.", '#ff0000')
            time.sleep(2)
            self.update_status("Ctrl: start", '#888888')

    def show_text(self, text):
        """Display transcribed text"""
        self.current_text = text
        self.text_visible = True
        self.text_label.configure(text=text)
        self.text_frame.pack(fill='x', pady=(0, 5))

    def clear_text(self):
        """Clear the displayed text"""
        self.text_visible = False
        self.current_text = ""
        self.text_frame.pack_forget()
        self.update_status("Ctrl: start", '#888888')
        print("🗑️ Text cleared")

    def auto_copy_after_delay(self):
        """Auto-copy text after showing it briefly"""
        time.sleep(1.5)  # Show text for 1.5 seconds
        if self.text_visible:  # Only if text is still visible (not cancelled)
            self.copy_to_cursor()

    def copy_to_cursor(self):
        """Copy text to cursor location"""
        if self.current_text:
            try:
                # Copy to clipboard first
                pyperclip.copy(self.current_text)
                print(f"📋 Copied to clipboard: '{self.current_text}'")

                # Simple approach: just type the text directly
                # Give a small delay to ensure our window isn't capturing the keystroke
                time.sleep(0.3)

                # Type the text character by character for better reliability
                subprocess.run(['xdotool', 'type', '--delay', '50', self.current_text], check=True)

                print("✓ Text pasted to cursor location")
                self.update_status("Text pasted!", '#00ff88')

                # Clear after successful copy
                time.sleep(1)
                self.clear_text()

            except subprocess.CalledProcessError as e:
                print(f"❌ xdotool failed: {e}")
                # Fallback: just keep in clipboard
                try:
                    pyperclip.copy(self.current_text)
                    self.update_status("Copied to clipboard - paste with Ctrl+V", '#ffaa00')
                    print("💡 Text is in clipboard, paste manually with Ctrl+V")
                except:
                    self.update_status("Copy failed", '#ff0000')
                    print("❌ Clipboard copy also failed")

            except Exception as e:
                print(f"❌ Unexpected error: {e}")
                self.update_status("Error - text copied to clipboard", '#ff6600')

    def update_status(self, text, color='#888888'):
        """Update status display"""
        self.status_label.configure(text=text, fg=color)

    def draw_animated_dots(self):
        """Draw compact animated dots"""
        self.dots_canvas.delete("all")

        canvas_width = 120
        canvas_height = 40
        center_y = canvas_height // 2

        # 4 dots with tighter spacing for compact design
        dot_spacing = 20
        start_x = (canvas_width - (3 * dot_spacing)) // 2

        for i in range(4):
            # Smooth animation towards target
            self.audio_levels[i] += (self.target_levels[i] - self.audio_levels[i]) * 0.15

            x = start_x + (i * dot_spacing)

            # Base position with animated offset
            offset = math.sin((self.frame_count + i * 20) * 0.2) * 1.5  # Smaller movement for compact design
            if self.recording:
                offset += self.audio_levels[i] * 0.2  # Reduced audio-reactive movement

            y = center_y + offset

            # Smaller dot size for compact design
            base_radius = 4
            if self.recording:
                radius = base_radius + (self.audio_levels[i] * 0.08)
            else:
                radius = base_radius + math.sin((self.frame_count + i * 30) * 0.1) * 0.3

            # Color based on state
            if self.recording:
                color = '#00ff88'  # Green when recording
            else:
                color = '#666666'  # Gray when idle

            # Draw dot with subtle glow effect
            self.dots_canvas.create_oval(
                x - radius - 1, y - radius - 1,
                x + radius + 1, y + radius + 1,
                fill='', outline=color, width=1
            )

            self.dots_canvas.create_oval(
                x - radius, y - radius,
                x + radius, y + radius,
                fill=color, outline=''
            )

    def animate(self):
        """Main animation loop"""
        if self.animation_running:
            self.frame_count += 1
            self.draw_animated_dots()
            self.root.after(50, self.animate)  # 20 FPS

    def start_animation(self):
        """Start the animation loop"""
        self.animate()

    def setup_hotkeys(self):
        """Setup global hotkey listener"""
        def on_key_press(key):
            try:
                # Ctrl key press
                if key == keyboard.Key.ctrl_l or key == keyboard.Key.ctrl_r:
                    if not self.ctrl_pressed:
                        self.ctrl_pressed = True
                        self.root.after(0, self.toggle_recording)

                # Escape key
                if key == keyboard.Key.esc and not self.escape_pressed:
                    self.escape_pressed = True
                    if self.text_visible:
                        self.root.after(0, self.clear_text)

            except AttributeError:
                pass

        def on_key_release(key):
            try:
                # Release Ctrl key
                if key == keyboard.Key.ctrl_l or key == keyboard.Key.ctrl_r:
                    self.ctrl_pressed = False

                # Release Escape
                if key == keyboard.Key.esc:
                    self.escape_pressed = False

            except AttributeError:
                pass

        self.keyboard_listener = keyboard.Listener(
            on_press=on_key_press,
            on_release=on_key_release
        )
        self.keyboard_listener.start()
        print("✓ Global hotkey listener started")

    def on_closing(self):
        """Handle window closing"""
        self.animation_running = False
        if self.audio_stream:
            self.audio_stream.stop()
            self.audio_stream.close()
        if hasattr(self, 'keyboard_listener'):
            self.keyboard_listener.stop()
        self.root.destroy()

def main():
    """Main function"""
    root = tk.Tk()
    app = Chatty(root)

    # Handle window closing
    root.protocol("WM_DELETE_WINDOW", app.on_closing)

    try:
        root.mainloop()
    except KeyboardInterrupt:
        app.on_closing()

if __name__ == "__main__":
    main()