#!/bin/bash
# Chatty Desktop Integration Validator

echo "🔍 Chatty Desktop Integration Diagnostics"
echo "========================================"

# Check if icons directory exists
if [ ! -d ~/.local/share/icons ]; then
    echo "❌ Icons directory does not exist: ~/.local/share/icons"
    echo "   This suggests the installer didn't run or failed."
    echo "   Solution: Re-run ./install.sh and check for errors"
    echo ""
else
    echo "✓ Icons directory exists: ~/.local/share/icons"
fi

# Check desktop file
if [ -f ~/.local/share/applications/chatty.desktop ]; then
    echo "✓ Desktop file exists: ~/.local/share/applications/chatty.desktop"
    
    # Check permissions
    perms=$(stat -c "%a" ~/.local/share/applications/chatty.desktop)
    if [ "$perms" = "644" ]; then
        echo "✓ Desktop file permissions correct (644)"
    else
        echo "⚠ Desktop file permissions: $perms (should be 644)"
        echo "  Fix with: chmod 644 ~/.local/share/applications/chatty.desktop"
    fi
else
    echo "❌ Desktop file not found"
    echo "  Run ./install.sh to create it"
    exit 1
fi

# Check icons
if [ -f ~/.local/share/icons/chatty.svg ]; then
    echo "✓ SVG icon exists: ~/.local/share/icons/chatty.svg"
else
    echo "❌ SVG icon missing"
fi

if [ -f ~/.local/share/icons/chatty.png ]; then
    echo "✓ PNG icon exists: ~/.local/share/icons/chatty.png"
else
    echo "❌ PNG icon missing (fallback)"
fi

# Check if start script exists and is executable
desktop_file_path=$(grep "^Exec=" ~/.local/share/applications/chatty.desktop | cut -d'=' -f2)
if [ -f "$desktop_file_path" ] && [ -x "$desktop_file_path" ]; then
    echo "✓ Start script exists and is executable: $desktop_file_path"
else
    echo "❌ Start script missing or not executable: $desktop_file_path"
fi

echo ""
echo "🛠️ Troubleshooting steps for Ubuntu:"
echo "1. If icons directory is missing, re-run: ./install.sh"
echo "2. Log out and log back in to refresh desktop environment"
echo "3. Try: update-desktop-database ~/.local/share/applications/"
echo "4. Try: xdg-desktop-menu forceupdate"
echo "5. Look for 'Chatty' in applications menu under 'AudioVideo' or 'Sound & Video' category"
echo "6. In Ubuntu, try searching for 'Chatty' in the Activities overview"

echo ""
echo "📋 Manual verification commands:"
echo "   ls -la ~/.local/share/icons/chatty.*"
echo "   ls -la ~/.local/share/applications/chatty.desktop"
echo "   cat ~/.local/share/applications/chatty.desktop"

echo ""
echo "🖥️ Desktop environment detection:"
if [ -n "$XDG_CURRENT_DESKTOP" ]; then
    echo "Desktop: $XDG_CURRENT_DESKTOP"
else
    echo "Desktop: Unknown"
fi

if [ -n "$XDG_SESSION_TYPE" ]; then
    echo "Session: $XDG_SESSION_TYPE"
fi

echo ""
echo "🔄 Quick reinstall command:"
echo "   ./install.sh && ./validate-desktop.sh"