$ErrorActionPreference = 'Stop'

## Include common configurations
$toolsDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. (Join-Path $toolsDir 'common.ps1')

$firgeFonts | ForEach-Object {
  'Uninstalling {0}...' -f $_
  Uninstall-ChocolateyFont $_ | Out-Null
}
