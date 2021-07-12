This directory contains sources of [![actionlint][actionlint_version]][actionlint_package].
<!-- First 2 lines are stripped by AU -->

[actionlint_version]: https://img.shields.io/chocolatey/v/actionlint.svg?label=actionlint
[actionlint_package]: https://chocolatey.org/packages/actionlint

actionlint
==========

[actionlint][repo] is a static checker for GitHub Actions workflow files. [Try it online!][playground]

Features:

- **Syntax check for workflow files** to check unexpected or missing keys following [workflow syntax][syntax-doc]
- **Strong type check for `${{ }}` expressions** to catch several semantic errors like access to not existing property,
  type mismatches, ...
- **[shellcheck][] and [pyflakes][] integrations** for scripts in `run:`
- **Other several useful checks**; [glob syntax][filter-pattern-doc] validation, dependencies check for `needs:`,
  runner label validation, cron syntax validation, ...

See [README](https://github.com/rhysd/actionlint/blob/main/README.md) for more details.

**Example of broken workflow:**

```yaml
on:
  push:
    branch: main
    tags:
      - 'v\d+'
jobs:
  test:
    strategy:
      matrix:
        os: [macos-latest, linux-latest]
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v2
      - uses: actions/cache@v2
        with:
          path: ~/.npm
          key: ${{ matrix.platform }}-node-${{ hashFiles('**/package-lock.json') }}
        if: ${{ github.repository.permissions.admin == true }}
      - run: npm install && npm test
```

**Output from actionlint:**

<img src="https://github.com/rhysd/ss/blob/master/actionlint/main.png?raw=true" alt="output example" width="850" height="621"/>
<!-- content of screenshot:
> actionlint
.github/workflows/test.yaml:3:5: unexpected key "branch" for "push" section. expected one of "branches", "branches-ignore", "paths", "paths-ignore", "tags", "tags-ignore", "types", "workflows" [syntax-check]
  |
3 |     branch: main
  |     ^~~~~~~
.github/workflows/test.yaml:5:11: character '\' is invalid for branch and tag names. only special characters [, ?, +, *, \ ! can be escaped with \. see `man git-check-ref-format` for more details. note that regular expression is unavailable. note: filter pattern syntax is explained at https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#filter-pattern-cheat-sheet [glob]
  |
5 |       - 'v\d+'
  |           ^~~~
.github/workflows/test.yaml:10:28: label "linux-latest" is unknown. available labels are "windows-latest", "windows-2019", "windows-2016", "ubuntu-latest", "ubuntu-20.04", "ubuntu-18.04", "ubuntu-16.04", "macos-latest", "macos-11", "macos-11.0", "macos-10.15", "self-hosted", "linux", "macos", "windows", "x64", "arm", "arm64". if it is a custom label for self-hosted runner, set list of labels in actionlint.yaml config file [runner-label]
   |
10 |         os: [macos-latest, linux-latest]
   |                            ^~~~~~~~~~~~~
.github/workflows/test.yaml:17:20: property "platform" is not defined in object type {os: string} [expression]
   |
17 |           key: ${{ matrix.platform }}-node-${{ hashFiles('**/package-lock.json') }}
   |                    ^~~~~~~~~~~~~~~
.github/workflows/test.yaml:18:17: receiver of object dereference "permissions" must be type of object but got "string" [expression]
   |
18 |         if: ${{ github.repository.permissions.admin == true }}
   |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-->

Basically all you need to do is running `acitonlint` command in your repository. actionlint automatically detects workflows in
your repository and reports errors in them. actionlint focuses on finding out mistakes. It tries to catch errors as much as
possible and make false positives as minimal as possible.

[repo]: https://github.com/rhysd/actionlint
[playground]: https://rhysd.github.io/actionlint/
[shellcheck]: https://github.com/koalaman/shellcheck
[shellcheck-install]: https://github.com/koalaman/shellcheck#installing
[pyflakes]: https://github.com/PyCQA/pyflakes
[filter-pattern-doc]: https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#filter-pattern-cheat-sheet
