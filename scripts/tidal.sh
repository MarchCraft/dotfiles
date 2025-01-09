#!/usr/bin/env bash
nohup chromium --enable-features=UseOzonePlatform --ozone-platform=wayland --app=https://listen.tidal.com/ > /dev/null 2>&1 &
