[CmdletBinding()]
param(
    [string]$RepoRoot = (Split-Path -Parent $PSScriptRoot),
    # Distant Horizons uses the multiplayer entry name as part of its local
    # server-data path. This is the permanent production identity; keep it
    # stable between every future client release.
    [string]$Name = 'Simba Create SMP',
    [string]$Address = 'meep.strangled.net'
)

$ErrorActionPreference = 'Stop'

function Write-UShortBE {
    param([IO.BinaryWriter]$Writer, [int]$Value)
    $Writer.Write([byte](($Value -shr 8) -band 0xff))
    $Writer.Write([byte]($Value -band 0xff))
}

function Write-IntBE {
    param([IO.BinaryWriter]$Writer, [int]$Value)
    $Writer.Write([byte](($Value -shr 24) -band 0xff))
    $Writer.Write([byte](($Value -shr 16) -band 0xff))
    $Writer.Write([byte](($Value -shr 8) -band 0xff))
    $Writer.Write([byte]($Value -band 0xff))
}

function Write-NbtString {
    param([IO.BinaryWriter]$Writer, [string]$Value)
    $bytes = [Text.Encoding]::UTF8.GetBytes($Value)
    Write-UShortBE -Writer $Writer -Value $bytes.Length
    $Writer.Write($bytes)
}

function Write-NamedStringTag {
    param([IO.BinaryWriter]$Writer, [string]$TagName, [string]$Value)
    $Writer.Write([byte]8)
    Write-NbtString -Writer $Writer -Value $TagName
    Write-NbtString -Writer $Writer -Value $Value
}

$memory = [IO.MemoryStream]::new()
$writer = [IO.BinaryWriter]::new($memory)
try {
    $writer.Write([byte]10) # root compound
    Write-NbtString -Writer $writer -Value ''

    $writer.Write([byte]9) # list tag
    Write-NbtString -Writer $writer -Value 'servers'
    $writer.Write([byte]10) # compound elements
    Write-IntBE -Writer $writer -Value 1

    Write-NamedStringTag -Writer $writer -TagName 'name' -Value $Name
    Write-NamedStringTag -Writer $writer -TagName 'ip' -Value $Address
    $writer.Write([byte]1) # byte tag
    Write-NbtString -Writer $writer -Value 'acceptTextures'
    $writer.Write([byte]0) # prompt for server resource packs
    $writer.Write([byte]0) # end server compound
    $writer.Write([byte]0) # end root compound
    $writer.Flush()

    foreach ($pack in @('client\packwiz-client', 'client\packwiz-lite')) {
        $destination = Join-Path (Join-Path $RepoRoot $pack) 'servers.dat'
        [IO.File]::WriteAllBytes($destination, $memory.ToArray())
        Write-Host "Wrote $destination"
    }
}
finally {
    $writer.Dispose()
    $memory.Dispose()
}
