# Simba Create SMP

[![CurseForge](https://img.shields.io/badge/CurseForge-Simba_Create_SMP-F16436?logo=curseforge&logoColor=white)](https://www.curseforge.com/minecraft/modpacks/simba-create)
[![Minecraft](https://img.shields.io/badge/Minecraft-1.21.1-62B47A)](https://www.minecraft.net/)
[![NeoForge](https://img.shields.io/badge/NeoForge-21.1.235-EF6C35)](https://neoforged.net/)
[![Status](https://img.shields.io/badge/release-stable-2ea44f)](https://www.curseforge.com/minecraft/modpacks/simba-create/files)

A friendly, Create-powered SMP where every factory feeds a world worth living in.

Simba Create SMP is a curated Minecraft 1.21.1 NeoForge pack for cooperative worlds: factories, trains, colonies, aircraft, exploration, and survival pressure that rewards building together.

## Get the pack

- [Download on CurseForge](https://www.curseforge.com/minecraft/modpacks/simba-create)
- Choose **Heavy** for the complete visual experience.
- Choose **Lite** for lower client-side overhead with the same gameplay compatibility.
- Server owners can use the matching **Server Pack** attached to the Heavy release.

Current source version: **0.15.0 release**

Minecraft: **1.21.1** · NeoForge: **21.1.235** · Java: **21**

## Community

- Found a crash, broken recipe, or pack bug? [Open a bug report](https://github.com/QT-aiDEV/simba-create-smp/issues/new?template=bug-report.yml).
- Have a mod or balance idea? [Submit a suggestion](https://github.com/QT-aiDEV/simba-create-smp/issues/new?template=mod-suggestion.yml).
- Need installation help? Read [SUPPORT.md](SUPPORT.md) before opening an issue.
- Please follow our [Code of Conduct](CODE_OF_CONDUCT.md).

When reporting a problem, include the Simba version, Heavy or Lite profile, reproduction steps, and a crash report or relevant log excerpt. Remove server addresses, usernames, tokens, and other private data first.

## Repository layout

- `client/packwiz-client` — Heavy Packwiz source
- `client/packwiz-lite` — Lite Packwiz source
- `server/packwiz-server` — dedicated-server Packwiz source, not a live world
- `scripts/` — validation, export, upload, and server-sync tooling
- `docs/` — changelogs, release notes, audits, and CurseForge page copy
- `art/curseforge/` — approved public project media

Release archives, downloaded mod jars, backups, worlds, player data, server credentials, and local runtime files are intentionally excluded from Git.

## Validate locally

From PowerShell:

```powershell
.\scripts\Test-SimbaModpack.ps1 -RepoRoot $PWD
```

The validator checks all three profiles and blocks known dependency regressions.
GitHub Actions uses `-SourceRepository` because third-party override jars are
deliberately not redistributed through this public repository; normal local and
release validation remains strict.

## Releases

CurseForge is the official download channel. GitHub stores the auditable Packwiz source, community workflow, and changelogs; it does not redistribute third-party mod jars.

Maintainers can dry-run a release with:

```powershell
.\scripts\Publish-SimbaCurseForge.ps1 -Version 0.15.0 -ChangelogPath docs\CHANGELOG_0.15.0.md
```

Uploading requires `CURSEFORGE_TOKEN` in the current shell or the matching GitHub Actions secret. Never commit the token.

## Credits and licenses

All Minecraft mods, resource packs, and third-party assets remain the property of their respective authors and are subject to their own licenses. This repository describes and assembles the pack; it does not grant redistribution rights to third-party projects.

See [CONTRIBUTING.md](CONTRIBUTING.md) before proposing changes.
