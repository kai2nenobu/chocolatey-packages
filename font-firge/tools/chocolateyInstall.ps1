$ErrorActionPreference = 'Stop'

## Include common configurations
$toolsDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. (Join-Path $toolsDir 'common.ps1')

$firgeBase = 'Firge_v0.1.0'
$extractDir = (Join-Path $toolsDir $firgeBase)

$packageArgs = @{
  PackageName   = 'font-firge'
  Url           = 'https://github.com/yuru7/Firge/releases/download/v0.1.0/Firge_v0.1.0.zip'
  Checksum      = 'd94ef9db6016d9dbf043b03ab45f36dd266ca930063294f464976fc09fa99489'
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
