[CmdletBinding()]
param(
    [string]$RepoRoot = (Split-Path -Parent $PSScriptRoot),
    [string]$OutputDirectory = (Join-Path $RepoRoot 'art\simba-ui-suite\mockups')
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
[System.IO.Directory]::CreateDirectory($OutputDirectory) | Out-Null

$assets = Join-Path $RepoRoot 'art\simba-ui-suite\assets\simba'

function Draw-CenteredImage {
    param(
        [System.Drawing.Graphics]$Graphics,
        [System.Drawing.Image]$Image,
        [int]$CenterX,
        [int]$Top,
        [int]$Width
    )
    $height = [int][Math]::Round($Width * $Image.Height / [double]$Image.Width)
    $x = [int][Math]::Round($CenterX - ($Width / 2.0))
    $Graphics.DrawImage($Image, $x, $Top, $Width, $height)
    return $height
}

function New-MainMockup {
    param([string]$LogoName, [string]$OutputName)

    $background = [System.Drawing.Image]::FromFile((Join-Path $assets 'main-menu-background.png'))
    $backplate = [System.Drawing.Image]::FromFile((Join-Path $assets 'main-logo-backplate.png'))
    $logo = [System.Drawing.Image]::FromFile((Join-Path $assets $LogoName))
    $normal = [System.Drawing.Image]::FromFile((Join-Path $assets 'button-normal.png'))
    $hover = [System.Drawing.Image]::FromFile((Join-Path $assets 'button-hover.png'))
    try {
        $canvas = New-Object System.Drawing.Bitmap(1920, 1080, [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
        try {
            $g = [System.Drawing.Graphics]::FromImage($canvas)
            try {
                $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
                $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
                $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
                $g.DrawImage($background, 0, 0, 1920, 1080)
                [void](Draw-CenteredImage -Graphics $g -Image $backplate -CenterX 960 -Top 24 -Width 350)
                [void](Draw-CenteredImage -Graphics $g -Image $logo -CenterX 960 -Top 42 -Width 300)

                $font = New-Object System.Drawing.Font('Segoe UI Semibold', 18, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
                $textBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(242, 235, 220))
                $hoverBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 212, 106))
                $format = New-Object System.Drawing.StringFormat
                try {
                    $format.Alignment = [System.Drawing.StringAlignment]::Center
                    $format.LineAlignment = [System.Drawing.StringAlignment]::Center
                    $labels = @('Singleplayer', 'Multiplayer', 'Mods', 'Options', 'Quit Game')
                    $buttonWidth = 340
                    $buttonHeight = 42
                    $gap = 12
                    $startY = 430
                    for ($i = 0; $i -lt $labels.Count; $i++) {
                        $x = 960 - [int]($buttonWidth / 2)
                        $y = $startY + ($i * ($buttonHeight + $gap))
                        $texture = if ($i -eq 1) { $hover } else { $normal }
                        $g.DrawImage($texture, $x, $y, $buttonWidth, $buttonHeight)
                        $rect = New-Object System.Drawing.RectangleF($x, $y, $buttonWidth, $buttonHeight)
                        $brush = if ($i -eq 1) { $hoverBrush } else { $textBrush }
                        $g.DrawString($labels[$i], $font, $brush, $rect, $format)
                    }

                    $footerFont = New-Object System.Drawing.Font('Segoe UI', 13, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
                    $footerBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(205, 233, 225, 207))
                    try {
                        $g.DrawString('Simba Create SMP • NeoForge 1.21.1', $footerFont, $footerBrush, 24, 1040)
                    } finally {
                        $footerFont.Dispose()
                        $footerBrush.Dispose()
                    }
                } finally {
                    $format.Dispose()
                    $font.Dispose()
                    $textBrush.Dispose()
                    $hoverBrush.Dispose()
                }
            } finally {
                $g.Dispose()
            }
            $canvas.Save((Join-Path $OutputDirectory $OutputName), [System.Drawing.Imaging.ImageFormat]::Png)
        } finally {
            $canvas.Dispose()
        }
    } finally {
        $background.Dispose()
        $backplate.Dispose()
        $logo.Dispose()
        $normal.Dispose()
        $hover.Dispose()
    }
}

function New-LoadingMockup {
    $background = [System.Drawing.Image]::FromFile((Join-Path $assets 'loading-vista.png'))
    $logo = [System.Drawing.Image]::FromFile((Join-Path $assets 'loading-logo-create.png'))
    $barBackground = [System.Drawing.Image]::FromFile((Join-Path $assets 'progress-background.png'))
    $barFill = [System.Drawing.Image]::FromFile((Join-Path $assets 'progress-fill.png'))
    try {
        $canvas = New-Object System.Drawing.Bitmap(1920, 1080, [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
        try {
            $g = [System.Drawing.Graphics]::FromImage($canvas)
            try {
                $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
                $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
                $g.DrawImage($background, 0, 0, 1920, 1080)
                [void](Draw-CenteredImage -Graphics $g -Image $logo -CenterX 970 -Top 260 -Width 500)
                $barX = 610
                $barY = 720
                $barWidth = 700
                $barHeight = 18
                $g.DrawImage($barBackground, $barX, $barY, $barWidth, $barHeight)
                $g.DrawImage($barFill, $barX, $barY, [int]($barWidth * 0.64), $barHeight)
            } finally {
                $g.Dispose()
            }
            $canvas.Save((Join-Path $OutputDirectory 'loading-screen.png'), [System.Drawing.Imaging.ImageFormat]::Png)
        } finally {
            $canvas.Dispose()
        }
    } finally {
        $background.Dispose()
        $logo.Dispose()
        $barBackground.Dispose()
        $barFill.Dispose()
    }
}

New-MainMockup -LogoName 'main-logo-sustenance.png' -OutputName 'main-menu-sustenance.png'
New-MainMockup -LogoName 'main-logo-clean.png' -OutputName 'main-menu-clean.png'
New-LoadingMockup

Get-ChildItem -LiteralPath $OutputDirectory -File | Sort-Object Name | Select-Object Name, Length
