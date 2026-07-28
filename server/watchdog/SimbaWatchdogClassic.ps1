param(
    [string]$ConfigPath = (Join-Path $PSScriptRoot "watchdog-config.json"),
    [switch]$SmokeTest
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"

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
    $config | Add-Member -NotePropertyName resolvedLogDirectory -NotePropertyValue (Join-Path $serverDir "logs") -Force
    $config | Add-Member -NotePropertyName latestLogPath -NotePropertyValue (Join-Path $serverDir "logs\latest.log") -Force
    $config | Add-Member -NotePropertyName watchdogLogPath -NotePropertyValue (Join-Path $PSScriptRoot "logs\watchdog-events.log") -Force
    return $config
}

$Config = Read-WatchdogConfig -Path $ConfigPath
New-Item -ItemType Directory -Force -Path $Config.resolvedLogDirectory | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Config.watchdogLogPath) | Out-Null

$script:ServerProcess = $null
$script:ServerStartedAt = $null
$script:LastReadyAt = $null
$script:LastRestartAt = [datetime]::MinValue
$script:RestartHistory = New-Object System.Collections.ArrayList
$script:KeepAlive = [bool]$Config.keepAliveOnOpen
$script:ManualStopRequested = $false
$script:ExitRequested = $false
$script:InputBuffer = ""
$script:OutputQueue = [System.Collections.Concurrent.ConcurrentQueue[string]]::new()
$script:LastStatusAt = [datetime]::MinValue
$script:LastLineWasPrompt = $false

function Write-WatchdogEvent {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    $line = "{0} [{1}] {2}" -f (Get-Date).ToString("yyyy-MM-dd HH:mm:ss"), $Level, $Message
    Add-Content -LiteralPath $Config.watchdogLogPath -Value $line
    [void]$script:OutputQueue.Enqueue("[WATCHDOG][$Level] $Message")
}

function Clear-CurrentInputLine {
    try {
        $width = [Math]::Max(20, [Console]::WindowWidth - 1)
        [Console]::Write("`r" + (" " * $width) + "`r")
    }
    catch {
        Write-Host ""
    }
}

function Write-Prompt {
    try {
        [Console]::Write("`rserver> $script:InputBuffer")
        $script:LastLineWasPrompt = $true
    }
    catch {}
}

function Write-ConsoleLine {
    param([string]$Line)
    Clear-CurrentInputLine
    Write-Host $Line
    Write-Prompt
}

function Show-Banner {
    Clear-Host
    Write-Host "===================================================================" -ForegroundColor Cyan
    Write-Host "   _____ _           _             _____                _          " -ForegroundColor Cyan
    Write-Host "  / ____(_)         | |           / ____|              | |         " -ForegroundColor Cyan
    Write-Host " | (___  _ _ __ ___ | |__   __ _ | |     _ __ ___  __ _| |_ ___    " -ForegroundColor Cyan
    Write-Host "  \___ \| | '_ \` _ \| '_ \ / _\` || |    | '__/ _ \/ _\` | __/ _ \   " -ForegroundColor Cyan
    Write-Host "  ____) | | | | | | | |_) | (_| || |____| | |  __/ (_| | ||  __/   " -ForegroundColor Cyan
    Write-Host " |_____/|_|_| |_| |_|_.__/ \__,_| \_____|_|  \___|\__,_|\__\___|   " -ForegroundColor Cyan
    Write-Host "                                                                    " -ForegroundColor Cyan
    Write-Host "             CLASSIC SERVER WATCHDOG - LIVE CONSOLE MODE            " -ForegroundColor Yellow
    Write-Host "===================================================================" -ForegroundColor Cyan
    Write-Host "Commands: .start  .stop  .restart  .backup  .status  .keepalive  .help  .quit"
    Write-Host "Minecraft commands do not need a dot. Example: say hello friends"
    Write-Host "-------------------------------------------------------------------"
}

