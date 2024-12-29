$ErrorActionPreference = 'Stop'

## Include common configurations
$toolsDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. (Join-Path $toolsDir 'common-font-hackgen.ps1')

$hackgenBase = 'HackGen_v2.10.0'
$extractDir = (Join-Path $toolsDir $hackgenBase)

$packageArgs = @{
  PackageName   = 'font-hackgen'
  Url           = 'https://github.com/yuru7/HackGen/releases/download/v2.10.0/HackGen_v2.10.0.zip'
  Checksum      = 'ed182e2a4b95792d94dea7932f6b45280b5ae353651be249d5f6b7867b788db7'
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
