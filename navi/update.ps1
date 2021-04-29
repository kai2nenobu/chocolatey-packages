import-module au

function global:au_GetLatest {
  ## Find a latest release and extract installer URL from GitHub Releases
  $releases = 'https://api.github.com/repos/denisidoro/navi/releases'
  $releases_info = Invoke-RestMethod -Uri $releases
  foreach ($release in $releases_info) {
    if (-not $release.prerelease) {
      $tag = $release.tag_name
      if ($release.prerelease) {
        Write-Warning ('Ignore prerelease version: "{0}"' -f $tag)
        continue
      }
      if (-not ($tag -match '^v[0-9]+\.[0-9]+\.[0-9]+')) {
        Write-Warning ('Ignore invalid tag name: "{0}"' -f $tag)
        continue
      }
      $version = $tag -replace "^v",""
      $url64 = $release.assets | Where-Object { $_.name -like "*x86_64-pc-windows-gnu.zip" } | Select-Object -First 1 -Expand browser_download_url
      return @{
        Tag = $tag
        Version = $version
        URL64 = $url64
      }
    }
  }
}

function global:au_BeforeUpdate { Get-RemoteFiles -Purge -NoSuffix }

function global:au_SearchReplace {
  @{
    ".\legal\VERIFICATION.txt" = @{
      "(?i)(\s+x64:).*"            = "`${1} $($Latest.URL64)"
      "(?i)(checksum64:).*"        = "`${1} $($Latest.Checksum64)"
    }
    ".\navi.nuspec" = @{
      '(/denisidoro/navi/blob/)[^/<]*' = "`${1}$($Latest.Tag)"
      '(/denisidoro/navi/releases/tag/)[^/<]*' = "`${1}$($Latest.Tag)"
      '(/denisidoro/navi@)[^/<]*' = "`${1}$($Latest.Version)"
    }
  }
}

Update-Package -ChecksumFor none
