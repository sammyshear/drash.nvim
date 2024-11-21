# drash.nvim

![GitHub License](https://img.shields.io/github/license/sammyshear/drash.nvim?style=for-the-badge)
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/sammyshear/drash.nvim/ci.yml?style=for-the-badge)

A Neovim plugin for helping to write a Drash/D'var Torah without leaving Neovim. It relies on the Sefaria API to provide info on the Parsha and any supporting texts you might need.

## Installation

### lazy.nvim

```lua
{
  "sammyshear/drash.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  opts = {}
}
```

## Development

### Format

The CI uses `stylua` to format the code; customize the formatting by editing `.stylua.toml`.

### Test

Uses [busted](https://lunarmodules.github.io/busted/) for testing. Install by using `luarocks --lua-version=5.1 install busted` then run `busted`
for your test cases.

Create test cases in the `spec` directory. Busted expects files in this directory to be named `foo_spec.lua`, with `_spec` as a suffix before the `.lua` file extension. For more usage details please check
[busted usage](https://lunarmodules.github.io/busted/)

### CI

- Auto generates doc from README.
- Runs the Busted integration tests
- Lints with `stylua`.