function Test-TcpPort {
    param(
        [string]$HostName = "127.0.0.1",
        [int]$Port
    )
    $client = [System.Net.Sockets.TcpClient]::new()
    try {
        $iar = $client.BeginConnect($HostName, $Port, $null, $null)
        if (-not $iar.AsyncWaitHandle.WaitOne(1000, $false)) { return $false }
        $client.EndConnect($iar)
        return $true
    }
    catch {
        return $false
    }
    finally {
        $client.Close()
    }
}

function Get-ManagedProcess {
    if ($script:ServerProcess -and -not $script:ServerProcess.HasExited) {
        return $script:ServerProcess
    }
    return $null
}

function Get-LogAgeSeconds {
    if (-not (Test-Path -LiteralPath $Config.latestLogPath)) {
        return [double]::PositiveInfinity
    }
    return ((Get-Date) - (Get-Item -LiteralPath $Config.latestLogPath).LastWriteTime).TotalSeconds
}

function Test-ServerReadyFromLog {
    if (-not (Test-Path -LiteralPath $Config.latestLogPath)) { return $false }
    $readyLine = Select-String -LiteralPath $Config.latestLogPath -Pattern 'Done \([0-9.]+s\)! For help, type "help"' -ErrorAction SilentlyContinue | Select-Object -Last 1
    return ($null -ne $readyLine)
}

function Format-Age {
    param([double]$Seconds)
    if ([double]::IsPositiveInfinity($Seconds)) { return "missing" }
    if ($Seconds -lt 60) { return ("{0:N0}s" -f $Seconds) }
    if ($Seconds -lt 3600) { return ("{0:N1}m" -f ($Seconds / 60)) }
    return ("{0:N1}h" -f ($Seconds / 3600))
}

function Test-RestartAllowed {
    $now = Get-Date
    $recentRestarts = @($script:RestartHistory | Where-Object { ($now - $_).TotalHours -lt 1 })
    $script:RestartHistory = New-Object System.Collections.ArrayList
    foreach ($restart in $recentRestarts) {
        [void]$script:RestartHistory.Add($restart)
    }

    if ($script:RestartHistory.Count -ge [int]$Config.maxRestartsPerHour) {
        Write-WatchdogEvent "Restart blocked: max restarts per hour reached." "ERROR"
        return $false
    }

    if (($now - $script:LastRestartAt).TotalSeconds -lt [int]$Config.restartCooldownSeconds) {
        return $false
    }

    return $true
}

function Start-Server {
    param([string]$Reason = "Manual start")
    throw "The legacy watchdog is disabled for production because it can launch Minecraft without its visible server GUI. Use SimbaWatchdog.ps1 instead."

    if (Get-ManagedProcess) {
        Write-WatchdogEvent "Start skipped: server is already running." "WARN"
        return
    }

    $script:ManualStopRequested = $false

    $psi = [System.Diagnostics.ProcessStartInfo]::new()
    $psi.FileName = $Config.javaPath
    $psi.Arguments = $Config.serverArguments
    $psi.WorkingDirectory = $Config.resolvedServerDirectory
    $psi.UseShellExecute = $false
    $psi.RedirectStandardInput = $true
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.CreateNoWindow = $false

    $proc = [System.Diagnostics.Process]::new()
    $proc.StartInfo = $psi
    $proc.EnableRaisingEvents = $true
    $proc.add_OutputDataReceived({
        param($sender, $eventArgs)
        if ($null -ne $eventArgs.Data) {
            [void]$script:OutputQueue.Enqueue($eventArgs.Data)
        }
    })
    $proc.add_ErrorDataReceived({
        param($sender, $eventArgs)
        if ($null -ne $eventArgs.Data) {
            [void]$script:OutputQueue.Enqueue("[stderr] " + $eventArgs.Data)
        }
    })
    $proc.add_Exited({
        [void]$script:OutputQueue.Enqueue("[WATCHDOG][WARN] Server process exited.")
    })

    [void]$proc.Start()
    $proc.BeginOutputReadLine()
    $proc.BeginErrorReadLine()

    $script:ServerProcess = $proc
    $script:ServerStartedAt = Get-Date
    $script:LastReadyAt = $null
    Write-WatchdogEvent "Started $($Config.serverName). Reason: $Reason"
}

