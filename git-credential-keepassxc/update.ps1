#Requires -Modules Chocolatey-AU

function global:au_GetLatest {
  ## Find a latest release and extract installer URL from GitHub Releases
  $releases_info = gh api 'repos/Frederick888/git-credential-keepassxc/releases' | ConvertFrom-Json
  foreach ($release in $releases_info) {
    if (-not $release.prerelease) {
      $tag = $release.tag_name
      $version = $release.tag_name -replace "^v", ""
      $urlMinimal = $release.assets | Where-Object { $_.name -eq "windows-latest-minimal.zip" } | Select-Object -First 1 -Expand browser_download_url
      $urlFull = $release.assets | Where-Object { $_.name -eq "windows-latest-full.zip" } | Select-Object -First 1 -Expand browser_download_url
      return @{
        Version = $version
        Tag     = $tag
        URLMinimal   = $urlMinimal
        URLFull   = $urlFull
      }
    }
  }
}

function global:au_BeforeUpdate {
  # Get remote archives
  Invoke-WebRequest -Uri $Latest.UrlMinimal -Outfile "tools\windows-latest-minimal.zip"
  Invoke-WebRequest -Uri $Latest.UrlFull -Outfile "tools\windows-latest-full.zip"
  # Calculate checksum for archives
  $Latest.ChecksumMinimal = (Get-FileHash "tools\windows-latest-minimal.zip" -Algorithm SHA256).Hash
  $Latest.ChecksumFull = (Get-FileHash "tools\windows-latest-full.zip" -Algorithm SHA256).Hash
}

function global:au_SearchReplace {
  @{
    ".\legal\VERIFICATION.txt" = @{
      "(?i)(\s+minimal build:).*"     = "`${1} $($Latest.URLMinimal)"
      "(?i)(\s+full build:).*"     = "`${1} $($Latest.URLFull)"
      "(?i)(checksum minimal:).*" = "`${1} $($Latest.ChecksumMinimal)"
      "(?i)(checksum full:).*" = "`${1} $($Latest.ChecksumFull)"
    }
    ".\git-credential-keepassxc.nuspec"      = @{
      '(/Frederick888/git-credential-keepassxc/blob/)[^/<]*'         = "`${1}$($Latest.Tag)"
      '(/Frederick888/git-credential-keepassxc/releases/tag/)[^/<]*' = "`${1}$($Latest.Tag)"
    }
  }
}

Update-Package -ChecksumFor none
