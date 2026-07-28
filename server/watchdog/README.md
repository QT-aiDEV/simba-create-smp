# Simba Server Watchdog

Launch `Start_Simba_Watchdog.bat` to open the XP-style watchdog control panel.

## What It Does

- Starts the NeoForge dedicated server from `server/dedicated`.
- Opens a real live server console window so the Minecraft terminal stays visible.
- Shows process, port, ready state, log freshness, uptime, memory, CPU, restart count, and Keep Alive status.
- Keeps the server alive when the Keep Alive checkbox is enabled.
- In console-window mode, stop the server by typing `stop` in the live server console.
- Restarts the server if it exits, stops responding on the port, or stops writing logs after startup.
- Shows watchdog events and health state in the control panel.
- Writes watchdog events to `server/watchdog/logs/watchdog-events.log`.

## Confidence Check

Run `Test_Simba_Watchdog_Server.bat` when you want to prove the configured launch path. It starts the server, waits for the ready message, sends `stop`, waits for shutdown, and confirms no Simba server Java process is left behind.

## UI Controls

- Start Server: starts the server under watchdog control.
- Stop: reminds you to type `stop` in the live console for a clean shutdown.
- Restart: use after the live console has stopped, or when the watchdog is in embedded mode.
- Run Backup: available in embedded mode; in console-window mode, type the backup command in the live console.
- Folder: opens the server folder.
- Logs: opens the server logs folder.
- Keep Alive: automatically restarts the server after a real managed failure.
- Quick Commands: command buttons are available in embedded mode; Track Map opens in both modes.

In the default console-window mode, type Minecraft commands directly into the separate server terminal. Example:

`say hello friends`

The command box is reserved for embedded mode.

## Notes

- Keep Alive is enabled by default in the config, but the server does not auto-start unless `autoStartOnOpen` is set to `true`.
- `launchMode` defaults to `consoleWindow` because it keeps the real terminal visible and avoids brittle hidden-console behavior.
- The classic terminal watchdog is still available through `Start_Simba_Watchdog_Terminal.bat`.
- Edit `watchdog-config.json` if the server folder, Java path, port, or timings change.
- If the server is started outside the watchdog, the UI will warn that it sees an external Java process. Start through the watchdog when you want the control panel to track it cleanly.
