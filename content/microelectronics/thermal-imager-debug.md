---
title: "Thermal imager troubleshooting"
date: 2026-04-10
draft: false
description: "Notes from helping a colleague debug a DIY pocket thermal imager"
tags: ["thermal", "diy", "troubleshooting"]
categories: ["embedded"]
showReadingTime: true
---

Working notes from helping a colleague (Ruslan) get a DIY pocket thermal imager up and running. The original board kept producing a noisy frame with a fixed-pattern offset across rows.

**Repo:** [github.com/georgeschaible/thermal-imager](https://github.com/georgeschaible/thermal-imager)

## The symptom

Captured frames showed a clear horizontal banding pattern that didn't go away with calibration. Looked like a clocking issue.

## Diagnosis steps

1. Scoped the SPI clock — clean
2. Checked sensor power rail under load — sagging ~80 mV during readout
3. Added a 22 µF tantalum on the sensor side of the rail — banding gone

## Reproduction

This is a `cat`-able single file for now; the full schematic and build log will move to its own page once Ruslan finalizes v0.2.
