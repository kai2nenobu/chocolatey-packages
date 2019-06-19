# <img src="https://cdn.jsdelivr.net/gh/knqyf263/pet/doc/logo.png" width="48" height="48"/> [![pet version][pet_version]][pet_package]

[pet_version]: https://img.shields.io/myget/kai2nenobu/v/pet.svg?label=pet
[pet_package]: https://www.myget.org/feed/kai2nenobu/package/nuget/pet

`pet` is written in Go, and therefore you can just grab the binary releases and drop it in your $PATH.

`pet` is a simple command-line snippet manager (inspired by [memo](https://github.com/mattn/memo)).
I always forget commands that I rarely use. Moreover, it is difficult to search them from shell history. There are many similar commands, but they are all different.

e.g.

- `$ awk -F, 'NR <=2 {print $0}; NR >= 5 && NR <= 10 {print $0}' company.csv` (What I am looking for)
- `$ awk -F, '$0 !~ "DNS|Protocol" {print $0}' packet.csv`
- `$ awk -F, '{print $0} {if((NR-1) % 5 == 0) {print "----------"}}' test.csv`

In the above case, I search by `awk` from shell history, but many commands hit.

Even if I register an alias, I forget the name of alias (because I rarely use that command).

So I made it possible to register snippets with description and search them easily.

## Features

`pet` has the following features.

- Register your command snippets easily.
- Use variables in snippets.
- Search snippets interactively.
- Run snippets directly.
- Edit snippets easily (config is just a TOML file).
- Sync snippets via Gist or GitLab Snippets automatically.
