param(
    [string]$ConfigPath = (Join-Path $PSScriptRoot "watchdog-config.json"),
    [switch]$SmokeTest,
    [string]$PreviewPng,
    [int]$AutoCloseSeconds = 0
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type @"
using System;
using System.Runtime.InteropServices;

public static class NativeIcon {
    [DllImport("Shell32.dll", CharSet=CharSet.Auto)]
    public static extern uint ExtractIconEx(string szFileName, int nIconIndex, IntPtr[] phiconLarge, IntPtr[] phiconSmall, uint nIcons);

    [DllImport("user32.dll", SetLastError=true)]
    public static extern bool DestroyIcon(IntPtr hIcon);
}
"@
[System.Windows.Forms.Application]::EnableVisualStyles()

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
$script:LastCpuTotal = $null
$script:LastCpuSampleAt = $null
$script:LastCpuPercent = 0.0
$script:OutputQueue = [System.Collections.Concurrent.ConcurrentQueue[string]]::new()
$script:ManualStopRequested = $false
$script:ArmedForKeepAlive = [bool]$Config.autoStartOnOpen
$script:LastAction = "Dashboard opened."
$script:LastConsoleAppendAt = [datetime]::MinValue
$script:CommandHistory = New-Object System.Collections.ArrayList
$script:CommandHistoryIndex = -1
$script:PreviewMode = [bool]$PreviewPng

$script:Form = $null
$script:ConsoleBox = $null
$script:CommandBox = $null
$script:EventList = $null
$script:StatusBadge = $null
$script:ProcessValue = $null
$script:PortValue = $null
$script:ReadyValue = $null
$script:UptimeValue = $null
$script:MemoryValue = $null
$script:CpuValue = $null
$script:LogAgeValue = $null
$script:RestartsValue = $null
$script:KeepAliveToggle = $null
$script:StartButton = $null
$script:StopButton = $null
$script:RestartButton = $null
$script:BackupButton = $null
$script:SendButton = $null
$script:QuickCommandButtons = @()
$script:ActionValue = $null
$script:FooterStatus = $null
$script:ConfigSummary = $null
$script:ConsoleModeNotice = $null

function Get-ConfigValue {
    param(
        [string]$Name,
        $Default
    )
    if ($Config.PSObject.Properties.Name -contains $Name) {
        return $Config.$Name
    }
    return $Default
}

function Test-ConsoleWindowMode {
    # Production policy: the live terminal and Minecraft server GUI must always be visible.
    return $true
}

function Write-WatchdogEvent {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )

    $line = "{0} [{1}] {2}" -f (Get-Date).ToString("yyyy-MM-dd HH:mm:ss"), $Level, $Message
    Add-Content -LiteralPath $Config.watchdogLogPath -Value $line
    [void]$script:OutputQueue.Enqueue("[watchdog][$Level] $Message")

    if ($script:EventList) {
        $script:EventList.Items.Insert(0, $line)
        while ($script:EventList.Items.Count -gt 250) {
            $script:EventList.Items.RemoveAt($script:EventList.Items.Count - 1)
        }
    }
}

function Invoke-UiAction {
    param(
        [string]$Name,
        [scriptblock]$Action
    )
    try {
        & $Action
    }
    catch {
        $message = "$Name failed: $($_.Exception.Message)"
        Write-WatchdogEvent $message "ERROR"
        [System.Windows.Forms.MessageBox]::Show(
            $message,
            "Watchdog action failed",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        ) | Out-Null
    }
}

function Append-ConsoleLine {
    param([string]$Line)
    if (-not $script:ConsoleBox) { return }

    $prefix = (Get-Date).ToString("HH:mm:ss")
    $script:ConsoleBox.AppendText("[$prefix] $Line`r`n")
    $script:ConsoleBox.SelectionStart = $script:ConsoleBox.TextLength
    $script:ConsoleBox.ScrollToCaret()

    if ($script:ConsoleBox.TextLength -gt 800000) {
        $script:ConsoleBox.Text = $script:ConsoleBox.Text.Substring([Math]::Max(0, $script:ConsoleBox.TextLength - 500000))
        $script:ConsoleBox.SelectionStart = $script:ConsoleBox.TextLength
        $script:ConsoleBox.ScrollToCaret()
    }
}

function Drain-OutputQueue {
    $line = $null
    while ($script:OutputQueue.TryDequeue([ref]$line)) {
        Append-ConsoleLine $line
        $line = $null
    }
}

