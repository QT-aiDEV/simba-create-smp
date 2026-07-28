# Simba Create SMP Test Log

## 0.1.0 Baseline

- Source folder: `packwiz-curseforge-pack`
- Distribution format: CurseForge manifest ZIP
- Export: `exports/Simba Create SMP-0.1.0-CurseForge.zip`
- Result: Export verified with `manifest.json`, `overrides/`, 39 CurseForge-managed file entries, and 0 bundled mod jars.
- Client launch: Not run in this environment.
- Test world: Not run in this environment.
- Server launch: Not run in this environment.

## 0.2.0 Admin/Server Foundation

- Added: FTB Library, FTB Teams, FTB Chunks, FTB Essentials, FTB Backups 3, FTB Ranks, FTB XMod Compat, Architectury API.
- Export: `exports/Simba Create SMP-0.2.0-CurseForge.zip`
- Manifest file entries: 47
- Bundled override mod jars: 0
- Client launch: Not run in this environment.
- Test world: Not run in this environment.
- Server launch: Not run in this environment.
- Notes: FTB XMod Compat included because FTB Chunks documents it as needed for integrations such as FTB Ranks.

## 0.3.0 Shader/World Scale

- Removed: Embeddium.
- Added: Sodium, Iris Shaders, Distant Horizons, Sound Physics Remastered.
- Export: `exports/Simba Create SMP-0.3.0-CurseForge.zip`
- Manifest file entries: 50
- Bundled override mod jars: 0
- Client launch: Not run in this environment.
- Test world: Not run in this environment.
- Shader load: Not run in this environment.
- Server launch: Not run in this environment.
- Notes: Sodium replaced Embeddium. Iris selected a NeoForge 1.21.1 beta build. Complementary Reimagined was not bundled; add as a manual shaderpack note unless confirmed safe through CurseForge shaderpack metadata.

## 0.4.0 Rail-Town Infrastructure

- Added: Create Railways Navigator, Create: Track Map (UNOFFICIAL FORK), Simply Light, Create: Dynamic Lights, DragonLib, Kotlin for Forge.
- Skipped: LambDynamicLights.
- Export: `exports/Simba Create SMP-0.4.0-CurseForge.zip`
- Manifest file entries: 56
- Bundled override mod jars: 0
- Client launch: Not run in this environment.
- Test world: Not run in this environment.
- Server launch: Not run in this environment.
- Notes: Track Map resolved to a 1.21.1 NeoForge unofficial fork, but packwiz printed dependency metadata warnings. Create: Dynamic Lights did not require LambDynamicLights; no extra dynamic-light companion was added.

## 0.5.0 Create Engineering And Power

- Added: Create: Diesel Generators, Create: Power Loader, Create Mechanical Extruder, Mechanicals Lib, Create: New Age.
- Export: `exports/Simba Create SMP-0.5.0-CurseForge.zip`
- Manifest file entries: 61
- Bundled override mod jars: 0
- Client launch: Not run in this environment.
- Test world: Not run in this environment.
- Server launch: Not run in this environment.
- Notes: Create: New Age failed automatic slug resolution but was added with exact CurseForge project/file IDs. Create Mechanical Extruder selected a Create 6.0.10-targeted file. Create: Power Loader overlaps with chunk-loading policy and needs server config review.

## 0.6.0 Lived-In World

- Added: Farmer's Delight, Handcrafted, Resourceful Lib.
- Export: `exports/Simba Create SMP-0.6.0-CurseForge.zip`
- Manifest file entries: 64
- Bundled override mod jars: 0
- Client launch: Not run in this environment.
- Test world: Not run in this environment.
- Server launch: Not run in this environment.
- Notes: Handcrafted is the only dedicated furniture mod in the main launch candidate.

## 0.7.0 Storage And QoL

- Added: Iron Chests, Tom's Simple Storage Mod, Mouse Tweaks, Inventory Essentials, Crafting Tweaks, TrashSlot, Durability Tooltip, Balm.
- Export: `exports/Simba Create SMP-0.7.0-CurseForge.zip`
- Manifest file entries: 72
- Bundled override mod jars: 0
- Client launch: Not run in this environment.
- Test world: Not run in this environment.
- Server launch: Not run in this environment.
- Notes: Crafting Tweaks failed automatic slug resolution and was added with exact CurseForge project/file IDs. Tom's Simple Storage was added as a group-preference storage interface; Storage Drawers remains the bulk storage/warehouse layer.

## 0.8.0 Immersion And Atmosphere

- Added: AmbientSounds 6, CreativeCore, Presence Footsteps (NeoForge), Particle Rain, Falling Leaves, Not Enough Animations, Visual Workbench, Puzzles Lib.
- Export: `exports/Simba Create SMP-0.8.0-CurseForge.zip`
- Manifest file entries: 80
- Bundled override mod jars: 0
- Client launch: Not run in this environment.
- Test world: Not run in this environment.
- Server launch: Not run in this environment.
- Notes: Presence Footsteps (NeoForge) and Particle Rain are beta/unofficial-style atmosphere picks and should be tested in-client. These additions are visual/audio ambience only and do not add survival punishment systems.

## 0.9.2 Performance And Stability

- Added: ImmediatelyFast, BadOptimizations, MoreCulling, Cloth Config API, Alternate Current, ServerCore, AllTheLeaks, Smooth Chunk Save, Cupboard, FastSuite, FastWorkbench, FastFurnace, Placebo, AI Improvements, NoisiumForked, Connectivity, ScalableLux, Let Me Despawn, Almanac Lib.
- Export: `exports/Simba Create SMP-0.9.2-CurseForge.zip`
- Manifest file entries: 99
- Bundled override mod jars: 0
- Client launch: Not run in this environment.
- Test world: Not run in this environment.
- Server launch: Not run in this environment.
- Notes: Let Me Despawn was re-added after discussion. Before live launch, specifically test pens, bred animals, named animals, tamed animals, villagers, and mobs holding items across chunk unload/reload and server restart.
- Skipped: C2ME and extra packet-fixer stacking. C2ME is powerful but should be tested in a separate profile first; Connectivity was chosen as the main network/timeout helper instead of stacking multiple packet mods.

## 0.9.3 George_VI Power Grid

- Added: Create: Electro Energetics.
- Already present: Create: Diesel Generators.
- Export: `exports/Simba Create SMP-0.9.3-CurseForge.zip`
- Manifest file entries: 100
- Bundled override mod jars: 0
- Client launch: Not run in this environment.
- Test world: Not run in this environment.
- Server launch: Not run in this environment.
- Notes: George_VI's owned Create projects are now represented by Diesel Generators and Electro Energetics. Electro Energetics is a 1.21.1 NeoForge electricity/grid addon with electric trains, transmission, distribution, FE conversion, and unloaded-chunk electrical simulation. It overlaps thematically with Create: New Age, so test both together before live launch.

