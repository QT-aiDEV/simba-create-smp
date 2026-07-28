# Simba Create SMP 0.14.1 — Community Computer and Typewriter release

## Added

- **Advanced Peripherals 0.7.62b** on Heavy, Lite, and Server.
- **CC:C Bridge 1.7.3** on Heavy, Lite, and Server.
- **Brewin' And Chewin' 4.5.0** on Heavy, Lite, and Server.
- **Drive-By-Wire: Typewriter 1.1.0-beta.2** on Heavy, Lite, and Server, pinned to CurseForge project `1558687`, file `8347375`. This is the maintained SparklezFishery project, not the discontinued fork.

## Server configuration

- Track `server/packwiz-server/config/computercraft-server.toml` in the Server pack.
- Provide 1 MB computer storage, 512 KiB uploads, HTTP/WebSockets, and deliberately configured local/LAN HTTP access.
- Keep generic peripherals available, command computers disabled, and conservative single-thread execution.
- Configure wireless modems for 192-block low-altitude and 768-block tower-height clear-weather range, with a 25% storm reduction.

## Production promotion

- Offline restore point: `D:\@MineCraft Server {Modded}\@Simba\server\dedicated\_archived_saves\0.14.1-predeploy-20260721-123909` (13.08 GiB, 3,803 files).
- Production Packwiz mirror and dedicated server were updated to 0.14.1.
- Production reached `Done (9.536s)`, listened on port 25565, loaded Typewriter 1.1.0-beta.2, and produced no new crash report or fatal startup event.
- CurseForge Heavy file: `8480969`.
- CurseForge Lite child file: `8480970`.
- CurseForge Server child file: `8480971`.
