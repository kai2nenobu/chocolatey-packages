$ErrorActionPreference = 'Stop'

## Include common configurations
$toolsDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. (Join-Path $toolsDir 'common.ps1')

$hackgenBase = 'HackGen_v2.2.2'
$extractDir = (Join-Path $toolsDir $hackgenBase)

$packageArgs = @{
  PackageName   = 'font-hackgen'
  Url           = 'https://github.com/yuru7/HackGen/releases/download/v2.2.2/HackGen_v2.2.2.zip'
  Checksum      = '1bd8f6b9e15845f03c5e5cb7cd2721246428f391448eb654e8bc6e9decaf756c'
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