## Candidate Review - Create Physics And Oritech

- Added to main profile: None.
- Reviewed: Loconautics, Ferronautics, Create: Automatics, Valkyrien Skies unofficial NeoForge port, Create Aeronautics, Oritech, Simple Conveyor Belts.
- Result: Keep these out of the main 0.9.x pack for now.
- Notes: Loconautics and Automatics appear not ready for a stable CurseForge main-profile add. VS unofficial NeoForge port conflicts with Iris/Oculus shader use. Create Aeronautics is available for 1.21.1 NeoForge but has Iris visual-risk notes and was already marked test-only. Oritech is compelling but is a second full tech identity. Simple Conveyor Belts is the safest Rearth candidate but still needs a test world before main inclusion.

## 0.9.4 Rearth Tech Support Lane

- Added: Oritech, Athena, GeckoLib, Simple Conveyor Belts.
- Export: `exports/Simba Create SMP-0.9.4-CurseForge.zip`
- Client launch: Not run in this environment.
- Test world: Not run in this environment.
- Server launch: Not run in this environment.
- Notes: Oritech was accepted as a lighter second tech identity than Mekanism and as a fallback path if pure Create hits a practical roadblock. This should be tested before final world start because Oritech adds worldgen/progression content. Simple Conveyor Belts was added as the Rearth belt/logistics companion; verify it does not make Create belts feel obsolete.

## 0.9.5 Create Vehicles And Rail Expansion

- Added: Create Aeronautics, Sable, Create Aeronautics: Compatibility, Steam 'n' Rails Neoforge, Colorwheel.
- Skipped: Valkyrien Skies, Ferronautics, Loconautics.
- Export: `exports/Simba Create SMP-0.9.5-CurseForge.zip`
- Client launch: Not run in this environment.
- Test world: Not run in this environment.
- Shader load: Not run in this environment.
- Server launch: Not run in this environment.
- Notes: VS remains out of the main profile. Aeronautics uses Sable rather than VS and keeps the pack in the Create lane, but it still needs client/server testing. Steam 'n' Rails Neoforge is an unofficial 1.21.1 port and should be backed up/tested before live world use. Colorwheel was added to improve Iris/Flywheel/Create shader behavior. Ferronautics was skipped because its page describes it as beta/crude and halted in favor of Loconautics. Loconautics appears not yet available as a stable CurseForge add.

## 0.9.6 Oil Refinery And Liquid Fuel

- Added: Create: The Factory Must Grow, Create: Liquid Fuel, TFMG Liquid Fuel Compat, Create Aeronautics: Portable Engine Liquid Fuel, Create: Petrochem, Create: Alloyed.
- Already present: Create: Diesel Generators.
- Export: `exports/Simba Create SMP-0.9.6-CurseForge.zip`
- Client launch: Not run in this environment.
- Test world: Not run in this environment.
- Shader load: Not run in this environment.
- Server launch: Not run in this environment.
- Notes: This wave intentionally loads the pack with Create oil/refinery content. TFMG was added using the release 1.21.1 file rather than the newer beta. Petrochem is newer and overlaps with Diesel Generators/TFMG refinery gameplay, so it needs real recipe/worldgen testing before final launch. Check oil worldgen, pumpjacks, refinery multiblocks, liquid fuels, blaze burner fuel behavior, Aeronautics portable engine fuel support, and JEI recipe clarity.

## 0.9.6 Static Risk Audit

- Audit doc: `docs/PACK_RISK_AUDIT_0.9.6.md`
- Export structure: valid CurseForge client manifest ZIP.
- Manifest file entries: 115
- Bundled override mod jars: 0
- Duplicate CurseForge project IDs: none found.
- Main finding: no packaging blocker, but not ready for live server until client launch, shader, worldgen, Aeronautics/Sable, refinery, animal persistence, and dedicated server tests pass.
- Server note: all packwiz mod metadata currently uses `side = "both"`, so do not use the client ZIP as a server mod folder without a server-side audit.

## 0.9.7 Conflict Handling And Deep Seas

- Added: Almost Unified, Create Deep Seas, Create: Deep Seas - Lava Fix.
- Already present: Polymorph.
- Export: `exports/Simba Create SMP-0.9.7-CurseForge.zip`
- Client launch: Not run in this environment.
- Test world: Not run in this environment.
- Shader load: Not run in this environment.
- Server launch: Not run in this environment.
- Notes: Polymorph handles direct crafting-output conflicts. Almost Unified was added because the pack now has several overlapping material ecosystems. Create Deep Seas was added because Aeronautics/Sable are now in the main profile, but its page marks it alpha/Early Access, so test submarines, boats, pressure/oxygen, lava fix behavior, shader visuals, and server restart persistence before live launch.

## 0.9.8 Terrain Identity Swap

- Kept: Tectonic, Lithostitched.
- Added: Middgard, Oh The Trees You'll Grow, Treeplacer.
- Removed: Terralith.
- Export: `exports/Simba Create SMP-0.9.8-CurseForge.zip`
- Client launch: Not run in this environment.
- Test world: Not run in this environment.
- Server launch: Not run in this environment.
- Notes: Tectonic is now the main terrain shape layer. Middgard replaces Terralith as the biome/forest realism layer. Terralith was removed to avoid stacking two biome overhaul systems. Generate a fresh test world and inspect biome transitions, tree density, ocean depth, Create Deep Seas usability, oil/worldgen resource placement, and chunkgen performance before launch.

## 0.9.9 Release Hardening

- Changed: marked 24 obvious client-only mods as `side = "client"` in packwiz metadata.
- Kept: 96 mods as `side = "both"`.
- Export: `exports/Simba Create SMP-0.9.9-CurseForge.zip`
- Manifest file entries: 120
- Bundled override mod jars: 0
- Client launch: Not run in this environment.
- Server launch: Not run in this environment.
- Notes: This addresses the dedicated-server weak spot from the risk audit. Do not use the CurseForge client ZIP as a raw server mod folder; build/install the server from packwiz metadata so client-only shader/render/UI/audio mods are excluded.

## 0.9.10 Server Split And Boot Hardening

