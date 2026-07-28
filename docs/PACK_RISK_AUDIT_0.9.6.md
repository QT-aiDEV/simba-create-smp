# Simba Create SMP Pack Risk Audit - 0.9.6

Date: 2026-07-07

## Current Pack

- Pack version: 0.9.6
- Minecraft: 1.21.1
- Loader: NeoForge 21.1.235
- CurseForge export: `exports/Simba Create SMP-0.9.6-CurseForge.zip`
- Manifest entries: 115
- Bundled override jars: 0
- Export structure: `manifest.json`, `modlist.html`, `overrides/`
- Duplicate CurseForge project IDs in export: none found
- Client launch: not yet tested
- Server launch: not yet tested

## Overall Verdict

Not ready for live server yet.

Ready for CurseForge client import testing.

The pack is coherent and exciting, but the last waves added several high-impact systems: Sable/Aeronautics, Steam 'n' Rails unofficial port, multiple oil/refinery systems, Oritech, shader stack, Distant Horizons, and a large performance stack. None of these are automatic removals, but they must be tested before the launch world.

## Hard Blockers

No packaging blockers found.

The 0.9.6 ZIP is a valid CurseForge-style manifest export and does not bundle mod jars.

## Biggest Runtime Risks

### 1. Client-only mods are marked `side = "both"`

All packwiz metadata currently marks mods as `side = "both"`, including obvious client-side mods such as Sodium, Iris, Dynamic FPS, Colorwheel, AmbientSounds, Entity Culling, MoreCulling, Not Enough Animations, Particle Rain, Presence Footsteps, and similar visual/audio mods.

Impact:

- Fine for the CurseForge client ZIP.
- Not fine as a direct server mod list.
- A server pack should be generated/audited separately so client-only mods do not get installed server-side.

Recommendation:

- Do not use the client ZIP as the server mod folder.
- Build a separate server pack after client launch succeeds.

### 2. Aeronautics / Sable

Risk level: high.

Why:

- Sable changes how moving structures and sub-levels behave.
- Aeronautics adds vehicles and physics-like moving structures.
- We are also using Iris, Sodium, Distant Horizons, Colorwheel, and many Create addons.

Test before launch:

- Client launch with shaders off.
- Client launch with shaders on.
- Create one small Aeronautics vehicle.
- Assemble, disassemble, save, reload, and restart.
- Test with 2 players nearby.
- Test interaction with Create contraptions and portable engine fuel.

### 3. Shader stack

Risk level: high.

Included:

- Sodium
- Iris beta build
- Colorwheel
- Distant Horizons
- Create/Flywheel rendering
- Aeronautics/Sable visuals

Impact:

- This is the most likely client-side crash or visual glitch zone.
- Colorwheel helps, but does not prove the stack works.

Test before launch:

- Launch with shaders disabled.
- Launch with Complementary/Reimagined if manually installed.
- Toggle Distant Horizons on and off.
- Visit Create contraptions, Aeronautics vehicles, trains, and oil refineries.

### 4. Oil/refinery overlap

Risk level: medium-high.

Included:

- Create: Diesel Generators
- Create: The Factory Must Grow
- Create: Petrochem
- Create: Liquid Fuel
- TFMG Liquid Fuel Compat
- Create Aeronautics: Portable Engine Liquid Fuel

Impact:

- Great theme fit.
- Possible recipe confusion, duplicate fuels, duplicate oil worldgen, balance weirdness, or JEI clutter.

Test before launch:

- Check JEI for oil/fuel recipes.
- Generate chunks and confirm oil features are sane.
- Build one Diesel Generators refinery line.
- Build one TFMG refinery line.
- Build one Petrochem pumpjack/distillation line.
- Confirm liquid fuels work in blaze burners and Aeronautics portable engines.

### 5. Worldgen stack

Risk level: medium-high.

Included:

- Terralith
- Tectonic
- Lithostitched
- Oritech worldgen
- Petrochem oil/petroleum worldgen
- TFMG oil/resource generation
- Create Ore Excavation

Impact:

- Terrain should look excellent.
- Worldgen has multiple systems now, and it must be tested before the real world starts.

Test before launch:

- Create a new test world.
- Fly 5,000-10,000 blocks in several directions.
- Watch for chunkgen stalls, crashes, broken terrain, and weird resource density.
- Confirm oil resources can actually be found.

### 6. Unofficial / beta-ish mods

Risk level: medium-high.

Watch closely:

