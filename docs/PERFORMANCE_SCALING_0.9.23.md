# Simba Create SMP Performance And Scaling Notes

Date: 2026-07-08

## Current Position

0.9.23 Heavy is at 167 pack entries with 4 bundled shaderpacks.

Do not chase 169 just because there is room. The pack is healthier at 167 than it would be with two filler mods.

The dedicated server remains 0.9.22 with 126 jars.

## Current Server Tuning

- JVM: `-Xms4G`, `-Xmx8G`
- `view-distance=8`
- `simulation-distance=6`
- Dynamic View:
  - view distance range: 6-10
  - simulation distance range: 4-8
  - target average tick time: 45 ms
  - update rate: 60 seconds
- Smooth Chunk Save:
  - chunk save delay: 300 seconds
  - chunk unload limit: 20 per tick
  - protochunk saving disabled
- Tom's Storage multithreading: enabled
- Let Me Despawn: installed and active
- AI Improvements: installed

This is a good controlled baseline for 3-5 players.

## Expected RAM

Server:

- Start with 8 GB max.
- Move to 10 GB only if real testing shows memory pressure with 4-6 players.
- Avoid jumping to 12-16 GB unless there is evidence. Too much heap can create longer garbage collection pauses.

Heavy client:

- Recommended allocation: 8-10 GB.
- Use 10 GB for shaders + Distant Horizons + high render distance.
- Do not allocate all system RAM.

Lite client:

- Recommended allocation: 6-8 GB.
- Use Lite for laptops or players who do not need shaders, ambience, and Distant Horizons.

## Detune Plan

Use this order if performance is rough.

1. Client visuals first:
   - turn off shaders
   - lower Distant Horizons quality/range
   - reduce particle density
   - disable Sound Physics / Presence Footsteps / Particle Rain / Falling Leaves for weak clients
2. Server distances:
   - keep view distance at 8 initially
   - if exploration hurts TPS, lower view distance to 6 and simulation distance to 5
   - keep Dynamic View enabled
3. Chunk loading discipline:
   - avoid permanent chunk-loading of huge factories
   - keep train/station loaders focused
   - do not leave large Aeronautics/Sable builds active in distant unloaded areas until tested
4. Factory discipline:
   - avoid massive exposed item belts where drawers/vaults/depots can reduce entities
   - prefer storage endpoints over loose item piles
   - avoid many constantly running contraptions in one dense town center
5. Only then cut mods:
   - Heavy-only ambience and visuals first
   - Create Nuclear if reactor testing is bad
   - Pipes'n Physics if long refinery/fluid networks misbehave
   - Create Easy Structures / Create Structures if worldgen is ugly
   - Aeronautics/Sable only if it causes real instability

## Scaling Guidance

The pack should scale for a small friend SMP if players build with some discipline:

- spread big builds into districts instead of one mega-chunk town
- use rails for distance, not one overloaded spawn base
- keep farms and contraptions purposeful
- use storage drawers/vaults/backpacks to reduce loose item entities
- pregenerate or slowly explore the world before heavy group sessions

The pack is not designed for 12 players all generating terrain, flying, running shaders, chunk-loading factories, and building Sable vehicles at the same time.

## Professional Pack Judgment

167 is a good stopping point.

The remaining risk is no longer missing client polish. The remaining risk is real-world behavior:

- TPS under 3-5 players
- chunk generation with Tectonic/Terralith/Middgard
- train network behavior
- fluid/refinery networks after restart
- Aeronautics/Sable persistence
- Create Nuclear endgame behavior
- Heavy client shader + Distant Horizons stability

Recommendation: test 0.9.23 clients against the frozen 0.9.22 server before adding anything else.
