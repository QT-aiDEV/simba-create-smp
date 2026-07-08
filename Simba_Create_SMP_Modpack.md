# Simba Create SMP Modpack

Status: Draft 1, based on live Modrinth availability checks on 2026-07-08.

## Target

- Minecraft: 1.21.1
- Loader: NeoForge
- Core identity: Create-first private SMP
- Core Create version: Create 6.0.10 for Minecraft 1.21.1
- Launch goal: 85-95 total mods including libraries and dependencies
- Hard cap: 100 total jars

This pack should feel like a rail-town and infrastructure server: huge terrain, long rail lines, depots, factories, stone and concrete utility buildings, searchlights, storage rooms, shared towns, and stable long-term play.

## Launch Philosophy

Version 1 should be "Rail Town":

- Create is the main automation and progression system.
- No Mekanism, ProjectE, Thermal stack, AE2, Refined Storage, Industrial Foregoing, or Extreme Reactors at launch.
- Storage should reduce pain without replacing warehouses, belts, trains, vaults, depots, and physical logistics.
- Terrain should be large and believable, not a pile of overlapping biome mods.
- Performance, backups, claims, pregeneration, and profiling are foundation mods, not extras.

## Recommended Launch Profile

Estimated top-level mods: 47-55.

Estimated total with libraries/dependencies: 82-96.

### Core

| Mod | Source | Role | Risk | Side |
| --- | --- | --- | --- | --- |
| Create | https://modrinth.com/mod/create | Main automation system | Medium | Client + server |
| Create Crafts & Additions | https://modrinth.com/mod/createaddition | Energy bridge and engineering depth | Medium | Client + server |
| Create: Connected | https://modrinth.com/mod/create-connected | Better Create components | Low | Client + server |
| Create Deco | https://modrinth.com/mod/create-deco | Rail and industrial decoration | Low | Client + server |
| Create: Copycats+ | https://modrinth.com/mod/copycats | Shape/detail building | Low | Client + server |
| Create: Bells & Whistles | https://modrinth.com/mod/bellsandwhistles | Train/station details | Low | Client + server |
| Create: Design n' Decor | https://modrinth.com/mod/create-design-n-decor | Create-style decoration | Medium | Client + server |
| Create Ore Excavation | https://modrinth.com/mod/create-ore-excavation | Long-term resource loop | Medium | Client + server |
| Create: Enchantment Industry | https://modrinth.com/mod/create-enchantment-industry | Create-based enchanting automation | Medium | Client + server |

### Terrain And World Scale

| Mod | Source | Role | Risk | Side |
| --- | --- | --- | --- | --- |
| Tectonic | https://modrinth.com/mod/tectonic | Large terrain and mountain scale | Medium | Server required |
| Terralith | https://modrinth.com/mod/terralith | Biome variety using vanilla-style blocks | Medium | Server required |
| Lithostitched | https://modrinth.com/mod/lithostitched | Worldgen dependency/compat layer | Low | Server required |
| Distant Horizons | https://modrinth.com/mod/distanthorizons | Long-distance visual terrain | Medium | Mostly client |
| Chunky | https://modrinth.com/mod/chunky | Chunk pregeneration | Low | Server |

### Server Admin

These are CurseForge-side picks. Keep them unless we later decide on Modrinth-only sharing.

| Mod | Source | Role | Risk | Side |
| --- | --- | --- | --- | --- |
| FTB Library | https://www.curseforge.com/minecraft/mc-mods/ftb-library-forge | FTB dependency | Low | Client + server |
| FTB Teams | https://www.curseforge.com/minecraft/mc-mods/ftb-teams-forge | Shared teams | Low | Client + server |
| FTB Chunks | https://www.curseforge.com/minecraft/mc-mods/ftb-chunks-forge | Claims, map, force-load rules | Medium | Client + server |
| FTB Essentials | https://www.curseforge.com/minecraft/mc-mods/ftb-essentials | Useful server commands | Low | Server |
| FTB Backups 3 | https://www.curseforge.com/minecraft/mc-mods/ftb-backups-3 | Scheduled backups | Low | Server |
| FTB Ranks | https://www.curseforge.com/minecraft/mc-mods/ftb-ranks | Permissions/ranks | Low | Server |
| FTB Quests | https://www.curseforge.com/minecraft/mc-mods/ftb-quests-forge | Optional onboarding book | Medium | Client + server |

### Performance And Diagnostics

