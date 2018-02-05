# Sharn (0.2.0) [![Donate using Liberapay](https://liberapay.com/assets/widgets/donate.svg)](https://liberapay.com/ned/donate)
A CLI app built on Crystal that makes managing shards easier.

No more writing to `shards.yml` by hand. In just a command, Sharn will handle everything for you.

This is also my own version of the solution for crystal-lang/shards#144 that is currently been discussed at the `crystal-lang/shards` repo.

**Note: This is not a replacement for [Shards](https://github.com/crystal-lang/shards). It will still be used in installing your dependencies.**

## Installation

1. Clone this repo.
2. Build it by running `build.sh`
3. Run it.

## Usage
1.  Add dependency/dependencies.
```shell
sharn add git/reponame
```
1.1 **(new)** Add development dependencies with `dev-add`
```shell
sharn dev-add git/reponame
```
2. Remove dependency/dependencies
```shell
sharn rm depname1 depname2
```
3. Specify version.
```shell
sharn add git/repo@0.1.0
```
4. Specify git platform
```shell
sharn add [gitlab/github/bitbucket]:git/repo
```

**Tip: By default, when none is specified, Sharn will automatically identifies it as a GitHub repo.**

5. Specify branch.
```shell
sharn add git/repo#master
```

## Development Roadmap

- [x] Primary commands (add, remove, inspect, install)
  - [x] `add` command
  - [x] `remove` command
  - [x] `inspect` command
  - [x] `install` command
  - [x] `update` command
- [x] `dev-add` command **(new!)**
- [x] execute `shards install` in post-installation
- [x] YAML manipulation 
- [x] ~~Installing dev dependencies with `--dev` flag(*)~~ (Replaced with `dev-add` command)
- [x] Specify git plaform
- [x] Specify branch (with `--branch` option)
- [x] Specify version
- [x] Just version number
  - [x] `~>`, `=>`, `<=`, `>`, `<`
  
## Quirks
1. You may have noticed that your `shard.yml` file has been changed with newlines/whitespaces removed. This is because the way YAML module in Crystal builds the markup but don't worry this is still valid YAML and it has no difference when installing dependencies compared with newlines/whitespaces.

~~2. Dependencies added using the `--dev` flag are now working but not added in the correct order as per [shard.yml specification](https://github.com/crystal-lang/shards/blob/master/SPEC.md).~~ (Solved in https://github.com/nedpals/sharn/commit/644280a50a69880c0a329454b2cf884979581a5b)

## Contributing

1. Fork it ( https://github.com/nedpals/sharn/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [nedpals](https://github.com/nedpals) Ned Palacios - creator, maintainer
