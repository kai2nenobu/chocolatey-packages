[![AppVeyor Build status](https://ci.appveyor.com/api/projects/status/1vv03ri8bujes620/branch/master?svg=true)](https://ci.appveyor.com/project/kai2nenobu/chocolatey-packages/branch/master)

# What is this repository?

This repository stores chocolatey packages for my own.

These packages are built on [AppVeyor](https://www.appveyor.com/) and stored in [MyGet public feed](https://www.myget.org/F/kai2nenobu).
Some packages are automatically updated by using [AU](https://github.com/majkinetor/au). ([Update Report](https://gist.github.com/kai2nenobu/4df33f42a891ced2fe169974fd3d58ec))

# Package List

| id         | title                                                        | version                                    | embedded? | auto update? |
|------------|--------------------------------------------------------------|--------------------------------------------|-----------|--------------|
| [pet](pet) | [pet : CLI Snippet Manager](https://github.com/knqyf263/pet) | [![pet version][pet_version]][pet_package] | ✓         | ✓            |

[pet_version]: https://img.shields.io/myget/kai2nenobu/v/pet.svg?label=myget
[pet_package]: https://www.myget.org/feed/kai2nenobu/package/nuget/pet

If you want to know the complete list, see https://www.myget.org/F/kai2nenobu/api/v3/query.

# How to use

Install a package with an above feed url.

```
> choco install <package_id> --source https://www.myget.org/F/kai2nenobu
```

Or add an above feed to your chocolatey source and install a package.

```
> choco source add --name kai2nenobu --source https://www.myget.org/F/kai2nenobu
> choco install <package_id>
```

# References

- [CreatePackages](https://chocolatey.org/docs/create-packages)
- [Build Services](https://docs.myget.org/docs/reference/build-services)
