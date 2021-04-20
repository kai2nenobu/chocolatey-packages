import-module au

$fixed_json = @'
[
  {
    "url": "https://api.github.com/repos/denisidoro/navi/releases/41241772",
    "assets_url": "https://api.github.com/repos/denisidoro/navi/releases/41241772/assets",
    "upload_url": "https://uploads.github.com/repos/denisidoro/navi/releases/41241772/assets{?name,label}",
    "html_url": "https://github.com/denisidoro/navi/releases/tag/v2.15.1",
    "id": 41241772,
    "author": {
      "login": "github-actions[bot]",
      "id": 41898282,
      "node_id": "MDM6Qm90NDE4OTgyODI=",
      "avatar_url": "https://avatars.githubusercontent.com/in/15368?v=4",
      "gravatar_id": "",
      "url": "https://api.github.com/users/github-actions%5Bbot%5D",
      "html_url": "https://github.com/apps/github-actions",
      "followers_url": "https://api.github.com/users/github-actions%5Bbot%5D/followers",
      "following_url": "https://api.github.com/users/github-actions%5Bbot%5D/following{/other_user}",
      "gists_url": "https://api.github.com/users/github-actions%5Bbot%5D/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/github-actions%5Bbot%5D/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/github-actions%5Bbot%5D/subscriptions",
      "organizations_url": "https://api.github.com/users/github-actions%5Bbot%5D/orgs",
      "repos_url": "https://api.github.com/users/github-actions%5Bbot%5D/repos",
      "events_url": "https://api.github.com/users/github-actions%5Bbot%5D/events{/privacy}",
      "received_events_url": "https://api.github.com/users/github-actions%5Bbot%5D/received_events",
      "type": "Bot",
      "site_admin": false
    },
    "node_id": "MDc6UmVsZWFzZTQxMjQxNzcy",
    "tag_name": "v2.15.1",
    "target_commitish": "master",
    "name": "2.15.1",
    "draft": false,
    "prerelease": false,
    "created_at": "2021-04-11T15:04:28Z",
    "published_at": "2021-04-11T15:04:53Z",
    "assets": [
      {
        "url": "https://api.github.com/repos/denisidoro/navi/releases/assets/34810472",
        "id": 34810472,
        "node_id": "MDEyOlJlbGVhc2VBc3NldDM0ODEwNDcy",
        "name": "navi-v2.15.1-x86_64-pc-windows-gnu.zip",
        "label": "",
        "uploader": {
          "login": "github-actions[bot]",
          "id": 41898282,
          "node_id": "MDM6Qm90NDE4OTgyODI=",
          "avatar_url": "https://avatars.githubusercontent.com/in/15368?v=4",
          "gravatar_id": "",
          "url": "https://api.github.com/users/github-actions%5Bbot%5D",
          "html_url": "https://github.com/apps/github-actions",
          "followers_url": "https://api.github.com/users/github-actions%5Bbot%5D/followers",
          "following_url": "https://api.github.com/users/github-actions%5Bbot%5D/following{/other_user}",
          "gists_url": "https://api.github.com/users/github-actions%5Bbot%5D/gists{/gist_id}",
          "starred_url": "https://api.github.com/users/github-actions%5Bbot%5D/starred{/owner}{/repo}",
          "subscriptions_url": "https://api.github.com/users/github-actions%5Bbot%5D/subscriptions",
          "organizations_url": "https://api.github.com/users/github-actions%5Bbot%5D/orgs",
          "repos_url": "https://api.github.com/users/github-actions%5Bbot%5D/repos",
          "events_url": "https://api.github.com/users/github-actions%5Bbot%5D/events{/privacy}",
          "received_events_url": "https://api.github.com/users/github-actions%5Bbot%5D/received_events",
          "type": "Bot",
          "site_admin": false
        },
        "content_type": "binary/octet-stream",
        "state": "uploaded",
        "size": 2817140,
        "download_count": 13,
        "created_at": "2021-04-11T15:08:32Z",
        "updated_at": "2021-04-11T15:08:32Z",
        "browser_download_url": "https://github.com/denisidoro/navi/releases/download/v2.15.1/navi-v2.15.1-x86_64-pc-windows-gnu.zip"
      }
    ],
    "tarball_url": "https://api.github.com/repos/denisidoro/navi/tarball/v2.15.1",
    "zipball_url": "https://api.github.com/repos/denisidoro/navi/zipball/v2.15.1",
    "body": "### :sparkles: New features\r\n- [`9095e`](https://github.com/denisidoro/navi/commit/9095e) Publish binaries for more platforms, including Windows ([#490](https://github.com/denisidoro/navi/issues/490))\r\n\r\n### :bug: Fixes\r\n- [`d550b`](https://github.com/denisidoro/navi/commit/d550b) Fix path for downloaded cheats ([#493](https://github.com/denisidoro/navi/issues/493))\r\n- [`5a68b`](https://github.com/denisidoro/navi/commit/5a68b) Fix navi fn welcome ([#495](https://github.com/denisidoro/navi/issues/495))\r\n\r\n### :computer: Code quality\r\n- [`33c01`](https://github.com/denisidoro/navi/commit/33c01) Update demo video ([#488](https://github.com/denisidoro/navi/issues/488))\r\n- [`fb6a2`](https://github.com/denisidoro/navi/commit/fb6a2) Add link to more shell instructions"
  }
]
'@

function global:au_GetLatest {
  ## Find a latest release and extract installer URL from GitHub Releases
  #$releases = 'https://api.github.com/repos/denisidoro/navi/releases'
  #$releases_info = Invoke-RestMethod -Uri $releases
  $releases_info = $fixed_json | ConvertFrom-Json
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
    }
  }
}

Update-Package -ChecksumFor 64
