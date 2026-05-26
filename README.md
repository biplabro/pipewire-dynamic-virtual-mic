# PipeWire Dynamic Virtual Mic

A lightweight and dynamically adaptive virtual microphone solution for Linux using PipeWire.

This project creates a browser-compatible virtual microphone that automatically captures system audio from the currently active output device.

Unlike many static virtual audio setups, this solution dynamically tracks output-device changes in real time. Whether audio switches between:

- Bluetooth headphones
- HDMI audio
- onboard speakers
- USB audio devices

the virtual microphone automatically adapts without requiring manual rewiring or restarting applications.

Designed to be:
- lightweight
- minimal
- PipeWire-native
- browser-compatible
- persistent across reboots

Set it up once and forget about it, the routing automatically follows your active audio device in the background.

![Virtual-Mic-System-Entry](https://github.com/biplabro/pipewire-dynamic-virtual-mic/blob/main/images/virtual-microphone.png)
---

# The Real Problem

AI transcription and data annotation workflows are often repetitive:

```text
listen → pause → type → rewind → correct
```

This project aims to reduce that friction by automating the:

`listen → pause → type` portion of the workflow.

The virtual microphone routes internal system audio directly into browser-compatible voice typing tools like Google Docs Voice Typing, allowing real-time speech-to-text transcription while keeping the human in the verification loop for accuracy.

---

# Solution Architecture

![Virtual-Mic-Architecture](https://github.com/biplabro/pipewire-dynamic-virtual-mic/blob/main/images/dynamic-virtual-mic-architecture.jpg)

---

# Prerequisites

## Step 1 — Verify PipeWire Is Running

Open terminal:

```
pactl info | grep "Server Name"
```

Expected output:

```
Server Name: PulseAudio (on PipeWire x.x.x)
```

If you see PipeWire, continue.

---

## Step 2 — Install Required Tools

Install PipeWire utilities:

```
sudo apt update && sudo apt install -y pipewire-audio wireplumber git
```

---

# Dynamic Virtual Mic Installation

---

## Step 1 — Clone The Repository

```
git clone https://github.com/biplabro/pipewire-dynamic-virtual-mic.git
cd pipewire-dynamic-virtual-mic
```

Copy the necessary files in place

```
mkdir -p ~/.local/bin
cp virtual-mic-daemon.sh ~/.local/bin/
```

---

## Step 2 (Optional) — Edit The Script

copy the cloned [virtual-mic-daemon.sh](https://github.com/biplabro/pipewire-dynamic-virtual-mic/blob/main/virtual-mic-daemon.sh) script to the `~/.local/bin` folder as mentioned in the previous step and edit the file as per requirements, like changing the device names and descriptions, if necessary.

```
nano ~/.local/bin/virtual-mic-daemon.sh
```

---

## Step 3 — Make Executable

```
chmod +x ~/.local/bin/virtual-mic-daemon.sh
```

---

## Step 4 — Run

```
~/.local/bin/virtual-mic-daemon.sh
```

If you want to make the script run after booting your machine, set it to autostart, mentioned at the bottom of this page.

---

![virtual-mic-flowchart](https://github.com/biplabro/pipewire-dynamic-virtual-mic/blob/main/images/workflow-virtual-microphone.png)

---

# Verification

---

## List Sources

```
pactl list short sources
```

You should see:

```
VirtualMic
VirtualMicSink.monitor
```

---

## Browser Verification

Completely restart the browser.

Then open:

```
chrome://settings/content/microphone
```

You should see:

```
Virtual-Microphone
```

---

# KDE/Cinnamon/Gnome Autostart Entry

System Settings:

```
System Settings→ Autostart→ Add Script→ ~/.local/bin/virtual-mic-daemon.sh
```

Tested and working on ubuntu 24.04/ LinuxMint 22.3 and Tuxedo OS
