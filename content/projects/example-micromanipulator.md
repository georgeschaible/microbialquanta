---
title: "3D-printed micromanipulator"
date: 2026-05-15
draft: false
description: "A low-cost, fully printable micromanipulator for single-cell sampling under the microscope"
tags: ["3d-printing", "microscopy", "instrumentation"]
categories: ["instruments"]
showReadingTime: true
showTableOfContents: true
---

A fully 3D-printable micromanipulator for picking individual cells under an inverted microscope. Designed for use with pulled-glass capillaries; resolution ~5 μm on the fine axes.

> **Status:** working prototype, v0.3. Feedback welcome via GitHub issues.

## Build files

- [`micromanipulator-v0.3.stl`](/files/micromanipulator-v0.3.stl) — main body, single file
- [`micromanipulator.scad`](/files/micromanipulator.scad) — OpenSCAD source (parametric)
- [`firmware/`](https://github.com/georgeschaible/microbialquanta/tree/main/projects/micromanipulator/firmware) — Arduino sketch for joystick control

## Interactive 3D preview

Drop the STL into `static/files/` in the repo, then this shortcode renders an interactive viewer:

```markdown
{{</* stl-viewer src="/files/micromanipulator-v0.3.stl" */>}}
```

<!-- Uncomment once you have the file in static/files/
{{< stl-viewer src="/files/micromanipulator-v0.3.stl" >}}
-->

## Parts list

| Part | Source | Qty | Notes |
|---|---|---|---|
| NEMA 8 stepper | Pololu / OSH | 3 | One per axis |
| A4988 driver | Pololu | 3 | Or DRV8825 |
| Arduino Nano | many | 1 | Any AVR-based variant |
| Joystick module | Adafruit | 1 | 2-axis + button |
| M3 hardware kit | McMaster | — | Mostly 8 mm and 12 mm |
| Pulled glass capillary | World Precision | as needed | 1.0 mm OD borosilicate |

## Build notes

Print body parts in PETG for stiffness; ABS works but warps. Use 100% infill on the carriage parts — flex matters. The joystick mapping in the firmware uses an exponential curve so coarse moves feel responsive and fine moves stay precise.

```cpp
// excerpt from joystick.ino
int mapExp(int raw, int deadzone, int maxStep) {
  int centered = raw - 512;
  if (abs(centered) < deadzone) return 0;
  float n = (float)(abs(centered) - deadzone) / (512 - deadzone);
  int step = (int)(pow(n, 2.5) * maxStep);
  return centered < 0 ? -step : step;
}
```

## Lessons learned

1. The first version used cantilevered axes — flex was unusable above 200× magnification. Cross-bracing solved it.
2. PLA creeps under preload from the glass capillary holder. Switch materials.
3. Adding a 30 mm working-distance offset to the capillary mount means you can swap out the glass without re-zeroing.

## Future improvements

- Optical encoders for closed-loop control
- Manual fine-adjust knobs as backup when the microcontroller is being reflashed
- Compatibility plate for Nikon Ti and Olympus IX stages