function Test-TcpPort {
    param(
        [string]$HostName = "127.0.0.1",
        [int]$Port
    )

    $client = [System.Net.Sockets.TcpClient]::new()
    try {
        $iar = $client.BeginConnect($HostName, $Port, $null, $null)
        if (-not $iar.AsyncWaitHandle.WaitOne(900, $false)) { return $false }
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

function Get-ExternalServerProcesses {
    $serverDir = [regex]::Escape($Config.resolvedServerDirectory)
    Get-CimInstance Win32_Process -Filter "name = 'java.exe'" -ErrorAction SilentlyContinue |
        Where-Object { $_.CommandLine -match $serverDir -or ($_.CommandLine -match "neoforge" -and $_.CommandLine -match "user_jvm_args") }
}

function Get-AnyServerProcesses {
    @(Get-ExternalServerProcesses)
}

function Close-ConsoleLauncher {
    $proc = Get-ManagedProcess
    if (-not $proc) { return }
    try {
        Write-WatchdogEvent "Closing watchdog-launched console window."
        & taskkill.exe /PID $proc.Id /T /F | Out-Null
    }
    catch {
        try { $proc.Kill($true) } catch { try { $proc.Kill() } catch {} }
    }
    $script:ServerProcess = $null
}

function New-ConsoleLaunchScript {
    $scriptPath = Join-Path $PSScriptRoot "Start_Simba_Server_Console.bat"
    $windowTitle = (Get-ConfigValue -Name "consoleWindowTitle" -Default "$($Config.serverName) - Live Server Console").ToString()
    $serverArguments = ($Config.serverArguments -replace '(?i)(^|\\s)nogui(?=\\s|$)', '').Trim()
    $content = @"
@echo off
title $windowTitle
cd /d "$($Config.resolvedServerDirectory)"
echo ===============================================================
echo  $($Config.serverName)
echo  Minecraft server launcher
echo ===============================================================
echo.
echo The Minecraft server GUI should open when Java finishes loading.
echo You can also type Minecraft server commands here. Use stop for graceful shutdown.
echo The watchdog control panel may stay open beside this window.
echo.
$($Config.javaPath) $serverArguments
echo.
echo Server process exited with code %ERRORLEVEL%.
echo This console is intentionally left open for troubleshooting.
pause
"@
    Set-Content -LiteralPath $scriptPath -Value $content -Encoding ASCII
    return $scriptPath
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
    if ($Seconds -lt 60) { return ("{0:N0}s ago" -f $Seconds) }
    if ($Seconds -lt 3600) { return ("{0:N1}m ago" -f ($Seconds / 60)) }
    return ("{0:N1}h ago" -f ($Seconds / 3600))
}

function Get-ProcessMetrics {
    $proc = Get-ManagedProcess
    if (-not $proc) {
        return @{ MemoryMb = 0; CpuPercent = 0.0 }
    }

    try {
        $proc.Refresh()
        $now = Get-Date
        $cpuTotal = $proc.TotalProcessorTime.TotalSeconds
        if ($script:LastCpuTotal -ne $null -and $script:LastCpuSampleAt -ne $null) {
            $elapsed = ($now - $script:LastCpuSampleAt).TotalSeconds
            if ($elapsed -gt 0) {
                $delta = $cpuTotal - $script:LastCpuTotal
                $script:LastCpuPercent = [Math]::Round(($delta / $elapsed) * 100 / [Environment]::ProcessorCount, 1)
            }
        }
        $script:LastCpuTotal = $cpuTotal
        $script:LastCpuSampleAt = $now
        return @{
            MemoryMb = [Math]::Round($proc.WorkingSet64 / 1MB, 0)
            CpuPercent = $script:LastCpuPercent
        }
    }
    catch {
        return @{ MemoryMb = 0; CpuPercent = 0.0 }
    }
}

function Send-ServerCommand {
    param([string]$Command)
    $cmd = $Command.Trim()
    if ($cmd.Length -eq 0) { return $false }

    if (Test-ConsoleWindowMode) {
        Write-WatchdogEvent "Command '$cmd' was not sent from the UI because console-window mode is active. Type it in the live server console window." "WARN"
        return $false
    }

    $proc = Get-ManagedProcess
    if (-not $proc) {
        Write-WatchdogEvent "Cannot send command because the managed server is not running: $cmd" "WARN"
        return $false
    }

    if ($cmd.ToLowerInvariant() -eq "stop") {
        $script:ManualStopRequested = $true
        $script:ArmedForKeepAlive = $false
    }

    try {
        $proc.StandardInput.WriteLine($cmd)
        $proc.StandardInput.Flush()
        Write-WatchdogEvent "Sent command: $cmd"
        return $true
    }
    catch {
        Write-WatchdogEvent "Failed to send command '$cmd': $($_.Exception.Message)" "ERROR"
        return $false
    }
}

function Invoke-CommandBox {
    $cmd = $script:CommandBox.Text.Trim()
    if ($cmd.Length -eq 0) { return }

    [void]$script:CommandHistory.Add($cmd)
    while ($script:CommandHistory.Count -gt 80) {
        $script:CommandHistory.RemoveAt(0)
    }
    $script:CommandHistoryIndex = $script:CommandHistory.Count
    [void](Send-ServerCommand $cmd)
    $script:CommandBox.Clear()
}

function Start-Server {
    param([string]$Reason = "Manual start")
    if (Get-ManagedProcess) {
        Write-WatchdogEvent "Start skipped because the server is already running." "WARN"
        return
    }
    if ((Test-ConsoleWindowMode) -and @(Get-AnyServerProcesses).Count -gt 0) {
        Write-WatchdogEvent "Start skipped because a Simba server Java process is already running." "WARN"
        return
    }

    if (-not (Test-Path -LiteralPath $Config.resolvedServerDirectory)) {
        throw "Server directory does not exist: $($Config.resolvedServerDirectory)"
    }

    $script:ManualStopRequested = $false
    $script:ArmedForKeepAlive = $true
    $script:LastAction = $Reason

    if (Test-ConsoleWindowMode) {
        $launcher = New-ConsoleLaunchScript
        $psi = [System.Diagnostics.ProcessStartInfo]::new()
        $psi.FileName = "cmd.exe"
        $psi.Arguments = "/k call `"$launcher`""
        $psi.WorkingDirectory = $Config.resolvedServerDirectory
        $psi.UseShellExecute = $true
        $psi.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Normal

        $proc = [System.Diagnostics.Process]::Start($psi)
        $script:ServerProcess = $proc
        $script:ServerStartedAt = Get-Date
        $script:LastReadyAt = $null
        $script:LastCpuTotal = $null
        $script:LastCpuSampleAt = $null
        $script:LastCpuPercent = 0.0
        Write-WatchdogEvent "Opened server launcher for $($Config.serverName). Reason: $Reason"
        [void]$script:OutputQueue.Enqueue("[watchdog][INFO] Server launcher opened in a separate window.")
        [void]$script:OutputQueue.Enqueue("[watchdog][INFO] Java GUI mode is enabled. The Minecraft server window should appear after startup.")
        return
    }

    throw "Hidden server launches are disabled. Start the server through the visible console-window launcher."
}

function Stop-Server {
    param([string]$Reason = "Manual stop")
    $proc = Get-ManagedProcess
    if (-not $proc) {
        Write-WatchdogEvent "Stop skipped because no managed server is running." "WARN"
        $script:ManualStopRequested = $true
        $script:ArmedForKeepAlive = $false
        return
    }

    $script:ManualStopRequested = $true
    $script:ArmedForKeepAlive = $false
    $script:LastAction = $Reason

    if (Test-ConsoleWindowMode) {
        Write-WatchdogEvent "Stop requested in console-window mode. Type 'stop' in the live server console for graceful shutdown." "WARN"
        [System.Windows.Forms.MessageBox]::Show(
            "The server is running in its own live console window.`r`n`r`nType stop in that console for a graceful shutdown.`r`n`r`nThe watchdog will keep monitoring it.",
            "Use the live server console",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information
        ) | Out-Null
        return
    }

    Write-WatchdogEvent "Stopping server gracefully. Reason: $Reason"
    [void](Send-ServerCommand "stop")

    $deadline = (Get-Date).AddSeconds([int]$Config.stopTimeoutSeconds)
    while ((Get-Date) -lt $deadline -and -not $proc.HasExited) {
        [System.Windows.Forms.Application]::DoEvents()
        Drain-OutputQueue
        Start-Sleep -Milliseconds 200
    }

    if (-not $proc.HasExited) {
        Write-WatchdogEvent "Graceful stop timed out. Force-killing server process." "ERROR"
        try { $proc.Kill($true) } catch { try { $proc.Kill() } catch {} }
    }

    $script:ServerProcess = $null
}

function Restart-Server {
    param([string]$Reason = "Manual restart")
    if (Test-ConsoleWindowMode) {
        $external = @(Get-AnyServerProcesses)
        if ($external.Count -gt 0) {
            Write-WatchdogEvent "Restart requested in console-window mode. Type 'stop' in the live server console, then press Start again." "WARN"
            [System.Windows.Forms.MessageBox]::Show(
                "Console-window mode keeps the real server terminal visible.`r`n`r`nFor a graceful restart, type stop in the live server console. When it finishes, press Start Server again.",
                "Restart from live console",
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Information
            ) | Out-Null
            return
        }
        Close-ConsoleLauncher
        Start-Server -Reason $Reason
        $script:LastRestartAt = Get-Date
        [void]$script:RestartHistory.Add($script:LastRestartAt)
        return
    }
    Stop-Server -Reason $Reason
    Start-Sleep -Seconds 2
    $script:ManualStopRequested = $false
    Start-Server -Reason $Reason
    $script:LastRestartAt = Get-Date
    [void]$script:RestartHistory.Add($script:LastRestartAt)
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

function Invoke-KeepAliveCheck {
    if (-not $script:KeepAliveToggle.Checked) { return }
    if (-not $script:ArmedForKeepAlive) { return }

    $now = Get-Date
    $managed = Get-ManagedProcess
    $external = @(Get-AnyServerProcesses)
    $portOpen = Test-TcpPort -Port ([int]$Config.serverPort)
    $logAge = Get-LogAgeSeconds
    $ready = Test-ServerReadyFromLog

    if ($ready -and -not $script:LastReadyAt) {
        $script:LastReadyAt = $now
        Write-WatchdogEvent "Server reported ready."
    }

    if ((Test-ConsoleWindowMode) -and $external.Count -gt 0) {
        return
    }

    if (-not $managed) {
        if (-not $script:ManualStopRequested -and (Test-RestartAllowed)) {
            Restart-Server -Reason "Keep Alive: managed process is not running"
        }
        return
    }

    $inStartupGrace = $script:ServerStartedAt -and (($now - $script:ServerStartedAt).TotalSeconds -lt [int]$Config.startupGraceSeconds)
    if ($inStartupGrace) { return }

    if (-not $portOpen -and $logAge -gt [int]$Config.logStaleSeconds) {
        if (Test-RestartAllowed) {
            Restart-Server -Reason "Keep Alive: port closed and log stale"
        }
        return
    }

    if ($ready -and $logAge -gt ([int]$Config.logStaleSeconds * 2)) {
        if (Test-RestartAllowed) {
            Restart-Server -Reason "Keep Alive: latest log has been stale too long"
        }
    }
}

function Set-ValueLabel {
    param(
        [System.Windows.Forms.Label]$Label,
        [string]$Text,
        [System.Drawing.Color]$Color
    )
    $Label.Text = $Text
    $Label.ForeColor = $Color
}

function New-XpIcon {
    param([string]$Kind)

    $bmp = [System.Drawing.Bitmap]::new(24, 24, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.Clear([System.Drawing.Color]::Transparent)

    $shadow = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(55, 0, 0, 0))
    $outline = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(70, 85, 115), 1)
    $white = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(210, 255, 255, 255), 1)

    try {
        switch ($Kind) {
            "start" {
                $brush = [System.Drawing.Drawing2D.LinearGradientBrush]::new([System.Drawing.Rectangle]::new(3, 3, 18, 18), [System.Drawing.Color]::FromArgb(118, 214, 91), [System.Drawing.Color]::FromArgb(25, 128, 47), 90)
                $g.FillEllipse($shadow, 4, 5, 17, 17)
                $g.FillEllipse($brush, 3, 3, 18, 18)
                $g.DrawEllipse($outline, 3, 3, 18, 18)
                $g.DrawLine($white, 7, 6, 12, 4)
                $tri = [System.Drawing.Point[]]@([System.Drawing.Point]::new(10, 8), [System.Drawing.Point]::new(10, 16), [System.Drawing.Point]::new(16, 12))
                $g.FillPolygon([System.Drawing.Brushes]::White, $tri)
                $brush.Dispose()
            }
            "stop" {
                $brush = [System.Drawing.Drawing2D.LinearGradientBrush]::new([System.Drawing.Rectangle]::new(3, 3, 18, 18), [System.Drawing.Color]::FromArgb(245, 107, 92), [System.Drawing.Color]::FromArgb(174, 34, 34), 90)
                $g.FillEllipse($shadow, 4, 5, 17, 17)
                $g.FillEllipse($brush, 3, 3, 18, 18)
                $g.DrawEllipse($outline, 3, 3, 18, 18)
                $g.FillRectangle([System.Drawing.Brushes]::White, 8, 8, 8, 8)
                $brush.Dispose()
            }
            "restart" {
                $brush = [System.Drawing.Drawing2D.LinearGradientBrush]::new([System.Drawing.Rectangle]::new(3, 3, 18, 18), [System.Drawing.Color]::FromArgb(126, 178, 255), [System.Drawing.Color]::FromArgb(34, 86, 190), 90)
                $g.FillEllipse($shadow, 4, 5, 17, 17)
                $g.FillEllipse($brush, 3, 3, 18, 18)
                $g.DrawEllipse($outline, 3, 3, 18, 18)
                $arcPen = [System.Drawing.Pen]::new([System.Drawing.Color]::White, 2)
                $g.DrawArc($arcPen, 7, 7, 10, 10, 35, 260)
                $head = [System.Drawing.Point[]]@([System.Drawing.Point]::new(16, 7), [System.Drawing.Point]::new(18, 12), [System.Drawing.Point]::new(13, 11))
                $g.FillPolygon([System.Drawing.Brushes]::White, $head)
                $arcPen.Dispose()
                $brush.Dispose()
            }
            "backup" {
                $g.FillRectangle($shadow, 5, 5, 15, 15)
                $brush = [System.Drawing.Drawing2D.LinearGradientBrush]::new([System.Drawing.Rectangle]::new(4, 3, 15, 17), [System.Drawing.Color]::FromArgb(255, 221, 103), [System.Drawing.Color]::FromArgb(194, 127, 22), 90)
                $g.FillRectangle($brush, 4, 3, 15, 17)
                $g.DrawRectangle($outline, 4, 3, 15, 17)
                $g.FillRectangle([System.Drawing.Brushes]::White, 7, 6, 9, 4)
                $g.DrawRectangle([System.Drawing.Pens]::SaddleBrown, 7, 14, 9, 4)
                $brush.Dispose()
            }
            "folder" {
                $g.FillRectangle($shadow, 4, 8, 17, 11)
                $g.FillRectangle([System.Drawing.Brushes]::Khaki, 3, 6, 18, 13)
                $g.FillRectangle([System.Drawing.Brushes]::Gold, 5, 4, 8, 5)
                $g.DrawRectangle($outline, 3, 6, 18, 13)
            }
            "logs" {
                $g.FillRectangle($shadow, 6, 5, 13, 16)
                $g.FillRectangle([System.Drawing.Brushes]::WhiteSmoke, 5, 3, 13, 16)
                $g.DrawRectangle($outline, 5, 3, 13, 16)
                $linePen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(45, 100, 210), 1)
                foreach ($y in 7, 10, 13, 16) { $g.DrawLine($linePen, 8, $y, 15, $y) }
                $linePen.Dispose()
            }
            "send" {
                $brush = [System.Drawing.Drawing2D.LinearGradientBrush]::new([System.Drawing.Rectangle]::new(3, 5, 18, 14), [System.Drawing.Color]::FromArgb(162, 205, 255), [System.Drawing.Color]::FromArgb(39, 100, 210), 90)
                $points = [System.Drawing.Point[]]@([System.Drawing.Point]::new(3, 6), [System.Drawing.Point]::new(21, 12), [System.Drawing.Point]::new(3, 18), [System.Drawing.Point]::new(7, 12))
                $g.FillPolygon($brush, $points)
                $g.DrawPolygon($outline, $points)
                $brush.Dispose()
            }
            default {
                $g.FillEllipse([System.Drawing.Brushes]::SteelBlue, 4, 4, 16, 16)
                $g.DrawEllipse($outline, 4, 4, 16, 16)
            }
        }
    }
    finally {
        $shadow.Dispose()
        $outline.Dispose()
        $white.Dispose()
        $g.Dispose()
    }
    return $bmp
}

function Get-ButtonIconKind {
    param([string]$Text)
    switch -Wildcard ($Text) {
        "*Start*" { return "start" }
        "*Stop*" { return "stop" }
        "*Restart*" { return "restart" }
        "*Backup*" { return "backup" }
        "*Folder*" { return "folder" }
        "*Logs*" { return "logs" }
        "*Send*" { return "send" }
        default { return "default" }
    }
}

function Get-ShellIconBitmap {
    param(
        [string]$DllPath,
        [int]$Index
    )

    try {
        if (-not (Test-Path -LiteralPath $DllPath)) { return $null }

        $large = New-Object IntPtr[] 1
        $small = New-Object IntPtr[] 1
        [void][NativeIcon]::ExtractIconEx($DllPath, $Index, $large, $small, 1)
        $handle = if ($small[0] -ne [IntPtr]::Zero) { $small[0] } else { $large[0] }
        if ($handle -eq [IntPtr]::Zero) { return $null }

        $icon = [System.Drawing.Icon]::FromHandle($handle)
        $bmp = $icon.ToBitmap()

        if ($small[0] -ne [IntPtr]::Zero) { [void][NativeIcon]::DestroyIcon($small[0]) }
        if ($large[0] -ne [IntPtr]::Zero) { [void][NativeIcon]::DestroyIcon($large[0]) }
        return $bmp
    }
    catch {
        return $null
    }
}

function Get-FirstShellIcon {
    param([object[]]$Candidates)

    foreach ($candidate in $Candidates) {
        $bitmap = Get-ShellIconBitmap -DllPath $candidate[0] -Index ([int]$candidate[1])
        if ($bitmap) { return $bitmap }
    }
    return $null
}

function Get-WatchdogButtonImage {
    param([string]$Text)

    $shell = Join-Path $env:SystemRoot "System32\shell32.dll"
    $imageres = Join-Path $env:SystemRoot "System32\imageres.dll"
    $moricons = Join-Path $env:SystemRoot "System32\moricons.dll"
    $fallback = Get-ButtonIconKind -Text $Text

    $candidates = switch -Wildcard ($Text) {
        "*Start*" { @(@($shell, 137), @($shell, 167), @($shell, 25), @($imageres, 102), @($moricons, 71)); break }
        "*Stop*" { @(@($shell, 131), @($shell, 109), @($imageres, 93), @($moricons, 87)); break }
        "*Restart*" { @(@($shell, 238), @($shell, 239), @($imageres, 229), @($moricons, 81)); break }
        "*Backup*" { @(@($shell, 6), @($shell, 7), @($shell, 165), @($imageres, 101)); break }
        "*Folder*" { @(@($shell, 3), @($shell, 4), @($imageres, 3)); break }
        "*Logs*" { @(@($shell, 70), @($shell, 152), @($imageres, 2), @($moricons, 1)); break }
        "*Send*" { @(@($shell, 146), @($shell, 147), @($imageres, 114)); break }
        default { @(@($shell, 1), @($imageres, 1)); break }
    }

    $icon = Get-FirstShellIcon -Candidates $candidates
    if ($icon) { return $icon }
    return New-XpIcon -Kind $fallback
}

function Update-Dashboard {
    Drain-OutputQueue

    $managed = Get-ManagedProcess
    $external = @(Get-ExternalServerProcesses)
    $anyServer = [bool]$managed -or ($external.Count -gt 0)
    $portOpen = Test-TcpPort -Port ([int]$Config.serverPort)
    $readyFromLog = Test-ServerReadyFromLog
    $ready = $readyFromLog -and ($portOpen -or $anyServer)
    $logAge = Get-LogAgeSeconds
    $metrics = Get-ProcessMetrics
    $green = [System.Drawing.Color]::FromArgb(37, 156, 94)
    $amber = [System.Drawing.Color]::FromArgb(210, 143, 42)
    $red = [System.Drawing.Color]::FromArgb(210, 72, 72)
    $ink = [System.Drawing.Color]::FromArgb(20, 38, 78)

    if ($managed -and (Test-ConsoleWindowMode)) {
        $script:StatusBadge.Text = $(if ($external.Count -gt 0) { "RUNNING" } else { "CONSOLE" })
        $script:StatusBadge.BackColor = $(if ($external.Count -gt 0) { $green } else { $amber })
        Set-ValueLabel $script:ProcessValue $(if ($external.Count -gt 0) { "Console + Java PID $($external[0].ProcessId)" } else { "Console open, Java not seen" }) $(if ($external.Count -gt 0) { $green } else { $amber })
    }
    elseif ($managed) {
        $script:StatusBadge.Text = "RUNNING"
        $script:StatusBadge.BackColor = $green
        Set-ValueLabel $script:ProcessValue "Managed PID $($managed.Id)" $green
    }
    elseif ($external.Count -gt 0) {
        $script:StatusBadge.Text = "EXTERNAL"
        $script:StatusBadge.BackColor = $amber
        Set-ValueLabel $script:ProcessValue "$($external.Count) external Java process(es)" $amber
    }
    else {
        $script:StatusBadge.Text = "STOPPED"
        $script:StatusBadge.BackColor = $red
        Set-ValueLabel $script:ProcessValue "No managed process" $red
    }

    Set-ValueLabel $script:PortValue $(if ($portOpen) { "Open on $($Config.serverPort)" } else { "Closed" }) $(if ($portOpen) { $green } else { $amber })
    Set-ValueLabel $script:ReadyValue $(if ($ready) { "Ready" } else { "Not ready yet" }) $(if ($ready) { $green } else { $amber })
    Set-ValueLabel $script:LogAgeValue (Format-Age $logAge) $(if ($logAge -lt [int]$Config.logStaleSeconds) { $green } else { $amber })

    $uptime = "Stopped"
    if ($managed -and $script:ServerStartedAt) {
        $uptime = ((Get-Date) - $script:ServerStartedAt).ToString("dd\.hh\:mm\:ss")
    }
    Set-ValueLabel $script:UptimeValue $uptime $ink
    Set-ValueLabel $script:MemoryValue "$($metrics.MemoryMb) MB" $ink
    Set-ValueLabel $script:CpuValue "$($metrics.CpuPercent)%" $ink
    Set-ValueLabel $script:RestartsValue "$($script:RestartHistory.Count) / $($Config.maxRestartsPerHour)" $ink
    $script:ActionValue.Text = $script:LastAction
    $script:FooterStatus.Text = "Server: $($Config.resolvedServerDirectory)     Port: $($Config.serverPort)     Keep Alive: $($script:KeepAliveToggle.Checked)     Auto-start: $($Config.autoStartOnOpen)"

    $script:StartButton.Enabled = -not $anyServer
    $script:StopButton.Enabled = $anyServer
    $script:RestartButton.Enabled = $anyServer
    $script:BackupButton.Enabled = [bool]$managed -and -not (Test-ConsoleWindowMode)
    $script:CommandBox.Enabled = [bool]$managed -and -not (Test-ConsoleWindowMode)
    if ($script:SendButton) {
        $script:SendButton.Enabled = [bool]$managed -and -not (Test-ConsoleWindowMode)
    }
    foreach ($quick in $script:QuickCommandButtons) {
        if ($quick.Text -eq "Track Map") {
            $quick.Enabled = $true
        }
        else {
            $quick.Enabled = [bool]$managed -and -not (Test-ConsoleWindowMode)
        }
    }
    if ($script:ConsoleModeNotice) {
        $script:ConsoleModeNotice.Visible = Test-ConsoleWindowMode
    }

    Invoke-KeepAliveCheck
}

function New-Label {
    param(
        [string]$Text,
        [int]$X,
        [int]$Y,
        [int]$W = 140,
        [int]$H = 22,
        [System.Drawing.Font]$Font = $null,
        [System.Drawing.Color]$Color = $null
    )
    $label = [System.Windows.Forms.Label]::new()
    $label.Text = $Text
    $label.Location = [System.Drawing.Point]::new($X, $Y)
    $label.Size = [System.Drawing.Size]::new($W, $H)
    if ($Font) { $label.Font = $Font }
    if ($Color) { $label.ForeColor = $Color }
    return $label
}

function New-Button {
    param(
        [string]$Text,
        [int]$X,
        [int]$Y,
        [int]$W,
        [scriptblock]$Action
    )
    $button = [System.Windows.Forms.Button]::new()
    $button.Text = $Text
    $button.Location = [System.Drawing.Point]::new($X, $Y)
    $button.Size = [System.Drawing.Size]::new($W, 38)
    $button.FlatStyle = "Standard"
    $button.BackColor = [System.Drawing.Color]::FromArgb(236, 233, 216)
    $button.ForeColor = [System.Drawing.Color]::FromArgb(20, 38, 78)
    $button.TextAlign = "MiddleLeft"
    $button.ImageAlign = "MiddleLeft"
    $button.TextImageRelation = "ImageBeforeText"
    $button.Padding = [System.Windows.Forms.Padding]::new(6, 0, 6, 0)
    $button.Image = Get-WatchdogButtonImage -Text $Text
    $button.Add_Click({ Invoke-UiAction -Name $Text -Action $Action }.GetNewClosure())
    return $button
}

if ($SmokeTest) {
    if (-not (Test-Path -LiteralPath $Config.resolvedServerDirectory)) {
        throw "Server directory does not exist: $($Config.resolvedServerDirectory)"
    }
    "WATCHDOG_UI_SMOKE_TEST_OK"
    return
}

$bg = [System.Drawing.Color]::FromArgb(236, 233, 216)
$panel = [System.Drawing.Color]::FromArgb(214, 232, 255)
$panel2 = [System.Drawing.Color]::FromArgb(248, 251, 255)
$border = [System.Drawing.Color]::FromArgb(115, 143, 205)
$text = [System.Drawing.Color]::FromArgb(20, 38, 78)
$muted = [System.Drawing.Color]::FromArgb(73, 94, 140)
$accent = [System.Drawing.Color]::FromArgb(45, 100, 210)

$font = [System.Drawing.Font]::new("Segoe UI", 10)
$smallFont = [System.Drawing.Font]::new("Segoe UI", 9)
$titleFont = [System.Drawing.Font]::new("Segoe UI Semibold", 18)
$monoFont = [System.Drawing.Font]::new("Consolas", 9)

$script:Form = [System.Windows.Forms.Form]::new()
$script:Form.Text = "$($Config.serverName) Watchdog"
$script:Form.Size = [System.Drawing.Size]::new(1180, 760)
$script:Form.MinimumSize = [System.Drawing.Size]::new(1040, 650)
$script:Form.StartPosition = "CenterScreen"
$script:Form.BackColor = $bg
$script:Form.ForeColor = $text
$script:Form.Font = $font
$script:Form.Icon = [System.Drawing.SystemIcons]::Shield

$top = [System.Windows.Forms.Panel]::new()
$top.Dock = "Top"
$top.Height = 88
$top.BackColor = [System.Drawing.Color]::FromArgb(55, 112, 215)
$top.Add_Paint({
    param($sender, $eventArgs)
    $rect = $sender.ClientRectangle
    $brush = [System.Drawing.Drawing2D.LinearGradientBrush]::new(
        $rect,
        [System.Drawing.Color]::FromArgb(38, 91, 196),
        [System.Drawing.Color]::FromArgb(142, 180, 248),
        [System.Drawing.Drawing2D.LinearGradientMode]::Vertical
    )
    $eventArgs.Graphics.FillRectangle($brush, $rect)
    $brush.Dispose()
    $pen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(25, 65, 150))
    $eventArgs.Graphics.DrawLine($pen, 0, $rect.Height - 1, $rect.Width, $rect.Height - 1)
    $pen.Dispose()
})
$script:Form.Controls.Add($top)

$title = New-Label "$($Config.serverName) Watchdog" 22 16 520 30 $titleFont $text
$title.ForeColor = [System.Drawing.Color]::White
$top.Controls.Add($title)
$subtitle = New-Label "Live console, keepalive, backups, and server control" 24 50 520 22 $smallFont $muted
$subtitle.ForeColor = [System.Drawing.Color]::FromArgb(235, 245, 255)
$top.Controls.Add($subtitle)

$script:StatusBadge = New-Label "STOPPED" 990 25 130 32 ([System.Drawing.Font]::new("Segoe UI Semibold", 11)) $text
$script:StatusBadge.TextAlign = "MiddleCenter"
$script:StatusBadge.BackColor = [System.Drawing.Color]::FromArgb(210, 72, 72)
$top.Controls.Add($script:StatusBadge)

$left = [System.Windows.Forms.Panel]::new()
$left.Location = [System.Drawing.Point]::new(18, 104)
$left.Size = [System.Drawing.Size]::new(320, 590)
$left.Anchor = "Top,Left,Bottom"
$left.BackColor = $panel
$left.BorderStyle = "FixedSingle"
$left.Add_Paint({
    param($sender, $eventArgs)
    $rect = $sender.ClientRectangle
    $brush = [System.Drawing.Drawing2D.LinearGradientBrush]::new(
        $rect,
        [System.Drawing.Color]::FromArgb(236, 246, 255),
        [System.Drawing.Color]::FromArgb(181, 210, 255),
        [System.Drawing.Drawing2D.LinearGradientMode]::Horizontal
    )
    $eventArgs.Graphics.FillRectangle($brush, $rect)
    $brush.Dispose()
})
$script:Form.Controls.Add($left)

$left.Controls.Add((New-Label "Pick a task" 16 14 180 24 ([System.Drawing.Font]::new("Segoe UI Semibold", 12)) $text))
$script:StartButton = New-Button "Start Server" 16 52 288 { Start-Server -Reason "Manual start" }
$script:StopButton = New-Button "Stop" 16 98 140 { Stop-Server -Reason "Manual stop" }
$script:RestartButton = New-Button "Restart" 164 98 140 { Restart-Server -Reason "Manual restart" }
$left.Controls.Add($script:StartButton)
$left.Controls.Add($script:StopButton)
$left.Controls.Add($script:RestartButton)

$script:BackupButton = New-Button "Run Backup" 16 144 288 { [void](Send-ServerCommand $Config.backupCommand) }
$openFolderButton = New-Button "Open Folder" 16 190 140 { Start-Process -FilePath $Config.resolvedServerDirectory }
$openLogsButton = New-Button "Open Logs" 164 190 140 { Start-Process -FilePath $Config.resolvedLogDirectory }
$left.Controls.Add($script:BackupButton)
$left.Controls.Add($openFolderButton)
$left.Controls.Add($openLogsButton)

$script:KeepAliveToggle = [System.Windows.Forms.CheckBox]::new()
$script:KeepAliveToggle.Text = "Keep Alive armed after Start"
$script:KeepAliveToggle.Checked = [bool]$Config.keepAliveOnOpen
$script:KeepAliveToggle.Location = [System.Drawing.Point]::new(18, 238)
$script:KeepAliveToggle.Size = [System.Drawing.Size]::new(250, 24)
$script:KeepAliveToggle.ForeColor = $text
$script:KeepAliveToggle.BackColor = [System.Drawing.Color]::Transparent
$left.Controls.Add($script:KeepAliveToggle)

$left.Controls.Add((New-Label "Health" 16 270 180 24 ([System.Drawing.Font]::new("Segoe UI Semibold", 12)) $text))
$metricY = 304
$metricGap = 30
$names = @("Process", "Port", "Ready", "Log Age", "Uptime", "Memory", "CPU", "Restarts")
$valueRefs = @("ProcessValue", "PortValue", "ReadyValue", "LogAgeValue", "UptimeValue", "MemoryValue", "CpuValue", "RestartsValue")
for ($i = 0; $i -lt $names.Count; $i++) {
    $left.Controls.Add((New-Label $names[$i] 18 ($metricY + ($i * $metricGap)) 95 20 $smallFont $muted))
    $value = New-Label "-" 124 ($metricY + ($i * $metricGap)) 170 22 ([System.Drawing.Font]::new("Segoe UI Semibold", 9)) $text
    Set-Variable -Name $valueRefs[$i] -Scope Script -Value $value
    $left.Controls.Add($value)
}

$left.Controls.Add((New-Label "Last Action" 18 552 95 20 $smallFont $muted))
$script:ActionValue = New-Label $script:LastAction 124 552 170 20 $smallFont $text
$left.Controls.Add($script:ActionValue)

$main = [System.Windows.Forms.Panel]::new()
$main.Location = [System.Drawing.Point]::new(356, 104)
$main.Size = [System.Drawing.Size]::new(786, 590)
$main.Anchor = "Top,Left,Right,Bottom"
$main.BackColor = $panel2
$main.BorderStyle = "FixedSingle"
$script:Form.Controls.Add($main)

$main.Controls.Add((New-Label "Live Server Console" 16 12 240 24 ([System.Drawing.Font]::new("Segoe UI Semibold", 12)) $text))
$main.Controls.Add((New-Label "Commands typed below are sent to the server process managed by this app." 16 38 560 20 $smallFont $muted))
$script:ConfigSummary = New-Label "NeoForge 21.1.235 | Minecraft 1.21.1" 488 38 280 20 $smallFont $muted
$script:ConfigSummary.TextAlign = "MiddleRight"
$script:ConfigSummary.Anchor = "Top,Right"
$main.Controls.Add($script:ConfigSummary)

$script:ConsoleModeNotice = New-Label "Console window mode: type live commands in the separate server terminal." 16 58 620 20 $smallFont ([System.Drawing.Color]::FromArgb(162, 92, 22))
$script:ConsoleModeNotice.Visible = Test-ConsoleWindowMode
$main.Controls.Add($script:ConsoleModeNotice)

$script:ConsoleBox = [System.Windows.Forms.TextBox]::new()
$script:ConsoleBox.Multiline = $true
$script:ConsoleBox.ReadOnly = $true
$script:ConsoleBox.ScrollBars = "Vertical"
$script:ConsoleBox.WordWrap = $false
$script:ConsoleBox.Font = $monoFont
$script:ConsoleBox.BackColor = [System.Drawing.Color]::FromArgb(7, 10, 14)
$script:ConsoleBox.ForeColor = [System.Drawing.Color]::FromArgb(210, 226, 238)
$script:ConsoleBox.BorderStyle = "FixedSingle"
$script:ConsoleBox.Location = [System.Drawing.Point]::new(16, 82)
$script:ConsoleBox.Size = [System.Drawing.Size]::new(752, 364)
$script:ConsoleBox.Anchor = "Top,Left,Right,Bottom"
$main.Controls.Add($script:ConsoleBox)

$script:CommandBox = [System.Windows.Forms.TextBox]::new()
$script:CommandBox.Location = [System.Drawing.Point]::new(16, 462)
$script:CommandBox.Size = [System.Drawing.Size]::new(624, 26)
$script:CommandBox.Anchor = "Left,Right,Bottom"
$script:CommandBox.BackColor = [System.Drawing.Color]::FromArgb(12, 16, 22)
$script:CommandBox.ForeColor = [System.Drawing.Color]::FromArgb(240, 246, 255)
$script:CommandBox.BorderStyle = "FixedSingle"
$script:CommandBox.Font = $font
$script:CommandBox.Add_KeyDown({
    param($sender, $eventArgs)
    if ($eventArgs.KeyCode -eq [System.Windows.Forms.Keys]::Enter) {
        Invoke-CommandBox
        $eventArgs.SuppressKeyPress = $true
    }
    elseif ($eventArgs.KeyCode -eq [System.Windows.Forms.Keys]::Up) {
        if ($script:CommandHistory.Count -gt 0) {
            $script:CommandHistoryIndex = [Math]::Max(0, $script:CommandHistoryIndex - 1)
            $script:CommandBox.Text = [string]$script:CommandHistory[$script:CommandHistoryIndex]
            $script:CommandBox.SelectionStart = $script:CommandBox.TextLength
            $eventArgs.SuppressKeyPress = $true
        }
    }
    elseif ($eventArgs.KeyCode -eq [System.Windows.Forms.Keys]::Down) {
        if ($script:CommandHistory.Count -gt 0) {
            $script:CommandHistoryIndex = [Math]::Min($script:CommandHistory.Count, $script:CommandHistoryIndex + 1)
            if ($script:CommandHistoryIndex -ge $script:CommandHistory.Count) {
                $script:CommandBox.Clear()
            }
            else {
                $script:CommandBox.Text = [string]$script:CommandHistory[$script:CommandHistoryIndex]
                $script:CommandBox.SelectionStart = $script:CommandBox.TextLength
            }
            $eventArgs.SuppressKeyPress = $true
        }
    }
})
$main.Controls.Add($script:CommandBox)

$script:SendButton = New-Button "Send" 656 458 112 { Invoke-CommandBox }
$script:SendButton.Anchor = "Right,Bottom"
$main.Controls.Add($script:SendButton)

$quickY = 496
$main.Controls.Add((New-Label "Quick Commands" 16 $quickY 130 22 ([System.Drawing.Font]::new("Segoe UI Semibold", 10)) $text))
$quickList = New-Button "list" 150 ($quickY - 6) 78 { [void](Send-ServerCommand "list") }
$quickSave = New-Button "save-all" 236 ($quickY - 6) 98 { [void](Send-ServerCommand "save-all") }
$quickSay = New-Button "say" 342 ($quickY - 6) 78 { [void](Send-ServerCommand "say Server checkpoint from watchdog.") }
$quickTrackMap = New-Button "Track Map" 428 ($quickY - 6) 112 { Start-Process "http://127.0.0.1:3876" }
foreach ($quick in @($quickList, $quickSave, $quickSay, $quickTrackMap)) {
    $quick.Height = 30
    $quick.Anchor = "Bottom,Left"
    $main.Controls.Add($quick)
}
$script:QuickCommandButtons = @($quickList, $quickSave, $quickSay, $quickTrackMap)

$main.Controls.Add((New-Label "Watchdog Events" 16 532 180 22 ([System.Drawing.Font]::new("Segoe UI Semibold", 11)) $text))
$script:EventList = [System.Windows.Forms.ListBox]::new()
$script:EventList.Location = [System.Drawing.Point]::new(16, 558)
$script:EventList.Size = [System.Drawing.Size]::new(752, 28)
$script:EventList.Anchor = "Left,Right,Bottom"
$script:EventList.BackColor = [System.Drawing.Color]::FromArgb(12, 16, 22)
$script:EventList.ForeColor = [System.Drawing.Color]::FromArgb(220, 226, 235)
$script:EventList.BorderStyle = "FixedSingle"
$main.Controls.Add($script:EventList)

$footer = [System.Windows.Forms.StatusStrip]::new()
$footer.BackColor = [System.Drawing.Color]::FromArgb(225, 230, 244)
$footer.ForeColor = $text
$script:FooterStatus = [System.Windows.Forms.ToolStripStatusLabel]::new()
$script:FooterStatus.Text = "Ready."
$script:FooterStatus.Spring = $true
$script:FooterStatus.TextAlign = "MiddleLeft"
[void]$footer.Items.Add($script:FooterStatus)
$script:Form.Controls.Add($footer)

$tips = [System.Windows.Forms.ToolTip]::new()
$tips.SetToolTip($script:StartButton, "Start the dedicated server as a managed watchdog process.")
$tips.SetToolTip($script:StopButton, "Send stop, wait for clean shutdown, then force-kill only if needed.")
$tips.SetToolTip($script:RestartButton, "Gracefully restart the managed server.")
$tips.SetToolTip($script:BackupButton, "Run the configured FTB Backups command.")
$tips.SetToolTip($script:CommandBox, "Type Minecraft server commands here. Use Up and Down for command history.")
$tips.SetToolTip($script:KeepAliveToggle, "When armed, the watchdog restarts the managed server after real failure signals.")

$timer = [System.Windows.Forms.Timer]::new()
$timer.Interval = [Math]::Max(1000, [int]$Config.checkIntervalSeconds * 1000)
$timer.Add_Tick({
    try { Update-Dashboard }
    catch { Write-WatchdogEvent "Dashboard update failed: $($_.Exception.Message)" "ERROR" }
})

$fastTimer = [System.Windows.Forms.Timer]::new()
$fastTimer.Interval = 250
$fastTimer.Add_Tick({ Drain-OutputQueue })

$autoCloseTimer = $null
if ($AutoCloseSeconds -gt 0) {
    $autoCloseTimer = [System.Windows.Forms.Timer]::new()
    $autoCloseTimer.Interval = [Math]::Max(1, $AutoCloseSeconds) * 1000
    $autoCloseTimer.Add_Tick({
        $autoCloseTimer.Stop()
        Write-WatchdogEvent "Auto-close render test completed."
        $script:Form.Close()
    })
}

$script:Form.Add_Shown({
    Write-WatchdogEvent "Watchdog UI opened."
    Append-ConsoleLine "Simba Watchdog UI ready. Press Start Server to launch the Minecraft server GUI."
    Append-ConsoleLine "Server folder: $($Config.resolvedServerDirectory)"
    if ((-not $script:PreviewMode) -and [bool]$Config.autoStartOnOpen) {
        Start-Server -Reason "Auto-start on watchdog open"
    }
    Update-Dashboard
    $timer.Start()
    $fastTimer.Start()
    if ($autoCloseTimer) { $autoCloseTimer.Start() }
})

$script:Form.Add_FormClosing({
    param($sender, $eventArgs)
    $timer.Stop()
    $fastTimer.Stop()
    if ($autoCloseTimer) { $autoCloseTimer.Stop() }
    if (Get-ManagedProcess) {
        $answer = [System.Windows.Forms.MessageBox]::Show(
            "The server is still running under this watchdog. Stop it before closing?",
            "Server is running",
            [System.Windows.Forms.MessageBoxButtons]::YesNoCancel,
            [System.Windows.Forms.MessageBoxIcon]::Question
        )
        if ($answer -eq [System.Windows.Forms.DialogResult]::Cancel) {
            $eventArgs.Cancel = $true
            $timer.Start()
            $fastTimer.Start()
            return
        }
        if ($answer -eq [System.Windows.Forms.DialogResult]::Yes) {
            Stop-Server -Reason "Watchdog closing"
        }
    }
    Write-WatchdogEvent "Watchdog UI closed."
})

if ($PreviewPng) {
    $previewPath = [System.IO.Path]::GetFullPath($PreviewPng)
    $previewDir = Split-Path -Parent $previewPath
    if ($previewDir) {
        New-Item -ItemType Directory -Force -Path $previewDir | Out-Null
    }
    $script:Form.StartPosition = "Manual"
    $script:Form.Location = [System.Drawing.Point]::new(20, 20)
    $script:Form.Show()
    [System.Windows.Forms.Application]::DoEvents()
    Start-Sleep -Milliseconds 700
    [System.Windows.Forms.Application]::DoEvents()
    $bitmap = [System.Drawing.Bitmap]::new($script:Form.Width, $script:Form.Height)
    $rect = [System.Drawing.Rectangle]::new(0, 0, $script:Form.Width, $script:Form.Height)
    $script:Form.DrawToBitmap($bitmap, $rect)
    $bitmap.Save($previewPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bitmap.Dispose()
    $script:Form.Close()
    "WATCHDOG_UI_PREVIEW_SAVED=$previewPath"
    return
}

[void]$script:Form.ShowDialog()
