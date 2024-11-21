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
  opts = {
    -- default is english
    text_language = "english",
  }
}
```

## Usage

The plugin provides a command `Parsha` which will open the Parsha for the week and give you a buffer user command `Commentaries` which will allow you to telescope pick between commentaries on the Parsha.

The plugin also provides the `SearchSefaria` command which allows you to make use of the Sefaria ElasticSearch API to search any texts on the website for arbitrary queries.
The command takes an argument that is your search query and opens a telescope picker to allow you to select the text you want to see.

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
