# Simba Create SMP Release Hardening - 0.9.9

Date: 2026-07-08

## Output

- Client CurseForge ZIP: `exports/Simba Create SMP-0.9.9-CurseForge.zip`
- Minecraft: 1.21.1
- Loader: NeoForge 21.1.235
- Manifest entries: 120
- Bundled override jars: 0

## What Was Fixed

The dedicated-server weak spot from the risk audit was addressed at the packwiz metadata level.

Before:

- Every mod was marked `side = "both"`.
- This made it too easy to accidentally build a server folder with client-only shader, renderer, UI, audio, and ambience mods.

After:

- 96 mods remain `side = "both"`.
- 24 obvious client-only mods are now `side = "client"`.
- `packwiz refresh` completed successfully.
- A new CurseForge client export was created as 0.9.9.

## Client-Only Mods Marked

- AmbientSounds 6
- AppleSkin
- BadOptimizations
- Colorwheel
- Crafting Tweaks
- CreativeCore
- Distant Horizons
- Durability Tooltip
- Dynamic FPS
- Entity Culling
- Falling Leaves
- ImmediatelyFast
- Inventory Essentials
- Iris Shaders
- Jade
- JEI
- MoreCulling
- Mouse Tweaks
- Not Enough Animations
- Particle Rain
- Presence Footsteps
- Sodium
- Sound Physics Remastered
- TrashSlot

## Server-Side Guidance

Do not use the CurseForge client ZIP as a direct server mod folder.

For a dedicated server, use the packwiz source and install only:

- `side = "both"` mods
- future `side = "server"` mods, if any are added

This keeps shader/render/UI/audio mods off the server.

## Remaining Weak Points

### Must Test Before Release Candidate

- Client launch with no shaderpack.
- Client launch with shaderpack.
- Fresh world generation.
- Dedicated server launch with server-side mod list only.
- Two-player join test.
- Server restart test.
- Animal/villager persistence test.
- Create contraption test.
- Aeronautics/Sable vehicle test.
- Deep Seas submarine test.
- Train test with Steam 'n' Rails, Railways Navigator, and Track Map.
- Oil/refinery test with Diesel Generators, TFMG, Petrochem, Liquid Fuel, and Aeronautics fuel.
- Oritech resource/machine test.
- Almost Unified recipe/material test.

### Highest-Risk Mods To Watch

- Create Aeronautics
- Sable
- Create Deep Seas
- Steam 'n' Rails Neoforge
- Create: Track Map unofficial fork
- Iris Shaders
- Distant Horizons
- Create: Petrochem
- Create: The Factory Must Grow
- Oritech
- Middgard

## Not Missing Anymore

- Crafting conflict chooser: Polymorph is installed.
- Material/resource unifier: Almost Unified is installed.
- Create submarine/boat layer: Create Deep Seas is installed.
- Create oil/refinery layer: Diesel Generators, TFMG, Petrochem, Liquid Fuel, and Aeronautics fuel support are installed.
- Tectonic terrain direction: Tectonic + Middgard is installed; Terralith was removed.

## Still Missing By Choice

- Valkyrien Skies: intentionally excluded due shader/physics instability risk.
- Ferronautics: intentionally skipped because it is beta/crude and superseded by Loconautics.
- Loconautics: watchlist; not stable on CurseForge yet.
- Teleportation mods: intentionally excluded to preserve rail/travel gameplay.
- AE2 / Refined Storage / Mekanism / Thermal / ProjectE: intentionally excluded.

## Recommendation

0.9.9 is ready for import testing, not live release.

The server-side metadata issue is fixed enough to proceed to a dedicated-server build/test pass. The next hardening step is runtime testing, not more static review.
