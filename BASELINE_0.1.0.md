# Baseline 0.1.0

Locked on 2026-07-08.

## Versions

- Minecraft: 1.21.1
- Loader: NeoForge
- Loader version: 21.1.235
- Pack version: 0.1.0
- Pack format: packwiz:1.1.0

## Validation

- `pack.toml`: present and points to `index.toml`
- `index.toml`: present and refreshed with packwiz
- Mod metadata files: 39 `.pw.toml` files present
- Exported pack: `packwiz-pack/Simba Create SMP-0.1.0.mrpack`
- Export result: Modrinth `.mrpack` archive opens and contains `modrinth.index.json`

## Total Mod Count

39 installed mods including dependencies.

## Installed Mods

- AppleSkin
- CC: Tweaked
- Chunky
- Clumps
- Create
- Create Crafts & Additions
- Create Deco
- Create Ore Excavation
- Create: Bells & Whistles
- Create: Connected
- Create: Copycats+
- Create: Design n' Decor
- Create: Dragons Plus
- Create: Enchantment Industry
- Dynamic FPS
- Embeddium
- Entity Culling
- FerriteCore
- FramedBlocks
- Fusion (Connected Textures)
- Jade
- Just Enough Items (JEI)
- Lithostitched
- Lootr
- Macaw's Bridges
- ModernFix
- Moonlight Lib
- Polymorph
- Rechiseled
- Rechiseled: Create
- Sophisticated Backpacks
- Sophisticated Core
- spark
- Storage Drawers
- SuperMartijn642's Config Lib
- SuperMartijn642's Core Lib
- Supplementaries
- Tectonic
- Terralith

## Known Missing Categories

- FTB admin layer: teams, chunks/claims, essentials, ranks, backups, quests.
- Dedicated lighting/searchlight category.
- Distant Horizons client visual profile.
- Server config policy files for claims, chunk loading, backups, and pregeneration.
- KubeJS scripts or recipe balancing.
- Dedicated server start script and packwiz installer workflow.
- CurseForge export with FTB-only dependencies.
- Full launch test in a Minecraft client and server.

## Known Risks

- CC: Tweaked was selected from available 1.21.1 NeoForge builds marked alpha by Modrinth.
- JEI selected a 1.21.1 NeoForge build marked beta by Modrinth.
- Terralith export selected `Terralith_1.21.x_v2.5.8.jar` even though newer 2.6.2 metadata was visible in live checks.
- Create: Enchantment Industry is pinned to stable 2.4.2, which added Create: Dragons Plus as a dependency.
- Supplementaries, Create Ore Excavation, and Sophisticated Backpacks should be tested for balance and server load.
- No world has been generated or pregenerated yet.
- No FTB backups/claims are installed yet, so this baseline is not server-admin complete.
