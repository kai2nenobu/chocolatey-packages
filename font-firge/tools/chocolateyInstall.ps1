$ErrorActionPreference = 'Stop'

## Include common configurations
$toolsDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. (Join-Path $toolsDir 'common.ps1')

$firgeBase = 'Firge_v0.0.2'
$extractDir = (Join-Path $toolsDir $firgeBase)

$packageArgs = @{
  PackageName   = 'font-firge'
  Url           = 'https://github.com/yuru7/Firge/releases/download/v0.0.2/Firge_v0.0.2.zip'
  Checksum      = '136c4b32aa862db3b6963dfdf73fb56a3aa70fe6fa37b1d304349ee3cef3d2a1'
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
