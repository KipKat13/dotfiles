#!/bin/bash

# Check if Nicotine+ is running
if pgrep -x "nicotine" > /dev/null; then
    process_running=true
else
    process_running=false
fi

# Check if port 2234 is listening
if nc -z localhost 2234 2>/dev/null; then
    port_open=true
else
    port_open=false
fi

# Build output for Waybar
if [ "$process_running" = true ] && [ "$port_open" = true ]; then
    echo '{"text": "󰚀 Soulseek", "class": "sk-active", "tooltip": "Nicotine+ running | Port 2234 OPEN"}'
elif [ "$process_running" = true ]; then
    echo '{"text": "⚠ Soulseek", "class": "sk-warning", "tooltip": "Nicotine+ running | Port 2234 CLOSED"}'
else
    echo '{"text": " Soulseek", "class": "sk-inactive", "tooltip": "Nicotine+ not running"}'
fi
