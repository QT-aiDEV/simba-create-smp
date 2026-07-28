# Simba Create SMP 0.14.0 — Community Computer release

## Added

- **Advanced Peripherals 0.7.62b** on Heavy, Lite, and Server. The full suite is available for friend-led ComputerCraft experimentation; Simba does not package a peripheral-disabling configuration.
- **CC:C Bridge 1.7.3** on Heavy, Lite, and Server for CC:Tweaked-to-Create displays, sources, targets, and civic/transit presentation work.
- The staged SustOS / Meep Community Hub now has a Meep Chat integration and an Advanced Peripherals discovery path. Its separate staging instructions remain the authority for CC-computer installation.

## Server configuration

- `server/packwiz-server/config/computercraft-server.toml` is now a tracked server-pack source file and is included in the Server export.
- The CC:Tweaked policy provides 1 MB computer storage, 512 KiB uploads, HTTP/WebSockets, and local/LAN HTTP for deliberately exposed local-first integrations (such as a future SustOS/MCP bridge). It leaves generic peripherals available, disables command computers, and retains conservative single-thread execution. Wireless modems use a forgiving 192-block low-altitude and 768-block tower-height range in clear weather, with a fair 25% storm reduction to 144 and 576 blocks.
- No live `D:` server directory, world, player data, or CC computer directory was modified for this release preparation.

## Release gates

- `Test-SimbaModpack.ps1` now requires the pinned Advanced Peripherals and CC:C Bridge metadata and validates the CC server-config policy.
- `Test-SimbaCurseForgePackage.ps1` now requires both integrations in every release manifest and can validate a candidate export directory with `-ExportsRoot`.
- Current 0.14 Heavy, Lite, and Server exports were rebuilt from the Packwiz sources and passed both release gates. The prior exports are preserved under `backups/release-artifacts/0.14.0-pre-cc-community-20260721/`.

## Before live promotion

1. Take and verify a production world backup.
2. Confirm the exact `D:` server target and its Packwiz/update procedure.
3. Boot the Server export in staging; verify the actual Chat Box and CC:C Bridge methods with `peripherals` and `peripheral.getMethods`.
4. Install Meep only into one explicitly selected staging CC computer, exercise reboot/maintenance/recovery, and record results.
5. Promote only after those checks pass. Do not bulk-copy CC computer data or restart the live server automatically.