- Changed: split working pack state into `client/packwiz-client` and `server/packwiz-server`.
- Changed: created NeoForge dedicated server folder at `server/dedicated`.
- Removed: ScalableLux. Sable declares it incompatible and the dedicated server refused to load while both were present.
- Replaced: CC: Tweaked CurseForge `1.113.1` with CC: Tweaked `1.120.0` from Modrinth metadata. Create New Age requires ComputerCraft/CC:Tweaked `1.116.2+`.
- Export: `exports/Simba Create SMP-0.9.10-CurseForge.zip`
- Manifest file entries: 118
- Bundled override mod jars: 1 (`cc-tweaked-1.21.1-forge-1.120.0.jar`)
- Client launch: Not run in this environment.
- Server launch: Passed first dedicated-server boot. Server reached ready state and accepted `stop`.
- Server mod count: 95 packwiz server entries, 95 jars in `server/dedicated/mods`.
- Notes: CurseForge has CC:Tweaked `1.113.1` for 1.21.1, but Create New Age requires a newer build. The local CurseForge ZIP can import with the bundled override jar, but public CurseForge publishing needs license/approved non-CurseForge-mod review or a different plan. Shutdown produced an AllTheLeaks stuck-thread warning after `stop`; keep it as a watch item during longer server tests.

## 0.9.11 Power And Builder Tools

- Added: Create: Power Grid, Building Gadgets, Builders Crafts & Additions.
- Explicitly skipped: Powah.
- Still skipped: Searchlight, because a clean NeoForge 1.21.1 target was not found.
- Export: `exports/Simba Create SMP-0.9.11-CurseForge.zip`
- Manifest file entries: 121
- Bundled override mod jars: 1 (`cc-tweaked-1.21.1-forge-1.120.0.jar`)
- Client launch: Not run in this environment.
- Server launch: Passed dedicated-server boot. Server reached ready state and accepted `stop`.
- Server mod count: 98 packwiz server entries, 98 jars in `server/dedicated/mods`.
- Notes: The new mods loaded on the dedicated server. Existing datapack/recipe noise remains visible from older content: Petrochem `gearbox:*` test/recipe errors, one Create Deco placard recipe error, and two Middgard malachite recipe errors. These did not block boot, but should be reviewed before live-world launch.

## 0.9.12 Block Palette And Lighting

- Added: Chipped, Macaw's Lights and Lamps.
- Already present: Rechiseled, Rechiseled: Create, Create Deco, Create: Design n' Decor, Create: Copycats+, FramedBlocks, Supplementaries, Simply Light, Create: Dynamic Lights, Builders Crafts & Additions.
- Still unavailable/skipped: Additional Blocks: Stone Edition; Searchlight.
- Export: `exports/Simba Create SMP-0.9.12-CurseForge.zip`
- Manifest file entries: 123
- Bundled override mod jars: 1 (`cc-tweaked-1.21.1-forge-1.120.0.jar`)
- Client launch: Not run in this environment.
- Server launch: Passed dedicated-server boot. Server reached ready state and accepted `stop`.
- Server mod count: 100 packwiz server entries, 100 jars in `server/dedicated/mods`.
- Notes: Chipped fills the missing Chisel-style block palette role. Macaw's Lights and Lamps fills the Searchlight gap with street lamps, ceiling lights, wall lanterns, light slabs, chandeliers, and other town lighting. Existing Petrochem/Create Deco/Middgard datapack noise remains a separate hardening item.

## 0.9.12 Client Profile Split

- Created Heavy client source: `client/packwiz-client`
- Created Lite client source: `client/packwiz-lite`
- Heavy export: `exports/Simba Create SMP-0.9.12-Heavy-CurseForge.zip`
- Lite export: `exports/Simba Create SMP-0.9.12-Lite-CurseForge.zip`
- Heavy client entries: 124
- Lite client entries: 112
- Server entries: 100
- Notes: Lite starts from the server pack and adds only practical client helpers. It excludes shaders, Distant Horizons, ambience, particles, extra animations, and other fancy vibe mods. No extra minimap was added because FTB Chunks already provides map/minimap functionality.

## 0.9.13 Server Utility And Performance Deep Dive

- Added server-side: Dynamic View and Simulation Distances, GriefLogger.
- Tuned Dynamic View config: view distance 6-10, simulation distance 4-8, target tick time 45 ms.
- Kept GriefLogger in server-side-only SQLite mode.
- Explicitly not added: Packet Fixer, Limited Chunkloading, LuckPerms, BlueMap, Simple Voice Chat, Recipes Fixer, C2ME/Lithium-style ports.
- Server launch: Passed dedicated-server boot. Server reached ready state and accepted `stop`.
- Server mod count: 102 packwiz server entries, 102 jars in `server/dedicated/mods`.
- Deep dive doc: `docs/SERVER_UTILITY_PERF_DEEP_DIVE_0.9.13.md`
- Notes: Packet Fixer overlaps Connectivity. Limited Chunkloading may interfere with FTB Chunks/Create Power Loader policy. LuckPerms overlaps FTB Ranks. BlueMap and Voice Chat are useful but not performance hardening. Recipe warnings should be fixed at source instead of masked.

## 0.9.14 Friendly Server Config Pass

- Changed config only: no mods added, removed, or upgraded.
- Disabled global PvP for a PvE co-op default.
- Tuned FTB Chunks defaults: claimed chunks block PvP, fake-player automation is enabled by default, and offline force-loaded chunks expire after 14 idle days.
- Protected Lootr chests from survival breaking and creeper/TNT explosions.
- Tightened Sophisticated Backpacks: disabled item-form fluid handling and disabled opening other players' worn backpacks.
- Kept `/home`, `/back`, `/warp`, `/spawn`, `/tpa`, and `/rtp` enabled by owner preference.
- Added server defaults to the server pack source: `server.properties`, `config/ftbchunks-world.snbt`, `config/lootr-common.toml`, and `config/sophisticatedbackpacks-server.toml`.
- Server launch: Passed dedicated-server boot. Server reached ready state: `Done (15.496s)! For help, type "help"`.
- Server mod count: 102 packwiz server entries, 102 jars in `server/dedicated/mods`.
- Config doc: `docs/SERVER_CONFIG_PASS_0.9.14.md`
- Notes: Existing datapack/recipe noise remains unchanged from previous tests. FTB Backups still logs that its empty/initial `backups.json` cannot be parsed; confirm during real play after the first successful backup.

## 0.9.13 Client Sodium Dynamic Lights Hotfix

