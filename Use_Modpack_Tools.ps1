$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$Tools = Join-Path $Root ".tools"
$env:Path = (Join-Path $Tools "bin") + ";" + (Join-Path $Tools "go\bin") + ";" + $env:Path
$env:GOBIN = Join-Path $Tools "bin"
$env:GOPATH = Join-Path $Tools "gopath"

Write-Host "Modpack tools ready for this PowerShell window."
Write-Host "Go:      $((Join-Path $Tools 'go\bin\go.exe'))"
Write-Host "packwiz: $((Join-Path $Tools 'bin\packwiz.exe'))"
Write-Host ""
Write-Host "Pack folder: $((Join-Path $Root 'packwiz-pack'))"
Write-Host "Try: cd `"$((Join-Path $Root 'packwiz-pack'))`"; packwiz list"
