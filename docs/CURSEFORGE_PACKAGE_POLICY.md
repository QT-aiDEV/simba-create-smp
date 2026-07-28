# Simba CurseForge Package Policy

## Standard Layout

Every published ZIP contains only `manifest.json`, packwiz's human-readable `modlist.html`, and `overrides/`. CurseForge-hosted projects belong in the manifest. Overrides are reserved for intentional configs, datapacks, branding, menu assets, pack metadata, and explicitly approved external jars.

## Bundled Exception Allowlist

Only these two jars may appear under `overrides/mods/`:

-- `cc-tweaked-1.21.1-forge-1.120.0.jar` — current required CC:Tweaked build; the author no longer publishes new versions on CurseForge.
-- `radiomod-1.0.2.jar` — Create Live Radio, sourced by pinned Modrinth version and hash.
-- `createautomatics-1.0.1.jar` — Create: Automatics is currently Modrinth-only;
   Apache-2.0 licensed, pinned to its verified upstream hash.
-- `create_bluemap-1.1.1.jar` — server-only BlueMap/Create integration, pinned
   to the official Modrinth build until a CurseForge release is available.

Any third bundled jar is a release-blocking error until it is documented, licensed for redistribution, hash-pinned, and added deliberately.

Create Aeronautics 1.3.0 is CurseForge project `676721`, file `8240058`. Its official file is byte-for-byte identical to the previously bundled jar, so it must remain a normal manifest entry rather than an override exception.

Create:Tracks+ 1.0.5 is CurseForge project `1548863`, file `8169570`. Its official file is byte-for-byte identical to the previously bundled jar and must remain a manifest entry.

## Override Budget

-- Maximum 100 override entries per artifact.
-- Maximum 75 MiB uncompressed override payload.
-- Compatibility resources must remain inside one Paxi datapack ZIP.
-- Generated instance folders, saves, logs, backups, caches, crash reports, account data, and machine-specific files are forbidden.

## Client and Server Separation

Drippy, FancyMenu, Melody, Konkrete, client resource packs, menu assets, and shaders must not appear in the Server artifact. Gameplay configs shared by integrated servers may appear in all profiles.

## Release Gate

Run `scripts/Test-SimbaModpack.ps1` followed by `scripts/Test-SimbaCurseForgePackage.ps1`. A release is not ready if either check fails.