- Fixed client load errors caused by missing Sodium helper dependencies.
- Added Reese's Sodium Options `2.2.2+mc1.21.1` to Heavy-main and Lite pack sources.
- Added Sodium Options API `1.0.10-1.21.1` to Heavy-main and Lite pack sources.
- Added Sodium Dynamic Lights `1.0.10-1.21.1` to Heavy-main and Lite pack sources.
- Sodium resolved to `0.8.12+mc1.21.1`, matching the required Sodium Options API range.
- Exports created: `exports/Simba Create SMP-0.9.13-Heavy-CurseForge.zip` and `exports/Simba Create SMP-0.9.13-Lite-CurseForge.zip`.
- Export structure verified: `manifest.json`, `overrides/`, and 5 bundled override jars.
- Retired the generic third client profile/export so Heavy-main is the default full pack and Lite is the performance fallback.
- Notes: Sodium, Sodium Options API, Sodium Dynamic Lights, Reese's Sodium Options, and CC:Tweaked are bundled override jars for local friend testing. Public CurseForge publishing still needs approved non-CurseForge mod/license review.

## 0.9.15 Create Aeronautics Addon Pass

- Added safe set: Create Cardan Shafts, Create Aeronautics: Transmission & Linkage, Create Aeronautics: Toolgun, Create: Tracks+, Create: Aeroworks, Create Propulsion: Simulated, and Create Aeronautics: Gadgets & Gizmos.
- Tested and rejected for main: Create Aeronautics: Delivery Required.
- Delivery Required failure: pulled Numismatics, KubeJS, KubeJS Create, LDLib, Ponder for KubeJS, and Rhino; the dedicated server then failed during mod loading with a Create/KubeJS/Petrochem wrapper conflict.
- Heavy-main export: `exports/Simba Create SMP-0.9.15-Heavy-CurseForge.zip`
- Lite export: `exports/Simba Create SMP-0.9.15-Lite-CurseForge.zip`
- Export structure verified: both ZIPs contain `manifest.json`, `overrides/`, Create Aeronautics, and Create: Tracks+.
- Heavy client entries: 134
- Lite client entries: 122
- Server mod count: 109 packwiz server entries, 109 jars in `server/dedicated/mods`.
- Server launch: Passed dedicated-server boot after removing Delivery Required and its dependency chain. Server reached ready state: `Done (17.139s)! For help, type "help"` and accepted `stop`.
- Notes: Existing non-fatal datapack/recipe warnings remain from Petrochem, Create Deco, Middgard, Create QoL, and FTB Backups. Create Propulsion logs missing fuel override targets for mods not installed, then completes fuel reload; this did not block boot.

## 0.9.16 Comfort Create Addon Filter

- Added: FTB Ultimine, Create Encased, and Create Goggles.
- Reason: these are high-comfort, low-drama additions. Ultimine improves mining/building flow, Encased expands Create casing/deco options, and Goggles adds practical Create wearable variants without shifting the whole pack into a new progression lane.
- Reviewed but not added now: Create Stuff & Additions, Create: Dreams & Desires, Create Sifting, Create: Numismatics, Create: Ender Transmission, Create: Recycle Everything, Create: Armory, Potato Weapons, Easy Structures, Guardian Beam Defense, Balanced Flight, and extra chunkloader overlap.
- Reason for holding: avoid flight/balance creep, duplicate resource-generation systems, KubeJS/Numismatics-adjacent risk, extra worldgen noise, and overlap with existing Power Loader, Ore Excavation, Copycats+, FramedBlocks, Design n' Decor, Rechiseled: Create, Connected, Diesel Generators, and Mechanical Extruder.
- Heavy-main export: `exports/Simba Create SMP-0.9.16-Heavy-CurseForge.zip`
- Lite export: `exports/Simba Create SMP-0.9.16-Lite-CurseForge.zip`
- Export structure verified: both ZIPs contain `manifest.json` and `overrides/`.
- Heavy client entries: 137
- Lite client entries: 125
- Server mod count: 112 packwiz server entries, 112 jars in `server/dedicated/mods`.
- Server launch: Passed dedicated-server boot. Server reached ready state: `Done (18.550s)! For help, type "help"` and accepted `stop`.

## 0.9.17 Pipes And Personal Transport Pass

- Added: Create: Pipes'n Physics and Create Jetpack.
- Reason: Pipes'n Physics deepens Create fluid engineering, which fits the oil/refinery/power identity. Create Jetpack gives Scott's requested personal transport while staying Create-native through the backtank/pressurized-air lane.
- Heavy-main export: `exports/Simba Create SMP-0.9.17-Heavy-CurseForge.zip`
- Lite export: `exports/Simba Create SMP-0.9.17-Lite-CurseForge.zip`
- Export structure verified: both ZIPs contain `manifest.json` and `overrides/`.
- Heavy client entries: 139
- Lite client entries: 127
- Server mod count: 114 packwiz server entries, 114 jars in `server/dedicated/mods`.
- Server launch: Passed dedicated-server boot. Server reached ready state: `Done (18.119s)! For help, type "help"` and accepted `stop`.
- Watch item: Pipes'n Physics is new and changes Create pipe/pump behavior. Test long pipe networks, refinery fluids, TFMG/Petrochem/Diesel Generators fluid flows, and server restart persistence before live-world launch.
- Notes: The new mods did not introduce a hard boot failure. Existing hardening noise remains from AllTheLeaks/Supplementaries and optional compat recipe/loot data.

## 0.9.18 Release Hardening Pass

- Added: Create: Central Kitchen.
- Removed: AllTheLeaks.
- Reason: Central Kitchen is the missing Farmer's Delight + Create automation glue. AllTheLeaks was removed because it produced false-positive shutdown/stuck-thread noise and a Supplementaries constructor error, making the logs less trustworthy.
- Fixed internal pack versions: Heavy `0.9.18-heavy`, Lite `0.9.18-lite`, Server `0.9.18-release-hardening`.
- Promoted key generated configs into the server pack source: ServerCore, FTB Ultimine, FTB Backups 3, Create Power Loader, Smooth Chunk Save, Connectivity, Tom's Storage, Create Ore Excavation, Dynamic View, FTB Chunks, Lootr, and Sophisticated Backpacks.
- Tightened FTB Ultimine: requires a proper tool, requires a valid tool for the block, adds a 10 tick cooldown, and prevents tools from being ultimined below 5 durability.
- Enabled FTB Backups 3 backup-on-shutdown.
- Enabled ServerCore's unloaded-chunk movement protection.
- Heavy-main export: `exports/Simba Create SMP-0.9.18-Heavy-CurseForge.zip`
- Lite export: `exports/Simba Create SMP-0.9.18-Lite-CurseForge.zip`
- Export structure verified: both ZIPs contain `manifest.json` and `overrides/`.
- Heavy client entries: 139
- Lite client entries: 127
- Server mod count: 114 packwiz server entries, 114 jars in `server/dedicated/mods`.
- C: working server launch: Passed dedicated-server boot. Server reached ready state: `Done (19.367s)! For help, type "help"` and accepted `stop`. Shutdown backup completed.
- D: final server sync: completed without touching the world folder. D: server now has 114 jars.
- D: final server launch: Passed dedicated-server boot. Server reached ready state: `Done (18.440s)! For help, type "help"` and accepted `stop`. Shutdown backup completed.
- Remaining known noise: optional compat recipe/loot errors still appear from rail/decor/worldgen data. They do not block boot, but should be cleaned in a later datapack-noise pass.

