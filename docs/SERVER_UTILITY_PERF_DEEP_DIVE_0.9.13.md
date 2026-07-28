# Server Utility And Performance Deep Dive 0.9.13

## Result

The server profile is now `0.9.13-server`.

- Server pack source: `server/packwiz-server`
- Dedicated server folder: `server/dedicated`
- Server pack entries: 102
- Dedicated server jars: 102
- Missing server jars: 0
- Boot result: passed
- Latest ready line: `Done (15.021s)! For help, type "help"`

## Added

### Dynamic View and Simulation Distances

- File: `dynview-1.21-4.0.jar`
- Side: server
- Purpose: dynamically adjusts view and simulation distance around server load to protect TPS when players spread out.
- Config preserved in: `server/packwiz-server/config/dynamicview.json`
- Live config: `server/dedicated/config/dynamicview.json`
- Tuned settings:
  - min view distance: 6
  - max view distance: 10
  - min simulation distance: 4
  - max simulation distance: 8
  - target average tick time: 45 ms

### GriefLogger

- File: `grieflogger-1.2.9-1.21.1-neoforge.jar`
- Side: server
- Purpose: server-side action/block logging for moderation and investigation.
- Config: `server/dedicated/config/grieflogger/grieflogger.toml`
- Current mode:
  - server-side-only: true
  - database: SQLite
  - indexes: enabled

## Already Covered Before This Pass

- ModernFix: broad performance/memory fixes
- FerriteCore: memory reduction
- ServerCore: TPS and server-side optimization
- spark: profiling
- Chunky: pregeneration
- Smooth Chunk Save: chunk-save lag-spike reduction
- Alternate Current: redstone performance
- FastSuite, FastWorkbench, FastFurnace: recipe/crafting/furnace cache improvements
- AI Improvements: mob AI optimization
- NoisiumForked: worldgen performance
- Connectivity: login, timeout, packet-size, ghost-block, payload stability
- Clumps: XP orb reduction
- AllTheLeaks: memory leak fixes
- Let Me Despawn: mob despawn performance
- FTB Backups 3: backups
- FTB Chunks, Teams, Ranks, Essentials, XMod Compat: claims, teams, ranks, commands, integrations

## Reviewed And Not Added

### Packet Fixer

Not added because Connectivity already covers the same network/login/payload problem space. Add only if real player joins show packet/NBT/time-out problems.

### Limited Chunkloading

Not added because this pack intentionally uses FTB Chunks and Create Power Loader. A global cleanup mod for chunkloading could surprise players by unloading factories or rail infrastructure. Reconsider only after we define a strict chunkloading policy.

### LuckPerms

Not added because FTB Ranks is already installed and matches the FTB admin stack. LuckPerms is excellent, but adding it now would create overlapping permission systems.

### BlueMap

Not added because it is a server map/web-rendering system, not a performance hardening tool. It can be useful later, but it adds disk/CPU/config/port surface.

### Simple Voice Chat

Not added because it requires client participation and UDP/network setup. It is a social feature, not server performance hardening.

### Recipes Fixer

Not added because the current recipe/datapack warnings should be fixed at the source instead of masked by a broad recipe fixer.

### C2ME / Lithium-style Ports

Not added because this is a NeoForge Create-heavy pack with physics, worldgen, and many mixins. These should only be tested in a separate performance experiment profile.

## Current Known Server Risks

- Existing datapack/recipe errors remain from older content:
  - Petrochem `gearbox:*` test/recipe serializers
  - Create Deco placard recipe
  - Middgard malachite recipes
  - CreateQOL `superheated_lava` data map reference
- Repeated dedicated-server log noise about client classes appears during mixin scanning. It does not currently block boot, but should remain on the watch list.
- Shutdown still produces spark/AllTheLeaks warnings because the test harness stops the server immediately after boot. Confirm behavior during normal manual shutdown after a longer play session.

## Next Server Tests

- First real player join with Heavy client.
- First real player join with Lite client.
- Run `/spark profiler start`, play for 10-15 minutes, then stop and inspect.
- Pregenerate a test radius with Chunky before live use.
- Test FTB claims and chunk loading policy.
- Test Create Power Loader behavior with Dynamic View active.
- Test GriefLogger inspect/search after placing, breaking, opening containers, and restarting.
