$ErrorActionPreference = 'Stop'

## Include common configurations
$toolsDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. (Join-Path $toolsDir 'common.ps1')

$hackgenBase = 'HackGen_v2.6.4'
$extractDir = (Join-Path $toolsDir $hackgenBase)

$packageArgs = @{
  PackageName   = 'font-hackgen'
  Url           = 'https://github.com/yuru7/HackGen/releases/download/v2.6.4/HackGen_v2.6.4.zip'
  Checksum      = '2462ad3cf6bfe3750ce91090f2cec88e74ff11368efa2507eaa3cb328974532a'
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