## 0.9.20 Vibe Addon Hardening Pass

- Added: Create: structures, Create: Easy Structures, Create: Bits 'n' Bobs, YUNG's Better Nether Fortresses, Create: Vibrant Vaults, Create: Protection Pixel, Petrol's Parts, Petrolpark Library, and YUNG's API.
- Tested and removed: Create Teleporters.
- Reason for removal: the server booted with Teleporters installed, but its `createteleporters:quantum_mechanism_recipe` failed to parse on Minecraft 1.21.1 / Create 6.0.10, meaning the intended late-game teleport progression was not trustworthy.
- Heavy-main export: `exports/Simba Create SMP-0.9.20-Heavy-CurseForge.zip`
- Lite export: `exports/Simba Create SMP-0.9.20-Lite-CurseForge.zip`
- Heavy client entries: 148
- Lite client entries: 136
- Server mod count: 123 packwiz server entries, 123 jars in both C: and D: dedicated server mods folders.
- C: working server launch: Passed dedicated-server boot and accepted `stop`. Shutdown backup completed.
- D: final server sync: completed without touching the world folder. D: server now has 123 jars.
- D: final server launch: Passed dedicated-server boot and accepted `stop`. Shutdown backup completed.
- Remaining known noise: existing optional compat recipe/loot errors remain from rail/decor/worldgen/generated data, plus a Petrolpark loot modifier warning. These did not block boot, but still deserve a later datapack-noise cleanup pass.

## 0.9.20 Fresh World Reset

- Archived old C: and D: test save state into each server's `_archived_saves/pre-0.9.20-fresh-start-*` folder.
- Archived: `world`, `local`, `database.db`, `usercache.json`, `logs`, `crash-reports`, `dynamic-data-pack-cache`, and `ftbbackups3`.
- Preserved: mods, configs, server properties, ops, whitelist, bans, launch scripts, watchdog, and pack source.
- D: final server generated a fresh new world and reached ready state: `Done (24.557s)! For help, type "help"`.
- Shutdown backup completed on the new D: world.
- Fresh-world note: Create Easy Structures logged missing `create_easy_structures:undergroundtrain_station` template pool references during spawn generation. This did not block startup, but the new structure stack should be watched during exploration.

## 0.9.21 Create Nuclear Endgame Proofing

- Added: Create Nuclear `1.3.2-beta.3` for NeoForge 1.21.1.
- Reason: endgame-proofing for a deeper Create power lane without adding a huge unrelated tech stack.
- Heavy-main export: `exports/Simba Create SMP-0.9.21-Heavy-CurseForge.zip`
- Lite export: `exports/Simba Create SMP-0.9.21-Lite-CurseForge.zip`
- Heavy client entries: 149
- Lite client entries: 137
- Server mod count: 124 packwiz server entries, 124 jars in both C: and D: dedicated server mods folders.
- C: working server launch: Passed dedicated-server boot and accepted `stop`.
- D: final server sync: completed without touching the world folder. D: server now has 124 jars.
- D: final server launch: Passed dedicated-server boot. Server reached ready state: `Done (17.013s)! For help, type "help"` and accepted `stop`.
- Watch item: Create Nuclear booted cleanly, but it is still a beta endgame addon. Test uranium generation in new chunks, reactor assembly, startup/shutdown, radiation or failure behavior, chunk unload/reload, and restart persistence before calling it live-safe.
- Performance note: first boot after the addon took longer; ModernFix reported dedicated server load around 82-115 seconds across the C: and D: tests. This is not a crash, but startup time should be watched as the pack grows.
- Remaining known noise: Create Easy Structures still logs missing `create_easy_structures:undergroundtrain_station` template pool references during generation. Spark may log a shutdown-only world-info warning after the watchdog sends stop. Neither blocked startup.

## 0.9.22 Transport Last-Call Pass

- Added: Create Train Utilities, Create Train Lights, and Create: Train Perspective.
- Reason: these are final rail-town polish additions. Train Utilities adds station doors, platform blocks, and station/train building blocks. Train Lights adds direction-aware train head/tail lights and interior lights. Train Perspective improves the camera feel while riding trains.
- Held: Railways Untold.
- Reason for hold: procedural infinite Create rail lines are interesting, but they change worldgen and can undercut the player-built rail network. Better as a separate experimental world than a launch-lock addition.
- Heavy-main export: `exports/Simba Create SMP-0.9.22-Heavy-CurseForge.zip`
- Lite export: `exports/Simba Create SMP-0.9.22-Lite-CurseForge.zip`
- Heavy client entries: 152
- Lite client entries: 140
- Server mod count: 126 packwiz server entries, 126 jars in both C: and D: dedicated server mods folders.
- D: final server sync: completed without touching the world folder. D: server now has 126 jars.
- D: final server launch: Passed dedicated-server boot. Server reached ready state: `Done (15.731s)! For help, type "help"` and accepted `stop`.
- Watch item: Create Train Utilities logs three failed advancements: `trainutilities:door_ingrediants`, `trainutilities:doors`, and `trainutilities:incomplete_prototype_door`. Recipes loaded and the server booted, so this is not a blocker, but it is a log-cleanup candidate.
- Remaining known noise: Create Easy Structures still logs missing `create_easy_structures:undergroundtrain_station` template pool references during generation. Spark may log a shutdown-only world-info warning after the watchdog sends stop. Neither blocked startup.

## 0.9.22 Feature Freeze

- Decision: 0.9.22 is the feature-freeze build for controlled group testing.
- Policy: no more broad server-side gameplay systems before the first group test unless the change is a bugfix, missing dependency, or direct stability fix.
- Heavy-main remains the visual/client-rich profile.
- Lite remains the practical fallback profile, close to server plus core client QoL/performance.
- Tinkers' Construct, Silent Gear, Tetra, Simply Swords, Railways Untold, and AI town/colony systems are held for after group testing.
- Release-freeze details written to `docs/RELEASE_FREEZE_0.9.22.md`.

