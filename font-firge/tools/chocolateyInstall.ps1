$ErrorActionPreference = 'Stop'

## Include common configurations
$toolsDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. (Join-Path $toolsDir 'common.ps1')

$firgeBase = 'Firge_v0.3.0'
$extractDir = (Join-Path $toolsDir $firgeBase)

$packageArgs = @{
  PackageName   = 'font-firge'
  Url           = 'https://github.com/yuru7/Firge/releases/download/v0.3.0/Firge_v0.3.0.zip'
  Checksum      = 'c986f621000a6598064c7e2078322ed02040af4f7804d258033df949b35b0527'
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
