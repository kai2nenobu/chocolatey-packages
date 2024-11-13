$ErrorActionPreference = 'Stop'

## Include common configurations
$toolsDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. (Join-Path $toolsDir 'common.ps1')

$firgeBase = 'FirgeNerd_v0.3.0'
$extractDir = (Join-Path $toolsDir $firgeBase)

$packageArgs = @{
  PackageName   = 'font-firge-nerd'
  Url           = 'https://github.com/yuru7/Firge/releases/download/v0.3.0/FirgeNerd_v0.3.0.zip'
  Checksum      = '54cd76378fbc5025f42d441d95ca6ec1d3ecc4270e6107558840fed7c04cfe4f'
  ChecksumType  = 'sha256'
  UnzipLocation = $toolsDir
}

# Download and extract Zip
Install-ChocolateyZipPackage @packageArgs

# Install all ttf fonts
$firgeFonts | ForEach-Object {
  'Installing {0}...' -f $_
  Install-ChocolateyFont (Join-Path $extractDir $_) | Out-Null
}
