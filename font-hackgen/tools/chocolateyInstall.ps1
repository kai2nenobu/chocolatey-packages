$ErrorActionPreference = 'Stop'

## Include common configurations
$toolsDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. (Join-Path $toolsDir 'common-font-hackgen.ps1')

$hackgenBase = 'HackGen_v2.8.0'
$extractDir = (Join-Path $toolsDir $hackgenBase)

$packageArgs = @{
  PackageName   = 'font-hackgen'
  Url           = 'https://github.com/yuru7/HackGen/releases/download/v2.8.0/HackGen_v2.8.0.zip'
  Checksum      = '89ed3f0d8f6c3976a76594e659067a3fa57840a0cb44c601f8b36cc21f87b7c5'
  ChecksumType  = 'sha256'
  UnzipLocation = $toolsDir
}

# Download and extract Zip
Install-ChocolateyZipPackage @packageArgs

# Install all ttf fonts
$hackgenFonts.Keys | ForEach-Object {
  'Installing {0}...' -f $_
  Install-ChocolateyFont (Join-Path $extractDir $_) | Out-Null
}
