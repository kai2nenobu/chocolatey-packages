#Requires -Modules Chocolatey-AU

function global:au_GetLatest {
  ## Find a latest release and extract installer URL from GitHub Releases
  $releases_info = gh api 'repos/rhysd/actionlint/releases' | ConvertFrom-Json
  foreach ($release in $releases_info) {
    if (-not $release.prerelease) {
      $tag = $release.tag_name
      $version = $release.tag_name -replace "^v", ""
      $url32 = $release.assets | Where-Object { $_.name -like "*_windows_386.zip" } | Select-Object -First 1 -Expand browser_download_url
      $url64 = $release.assets | Where-Object { $_.name -like "*_windows_amd64.zip" } | Select-Object -First 1 -Expand browser_download_url
      return @{
        Version = $version
        Tag     = $tag
        URL32   = $url32
        URL64   = $url64
      }
    }
  }
}

function global:au_BeforeUpdate { Get-RemoteFiles -Purge -NoSuffix }

function global:au_SearchReplace {
  @{
    ".\legal\VERIFICATION.txt" = @{
      "(?i)(\s+x32:).*"     = "`${1} $($Latest.URL32)"
      "(?i)(\s+x64:).*"     = "`${1} $($Latest.URL64)"
      "(?i)(checksum32:).*" = "`${1} $($Latest.Checksum32)"
      "(?i)(checksum64:).*" = "`${1} $($Latest.Checksum64)"
    }
    ".\actionlint.nuspec"      = @{
      '(/rhysd/actionlint/blob/)[^/<]*'         = "`${1}$($Latest.Tag)"
      '(/rhysd/actionlint/releases/tag/)[^/<]*' = "`${1}$($Latest.Tag)"
    }
  }
}

Update-Package -ChecksumFor none
