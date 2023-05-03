$ErrorActionPreference = 'Stop'

## Include common configurations
$toolsDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. (Join-Path $toolsDir 'common-font-hackgen.ps1')

$hackgenBase = 'HackGen_v2.9.0'
$extractDir = (Join-Path $toolsDir $hackgenBase)

$packageArgs = @{
  PackageName   = 'font-hackgen'
  Url           = 'https://github.com/yuru7/HackGen/releases/download/v2.9.0/HackGen_v2.9.0.zip'
  Checksum      = '123b2179866f5a291c15cf34a83fdce6ac202e2fe6ad27fbd9ddd4f5bff23c65'
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
