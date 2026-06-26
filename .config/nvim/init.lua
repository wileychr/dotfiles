vim.pack.add({
  {
    src = "https://github.com/polirritmico/monokai-nightasty.nvim",
    version = "1e9b92006782a1217d0a7a871b871768f1cbf5ed"
  },
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = 'main'
  },
  {
    src = "https://github.com/neovim/nvim-lspconfig",
    -- latest 2026-05-07
    version = "cd576dd72d31ddffcbfa6d064c0dd697ca218758"
  },
  {
    -- The completion engine itself is called nvim-cmp
    src = "https://github.com/hrsh7th/nvim-cmp",
    -- latest 2026-05-07
    version = "a1d504892f2bc56c2e79b65c6faded2fd21f3eca"
  },
  {
    src = "https://github.com/ellisonleao/gruvbox.nvim",
    -- latest 2026-06-18
    version = "154eb5ff5b96d0641307113fa385eaf0d36d9796"
  },
  {
    src = "https://github.com/ibhagwan/fzf-lua",
    -- latest 2026-06-18
    version = "267f5db2aa2202b9f6cc7a50783f0ccd2121766c"
  },
  {
    src = "https://github.com/hrsh7th/cmp-nvim-lsp-signature-help",
    -- latest 2026-05-07
    version = "fd3e882e56956675c620898bf1ffcf4fcbe7ec84"
  }
})

-- Set our leader key first so that plugins will have a consistent view
vim.g.mapleader=","


vim.cmd([[
nnoremap <Leader>t :FzfLua files<CR>
nnoremap <Leader>f :FzfLua grep_project<CR>
]])

vim.cmd([[
" Default tab settings
set tabstop=2
set softtabstop=2
set shiftwidth=2
set backspace=2
set expandtab
set textwidth=100

" I read somewhere that recent versions of vim don't perform filetype
" detection automatically on startup.
filetype on
filetype plugin on
filetype indent on
syntax on
" colorscheme monokai-nightasty

au BufNewFile,BufRead Dockerfile.*      set filetype=dockerfile
au BufNewFile,BufRead Makefile.*        set filetype=make
au BufNewFile,BufRead *.flex,*.jflex    set filetype=jflex
au BufNewFile,BufRead *.cc.fsm          set filetype=cpp
au BufNewFile,BufRead *.cup             set filetype=cup
au BufNewFile,BufRead *.py              set filetype=python
au BufNewFile,BufRead *.aidl            set filetype=java
au BufNewFile,BufRead *.eclass,*.ebuild set filetype=sh

" Language specific overrides
autocmd FileType sh setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
autocmd FileType make setlocal tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab
autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab textwidth=100 foldmethod=indent
autocmd FileType markdown setlocal tabstop=4 softtabstop=4 shiftwidth=4 textwidth=100
autocmd FileType javascript setlocal tabstop=4 softtabstop=4 shiftwidth=4
"autocmd FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2

autocmd BufNewFile,BufRead *.go setlocal tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab textwidth=100

" Don't bother showing the vertical split separator.
highlight VertSplit ctermfg=BLACK
highlight VertSplit ctermbg=BLACK
]])

vim.cmd([[

set number                    " show/hide line numbers (nu/nonu)
set scrolloff=5               " scroll offsett, min lines above/below cursor
set scrolljump=5              " jump 5 lines when running out of the screen
set sidescroll=10             " minumum columns to scroll horizontally
set showcmd                   " show command status
set showmatch                 " flashes matching paren when one is typed
set showmode                  " show editing mode in status (-- INSERT --)
set ruler                     " show cursor position

" Some search stuff
set ignorecase
set smartcase
set incsearch                 " incremental search
set hlsearch                  " highlighting when searching

" Make tab completion of file paths more bashlike
" Setting `wildmode=full` switches from bash style tab complete to a pop-up
"   menu.  However, it seems less functional.
"set wildmode=full
set wildmode=longest,list
set wildmenu
set pumblend=15

set noerrorbells              " no bells in terminal
set novisualbell
set undolevels=1000           " number of undos stored
set whichwrap=<,>,h,l,[,]
set nofen
]])

