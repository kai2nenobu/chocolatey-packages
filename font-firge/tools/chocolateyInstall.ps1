$ErrorActionPreference = 'Stop'

## Include common configurations
$toolsDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. (Join-Path $toolsDir 'common.ps1')

$firgeBase = 'Firge_v0.2.0'
$extractDir = (Join-Path $toolsDir $firgeBase)

$packageArgs = @{
  PackageName   = 'font-firge'
  Url           = 'https://github.com/yuru7/Firge/releases/download/v0.2.0/Firge_v0.2.0.zip'
  Checksum      = '18ccd0d5c7689a02af4a7217912c0112db9f24071e8b36a716baef3b446c32e7'
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
