param(
    [string]$RepoRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem
$packs = @(
    @{ Name = 'Heavy'; Path = 'client\packwiz-client' },
    @{ Name = 'Lite'; Path = 'client\packwiz-lite' },
    @{ Name = 'Server'; Path = 'server\packwiz-server' }
)
$requiredMods = @(
    'carry-on.pw.toml',
    'comforts.pw.toml',
    'corail-tombstone.pw.toml',
    'curios.pw.toml',
    'falling-tree.pw.toml',
    'create-qol.pw.toml',
    'create-aeronautics-transmission-linkage.pw.toml',
    'jei.pw.toml',
    'paxi-neoforge.pw.toml',
    'tectonic.pw.toml',
    'torchmaster.pw.toml',
    'astikor-carts-redux.pw.toml',
    'bad-mobs.pw.toml',
    'butchery.pw.toml',
    'create-big-cannons.pw.toml',
    'create-blocks-bogies.pw.toml',
    'create-contraption-terminals.pw.toml',
    'create-escalated.pw.toml',
    'create-live-radio.pw.toml',
    'create-radars.pw.toml',
    'create-ultimine.pw.toml',
    'enhanced-hordes.pw.toml',
    'exposure.pw.toml',
    'haven-trowel.pw.toml',
    'immersive-aircraft.pw.toml',
    'mutants-and-zombies.pw.toml',
    'parcool.pw.toml',
    'passive-shield.pw.toml',
    'patchouli.pw.toml',
    'sawmill.pw.toml',
    'simple-voice-chat.pw.toml',
    'undead-nights.pw.toml'
    'simply-swords.pw.toml'
    'simply-tooltips.pw.toml'
    'epic-knights-armor-and-weapons.pw.toml'
    'ydms-weapon-master.pw.toml'
    'cosmetic-armor-reworked.pw.toml'
    'enchanting-infuser.pw.toml'
    'illager-invasion.pw.toml'
    'what-are-they-up-to.pw.toml'
    'coroutil.pw.toml'
    'better-combat-by-daedelus.pw.toml'
    'playeranimator.pw.toml'
    'cgs.pw.toml'
    'nukateams-gun-lib.pw.toml'
    'betterdays.pw.toml'
    'minecolonies.pw.toml'
    'createcolonies.pw.toml'
    'minecolonies-tweaks.pw.toml'
    'minecolonies-compatibility.pw.toml'
    'stylecolonies.pw.toml'
    'towntalk.pw.toml'
    'domum-ornamentum.pw.toml'
    'structurize.pw.toml'
    'blockui.pw.toml'
    'multi-piston.pw.toml'
    'better-village-neoforge.pw.toml'
    'library-ferret-neoforge.pw.toml'
    'aeronautic-additions-and-chunkloader.pw.toml'
    'create-armored-constructs.pw.toml'
    'create-automatics.pw.toml'
    'create-hypertubes.pw.toml'
    'create-tracks.pw.toml'
    'shield-generators.pw.toml'
    'simple-magnets.pw.toml'
    'advanced-peripherals.pw.toml'
    'cccbridge.pw.toml'
)
$requiredServerConfigs = @(
    'carryon-common.toml',
    'comforts-server.toml',
    'fallingtree.json',
    'tectonic.json',
    'tombstone-common.toml',
    'tombstone-server.toml',
    'torchmaster.toml',
    'badmobs-common.toml',
    'passiveshield.json5'
    'illagerinvasion-server.toml'
    'create_submarine-common.toml'
    'watut-server.toml'
    'watut-common.toml'
    'ntgl-common.toml'
    'ntgl-server.toml'
    'betterdays-common.toml'
    'minecolonies-server.toml'
    'minecolonies-common.toml'
    'minecolonies_tweaks-common.toml'
    'minecolonies_tweaks-server.toml'
    'minecolonies_compatibility-common.toml'
    'minecolonies_compatibility-server.toml'
    'createcolonies-common.toml'
    'bettervillage_1.properties'
    'structurize-server.toml'
    'computercraft-server.toml'
)
$forbiddenPatterns = @(
    'createdynlight',
    'reeses_sodium_options',
    'sodiumdynamiclights',
    'sodiumoptionsapi'
)
$failures = [System.Collections.Generic.List[string]]::new()

foreach ($pack in $packs) {
    $root = Join-Path $RepoRoot $pack.Path
    $mods = Join-Path $root 'mods'
    $config = Join-Path $root 'config'

    foreach ($file in $requiredMods) {
        if (-not (Test-Path -LiteralPath (Join-Path $mods $file))) {
            $failures.Add("$($pack.Name): missing mod metadata $file")
        }
    }
    if ($pack.Name -eq 'Server') {
        foreach ($file in $requiredServerConfigs) {
            if (-not (Test-Path -LiteralPath (Join-Path $config $file))) {
                $failures.Add("$($pack.Name): missing config $file")
            }
        }
        foreach ($file in @('paxi\datapack_load_order.json', 'paxi\datapacks\simba_log_cleanup.zip')) {
            if (-not (Test-Path -LiteralPath (Join-Path $config $file))) {
                $failures.Add("$($pack.Name): missing cleanup datapack file $file")
            }
        }
        $cleanupArchive = Join-Path $config 'paxi\datapacks\simba_log_cleanup.zip'
        if (Test-Path -LiteralPath $cleanupArchive) {
            $archive = [IO.Compression.ZipFile]::OpenRead($cleanupArchive)
            try {
                foreach ($entry in @('pack.mcmeta', 'data/createdeco/recipe/placard.json')) {
                    if (-not $archive.GetEntry($entry)) {
                        $failures.Add("$($pack.Name): cleanup archive missing $entry")
                    }
                }
            }
            finally {
                $archive.Dispose()
            }
        }
    }
    if (-not (Test-Path -LiteralPath (Join-Path $mods 'cc-tweaked-1.21.1-forge-1.120.0.jar'))) {
        $failures.Add("$($pack.Name): missing pinned CC: Tweaked override")
    }

    $advancedPeripherals = Get-Content -Raw (Join-Path $mods 'advanced-peripherals.pw.toml')
    if ($advancedPeripherals -notmatch 'AdvancedPeripherals-1\.21\.1-0\.7\.62b\.jar' -or
        $advancedPeripherals -notmatch 'file-id\s*=\s*8228816' -or
        $advancedPeripherals -notmatch 'pin\s*=\s*true') {
        $failures.Add("$($pack.Name): Advanced Peripherals is not pinned to the approved 1.21.1 build")
    }

    $ccCBridge = Get-Content -Raw (Join-Path $mods 'cccbridge.pw.toml')
    if ($ccCBridge -notmatch 'cccbridge-mc1\.21\.1-v1\.7\.3-neoforge\.jar' -or
        $ccCBridge -notmatch 'file-id\s*=\s*8232436' -or
        $ccCBridge -notmatch 'pin\s*=\s*true') {
        $failures.Add("$($pack.Name): CC:C Bridge is not pinned to the approved 1.21.1 build")
    }

    $driveByWireTypewriter = Get-Content -Raw (Join-Path $mods 'drive-by-wire-typewriter.pw.toml')
    if ($driveByWireTypewriter -notmatch 'drivebywire-typewriter-1\.1\.0-beta\.2\.jar' -or
        $driveByWireTypewriter -notmatch 'project-id\s*=\s*1558687' -or
        $driveByWireTypewriter -notmatch 'file-id\s*=\s*8347375' -or
        $driveByWireTypewriter -notmatch 'pin\s*=\s*true') {
        $failures.Add("$($pack.Name): Drive-By-Wire: Typewriter is not pinned to the approved maintained 1.21.1 build")
    }

    $jei = Get-Content -Raw (Join-Path $mods 'jei.pw.toml')
    if ($jei -notmatch '19\.27\.0\.338' -or $jei -notmatch 'pin\s*=\s*true') {
        $failures.Add("$($pack.Name): JEI is not pinned to 19.27.0.338")
    }

    # Sophisticated Core 1.4.72+ requires JEI 19.32+, which conflicts with the
    # Petrolpark-compatible JEI pin used by this pack. Keep this pair together.
    $sophisticatedCore = Get-Content -Raw (Join-Path $mods 'sophisticated-core.pw.toml')
    $sophisticatedBackpacks = Get-Content -Raw (Join-Path $mods 'sophisticated-backpacks.pw.toml')
    if ($sophisticatedCore -notmatch '1\.4\.69\.2125' -or $sophisticatedCore -notmatch 'file-id\s*=\s*8389843') {
        $failures.Add("$($pack.Name): Sophisticated Core is not on the JEI-compatible 1.4.69.2125 pin")
    }
    if ($sophisticatedBackpacks -notmatch '3\.25\.68\.1971' -or $sophisticatedBackpacks -notmatch 'file-id\s*=\s*8377457') {
        $failures.Add("$($pack.Name): Sophisticated Backpacks is not on the approved 3.25.68.1971 pair")
    }

    if ($pack.Name -eq 'Server') {
        $colonies = Get-Content -Raw (Join-Path $config 'minecolonies-server.toml')
        if ($colonies -notmatch 'maxcitizenpercolony\s*=\s*250' -or
            $colonies -notmatch 'maxBarbarianSize\s*=\s*20' -or
            $colonies -notmatch 'barbarianhordedifficulty\s*=\s*3' -or
            $colonies -notmatch 'averagenumberofnightsbetweenraids\s*=\s*8' -or
            $colonies -notmatch 'minimumnumberofnightsbetweenraids\s*=\s*6') {
            $failures.Add("$($pack.Name): MineColonies population/raid balance is not pinned")
        }
    }

    $allNames = (Get-ChildItem -LiteralPath $mods -File | Select-Object -ExpandProperty Name) -join "`n"
    foreach ($pattern in $forbiddenPatterns) {
        if ($allNames -match [regex]::Escape($pattern)) {
            $failures.Add("$($pack.Name): forbidden regression present: $pattern")
        }
    }
}

$serverRoot = Join-Path $RepoRoot 'server\packwiz-server'
$ccServerConfig = Get-Content -Raw (Join-Path $serverRoot 'config\computercraft-server.toml')
if ($ccServerConfig -notmatch 'computer_space_limit\s*=\s*4000000' -or
    $ccServerConfig -notmatch 'upload_max_size\s*=\s*524288' -or
    $ccServerConfig -notmatch 'enabled\s*=\s*true' -or
    $ccServerConfig -notmatch 'websocket_enabled\s*=\s*true' -or
    $ccServerConfig -notmatch 'host\s*=\s*"\$private"\s*\r?\n\s*action\s*=\s*"allow"' -or
    $ccServerConfig -notmatch 'modem_range\s*=\s*192' -or
    $ccServerConfig -notmatch 'modem_high_altitude_range\s*=\s*768' -or
    $ccServerConfig -notmatch 'modem_range_during_storm\s*=\s*144' -or
    $ccServerConfig -notmatch 'modem_high_altitude_range_during_storm\s*=\s*576' -or
    $ccServerConfig -notmatch 'command_block_enabled\s*=\s*false') {
    $failures.Add('Server: ComputerCraft configuration is missing the approved storage, local-HTTP, cell-network, or command-computer policy')
}

foreach ($file in @(
    'mods\bluemap.pw.toml',
    'config\bluemap\core.conf',
    'config\bluemap\plugin.conf',
    'config\bluemap\webserver.conf',
    'config\bluemap\webapp.conf',
    'config\bluemap\storages\file.conf',
    'config\bluemap\maps\world.conf',
    'config\bluemap\maps\world_the_nether.conf',
    'config\bluemap\maps\world_the_end.conf'
)) {
    if (-not (Test-Path -LiteralPath (Join-Path $serverRoot $file))) {
        $failures.Add("Server: missing BlueMap file $file")
    }
}

foreach ($file in @(
    'config\voicechat\voicechat-server.properties',
    'config\undeadnights-server.toml',
    'config\undeadnights_difficulty_config.json',
    'config\fallingtree.json'
)) {
    if (-not (Test-Path -LiteralPath (Join-Path $serverRoot $file))) {
        $failures.Add("Server: missing server feature config $file")
    }
}

foreach ($clientPath in @('client\packwiz-client', 'client\packwiz-lite')) {
    $serversDat = Join-Path (Join-Path $RepoRoot $clientPath) 'servers.dat'
    if (Test-Path -LiteralPath $serversDat) {
        $failures.Add("Client: bundled multiplayer server list must not override player settings: $clientPath\servers.dat")
    }
    if (Test-Path -LiteralPath (Join-Path (Join-Path $RepoRoot $clientPath) 'options.txt')) {
        $failures.Add("Client: root options.txt must not override player settings: $clientPath\options.txt")
    }
    foreach ($file in @('mods\ok-zoomer.pw.toml', 'mods\raws-visual-keybinder.pw.toml')) {
        if (-not (Test-Path -LiteralPath (Join-Path (Join-Path $RepoRoot $clientPath) $file))) {
            $failures.Add("Client: missing UI/QoL metadata $clientPath\$file")
        }
    }
    if (-not (Test-Path -LiteralPath (Join-Path (Join-Path $RepoRoot $clientPath) 'mods\aeronautics-wind-sound.pw.toml'))) {
        $failures.Add("Client: missing Aeronautics Wind Sound metadata $clientPath")
    }
    foreach ($file in @('mods\extreme-sound-muffler.pw.toml', 'mods\dark-mode-everywhere.pw.toml')) {
        if (-not (Test-Path -LiteralPath (Join-Path (Join-Path $RepoRoot $clientPath) $file))) {
            $failures.Add("Client: missing 0.12.1 Petting/audio component $clientPath\$file")
        }
    }
    $trmtMetadata = Join-Path (Join-Path $RepoRoot $clientPath) 'mods\the-roads-more-travelled.pw.toml'
    if (-not (Test-Path -LiteralPath $trmtMetadata) -or (Get-Content -Raw $trmtMetadata) -notmatch 'trmt-0\.5\.1-1\.21\.1-neoforge\.jar') {
        $failures.Add("Client: missing the pinned NeoForge 1.21.1 TRMT build in $clientPath")
    }
    if ((Get-Content -Raw (Join-Path (Join-Path $RepoRoot $clientPath) 'mods\extreme-sound-muffler.pw.toml')) -notmatch 'side\s*=\s*"client"') {
        $failures.Add("Client: Extreme Sound Muffler must remain client-only in $clientPath")
    }
    if ((Get-Content -Raw (Join-Path (Join-Path $RepoRoot $clientPath) 'mods\dark-mode-everywhere.pw.toml')) -notmatch 'side\s*=\s*"client"') {
        $failures.Add("Client: Dark Mode Everywhere must remain client-only in $clientPath")
    }
    $mainMenuLayout = Get-Content -Raw (Join-Path (Join-Path $RepoRoot $clientPath) 'config\fancymenu\customization\simba-title-clean.txt')
    if ($mainMenuLayout -notmatch 'main-logo-clean\.png' -or $mainMenuLayout -match 'simba-title-logo-breath\.fma') {
        $failures.Add("Client: main-menu Simba title must remain static in $clientPath")
    }
    $fancyMenuOptions = Get-Content -Raw (Join-Path (Join-Path $RepoRoot $clientPath) 'config\fancymenu\options.txt')
    if ($fancyMenuOptions -match 'play_vanilla_menu_music|default_gui_scale|force_fullscreen') {
        $failures.Add("Client: FancyMenu must not override player display or music preferences in $clientPath")
    }
    foreach ($file in @('mods\default-options.pw.toml', 'config\defaultoptions-common.toml')) {
        if (-not (Test-Path -LiteralPath (Join-Path (Join-Path $RepoRoot $clientPath) $file))) {
            $failures.Add("Client: missing first-run defaults component $clientPath\$file")
        }
    }
    if ((Get-Content -Raw (Join-Path (Join-Path $RepoRoot $clientPath) 'mods\default-options.pw.toml')) -notmatch 'side\s*=\s*"client"') {
        $failures.Add("Client: Default Options must remain client-only in $clientPath")
    }
    $defaultOptionsConfig = Get-Content -Raw (Join-Path (Join-Path $RepoRoot $clientPath) 'config\defaultoptions-common.toml')
    if ($defaultOptionsConfig -match 'Flintl0cks' -or $defaultOptionsConfig -notmatch 'defaultResourcePacks' -or $defaultOptionsConfig -notmatch 'file/Simba Chat Format\.zip') {
        $failures.Add("Client: Default Options resource-pack defaults are invalid in $clientPath")
    }
    $etfConfig = Get-Content -Raw (Join-Path (Join-Path $RepoRoot $clientPath) 'config\entity_texture_features.json')
    if ($etfConfig -notmatch 'skinFeaturesEnabled\s*"?\s*:\s*false') {
        $failures.Add("Client: Entity Texture Features skin compatibility fix is missing in $clientPath")
    }
    foreach ($file in @(
        'config\dynamic_fps.json',
        'config\iris.properties',
        'config\passiveshield.json5',
        'config\fallingtree.json',
        'config\petting-common.toml',
        'config\tectonic.json',
        'config\paxi\datapack_load_order.json'
    )) {
        if (Test-Path -LiteralPath (Join-Path (Join-Path $RepoRoot $clientPath) $file)) {
            $failures.Add("Client: mutable or server-authoritative override must not ship: $clientPath\$file")
        }
    }
    $chatFormatPack = Join-Path (Join-Path $RepoRoot $clientPath) 'resourcepacks\Simba Chat Format.zip'
    if (-not (Test-Path -LiteralPath $chatFormatPack)) {
        $failures.Add("Client: bundled Simba Chat Format resource pack is missing in $clientPath")
    }
    foreach ($file in @(
        'mods\drippy-loading-screen.pw.toml',
        'mods\drippy-early-loading-module.pw.toml',
        'mods\fancymenu.pw.toml',
        'mods\konkrete.pw.toml',
        'mods\melody.pw.toml'
    )) {
        $path = Join-Path (Join-Path $RepoRoot $clientPath) $file
        if (-not (Test-Path -LiteralPath $path)) {
            $failures.Add("Client: missing Drippy stack metadata $clientPath\$file")
        }
        elseif ((Get-Content -Raw $path) -notmatch 'side\s*=\s*"client"') {
            $failures.Add("Client: Drippy stack entry is not client-only $clientPath\$file")
        }
    }
}

$serverCoreConfig = Get-Content -Raw (Join-Path $serverRoot 'config\servercore\config.yml')
if ($serverCoreConfig -notmatch 'autosave-interval-seconds:\s*1800') {
    $failures.Add('Server: ServerCore autosave interval must be staged at 1800 seconds')
}
$serverFallingTreeConfig = Get-Content -Raw (Join-Path $serverRoot 'config\fallingtree.json') | ConvertFrom-Json
if ($serverFallingTreeConfig.trees.detectionMode -ne 'WHOLE_TREE' -or -not $serverFallingTreeConfig.trees.allowMixedLogs -or $serverFallingTreeConfig.trees.maxScanSize -ne 2048 -or $serverFallingTreeConfig.trees.maxSize -ne 2048 -or $serverFallingTreeConfig.trees.searchAreaRadius -ne -1) {
    $failures.Add('Server: FallingTree must support large mixed-log trees')
}
$undeadNightsConfig = Get-Content -Raw (Join-Path $serverRoot 'config\undeadnights-server.toml')
if ($undeadNightsConfig -notmatch 'maxHealthHordeZombies\s*=\s*24\.0' -or $undeadNightsConfig -notmatch 'maxHealthEliteZombies\s*=\s*24\.0' -or $undeadNightsConfig -notmatch 'maxHealthDemolitionZombies\s*=\s*24\.0') {
    $failures.Add('Server: Undead Nights zombie health must remain at the 24-health PvE target')
}
if ($undeadNightsConfig -notmatch 'demolitionZombiesSpawnNaturally\s*=\s*false') {
    $failures.Add('Server: Undead Nights demolition (TNT) zombies must remain disabled')
}
$undeadNightsDifficultyConfig = Get-Content -Raw (Join-Path $serverRoot 'config\undeadnights_difficulty_config.json') | ConvertFrom-Json
$undeadNightsHordeMobs = $undeadNightsDifficultyConfig.difficultyLevels[0].difficultySettingsHordeMobs
if (-not $undeadNightsHordeMobs.updateHordeMobAttributes -or $undeadNightsHordeMobs.speedAttributeScaleFactor -ne 0.6 -or $undeadNightsHordeMobs.healthAttributeScaleFactor -ne 1.0 -or $undeadNightsHordeMobs.damageAttributeScaleFactor -ne 1.0 -or $undeadNightsHordeMobs.armorAttributeScaleFactor -ne 1.0 -or $undeadNightsHordeMobs.hordeMobsCanClimbEachOther -or -not $undeadNightsHordeMobs.hordeZombiesBurnInTheSun) {
    $failures.Add('Server: Undead Nights must keep the slow, non-climbing PvE horde profile')
}
$undeadNightsLure = $undeadNightsDifficultyConfig.difficultyLevels[0].difficultySettingsLureEffect
if ($undeadNightsLure.lureHordeEffectSpawnsHorde -or $undeadNightsLure.strongLureHordeEffectSpawnsHorde) {
    $failures.Add('Server: Undead Nights lure effects must not create surprise hordes')
}

foreach ($file in @('mods\petting.pw.toml', 'config\petting-common.toml')) {
    if (-not (Test-Path -LiteralPath (Join-Path $serverRoot $file))) {
        $failures.Add("Server: missing Petting component $file")
    }
}
$serverTrmtMetadata = Join-Path $serverRoot 'mods\the-roads-more-travelled.pw.toml'
if (-not (Test-Path -LiteralPath $serverTrmtMetadata) -or (Get-Content -Raw $serverTrmtMetadata) -notmatch 'trmt-0\.5\.1-1\.21\.1-neoforge\.jar') {
    $failures.Add('Server: missing the pinned NeoForge 1.21.1 TRMT build')
}
$serverPettingConfig = Get-Content -Raw (Join-Path $serverRoot 'config\petting-common.toml')
if ($serverPettingConfig -notmatch 'maxPetsPerPlayer\s*=\s*6' -or $serverPettingConfig -notmatch 'minecraft:ender_dragon' -or $serverPettingConfig -notmatch 'illagerinvasion:\*') {
    $failures.Add('Server: Petting safety profile is incomplete')
}
if (Test-Path -LiteralPath (Join-Path $serverRoot 'mods\extreme-sound-muffler.pw.toml')) {
    $failures.Add('Server: client-only Extreme Sound Muffler leaked into the dedicated-server pack')
}
if (Test-Path -LiteralPath (Join-Path $serverRoot 'mods\dark-mode-everywhere.pw.toml')) {
    $failures.Add('Server: client-only Dark Mode Everywhere leaked into the dedicated-server pack')
}

if (Test-Path -LiteralPath (Join-Path $serverRoot 'servers.dat')) {
    $failures.Add('Server: client servers.dat leaked into the dedicated-server pack')
}

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Host 'Simba modpack validation passed for Heavy, Lite, and Server.'
