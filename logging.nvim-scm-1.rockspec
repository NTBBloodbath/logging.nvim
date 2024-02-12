local MAJOR, REV = "scm", "-1"
rockspec_format = "3.0"
package = "logging.nvim"
version = MAJOR .. REV

description = {
  summary = "A very simple and asynchronous logging library for Neovim plugins",
  labels = { "neovim", "logging", "library" },
  homepage = "https://github.com/NTBBloodbath/logging.nvim",
  license = "GPLv3",
}

dependencies = {
  "lua >= 5.1, < 5.4",
}

source = {
  url = "https://github.com/NTBBloodbath/logging.nvim/archive/" .. MAJOR .. ".zip",
  dir = "logging.nvim-" .. MAJOR,
}

if MAJOR == "scm" then
  source = {
    url = "git://github.com/NTBBloodbath/logging.nvim",
  }
end

build = {
  type = "builtin",
  copy_directories = {
    "doc",
  },
}
