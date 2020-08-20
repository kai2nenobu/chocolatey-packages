Import-Module au

$fixedJson = @'
[
  {
    "name": "MAPE_1.0.20.0_Windows.zip",
    "path": "Releases/MAPE_1.0.20.0_Windows.zip",
    "sha": "ce59f24a594fcef5d5a7affea8cbb8188c660778",
    "size": 131,
    "url": "https://api.github.com/repos/ipponshimeji/MAPE/contents/Releases/MAPE_1.0.20.0_Windows.zip?ref=master",
    "html_url": "https://github.com/ipponshimeji/MAPE/blob/master/Releases/MAPE_1.0.20.0_Windows.zip",
    "git_url": "https://api.github.com/repos/ipponshimeji/MAPE/git/blobs/ce59f24a594fcef5d5a7affea8cbb8188c660778",
    "download_url": "https://raw.githubusercontent.com/ipponshimeji/MAPE/master/Releases/MAPE_1.0.20.0_Windows.zip",
    "type": "file",
    "_links": {
      "self": "https://api.github.com/repos/ipponshimeji/MAPE/contents/Releases/MAPE_1.0.20.0_Windows.zip?ref=master",
      "git": "https://api.github.com/repos/ipponshimeji/MAPE/git/blobs/ce59f24a594fcef5d5a7affea8cbb8188c660778",
      "html": "https://github.com/ipponshimeji/MAPE/blob/master/Releases/MAPE_1.0.20.0_Windows.zip"
    }
  }
]
'@

function global:au_GetLatest {
  ## Find a latest version from a5m2 history page
  $regex = [regex]'(?i)^mape_([.\d]+)_.*\.zip$'
  #$releases = 'https://api.github.com/repos/ipponshimeji/MAPE/contents/Releases?ref=master'
  #$releases_info = Invoke-RestMethod -Uri $releases
  $releases_info = $fixedJson | ConvertFrom-Json
  $latestRelease = $releases_info | Where-Object { $_.name -match $regex } `
    | Sort-Object { [System.Version]($regex.Match($_.name).Groups[1].Value) } -Descending `
    | Select-Object -First 1
  return @{
    Version = $regex.Match($latestRelease.name).Groups[1].Value
    URL32 = 'https://github.com/ipponshimeji/MAPE/raw/master/' + $latestRelease.path
  }
}

function global:au_SearchReplace {
  @{
    "tools\chocolateyInstall.ps1" = @{
      "(^\s*[$]url)\s*=.*" = "`${1} = '$($Latest.URL32)'"
      "(^\s*[$]checksum)\s*=.*" = "`${1} = '$($Latest.Checksum32)'"
    }
  }
}

$env:ChocolateyPackageName = 'mape'
$env:ChocolateyPackageFolder = '.'
Update-Package
