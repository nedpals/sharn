# sharn (Work in progress) (0.1.13)

A command line program built on Crystal that adds new commands for the [Shards](https://github.com/crystal-lang/shards) dependency manager. It is inspired from [Yarn](https://yarnpkg.com), a package manager for Javascript.

With Sharn, you don't have to write dependencies directly to your `shard.yml` file. Instead, you just have to type in the command and you're ready to go.

This is also my own version of the solution for [issue #144](https://github.com/crystal-lang/shards/issues/144) that is currently been discussed at the `crystal-lang/shards` repo.

**Note: This is not a replacement for Shards. Shards will still be used in installing your dependencies.**

## Installation

1. Clone this repo.
2. Build it with `crystal build`
3. Run it.
4. **FOR NOW**, manually install your dependencies through `crystal deps` or `shards install`.

## Usage
1.  Add dependency/dependencies.
```shell
sharn add depname:git/reponame
```

2. Remove dependency/dependencies
```shell
sharn remove depname1 depname2
```
3. Specify version.
```shell
sharn add depname:git/repo@0.1.0
```
**Note: version scopes such as `~>` and `=>` are not safe to use it yet as they will make a file in your working directory**

4. Specify git platform
```shell
sharn add [gitlab/github/bitbucket]:depname:git/repo
```
**Note: Currently you cannot add git URLs from other platforms that aren't listed above.**
**Tip: When none specified, it automatically identifies it as a GitHub repo.**

5. Specify branch with `--branch` option
```shell
sharn add depname:git/repo --branch master
```

### List of commands
```shell
sharn [OPTIONS] [SUBCOMMAND]

Additional commands for the Shards dependency manager.

Subcommands:
  add
  inspect
  install (default)
  remove

Options:
  -h, --help     show this help
  -v, --version  show version
```

## Development Roadmap

- [x] Primary commands (add, remove, inspect, install)
  - [x] `add` command
  - [x] `remove` command
  - [x] `inspect` command
  - [ ] `install` command
  - [ ] execute `shards install` in post-installation
  - [x] YAML manipulation 
  - [ ] Installing dev dependencies with `--dev` flag
  - [x] Specify git plaform
  - [x] Specify branch (with `--branch` option)
  - [ ] Specify version
    - [x] Just version number
    - [ ] `~>`, `=>`
	
## Quirks
You may have noticed that `shard.yml` file has been changed with some newlines/whitespaces removed. This is because the way YAML module in Crystal builds the markup but don't worry this is still valid YAML and it has no difference when installing dependencies compared with newlines/whitespaces.

## Contributing

1. Fork it ( https://github.com/nedpals/sharn/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [nedpals](https://github.com/nedpals) Ned Palacios - creator, maintainer