| Mod | Source | Role | Risk | Side |
| --- | --- | --- | --- | --- |
| ModernFix | https://modrinth.com/mod/modernfix | Bug fixes and performance | Low | Client + server |
| FerriteCore | https://modrinth.com/mod/ferrite-core | Memory reduction | Low | Client + server |
| Embeddium | https://modrinth.com/mod/embeddium | Client rendering performance | Low | Client |
| Entity Culling | https://modrinth.com/mod/entityculling | Client-side culling | Low | Client |
| Dynamic FPS | https://modrinth.com/mod/dynamic-fps | Reduces background load | Low | Client |
| Clumps | https://modrinth.com/mod/clumps | XP orb lag reduction | Low | Client + server |
| spark | https://modrinth.com/mod/spark | Profiling and lag diagnosis | Low | Server |

### Building, Lights, And Town Detail

| Mod | Source | Role | Risk | Side |
| --- | --- | --- | --- | --- |
| FramedBlocks | https://modrinth.com/mod/framedblocks | Slopes, panels, detailed builds | Low | Client + server |
| Supplementaries | https://modrinth.com/mod/supplementaries | World/building detail | Medium | Client + server |
| Rechiseled | https://modrinth.com/mod/rechiseled | Block variants | Low | Client + server |
| Rechiseled: Create | https://modrinth.com/mod/rechiseled-create | Create-themed variants | Low | Client + server |
| Macaw's Bridges | https://modrinth.com/mod/macaws-bridges | Bridges and rail-town infrastructure | Low | Client + server |
| Chipped | https://modrinth.com/mod/chipped | Large block palette | Medium | Client + server |

Policy: start with Rechiseled plus Rechiseled: Create. Add Chipped only if the group really wants the bigger palette, because it overlaps with Rechiseled.

### Storage, Logistics, And QoL

| Mod | Source | Role | Risk | Side |
| --- | --- | --- | --- | --- |
| Storage Drawers | https://modrinth.com/mod/storagedrawers | Bulk storage | Low | Client + server |
| Sophisticated Backpacks | https://modrinth.com/mod/sophisticated-backpacks | Player storage | Medium | Client + server |
| CC: Tweaked | https://modrinth.com/mod/cc-tweaked | Computers, automation, Kelvin lane | Medium | Client + server |
| Polymorph | https://modrinth.com/mod/polymorph | Recipe conflict handling | Low | Client + server |
| Just Enough Items | https://modrinth.com/mod/jei | Recipe viewer | Low | Client |
| Jade | https://modrinth.com/mod/jade | Block/entity info | Low | Client + server |
| AppleSkin | https://modrinth.com/mod/appleskin | Food/saturation UI | Low | Client |
| KubeJS | https://modrinth.com/mod/kubejs | Future recipe and balance control | Medium | Client + server |

### Light Flavour

| Mod | Source | Role | Risk | Side |
| --- | --- | --- | --- | --- |
| Waystones | https://modrinth.com/mod/waystones | Town-to-town travel, optional | Medium | Client + server |
| Comforts | https://modrinth.com/mod/comforts | Sleeping bags/hammocks | Low | Client + server |
| Carry On | https://modrinth.com/mod/carry-on | Move containers/entities | Medium | Client + server |
| Lootr | https://modrinth.com/mod/lootr | Multiplayer-friendly loot | Low | Client + server |

Policy: Waystones should be limited. Prefer trains for primary travel. Use waystones as emergency/town hubs, not every 200 blocks.

## Strong Include

- Create
- Create Crafts & Additions
- Create: Connected
- Create Deco
- Create: Copycats+
- Create: Bells & Whistles
- Tectonic
- Terralith
- Lithostitched
- ModernFix
- FerriteCore
- Embeddium
- Entity Culling
- Dynamic FPS
- Clumps
- spark
- Chunky
- Storage Drawers
- Sophisticated Backpacks
- CC: Tweaked
- Polymorph
- JEI
- Jade
- AppleSkin
- FTB Library
- FTB Teams
- FTB Chunks
- FTB Essentials
- FTB Backups 3
- FTB Ranks

## Test Candidate

- Create Ore Excavation: good fit, but tune resource rates.
- Create: Enchantment Industry: strong Create flavour, but watch progression speed.
- Create: Design n' Decor: good style, but test for overlap and missing recipes.
- Distant Horizons: client-side visual win, but beta builds and GPU/RAM settings need care.
- Supplementaries: great atmosphere, but broad feature surface.
- Chipped: massive palette, but overlaps with Rechiseled.
- Waystones: useful, but can weaken railroad identity if unrestricted.
- Carry On: useful, but can interact weirdly with modded blocks/entities.
- KubeJS: useful for balancing, but only worth keeping if we actually use scripts.
- FTB Quests: great for onboarding, not mandatory for three friends.

