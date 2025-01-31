This directory contains sources of [![git-credential-keepassxc][git-credential-keepassxc_version]][git-credential-keepassxc_package].
<!-- First 2 lines are stripped by AU -->

[git-credential-keepassxc_version]: https://img.shields.io/chocolatey/v/git-credential-keepassxc.svg?label=git-credential-keepassxc
[git-credential-keepassxc_package]: https://chocolatey.org/packages/git-credential-keepassxc

# `git-credential-keepassxc`

`git-credential-keepassxc` is a [Git credential](https://git-scm.com/docs/gitcredentials) helper that allows Git (and shell scripts) to get/store logins from/to [KeePassXC](https://keepassxc.org/).

It communicates with KeePassXC using [keepassxc-protocol](https://github.com/keepassxreboot/keepassxc-browser/blob/develop/keepassxc-protocol.md), which was originally designed for browser extensions.

Visit a [source repository](https://github.com/Frederick888/git-credential-keepassxc) and [document](https://github.com/Frederick888/git-credential-keepassxc/blob/master/README.md) for more details.

## Package parameters

This package installs a pre-built binary for `git-credential-keepassxc` released in [GitHub release page](https://github.com/Frederick888/git-credential-keepassxc/releases).

The following package parameters can be set.

| Parameter Name | Description | Valid Value | Default Value |
|---|---|---|---|
| `BuildType` | Build type for pre-built binary. `minimal` is built with no optional features, and `full` is built with all features. | `minimal`/`full` | `minimal` |

Example:

```sh
choco install git-credential-keepassxc --params '/BuildType:full'
```