## 0.9.23 Client Polish Pass

- Added to Heavy and Lite: Controlling, Searchables, Catalogue, Configured, Xaero's Minimap, and Xaero's World Map.
- Added to Heavy only: Chat Heads, Legendary Tooltips, Advancement Plaques, Blur+, MidnightLib, Iceberg, Prism, Dark Loading Screen Neoforge, Euphoria Patches, Complementary Reimagined, BSL Shaders, Bliss Shaders, and Photon Shaders.
- Heavy-main export: `exports/Simba Create SMP-0.9.23-Heavy-CurseForge.zip`
- Lite export: `exports/Simba Create SMP-0.9.23-Lite-CurseForge.zip`
- Heavy client entries: 167
- Lite client entries: 146
- Heavy export verified: contains `manifest.json`, `overrides/`, Xaero's Minimap, Xaero's World Map, Controlling, Configured, Chat Heads, Legendary Tooltips, Advancement Plaques, and 4 shaderpacks.
- Lite export verified: contains `manifest.json`, `overrides/`, Xaero's Minimap, Xaero's World Map, Controlling, and Configured; no bundled shaderpacks.
- Server note: dedicated server remains frozen at 0.9.22 with 126 jars. No server gameplay changes were made.
- Distribution note: Heavy bundles Modrinth/external files including shaderpacks. This is fine for private friend testing, but public CurseForge publication should re-check approved non-CurseForge file policy or swap to CurseForge metadata where available.

## 0.9.23 Performance And Scaling Notes

- Heavy-main is intentionally stopped at 167 entries. Do not chase 169 with filler mods.
- Server JVM is currently `-Xms4G` / `-Xmx8G`.
- Server distances are disciplined: `view-distance=8`, `simulation-distance=6`, with Dynamic View ranging view 6-10 and simulation 4-8.
- Recommended Heavy client allocation: 8-10 GB, especially with shaders and Distant Horizons.
- Recommended Lite client allocation: 6-8 GB.
- Performance/scaling notes written to `docs/PERFORMANCE_SCALING_0.9.23.md`.

## 0.9.24 Defaults And Diagnostics Pass

- Added Crash Assistant to Heavy-main and Lite for clearer client crash handling.
- Added Crash Utilities to the server profile for server-side crash diagnostics.
- Spark remains installed and is still the main profiler for TPS, tick cost, and memory investigations.
- Added client defaults to both profiles: VSync off, FPS cap 120, auto-jump off, fullscreen off, dark loading background on.
- Heavy-main default: Complementary Reimagined enabled through Iris, render distance 12, simulation distance 8.
- Lite default: shaders disabled, render distance 10, simulation distance 6.
- Heavy-main export: `exports/Simba Create SMP-0.9.24-Heavy-CurseForge.zip`
- Lite export: `exports/Simba Create SMP-0.9.24-Lite-CurseForge.zip`
- Heavy client entries: 168
- Lite client entries: 147
- Server mod count: 127 packwiz server entries, 127 jars in the D: dedicated server mods folder.
- Export verification passed: both ZIPs contain `manifest.json`, `overrides/`, `overrides/options.txt`, and `overrides/config/iris.properties`.
- Heavy export includes 4 shaderpacks. Lite export includes 0 shaderpacks.
- D: final server launch: Passed dedicated-server boot with Crash Utilities installed. Server reached ready state: `Done (53.359s)! For help, type "help"` and accepted stop.
- Remaining known noise: Create Easy Structures still logs missing template pool references during generation. Spark can still log a shutdown-only rejected-execution warning after stop. Neither blocked startup.
- Details written to `docs/CLIENT_DEFAULTS_DIAGNOSTICS_0.9.24.md`.

## 0.9.25 Inventory QoL Swap

- Promoted Inventory Profiles Next to the main inventory management mod in both Heavy-main and Lite.
- Added required client dependencies: libIPN and Kotlin for Forge.
- Removed Inventory Essentials from both client profiles to avoid duplicate inventory sorting/control layers.
- Kept Mouse Tweaks because it is small, familiar, and still useful for mouse-drag inventory handling.
- Heavy-main export: `exports/Simba Create SMP-0.9.25-Heavy-CurseForge.zip`
- Lite export: `exports/Simba Create SMP-0.9.25-Lite-CurseForge.zip`
- Heavy client entries: 169
- Lite client entries: 148
- Server note: no server gameplay or jar changes were made in this pass. The server remains at 127 jars.
- Export verification passed: both ZIPs contain `manifest.json`, `overrides/`, Inventory Profiles Next, libIPN, Kotlin for Forge, `overrides/options.txt`, and `overrides/config/iris.properties`.
- Export verification passed: Inventory Essentials is absent from both 0.9.25 ZIPs.

## 0.9.27 Branding And Social Art Pass

- Added Simba Create SMP generated branding assets: pack icon, server icon, app icon source, menu art source, and a small title-panorama resource pack.
- Used the provided Simba photos as likeness/mood reference only. Raw photos were not copied into the repo.
- Added `pack.png` and `resourcepacks/Simba Create SMP Branding.zip` to both Heavy-main and Lite.
- Updated both client `options.txt` files to load the branding resource pack by default.
- Added `server-icon.png` to the server pack source, C: dedicated server, and D: dedicated server.
- Added Immersive Paintings to Heavy-main, Lite, and server for shared group art, posters, screenshots, and town/factory decoration.
- Added Fzzy Config as the required Immersive Paintings dependency.
- Heavy-main export: `exports/Simba Create SMP-0.9.27-Heavy-CurseForge.zip`
- Lite export: `exports/Simba Create SMP-0.9.27-Lite-CurseForge.zip`
- Heavy client entries: 171
- Lite client entries: 150
- Server mod count: 129 packwiz server entries, 129 jars in the D: dedicated server mods folder.
- Export verification passed: both ZIPs contain `manifest.json`, `overrides/pack.png`, `overrides/resourcepacks/Simba Create SMP Branding.zip`, Immersive Paintings, and Fzzy Config.
- D: final server launch: Passed dedicated-server boot with Immersive Paintings installed. Server reached ready state: `Done (49.676s)! For help, type "help"` and accepted stop.
- Remaining known noise: Create Easy Structures missing template pool warnings and Spark shutdown-only rejected-execution warning remain non-blocking.
- Details written to `docs/BRANDING_AND_SOCIAL_ART_0.9.27.md`.

## 0.9.28 Heavy Lean Branding Pass

