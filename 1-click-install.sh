#!/usr/bin/env bash

# Run this script with " bash 1-click-install.sh "

set -euo pipefail

echo "================================================="
echo " PipeWire Dynamic Virtual Microphone Installer"
echo "================================================="

echo ""
echo "[1/10] Verifying repository files..."

if [ ! -f "virtual-mic-daemon.sh" ]; then

    echo ""
    echo "ERROR:"
    echo "virtual-mic-daemon.sh not found."
    echo ""
    echo "Run this installer from inside the cloned repository:"
    echo ""
    echo "git clone https://github.com/biplabro/pipewire-dynamic-virtual-mic.git"
    echo "cd pipewire-dynamic-virtual-mic"
    echo "./install.sh"
    echo ""

    exit 1
fi

echo "Repository structure OK."

echo ""
echo "[2/10] Checking required commands..."

REQUIRED_CMDS=("pactl" "systemctl" "grep" "awk")

for cmd in "${REQUIRED_CMDS[@]}"; do

    if ! command -v "$cmd" &>/dev/null; then

        echo ""
        echo "ERROR: Missing dependency -> $cmd"
        echo ""
        echo "Please install PipeWire utilities first."
        echo ""

        exit 1
    fi
done

echo "Required commands detected."

echo ""
echo "[3/10] Verifying PipeWire backend..."

if ! pactl info 2>/dev/null | grep -qi "PipeWire"; then

    echo ""
    echo "ERROR:"
    echo "PipeWire audio server not detected."
    echo ""
    echo "This project requires PipeWire."
    echo ""

    exit 1
fi

echo "PipeWire detected."

echo ""
echo "[4/10] Creating required directories..."

mkdir -p ~/.local/bin
mkdir -p ~/.config/systemd/user

echo "Directories ready."

echo ""
echo "[5/10] Installing daemon script..."

cp virtual-mic-daemon.sh ~/.local/bin/

chmod +x ~/.local/bin/virtual-mic-daemon.sh

echo "Daemon installed:"
echo "~/.local/bin/virtual-mic-daemon.sh"

echo ""
echo "[6/10] Creating systemd user service..."

cat > ~/.config/systemd/user/virtual-mic.service <<EOF
[Unit]
Description=PipeWire Dynamic Virtual Microphone
After=pipewire.service wireplumber.service

[Service]
Type=simple
ExecStart=%h/.local/bin/virtual-mic-daemon.sh
Restart=always
RestartSec=2

[Install]
WantedBy=default.target
EOF

echo "Systemd service created."

echo ""
echo "[7/10] Reloading systemd user daemon..."

systemctl --user daemon-reload

echo "Systemd daemon reloaded."

echo ""
echo "[8/10] Enabling autostart service..."

systemctl --user enable virtual-mic.service

echo "Autostart enabled."

echo ""
echo "[9/10] Restarting PipeWire stack..."
echo ""
echo "Audio may briefly disconnect."
echo ""

systemctl --user restart pipewire pipewire-pulse wireplumber

sleep 3

echo "PipeWire restarted."

echo ""
echo "[10/10] Starting virtual microphone service..."

systemctl --user restart virtual-mic.service

sleep 3

echo ""
echo "Checking service status..."

if ! systemctl --user is-active --quiet virtual-mic.service; then

    echo ""
    echo "ERROR:"
    echo "virtual-mic.service failed to start."
    echo ""
    echo "Check logs using:"
    echo ""
    echo "journalctl --user -u virtual-mic.service -f"
    echo ""

    exit 1
fi

echo "Service running."

echo ""
echo "================================================="
echo " Installed Successfully"
echo "================================================="

echo ""
echo "Detected PipeWire sources:"
echo "-------------------------------------------------"

pactl list short sources

echo "-------------------------------------------------"

echo ""

if pactl list short sources | grep -q "VirtualMic"; then

    echo "SUCCESS:"
    echo "Virtual microphone detected."

else

    echo "WARNING:"
    echo "Virtual microphone source not detected."
    echo ""
    echo "Try manually restarting:"
    echo ""
    echo "systemctl --user restart virtual-mic.service"
fi

echo ""
echo "Browser-compatible microphone:"
echo ""
echo "    Virtual-Microphone"
echo ""

echo "IMPORTANT:"
echo "Completely restart:"
echo ""
echo "    Chrome"
echo "    Discord"
echo "    OBS"
echo ""
echo "before checking microphone devices."
echo ""

echo "Useful Commands"
echo "================================================="
echo ""
echo "Restart service:"
echo "systemctl --user restart virtual-mic.service"
echo ""
echo "Stop service:"
echo "systemctl --user stop virtual-mic.service"
echo ""
echo "Disable autostart:"
echo "systemctl --user disable virtual-mic.service"
echo ""
echo "Live service logs:"
echo "journalctl --user -u virtual-mic.service -f"
echo ""
echo "List PipeWire sources:"
echo "pactl list short sources"
echo ""
echo "List PipeWire sinks:"
echo "pactl list short sinks"
echo ""
echo "Current default sink:"
echo "pactl get-default-sink"
echo ""
