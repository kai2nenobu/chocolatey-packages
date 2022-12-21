import-module au

function global:au_GetLatest {
  ## Find a latest release and extract zip URL from GitHub Releases
  $releases_info = gh api 'repos/yuru7/HackGen/releases' | ConvertFrom-Json
  foreach ($release in $releases_info) {
    $tag = $release.tag_name
    $pre = if ($release.prerelease) { '-pre' } else { '' }
    if (-not ($tag -match '^v[0-9]+\.[0-9]+\.[0-9]+')) {
      Write-Warning ('Ignore invalid tag name: "{0}"' -f $tag)
      continue
    }
    $version = ($tag -replace "^v","") + $pre
    $normalZip = $release.assets | Where-Object { $_.name -eq "HackGen_${tag}.zip" } | Select-Object -First 1 -Expand browser_download_url
    $nerdZip = $release.assets | Where-Object { $_.name -eq "HackGen_NF_${tag}.zip" } | Select-Object -First 1 -Expand browser_download_url
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
          Prefix = 'HackGen_NF'
        }
      }
    }
  }
}

function global:au_SearchReplace {
  @{
    ".\font-hackgen.nuspec" = @{
      '(/HackGen/blob/)[^/<]*' = "`${1}$($Latest.Tag)"
      '(/HackGen/releases/tag/)[^/<]*' = "`${1}$($Latest.Tag)"
      '(?i)(^\s*\<title\>).*(\<\/title\>)' = "`${1}$($Latest.Title)`${2}"
    }
    ".\tools\ChocolateyInstall.ps1" = @{
      "'common-(.*)\.ps1'" = "'common-$($Latest.PackageName).ps1'"
      '^([$]hackgenBase\s*=).*' = "`${1} '$($Latest.Prefix)_$($Latest.Tag)'"
      '^(\s*PackageName\s*=).*' = "`${1} '$($Latest.PackageName)'"
      '^(\s*Url\s*=).*' = "`${1} '$($Latest.URL32)'"
      '^(\s*Checksum\s*=).*' = "`${1} '$($Latest.Checksum32)'"
    }
    ".\tools\ChocolateyBeforeModify.ps1" = @{
      "'common-(.*)\.ps1'" = "'common-$($Latest.PackageName).ps1'"
    }
  }
}

function global:au_BeforeUpdate() {
  # Load font names from a common file
  . "tools/common-$($Latest.PackageName).ps1"
  $fontNames = ($hackgenFonts.Values | ForEach-Object { "- ``$_``" }) -join "`n"
  $regex = '(<!-- Begin font names -->)([^<]*)(<!-- End font names -->)'
  $fontNamesReplacement = '$1' + "`n`n" + $fontNames + "`n`n" + '$3'
  # Replace font names in README.md
  $readme = Get-Content -Raw -Path README.md -Encoding UTF8
  $readme | % { $_ -replace $regex,$fontNamesReplacement } `
    | % { [Text.Encoding]::UTF8.GetBytes($_) } `
    | Set-Content -Encoding Byte -Path README.md
}

Update-Package
