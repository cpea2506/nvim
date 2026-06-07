# peaNvim

My Neovim config built around **lazy.nvim** with LSP, completion, formatting, and a focused plugin set.

## ✅ Requirements

- **Neovim nightly**
- **`git`**
- **`ripgrep`**
- **`cargo`**: building `blink.cmp` and `blink.pairs`
- **`lazygit`**
- **`dotnet`**: C# debug and Roslyn

**Windows note:** PowerShell is recommended. Shell settings are configured in [`lua/pea/options.lua`](lua/pea/options.lua).

## 🚀 Quick start

1. Clone this repo to your Neovim config directory:
   - macOS/Linux:

     ```sh
     git clone https://github.com/cpea2506/nvim.git ~/.config/nvim
     ```

   - Windows (PowerShell):

     ```sh
     git clone https://github.com/cpea2506/nvim.git $env:USERPROFILE\.config\nvim
     ```

2. Start Neovim. `lazy.nvim` bootstraps automatically on first launch.
3. Run `:Mason` to install LSP servers and external tools.

## 📦 What’s included

Plugins and features are defined in [`lua/pea/plugins/`](lua/pea/plugins).

| Area            | Plugins                                                                                             |
| --------------- | --------------------------------------------------------------------------------------------------- |
| Plugin manager  | **lazy.nvim**                                                                                       |
| UI              | `one_monokai`, `lualine`, `nvim-navic`, `nvim-web-devicons`                                         |
| Navigation      | `fyler`, `fzf-lua` (non-Windows), `telescope.nvim` (Windows)                                        |
| Git             | `gitsigns`, `conflict-marker`                                                                       |
| Syntax          | `arborist.nvim`, `nvim-treesitter-context`                                                          |
| LSP             | `mason.nvim`, `mason-lspconfig`, `nvim-lspconfig`, `roslyn.nvim`, `crates.nvim`                     |
| Completion      | `blink.lib`, `blink.cmp`, `blink.pairs`, `blink-ripgrep`, `friendly-snippets`                       |
| Editing UX      | `better-escape`, `select.nvim`, `input.nvim`, `nvim-surround`, `numb`, `relative-toggle`, `quicker` |
| Terminal        | `toggleterm.nvim`                                                                                   |
| Formatting      | `conform.nvim`                                                                                      |
| Linting         | `nvim-lint`                                                                                         |
| Debugging       | `debugmaster.nvim`, `nvim-dap`, `nvim-dap-unity`                                                    |
| CLI integration | Copilot CLI in ToggleTerm (`copilot --banner`)                                                      |

## ⌨️ Keymaps

Leader is `<Space>` ([`lua/pea/options.lua`](lua/pea/options.lua)).

### Navigation & Editing

Global keymaps ([`lua/pea/keymaps.lua`](lua/pea/keymaps.lua)):

| Key         | Mode | Action                    |
| ----------- | ---- | ------------------------- |
| `<C-h>`     | n    | Window left               |
| `<C-j>`     | n    | Window down               |
| `<C-k>`     | n    | Window up                 |
| `<C-l>`     | n    | Window right              |
| `<C-s>`     | n    | Save                      |
| `<C-e>`     | n    | Delete buffer             |
| `<C-t>`     | n    | Toggle terminal           |
| `<C-x>`     | t    | Terminal normal mode      |
| `<`         | v    | Indent left and reselect  |
| `>`         | v    | Indent right and reselect |
| `<leader>q` | n    | Quit                      |

### Code Navigation

LSP keymaps (buffer-local on attach, [`lua/pea/lsp/keymaps.lua`](lua/pea/lsp/keymaps.lua)):

| Key  | Mode | Action                            |
| ---- | ---- | --------------------------------- |
| `gd` | n    | Definition                        |
| `gD` | n    | Type definition                   |
| `gr` | n    | References                        |
| `gi` | n    | Implementation                    |
| `gl` | n    | Line diagnostics                  |
| `gw` | n    | Workspace diagnostics to quickfix |
| `gn` | n    | Rename                            |
| `ga` | n/v  | Code action                       |
| `gk` | n    | Run codelens                      |

### Searching & Projects

| Key          | Mode | Plugin           | Action                      |
| ------------ | ---- | ---------------- | --------------------------- |
| `<leader>e`  | n    | Fyler            | Open explorer               |
| `<leader>sg` | n    | FzfLua           | Global search (non-Windows) |
| `<leader>sf` | n    | FzfLua/Telescope | File search                 |
| `<leader>st` | n    | FzfLua/Telescope | Live grep                   |
| `<leader>sb` | n    | FzfLua/Telescope | Buffers                     |

