# Simba Create SMP 0.12.1

**Release type:** Beta  
**Minecraft:** 1.21.1 NeoForge  
**Profiles:** Heavy, Lite, and Server

## Added

- **The Roads More Travelled** on Heavy, Lite, and Server. Frequently travelled terrain gradually develops visible paths, including in the existing world from the time of update onward.
- **Petting** with a survival-safe tame profile: six pets per player, a kill plus 50%-health requirement, 20% base tame chance, saddle-required mounts, and boss/raid-mob exclusions.
- **Extreme Sound Muffler** on Heavy and Lite for individual sound-event volume and mute control.
- **Dark Mode Everywhere** on Heavy and Lite, bringing dark UI treatment to bright mod screens such as Tom's Simple Storage and Iron Chests.
- **Simba Chat Format** resource pack, changing normal chat to `Name: message` while preserving FTB Ranks name styling.
- First-run **Default Options** resource-pack defaults for fresh installs.

## Changed

- FallingTree now supports large mixed-log custom trees, with whole-tree detection and 2,048-block scan/fell limits.
- Undead Nights is now built for slow, dense, readable horde combat:
  - Horde, Elite, and Demolition zombies: **40 → 24 HP**.
  - Movement speed: **40% slower** than their previous setting.
  - Horde mobs no longer stack into wall- or fence-scaling piles.
  - Surviving horde mobs burn in daylight.
  - Lure effects remain atmospheric but cannot summon surprise hordes.
  - Horde size, variety, warnings, and scheduled siege nights remain intact.
- Server autosave is staged at **15 minutes** rather than 5, reducing repeatable save hitches while normal saves and the FTB backup schedule remain in place.
- The Simba title on the main menu is now static; the animated background remains.
- Client exports contain only the first-run resource-pack baseline, Simba UI art, and the skin compatibility fix. Personal settings and server/world rules are no longer overwritten on updates.

## Removed

- Forced `options.txt` deployment. Updates no longer reset player controls, video settings, keybinds, accessibility options, or chosen resource packs.
- Forced `servers.dat` deployment. Fresh installs start with an empty server list, and existing players keep their own entries.
- Client copies of server/world tuning and personal shader, FPS, shield, and gameplay configs. Fresh installs generate their own local preferences; multiplayer rules remain server-authoritative.

## Server Notes

- **0.12.1 requires the matching server update** because TRMT, FallingTree, and Undead Nights are server-authoritative.
- Back up the world before first boot with TRMT. If TRMT is ever removed, run its documented conversion command on loaded chunks first.
- Dynamic Undead Nights scaling deliberately remains off; the staged profile uses predictable fixed values instead.