- Removed Blur+ from Heavy-main.
- Removed Dark Loading Screen Neoforge from Heavy-main.
- Heavy-main now sits at 169 pack entries.
- Lite was not pruned and remains at 150 pack entries.
- Generated new shadow-side Simba loading art inspired by the darker window-profile reference.
- Added `art/simba-branding/simba-shadow-loading-1920x1080.jpg`.
- Added `art/simba-branding/simba-shadow-loading-1920x1080.png`.
- Updated `resourcepacks/Simba Create SMP Branding.zip` with `assets/minecraft/textures/gui/title/mojangstudios.png` and `assets/simba_create/textures/gui/shadow_loading.png`.
- Reviewed Black Loading Screen as a resource-pack option. It is mostly an OptiFine `color.properties` pack, so it is not reliable as a Sodium/Iris loading-screen fix.
- Merged the useful dark-loading color idea into the Simba branding pack as `assets/minecraft/optifine/color.properties` for harmless compatibility, while keeping Simba art as the actual visual layer.
- Heavy-main export: `exports/Simba Create SMP-0.9.28-Heavy-CurseForge.zip`
- Lite export: `exports/Simba Create SMP-0.9.28-Lite-CurseForge.zip`
- Export verification passed: Heavy ZIP contains `manifest.json`, `overrides/pack.png`, `overrides/resourcepacks/Simba Create SMP Branding.zip`, and 4 shaderpacks.
- Export verification passed: Heavy ZIP does not contain Blur+ or Dark Loading Screen Neoforge.
- Export verification passed: nested branding pack contains `assets/minecraft/optifine/color.properties`, `assets/minecraft/textures/gui/title/mojangstudios.png`, `assets/simba_create/textures/gui/shadow_loading.png`, and 7 panorama files.
- Note: the resource pack can override the vanilla loading/title logo texture and provide the shadow loading artwork, but it is not a full custom loading-screen engine like FancyMenu or Drippy Loading Screen.

## 0.9.29 Lite Lean Client Pass

- Goal: make Lite actually light without making it feel anonymous or unpleasant to play.
- Kept Simba branding resource pack in Lite by request.
- Removed from Lite: AppleSkin, Catalogue, Configured, Crash Assistant, Crafting Tweaks, Create: Train Perspective, Reese's Sodium Options, Sodium Dynamic Lights, and Sodium Options API.
- Kept Lite essentials: Sodium, JEI, Jade, Xaero's Minimap, Xaero's World Map, Inventory Profiles Next, libIPN, Kotlin for Forge, Mouse Tweaks, Controlling, Searchables, Entity Culling, MoreCulling, ImmediatelyFast, BadOptimizations, and Dynamic FPS.
- Lite export: `exports/Simba Create SMP-0.9.29-Lite-CurseForge.zip`
- Lite client entries: 141
- Lite ZIP size: about 99.28 MB
- Export verification passed: Lite ZIP contains `manifest.json`, `overrides/options.txt`, Simba branding resource pack, Sodium, and Inventory Profiles Next.
- Export verification passed: removed Lite mods are absent from the 0.9.29 Lite ZIP.
- Server and Heavy-main were not changed in this pass.

## 0.10.0 Fresh World Group-Test Update

