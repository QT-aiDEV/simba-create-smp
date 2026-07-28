param(
    [string]$RepoRoot = (Split-Path -Parent $PSScriptRoot),
    [string]$SourceLog = (Join-Path $RepoRoot 'server\dedicated\logs\latest.log')
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
if (-not (Test-Path -LiteralPath $SourceLog)) {
    throw "Source log not found: $SourceLog"
}

$blocked = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
foreach ($line in Get-Content -LiteralPath $SourceLog) {
    if ($line -match 'LootDataType.*ResourceKey.*\]:([a-z0-9_]+):([a-z0-9_./-]+) - Unknown registry key') {
        [void]$blocked.Add("$($matches[1])|loot_table/$($matches[2])")
    }
    if ($line -match 'RecipeManager.*(?:recipe )([a-z0-9_]+):([a-z0-9_./-]+):') {
        [void]$blocked.Add("$($matches[1])|recipe/$($matches[2])")
    }
}

# Optional advancements and a compatibility data map reference content that is not installed.
foreach ($entry in @(
    'createdeco|recipe/placard',
    'trainutilities|advancement/door_ingrediants',
    'trainutilities|advancement/doors',
    'trainutilities|advancement/incomplete_prototype_door'
)) {
    [void]$blocked.Add($entry)
}

$metadata = [ordered]@{
    pack = [ordered]@{
        pack_format = 48
        description = 'Simba SMP targeted compatibility cleanup'
    }
}

# This is server data cleanup. Do not generate a client copy: client packs may
# receive Paxi for compatibility, but must not ship server-authoritative data.
$packRoots = @('server\packwiz-server')

foreach ($relativeRoot in $packRoots) {
    $paxiRoot = Join-Path $RepoRoot "$relativeRoot\config\paxi"
    $datapacksRoot = Join-Path $paxiRoot 'datapacks'
    $packRoot = Join-Path $datapacksRoot '.simba_log_cleanup_build'
    $legacyPackRoot = Join-Path $datapacksRoot 'simba_log_cleanup'
    $packArchive = Join-Path $datapacksRoot 'simba_log_cleanup.zip'

    foreach ($target in @($packRoot, $legacyPackRoot)) {
        if (Test-Path -LiteralPath $target) {
            $resolvedTarget = (Resolve-Path -LiteralPath $target).Path
            if (-not $resolvedTarget.StartsWith($RepoRoot, [StringComparison]::OrdinalIgnoreCase)) {
                throw "Refusing to replace unexpected cleanup path: $resolvedTarget"
            }
            Remove-Item -LiteralPath $resolvedTarget -Recurse -Force
        }
    }
    if (Test-Path -LiteralPath $packArchive) {
        Remove-Item -LiteralPath $packArchive -Force
    }
    New-Item -ItemType Directory -Force -Path $packRoot | Out-Null

    $metadata | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $packRoot 'pack.mcmeta') -Encoding UTF8
    [ordered]@{ loadOrder = @('simba_log_cleanup.zip') } | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $paxiRoot 'datapack_load_order.json') -Encoding UTF8

    foreach ($entry in $blocked) {
        $parts = $entry.Split('|', 2)
        $target = Join-Path $packRoot "data\$($parts[0])\$($parts[1]).json"
        New-Item -ItemType Directory -Force -Path (Split-Path -Parent $target) | Out-Null

        if ($entry -eq 'createdeco|recipe/placard') {
            $content = [ordered]@{
                type = 'minecraft:crafting_shapeless'
                category = 'misc'
                group = 'dye_placard'
                ingredients = @(
                    [ordered]@{ tag = 'createdeco:placards' },
                    [ordered]@{ item = 'minecraft:white_dye' }
                )
                result = [ordered]@{ count = 1; id = 'create:placard' }
            }
        }
        else {
            $content = [ordered]@{
                'neoforge:conditions' = @([ordered]@{ type = 'neoforge:false' })
            }
        }
        $content | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $target -Encoding UTF8
    }

    # Compress-Archive writes backslash entry names on Windows, which are not
    # valid datapack resource paths. Build the ZIP with explicit POSIX names.
    $zipStream = [IO.File]::Open($packArchive, [IO.FileMode]::CreateNew)
    $zip = [IO.Compression.ZipArchive]::new($zipStream, [IO.Compression.ZipArchiveMode]::Create)
    try {
        foreach ($file in Get-ChildItem -LiteralPath $packRoot -Recurse -File) {
            $entryName = $file.FullName.Substring($packRoot.Length + 1).Replace('\', '/')
            [IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
                $zip,
                $file.FullName,
                $entryName,
                [IO.Compression.CompressionLevel]::Optimal
            ) | Out-Null
        }
    }
    finally {
        $zip.Dispose()
        $zipStream.Dispose()
    }
    Remove-Item -LiteralPath $packRoot -Recurse -Force
}

Write-Output "Generated zipped Simba cleanup datapack with $($blocked.Count) targeted resources for Server."
