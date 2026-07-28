# Simba Create SMP 0.9.27 Branding And Social Art Pass

0.9.27 makes the pack feel like a real shared group build instead of a pile of mods.

## Art Direction

The original Simba photos were used only as visual reference. They were not copied into the repo as raw source photos.

Generated and processed pack assets now live in:

- `art/simba-branding/pack.png`
- `art/simba-branding/server-icon.png`
- `art/simba-branding/simba-create-smp-app-icon-512.png`
- `art/simba-branding/simba-main-menu-1920x1080.jpg`
- `art/simba-branding/simba-main-menu-1920x1080.png`
- `art/simba-branding/Simba Create SMP Branding.zip`

## Client Branding

Both Heavy-main and Lite now include:

- `pack.png`
- `resourcepacks/Simba Create SMP Branding.zip`
- `options.txt` set to load the branding resource pack by default

The branding resource pack replaces the vanilla title panorama with Simba Create SMP themed art. This avoids adding FancyMenu or a heavier menu customization stack before group testing.

## Server Branding

The generated server icon was copied to:

- `server/packwiz-server/server-icon.png`
- `server/dedicated/server-icon.png`
- `D:/@MineCraft Server {Modded}/@Simba/server/dedicated/server-icon.png`

## Immersive Paintings

Added Immersive Paintings so the group can share art, screenshots, signs, posters, town notices, factory labels, and dumb friend-server memories inside the world.

Added to:

- Heavy-main
- Lite
- Server

Dependency:

- Fzzy Config

## Exports

- Heavy-main: `exports/Simba Create SMP-0.9.27-Heavy-CurseForge.zip`
- Lite: `exports/Simba Create SMP-0.9.27-Lite-CurseForge.zip`

## Counts

- Heavy-main pack entries: 171
- Lite pack entries: 150
- Server pack entries: 129
- D: dedicated server jars: 129

## Verification

- Heavy and Lite ZIPs contain `manifest.json`
- Heavy and Lite ZIPs contain `overrides/pack.png`
- Heavy and Lite ZIPs contain `overrides/resourcepacks/Simba Create SMP Branding.zip`
- Heavy and Lite ZIPs contain Immersive Paintings and Fzzy Config
- Heavy contains 4 shaderpacks
- Lite contains 0 shaderpacks
- D: dedicated server boot test passed with 129 jars
- No Simba Java server process was left running after the test

## Notes

The branding resource pack is intentionally simple and low-risk. A full custom FancyMenu/Drippy stack can still happen later, but it should be tested as its own UI pass.

The generated art and bundled Modrinth files are fine for private friend testing. Public CurseForge publication still needs a final license and external-file policy review.

