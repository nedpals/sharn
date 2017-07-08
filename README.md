# sharn (Work in progress) (0.1.11)

A command line program built on Crystal that adds new commands for the [Shards](https://github.com/crystal-lang/shards) dependency manager. It is inspired from [Yarn](https://yarnpkg.com), a package manager for Javascript.

With Sharn, you don't have to write dependencies directly to your `shard.yml` file. Instead, you just have to type in the command and you're ready to go.

This is also my own version of the solution for [issue #144](https://github.com/crystal-lang/shards/issues/144) that is currently been discussed at the `crystal-lang/shards` repo.

**Note: This is not a replacement for Shards. Shards will still be used in installing your dependencies.**

## Installation

1. Clone this repo.
2. Build it with `crystal build`
3. Run it.
4. **For now**, manually install the dependencies through `crystal deps` or `shards install`.

## Usage

```shell
sharn [OPTIONS] [SUBCOMMAND]

Additional commands for the Shards package manager.

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
I work this project during weekends and have a long free time. Right now here's what 

- [x] Primary commands (add, remove, inspect, install)
  - [x] `add` command
  - [x] `remove` command
  - [x] `inspect` command
  - [ ] `install` command
  - [ ] add `shards install` command for postinstall
  - [x] YAML manipulation 
  - [ ] Installing dev dependencies with `--dev` flag
  - [ ] Specify git provider
  - [ ] Specify branch
	
## Quirks
You may have noticed that `shard.yml` has changed with some newlines/whitespaces removed. This is because the way YAML module in Crystal builds but don't worry this is still valid YAML and it has no difference when installing dependencies.

## Contributing

1. Fork it ( https://github.com/nedpals/sharn/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [nedpals](https://github.com/nedpals) Ned Palacios - creator, maintainer
