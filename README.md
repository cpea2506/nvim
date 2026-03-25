# peaNvim

My Neovim config built around **lazy.nvim** with LSP, completion, formatting, and a focused plugin set.

## ✨ Highlights

- LSP managed by Mason with per‑server overrides and custom LSP UX
- `blink.cmp` completion with snippets and a ripgrep source
- Format on save via Conform + lint on edit via nvim‑lint
- Debugging with nvim‑dap + Debugmaster
- Fzf‑Lua, Fyler explorer, and Git helpers

## 🚀 Quick start

1. Clone this repo to your Neovim config directory:
   - macOS:
     ```
     git clone https://github.com/cpea2506/nvim.git ~/.config/nvim
     ```
   - Windows (PowerShell):
     ```
     git clone https://github.com/cpea2506/nvim.git $env:USERPROFILE\.config\nvim
     ```
2. Start Neovim. `lazy.nvim` bootstraps automatically (`init.lua`).
3. Run `:Lazy sync` (or `<leader>ps`) to install plugins.
4. Run `:Mason` to install LSP servers/tools you need.
5. Install optional tooling you want (formatters/linters, `ripgrep`, `lazygit`).

## ✅ Requirements

| Type                   | Tools                                                                                       | Notes                                                    |
| ---------------------- | ------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| Required               | Neovim 0.12+, `git`                                                                         | Neovim runtime + lazy.nvim bootstrap                     |
| Recommended            | `ripgrep`, `cargo`                                                                          | Completion source and building `blink.cmp`/`blink.pairs` |
| Optional               | `lazygit`, `dotnet`                                                                         | Git UI and C# debug/LSP                                  |
| Optional (format/lint) | `stylua`, `csharpier`, `prettier`, `clang-format`, `taplo`, `shfmt`, `selene`, `shellcheck` | Used by Conform/Nvim‑lint                                |

## 🧰 Common commands

| Task                  | Command        | Notes                      |
| --------------------- | -------------- | -------------------------- |
| Open Lazy UI          | `:Lazy`        | `<leader>ph`               |
| Sync plugins          | `:Lazy sync`   | `<leader>ps`               |
| Manage LSP tools      | `:Mason`       | Install servers/formatters |
| Update Mason registry | `:MasonUpdate` | Tool metadata refresh      |
| Formatting info       | `:ConformInfo` | See active formatters      |

## 📦 What’s included

Plugins and features are defined in `lua/pea/plugins/**`.

| Area           | Plugins                                                                              | Config                                                      | Notes                                                                  |
| -------------- | ------------------------------------------------------------------------------------ | ----------------------------------------------------------- | ---------------------------------------------------------------------- |
| Plugin manager | **lazy.nvim**                                                                        | `init.lua`, `lazy-lock.json`                                | Lazy‑load + lockfile                                                   |
| UI             | `one_monokai`, `lualine`, `navic`, `nvim-web-devicons`                               | `colorscheme.lua`, `lualine/**`, `winbar.lua`, `common.lua` | Theme, statusline, winbar, icons                                       |
| Navigation     | `fzf-lua`, `fyler`                                                                   | `picker.lua`, `explorer.lua`                                | Fuzzy finding + file explorer                                          |
| Git            | `gitsigns`, `conflict-marker`                                                        | `git.lua`                                                   | Signs, conflict helpers                                                |
| Treesitter     | `nvim-treesitter`, `treesitter-context`                                              | `treesitter.lua`                                            | Syntax + context                                                       |
| LSP            | `mason.nvim`, `mason-lspconfig`, `nvim-lspconfig`, `roslyn.nvim`                     | `lsp.lua`, `lsp/**`, `after/lsp/**`                         | LSP management + overrides                                             |
| Completion     | `blink.cmp`, `friendly-snippets`, `blink-ripgrep`                                    | `cmp.lua`                                                   | Completion + snippets                                                  |
| Editing UX     | `better-escape`, `input.nvim`, `nvim-surround`, `numb`, `relative-toggle`, `quicker` | `input.lua`, `number.lua`, `quickfix.lua`                   | Escape mapping, input UI, surround, line preview, numbers, quickfix UI |
| Terminal       | `toggleterm.nvim`                                                                    | `terminal.lua`                                              | Terminal toggle + Lazygit                                              |
| Formatting     | `conform.nvim`                                                                       | `formatters.lua`                                            | Format on save                                                         |
| Linting        | `nvim-lint`                                                                          | `lints.lua`                                                 | Lint on save/read/insert leave                                         |
| Debugging      | `nvim-dap`, `debugmaster.nvim`                                                       | `debugger/**`                                               | DAP + UI                                                               |
| AI             | `sidekick.nvim`                                                                      | `ai.lua`                                                    | Copilot CLI toggle                                                     |

## 🧭 Repo layout

| Path                   | Purpose                                   |
| ---------------------- | ----------------------------------------- |
| `init.lua`             | Bootstrap lazy.nvim and load modules      |
| `lua/pea/options.lua`  | Editor options + Windows shell tweaks     |
| `lua/pea/autocmds.lua` | Autocmds                                  |
| `lua/pea/keymaps.lua`  | Core keymaps                              |
| `lua/pea/onkeys.lua`   | Runtime key listeners (hlsearch behavior) |
| `lua/pea/lsp/**`       | LSP setup, handlers, keymaps              |
| `lua/pea/plugins/**`   | Plugin specs and configs                  |
| `after/lsp/**`         | Per‑server LSP overrides                  |
| `ftdetect/**`          | Custom filetype detection                 |
| `lazy-lock.json`       | Plugin version lockfile                   |

## ⌨️ Keymaps

Leader is `<Space>` (`lua/pea/options.lua`). Some mappings are buffer‑local or only active in plugin UIs.

