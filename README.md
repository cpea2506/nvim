# peaNvim

Neovim config using native `vim.pack` - LSP, completion, formatting, and a focused plugin set.

## Requirements

- **Neovim nightly** + `git`
- **`ripgrep`** - fzf-lua grep backend
- **`cargo`** - building `blink.pairs`
- **`lazygit`** - git UI in terminal tab

## Quick start

```sh
git clone https://github.com/cpea2506/nvim.git ~/.config/nvim
```

Start Neovim - plugins bootstraps on first launch. Run `:Mason` to install LSP servers.

## What's inside

Plugin definitions live in [`plugin/`](plugin).

| Area            | Plugins                                                                            |
| --------------- | ---------------------------------------------------------------------------------- |
| Package manager | `vim.pack`                                                                         |
| UI              | `one_monokai`, `lualine`, `nvim-web-devicons`, `nvim-navic`                        |
| Navigation      | `dir`, `fzf-lua`                                                                   |
| Git             | `gitsigns`, `codediff.nvim`                                                        |
| Syntax          | `nvim-treesitter`, `nvim-treesitter-context`                                       |
| LSP             | `mason.nvim`, `nvim-lspconfig`, `roslyn.nvim`, `crates.nvim`                       |
| Completion      | `builtin completion`, `blink.pairs`, `friendly-snippets`                           |
| Editing         | `relative-toggle`, `select.nvim`, `input.nvim`, `nvim-surround`, `numb`, `quicker` |
| Formatting      | `conform.nvim`                                                                     |
| Debug           | `debugmaster.nvim`, `nvim-dap`, `nvim-dap-unity`                                   |

## Keymaps

Leader: `<Space>` ([`lua/pea/options.lua`](lua/pea/options.lua)).

### Window & buffer

| Key           | Mode | Action                      |
| ------------- | ---- | --------------------------- |
| `<C-h/j/k/l>` | n    | Navigate windows            |
| `<C-h/j/k/l>` | i    | Move cursor in insert       |
| `<C-s>`       | n    | Save                        |
| `<leader>w`   | n    | Save (no autocmds)          |
| `<C-e>`       | n    | Close buffer                |
| `<C-x>`       | t    | Exit terminal mode          |
| `< / >`       | v    | Indent left/right, reselect |
| `<leader>q`   | n    | Quit                        |

### LSP (buffer-local on attach)

[`lua/pea/lsp/keymaps.lua`](lua/pea/lsp/keymaps.lua)

| Key  | Action                           |
| ---- | -------------------------------- |
| `gd` | Definition                       |
| `gD` | Type definition                  |
| `gr` | References                       |
| `gi` | Implementation                   |
| `gl` | Line diagnostics                 |
| `gw` | Workspace diagnostics → quickfix |
| `gn` | Rename                           |
| `ga` | Code action (n/v)                |

### Search & files

[`plugin/picker.lua`](plugin/picker.lua)

| Key          | Action                         |
| ------------ | ------------------------------ |
| `<leader>e`  | Open builtin directory listing |
| `<leader>sf` | File search                    |
| `<leader>st` | Live grep                      |
| `<leader>sb` | Buffers                        |

### Terminal

[`plugin/terminal.lua`](plugin/terminal.lua) - uses native `term`.

| Key          | Action                                 |
| ------------ | -------------------------------------- |
| `<leader>gg` | Lazygit (tab)                          |
| `<leader>ai` | opencode (vsplit, width 80)            |
| `<leader>ac` | opencode --continue (vsplit, width 80) |

### Completion

[`plugin/cmp.lua`](plugin/cmp.lua)

**Insert mode:**

| Key               | Action                   |
| ----------------- | ------------------------ |
| `<C-k>` / `<C-j>` | Navigate                 |
| `<C-d>` / `<C-f>` | Scroll docs              |
| `<CR>` / `<Tab>`  | Accept / snippet forward |
| `<S-Tab>`         | Snippet backward         |

**Cmdline mode:**

| Key               | Action           |
| ----------------- | ---------------- |
| `<C-k>` / `<C-j>` | Navigate         |
| `<Tab>`           | Accept           |
| `<CR>`            | Accept and enter |

### Tools & plugin UI

| Key               | Context            | Action                 |
| ----------------- | ------------------ | ---------------------- |
| `<leader>ph`      | -                  | Update packages        |
| `<leader>ps`      | -                  | Sync packages          |
| `<leader>d`       | -                  | Toggle debug mode      |
| `[c`              | Treesitter-context | Jump to context        |
| `o`               | Mason              | Toggle package expand  |
| `d`               | Mason              | Uninstall package      |
| `<C-d>` / `<C-u>` | FzfLua picker      | Preview page down / up |

### Autocommands

[`lua/pea/autocmds.lua`](lua/pea/autocmds.lua)

| Behavior           | Detail                                  |
| ------------------ | --------------------------------------- |
| Yank highlight     | `TextYankPost` / `TextPutPost`          |
| Close help buffers | `q` in `help`, `man`, `qf`, `nvim-pack` |
| Equalize splits    | `VimResized` → `tabdo wincmd =`         |

## LSP servers

Server configs: [`after/lsp/`](after/lsp)

| Server       | Language         |
| ------------ | ---------------- |
| `emmylua_ls` | Lua              |
| `roslyn`     | C#               |
| `shaderls`   | ShaderLab / GLSL |

Custom filetypes ([`ftdetect/`](ftdetect)):

| Pattern             | Filetype     | Notes                  |
| ------------------- | ------------ | ---------------------- |
| `*.shader`          | `glsl`       | Enables `shaderls` LSP |
| `*.jslib`, `*.jpre` | `javascript` |                        |
| `*.asmdef`          | `json`       |                        |

Install via `:Mason`, override in `after/lsp/<server>.lua`.

## Formatting

**Conform** runs on save with LSP fallback ([`plugin/formatters.lua`](plugin/formatters.lua)).

| Language                                  | Formatter      |
| ----------------------------------------- | -------------- |
| JSON/JSONC, Markdown, JS, TS, Svelte, CSS | `prettier`     |
| C/C++                                     | `clang-format` |
| TOML                                      | `taplo`        |
| Shell                                     | `shfmt`        |
