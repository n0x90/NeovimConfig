# NeovimConfig

Personal Neovim configuration for Linux, targeting Neovim 0.12.5.

## Requirements

- Neovim 0.12.5
- Git, curl, GNU tar, gzip, and unzip
- A C compiler and `tree-sitter-cli` 0.26.1 or newer
- ripgrep and fd 8.4 or newer for project-wide picker and TODO searches
- `xsel` and a working `DISPLAY` for the X11 clipboard (including the companion tmux bindings)
- Node.js/npm, Python, and the Rust toolchain for the configured language servers, formatters, and debugger
- `rustfmt` for Rust formatting
- A Nerd Font 3.3 or newer installed and selected in the Linux terminal for icons

Mason installs the configured language servers, `prettier`, `prettierd`, and the
Python debug adapter. Tree-sitter installs the configured parsers on first use.
This includes `markdown` and `markdown_inline`, which Neovim uses to render LSP
hover documentation (`K`) even when editing another language. After the first
launch or pulling parser-list changes, let parser installation finish before
opening hover documentation; check `:TSLog` if installation fails.

## Installation

Back up any existing Neovim configuration, then clone this repository:

```sh
git clone https://github.com/n0x90/NeovimConfig.git ~/.config/nvim
nvim
```

Run `:checkhealth` after the first launch to identify any missing system tools.
