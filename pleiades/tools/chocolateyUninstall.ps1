﻿$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName = $env:ChocolateyPackageName
$installPath = Join-Path (Get-ToolsLocation) $packageName

## Delete installed pleiades
if (Test-Path $installPath) {
    Remove-Item -Path $installPath -Recurse -Force
}

## Delete a shortcut
$CommonPrograms =([Environment]::GetFolderPath('CommonPrograms'))
$shortcutDir = Join-Path $CommonPrograms $packageName
if (Test-Path $shortcutDir) {
    Remove-Item -Path $shortcutDir -Recurse -Force
}
