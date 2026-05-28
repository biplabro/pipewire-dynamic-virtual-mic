#!/usr/bin/env bash

# setup once and forget

VIRTUAL_SINK="VirtualMicSink"
VIRTUAL_SOURCE="VirtualMic"

CURRENT_LOOPBACK=""
DEFAULT_SINK=""

echo "Creating virtual sink..."

SINK_ID=$(pactl load-module module-null-sink \
    sink_name=VirtualMicSink \
    sink_properties=device.description="Virtual-Mic-Backend")

echo "Sink module ID: $SINK_ID"

sleep 2

echo "Checking monitor availability..."

pactl list short sources

echo "Creating virtual microphone..."

VIRTUAL_SOURCE_ID=$(pactl load-module module-virtual-source \
    source_name=VirtualMic \
    master=VirtualMicSink.monitor \
    source_properties=device.description="Virtual-Microphone")

echo "Virtual source module ID: $VIRTUAL_SOURCE_ID"

sleep 2

echo "Current sources:"
pactl list short sources

create_loopback() {

    NEW_DEFAULT=$(pactl get-default-sink)

    if [ "$NEW_DEFAULT" = "$VIRTUAL_SINK" ]; then
        return
    fi

    if [ "$NEW_DEFAULT" = "$DEFAULT_SINK" ]; then
        return
    fi

    echo "Switching to: $NEW_DEFAULT"

    if [ -n "$CURRENT_LOOPBACK" ]; then
        pactl unload-module "$CURRENT_LOOPBACK" 2>/dev/null
    fi

    DEFAULT_SINK="$NEW_DEFAULT"

    CURRENT_LOOPBACK=$(pactl load-module module-loopback \
        source=${DEFAULT_SINK}.monitor \
        sink=VirtualMicSink \
        latency_msec=20)

    echo "Loopback ID: $CURRENT_LOOPBACK"
}

create_loopback

echo "Daemon active."

pactl subscribe | while read -r line; do

    if echo "$line" | grep -q "server"; then
        create_loopback
    fi
done
