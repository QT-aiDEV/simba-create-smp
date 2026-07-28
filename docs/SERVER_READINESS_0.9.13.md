# Server Readiness 0.9.13

## Current Layout

- Client pack source: `client/packwiz-client`
- Main CurseForge pack source: `packwiz-curseforge-pack`
- Server pack source: `server/packwiz-server`
- Dedicated server folder: `server/dedicated`
- Server start script: `server/dedicated/Start_Simba_Server.bat`

## Versions

- Minecraft: `1.21.1`
- Loader: `NeoForge 21.1.235`
- Pack version: `0.9.13-server`
- Java tested: Java 21

## Counts

- Client pack entries: 124
- CurseForge manifest entries: 123
- Bundled override jars in client ZIP: 1
- Server pack entries: 102
- Server jar count: 102

## Boot Result

The dedicated server in `server/dedicated` reached the ready state on July 8, 2026 and accepted a normal `stop` command after the 0.9.13 server utility/performance additions.

Fresh boot logs are in:

- `server/dedicated/logs/latest.log`
- `server/dedicated/logs/codex-server-boot-stdout.log`
- `server/dedicated/logs/codex-server-boot-stderr.log`

## Fixes Applied

- Removed ScalableLux because Sable declares it incompatible.
- Replaced CC: Tweaked CurseForge `1.113.1` with CC: Tweaked `1.120.0` from Modrinth metadata because Create New Age requires `1.116.2+`.
- Added Create: Power Grid, Building Gadgets, and Builders Crafts & Additions.
- Added Chipped and Macaw's Lights and Lamps.
- Added Dynamic View and Simulation Distances to the server profile.
- Added GriefLogger to the server profile.
- Tuned Dynamic View config and preserved it in `server/packwiz-server/config/dynamicview.json`.
- Skipped Powah by request.
- Re-exported the client CurseForge profile ZIP after the fix.
- Synced the dedicated server `mods` folder to remove ScalableLux and old CC:Tweaked, then added the compatible CC:Tweaked jar and the 0.9.11 server jars.

## Distribution Caveat

`exports/Simba Create SMP-0.9.12-CurseForge.zip` is a CurseForge custom profile ZIP with `manifest.json`, `overrides`, and one bundled jar:

- `overrides/mods/cc-tweaked-1.21.1-forge-1.120.0.jar`

This is needed because CurseForge only has CC:Tweaked `1.113.1` for Minecraft 1.21.1, while Create New Age requires `1.116.2+`. This should be okay for local friend import testing, but public CurseForge publication needs license and approved non-CurseForge-mod review.

## Watch Items

- Run a longer server soak test, not just boot-and-stop.
- Test first player join.
- Generate and explore new terrain around spawn.
- Confirm Create, TFMG, Petrochem, Oritech, Aeronautics/Sable, Deep Seas, and Steam 'n' Rails content in-game.
- Watch shutdown logs for the AllTheLeaks stuck-thread warning seen after the first stop.
- Decide whether CC:Tweaked bundling is acceptable for the final distribution route.
- Review existing datapack/recipe errors from Petrochem, Create Deco, and Middgard before live-world launch.
