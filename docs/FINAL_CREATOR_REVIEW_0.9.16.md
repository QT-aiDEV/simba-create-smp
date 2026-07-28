# Final Creator Review 0.9.16

Date: 2026-07-08

## Verdict

Simba Create SMP 0.9.16 is coherent and close to group-test ready, but I would not call it a polished release candidate until the log noise and final server sync are cleaned up.

The pack identity is strong: Create-first rail-town infrastructure SMP with huge terrain, depots, factories, oil/power systems, storage rooms, shared towns, and optional Heavy/Lite client experiences. The current mod choices mostly support that identity.

## Current Counts

- Heavy-main client entries: 137
- Lite client entries: 125
- Server pack entries: 112
- Dedicated server jars in the C: working server: 112
- Dedicated server jars in the D: final server folder: 102

## Strong Parts

- The Heavy/Lite split makes sense. Heavy is the visual/vibe profile; Lite is close to the server plus practical client comfort.
- The server/client split is clean. No client-only Iris/Sodium/Distant Horizons style mods are in the server pack source.
- The core Create lane is excellent: Create, Steam 'n' Rails, Diesel Generators, TFMG, Petrochem, Power Grid, New Age, Crafts & Additions, Ore Excavation, Mechanical Extruder, Power Loader, Deep Seas, Aeronautics, Tracks+, and the Aeronautics addon wave.
- QoL is good: JEI, Jade, Polymorph, Tom's Storage, Storage Drawers, Sophisticated Backpacks, Iron Chests, Ultimine, Building Gadgets, Visual Workbench, Crafting Tweaks, Mouse Tweaks, Inventory Essentials, TrashSlot.
- Server foundation is good: FTB Teams, Chunks, Essentials, Ranks, Backups, GriefLogger, Spark, Chunky, ServerCore, Dynamic View, Connectivity, ModernFix, FerriteCore, Smooth Chunk Save.

## Launch Blockers

1. Sync the D: live server folder before hosting.
   - C: working server has 112 jars.
   - D: final server has 102 jars.
   - Hosting from D: right now would not match the 0.9.16 client exports.

2. Update internal packwiz versions before final export.
   - Heavy ZIP filename is 0.9.16, but `client/packwiz-client/pack.toml` still says `0.9.12-heavy`.
   - Lite ZIP filename is 0.9.16, but `client/packwiz-lite/pack.toml` still says `0.9.12-lite`.
   - Server pack still says `0.9.14-server-config`.

3. Clean up repeated datapack/recipe/loot errors.
   - Latest boot had 610 ERROR lines and 175 WARN lines.
   - The server boots, but this is too noisy for a confident long-running test server.

## Main Technical Risks

### Datapack Noise

Repeated missing registry/loot errors come mostly from optional compat data:

- `dndecor:*` missing blocks/items
- `railways:*` optional tracks for mods not installed
- `create_connected:*` optional dye catalyst entries
- `midgard:*` sign/malachite entries
- `createcasing:*` slicer entries
- `gearbox:*` test recipes from Petrochem/industrial recipe data
- `createdeco:placard`
- `createqol:superheated_lava`

These did not block boot, but they make real problems harder to see. Fixing or filtering these should be a hardening task.

### AllTheLeaks

AllTheLeaks is currently not fully clean:

- It fails to instantiate a Supplementaries-related fix because `ColoredMapHandler` is not present.
- It reports a stuck thread during shutdown, even after the server saves cleanly.

Recommendation: either update/verify AllTheLeaks against the exact Supplementaries version, disable the broken Supplementaries issue if configurable, or remove AllTheLeaks if it keeps producing false-positive shutdown warnings.

### Aeronautics/Sable Stack

The Aeronautics stack boots now, but it remains the highest-risk gameplay system because it adds physics, sub-levels, extra dimensions/test levels, and unusual contraption behavior. It needs an in-world multiplayer stress test, not just a boot test.

Test specifically:

- Build and save a small airship.
- Fly, land, disassemble/reassemble.
- Restart server with the ship loaded and unloaded.
- Check shader users and non-shader users.
- Check trains and Aeronautics contraptions near chunk borders.

### Chunk Loading Policy

FTB Chunks and Create Power Loader can both keep chunks active. The current config is conservative for FTB Chunks, but Power Loader still needs a server policy.

Recommendation:

- Use FTB Chunks for ordinary base claims and limited offline force-loads.
- Use Create Power Loader only for train/contraption infrastructure where it is actually needed.
- Watch total forced chunks during group testing.

## Recommended Missing Addons

### Add Soon

Create: Central Kitchen

This is the biggest "why don't we have this yet?" addon. The pack already has Farmer's Delight and a huge Create automation focus. Central Kitchen connects Farmer's Delight to Create automation through saws, deployers, mechanical arms, cooking support, boiler/heater interactions, and feast handling. It fits the pack perfectly and should be tested for 0.9.17.

Create: Pattern Schematics

This is highly on-theme for rail-town infrastructure. It supports repeated Create schematic construction from contraptions, trains, and gantries. It is not mandatory for launch, but it could make large rail/build projects much better.

### Consider Carefully

Every Compat

This would improve wood-set consistency across Farmer's Delight, Macaw's, Supplementaries, and other decorative mods. It also adds a lot of generated blocks/recipes. It is a good polish mod, but only if the team actually cares about complete wood palettes.

Create: Schematic Checker

Potentially useful for a Create-heavy build server, especially with many addons. Test separately before adding.

## Do Not Add Blindly

- Create Stuff & Additions: fun, but flying/mobility gear changes balance.
- Create Sifting: overlaps Ore Excavation and Mechanical Extruder resource generation.
- Create Numismatics: good shop mod, but recently adjacent to the Delivery Required/KubeJS failure path.
- Dreams & Desires: broad mixed addon; needs its own test pass.
- Extra chunkloader mods: not needed with FTB Chunks and Create Power Loader.
- Extra terrain/biome stacks: not needed. Tectonic + Middgard + current tree/world support is enough.

## Final Recommendation

Ready for controlled group testing after hardening, not ready for a public-style release.

Minimum before first live test:

1. Sync C: working server to D: final server.
2. Update packwiz version strings to 0.9.16 or 0.9.17.
3. Fix or document the noisy datapack errors.
4. Run one real client join test with Heavy and one with Lite.
5. Run one 30-60 minute server session with trains, storage, Create machines, chunk loading, and at least one Aeronautics build.

Best next build: 0.9.17 hardening + Create: Central Kitchen test.
