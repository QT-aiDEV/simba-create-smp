# Create Aeronautics: Transmission & Linkage restore trace

## Current finding

- The production-facing pack is unchanged; no D: server sync or staging was performed.
- The archived server logs do not show Transmission & Linkage as the root cause. The nearby failures were KubeJS duplicate `ProcessingOutput` registration, Create New Age's CC Tweaked requirement, and a missing Create Structure dependency.
- The addon is present in the old C: dedicated test install and reaches normal mod discovery with Create 6.0.10, Aeronautics 1.3.0, Sable 2.0.3, and Sodium 0.8.12.
- The client-side risk is real: the addon registers `BlockRenderDispatcherMixin`. Version 0.2.4 and 0.2.5 also add a Sable-2.0-specific `SwivelBearingBlockEntityAccessorSable20` mixin.

## Candidate matrix

| Candidate | What changed | Expected value | Status |
|---|---|---|---|
| 0.2.5 | Current latest; Sable-2.0 mixin | Best feature set, highest regression risk | Hold |
| 0.2.4 | Same Sable-2.0 path, earlier build | First compatibility rollback to try | Candidate |
| 0.2.3 | No Sable-2.0-specific accessor | Useful rollback if the Sable mixin is the trigger; may predate Sable 2.0 behavior | Candidate |
| 0.2.2 and older | Earlier implementation and content | Last-resort compatibility fallback; likely missing later fixes/content | Not preferred |

## Test order before re-adding

1. Client with 0.2.4, current Aeronautics/Sable, and Iris disabled.
2. If stable, repeat with Iris enabled.
3. If unstable, repeat the same two checks with 0.2.3.
4. Only after a clean client boot, menu load, single-player test world, and multiplayer join should the chosen version be added to all three pack manifests.

The addon is explicitly a client-and-server NeoForge 1.21.1 project. Its advertised parts include universal joints, hydraulic rods, pneumatic regulators, and kinetic conversion bearings. CurseForge lists 0.2.4 as compatible with the latest Aeronautics and Sable 2.0.0, while 0.2.3 predates that Sable-specific compatibility change.

Sources: https://www.curseforge.com/minecraft/mc-mods/create-aeronautics-transmission-linkage/files/8242757, https://www.curseforge.com/minecraft/mc-mods/create-aeronautics-transmission-linkage/files/8160951, https://www.curseforge.com/minecraft/mc-mods/create-aeronautics
