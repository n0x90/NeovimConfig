# NeovimConfig

Personal Neovim configuration shared by Linux (Kali, X11/XFCE, tmux) and macOS
(iTerm2, optionally tmux), targeting Neovim 0.12.5.

## Requirements

- Neovim 0.12.5
- Git, curl, tar, gzip, and unzip (macOS's built-in BSD tar works)
- A C compiler and `tree-sitter-cli` 0.26.1 or newer; the Tree-sitter library
  installed as a Neovim dependency is **not** the CLI
- ripgrep and fd 8.4 or newer for project-wide picker and TODO searches
- Node.js/npm and Python with pip/venv for Mason's configured tools
- A Rust toolchain including `rustfmt` and `clippy` for Rust development
- A Nerd Font 3.3 or newer installed **and selected in the terminal profile**
- Linux/X11: `xsel` and a working `DISPLAY` for the clipboard
- macOS: built-in `pbcopy`/`pbpaste`; no X11 or `xsel` needed

## Installation

Back up any existing Neovim configuration, then clone this repository:

```sh
git clone https://github.com/n0x90/NeovimConfig.git ~/.config/nvim
```

### macOS

Install Apple's Command Line Tools if `clang --version` fails:

```sh
xcode-select --install
```

With [Homebrew](https://brew.sh) installed and on your shell's PATH:

```sh
brew bundle --file ~/.config/nvim/Brewfile
```

For Rust development, install [rustup](https://rustup.rs) if you do not already
have a toolchain, then run:

```sh
rustup toolchain install stable
rustup component add rustfmt clippy
```

Use rustup for Rust on both platforms; the Brewfile deliberately does not install
a second Rust toolchain. Follow Homebrew/rustup's shell setup instructions so
`brew`, `node`, `tree-sitter`, and `cargo` are visible in a new iTerm2 session.

In iTerm2 Settings → Profiles → Text, select **JetBrainsMono Nerd Font Mono**
for the profile you actually use. Keep the terminal type `xterm-256color` outside
tmux; tmux manages its own terminal type. All leader mappings use **Space**, and
Control mappings use **Control**, not Command. If macOS captures Ctrl-Space for
input-source switching, use **Ctrl-G** in insert mode to open completion.

### Linux / Kali

Keep your existing packages and terminal settings. On a fresh installation,
install the requirements above through your distribution's package manager;
check `nvim --version` and `tree-sitter --version` since distribution packages
may be older than required. If fd is packaged as `fdfind`, Snacks supports that
executable too. Use your existing X11 clipboard setup.

### First launch (both platforms)

```sh
nvim
```

Leave Neovim open while Lazy installs plugins, Mason installs language tools, and
Tree-sitter compiles parsers. Quitting early aborts pending installations.
`:Mason` shows tool installation progress; `:TSLog` shows parser progress/errors.
Restart once installation finishes. Normal launches retry missing tools/parsers.

Mason installs the configured language servers, `prettier`, `prettierd`, and the
Python debug adapter. Tree-sitter installs the configured parsers, including
`markdown` and `markdown_inline` for LSP hover documentation (`K`).

Run `:checkhealth` and `:ConformInfo` in a source file to diagnose remaining
issues. Health checks also report optional features this configuration does not
use: Go/PHP/Java/Julia, remote Python/Node/Ruby/Perl providers, LuaRocks, and Snacks
image rendering/lazygit. Those warnings alone do not require installing packages.
Snacks' image renderer requires a supported graphics terminal; this configuration
uses its picker, which works in iTerm2.

## One repository for both machines

Keep the same branch, Lua files, and committed `lazy-lock.json` on both machines.
The lockfile pins plugin source versions; each machine installs its own native
parsers and Mason binaries under Neovim's local data directory. Do not copy those
installed data/cache directories between Linux and macOS.

The shared `clipboard=unnamedplus` setting lets Neovim choose `pbcopy`/`pbpaste`
on macOS and an available X11 provider on Kali. No OS-specific branches or config
copies are needed. If a future feature needs platform-specific behavior, gate
just that feature with `vim.fn.has("macunix") == 1` and preserve the Linux default.

After publishing configuration changes, update either machine with:

```sh
git -C ~/.config/nvim pull
```

Use `:Lazy restore` to align already-installed plugins with the committed
lockfile, then `:TSUpdate` if Tree-sitter changed. Run `brew bundle` again when the
Brewfile changes. Use `:Lazy update` only when intentionally updating plugin
versions, and commit that lockfile change for both machines.

Any separate tmux configuration must also use platform-appropriate clipboard
commands: `pbcopy` on macOS and your existing `xsel` command on X11. This repository
does not contain or manage a tmux configuration.

References: [Tree-sitter requirements](https://github.com/nvim-treesitter/nvim-treesitter#requirements),
[Neovim clipboard providers](https://neovim.io/doc/user/provider/#clipboard-tool),
[Homebrew Bundle](https://docs.brew.sh/Brew-Bundle-and-Brewfile).
