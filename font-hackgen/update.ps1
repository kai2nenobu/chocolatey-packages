import-module au

function global:au_GetLatest {
  ## Find a latest release and extract zip URL from GitHub Releases
  $releases = 'https://api.github.com/repos/yuru7/HackGen/releases'
  $releases_info = Invoke-RestMethod -Uri $releases
  foreach ($release in $releases_info) {
    $tag = $release.tag_name
    $pre = if ($release.prerelease) { '-pre' } else { '' }
    if (-not ($tag -match '^v[0-9]+\.[0-9]+\.[0-9]+')) {
      Write-Warning ('Ignore invalid tag name: "{0}"' -f $tag)
      continue
    }
    $version = ($tag -replace "^v","") + $pre
    $normalZip = $release.assets | Where-Object { $_.name -eq "HackGen_${tag}.zip" } | Select-Object -First 1 -Expand browser_download_url
    $nerdZip = $release.assets | Where-Object { $_.name -eq "HackGenNerd_${tag}.zip" } | Select-Object -First 1 -Expand browser_download_url
    return @{
      Tag = $tag
      Version = $version
      Streams = [ordered] @{
        'normal' = @{
          PackageName = 'font-hackgen'
          Title = 'Programming Font HackGen'
          URL32 = $normalZip
          Prefix = 'HackGen'
        }
        'nerd' = @{
          PackageName = 'font-hackgen-nerd'
          Title = 'Programming Font HackGen with Nerd Fonts'
          URL32 = $nerdZip
          Prefix = 'HackGenNerd'
        }
      }
    }
  }
}

function global:au_SearchReplace {
  # Replacement for font names
  if ($Latest.Stream -eq 'nerd') {
    $fontReplacement = 'HackGen${1}Nerd${3}'
  } else {
    $fontReplacement = 'HackGen${1}${3}'
  }
  @{
    ".\font-hackgen.nuspec" = @{
      '(/HackGen/blob/)[^/<]*' = "`${1}$($Latest.Tag)"
      '(/HackGen/releases/tag/)[^/<]*' = "`${1}$($Latest.Tag)"
      '(?i)(^\s*\<title\>).*(\<\/title\>)' = "`${1}$($Latest.Title)`${2}"
    }
    ".\tools\ChocolateyInstall.ps1" = @{
      '^([$]hackgenBase\s*=).*' = "`${1} '$($Latest.Prefix)_$($Latest.Tag)'"
      '^(\s*PackageName\s*=).*' = "`${1} '$($Latest.PackageName)'"
      '^(\s*Url\s*=).*' = "`${1} '$($Latest.URL32)'"
      '^(\s*Checksum\s*=).*' = "`${1} '$($Latest.Checksum32)'"
    }
    ".\tools\common.ps1" = @{
      'HackGen(35)?(Nerd)?(Console)?-' = $fontReplacement + '-'
    }
    ".\README.md" = @{
      '`HackGen(35)?(Nerd)?( Console)?`' = '`' + $fontReplacement + '`'
    }
  }
}

Update-Package
