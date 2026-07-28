[CmdletBinding()]
param(
    [string]$RepoRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'

function Get-Sha256Hex {
    param([string]$Path)
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant()
}

foreach ($relativePackRoot in @('client\packwiz-client', 'client\packwiz-lite')) {
    $packRoot = Join-Path $RepoRoot $relativePackRoot
    $indexPath = Join-Path $packRoot 'index.toml'
    $packTomlPath = Join-Path $packRoot 'pack.toml'
    $indexText = Get-Content -LiteralPath $indexPath -Raw

    $trackedFiles = Get-ChildItem -LiteralPath (Join-Path $packRoot 'config\fancymenu') -Recurse -File
    $trackedFiles += Get-ChildItem -LiteralPath (Join-Path $packRoot 'config\drippyloadingscreen') -Recurse -File
    $trackedFiles += Get-Item -LiteralPath (Join-Path $packRoot 'resourcepacks\Simba Create SMP Branding.zip')

    foreach ($file in ($trackedFiles | Sort-Object FullName)) {
        $relative = $file.FullName.Substring($packRoot.Length).TrimStart('\', '/').Replace('\', '/')
        $hash = Get-Sha256Hex -Path $file.FullName
        $escapedRelative = [Regex]::Escape($relative)
        $blockPattern = "(?ms)^\[\[files\]\]\r?\nfile = `"$escapedRelative`"\r?\nhash = `"[0-9a-f]+`"(?:\r?\nmetafile = true)?"
        $match = [Regex]::Match($indexText, $blockPattern)
        if ($match.Success) {
            $updatedBlock = [Regex]::Replace($match.Value, 'hash = "[0-9a-f]+"', "hash = `"$hash`"")
            $indexText = $indexText.Remove($match.Index, $match.Length).Insert($match.Index, $updatedBlock)
        } else {
            if (-not $indexText.EndsWith("`n")) { $indexText += "`n" }
            $indexText += "`n[[files]]`nfile = `"$relative`"`nhash = `"$hash`"`n"
            if ($relative.EndsWith('.pw.toml')) {
                $indexText += "metafile = true`n"
            }
        }
    }

    [System.IO.File]::WriteAllText($indexPath, $indexText, [System.Text.UTF8Encoding]::new($false))
    $indexHash = Get-Sha256Hex -Path $indexPath
    $packText = Get-Content -LiteralPath $packTomlPath -Raw
    $packText = [Regex]::Replace(
        $packText,
        '(?ms)(\[index\].*?hash-format = "sha256"\s*hash = ")[0-9a-f]+(")',
        "`${1}$indexHash`${2}"
    )
    [System.IO.File]::WriteAllText($packTomlPath, $packText, [System.Text.UTF8Encoding]::new($false))

    [PSCustomObject]@{
        Pack = $relativePackRoot
        UiFiles = $trackedFiles.Count
        IndexHash = $indexHash
    }
}
