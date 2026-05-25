# Troubleshooting

---

## Browser Cannot Detect Microphone

### Cause

Browsers reject monitor-class devices.

### Wrong

```
VirtualMicSink.monitor
```

### Correct

Use:

```
module-virtual-source
```

---

## Violent Feedback Loop

### Cause

The virtual sink became the default output device.

This creates:

```
speaker → monitor → virtual sink → speaker
```

recursive routing.

### Fix

Never route:

- VirtualMicSink  
  back into itself.

---

## Audio Stops After Switching Devices

### Cause

The monitor source changes dynamically:

```
Bluetooth → HDMI → speakers
```

### Fix

Track:

- default sink changes
- recreate loopbacks dynamically

---

## Virtual Source Missing

### Cause

Race condition.

PipeWire created:

```
VirtualMicSink.monitor
```

slightly later than expected.

### Fix

Add delays before creating:

- module-virtual-source

---

## PipeWire Becomes Unstable

Restart:

```
systemctl --user restart pipewire pipewire-pulse wireplumber
```
