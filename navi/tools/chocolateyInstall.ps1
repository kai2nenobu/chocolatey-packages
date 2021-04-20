$ErrorActionPreference = 'Stop'

$toolsPath = Split-Path $MyInvocation.MyCommand.Definition

Get-ChildItem $toolsPath\* | ? { $_.PSISContainer } | Remove-Item -Recurse -Force #remove older package dirs

# Expand .tar.gz
$packageArgs = @{
  PackageName    = 'navi'
  FileFullPath64 = Get-Item "$toolsPath\*x86_64-pc-windows-gnu.zip"
  Destination    = $toolsPath
}
Get-ChocolateyUnzip @packageArgs

Remove-Item $toolsPath\*.zip -ErrorAction 0