- Removed: Middgard, Oh The Trees You'll Grow, Treeplacer, and Create Aeronautics: Transmission & Linkage.
- Added: Terralith, Torchmaster, Comforts, Curios, Corail Tombstone, FallingTree, Carry On, and CC: Tweaked.
- Added the pinned JEI 19.27.0.338 file to the server profile.
- Updated compatible current mods across Heavy, Lite, and Server.
- Held: JEI 19.27.0.338, Create: Enchantment Industry 2.4.2, CC: Tweaked 1.120.0, BankSystem 1.4.1, and Stock Market 1.3.1.
- Rejected BankSystem/Stock Market 2.0.2 after the isolated server reached ready state and then hung in BankSystem item-ID registration until the watchdog terminated it.
- Isolated C: validation server generated a fresh Tectonic + Terralith world and reached `Done (27.092s)` on a non-production port.
- Validation-side shutdown logged an embedded finance-service port collision because the production server is currently running; D: was not touched.
- Pack validator passed for Heavy, Lite, and Server.
- Heavy export: `exports/Simba Create SMP-0.10.0-Heavy-CF-With-Overrides-CurseForge.zip`.
- Lite export: `exports/Simba Create SMP-0.10.0-Lite-CF-With-Overrides-CurseForge.zip`.
- Server export: `exports/Simba Create SMP-0.10.0-Server-CF-With-Overrides-CurseForge.zip`.
- Export verification passed: all three include CC: Tweaked and the new configs; none include Middgard, Treeplacer, Oh The Trees You'll Grow, or Transmission & Linkage.
- Production sync intentionally deferred until players are offline and the old world can be archived.
- 2026-07-12 — World-regression audit for the locked 0.10.0 Server export: compared against the prior 0.9.36 server manifest. The only removed project is Create Aeronautics: Transmission & Linkage; Middgard, Oh The Trees You'll Grow, Treeplacer, Tectonic, Terralith, and Lithostitched are all present. Changed files are limited to compatible utility/Create addon updates plus Sophisticated Core 1.4.72.2136. No worldgen/biome registry mod was removed.
- 2026-07-12 — Final map-lock correction: Terralith removed; Middgard, Oh The Trees You'll Grow, Treeplacer, Tectonic, and Lithostitched retained. Transmission & Linkage 0.2.4 restored.
- 2026-07-12 — Added Paxi 5.1.3 and generated a targeted 597-resource cleanup datapack. Isolated C: server boot reduced error-level log entries from 611 to 16, with zero broken loot-table errors and zero recipe parsing errors. The validation server reached `Done (23.819s)`. Remaining errors are 13 dedicated-server client-class scans, one malformed Middgard filename, one missing Tracks Plus tag reference, and one optional Create QoL fuel-map reference. Production D: was not touched.
- 2026-07-12 — Added Create: Quality Of Life 1.6.3-fix1 to Heavy, Lite, and Server. CurseForge lists it for NeoForge 1.21.1 and the author states support for Create 6.0.10. This also supplies the optional integration target referenced by Portable Engine Liquid Fuel.
- 2026-07-12 — Create: Quality Of Life isolated dedicated-server validation passed. The server reached `Done (25.669s)`, accepted a clean `stop`, and exited 0. The prior Portable Engine Liquid Fuel missing-Create-QoL fuel-map error is gone. All three 0.10.0 exports were rebuilt and verified to contain CurseForge project 905508 file 8265828 plus the required override-only mods. Production D: was not touched.
- 2026-07-12 — Added BlueMap 5.7 to Server only with a Simba production profile: TCP 8100 webserver, high-resolution 3D/flat/free-flight views for Overworld/Nether/End, two render threads, automatic mod-resource scanning, visible friendly-server player markers, and rendering paused whenever one or more players are online. Isolated validation loaded the full mod resource set, bound port 8100, returned HTTP 200 from the web viewer, reached server ready state, and exited cleanly. Production D: was not touched.
- 2026-07-12 — Scott-list compatibility waves passed isolated dedicated-server testing. Wave one added building/QoL/Create content and confirmed Simple Voice Chat on UDP 24454 plus BlueMap resource baking. Wave two added Parcool, Immersive Aircraft, Mutants and Zombies, Undead Nights, and Enhanced Hordes. Patchouli removed Parcool's two optional-guide parse errors. Final tuned boot reached ready state, started voice chat, and exited 0. Production D: was not touched.
- 2026-07-12 — Published 0.10.0 beta to CurseForge project 967235 through the upload API. Heavy main file 8419841; Lite child 8419843; Server child 8419844. Production D: was not touched.
- 2026-07-12 — Compacted the 597-resource Paxi cleanup datapack from roughly 598 loose files into one 157 KB ZIP per profile. Isolated full-stack boot retained zero loot, recipe, and advancement parsing errors, reached ready state, and exited 0. Remaining error-level lines stayed at 16. Production D: was not touched.
- 2026-07-12 — 0.10.1 QA hotfix: Heavy exposed a loader conflict because Sophisticated Core 1.4.72.2136 requires JEI 19.32+, while Petrolpark requires the pack's JEI 19.27.0.338 pin. Restored the tested Sophisticated Core 1.4.69.2125 and Sophisticated Backpacks 3.25.68.1971 pair across Heavy, Lite, and Server. Jar metadata confirms Backpacks accepts Core 1.4.67+ and this Core build does not impose the newer JEI constraint. Added a validator regression guard and rebuilt all three exports. No world/content mods changed; production D: was not touched.
- 2026-07-12 — Final 0.10.1 medieval equipment pass added Simply Swords 1.63.0 plus Simply Tooltips 0.1.3, Epic Knights 10.12, YDM's Weapon Master 4.2.7, Cosmetic Armor Reworked v1, and Enchanting Infuser 21.1.4. The combined isolated NeoForge 1.21.1 server reached `Done (43.383s)` with no mod-loading failure. Better Combat was deliberately held because its attack/animation overhaul overlaps Parcool and Weapon Master and is beyond the scope of this compatibility hotfix. Production D: was not touched.
- 2026-07-12 — Added Illager Invasion 21.1.6 as the focused PvE-loop addition. Its isolated combined boot reached `Done (25.173s)`. Packaged defaults keep the nine regular new illagers in village raids while the boss-tier Invoker remains excluded from normal raid waves; this avoids adding another global spawn-pressure system on top of Enhanced Hordes and Undead Nights. Production D: was not touched.
- 2026-07-12 — Added ewewukek's Musket Mod 1.5.4 and the client-only Flintlocks 1.2 overhaul. Promoted the balanced Musket server config and enabled Flintlocks by default in Heavy/Lite. Promoted a forgiving-survival Create: Deep Seas profile: implosions remain enabled, effective depth tolerance is 2×, crack progression is 10% of normal, oxygen scan capacity is 1.5 million blocks, and large-sub ballast/floater lift is moderately increased. Source review confirmed once-per-second pressure checks, audible creaks, three visible/dripping crack stages, wrench repairs, barometer warning/critical states, and display-link support before a block breaches. Combined isolated boot reached `Done (46.859s)`. Production D: was not touched.
- 2026-07-12 — Began 0.10.2 hot QA. Added WATUT 1.2.7 with CoroUtil and Better Combat 2.3.2 with Player Animator; combined isolated boot reached `Done (25.935s)`. Added Create: Gunsmithing 1.4.8 with NTGL 3.1.7; full combined boot reached `Done (45.575s)`. Verified Gunsmithing includes Create filling, emptying and mechanical-crafting recipes for firearm components, ammunition and industrial weapons. Packaged WATUT's low-overhead GUI snapshot defaults and disabled NTGL block ignition/explosive terrain removal while retaining glass impacts and gunshot mob aggro. Production D: was not touched.
- 2026-07-12 — Added Better Days 3.3.6.3 to 0.10.2; full isolated boot reached `Done (25.339s)` and the packaged config retest reached `Done (27.948s)`. Final timing is 60 real minutes of daylight and 15 minutes of night. Sleep accelerates time smoothly from 8× with minimal participation toward 110× when everyone sleeps; block entities, random ticks, hunger and potion effects are deliberately not accelerated. Production D: was not touched.
- 2026-07-12 — Added the client-only Drippy branding framework to Heavy and Lite: Drippy Loading Screen 3.1.2, Drippy Early Loading Module 3.1.2, FancyMenu 3.9.6, Konkrete 1.9.9 and Melody 1.0.10. All are current NeoForge 1.21.1 files. No custom layout was forced before art delivery; the existing Simba branding resource pack remains the visual fallback. Server export excludes the entire stack. Production D: was not touched.
- 2026-07-12 — Added the complete Create’a Colony-inspired settlement wave: MineColonies 1.1.1346, CreateColonies 2.0.5, Structurize, Domum Ornamentum, BlockUI, Multi-Piston, StyleColonies, TownTalk, MineColonies Tweaks 3.32, MineColonies Compatibility 3.53, Better Villages and Library Ferret. Full-stack isolated boot reached `Done (46.710s)` before tuning. The older MineColonies 1.1.1333 build targeted by addon metadata was explicitly rejected because it hard-crashed dedicated registration in this pack; current 1.1.1346 boots successfully. Configured 250 maximum citizens, raid difficulty 3, maximum 20 colony raiders, 8-night average/6-night minimum cadence, colony explosion protection, hostile-mob citizen attacks, and 35% abandoned-colony generation. Better Villages affects new chunks only. Production D: was not touched.
- 2026-07-12 — Completed CurseForge package-hardening pass. Added a strict manifest/override validator, exact SHA-256 allowlist for the four unavoidable bundled jars, client/server leakage checks, duplicate project/path checks, secret scanning, forbidden runtime-file checks, POSIX ZIP-path enforcement, nested cleanup-datapack validation, and override count/size budgets. Documented the release policy and exception rationale. Production D: was not touched.
