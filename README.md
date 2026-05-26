# pipewire-dynamic-virtual-mic

Lightweight dynamically adaptive virtual microphone solution for Linux using PipeWire.

---

# The Real Problem

This project started from a very practical problem.

AI transcription and data annotation tasks workflow was extremely repetitive:

```
listen → pause → type → rewind → correct
```

This virual mic automates the `listen → pause → type` loop using the virtual mic and any online voice typing tool like google doc's native voice typing app. This code creates a working virtualmic input for the voice typing apps that work both natively and via browsers. 


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