function Send-ServerCommand {
    param([string]$Command)
    $proc = Get-ManagedProcess
    if (-not $proc) {
        Write-WatchdogEvent "Cannot send command; server is not running: $Command" "WARN"
        return
    }

    if ($Command.Trim().ToLowerInvariant() -eq "stop") {
        $script:ManualStopRequested = $true
    }

    try {
        $proc.StandardInput.WriteLine($Command)
        $proc.StandardInput.Flush()
        Write-WatchdogEvent "Sent command: $Command"
    }
    catch {
        Write-WatchdogEvent "Failed to send command '$Command': $($_.Exception.Message)" "ERROR"
    }
}

function Stop-Server {
    param([string]$Reason = "Manual stop")
    $proc = Get-ManagedProcess
    if (-not $proc) {
        Write-WatchdogEvent "Stop skipped: server is not running." "WARN"
        return
    }

    $script:ManualStopRequested = $true
    Write-WatchdogEvent "Stopping server. Reason: $Reason"
    Send-ServerCommand "stop"

    $deadline = (Get-Date).AddSeconds([int]$Config.stopTimeoutSeconds)
    while ((Get-Date) -lt $deadline -and -not $proc.HasExited) {
        Drain-ServerOutput
        Start-Sleep -Milliseconds 250
    }

    if (-not $proc.HasExited) {
        Write-WatchdogEvent "Graceful stop timed out. Force-killing server process." "ERROR"
        try { $proc.Kill($true) } catch { try { $proc.Kill() } catch {} }
    }

    $script:ServerProcess = $null
}

function Restart-Server {
    param([string]$Reason = "Manual restart")
    Stop-Server -Reason $Reason
    Start-Sleep -Seconds 3
    Start-Server -Reason $Reason
    $script:LastRestartAt = Get-Date
    [void]$script:RestartHistory.Add($script:LastRestartAt)
}

