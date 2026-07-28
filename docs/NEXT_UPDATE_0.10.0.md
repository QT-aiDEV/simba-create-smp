# Simba Create SMP 0.10.0 - Map Lock Update

Prepared on 2026-07-11. This release is staged in the C: workspace only. Do not sync it to the D: production server until players are offline and the current world has been archived.

## Group-chat priorities completed

1. Restored Create Aeronautics: Transmission & Linkage 0.2.4 in Heavy, Lite, and Server for the final player test build.
2. Restored CC: Tweaked 1.120.0 as an override in all three packs.
3. Added Torchmaster for Mega Torches and base spawn control.
4. Added Comforts for sleeping bags and hammocks.
5. Added Curios API.
6. Added the pinned JEI 19.27.0.338 build to Server so server-backed recipe transfer/autocrafting has matching JEI support.
7. Added Corail Tombstone as the death-recovery system. Graves do not decay, item loss is disabled, XP loss is reduced to 50%, and Tombstone's enchanting/event/guardian layer is disabled to keep the pack tech-focused.
8. Kept Middgard, Oh The Trees You'll Grow, Treeplacer, Tectonic, and Lithostitched for continuity with the established map. Terralith is not included. Added FallingTree with tool-required whole-tree felling.
9. The custom Middgard trees remain by group choice; FallingTree provides the requested whole-tree harvesting behavior.
10. Retained the established Heavy/Lite performance split and the server distance, chunk-save, pregeneration, profiling, and watchdog tooling.
11. Kept Stock Market and BankSystem on proven versions 1.3.1 and 1.4.1. Their 2.0.2 updates caused a server-start item-indexing hang and are now pinned out.
12. This is a map-preserving update. Back up the established world before deployment and use a clean client profile when importing 0.10.0.
13. Added Create: Quality Of Life 1.6.3-fix1 across Heavy, Lite, and Server. It supports the pack's Create 6.0.10 build and satisfies Portable Engine Liquid Fuel's optional Create QoL integration.
14. Added BlueMap 5.7 to Server only. It serves high-resolution 3D maps for all three vanilla dimensions on TCP 8100, scans Create and other mod resources automatically, shows friendly-server player markers, and pauses render work whenever a player is online.
15. Completed Scott's requested building, UI, Create, transport, and zombie waves. All selected server components reached ready state together; Simple Voice Chat bound UDP 24454 and BlueMap completed the expanded resource bake.

## Compatible mod update pass

Updated compatible 1.21.1 files for Aeronautics Compatibility, Aeroworks, Aeronautics Toolgun, TFMG, Create Structures, Vibrant Vaults, Bits 'n Bobs, Balm, Sophisticated Core/Backpacks, Entity Culling, Crafting Tweaks, Distant Horizons, Colorwheel, and Xaero's Minimap where present in each profile.

Held/pinned for compatibility:

- JEI 19.27.0.338 while Petrolpark 1.4.36 is present.
- CC: Tweaked 1.120.0 for Create New Age.
- Create: Enchantment Industry 2.4.2; the offered update is a preview alpha.
- BankSystem 1.4.1 and Stock Market 1.3.1; 2.0.2 hangs the server while indexing modded item data.

## Deployment checklist (later, when players are offline)

1. Stop the D: server cleanly and confirm no Java process is using its server ports.
2. Archive the complete current world, `local`, `database.db`, player/admin lists, configs, and latest logs.
3. Sync the validated 0.10.0 server pack and dedicated-server files.
4. Keep the established world in place after its backup; do not generate a replacement world for this update.
5. Confirm a clean ready state, then stop once and verify a clean restart.
6. In-game, use `/StockMarket ManagementGUI` to add the chosen economy items and set rarity, price, volatility, and trade speed. Save settings after each batch.
7. Pregenerate the agreed world radius with Chunky before opening the server.
8. Test graves, sleeping bags, Mega Torches, Carry On, FallingTree, JEI recipe transfer, CC computers, ships/submarines, and Stock Market permissions with a non-op account.
9. Confirm router/firewall TCP 8100 reaches the server, allow BlueMap's initial resource scan and render to finish while the server is empty, then verify Create blocks and custom trees visually in the web map.

## Known non-blocking noise

Existing optional compatibility recipes, loot tables, and advancements from several Create add-ons still log missing optional-mod references. They were present before this update and do not prevent the isolated server from reaching ready state.
