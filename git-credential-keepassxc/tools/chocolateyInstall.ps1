$ErrorActionPreference = 'Stop'

$pp = Get-PackageParameters
if (!$pp['BuildType']) {
    $pp['BuildType'] = 'minimal'
}
switch($pp['BuildType']) {
    'minimal' { $zipPath = 'windows-latest-minimal.zip' }
    'full' { $zipPath = 'windows-latest-full.zip' }
    default { throw "'BuildType' parameter is invalid: $($pp['BuildType'])" }
}

$toolsPath = Split-Path $MyInvocation.MyCommand.Definition

$packageArgs = @{
    PackageName    = 'git-credential-keepassxc'
    FileFullPath   = "$toolsPath\$zipPath"
    Destination    = $toolsPath
}

Get-ChocolateyUnzip @packageArgs
Remove-Item $toolsPath\*.zip -ea 0
