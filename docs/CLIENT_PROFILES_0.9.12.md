# Client Profiles 0.9.12

## Server

- Source: `server/packwiz-server`
- Purpose: dedicated server only
- Pack entries: 100
- Dedicated server jars: 100
- Fancy client visuals: no
- Export: server folder, not a CurseForge client ZIP

## Heavy Client

- Source: `client/packwiz-client`
- Name: `Simba Create SMP Heavy`
- Version: `0.9.12-heavy`
- Purpose: full visual and ambience experience
- Pack entries: 124
- CurseForge manifest entries: 123
- Bundled override jars: 1 (`cc-tweaked-1.21.1-forge-1.120.0.jar`)
- Export: `exports/Simba Create SMP-0.9.12-Heavy-CurseForge.zip`

Heavy includes the shader and vibe stack: Iris, Distant Horizons, AmbientSounds, Sound Physics Remastered, Presence Footsteps, Particle Rain, Falling Leaves, Not Enough Animations, and the full QoL/performance client set.

## Lite Client

- Source: `client/packwiz-lite`
- Name: `Simba Create SMP Lite`
- Version: `0.9.12-lite`
- Purpose: laptop-friendly client that stays as close as possible to the server profile
- Pack entries: 112
- CurseForge manifest entries: 111
- Bundled override jars: 1 (`cc-tweaked-1.21.1-forge-1.120.0.jar`)
- Export: `exports/Simba Create SMP-0.9.12-Lite-CurseForge.zip`

Lite starts from the server pack and adds only practical client helpers:

- AppleSkin
- BadOptimizations
- Crafting Tweaks
- Dynamic FPS
- Entity Culling
- ImmediatelyFast
- Inventory Essentials
- Jade
- JEI
- MoreCulling
- Mouse Tweaks
- Sodium

Lite intentionally excludes the fancy client stack:

- Iris Shaders
- Distant Horizons
- AmbientSounds
- Sound Physics Remastered
- Presence Footsteps
- Particle Rain
- Falling Leaves
- Not Enough Animations
- Durability Tooltip
- TrashSlot

## Map Note

No extra minimap mod was added to Lite because FTB Chunks is already part of the shared server pack and includes a minimap and large map. This keeps Lite closer to the server and avoids another client-only mapping ecosystem.

## Distribution Caveat

Both client ZIPs bundle CC:Tweaked `1.120.0` as an override jar because the CurseForge 1.21.1 file is too old for Create New Age. This is fine for local friend testing, but public CurseForge publishing still needs license and approved non-CurseForge-mod review.
