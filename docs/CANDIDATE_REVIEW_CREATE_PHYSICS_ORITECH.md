# Candidate Review - Create Physics, Loconautics, Automatics, VS, And Oritech

Date: 2026-07-07
Current main pack: 0.9.3
Current target: Minecraft 1.21.1, NeoForge, Create 6.0.10, CurseForge-compatible ZIP

## Decision Summary

Original review: do not add these directly to the main 0.9.x profile yet.

The pack should track them as high-interest candidates, but they need a separate test profile because they either are not available yet, are beta/unofficial, conflict with the shader stack, or add a second major tech identity beside Create.

Update after group decision:

- Oritech and Simple Conveyor Belts were accepted into the main profile in 0.9.4 as a lighter second tech lane.
- Create Aeronautics, Sable, Aeronautics Compatibility, Steam 'n' Rails Neoforge, and Colorwheel were accepted into the main profile in 0.9.5.
- Valkyrien Skies remains out of the main profile.
- Ferronautics remains skipped.
- Loconautics and Automatics remain watchlist items.

## Loconautics

Status: Watchlist, not added.

Reason:

- Loconautics appears to be unreleased / coming soon rather than available as a stable CurseForge project.
- The nearby available project, Ferronautics, says development is halted and it will be superseded by Loconautics.
- Ferronautics is beta and describes itself as a crude implementation.

Recommendation:

- Do not add Ferronautics to the main pack.
- Re-check Loconautics when it has a public CurseForge release for Minecraft 1.21.1 NeoForge.
- Test it in a separate rail/physics profile before main-pack inclusion.

## Automatics

Status: Watchlist, not added.

Reason:

- Current public references describe Create: Automatics as upcoming / CurseForge soon.
- It appears connected to Create Aeronautics/Sable-style vehicle automation, which is a large physics-system lane rather than simple Create factory content.

Recommendation:

- Do not add until an actual CurseForge project/file is available.
- Test only after Create Aeronautics/Sable compatibility is proven with the pack.

## Valkyrien Skies / VS

Status: Added to main in 0.9.5 after group decision.

Reason:

- The 1.21.1 NeoForge option found is an unofficial port.
- The port explicitly says it is completely incompatible with Oculus/Iris shaders.
- Simba Create SMP currently uses Sodium + Iris + Distant Horizons as the visual stack.
- VS-style physics changes the entire server stability profile and should not enter the main pack without isolated testing.

Recommendation:

- Make a separate `Simba Create SMP - VS Test` profile if Martin wants blimps/ships.
- Do not mix VS unofficial NeoForge port into the main shader/profile build yet.

## Create Aeronautics

Status: Test profile only, not added to main.

Reason:

- Earlier pack rule said not to add Aeronautics to the main profile.
- It is now available for 1.21.1 NeoForge, but it lists visual issues with Iris Shaders.
- It requires Sable and becomes a major vehicle/physics direction.

Recommendation:

- Keep Valkyrien Skies out of the main profile.
- Test Aeronautics with shaders and without shaders before live launch.
- If Aeronautics causes shader issues, disable shader use near Sable contraptions first before removing the mod.

## Rearth - Oritech

Status: Added to main in 0.9.4 after group decision.

Reason:

- Oritech is available for 1.21.1 NeoForge and is mature enough to consider.
- It adds a full separate tech progression: machines, worldgen, quarries, electric tools/armor, pipes, drones, lasers, cybernetics, particle accelerators, and more.
- That is cool, but it competes with the pack identity of Create-first infrastructure.
- It may add worldgen and progression weight that should be decided before the world is started.

Recommendation:

- Group approved this as a lighter second tech identity than Mekanism.
- Test in a throwaway world before final launch.
- Because it adds worldgen/progression content, keep it in before the real server world begins rather than adding later.

## Rearth - Simple Conveyor Belts

Status: Added to main in 0.9.4 after group decision.

Reason:

- Simple Conveyor Belts is available for 1.21.1 NeoForge.
- It is thematically lighter than Oritech and could be useful for factory routing.
- It still overlaps with Create belts and is marked beta, so it should be tested for item behavior, server TPS, and player taste.

Recommendation:

- This is the safest Rearth candidate.
- Test that it does not undermine Create belt builds.

## Main Pack Recommendation

For main 0.9.x / 1.0 after 0.9.5:

- Do not add Loconautics yet.
- Do not add Automatics yet.
- Do not add VS yet.
- Keep Create Aeronautics, Sable, Aeronautics Compatibility, Oritech, and Simple Conveyor Belts in the testable main candidate.
- Keep Ferronautics skipped unless Loconautics fails to materialize and the group specifically wants to test a halted beta.

Best next move:

- Finish the client-polish wave first: maps, dark UI, keybind/config comfort.
- Then run real client/server launch tests, especially shaders plus Aeronautics/Sable.

## 0.9.6 Oil Refinery Update

The main profile now includes the full intended Create oil/refinery lane:

- Create: Diesel Generators
- Create: The Factory Must Grow
- Create: Liquid Fuel
- TFMG Liquid Fuel Compat
- Create Aeronautics: Portable Engine Liquid Fuel
- Create: Petrochem
- Create: Alloyed

This is very on-theme for fuel depots, refinery districts, tank farms, rail fuel logistics, and factory power, but it must be tested because several mods provide overlapping oil and fuel systems.
