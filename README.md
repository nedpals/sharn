# Sharn (0.3.0)

<a href="https://www.buymeacoffee.com/slapden" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>

A small, zero-dependency, command-line utility application that allows you to modify your `shard.yml` manifest file without touching it. This includes the ability to add and remove dependencies, and lots of functionalities to be implemented in the future. **It's a companion and not a replacement for the [Shards](https://github.com/crystal-lang/shards) package manager.**

This program was rebuilt from scratch designed to be compatible with the latest and future versions of Crystal.

## Install

To install, you need to clone this repository, and invoke the `shards build` command.
```
git clone https://github.com/nedpals/sharn.git && cd sharn
shards build
```
  
## Roadmap
- [x] `add` command.
- [x] `remove` command.
- [ ] `inspect` command.
- [ ] `bump-version` command. 
- [ ] Testing
- [ ] And many more to come...

## Caveats (for now)
1. Adding packages to a non-existing key will be placed to the bottom. (They will be organized soon).

## Contributing

1. Fork it ( https://github.com/nedpals/sharn/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [nedpals](https://github.com/nedpals) Ned Palacios - creator, maintainer
