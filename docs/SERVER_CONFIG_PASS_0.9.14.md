# Simba Create SMP Server Config Pass 0.9.14

Date: 2026-07-08

Scope: friendly PvE co-op balance for the dedicated server profile. No mods were added, removed, or upgraded.

## Changes Applied

- Disabled global player-vs-player damage in `server.properties`.
- Set FTB Chunks claimed areas to block PvP by default.
- Set FTB Chunks default fake-player access to enabled so Create deployers and automation are less likely to fail inside claims.
- Set FTB Chunks offline force-loaded chunks to expire after 14 idle days.
- Protected Lootr chests from normal breaking and creeper/TNT explosions so one player cannot accidentally remove shared exploration loot before friends open it.
- Disabled Sophisticated Backpacks item-form fluid handling to avoid the known cross-mod fluid dupe edge case.
- Disabled opening other players' worn backpacks by right-clicking them, preventing accidental privacy/theft friction.

## Commands Intentionally Left Enabled

- `/home`
- `/back`
- `/warp`
- `/spawn`
- `/tpa`
- `/rtp`

These stay enabled by owner preference for a relaxed friends server.

## Reviewed And Kept

- FTB Backups 3: automatic backups every 120 minutes, 12 backups retained, 50 GB cap.
- Create Power Loader: cheap static loading remains enabled; mobile/train/station loading remains tied to brass loaders.
- Tom's Storage: moderate wireless ranges, beacon-gated infinite/cross-dimensional access, multithreading enabled.
- Let Me Despawn: no broad captive-animal despawn rules were added.
- Dynamic View: keeps view/simulation distance adaptive within the existing conservative range.

## Follow-Up Test Notes

- In a claimed chunk, test a Create deployer or similar automation against a protected block/container.
- Confirm players cannot damage each other.
- Confirm Lootr chests cannot be accidentally broken in survival.
- Confirm `/home`, `/back`, and `/warp` still work as expected.
- Confirm FTB Backups creates a clean backup during real play.