vim.g.markdown_enable_spell_checking = false

--[[
Spell checking. Enabled only for prose-y filetypes so it doesn't flag code.
Custom/accepted words are saved to spellfile when you add them with `zg`.
Using it — misspelled words get underlined/highlighted. Cursor on a flagged word:
  - ]s / [s — jump to next / previous misspelling
  - z= — show suggestions (pick a number to replace)
  - zg — add the word to your dictionary as good (saved to the spellfile)
  - zw — mark a word as wrong
  - zug — undo a zg
]]--

vim.opt.spelllang = "en_us"
vim.opt.spellfile = os.getenv("HOME") .. "/.config/nvim/spell/en.utf-8.add"
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text", "gitcommit", "tex", "rst" },
  callback = function()
    vim.opt_local.spell = true
  end,
})

vim.lsp.enable("gopls")

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),

  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

    --[[
    if client:supports_method('textDocument/implementation') then
      -- Create a keymap for vim.lsp.buf.implementation ...
    end


    -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
    if client:supports_method('textDocument/completion') then
      -- Optional: trigger autocompletion on EVERY keypress. May be slow!
      -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
      -- client.server_capabilities.completionProvider.triggerCharacters = chars

      vim.lsp.completion.enable(true, client.id, ev.buf, {autotrigger = true})
    end

    -- Auto-format ("lint") on save.
    -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp', {clear=false}),
        buffer = ev.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end
    ]]--

    local keymap_opts = { noremap=true, silent=true }

    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(ev.buf, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    vim.api.nvim_buf_set_keymap(ev.buf, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', keymap_opts)
    vim.api.nvim_buf_set_keymap(ev.buf, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', keymap_opts)
    vim.api.nvim_buf_set_keymap(ev.buf, 'n', '<leader>c', '<cmd>lua vim.lsp.buf.hover()<CR>', {
      desc = "display hover information",
      unpack(keymap_opts)
    })
    vim.api.nvim_buf_set_keymap(ev.buf, 'n', '<space>f', '<cmd>lua vim.lsp.buf.format({async=true})<CR>', {
      desc = "format buffer",
      unpack(keymap_opts)
    })
    vim.api.nvim_buf_set_keymap(ev.buf, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', keymap_opts)

    -- vim.api.nvim_buf_set_keymap(ev.buf, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', keymap_opts)
    vim.api.nvim_buf_set_keymap(ev.buf, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', keymap_opts)
    vim.api.nvim_buf_set_keymap(ev.buf, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', keymap_opts)
    vim.api.nvim_buf_set_keymap(ev.buf, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', keymap_opts)
    vim.api.nvim_buf_set_keymap(ev.buf, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', keymap_opts)
    vim.api.nvim_buf_set_keymap(ev.buf, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', {
      desc = "go to type definition",
      unpack(keymap_opts)
    })
    vim.api.nvim_buf_set_keymap(ev.buf, 'n', '<F6>', '<cmd>lua vim.lsp.buf.rename()<CR>', keymap_opts)
    vim.api.nvim_buf_set_keymap(ev.buf, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', keymap_opts)

    vim.opt.tagfunc = "v:lua.vim.lsp.tagfunc"
  end,
})

cwd = os.getenv("PWD") or io.popen("cd"):read()
function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end
GOPACKAGESDRIVER_PATH = cwd .. "/dev/go_packages_driver.bash"
if (file_exists(GOPACKAGESDRIVER_PATH))
then
vim.lsp.config('gopls', {
  -- cmd = {'gopls', '-rpc.trace', '--debug=localhost:6060'},
  settings = {
    gopls = {
      env = {
        GOPACKAGESDRIVER = GOPACKAGESDRIVER_PATH,
        -- Work around some bug with symlinks + bazel in 1.18
        --   https://github.com/bazelbuild/rules_go/issues/3110
        GOPACKAGESDRIVER_BAZEL_BUILD_FLAGS = '--strategy=GoStdlibList=local',
      },
      directoryFilters = {
        "-bazel-bin",
        "-bazel-out",
        "-bazel-testlogs",
        "-bazel-applied2",
        "-simian/client/frontend",
        "-data",
      },
    },
  },
})
else
vim.lsp.config('gopls', {
})
end


function all_trim(s)
  return s:match"^%s*(.*)":match"(.-)%s*$"
end

-- We will run the python language server inside a virtual env.
-- To boostrap this environment on Ubuntu 24.04
--   sudo apt install python3.12-venv
--   ~/.wileyfiles/vim_py_env/bin/python3 -m pip install python-lsp-server[all] python-lsp-ruff pylsp-mypy
HOMEDIR_PYTHON3_EXEC = os.getenv("HOME") .. '/.wileyfiles/vim_py_env/bin/python3'
function get_venv_python3()
  if vim.fn.getcwd() == os.getenv("HOME") then
    -- Running find in the homedir can cause permissions issues on OSX.
    return HOMEDIR_PYTHON3_EXEC
  end
  local handle = io.popen('find . -name python3 -maxdepth 3')
  local result = all_trim(handle:read("*a"))
  handle:close()
  if result == "" then
    return os.getenv("HOME") .. '/.wileyfiles/vim_py_env/bin/python3'
  end
  return result
end

PYTHON3_EXEC = get_venv_python3()


vim.lsp.config('pylsp', {
  on_attach = on_attach,
  cmd = {PYTHON3_EXEC, '-m', 'pylsp'},
  -- See https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
  settings = {
    pylsp = {
      plugins = {
        jedi_completion = { fuzzy = true },
        -- python3 -m pip install python-lsp-ruff
        -- python3 -m pip install pylsp-mypy
        pylsp_mypy = { enabled = true },

        -- pylsp will try and enable these by default
        pylint = { enabled = false },
        pyflakes = { enabled = false },
        pycodestyle = { enabled = false },

        ruff = { enabled = true },
        pyls_isort = { enabled = true },
        -- We want to use ruff for formatting. Unfortunately, pylsp requires us to disable all other alternatives.
        autopep8 = { enabled = false },
        yapf = { enabled = false },
        black = { enabled = false },
      },
    },
  },
})

TS_LANGUAGES = {
  "c",
  "cpp",
  "go",
  "json",
  "kotlin",
  "lua",
  "markdown",
  "python",
  "query",
  "sql",
  "terraform",
  "vim",
  "vimdoc",
}
require('nvim-treesitter').install(TS_LANGUAGES)

vim.api.nvim_create_autocmd('FileType', {
  pattern = TS_LANGUAGES,
  callback = function()
    -- syntax highlighting, provided by Neovim
    vim.treesitter.start()
    -- folds, provided by Neovim
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo.foldmethod = 'expr'
    -- indentation, provided by nvim-treesitter
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

local cmp = require("cmp")
cmp.setup({
  -- Example mappings: https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings
  mapping = {
    ["<CR>"] = cmp.mapping({
       i = function(fallback)
         if cmp.visible() and cmp.get_active_entry() then
           cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
         else
           fallback()
         end
       end,
       s = cmp.mapping.confirm({ select = true }),
       c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
    }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      --elseif has_words_before() then
      --  cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),
    --[[
    ["<tab>"] = cmp.mapping(function(fallback)
      if not cmp.visible() then
        return fallback()
      end

      local entry = cmp.get_selected_entry()
      if not entry then
        return fallback()
      end
      cmp.confirm()
    end, {"i","s"}),
    -- Use the arrow keys to move up and down between autocomplete options.
    -- This is a little janky unless you have up/down bound to the home row somewhere.
    ["<down>"] = cmp.mapping(function(fallback)
      if not cmp.visible() then
        return fallback()
      end
      cmp.select_next_item()
    end, {"i","s"}),
    ["<up>"] = cmp.mapping(function(fallback)
      if not cmp.visible() then
        return fallback()
      end
      cmp.select_prev_item()
    end, {"i","s"}),
    --]]
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' }
  }
})

require("gruvbox").setup({
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "hard", -- can be "hard", "soft" or empty string
})
vim.cmd.colorscheme("gruvbox")

