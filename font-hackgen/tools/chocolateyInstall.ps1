$ErrorActionPreference = 'Stop'

## Include common configurations
$toolsDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. (Join-Path $toolsDir 'common.ps1')

$hackgenBase = 'HackGenNerd_v2.2.3'
$extractDir = (Join-Path $toolsDir $hackgenBase)

$packageArgs = @{
  PackageName   = 'font-hackgen-nerd'
  Url           = 'https://github.com/yuru7/HackGen/releases/download/v2.2.3/HackGenNerd_v2.2.3.zip'
  Checksum      = '7ce5ea01ab88443f30de461e8b614cbeaed10a7fc9580902922646a1134158f0'
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
