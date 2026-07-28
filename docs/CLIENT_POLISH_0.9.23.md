# Simba Create SMP 0.9.23 Client Polish Pass

Date: 2026-07-08

## Decision

0.9.23 is a client-profile polish build.

The dedicated server pack remains frozen at 0.9.22. No server-side gameplay systems were added.

## Added To Heavy And Lite

- Controlling
- Searchables
- Catalogue
- Configured
- Xaero's Minimap
- Xaero's World Map

Reason: these are professional-pack comfort mods. They improve keybind management, mod/config menus, and general navigation without changing server gameplay.

## Added To Heavy Only

- Chat Heads
- Legendary Tooltips
- Advancement Plaques
- Blur+
- MidnightLib
- Iceberg
- Prism
- Dark Loading Screen Neoforge
- Euphoria Patches

Reason: Heavy-main is allowed to be the rich client experience. These improve chat readability, menus, advancement popups, item tooltip presentation, loading-screen comfort, and shader options.

## Heavy Shaderpack Options

Bundled in Heavy-main:

- Complementary Shaders - Reimagined
- BSL Shaders
- Bliss Shaders
- Photon Shaders

Recommended default:

- Start with Complementary Reimagined for the most balanced look/performance.
- Try Bliss or Photon for Distant Horizons-heavy scenic testing.
- Keep BSL as a softer bright screenshot option.

Euphoria Patches is included for Complementary users who want more optional shader controls.

## Not Added

- Fresh Animations / entity model replacement stack
- Extra resource-pack stacks
- FancyMenu / Drippy Loading Screen branding stack
- Extra weather/particle mods beyond the current Heavy ambience pass

Reason: these are good later polish candidates, but they add rendering or maintenance risk. Heavy already has Iris, Sodium, Distant Horizons, AmbientSounds, Sound Physics, Presence Footsteps, Falling Leaves, Particle Rain, Not Enough Animations, and now multiple shaderpack options.

## Export Notes

Heavy-main export:

- `exports/Simba Create SMP-0.9.23-Heavy-CurseForge.zip`
- 167 pack entries
- 155 CurseForge manifest files
- 4 shaderpacks in overrides

Lite export:

- `exports/Simba Create SMP-0.9.23-Lite-CurseForge.zip`
- 146 pack entries
- 136 CurseForge manifest files
- no bundled shaderpacks

## Distribution Note

The 0.9.23 Heavy ZIP bundles several Modrinth/external files into the CurseForge import ZIP, including shaderpacks. This is fine for private friend testing, but before public CurseForge publication we should re-check each bundled external file against CurseForge's approved non-CurseForge mod/resource/shader policy or swap to CurseForge metadata where available.

## Recommendation

Use 0.9.23 for friend client testing with the 0.9.22 frozen server.

Heavy-main is now the recommended profile for shader/GPU players. Lite is the recommended fallback for laptops or players who want fewer visual extras while staying compatible with the same server.
