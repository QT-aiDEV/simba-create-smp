param(
    [Parameter(Mandatory = $true)]
    [string]$Version,

    [ValidateSet("alpha", "beta", "release")]
    [string]$ReleaseType = "beta",

    [int]$ProjectId = 967235,

    [string]$Endpoint = "https://minecraft.curseforge.com",

    [string]$Token = $env:CURSEFORGE_TOKEN,

    [string]$ChangelogPath = "exports\CURRENT_CLIENT_EXPORTS.md",

    [switch]$Upload,

    [switch]$ClientOnly,

    [switch]$SkipAdditionalFiles,

    [int]$ExistingMainFileId = -1
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"

function Resolve-RepoPath {
    param([string]$Path)

    if ([System.IO.Path]::IsPathRooted($Path)) {
        return [System.IO.Path]::GetFullPath($Path)
    }

    return [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".." $Path))
}

function Get-Changelog {
    param([string]$Path, [string]$Version)

    $resolvedPath = Resolve-RepoPath $Path
    if (-not (Test-Path -LiteralPath $resolvedPath)) {
        return "Simba Create SMP $Version"
    }

    $content = Get-Content -Raw -LiteralPath $resolvedPath
    $pattern = "(?ms)^##\s+$([regex]::Escape($Version))\s+Note\s*\r?\n(?<body>.*?)(?=^##\s+|\z)"
    $match = [regex]::Match($content, $pattern)
    if ($match.Success -and $match.Groups["body"].Value.Trim()) {
        return $match.Groups["body"].Value.Trim()
    }

    # Standalone release changelogs use a title such as
    # "# Simba Create SMP 0.10.5 — Client Polish Candidate".
    if ((Split-Path -Leaf $resolvedPath) -match "^CHANGELOG_$([regex]::Escape($Version))\.md$") {
        return $content.Trim()
    }

    return "Simba Create SMP $Version"
}

function New-UploadFileSpec {
    param(
        [string]$Path,
        [string]$DisplayName,
        [string[]]$GameVersionNames,
        [bool]$IsMainFile
    )

    $resolvedPath = Resolve-RepoPath $Path
    if (-not (Test-Path -LiteralPath $resolvedPath)) {
        throw "Missing upload file: $resolvedPath"
    }

    [pscustomobject]@{
        Path = $resolvedPath
        DisplayName = $DisplayName
        GameVersionNames = $GameVersionNames
        IsMainFile = $IsMainFile
    }
}

function Invoke-CurseForgeUpload {
    param(
        [int]$ProjectId,
        [string]$Endpoint,
        [string]$Token,
        [string]$FilePath,
        [string]$DisplayName,
        [string]$ReleaseType,
        [string]$Changelog,
        [string[]]$GameVersionNames,
        [int]$ParentFileId = -1
    )

    $metadata = [ordered]@{
        changelog = $Changelog
        changelogType = "markdown"
        displayName = $DisplayName
        releaseType = $ReleaseType
        isMarkedForManualRelease = $false
    }

    if ($ParentFileId -ge 0) {
        $metadata.parentFileID = $ParentFileId
    }
    else {
        $metadata.gameVersionNames = $GameVersionNames
    }

    $metadataJson = $metadata | ConvertTo-Json -Depth 10 -Compress
    $uri = "$Endpoint/api/projects/$ProjectId/upload-file"

    Write-Host "Uploading: $DisplayName"
    Write-Host "  File: $FilePath"
    Write-Host "  Release type: $ReleaseType"
    if ($ParentFileId -ge 0) {
        Write-Host "  Parent file ID: $ParentFileId"
    }
    else {
        Write-Host "  Game versions: $($GameVersionNames -join ', ')"
    }

    $response = Invoke-RestMethod `
        -Method Post `
        -Uri $uri `
        -Headers @{ "X-Api-Token" = $Token } `
        -Form @{
            metadata = $metadataJson
            file = Get-Item -LiteralPath $FilePath
        }

    if (-not $response.id) {
        throw "CurseForge upload did not return a file ID for $DisplayName."
    }

    return [int]$response.id
}

$repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
$changelog = Get-Changelog -Path $ChangelogPath -Version $Version

$heavy = New-UploadFileSpec `
    -Path "exports\Simba Create SMP-$Version-Heavy-CF-With-Overrides-CurseForge.zip" `
    -DisplayName "Simba Create SMP $Version Heavy" `
    -GameVersionNames @("1.21.1", "NeoForge", "Java 21") `
    -IsMainFile $true

$lite = New-UploadFileSpec `
    -Path "exports\Simba Create SMP-$Version-Lite-CF-With-Overrides-CurseForge.zip" `
    -DisplayName "Simba Create SMP $Version Lite" `
    -GameVersionNames @("1.21.1", "NeoForge", "Java 21") `
    -IsMainFile $false

$server = if (-not $ClientOnly) {
    New-UploadFileSpec `
        -Path "exports\Simba Create SMP-$Version-Server-CF-With-Overrides-CurseForge.zip" `
        -DisplayName "Simba Create SMP $Version Server Pack" `
        -GameVersionNames @("1.21.1", "NeoForge", "Java 21", "Server") `
        -IsMainFile $false
}

if ($ExistingMainFileId -ge 0 -and $SkipAdditionalFiles) {
    throw "-ExistingMainFileId cannot be combined with -SkipAdditionalFiles because there would be nothing to upload."
}

$files = if ($ExistingMainFileId -ge 0) {
    if ($ClientOnly) { @($lite) } else { @($lite, $server) }
}
elseif ($SkipAdditionalFiles) {
    @($heavy)
}
elseif ($ClientOnly) {
    @($heavy, $lite)
}
else {
    @($heavy, $lite, $server)
}

Write-Host "CurseForge project: $ProjectId"
Write-Host "Version: $Version"
Write-Host "Release type: $ReleaseType"
Write-Host "Repo: $repoRoot"
if ($ExistingMainFileId -ge 0) {
    Write-Host "Existing Heavy parent file ID: $ExistingMainFileId"
}
Write-Host "Files:"
$files | ForEach-Object { Write-Host "  - $($_.DisplayName): $($_.Path)" }

if (-not $Upload) {
    Write-Host ""
    Write-Host "Dry run only. Re-run with -Upload and CURSEFORGE_TOKEN set to submit files."
    exit 0
}

if ([string]::IsNullOrWhiteSpace($Token)) {
    throw "Missing CurseForge token. Set CURSEFORGE_TOKEN or pass -Token."
}

$mainFileId = $ExistingMainFileId
if ($mainFileId -lt 0) {
    $mainFileId = Invoke-CurseForgeUpload `
        -ProjectId $ProjectId `
        -Endpoint $Endpoint `
        -Token $Token `
        -FilePath $heavy.Path `
        -DisplayName $heavy.DisplayName `
        -ReleaseType $ReleaseType `
        -Changelog $changelog `
        -GameVersionNames $heavy.GameVersionNames `
        -ParentFileId -1

    Write-Host "Heavy uploaded as file ID $mainFileId"
}
else {
    Write-Host "Using existing Heavy file ID $mainFileId"
}

if (-not $SkipAdditionalFiles) {
    foreach ($file in @($files | Where-Object { -not $_.IsMainFile })) {
        $childId = Invoke-CurseForgeUpload `
            -ProjectId $ProjectId `
            -Endpoint $Endpoint `
            -Token $Token `
            -FilePath $file.Path `
            -DisplayName $file.DisplayName `
            -ReleaseType $ReleaseType `
            -Changelog $changelog `
            -GameVersionNames $file.GameVersionNames `
            -ParentFileId $mainFileId

        Write-Host "$($file.DisplayName) uploaded as file ID $childId"
    }
}
