# Simba Create SMP 0.9.22 Release Freeze

Date: 2026-07-08

## Decision

0.9.22 is the feature-freeze build for group testing.

Do not add more server-side gameplay systems before the first group test unless the change is a bugfix, missing dependency, or direct stability fix.

## Profile Intent

- Heavy-main: full visual/client experience. Shaders, ambience, camera feel, particles, sounds, Distant Horizons, and client comfort mods belong here.
- Lite: close to the server with only practical QoL/performance/client essentials. No fancy ambience stack.
- Server: shared gameplay, worldgen, automation, storage, admin, protection, performance, and logging only.

Current counts:

- Heavy-main: 152 pack entries
- Lite: 140 pack entries
- Server pack: 126 entries
- Final D: dedicated server: 126 jars

## Not Adding Before Group Test

- Tinkers' Construct: not cleanly available for our Minecraft 1.21.1 NeoForge target.
- Silent Gear: good candidate later, but it adds a whole parallel gear progression.
- Tetra / Simply Swords: useful in other packs, but not needed before lock.
- Railways Untold: cool but too invasive for the current realistic terrain and player-built rail network goal.
- AI town / colony / settlement systems: hold. They add worldgen, entity, balance, and maintenance risk and may make the world feel generated instead of player-built.
- More terrain/biome stacks: hold. Tectonic, Terralith, Lithostitched, and Middgard are already the terrain direction.

## Why We Are Freezing

The pack already has the core identity covered:

- Create 6.0.10 engineering
- Trains, stations, track mapping, navigation, lights, and station utilities
- Aeronautics, propulsion, Deep Seas, jetpack, and personal transport
- Oil/refinery/fuels, Create Nuclear, Create New Age, Power Grid, Electro Energetics
- Concrete/stone/industrial building blocks, copycat/framed building tools, storage, backpacks, drawers, Tom's Storage
- Server admin, teams, chunks, backups, ranks, claims, grief logging
- Heavy visual pass and Lite fallback profile

At this point, more systems are more likely to increase hidden maintenance work than improve the launch test.

## Current Watchlist

These did not block the D: dedicated server boot test, but they should be watched during group testing.

- Steam 'n' Rails: logs many optional loot table errors for track variants tied to mods we do not have. Keep for now because it is central to the rail-town identity.
- Create: Design n' Decor: logs many optional loot table errors for missing colored/variant blocks. Keep for now because it supports the industrial build palette.
- Create Industry / Gearbox data: logs test recipe parsing errors. Keep for now, but verify its intended machines/recipes in-game.
- Middgard: logs two malachite recipe/item errors. Keep for now because the user specifically wanted Middgard terrain, but watch for missing content.
- Create Train Utilities: logs three failed advancements. Recipes loaded and server booted, so this is log noise, not a boot blocker.
- Create Easy Structures: logs missing `create_easy_structures:undergroundtrain_station` template pool references during spawn generation. Watch structure generation while exploring.
- Petrolpark / Petrol's Parts: logs one loot modifier warning and dedicated-server client-class mixin noise. Boot passed.
- Create Propulsion: logs ignored fuel overrides for mods we do not have. This is expected optional compatibility noise.
- Spark: may log a shutdown-only `RejectedExecutionException` after the watchdog sends stop. This is not a running-server failure.

Latest D: boot test:

- Passed watchdog self-test.
- Ready line: `Done (15.731s)! For help, type "help"`
- ModernFix reported total dedicated-server load around 78 seconds.

## Cut Order If Group Test Performs Poorly

Use this order if we need to slim down after real player testing.

1. Heavy-only visuals first for laptop players: Particle Rain, Falling Leaves, Sound Physics, Presence Footsteps, AmbientSounds, Distant Horizons, Not Enough Animations.
2. Experimental endgame lanes next: Create Nuclear if reactor/worldgen testing is bad, then Create: Pipes'n Physics if long fluid networks misbehave.
3. Worldgen/structure polish next: Create: Easy Structures / Create: Structures if exploration logs or chunkgen performance are ugly.
4. Large transport experiments last: Aeronautics/Sable stack only if it causes real instability, because Martin's transport goal depends on it.
5. Core Create, storage, trains, server admin, backups, claims, and performance mods should be protected.

## Group Test Focus

Test these before calling the pack long-term ready:

- 3-5 players online for at least 60 minutes
- exploring new terrain in different directions
- building a starter town with storage rooms and shared claims
- basic Create contraptions under chunk load
- train route, station, Train Utilities blocks, Train Lights, Track Map, and Railways Navigator
- refinery/oil/fuel fluid networks for 30-60 minutes and after restart
- Aeronautics/Sable contraption creation, parking, unload/reload, and restart
- Create Nuclear ore generation and reactor behavior in a controlled test area
- Heavy profile shader/dynamic light stability
- Lite profile laptop FPS and memory behavior

## Recommendation

0.9.22 is ready for controlled group testing, not final long-term world approval.

The next work should be testing, log review after real play, and targeted cuts/fixes. No more broad feature additions before that first test.
