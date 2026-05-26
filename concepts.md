# Core PipeWire Concepts

![core-concepts-pipewire](https://github.com/biplabro/pipewire-dynamic-virtual-mic/blob/main/images/workflow-virtual-microphone.png)

## Sink

A sink receives audio.

Examples:

- speakers
- headphones
- HDMI audio

Think:

- output device

---

## Source

A source produces audio.

Examples:

- microphones
- webcams
- capture devices

Think:

- input device

---

## Monitor Source

PipeWire automatically creates a hidden monitor source for every sink.

Example:

```
bluez_output.xxx.monitor
```

This behaves like a hidden microphone attached to the output device.

It hears whatever is being played through that sink.

---

## Null Sink

A null sink is a fake virtual output device.

It does not physically play sound.

Its purpose here is to act as:

- a stable intermediate layer
- a persistent routing target

Without it, device names would constantly change whenever outputs switched.

---

## Virtual Source

Browsers often reject raw monitor devices.

So instead of exposing:

```
VirtualMicSink.monitor
```

directly, we create a proper microphone-class virtual source.

That makes:

- Chrome
- Discord
- OBS
- WebRTC apps

recognize the device correctly.