function Show-Status {
    $proc = Get-ManagedProcess
    $portOpen = Test-TcpPort -Port ([int]$Config.serverPort)
    $logAge = Get-LogAgeSeconds
    $ready = Test-ServerReadyFromLog
    $uptime = "stopped"
    if ($proc -and $script:ServerStartedAt) {
        $uptime = ((Get-Date) - $script:ServerStartedAt).ToString("dd\.hh\:mm\:ss")
    }

    Write-ConsoleLine ("[STATUS] process={0} port={1} ready={2} logAge={3} uptime={4} keepAlive={5} restartsThisHour={6}/{7}" -f `
        $(if ($proc) { "running pid $($proc.Id)" } else { "stopped" }),
        $(if ($portOpen) { "open" } else { "closed" }),
        $(if ($ready) { "yes" } else { "no" }),
        (Format-Age $logAge),
        $uptime,
        $script:KeepAlive,
        $script:RestartHistory.Count,
        $Config.maxRestartsPerHour)
}

function Drain-ServerOutput {
    $line = $null
    while ($script:OutputQueue.TryDequeue([ref]$line)) {
        Write-ConsoleLine $line
        $line = $null
    }
}

function Invoke-KeepAliveCheck {
    if (-not $script:KeepAlive) { return }

    $proc = Get-ManagedProcess
    $portOpen = Test-TcpPort -Port ([int]$Config.serverPort)
    $logAge = Get-LogAgeSeconds
    $ready = Test-ServerReadyFromLog
    $now = Get-Date

    if ($ready -and -not $script:LastReadyAt) {
        $script:LastReadyAt = $now
        Write-WatchdogEvent "Server reported ready."
    }

    if (-not $proc) {
        if ((-not $script:ManualStopRequested) -and (Test-RestartAllowed)) {
            Restart-Server -Reason "Keep Alive: process is not running"
        }
        return
    }

    $inStartupGrace = $script:ServerStartedAt -and (($now - $script:ServerStartedAt).TotalSeconds -lt [int]$Config.startupGraceSeconds)
    if ($inStartupGrace) { return }

    if (-not $portOpen -and $logAge -gt [int]$Config.logStaleSeconds) {
        if (Test-RestartAllowed) {
            Restart-Server -Reason "Keep Alive: port closed and latest log is stale"
        }
        return
    }

    if ($ready -and $logAge -gt ([int]$Config.logStaleSeconds * 2)) {
        if (Test-RestartAllowed) {
            Restart-Server -Reason "Keep Alive: latest log has been stale too long"
        }
    }
}

function Invoke-WatchdogCommand {
    param([string]$Command)
    $cmd = $Command.Trim()
    if ($cmd.Length -eq 0) { return }

    switch -Regex ($cmd) {
        '^\.help$' {
            Write-ConsoleLine "Watchdog commands: .start .stop .restart .backup .status .keepalive .quit"
            Write-ConsoleLine "Anything else is sent to Minecraft. Example: say Server restart in 5 minutes"
        }
        '^\.start$' { Start-Server -Reason "Manual start" }
        '^\.stop$' { Stop-Server -Reason "Manual stop" }
        '^\.restart$' { Restart-Server -Reason "Manual restart" }
        '^\.backup$' { Send-ServerCommand $Config.backupCommand }
        '^\.status$' { Show-Status }
        '^\.keepalive$' {
            $script:KeepAlive = -not $script:KeepAlive
            Write-WatchdogEvent "Keep Alive set to $script:KeepAlive"
        }
        '^\.quit$' {
            if (Get-ManagedProcess) {
                Stop-Server -Reason "Watchdog quit"
            }
            $script:ExitRequested = $true
        }
        default {
            Send-ServerCommand $cmd
        }
    }
}

function Read-ConsoleInput {
    while ([Console]::KeyAvailable) {
        $key = [Console]::ReadKey($true)
        switch ($key.Key) {
            "Enter" {
                Clear-CurrentInputLine
                Write-Host "server> $script:InputBuffer"
                $command = $script:InputBuffer
                $script:InputBuffer = ""
                Invoke-WatchdogCommand $command
                Write-Prompt
            }
            "Backspace" {
                if ($script:InputBuffer.Length -gt 0) {
                    $script:InputBuffer = $script:InputBuffer.Substring(0, $script:InputBuffer.Length - 1)
                    Clear-CurrentInputLine
                    Write-Prompt
                }
            }
            default {
                if (-not [char]::IsControl($key.KeyChar)) {
                    $script:InputBuffer += $key.KeyChar
                    [Console]::Write($key.KeyChar)
                }
            }
        }
    }
}

if ($SmokeTest) {
    if (-not (Test-Path -LiteralPath $Config.resolvedServerDirectory)) {
        throw "Server directory does not exist: $($Config.resolvedServerDirectory)"
    }
    "CLASSIC_WATCHDOG_SMOKE_TEST_OK"
    return
}

$Host.UI.RawUI.WindowTitle = "$($Config.serverName) Classic Watchdog"
Show-Banner
Write-WatchdogEvent "Classic watchdog opened."
Write-Prompt

if ([bool]$Config.autoStartOnOpen) {
    Start-Server -Reason "Auto-start on watchdog open"
}

while (-not $script:ExitRequested) {
    Drain-ServerOutput
    Read-ConsoleInput
    Invoke-KeepAliveCheck

    if (((Get-Date) - $script:LastStatusAt).TotalSeconds -ge 30) {
        $script:LastStatusAt = Get-Date
        Show-Status
    }

    Start-Sleep -Milliseconds 100
}

Write-WatchdogEvent "Classic watchdog closed."
Write-Host ""
