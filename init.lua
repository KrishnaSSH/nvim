local config_dir = vim.fn.stdpath("config")
package.path = config_dir .. "/?.lua;" .. package.path

require("config.core")
require("config.plugins")
require("config.lsp")
