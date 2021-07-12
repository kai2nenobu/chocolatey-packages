$ErrorActionPreference = 'Stop'

$toolsPath = Split-Path $MyInvocation.MyCommand.Definition

$packageArgs = @{
    PackageName    = 'actionlint'
    FileFullPath   = Get-Item "$toolsPath\*_windows_386.zip"
    FileFullPath64 = Get-Item "$toolsPath\*_windows_amd64.zip"
    Destination    = $toolsPath
}

Get-ChocolateyUnzip @packageArgs
Remove-Item $toolsPath\*.zip -ea 0