## Delay Or Cut

- AE2: delay until storage pain is genuinely hurting the world.
- Refined Storage: delay/cut for the same reason as AE2.
- Mekanism: cut for launch; it becomes the center of tech progression.
- ProjectE: cut; it erases resource logistics.
- Thermal stack: cut for launch.
- Industrial Foregoing: cut for launch.
- Extreme Reactors: cut for launch.
- RFTools Builder: cut for launch.
- Pixelmon/Cobblemon: cut unless the server identity changes.
- Gun mods: cut unless the server identity changes.
- Multiple furniture packs: cut. Use one or two decoration systems.
- Multiple biome stacks beyond Tectonic/Terralith: cut.

## Experimental Profile

Use this only after the launch profile runs cleanly for several test sessions.

Add:

- Create Aeronautics - https://modrinth.com/mod/create-aeronautics
- Steam 'n' Rails NeoForge port - https://modrinth.com/mod/create-steam-n-rails-1.21.1
- Create: Crafts & Additions and Aeronautics Compat - https://modrinth.com/mod/create-crafts-additions-and-aeronautics-compat
- Extra Copycats - https://modrinth.com/mod/extra-copycats

Experimental warning:

- Aeronautics is a big system, not casual decoration.
- Flying machines, vehicles, and moving contraptions can create server load.
- Keep it out of the first shared world unless a test world proves it behaves.

## Config Policy

### Chunk Claims And Loading

- Claims enabled for bases, towns, stations, and shared factories.
- Force-loaded chunks should be limited per player/team.
- No permanently force-loaded decorative chunks.
- Make the main shared factory a team claim, not one player's private claim.

### Backups

- FTB Backups 3 enabled on the server.
- Backup before adding/removing worldgen mods.
- Backup before updating Create, Create addons, FTB Chunks, or terrain mods.
- Keep at least daily backups and a few manual milestone backups.

### Pregeneration

- Use Chunky before launch.
- Pregenerate a realistic starter area before friends join.
- Suggested first pass: 5,000-8,000 block radius around spawn.
- Expand later if trains push farther out.

### Distant Horizons

- Client optional.
- Do not require every player to use the same visual distance.
- Keep server view distance reasonable and let DH handle far visuals client-side.
- Treat beta updates carefully.

### Terrain

- Lock Tectonic/Terralith before the real world starts.
- Do not add/remove terrain mods after the world is active unless everyone accepts chunk borders.
- Test at least 10 seeds for rail-friendly plains, valleys, mountains, and ocean spacing.

### Storage

- Storage Drawers allowed early.
- Sophisticated Backpacks allowed, but avoid overpowered upgrades too early if it trivializes logistics.
- No AE2/Refined Storage launch terminals.

### Waystones

- If included, restrict to spawn, major towns, and major far projects.
- Do not let waystones replace rail stations.

## Sharing Plan

Best path for friends:

1. Build and test the pack in Prism Launcher or the Modrinth App.
2. Prefer Modrinth-hosted mods where possible.
3. If keeping the FTB admin layer, either:
   - use a CurseForge export, or
   - keep a Modrinth pack plus a short "manual FTB server mods" install note.
4. Once stable, publish privately/unlisted for friends.

Recommendation:

- Use CurseForge export if the FTB layer is non-negotiable and you want the easiest friend install.
- Use Modrinth export if we replace FTB with Modrinth-hosted alternatives or accept a small manual install note.

## Player Taste Mapping

Kelvin:

- CC: Tweaked, Create trains, Storage Drawers, FTB Chunks, FramedBlocks, lights/deco, rail infrastructure.

Scott:

- Create Crafts & Additions, Create Ore Excavation, large factories, resource loops, power conversion, train-scale industry.

Martin:

- Create, Create Deco, Bells & Whistles, Copycats+, Supplementaries, terrain, atmospheric towns.

Group:

- Backups, claims, pregeneration, performance mods, JEI/Jade/Polymorph, shared stations, shared factories.

## Next Build Steps

1. Create a test instance: Minecraft 1.21.1 + NeoForge.
2. Add Strong Include mods first.
3. Launch client and server once with only Strong Include mods.
4. Add Test Candidate mods in small batches.
5. Generate a test world and run Chunky pregeneration.
6. Use spark if TPS drops.
7. Lock the launch list.
8. Export for friends through CurseForge or Modrinth.
