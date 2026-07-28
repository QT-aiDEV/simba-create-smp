# Simba Create SMP 0.15.0 — Pipes'n Physics compatibility update

Prepared July 27, 2026 in the C: lab workspace only. Production D: has not been changed.

## Planned change

- Update Create: Pipes'n Physics from 2.1.1 to 3.0.0 in Heavy, Lite, and Server.
- Take the upstream Create: Diesel Generators fix for fillable distillation tower inputs.
- Keep `pipeVolumePerCell = 0` for the first rollout. This retains legacy instant-transfer
  pipes and avoids introducing retained/mixed pipe contents into existing brewery lines.
- Keep `enablePumpSelfPriming = true` so existing dry suction lines continue to prime.

## Why the conservative configuration

Pipes'n Physics 3.0.0 normally gives every pipe block 250 mB of real storage. The upstream
release notes warn that networks behave differently, mixed fluids can break pipes, and dry
suction lines no longer self-prime by default. Those are meaningful migration risks for the
existing brewery and other multi-fluid builds.

Setting pipe storage to zero is an upstream-supported compatibility mode. It lets 0.15.0
adopt the endpoint fixes first. The full stored-fluid simulation can be enabled later after
purpose-built testing and any needed rebuilds.

## Required lab checks before production

1. Confirm oil can enter Create: Diesel Generators distillation tower inputs and the refinery
   completes a normal production cycle.
2. Run each Brewin' and Chewin' keg recipe that shares water/output plumbing. Confirm smart
   fluid pipe filters select the intended product and pipes do not break.
3. Restart the lab server with both facilities loaded and repeat both tests.
4. Check the log for Pipes'n Physics exceptions, broken fluid capabilities, and server tick
   regressions.
5. Do not sync or deploy to D: until these checks pass and the production world is archived.

## Dependency update pass

The 0.15 lab candidate also takes the compatible updates recorded in
`UPDATE_AUDIT_0.15.0.md`, including the Xaero maps, FTB suite, Supplementaries
and Moonlight, Petrochem, Oritech, the coordinated Gunsmithing pair, and the
tested Aeronautics/Create addon patches.

Architectury API remains pinned at 13.0.8. Version 13.0.11 reproducibly caused a
NeoForge feature-order cycle in `minecraft:dripstone_caves` while generating a
new world. With every other intended 0.15 update installed and only Architectury
rolled back, the isolated server generated a fresh spawn and reached
`Done (93.300s)`.

MineColonies remains pinned at 1.1.1346. The offered 1.1.1362 snapshot produced
Create QOL config-access errors during equipment-tier initialization.

This is still a lab candidate. Oil/refinery, brewery filtering, colony, aircraft,
combat, and storage gameplay checks remain required before production.

## Production deployment

Deployed July 27, 2026 after creating and verifying the rollback snapshot
`0.15.0-predeploy-20260727-214515`. The snapshot contains the complete 13.405 GiB
world, configs, mods, permissions, server settings, and economy database.

The production installer validated all 272 managed entries. Two CurseForge
publisher-restricted files were downloaded from their official file endpoints
and verified against the Packwiz SHA-1 metadata. Superseded CreateColonies 2.0.5
and Shield Generators 1.3.0 jars were removed after confirming their backup
copies.

Production reached `Done (9.125s)` on port 25565. Voice chat started on UDP
24454, BlueMap started on TCP 8100, and no post-ready errors were logged.
