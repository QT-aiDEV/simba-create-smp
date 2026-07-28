param(
    [string]$ConfigPath = (Join-Path $PSScriptRoot "watchdog-config.json"),
    [int]$ReadyTimeoutSeconds = 360,
    [int]$StopTimeoutSeconds = 180
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"

throw "This self-test is disabled for production. It must not start Minecraft outside the visible terminal-and-GUI launcher."

function Read-WatchdogConfig {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) {
        throw "Missing watchdog config: $Path"
    }

    $config = Get-Content -Raw -LiteralPath $Path | ConvertFrom-Json
    $baseDir = Split-Path -Parent $Path
    $serverDir = $config.serverDirectory
    if (-not [System.IO.Path]::IsPathRooted($serverDir)) {
        $serverDir = [System.IO.Path]::GetFullPath((Join-Path $baseDir $serverDir))
    }

    $config | Add-Member -NotePropertyName resolvedServerDirectory -NotePropertyValue $serverDir -Force
    return $config
}

function Get-SimbaServerJavaProcesses {
    param([string]$ServerDirectory)

    $serverDirPattern = [regex]::Escape($ServerDirectory)
    Get-CimInstance Win32_Process -Filter "name = 'java.exe'" -ErrorAction SilentlyContinue |
        Where-Object {
            $_.CommandLine -match $serverDirPattern -or
            ($_.CommandLine -match "neoforge" -and $_.CommandLine -match "21\.1\.235" -and $_.CommandLine -match "user_jvm_args")
        }
}

$config = Read-WatchdogConfig -Path $ConfigPath
if (-not (Test-Path -LiteralPath $config.resolvedServerDirectory)) {
    throw "Server directory does not exist: $($config.resolvedServerDirectory)"
}
$latestLogPath = Join-Path $config.resolvedServerDirectory "logs\latest.log"

$existing = @(Get-SimbaServerJavaProcesses -ServerDirectory $config.resolvedServerDirectory)
if ($existing.Count -gt 0) {
    throw "Refusing to self-test while a Simba server Java process is already running. Stop it first, then run this again."
}

$proc = $null

try {
    $startedAt = Get-Date

    $psi = [System.Diagnostics.ProcessStartInfo]::new()
    $psi.FileName = $config.javaPath
    $psi.Arguments = $config.serverArguments
    $psi.WorkingDirectory = $config.resolvedServerDirectory
    $psi.UseShellExecute = $false
    $psi.RedirectStandardInput = $true
    $psi.RedirectStandardOutput = $false
    $psi.RedirectStandardError = $false
    $psi.CreateNoWindow = $false

    $proc = [System.Diagnostics.Process]::new()
    $proc.StartInfo = $psi
    $proc.EnableRaisingEvents = $true

    [void]$proc.Start()

    $deadline = (Get-Date).AddSeconds($ReadyTimeoutSeconds)
    $readyLine = $null
    while ((Get-Date) -lt $deadline -and -not $proc.HasExited -and -not $readyLine) {
        if (Test-Path -LiteralPath $latestLogPath) {
            $latestLog = Get-Item -LiteralPath $latestLogPath
            if ($latestLog.LastWriteTime -ge $startedAt.AddSeconds(-2)) {
                $readyLine = Select-String -LiteralPath $latestLogPath -Pattern 'Done \([0-9.]+s\)! For help, type "help"' -ErrorAction SilentlyContinue | Select-Object -Last 1
            }
        }
        Start-Sleep -Milliseconds 500
    }

    if ($proc.HasExited) {
        $tail = if (Test-Path -LiteralPath $latestLogPath) { (Get-Content -Tail 40 -LiteralPath $latestLogPath) -join [Environment]::NewLine } else { "" }
        throw "Server exited before ready. Last output:`n$tail"
    }

    if (-not $readyLine) {
        $tail = if (Test-Path -LiteralPath $latestLogPath) { (Get-Content -Tail 40 -LiteralPath $latestLogPath) -join [Environment]::NewLine } else { "" }
        throw "Server did not reach ready within $ReadyTimeoutSeconds seconds. Latest log tail:`n$tail"
    }

    $proc.StandardInput.WriteLine("stop")
    $proc.StandardInput.Flush()

    if (-not $proc.WaitForExit($StopTimeoutSeconds * 1000)) {
        throw "Server reached ready but did not stop within $StopTimeoutSeconds seconds."
    }

    $leftoverDeadline = (Get-Date).AddSeconds(20)
    do {
        Start-Sleep -Milliseconds 500
        $leftover = @(Get-SimbaServerJavaProcesses -ServerDirectory $config.resolvedServerDirectory)
    } while ($leftover.Count -gt 0 -and (Get-Date) -lt $leftoverDeadline)

    if ($leftover.Count -gt 0) {
        throw "Server stopped, but $($leftover.Count) Simba Java process(es) are still visible."
    }

    "WATCHDOG_SERVER_SELFTEST_OK"
}
finally {
    if ($proc -and -not $proc.HasExited) {
        try {
            $proc.StandardInput.WriteLine("stop")
            $proc.StandardInput.Flush()
            if (-not $proc.WaitForExit(30000)) {
                $proc.Kill($true)
            }
        }
        catch {
            try { $proc.Kill($true) } catch { try { $proc.Kill() } catch {} }
        }
    }
}
