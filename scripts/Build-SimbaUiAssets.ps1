[CmdletBinding()]
param(
    [string]$RepoRoot = (Split-Path -Parent $PSScriptRoot),
    [string]$MainBackgroundSource,
    [string]$LoadingBackgroundSource,
    [string]$MainLogoSource,
    [string]$MainLogoAlternateSource,
    [string]$LoadingLogoSource
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$sourceRoot = Join-Path $RepoRoot 'art\simba-ui-suite\source'
if ([string]::IsNullOrWhiteSpace($MainBackgroundSource)) { $MainBackgroundSource = Join-Path $sourceRoot 'main-menu-360-source.png' }
if ([string]::IsNullOrWhiteSpace($LoadingBackgroundSource)) { $LoadingBackgroundSource = Join-Path $sourceRoot 'loading-vista-source.png' }
if ([string]::IsNullOrWhiteSpace($MainLogoSource)) { $MainLogoSource = Join-Path $sourceRoot 'main-logo-sustenance-original.png' }
if ([string]::IsNullOrWhiteSpace($MainLogoAlternateSource)) { $MainLogoAlternateSource = Join-Path $sourceRoot 'main-logo-clean-original.png' }
if ([string]::IsNullOrWhiteSpace($LoadingLogoSource)) { $LoadingLogoSource = Join-Path $sourceRoot 'loading-logo-create-original.png' }

function New-Directory {
    param([string]$Path)
    [System.IO.Directory]::CreateDirectory($Path) | Out-Null
}

function Save-CoverImage {
    param(
        [string]$Source,
        [string]$Destination,
        [int]$Width,
        [int]$Height
    )

    $sourceImage = [System.Drawing.Image]::FromFile($Source)
    try {
        $sourceRatio = $sourceImage.Width / [double]$sourceImage.Height
        $targetRatio = $Width / [double]$Height
        if ($sourceRatio -gt $targetRatio) {
            $cropHeight = $sourceImage.Height
            $cropWidth = [int][Math]::Round($cropHeight * $targetRatio)
            $cropX = [int][Math]::Round(($sourceImage.Width - $cropWidth) / 2.0)
            $cropY = 0
        } else {
            $cropWidth = $sourceImage.Width
            $cropHeight = [int][Math]::Round($cropWidth / $targetRatio)
            $cropX = 0
            $cropY = [int][Math]::Round(($sourceImage.Height - $cropHeight) / 2.0)
        }

        $bitmap = New-Object System.Drawing.Bitmap($Width, $Height, [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
        try {
            $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
            try {
                $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
                $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
                $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
                $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
                $destinationRect = New-Object System.Drawing.Rectangle(0, 0, $Width, $Height)
                $sourceRect = New-Object System.Drawing.Rectangle($cropX, $cropY, $cropWidth, $cropHeight)
                $graphics.DrawImage($sourceImage, $destinationRect, $sourceRect, [System.Drawing.GraphicsUnit]::Pixel)
            } finally {
                $graphics.Dispose()
            }
            $bitmap.Save($Destination, [System.Drawing.Imaging.ImageFormat]::Png)
        } finally {
            $bitmap.Dispose()
        }
    } finally {
        $sourceImage.Dispose()
    }
}

function Save-TrimmedAlphaImage {
    param(
        [string]$Source,
        [string]$Destination,
        [int]$Padding = 4
    )

    $bitmap = New-Object System.Drawing.Bitmap($Source)
    try {
        $minX = $bitmap.Width
        $minY = $bitmap.Height
        $maxX = -1
        $maxY = -1
        for ($y = 0; $y -lt $bitmap.Height; $y++) {
            for ($x = 0; $x -lt $bitmap.Width; $x++) {
                if ($bitmap.GetPixel($x, $y).A -gt 2) {
                    if ($x -lt $minX) { $minX = $x }
                    if ($x -gt $maxX) { $maxX = $x }
                    if ($y -lt $minY) { $minY = $y }
                    if ($y -gt $maxY) { $maxY = $y }
                }
            }
        }
        if ($maxX -lt 0) { throw "No visible pixels found in $Source" }

        $minX = [Math]::Max(0, $minX - $Padding)
        $minY = [Math]::Max(0, $minY - $Padding)
        $maxX = [Math]::Min($bitmap.Width - 1, $maxX + $Padding)
        $maxY = [Math]::Min($bitmap.Height - 1, $maxY + $Padding)
        $rect = New-Object System.Drawing.Rectangle($minX, $minY, ($maxX - $minX + 1), ($maxY - $minY + 1))
        $trimmed = $bitmap.Clone($rect, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
        try {
            $trimmed.Save($Destination, [System.Drawing.Imaging.ImageFormat]::Png)
        } finally {
            $trimmed.Dispose()
        }
    } finally {
        $bitmap.Dispose()
    }
}

function New-ButtonTexture {
    param(
        [string]$Destination,
        [System.Drawing.Color]$Fill,
        [System.Drawing.Color]$Border,
        [System.Drawing.Color]$InnerHighlight
    )

    $bitmap = New-Object System.Drawing.Bitmap(64, 20, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    try {
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        try {
            $graphics.Clear([System.Drawing.Color]::Transparent)
            $fillBrush = New-Object System.Drawing.SolidBrush($Fill)
            $borderPen = New-Object System.Drawing.Pen($Border, 1)
            $highlightPen = New-Object System.Drawing.Pen($InnerHighlight, 1)
            try {
                $graphics.FillRectangle($fillBrush, 1, 1, 62, 18)
                $graphics.DrawRectangle($borderPen, 0, 0, 63, 19)
                $graphics.DrawLine($highlightPen, 2, 2, 61, 2)
            } finally {
                $fillBrush.Dispose()
                $borderPen.Dispose()
                $highlightPen.Dispose()
            }
        } finally {
            $graphics.Dispose()
        }
        $bitmap.Save($Destination, [System.Drawing.Imaging.ImageFormat]::Png)
    } finally {
        $bitmap.Dispose()
    }
}

function New-ProgressTexture {
    param(
        [string]$Destination,
        [System.Drawing.Color]$Fill,
        [System.Drawing.Color]$Border
    )

    $bitmap = New-Object System.Drawing.Bitmap(512, 12, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    try {
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        try {
            $graphics.Clear([System.Drawing.Color]::Transparent)
            $fillBrush = New-Object System.Drawing.SolidBrush($Fill)
            $borderPen = New-Object System.Drawing.Pen($Border, 1)
            try {
                $graphics.FillRectangle($fillBrush, 1, 1, 510, 10)
                $graphics.DrawRectangle($borderPen, 0, 0, 511, 11)
            } finally {
                $fillBrush.Dispose()
                $borderPen.Dispose()
            }

        } finally {
            $graphics.Dispose()
        }
        $bitmap.Save($Destination, [System.Drawing.Imaging.ImageFormat]::Png)
    } finally {
        $bitmap.Dispose()
    }
}

function New-LogoBackplate {
    param([string]$Destination)

    $bitmap = New-Object System.Drawing.Bitmap(512, 256, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    try {
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        try {
            $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
            $graphics.Clear([System.Drawing.Color]::Transparent)
            for ($inset = 0; $inset -lt 24; $inset++) {
                $alpha = [int][Math]::Round(3 + (($inset / 23.0) * 7))
                $shadowBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb($alpha, 5, 7, 8))
                try {
                    $graphics.FillEllipse($shadowBrush, $inset, $inset, 512 - (2 * $inset), 256 - (2 * $inset))
                } finally {
                    $shadowBrush.Dispose()
                }
            }
            $fillBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(194, 12, 15, 16))
            $borderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(145, 184, 137, 59), 2)
            try {
                $rect = New-Object System.Drawing.Rectangle(28, 24, 456, 208)
                $radius = 20
                $path = New-Object System.Drawing.Drawing2D.GraphicsPath
                try {
                    $diameter = $radius * 2
                    $path.AddArc($rect.X, $rect.Y, $diameter, $diameter, 180, 90)
                    $path.AddArc($rect.Right - $diameter, $rect.Y, $diameter, $diameter, 270, 90)
                    $path.AddArc($rect.Right - $diameter, $rect.Bottom - $diameter, $diameter, $diameter, 0, 90)
                    $path.AddArc($rect.X, $rect.Bottom - $diameter, $diameter, $diameter, 90, 90)
                    $path.CloseFigure()
                    $graphics.FillPath($fillBrush, $path)
                    $graphics.DrawPath($borderPen, $path)
                } finally {
                    $path.Dispose()
                }
            } finally {
                $fillBrush.Dispose()
                $borderPen.Dispose()
            }

            $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
            $creditFont = New-Object System.Drawing.Font('Segoe UI Semibold', 17, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
            $creditBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(230, 245, 245, 241))
            $creditFormat = New-Object System.Drawing.StringFormat
            try {
                $creditFormat.Alignment = [System.Drawing.StringAlignment]::Center
                $creditFormat.LineAlignment = [System.Drawing.StringAlignment]::Center
                $creditRect = New-Object System.Drawing.RectangleF(52, 198, 408, 24)
                $graphics.DrawString('SUSTAINED BY SUSTENANCE', $creditFont, $creditBrush, $creditRect, $creditFormat)
            } finally {
                $creditFormat.Dispose()
                $creditBrush.Dispose()
                $creditFont.Dispose()
            }
        } finally {
            $graphics.Dispose()
        }
        $bitmap.Save($Destination, [System.Drawing.Imaging.ImageFormat]::Png)
    } finally {
        $bitmap.Dispose()
    }
}

$artRoot = Join-Path $RepoRoot 'art\simba-ui-suite'
$assetRoot = Join-Path $artRoot 'assets\simba'
New-Directory $assetRoot

Save-CoverImage -Source $MainBackgroundSource -Destination (Join-Path $assetRoot 'main-menu-background.png') -Width 1920 -Height 1080
Save-CoverImage -Source $LoadingBackgroundSource -Destination (Join-Path $assetRoot 'loading-vista.png') -Width 1920 -Height 1080
Save-TrimmedAlphaImage -Source $MainLogoSource -Destination (Join-Path $assetRoot 'main-logo-sustenance.png')
Save-TrimmedAlphaImage -Source $MainLogoAlternateSource -Destination (Join-Path $assetRoot 'main-logo-clean.png')
Save-TrimmedAlphaImage -Source $LoadingLogoSource -Destination (Join-Path $assetRoot 'loading-logo-create.png')
New-LogoBackplate -Destination (Join-Path $assetRoot 'main-logo-backplate.png')

New-ButtonTexture -Destination (Join-Path $assetRoot 'button-normal.png') `
    -Fill ([System.Drawing.Color]::FromArgb(205, 22, 24, 24)) `
    -Border ([System.Drawing.Color]::FromArgb(220, 111, 99, 76)) `
    -InnerHighlight ([System.Drawing.Color]::FromArgb(80, 198, 169, 108))
New-ButtonTexture -Destination (Join-Path $assetRoot 'button-hover.png') `
    -Fill ([System.Drawing.Color]::FromArgb(230, 42, 34, 22)) `
    -Border ([System.Drawing.Color]::FromArgb(255, 214, 154, 48)) `
    -InnerHighlight ([System.Drawing.Color]::FromArgb(150, 255, 213, 105))
New-ButtonTexture -Destination (Join-Path $assetRoot 'button-inactive.png') `
    -Fill ([System.Drawing.Color]::FromArgb(160, 20, 21, 22)) `
    -Border ([System.Drawing.Color]::FromArgb(150, 76, 76, 72)) `
    -InnerHighlight ([System.Drawing.Color]::FromArgb(40, 122, 116, 101))

New-ProgressTexture -Destination (Join-Path $assetRoot 'progress-background.png') `
    -Fill ([System.Drawing.Color]::FromArgb(190, 17, 19, 19)) `
    -Border ([System.Drawing.Color]::FromArgb(230, 116, 102, 76))
New-ProgressTexture -Destination (Join-Path $assetRoot 'progress-fill.png') `
    -Fill ([System.Drawing.Color]::FromArgb(255, 213, 145, 40)) `
    -Border ([System.Drawing.Color]::FromArgb(255, 255, 211, 99))

foreach ($pack in @('packwiz-client', 'packwiz-lite')) {
    $configRoot = Join-Path $RepoRoot "client\$pack\config"
    $assetDestination = Join-Path $configRoot 'fancymenu\assets\simba'
    New-Directory $assetDestination
    Get-ChildItem -LiteralPath $assetRoot -File | Copy-Item -Destination $assetDestination -Force

    $configTemplateRoot = Join-Path $artRoot 'config-template'
    Get-ChildItem -LiteralPath $configTemplateRoot -Recurse -File | ForEach-Object {
        $relativePath = $_.FullName.Substring($configTemplateRoot.Length).TrimStart('\', '/')
        $target = Join-Path $configRoot $relativePath
        New-Directory (Split-Path -Parent $target)
        Copy-Item -LiteralPath $_.FullName -Destination $target -Force
    }
}

Get-ChildItem -LiteralPath $assetRoot -File | Sort-Object Name | Select-Object Name, Length
