# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal mpv media player configuration, including a custom OSC (on-screen controller) written in Lua. It lives at `~/.config/mpv/` on the target machine.

## Linting and Formatting

- **Lint Lua:** `luacheck scripts/osc/` (configured via `.luacheckrc` — globals `jit` and `mp` are whitelisted)
- **Format Lua:** `stylua scripts/osc/` (configured via `.stylua.toml` — 2-space indent, 96 col width, single quotes, no call parentheses)

No build step or test suite exists; changes are tested by running mpv directly.

## Code Architecture

### Custom OSC (`scripts/osc/`)

A modular, from-scratch replacement for mpv's built-in OSC. The entry point is `scripts/osc/main.lua`, which disables the built-in OSC and calls `events.init()`.

**Module responsibilities:**

- `main.lua` — entry point; disables built-in OSC, bootstraps event system
- `events.lua` — top-level orchestrator; wires property observers (`osd-dimensions`, `chapter-list`, `track-list`, `pause`) and mouse-move to show/hide the UI
- `ui.lua` — manages the list of active UI elements (layers); calls `update()`/`osd()`/`handlers()` on each; controls show/hide via `osd.lua`
- `osd.lua` — thin wrapper around `mp.create_osd_overlay('ass-events')`; deduplicates updates
- `mouse.lua` — centralised mouse event dispatcher using mpv key-binding sections; elements subscribe via `mouse.subscribe(event, fn)`
- `timer.lua` — drives periodic re-render (e.g. for the seek bar position ticking)
- `delay.lua` — debounce helper used to hide the OSC after inactivity
- `window.lua` — caches OSD dimensions (`width()`, `height()`)
- `size.lua` — shared layout constants (margins, button size, label size); platform-aware via `env.lua`
- `env.lua` — exposes `win()` boolean (Windows vs Linux)
- `spec.lua` — default element spec (geometry, color, alpha, border, blur, font); `spec.hover()` applies hover styling
- `align.lua` — ASS alignment constants (1–9 grid)
- `tags.lua` — builds ASS tag strings from a spec table
- `draw.lua` — draws rounded rectangles via `mp.assdraw`
- `hitbox.lua` — point-in-rect hit testing for mouse events
- `font.lua` — font name constants
- `format.lua` — time formatting helpers
- `util.lua` — generic table helpers (`copy`, `merge`, `contains`)

**UI elements** (each exposes `reset?`, `update?`, `osd?`, `handlers?`):

- `background.lua` — translucent bottom bar
- `seek.lua` — seekbar (zoom/drag interaction)
- `play.lua` — play/pause button
- `time.lua` — playback time display
- `chapter.lua` — chapter skip buttons (registered only if chapters exist)
- `chapters.lua` — chapter marker dots on seekbar
- `audio.lua` — audio track cycle button (registered only if >1 audio track)
- `subtitles.lua` — subtitle track cycle button (registered only if subtitle tracks exist)
- `panscan.lua` — pan/scan reset button
- `fullscreen.lua` — fullscreen toggle button

### mpv Configuration

- `mpv.conf` — main config: `vo=gpu-next`, hardware decoding, subtitle styling, OSD, screenshot settings, scaling, and host-based profiles (`intel-linux`/`nvidia-linux`/`linux`/`windows`/`music`)
- `input.conf` — keybindings (`+`/`-` adjust subtitle scale)
- `script-opts/osc.conf` — options for the legacy OSC (present but the custom OSC is active instead)
- `script-opts/stats.conf` — stats display options
- `script-opts/console.conf` — console options

### Platform Profiles (`mpv.conf`)

| Profile | Condition | Effect |
|---|---|---|
| `intel-linux` | `HOST=drifter` | `hwdec=vaapi` |
| `nvidia-linux` | `HOST=player` or `HOST=worker` | `hwdec=nvdec`, `gpu-api=vulkan` |
| `linux` | `jit.os == 'Linux'` | `ao=pipewire` |
| `windows` | `jit.os == 'Windows'` | `ao=wasapi`, Segoe UI font, no title bar |
| `music` | `.flac` or `.m4a` filename | `hwdec=no`, `audio-exclusive=yes` |
