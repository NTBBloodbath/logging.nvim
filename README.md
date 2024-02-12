# logging.nvim

A very simple and asynchronous logging library for Neovim plugins.

[![LuaRocks](https://img.shields.io/luarocks/v/NTBBloodbath/logging.nvim?style=for-the-badge&logo=lua&color=blue)](https://luarocks.org/modules/NTBBloodbath/logging.nvim)

> [!IMPORTANT]
> This logging library needs at least Neovim `>= 0.9`.

## Installation

### rocks.nvim

You can install `logging.nvim` through the following command:

```vim
:Rocks install logging.nvim
```

Although that is only if you are a plugin developer and you are working with the library.
If you are a user, you won't have to worry about installing `logging.nvim` yourself :)

### lazy.nvim

```lua
return {
    "NTBBloodbath/logging.nvim"
}
```

### packer.nvim

```lua
use "NTBBloodbath/logging.nvim"
```

## Usage

Using `logging.nvim` is very simple. The library is managed by instances of the
`Logger` class.

Creating a new instance of the logger is as simple as:
```lua
local logger = require("logging"):new({
   level_name = "debug",
   plugin_name = "my_plugin",
   save_logs = true,
})
```

And start using said instance to send your logs using `logger:level_name("foo")`!

Also, the `logger:debug(foo)` logs are verbose for a better experience during
the development of your plugins ;)

> [!IMPORTANT]
> You can see all the documentation for `logging.nvim` with `:h logging`

### Default configuration

The default configuration of `logging.nvim` is as follows:
- `log_level`: `"info"`
- `plugin_name`: `""`
- `save_logs`: `true`

The defaults are very healthy for production, you will only have to set the name
of your plugin! :D

## Acknowledgement

- [rmagatti/logger.nvim](https://github.com/rmagatti/logger.nvim), library from which `logging.nvim` was inspired.

## License

This project is licensed under [GPLv3](./LICENSE) license.
