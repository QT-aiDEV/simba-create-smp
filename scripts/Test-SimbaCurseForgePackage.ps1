param(
    [string]$RepoRoot = (Split-Path -Parent $PSScriptRoot),
    [string]$Version = '0.14.1',
    [string]$ExportsRoot
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
if ([string]::IsNullOrWhiteSpace($ExportsRoot)) {
    $ExportsRoot = Join-Path $RepoRoot 'exports'
}

$allowedBundledMods = [ordered]@{
    'cc-tweaked-1.21.1-forge-1.120.0.jar' = '81A903710D109D129C249C105695A96F4BAD5E0ACF7068920FB191BA791C14CE'
    'radiomod-1.0.2.jar' = '1A3EA0AC1918AE0888F859F287ABD27B42200D693704C2CD03C5F43A50DBC7E3'
    'createautomatics-1.0.1.jar' = '5BD847FA3EE45270650907FA9B75F351EAD752FE8B1D6AB019EA11365F41F3C5'
    'create_bluemap-1.1.1.jar' = '1DC287271F7DB558146E4473954F204F526F368259A274D5DF0A67E953B66050'
}
$clientOnlyProjectIds = @(511770, 1390924, 367706, 410295, 938643, 232131, 363363, 574123)
$packs = @(
    @{ Name = 'Heavy'; File = "Simba Create SMP-$Version-Heavy-CF-With-Overrides-CurseForge.zip"; Client = $true },
    @{ Name = 'Lite'; File = "Simba Create SMP-$Version-Lite-CF-With-Overrides-CurseForge.zip"; Client = $true },
    @{ Name = 'Server'; File = "Simba Create SMP-$Version-Server-CF-With-Overrides-CurseForge.zip"; Client = $false }
)
$forbiddenPathPattern = '(?i)(^|/)(logs?|crash-reports?|world|saves?|screenshots?|backups?|cache|.git)(/|$)|.(log|tmp|bak|old|dmp|lock)$|(^|/)(launcher_profiles|usercache|usernamecache|ops|whitelist|banned-players|banned-ips).json$'
$secretPattern = '(?i)(curseforge[_-]?token|api[_-]?token|authorizations*[:=]|bearers+[a-z0-9._-]{16,}|[a-f0-9]{8}(?:-[a-f0-9]{4}){3}-[a-f0-9]{12})'
$failures = [Collections.Generic.List[string]]::new()
$report = [Collections.Generic.List[object]]::new()

foreach ($pack in $packs) {
    $path = Join-Path $ExportsRoot $pack.File
    if (-not (Test-Path -LiteralPath $path)) {
        $failures.Add("$($pack.Name): missing export $path")
        continue
    }

    $zip = [IO.Compression.ZipFile]::OpenRead($path)
    try {
        $names = @($zip.Entries | ForEach-Object FullName)
        if (@($names | Where-Object { $_ -notmatch '^(manifest\.json|modlist\.html|overrides(?:/.*)?)$' }).Count) {
            $failures.Add("$($pack.Name): unexpected ZIP root content")
        }
        if (@($names | Where-Object { $_ -match '\\' }).Count) {
            $failures.Add("$($pack.Name): ZIP contains backslash entry names")
        }
        if (@($names | Group-Object | Where-Object Count -gt 1).Count) {
            $failures.Add("$($pack.Name): ZIP contains duplicate entry names")
        }
        if (@($names | Where-Object { $_ -match $forbiddenPathPattern }).Count) {
            $failures.Add("$($pack.Name): forbidden runtime/user files are packaged")
        }

        $manifestEntry = $zip.GetEntry('manifest.json')
        if (-not $manifestEntry) {
            $failures.Add("$($pack.Name): manifest.json missing")
            continue
        }
        $reader = [IO.StreamReader]::new($manifestEntry.Open())
        try { $manifestText = $reader.ReadToEnd() } finally { $reader.Dispose() }
        $manifest = $manifestText | ConvertFrom-Json
        if ($manifest.minecraft.version -ne '1.21.1') {
            $failures.Add("$($pack.Name): manifest Minecraft version is not 1.21.1")
        }
        if (@($manifest.minecraft.modLoaders | Where-Object id -eq 'neoforge-21.1.235').Count -ne 1) {
            $failures.Add("$($pack.Name): NeoForge 21.1.235 is not the primary manifest loader")
        }
        if (@($manifest.files | Group-Object projectID | Where-Object Count -gt 1).Count) {
            $failures.Add("$($pack.Name): duplicate CurseForge project IDs in manifest")
        }
        if (-not ($manifest.files | Where-Object { $_.projectID -eq 676721 -and $_.fileID -eq 8240058 })) {
            $failures.Add("$($pack.Name): Create Aeronautics must use CurseForge project 676721 file 8240058")
        }
        if (-not ($manifest.files | Where-Object { $_.projectID -eq 1548863 -and $_.fileID -eq 8169570 })) {
            $failures.Add("$($pack.Name): Create:Tracks+ must use CurseForge project 1548863 file 8169570")
        }
        if (-not ($manifest.files | Where-Object { $_.projectID -eq 431725 -and $_.fileID -eq 8228816 })) {
            $failures.Add("$($pack.Name): Advanced Peripherals must use CurseForge project 431725 file 8228816")
        }
        if (-not ($manifest.files | Where-Object { $_.projectID -eq 656214 -and $_.fileID -eq 8232436 })) {
            $failures.Add("$($pack.Name): CC:C Bridge must use CurseForge project 656214 file 8232436")
        }
        if (-not ($manifest.files | Where-Object { $_.projectID -eq 1558687 -and $_.fileID -eq 8347375 })) {
            $failures.Add("$($pack.Name): Drive-By-Wire: Typewriter must use CurseForge project 1558687 file 8347375")
        }

        $bundled = @($zip.Entries | Where-Object FullName -like 'overrides/mods/*.jar')
        foreach ($entry in $bundled) {
            $name = Split-Path $entry.FullName -Leaf
            if (-not $allowedBundledMods.Contains($name)) {
                $failures.Add("$($pack.Name): unapproved bundled mod $name")
                continue
            }
            $sha = [Security.Cryptography.SHA256]::Create()
            $stream = $entry.Open()
            try { $actual = [BitConverter]::ToString($sha.ComputeHash($stream)).Replace('-', '') }
            finally { $stream.Dispose(); $sha.Dispose() }
            if ($actual -ne $allowedBundledMods[$name]) {
                $failures.Add("$($pack.Name): bundled mod hash mismatch for $name")
            }
        }
        foreach ($name in $allowedBundledMods.Keys) {
            if ($name -eq 'create_bluemap-1.1.1.jar' -and $pack.Client) {
                continue
            }
            if (-not ($bundled | Where-Object { (Split-Path $_.FullName -Leaf) -eq $name })) {
                $failures.Add("$($pack.Name): approved bundled mod missing: $name")
            }
        }

        if (-not $pack.Client) {
            if ($zip.GetEntry('overrides/servers.dat')) {
                $failures.Add('Server: client servers.dat leaked into server export')
            }
            if (@($manifest.files | Where-Object projectID -in $clientOnlyProjectIds).Count) {
                $failures.Add('Server: client-only Drippy/FancyMenu stack leaked into manifest')
            }
            if (@($names | Where-Object { $_ -match '^overrides/(shaderpacks|resourcepacks|config/fancymenu|config/drippy)' }).Count) {
                $failures.Add('Server: client-only visual overrides leaked into server pack')
            }
        }
        else {
            $serversEntry = $zip.GetEntry('overrides/servers.dat')
            if ($serversEntry) {
                $failures.Add("$($pack.Name): bundled servers.dat would overwrite player server lists")
            }
            if ($zip.GetEntry('overrides/options.txt')) {
                $failures.Add("$($pack.Name): bundled options.txt would overwrite player settings")
            }
            if (-not $zip.GetEntry('overrides/config/defaultoptions-common.toml')) {
                $failures.Add("$($pack.Name): Default Options resource-pack baseline missing")
            }
            if (-not $zip.GetEntry('overrides/resourcepacks/Simba Chat Format.zip')) {
                $failures.Add("$($pack.Name): bundled Simba Chat Format resource pack missing")
            }
            foreach ($id in $clientOnlyProjectIds) {
                if (-not ($manifest.files | Where-Object projectID -eq $id)) {
                    $failures.Add("$($pack.Name): required Drippy/FancyMenu project missing: $id")
                }
            }
        }

        foreach ($entry in $zip.Entries | Where-Object { $_.Length -le 2MB -and $_.FullName -match '\.(txt|toml|json|json5|properties|cfg|conf|md)$' }) {
            $reader = [IO.StreamReader]::new($entry.Open())
            try { $text = $reader.ReadToEnd() } finally { $reader.Dispose() }
            if ($text -match $secretPattern) {
                $failures.Add("$($pack.Name): possible secret in $($entry.FullName)")
            }
        }

        $overrideEntries = @($zip.Entries | Where-Object FullName -like 'overrides/*')
        if ($overrideEntries.Count -gt 100) {
            $failures.Add("$($pack.Name): override entry budget exceeded ($($overrideEntries.Count) > 100)")
        }
        $overrideBytes = ($overrideEntries | Measure-Object Length -Sum).Sum
        if ($overrideBytes -gt 75MB) {
            $failures.Add("$($pack.Name): override size budget exceeded")
        }

        $cleanupEntry = $zip.GetEntry('overrides/config/paxi/datapacks/simba_log_cleanup.zip')
        if ($pack.Client) {
            if ($cleanupEntry) {
                $failures.Add("$($pack.Name): server-only cleanup datapack leaked into client export")
            }
        }
        elseif (-not $cleanupEntry) {
            $failures.Add("$($pack.Name): cleanup datapack missing")
        }
        else {
            $memory = [IO.MemoryStream]::new()
            $source = $cleanupEntry.Open()
            try { $source.CopyTo($memory) } finally { $source.Dispose() }
            $memory.Position = 0
            $nested = [IO.Compression.ZipArchive]::new($memory, [IO.Compression.ZipArchiveMode]::Read)
            try {
                if (@($nested.Entries | Where-Object FullName -match '\\').Count) {
                    $failures.Add("$($pack.Name): cleanup datapack contains backslash paths")
                }
                if (-not $nested.GetEntry('pack.mcmeta')) {
                    $failures.Add("$($pack.Name): cleanup datapack missing pack.mcmeta")
                }
            }
            finally { $nested.Dispose(); $memory.Dispose() }
        }

        $report.Add([pscustomobject]@{
            Pack = $pack.Name
            ManifestProjects = @($manifest.files).Count
            OverrideEntries = $overrideEntries.Count
            OverrideMiB = [math]::Round($overrideBytes / 1MB, 2)
            BundledExceptions = $bundled.Count
            ZipMiB = [math]::Round((Get-Item -LiteralPath $path).Length / 1MB, 2)
        })
    }
    finally { $zip.Dispose() }
}

if ($failures.Count) {
    $failures | ForEach-Object { Write-Error $_ }
    exit 1
}

$report | Format-Table -AutoSize
Write-Host 'CurseForge package hardening validation passed.'
