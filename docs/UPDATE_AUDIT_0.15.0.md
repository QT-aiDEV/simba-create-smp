# Simba Create SMP 0.15.0 update ecosystem audit

Prepared July 27, 2026 using temporary copies of Heavy, Lite, and Server.
No discovered update in this audit was applied to the real pack sources or production.

## Recommendation

Do not run a blanket Packwiz update. Build 0.15 in controlled waves:

1. Pipes'n Physics 3.0.0 compatibility update.
2. Low-risk patches and client utilities.
3. Coupled library/mod families, one family at a time.
4. Gameplay or physics changes only after isolated boot and in-world tests.

## Keep pinned or reject

- JEI stays at 19.27.0.338 while Petrolpark 1.4.36 is installed.
- Sophisticated Core stays at 1.4.69.2125 and Sophisticated Backpacks at
  3.25.68.1971. Newer Core builds previously required JEI 19.32+, conflicting
  with Petrolpark.
- Create: Enchantment Industry, BankSystem, and Stock Market remain pinned.
- Reject Packwiz's Create: New Age `1.2.0 -> 1.1.7c` proposal: it is a downgrade.
- Reject IamMusicPlayer `beta2 -> alpha1` for this release.
- Hold Petting `4.2.2 -> 4.2.3-beta.2`; do not replace a stable build with a beta
  without a specific fix we need.
- Hold Entity Texture Features `6.2.9 -> 7.1`; this is a major-version client
  rendering change and the pack carries an ETF skin-compatibility fix.

## Low-risk first wave

These are patch-level or client/utility updates. Keep Heavy, Lite, and Server
metadata aligned wherever the mod is shared:

- ModernFix 5.27.15 -> 5.27.20
- Crash Assistant 1.11.10 -> 1.11.11
- Default Options 21.1.7 -> 21.1.8
- Balm 21.0.62 -> 21.0.63
- Placebo 9.9.1 -> 9.9.2
- Simple Voice Chat 2.6.20 -> 2.6.21
- Corail Tombstone 9.5.2 -> 9.5.3
- Chat Heads 0.15.2 -> 0.15.3
- Cupboard 3.8 -> 3.9
- Lootr 1.11.37.121 -> 1.11.37.122
- Architectury API 13.0.8 -> 13.0.11
- Fusion 1.3.5 -> 1.3.9
- FancyMenu 3.9.6 -> 3.9.8
- Default Dark Mode Expansion 2026.6.16 -> 2026.7.20
- Xaero's Minimap 26.2.1 -> 26.4.2 and World Map 1.42.0 -> 1.44.2 together
- AstikorCarts Redux 1.2.2 -> 1.2.3

Even this wave still requires Packwiz validation and a client/server boot test.

## Coupled families

Update each family as one unit and test before adding the next family.

### FTB platform

- FTB Library 2101.1.32 -> 2101.1.34
- FTB Chunks 2101.1.20 -> 2101.1.21
- FTB Ranks 2101.1.3 -> 2101.1.4
- FTB Essentials 2101.1.9 -> 2101.1.10
- FTB XMod Compat 21.1.8 -> 21.1.10

Test claims, fake-player Create automation, ranks/chat formatting, commands,
map access, and offline force-loading policy.

### Supplementaries platform

- Moonlight Lib 3.0.22 -> 3.3.0
- Supplementaries 3.7.7 -> 3.8.4

This is a larger library jump. Update together and inspect configs, registries,
recipes, and startup warnings.

### MineColonies platform

- MineColonies 1.1.1346 snapshot -> 1.1.1362 snapshot
- CreateColonies 2.0.5 -> 2.0.6
- StyleColonies 1.15.54 -> 1.15.56

Keep Structurize, BlockUI, Domum Ornamentum, Multi-Piston, TownTalk,
MineColonies Tweaks, and MineColonies Compatibility under review even when
Packwiz reports no update. The older 1.1.1333 MineColonies build previously
crashed this pack, so this family needs an isolated server boot and colony test.

### Gunsmithing platform

- NTGL 3.1.7 -> 3.1.8
- Create: Gunsmithing 1.4.8 -> 1.4.9

Update together. Recheck the pack's disabled block ignition/explosive terrain
damage settings and weapon recipes.

### Create utility patches

- Create Mechanical Extruder 2.2.1 -> 2.2.2
- Create Encased 1.9.0-ht1 -> 1.9.0-ht2
- Create Propulsion: Simulated 1.1.4 -> 1.1.5

Extruder and Encased can be tested as small patches. Propulsion belongs with the
fuel/Aeronautics test lane because Pipes'n Physics 3.0.0 also changes Propulsion
fluid-handler behavior.

## High-risk test lanes

### Aeronautics and Sable addons

- Toolgun 0.2.3 -> 0.3.2
- Gadgets & Gizmos 1.0.6 -> 1.1.2
- Shield Generators 1.3.0 -> 1.4.0
- Transmission & Linkage 0.2.4 -> 0.2.5
- Create Propulsion: Simulated 1.1.4 -> 1.1.5

Do not scatter these into the safe wave. Test craft assembly, saved toolgun
blueprints, sub-level loading, fluid engines, shield behavior, chunk borders,
server restart persistence, and client rendering.

### Refinery and industrial gameplay

- Create: Petrochem 1.2.1 -> 1.3.0
- Oritech 1.2.8 -> 1.2.9

Oritech is a small patch but touches a worldgen/machine lane. Petrochem is a
feature-version upgrade in the same oil ecosystem being changed by Pipes'n
Physics. Test TFMG, Petrochem, Diesel Generators, portable engines, recipes,
fluids, and existing refinery blocks before accepting it.

### Combat and storage behavior

- Better Combat 2.3.2 -> 2.4.0
- Tom's Simple Storage 2.3.2 -> 2.4.1
- Carry On 2.2.5.8 -> 2.2.6.13
- Treeplacer 2.1.0 -> 2.2.0

These are not dependency emergencies. They change player controls, inventories,
block movement, or world interaction and should wait until the essential 0.15
fluid fix is proven.

## Petrolpark 1.5 migration

Packwiz offers Petrolpark Library 1.5.0, but it is a beta feature-version jump.
Hold it for a dedicated migration pass covering Petrol's Parts, Protection
Pixel, Create: Enchantment Industry, JEI, loot modifiers, and every other
Petrolpark consumer. Do not unpin JEI or Sophisticated Core merely because a new
Petrolpark build exists; verify jar dependency ranges and boot the complete
consumer set first.

## Isolation results — July 27, 2026

- Accepted the compatible update set in Heavy, Lite, and Server and refreshed
  all three Packwiz indexes.
- Rejected and pinned Architectury API 13.0.11. It reproducibly caused
  `Feature order cycle found` for `minecraft:dripstone_caves` during fresh-world
  spawn generation.
- Confirmed the Architectury result by restoring every other intended update
  (including Oritech 1.2.9, Petrochem 1.3.0, Treeplacer 2.2.0, Moonlight 3.3.0,
  and Supplementaries 3.8.4) while retaining Architectury 13.0.8. The isolated
  server then generated a new world and reached `Done (93.300s)`.
- Rejected and pinned MineColonies 1.1.1362 after repeated Create QOL
  `Cannot get config value before config is loaded` errors. Retained the proven
  1.1.1346 snapshot while accepting CreateColonies 2.0.6 and StyleColonies
  1.15.56.
- Observed a non-fatal Propulsion/Gadgets & Gizmos mixin warning during boot.
  Aircraft and propulsion gameplay remain a required manual test lane.
- `Test-SimbaModpack.ps1` passes for Heavy, Lite, and Server.
- No production files were changed.