### Tools & Utilities

| Key          | Mode | Plugin             | Action             |
| ------------ | ---- | ------------------ | ------------------ |
| `<leader>gg` | n    | ToggleTerm         | Toggle Lazygit     |
| `<leader>ai` | n    | ToggleTerm         | Toggle Copilot CLI |
| `<leader>d`  | n    | Debugmaster        | Toggle Debug Mode  |
| `[c`         | n    | Treesitter-context | Go to context      |

### Plugins & Manager

| Key          | Mode | Action       |
| ------------ | ---- | ------------ |
| `<leader>ph` | n    | Open Lazy UI |
| `<leader>ps` | n    | Lazy sync    |

### Autocommands

Close buffer (buffer-local, [`lua/pea/autocmds.lua`](lua/pea/autocmds.lua)):

| Key | Mode | FileType                           |
| --- | ---- | ---------------------------------- |
| `q` | n    | `help`, `man`, `qf`, `checkhealth` |

### Conflicts

`conflict-marker` buffer-local keymaps:

| Key     | Mode | Action                              |
| ------- | ---- | ----------------------------------- |
| `<C-j>` | n    | Jump to next conflict separator     |
| `<C-k>` | n    | Jump to previous conflict separator |
| `co`    | n    | Choose ours                         |
| `ct`    | n    | Choose theirs                       |
| `cb`    | n    | Choose both                         |
| `cn`    | n    | Choose none                         |

### Completion

Insert mode ([`lua/pea/plugins/cmp.lua`](lua/pea/plugins/cmp.lua)):

| Key       | Mode | Action                 |
| --------- | ---- | ---------------------- |
| `<C-k>`   | i    | Select previous        |
| `<C-j>`   | i    | Select next            |
| `<C-d>`   | i    | Scroll docs up         |
| `<C-f>`   | i    | Scroll docs down       |
| `<CR>`    | i    | Accept                 |
| `<Tab>`   | i    | Accept/snippet forward |
| `<S-Tab>` | i    | Snippet backward       |

Cmdline mode:

| Key     | Mode | Action           |
| ------- | ---- | ---------------- |
| `<C-k>` | c    | Select previous  |
| `<C-j>` | c    | Select next      |
| `<Tab>` | c    | Accept           |
| `<CR>`  | c    | Accept and enter |

### Plugin UI

| Key      | Mode | Plugin        | Action                |
| -------- | ---- | ------------- | --------------------- |
| `o`      | n    | Mason         | Toggle package expand |
| `d`      | n    | Mason         | Uninstall package     |
| `<C-d>`  | n    | FzfLua picker | Preview page down     |
| `<C-u>`  | n    | FzfLua picker | Preview page up       |
| `ctrl-d` | n    | FzfLua (fzf)  | Preview page down     |
| `ctrl-u` | n    | FzfLua (fzf)  | Preview page up       |

## 🧠 LSP servers and filetypes

Server overrides live in [`after/lsp/`](after/lsp):

- `lua_ls` (Lua)
- `roslyn` (C#)
- `shaderls` (ShaderLab/GLSL)

Custom filetype detection lives in [`ftdetect/`](ftdetect):

- `shaderlab.lua`
- `jslib.lua`

Install servers through `:Mason`, then tweak in `after/lsp/<server>.lua`.

## 🧹 Formatting & linting

### Formatting

Formatting uses **Conform** on save with LSP fallback ([`lua/pea/plugins/formatters.lua`](lua/pea/plugins/formatters.lua)).

| Language/Type | Formatter      |
| ------------- | -------------- |
| JSON/JSONC    | `prettier`     |
| Markdown      | `prettier`     |
| JavaScript    | `prettier`     |
| TypeScript    | `prettier`     |
| Svelte        | `prettier`     |
| CSS           | `prettier`     |
| C/C++         | `clang-format` |
| TOML          | `taplo`        |
| Shell         | `shfmt`        |

### Linting

Linting uses **nvim-lint** on save/read/insert leave ([`lua/pea/plugins/lints.lua`](lua/pea/plugins/lints.lua)).

| Language | Linter       |
| -------- | ------------ |
| Lua      | `selene`     |
| Shell    | `shellcheck` |
