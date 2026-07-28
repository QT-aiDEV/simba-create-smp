param(
    [int]$ProjectId = 967235,
    [string]$Endpoint = "https://minecraft.curseforge.com",
    [string]$Token = $env:CURSEFORGE_TOKEN
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($Token)) {
    throw "Missing CurseForge token. Set CURSEFORGE_TOKEN only in the current shell before running this probe."
}

function Invoke-Probe {
    param(
        [string]$Name,
        [scriptblock]$Call,
        [int]$ExpectedStatus = -1
    )

    try {
        $result = & $Call
        if ($ExpectedStatus -ge 0) {
            throw "$Name unexpectedly succeeded; expected HTTP $ExpectedStatus."
        }

        Write-Host "OK $Name"
        return $result
    }
    catch {
        $responseProperty = $_.Exception.PSObject.Properties["Response"]
        $response = if ($responseProperty) { $responseProperty.Value } else { $null }
        $status = if ($response) { [int]$response.StatusCode } else { $null }

        if ($ExpectedStatus -ge 0 -and $status -eq $ExpectedStatus) {
            Write-Host "OK $Name returned expected HTTP $status"
            return $null
        }

        throw "$Name failed with HTTP $status. $($_.Exception.Message)"
    }
}

$headers = @{ "X-Api-Token" = $Token }

$versions = Invoke-Probe "game versions read" {
    Invoke-RestMethod -Method Get -Uri "$Endpoint/api/game/versions" -Headers $headers
}

$mcVersion = $versions | Where-Object { $_.name -eq "1.21.1" } | Select-Object -First 1
if (-not $mcVersion) {
    throw "Could not find Minecraft game version 1.21.1 from CurseForge."
}
Write-Host "OK found Minecraft 1.21.1 game version id $($mcVersion.id)"

$metadata = @{
    displayName = "Simba API dry auth probe"
    releaseType = "beta"
    changelog = "dry run"
    changelogType = "text"
    gameVersionNames = @("1.21.1", "NeoForge", "Java 21")
    isMarkedForManualRelease = $true
} | ConvertTo-Json -Depth 10 -Compress

Invoke-Probe "upload auth probe without a file" {
    Invoke-RestMethod -Method Post -Uri "$Endpoint/api/projects/$ProjectId/upload-file" -Headers $headers -Form @{ metadata = $metadata }
} -ExpectedStatus 400 | Out-Null

Write-Host "CurseForge API probe passed. The token reached the upload endpoint; no file was uploaded."
