# Simba Watchdog Release Notes

## Current Watchdog

Launch from the D-drive live server folder:

- `START SIMBA WATCHDOG.bat`
- `START SIMBA WATCHDOG TERMINAL.bat`
- `START SIMBA SERVER.bat`

The primary watchdog is an XP-style control panel with a live server console, command input, quick commands, health checks, graceful stop/restart, backup command, and keepalive protection.

## Important Behavior

- Opening the watchdog does not auto-start the server.
- Pressing Start arms Keep Alive and starts the server under watchdog control.
- Closing the watchdog while the managed server is running asks whether to stop the server first.
- The terminal watchdog remains available as a fallback.
- If a server is started outside the watchdog, the UI reports it as an external Java process and does not pretend it can safely control it.

## Validation

Use this when you want to prove the server launch path:

- `server/watchdog/Test_Simba_Watchdog_Server.bat`

That check starts the server, waits for the ready message, sends `stop`, waits for shutdown, and confirms no Simba server Java process is left behind.
