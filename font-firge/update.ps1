import-module au

function global:au_GetLatest {
  ## Find a latest release and extract zip URL from GitHub Releases
  $releases_info = gh api 'repos/yuru7/Firge/releases' | ConvertFrom-Json
  foreach ($release in $releases_info) {
    $tag = $release.tag_name
    if ($release.prerelease) {
      Write-Warning ('Ignore prerelease version: "{0}"' -f $tag)
      continue
    }
    if (-not ($tag -match '^v[0-9]+\.[0-9]+\.[0-9]+')) {
      Write-Warning ('Ignore invalid tag name: "{0}"' -f $tag)
      continue
    }
    $version = $tag -replace "^v", ""
    $normalZip = $release.assets | Where-Object { $_.name -eq "Firge_${tag}.zip" } | Select-Object -First 1 -Expand browser_download_url
    $nerdZip = $release.assets | Where-Object { $_.name -eq "FirgeNerd_${tag}.zip" } | Select-Object -First 1 -Expand browser_download_url
    return @{
      Tag     = $tag
      Version = $version
      Streams = [ordered] @{
        'normal' = @{
          PackageName = 'font-firge'
          Title       = 'Programming Font Firge'
          URL32       = $normalZip
          Prefix      = 'Firge'
        }
        'nerd'   = @{
          PackageName = 'font-firge-nerd'
          Title       = 'Programming Font Firge with Nerd Fonts'
          URL32       = $nerdZip
          Prefix      = 'FirgeNerd'
        }
      }
    }
  }
}

function global:au_SearchReplace {
  # Replacement for font names
  if ($Latest.Stream -eq 'nerd') {
    $fontReplacement = 'Firge${1}Nerd${3}'
  }
  else {
    $fontReplacement = 'Firge${1}${3}'
  }
  @{
    ".\font-firge.nuspec"           = @{
      '(/Firge/blob/)[^/<]*'               = "`${1}$($Latest.Tag)"
      '(/Firge/releases/tag/)[^/<]*'       = "`${1}$($Latest.Tag)"
      '(?i)(^\s*\<title\>).*(\<\/title\>)' = "`${1}$($Latest.Title)`${2}"
    }
    ".\tools\ChocolateyInstall.ps1" = @{
      '^([$]firgeBase\s*=).*'   = "`${1} '$($Latest.Prefix)_$($Latest.Tag)'"
      '^(\s*PackageName\s*=).*' = "`${1} '$($Latest.PackageName)'"
      '^(\s*Url\s*=).*'         = "`${1} '$($Latest.URL32)'"
      '^(\s*Checksum\s*=).*'    = "`${1} '$($Latest.Checksum32)'"
    }
    ".\tools\common.ps1"            = @{
      'Firge(35)?(Nerd)?(Console)?-' = $fontReplacement + '-'
    }
    ".\README.md"                   = @{
      '`Firge(35)?(Nerd)?( Console)?`' = '`' + $fontReplacement + '`'
    }
  }
}

Update-Package
