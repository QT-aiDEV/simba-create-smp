# Simba Create SMP 0.9.24 Defaults And Diagnostics Pass

0.9.24 is a polish and support build. It does not add a new gameplay lane; it makes the client profiles easier to start correctly and adds crash-diagnosis helpers for later group testing.

## Client Defaults

Both Heavy-main and Lite now ship an `options.txt` override.

- VSync: off by default
- FPS cap: 120
- Fullscreen: off by default
- Auto-jump: off
- Dark Mojang loading background: on
- Heavy render distance: 12
- Heavy simulation distance: 8
- Lite render distance: 10
- Lite simulation distance: 6

Heavy-main also ships an Iris default config:

- Shaders enabled
- Default shader: Complementary Reimagined r5.8.1
- Shadow render distance: modest default

Lite ships an Iris default config with shaders disabled.

## Diagnostics

Added Crash Assistant to both client profiles. This gives players a better crash report workflow when something goes wrong instead of leaving them with only the raw loader screen.

Added Crash Utilities to the server profile. Spark was already present and remains the primary profiling tool for TPS, tick cost, and memory investigations.

Do not add another broad profiler before group testing unless Spark is not enough. The current diagnostic stack is intentionally simple:

- Spark for profiling
- Crash Utilities for server crash handling
- Crash Assistant for client-side crash readability
- FTB Backups 3 for recovery
- Watchdog app for keepalive and operator visibility

## Exports

- Heavy-main: `exports/Simba Create SMP-0.9.24-Heavy-CurseForge.zip`
- Lite: `exports/Simba Create SMP-0.9.24-Lite-CurseForge.zip`

Export verification passed:

- Both ZIPs contain `manifest.json`
- Both ZIPs contain `overrides/`
- Both ZIPs contain `overrides/options.txt`
- Both ZIPs contain `overrides/config/iris.properties`
- Heavy-main contains 4 shaderpacks
- Lite contains 0 shaderpacks

## Counts

- Heavy-main pack entries: 168
- Lite pack entries: 147
- Server pack entries: 127
- D: dedicated server jars: 127

## Test Result

D: dedicated server boot test passed after Crash Utilities was added. The server reached ready state and accepted stop through the watchdog test.

Known non-blocking noise remains:

- Create Easy Structures missing template pool warnings during generation
- Spark shutdown-only rejected-execution warning after stop
- Public CurseForge upload policy still needs a bundled external file review before publishing beyond private friend testing

