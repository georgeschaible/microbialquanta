---
title: "Pocket thermal imager"
date: 2026-07-13
draft: false
description: "A handheld thermal camera built around an MLX90640 sensor and a LilyGo TTGO T4 ESP32 board, in a printable case. Not my design, this is a build of Ruslan Nadyrshin's open source project, along with the fixes I needed to actually get it working."
weight: 30
images:
  - "/images/lab-tools/thermal-imager/Thermal_camera_1.jpeg"
  - "/images/lab-tools/thermal-imager/Thermal_camera_2.jpeg"
github_url: "https://github.com/georgeschaible/thermal-imager"
thingiverse_url: "https://www.thingiverse.com/thing:7382860"
hackaday_url: ""
tags: ["electronics", "3d printing"]
---

I took this on as an introduction to electronics, on the assumption it would be easy. Most of it was. The parts that were not turned out to be worth documenting, so the repository is less a build guide than a troubleshooting record for anyone attempting the same thing.

The LilyGo TTGO T4 v1.3 boards shipping in early 2025 would not initialize the screen with the original firmware, which took edits to `ili9341.c` to fix. The SD card would not mount, which took edits to `sd.c`. The device firmware is written in Russian, so there is also a Python script that translates the interface strings to English. I have included the soldering map I drew for version 1.1, and OpenSCAD source plus STLs for a case, sized for both the 2.2 and 2.4 inch displays. The 2.2 inch version is the better choice, since it can be mounted at all four corners.

The original design, firmware, and full build documentation are Ruslan Nadyrshin's, and live on [his Hackaday page](https://hackaday.io/project/189728-diy-pocket-thermal-imager).
