# pipewire-dynamic-virtual-mic

Lightweight dynamically adaptive virtual microphone solution for Linux using PipeWire.

---

# Why This Project Exists

This project started from a very practical problem.

AI transcription and data annotation tasks. The workflow was extremely repetitive:

```
listen → pause → type → rewind → correct
```

# The Real Problem

Linux already has many [virtual audio solutions]([virtual-microphone · GitHub Topics · GitHub](https://github.com/topics/virtual-microphone)).

There are:

- JACK setups
- PulseAudio loopbacks
- OBS routing workflows
- qpwgraph patching
- PipeWire graph editors
- complex GUI tools
- static monitor-based scripts

However, while exploring existing solutions, I repeatedly encountered **several practical problems**:

## Most solutions were static

They worked only for one output device.

Example:

```
Bluetooth headphones → worksSwitch to HDMI → breaks
```

---

## Browser compatibility issues

Many approaches expose: `.monitor` devices directly. PipeWire recognizes them perfectly. Browsers often do not. **Chrome/Discord/WebRTC frequently reject monitor-class devices**.

---

## Manual rewiring

Many solutions required:

- reconnecting nodes manually
- patching graphs repeatedly
- restarting routing after device changes

---

## Feedback-loop problems

Recursive routing loops are surprisingly easy to create accidentally.

Example:

```
speaker → monitor → virtual sink → speaker
```

which can rapidly create violent audio feedback.

---

## Overly complex workflows

Many solutions depend on:

- JACK
- GUI patchers
- OBS-specific setups
- heavyweight routing environments

I wanted something:

- lightweight
- minimal
- dynamic
- browser-compatible
- persistent across reboots

---

# Project Goals

The final system needed to:

- capture any system audio
- dynamically follow output-device changes
- support Bluetooth / HDMI / speakers
- expose a valid microphone device
- work with browsers and WebRTC applications
- avoid recursive feedback loops
- persist across reboots
- remain lightweight and scriptable

---

# Final Architecture

```
Applications (YouTube/Spotify/Games) >>> Real Audio Output Device >>> monitor source (.monitor) >>> module-loopback >>> VirtualMicSink (null sink) >>> VirtualMicSink.monitor >>> module-virtual-source >>> Virtual-Microphone >>> Chrome / Discord / OBS / etc
```

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

Dynamic Virtual Mic Architecture

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

copy the cloned [virtual-mic-daemon.sh]([pipewire-dynamic-virtual-mic/virtual-mic-daemon.sh at main · biplabro/pipewire-dynamic-virtual-mic · GitHub](https://github.com/biplabro/pipewire-dynamic-virtual-mic/blob/main/virtual-mic-daemon.sh)) script to the `~/.local/bin` folder as mentioned in the previous step or edit the file as per requirements, like changing the device names and descriptions, if necessary.

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

# Verification

---

## List Sources

```
pactl list short sources
```

You should see:

```
VirtualMicVirtualMicSink.monitor
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
