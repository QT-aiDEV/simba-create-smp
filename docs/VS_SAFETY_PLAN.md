# VS / Blimps Safety Plan

Goal: give Martin a path to blimps/ships without risking the main Simba Create SMP pack.

## Main Decision

Do not add Valkyrien Skies, Eureka, Clockwork, Loconautics, or Automatics directly to the main 0.9.x pack.

Reason: the main pack uses Sodium + Iris + Distant Horizons, and the available 1.21.1 NeoForge VS path is unofficial and shader-risky. This is exactly the kind of system that should be isolated first.

Create Aeronautics and Sable were accepted into the main pack in 0.9.5 because the group preferred all-Create vehicles over VS physics. They still require shader and server testing.

## Safe Test Path

Create a separate optional profile later:

- Name: `Simba Create SMP - Martin VS Test`
- Base: copy of the current pack after the client-polish wave
- Shaders: disabled for the first test pass
- Distant Horizons: disabled for the first test pass
- Terrain: use a throwaway test world, not the launch world
- Server: test with 2 players before adding to the real server

## Test Order

1. Confirm the copied pack launches without VS changes.
2. Add the minimum VS stack only.
3. Launch client with shaders off.
4. Create a throwaway world.
5. Build one small ship/blimp.
6. Add simple Create contraptions.
7. Test chunk loading, disassembly, server restart, player disconnect/reconnect, and crash recovery.
8. Only after that, test with Iris/shaders if the chosen VS stack claims support.

## Pass Criteria

- No client crash on launch.
- No server crash on launch.
- No crash when assembling/disassembling vehicles.
- No vehicle corruption after restart.
- No severe TPS loss with one active vehicle.
- No shader/DH conflict if visuals are enabled.

## Main-Pack Rule

VS can become a main-pack candidate only if the test profile survives real play. Until then, the main CurseForge ZIP stays rail-town stable.