Global keymaps (`lua/pea/keymaps.lua`):

| Mode | Key          | Action                    |
| ---- | ------------ | ------------------------- |
| n    | `<leader>q`  | Quit                      |
| n    | `<C-s>`      | Save                      |
| n    | `<C-e>`      | Delete buffer             |
| n    | `<C-h>`      | Window left               |
| n    | `<C-j>`      | Window down               |
| n    | `<C-k>`      | Window up                 |
| n    | `<C-l>`      | Window right              |
| v    | `<`          | Indent left and reselect  |
| v    | `>`          | Indent right and reselect |
| n    | `<leader>ph` | `:Lazy`                   |
| n    | `<leader>ps` | `:Lazy sync`              |

LSP keymaps (buffer‑local on attach, `lua/pea/lsp/keymaps.lua`):

| Mode | Key  | Action           |
| ---- | ---- | ---------------- |
| n    | `gd` | Definition       |
| n    | `gD` | Type definition  |
| n    | `gr` | References       |
| n    | `gi` | Implementation   |
| n    | `gl` | Line diagnostics |
| n    | `gn` | Rename           |
| n/v  | `ga` | Code action      |

Autocmd keymaps (buffer‑local, `lua/pea/autocmds.lua`):

| Mode | Key | Action       | Scope                              |
| ---- | --- | ------------ | ---------------------------------- |
| n    | `q` | Close buffer | `help`, `man`, `qf`, `checkhealth` |

Plugin keymaps (global):

| Plugin             | Mode | Key          | Action                          |
| ------------------ | ---- | ------------ | ------------------------------- |
| Fyler              | n    | `<leader>e`  | Open explorer                   |
| FzfLua             | n    | `<leader>sg` | Global search                   |
| FzfLua             | n    | `<leader>sf` | File search                     |
| FzfLua             | n    | `<leader>st` | Live grep                       |
| FzfLua             | n    | `<leader>sb` | Buffers                         |
| FzfLua             | n    | `<leader>sd` | Workspace diagnostics           |
| ToggleTerm         | n    | `<C-t>`      | Toggle terminal                 |
| ToggleTerm         | n    | `<leader>gg` | Toggle Lazygit                  |
| Treesitter‑context | n    | `[c`         | Go to context                   |
| Debugmaster        | n    | `<leader>d`  | Toggle Debug Mode               |
| Sidekick           | n    | `<Tab>`      | Goto/apply next edit suggestion |
| Sidekick           | n    | `<leader>ai` | Toggle Copilot CLI sidekick     |

Plugin keymaps (buffer‑local):

| Plugin          | Mode | Key     | Action                              | Scope           |
| --------------- | ---- | ------- | ----------------------------------- | --------------- |
| conflict‑marker | n    | `<C-j>` | Jump to next conflict separator     | conflict buffer |
| conflict‑marker | n    | `<C-k>` | Jump to previous conflict separator | conflict buffer |
| conflict‑marker | n    | `co`    | Choose ours                         | conflict buffer |
| conflict‑marker | n    | `ct`    | Choose theirs                       | conflict buffer |
| conflict‑marker | n    | `cb`    | Choose both                         | conflict buffer |
| conflict‑marker | n    | `cn`    | Choose none                         | conflict buffer |

Completion keymaps (blink.cmp, Insert mode):

| Mode | Key       | Action                 |
| ---- | --------- | ---------------------- |
| i    | `<C-k>`   | Select previous        |
| i    | `<C-j>`   | Select next            |
| i    | `<C-d>`   | Scroll docs up         |
| i    | `<C-f>`   | Scroll docs down       |
| i    | `<CR>`    | Accept                 |
| i    | `<Tab>`   | Accept/snippet forward |
| i    | `<S-Tab>` | Snippet backward       |

Cmdline completion keymaps (blink.cmp):

| Mode | Key     | Action           |
| ---- | ------- | ---------------- |
| c    | `<C-k>` | Select previous  |
| c    | `<C-j>` | Select next      |
| c    | `<Tab>` | Accept           |
| c    | `<CR>`  | Accept and enter |

Plugin UI keymaps:

| UI            | Key      | Action                |
| ------------- | -------- | --------------------- |
| Mason         | `o`      | Toggle package expand |
| Mason         | `d`      | Uninstall package     |
| FzfLua picker | `<C-d>`  | Preview page down     |
| FzfLua picker | `<C-u>`  | Preview page up       |
| FzfLua (fzf)  | `ctrl-d` | Preview page down     |
| FzfLua (fzf)  | `ctrl-u` | Preview page up       |

## 🧠 LSP servers and filetypes

Server overrides live in `after/lsp/**`:

- `lua_ls` for Lua
- `roslyn` for C#
- `shaderls` for ShaderLab/GLSL (plus `ftdetect/shaderlab.lua`)

Install servers through `:Mason`, then tweak settings in `after/lsp/<server>.lua` if needed.

## 🧹 Formatting & linting

Formatting uses Conform on save with LSP fallback (`lua/pea/plugins/formatters.lua`).

Configured formatters: `stylua`, `csharpier`, `prettier`, `clang-format`, `taplo`, `shfmt`.

Linting uses `nvim-lint` on save/read/insert leave (`lua/pea/plugins/lints.lua`).

Configured linters: `selene` (Lua) and `shellcheck` (shell).

## 🔄 Updating

- Update plugins: `:Lazy sync`
- Update Mason tools: `:MasonUpdate`
- Update Treesitter parsers (optional): `:TSUpdate`

## 🪟 Windows notes

On Windows, the shell is configured to use `pwsh` with UTF‑8 pipe/redirection settings (`lua/pea/options.lua`).