- Steam 'n' Rails Neoforge: unofficial 1.21.1 port and alpha filename.
- Create: Track Map unofficial fork: already had dependency metadata warnings earlier.
- Create Railways Navigator: beta filename.
- DragonLib: beta filename.
- Iris: beta filename.
- Particle Rain: beta filename.
- Presence Footsteps: beta filename.
- Simply Light: beta filename.
- ScalableLux: early-looking version.

Impact:

- Not automatic removals.
- These are the likely suspects if client launch or server launch fails.

### 7. Performance stack overlap

Risk level: medium.

Included:

- Sodium
- FerriteCore
- ModernFix
- Entity Culling
- MoreCulling
- ImmediatelyFast
- BadOptimizations
- Alternate Current
- ServerCore
- Smooth Chunk Save
- AI Improvements
- Let Me Despawn
- ScalableLux
- NoisiumForked
- FastSuite/FastWorkbench/FastFurnace
- AllTheLeaks
- Connectivity

Impact:

- Strong performance posture.
- Some overlap is normal, but if rendering glitches occur, check culling/rendering helpers first.

Recommended first suspects for client visual issues:

- MoreCulling
- Entity Culling
- Colorwheel
- Iris
- Distant Horizons
- Sodium

Recommended first suspects for server behavior issues:

- ServerCore
- Let Me Despawn
- AI Improvements
- Alternate Current
- ScalableLux
- NoisiumForked

## Animal / Entity Safety

Let Me Despawn remains included.

Before launch, test:

- Penned passive animals.
- Bred animals.
- Named animals.
- Tamed animals.
- Villagers.
- Mobs holding items.
- Chunk unload/reload.
- Server restart.

## Keep / Remove Recommendation

Do not remove anything yet solely from static review.

The pack is now ambitious, but the risks match the requested identity. The next step should be testing, not guessing.

If launch fails, remove or disable in this order:

1. Shaders/Distant Horizons first, not content mods.
2. Aeronautics/Sable if crashes involve vehicles or rendering.
3. Steam 'n' Rails / Track Map if train map or rail systems crash.
4. Petrochem first if oil/refinery recipes/worldgen are broken.
5. TFMG second if heavy engineering/oil content causes conflicts.
6. Oritech only if worldgen or machine progression causes major issues.

## Required Test Pass

Before calling release candidate:

1. Import the 0.9.6 ZIP into CurseForge.
2. Launch client with no shaderpack.
3. Create a test world.
4. Confirm Create items and ponder screens exist.
5. Confirm JEI opens and searches oil, diesel, petroleum, train, Aeronautics, and Oritech items.
6. Generate terrain for at least 5,000 blocks.
7. Enable shaderpack and test again.
8. Build one Create machine.
9. Build one train.
10. Build one small Aeronautics vehicle.
11. Build one refinery line.
12. Start a dedicated server with a proper server-side mod list.
13. Join with two clients.
14. Restart server and confirm world/entities persist.

## Final Read

The pack is not obviously broken from metadata/export inspection.

The pack is also not safe to launch live without runtime testing. The danger is not the mod count by itself; it is the combination of ambitious Create physics, shaders, worldgen, and overlapping refinery systems.

Best next move: client import test first, then server-side pack split/audit.

## 0.9.7 Addendum

Added after this audit:

- Almost Unified
- Create Deep Seas
- Create: Deep Seas - Lava Fix

Risk update:

- Polymorph was already present for direct crafting-output conflicts.
- Almost Unified adds resource/material recipe unification, useful now that the pack has Oritech, TFMG, Petrochem, Alloyed, and other overlapping industrial materials.
- Create Deep Seas extends the Aeronautics/Sable risk area into submarines and boats. Its CurseForge page marks it alpha/Early Access, so it should be treated as a major test target before launch.

Additional tests:

- Check duplicate ingot/dust/plate behavior in JEI.
- Check Almost Unified does not hide required progression recipes.
- Build one small submarine.
- Test pressure and oxygen.
- Test water/lava sealed-compartment behavior with the lava fix.
- Save, reload, and restart the world with the submarine assembled.

## 0.9.8 Terrain Addendum

Terrain stack changed after this audit:

- Tectonic kept as the terrain-shape layer.
- Middgard added as the biome/forest realism layer.
- Oh The Trees You'll Grow and Treeplacer added as Middgard dependencies.
- Terralith removed to avoid stacking two biome overhaul systems.
- Lithostitched kept for worldgen compatibility and deep-ocean support.

Risk update:

- This is a new-world-affecting change. Do not apply it to an already-started launch world.
- Test fresh world generation again before release candidate.
- Pay special attention to tree density, biome transitions, ocean depth, oil resources, Oritech resources, and chunkgen performance.
