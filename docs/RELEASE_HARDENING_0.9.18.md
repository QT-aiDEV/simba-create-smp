# Release Hardening 0.9.18

Date: 2026-07-08

## Verdict

0.9.18 is the first build I would treat as the serious group-test candidate, with one important caveat: the pack still needs in-world testing for Create fluid networks, Aeronautics/Sable vehicles, and the remaining optional datapack noise.

## What Changed

- Added Create: Central Kitchen.
- Removed AllTheLeaks.
- Updated internal packwiz version labels to 0.9.18.
- Promoted important generated server configs into the server pack source.
- Tightened FTB Ultimine so it requires proper tools and avoids tool breakage.
- Enabled FTB Backups 3 backup-on-shutdown.
- Enabled ServerCore unloaded-chunk movement protection.
- Synced the D: final server folder to the current C: working build without touching the world folder.

## Why Central Kitchen

Central Kitchen is the correct missing Create glue for this pack. The pack already has Farmer's Delight and a Create-first identity, so food automation belongs here more than another broad tech or furniture addon.

## Why AllTheLeaks Was Removed

AllTheLeaks was not failing the server, but it made the logs less trustworthy:

- It threw a Supplementaries constructor/class error.
- It reported stuck-thread shutdown warnings after clean saves.

For a release candidate, clean signal matters more than a speculative memory helper.

## Current Counts

- Heavy-main client entries: 139
- Lite client entries: 127
- Server pack entries: 114
- C: working server jars: 114
- D: final server jars: 114

## Verified

- Heavy export contains `manifest.json` and `overrides/`.
- Lite export contains `manifest.json` and `overrides/`.
- C: working dedicated server boots and stops cleanly.
- D: final dedicated server boots and stops cleanly.
- Shutdown backups completed on both C: and D: tests.
- D: world folder was not replaced during sync.

## Remaining Risks

- Create: Pipes'n Physics must be tested with TFMG, Petrochem, Diesel Generators, long horizontal pipe runs, vertical lift runs, and restart persistence.
- Aeronautics/Sable must be tested in a real multiplayer world with saved/reloaded vehicles.
- Optional compat recipe/loot noise remains in logs, mostly from rail/decor/worldgen generated data.
- Client-side Heavy still needs a real shader test with Scott/Martin-style hardware differences.

## Recommendation

Use 0.9.18 for controlled group testing. Do not keep expanding until the team has completed a real in-world test session covering fluids, trains, Aeronautics, storage, backups, and client performance.
