$ErrorActionPreference = 'Stop'

## Include common configurations
$toolsDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. (Join-Path $toolsDir 'common.ps1')

$hackgenBase = 'HackGenNerd_v2.6.2'
$extractDir = (Join-Path $toolsDir $hackgenBase)

$packageArgs = @{
  PackageName   = 'font-hackgen-nerd'
  Url           = 'https://github.com/yuru7/HackGen/releases/download/v2.6.2/HackGenNerd_v2.6.2.zip'
  Checksum      = '93481704137fc3defebf02e5957fe23ad82e5b8ca5164de7940354ef18cb5349'
  ChecksumType  = 'sha256'
  UnzipLocation = $toolsDir
}

# Download and extract Zip
Install-ChocolateyZipPackage @packageArgs

# Install all ttf fonts
$hackgenFonts | ForEach-Object {
  'Installing {0}...' -f $_
  Install-ChocolateyFont (Join-Path $extractDir $_) | Out-Null
}
