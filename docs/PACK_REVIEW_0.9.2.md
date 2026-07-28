# Simba Create SMP Pack Review - 0.9.2

## Current State

- Minecraft: 1.21.1
- Loader: NeoForge 21.1.235
- Current source: `packwiz-curseforge-pack`
- Current export: `exports/Simba Create SMP-0.9.3-CurseForge.zip`
- Current manifest entries: 100
- Bundled override mod jars: 0
- Launch tests: not yet run in this environment

## Overall Read

The pack is now a strong Create-first SMP candidate. The core identity is coherent: rail infrastructure, Create engineering, bulk storage, realistic terrain, ambient world feel, and server performance all point in the same direction.

The pack is not drifting into generic tech-pack soup. Avoiding AE2, Refined Storage, Mekanism, Thermal, ProjectE, Waystones, and questing keeps Create as the center of gravity.

## What Is Already Strong

- Create engineering: Create 6.0.10 plus compatible power, decoration, train, and automation addons.
- Rail-town identity: Create Railways Navigator, Track Map, Create Deco, Bells & Whistles, Simply Light, Macaw's Bridges, Rechiseled, FramedBlocks, and Handcrafted all support towns, depots, stations, factories, and utility buildings.
- Storage without bypassing Create: Storage Drawers, Tom's Simple Storage, Iron Chests, and Sophisticated Backpacks give quality of life without turning the pack into AE2 or Refined Storage.
- Multiplayer/server foundation: FTB Teams, FTB Chunks, FTB Ranks, FTB Essentials, FTB Backups 3, Lootr, Chunky, spark, and ServerCore make the pack feel server-ready.
- Performance stack: Sodium, FerriteCore, ModernFix, Entity Culling, ImmediatelyFast, MoreCulling, BadOptimizations, Alternate Current, Smooth Chunk Save, AI Improvements, ScalableLux, NoisiumForked, FastSuite/FastWorkbench/FastFurnace, AllTheLeaks, Connectivity, and Let Me Despawn are a serious pass.
- Atmosphere: AmbientSounds, Sound Physics Remastered, Presence Footsteps, Particle Rain, Falling Leaves, Not Enough Animations, Visual Workbench, Supplementaries, Farmer's Delight, and Handcrafted give the world a lived-in feel without adding survival punishment.

## Main Gaps Before Launch Candidate

- Client navigation: no minimap or full-screen explored-world map yet.
- Dark UI polish: no bundled dark-mode GUI resource pack or dark GUI mod yet.
- Keybind/options comfort: no dedicated keybind search/config polish layer yet.
- First-run defaults: no curated config/defaultconfig pass yet for claims, chunk loading, map rules, shader defaults, Distant Horizons, audio volume, and performance toggles.
- Launch proof: client launch, shader load, test world, Create item check, terrain check, server start, and animal despawn safety tests still need to be run.

## Recommended Next Wave - 1.0 Client Polish

Add only after a backup/export of 0.9.2:

- Xaero's Minimap
- Xaero's World Map
- BetterF3
- Configured
- Catalogue
- Default Dark Mode resource pack
- Default Dark Mode: Expansion resource pack, if it exports cleanly

Optional, test separately:

- Dark Mode Everywhere: useful if resource packs do not cover enough modded screens, but it shader-transforms GUI textures and should be checked with JEI, Jade, FTB menus, Tom's Storage, and Create screens.
- Inventory Profiles Next: powerful client-side inventory QoL, but overlaps with Mouse Tweaks and Inventory Essentials enough that it should be tested by the group before becoming default.
- Legendary Tooltips: nice polish, but more style-heavy than essential and adds dependencies.

## Map Policy Recommendation

Use Xaero's Minimap plus Xaero's World Map rather than JourneyMap for the main profile.

Reasons:

- Lighter daily-driver feel.
- Pairs well as minimap plus full-screen explored map.
- Better fit for a rail/travel SMP than a heavier all-in-one mapping setup.
- Server-side controls can be used to keep teleport disabled and preserve rail travel.

Recommended map rules:

- Allow minimap.
- Allow fullscreen explored map.
- Allow waypoints.
- Disable waypoint teleport.
- Disable cave/entity radar if the group wants a more survival-friendly map.

## Dark Mode Recommendation

Start with Default Dark Mode plus Default Dark Mode: Expansion as resource packs.

This is safer than relying first on a GUI shader transformer. If too many modded screens stay bright, test Dark Mode Everywhere as a follow-up.

## Stability Risks To Watch

- Iris on NeoForge 1.21.1 is still a risk area and must be tested with Sodium, Distant Horizons, and shader loading.
- Create: Track Map is an unofficial fork and already produced dependency metadata warnings during export.
- Presence Footsteps and Particle Rain are atmosphere picks that need real client testing.
- Create: Power Loader overlaps with chunk-loading policy and should be configured carefully.
- Let Me Despawn should stay, but animal/villager retention must be tested before live launch.
- No curated configs are present yet, so the first launch will create defaults rather than using final server rules.

## Animal Safety Test

Before live server:

- Put vanilla passive animals in pens.
- Test bred animals.
- Test named animals.
- Test tamed animals.
- Test villagers.
- Test mobs holding items.
- Leave the area, unload chunks, reload chunks, restart the server, and confirm they remain.

## Long-Term Aging Notes

The pack should age well if future additions stay inside these lanes:

- Create automation and rail infrastructure.
- Industrial building blocks and lighting.
- Storage that does not replace Create logistics.
- Client comfort that does not add gameplay shortcuts.
- Performance and server admin tools that are easy to configure.

Avoid adding:

- Parallel tech ecosystems.
- Teleportation networks.
- Heavy progression/quest systems.
- Extra terrain stacks.
- Multiple overlapping furniture or decoration packs.
- Experimental physics/worldgen/threading mods directly into the main profile.

## Verdict

Current 0.9.2 is ready for a client-polish wave, not yet ready for a live test server.

The next best move is a small 1.0 client polish pass focused on maps, dark UI, config menus, and first-run defaults. After that, run the actual launch tests and only then call it a release candidate.

## 0.9.3 Update Note

Create: Electro Energetics was added after this review to complete the George_VI power-grid set alongside Create: Diesel Generators. This improves the electrical infrastructure theme, especially for towns, rail corridors, substations, factories, and long-distance power transmission.
