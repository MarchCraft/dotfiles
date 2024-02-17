return {
    {
        "nvim-treesitter/nvim-treesitter",
        event = "User File",
        build = function()
            require("nvim-treesitter.install").update({ with_sync = true })
        end,
        opts = {
            ensure_installed = {
                "bash",
                "c",
                "clojure",
                "cmake",
                "cpp",
                "css",
                "diff",
                "dockerfile",
                "fish",
                "gitattributes",
                "gitcommit",
                "git_config",
                "gitignore",
                "git_rebase",
                "html",
                "ini",
                "java",
                "javascript",
                "json",
                "kotlin",
                "latex",
                "lua",
                "make",
                "markdown",
                "markdown_inline",
                "meson",
                "ninja",
                "nix",
                "python",
                "regex",
                "rust",
                "scss",
                "sql",
                "toml",
                "typescript",
                "vim",
                "yaml",
                "zig",
            },
            highlight = {
                enable = true,
            },
            indent = {
                true
            },
        },
        main = "nvim-treesitter.configs",
    },
}

