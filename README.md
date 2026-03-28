# peaNvim

My Neovim config built around **lazy.nvim** with LSP, completion, formatting, and a focused plugin set.

## ✅ Requirements

- **Neovim nightly**
- **`git`**
- **`ripgrep`**
- **`cargo`**: Building `blink.cmp` and `blink.pairs`
- **`lazygit`**
- **`dotnet`**: C# debug and LSP (Roslyn)

**Windows note:** On Windows, Powershell is recommended as the shell is configured to use `pwsh` with UTF‑8 pipe/redirection settings ([`lua/pea/options.lua`](lua/pea/options.lua)).

## 🚀 Quick start

1. Clone this repo to your Neovim config directory:
   - macOS:

     ```sh
     git clone https://github.com/cpea2506/nvim.git ~/.config/nvim
     ```

   - Windows (PowerShell):

     ```sh
     git clone https://github.com/cpea2506/nvim.git $env:USERPROFILE\.config\nvim
     ```

2. Start Neovim. `lazy.nvim` bootstraps automatically and runs `:Lazy sync` on first start.
3. Run `:Mason` to install LSP servers and tools.

## 📦 What’s included

Plugins and features are defined in [`lua/pea/plugins/`](lua/pea/plugins).

| Area           | Plugins                                                                              |
| -------------- | ------------------------------------------------------------------------------------ |
| Plugin manager | **lazy.nvim**                                                                        |
| UI             | `one_monokai`, `lualine`, `navic`, `nvim-web-devicons`                               |
| Navigation     | `fzf-lua`, `fyler`                                                                   |
| Git            | `gitsigns`, `conflict-marker`                                                        |
| Treesitter     | `nvim-treesitter`, `treesitter-context`                                              |
| LSP            | `mason.nvim`, `mason-lspconfig`, `nvim-lspconfig`, `roslyn.nvim`                     |
| Completion     | `blink.cmp`, `friendly-snippets`, `blink-ripgrep`                                    |
| Editing UX     | `better-escape`, `input.nvim`, `nvim-surround`, `numb`, `relative-toggle`, `quicker` |
| Terminal       | `toggleterm.nvim`                                                                    |
| Formatting     | `conform.nvim`                                                                       |
| Linting        | `nvim-lint`                                                                          |
| Debugging      | `nvim-dap`, `debugmaster.nvim`                                                       |
| AI             | `sidekick.nvim`                                                                      |

## 🧭 Repo layout

| Path                                           | Purpose                                   |
| ---------------------------------------------- | ----------------------------------------- |
| [`init.lua`](init.lua)                         | Bootstrap lazy.nvim and load modules      |
| [`lua/pea/options.lua`](lua/pea/options.lua)   | Editor options + Windows shell tweaks     |
| [`lua/pea/autocmds.lua`](lua/pea/autocmds.lua) | Autocmds                                  |
| [`lua/pea/keymaps.lua`](lua/pea/keymaps.lua)   | Core keymaps                              |
| [`lua/pea/onkeys.lua`](lua/pea/onkeys.lua)     | Runtime key listeners (hlsearch behavior) |
| [`lua/pea/lsp/`](lua/pea/lsp)                  | LSP setup, handlers, keymaps              |
| [`lua/pea/plugins/`](lua/pea/plugins)          | Plugin specs and configs                  |
| [`after/lsp/`](after/lsp)                      | Per‑server LSP overrides                  |
| [`ftdetect/`](ftdetect)                        | Custom filetype detection                 |
| [`lazy-lock.json`](lazy-lock.json)             | Plugin version lockfile                   |

## ⌨️ Keymaps

Leader is `<Space>` ([`lua/pea/options.lua`](lua/pea/options.lua)). Some mappings are buffer‑local or only active in plugin UIs.

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
| `<`         | v    | Indent left and reselect  |
| `>`         | v    | Indent right and reselect |
| `<leader>q` | n    | Quit                      |

### Code Navigation

LSP keymaps (buffer‑local on attach, [`lua/pea/lsp/keymaps.lua`](lua/pea/lsp/keymaps.lua)):

| Key  | Mode | Action           |
| ---- | ---- | ---------------- |
| `gd` | n    | Definition       |
| `gD` | n    | Type definition  |
| `gr` | n    | References       |
| `gi` | n    | Implementation   |
| `gl` | n    | Line diagnostics |
| `gn` | n    | Rename           |
| `ga` | n/v  | Code action      |

### Searching & Projects

| Key          | Mode | Plugin | Action                |
| ------------ | ---- | ------ | --------------------- |
| `<leader>e`  | n    | Fyler  | Open explorer         |
| `<leader>sg` | n    | FzfLua | Global search         |
| `<leader>sf` | n    | FzfLua | File search           |
| `<leader>st` | n    | FzfLua | Live grep             |
| `<leader>sb` | n    | FzfLua | Buffers               |
| `<leader>sd` | n    | FzfLua | Workspace diagnostics |

### Tools & Utilities

| Key          | Mode | Plugin             | Action                          |
| ------------ | ---- | ------------------ | ------------------------------- |
| `<leader>gg` | n    | ToggleTerm         | Toggle Lazygit                  |
| `[c`         | n    | Treesitter‑context | Go to context                   |
| `<leader>d`  | n    | Debugmaster        | Toggle Debug Mode               |
| `<Tab>`      | n    | Sidekick           | Goto/apply next edit suggestion |
| `<leader>ai` | n    | Sidekick           | Toggle Copilot CLI sidekick     |

### Plugins & Manager

| Key          | Mode | Action       |
| ------------ | ---- | ------------ |
| `<leader>ph` | n    | Open Lazy UI |
| `<leader>ps` | n    | Lazy sync    |

### Autocommands

Close buffer (buffer‑local, [`lua/pea/autocmds.lua`](lua/pea/autocmds.lua)):

| Key | Mode | FileType                           |
| --- | ---- | ---------------------------------- |
| `q` | n    | `help`, `man`, `qf`, `checkhealth` |

### Conflicts

conflict‑marker (buffer‑local, conflict buffers):

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

- `lua_ls` for Lua
- `roslyn` for C#
- `shaderls` for ShaderLab/GLSL (plus [`ftdetect/shaderlab.lua`](ftdetect/shaderlab.lua))

Install servers through `:Mason`, then tweak settings in [`after/lsp/<server>.lua`](after/lsp) if needed.

## 🧹 Formatting & linting

### Formatting

Formatting uses **Conform** on save with LSP fallback ([`lua/pea/plugins/formatters.lua`](lua/pea/plugins/formatters.lua)).

Configured formatters:

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

Install these via `:Mason` or your system package manager.

### Linting

Linting uses **nvim-lint** on save/read/insert leave ([`lua/pea/plugins/lints.lua`](lua/pea/plugins/lints.lua)).

Configured linters:

| Language | Linter       |
| -------- | ------------ |
| Lua      | `selene`     |
| Shell    | `shellcheck` |

Install these via `:Mason` or your system package manager.
