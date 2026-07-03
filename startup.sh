#!/bin/bash

# 1. Start a Virtual Display (Xvfb) on display port :99
export DISPLAY=:99
Xvfb :99 -screen 0 1280x720x24 -ac +extension GLX +render -noreset &

# Wait briefly for Xvfb to fully initialize
sleep 2

# 2. Start Fluxbox (A lightweight window manager so Chromium has standard borders/controls)
fluxbox &

# 3. Start Chromium in the background
# Sandboxing must be disabled because Docker containers lack root execution privileges
chromium --no-sandbox \
         --disable-dev-shm-usage \
         --disable-gpu \
         --disable-software-rasterizer \
         --start-maximized \
         --window-size=1280,720 \
         --no-first-run \
         --homepage="https://duckduckgo.com" &

# 4. Start the VNC server, attaching it to our virtual display :99
x11vnc -display :99 -forever -nopw -bg -xkb -quiet

# 5. Start websockify with the noVNC client interface
# This translates VNC protocols to WebSockets and serves the UI on port 7860
websockify --web /usr/share/novnc/ 7860 localhost:5900
