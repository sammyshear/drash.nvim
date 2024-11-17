# drash.nvim

A Neovim plugin for helping to write a Drash/D'var Torah in without leaving Neovim. It relies on the Sefaria API to provide info on the Parsha and any supporting texts you might need.

## Development

### Format

The CI uses `stylua` to format the code; customize the formatting by editing `.stylua.toml`.

### Test

Uses [busted](https://lunarmodules.github.io/busted/) for testing. Installs by using `luarocks --lua-version=5.1 install busted` then runs `busted ./test`
for your test cases.

Create test cases in the `test` folder. Busted expects files in this directory to be named `foo_spec.lua`, with `_spec` as a suffix before the `.lua` file extension. For more usage details please check
[busted usage](https://lunarmodules.github.io/busted/)

### CI

- Auto generates doc from README.
- Runs the Busted integration tests
- Lints with `stylua`.
