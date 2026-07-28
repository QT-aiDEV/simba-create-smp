# Client Defaults Policy

Simba releases must never include root-level `options.txt` or `servers.dat` files.
Those files are mutable player preferences; shipping them in CurseForge overrides
can overwrite a player's controls, visual settings, multiplayer list, and local
Distant Horizons identity on update.

Use the client-only **Default Options** mod instead. Its `defaultResourcePacks`
baseline in `config/defaultoptions-common.toml` applies Simba's resource-pack
selection only once to a fresh install and records that action locally. Future
pack updates preserve the player's own choices.

Client artifacts contain only this first-run resource-pack baseline, the
FancyMenu/Drippy Simba art required to render the pack's branded screens, and
the Entity Texture Features skin compatibility fix. Gameplay, world-generation,
server-authoritative, shader, performance, and other mutable preference configs
belong only in the Server artifact or are generated locally by each player.

The production server is intentionally not preloaded into the multiplayer list.
Players add `meep.strangled.net` themselves, using whatever local label they
prefer. Do not run `New-SimbaServersDat.ps1` or add `servers.dat` to a release
unless the team explicitly reverses this policy.
