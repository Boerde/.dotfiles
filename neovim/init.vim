call plug#begin('~/.local/share/nvim/plugged')
Plug 'Boerde/vim-addon-linux-coding-style'
Plug 'Matt-Deacalion/vim-systemd-syntax'
Plug 'Shougo/neco-syntax'
Plug 'Shougo/neco-vim'
Plug 'Shougo/neoinclude.vim'
Plug 'bogado/file-line'
Plug 'davidhalter/jedi-vim'
Plug 'dcampos/nvim-snippy'
Plug 'dense-analysis/ale'
Plug 'dietsche/vim-lastplace'
Plug 'hrsh7th/vscode-langservers-extracted'
Plug 'ludovicchabant/vim-gutentags'
Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'moll/vim-bbye'
Plug 'nathanalderson/yang.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'lsoest/vim-svn-blame'
Plug 'skywind3000/asyncrun.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/taglist.vim'
Plug 'wannesm/wmgraphviz.vim'
Plug 'wellle/tmux-complete.vim'
" https://github.com/CopilotC-Nvim/CopilotChat.nvim
Plug 'github/copilot.vim', { 'branch': 'release' }
Plug 'CopilotC-Nvim/CopilotChat.nvim', { 'branch': 'main' }
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
" PlantUml Plugins
Plug 'aklt/plantuml-syntax'
Plug 'tyru/open-browser.vim'
Plug 'weirongxu/plantuml-previewer.vim'
" Telescope plugins
Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', {'branch': 'main', 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug 'nvim-lua/plenary.nvim'
" jenkins
Plug 'ckipp01/nvim-jenkinsfile-linter', { 'branch': 'main' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'maxmx03/solarized.nvim'
" markdown
Plug 'echasnovski/mini.nvim'
Plug 'MeanderingProgrammer/render-markdown.nvim'
"markdown in browser
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
call plug#end()

"disable jedi completion as this is done by deoplete
let g:jedi#completions_enabled = 0

lua << EOF
-- Use vim.lsp.enable() for Neovim 0.11+
vim.lsp.enable('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      diagnostics = {
        enable = false;
      }
    }
  }
})

vim.lsp.enable('clangd')
-- https://github.com/redhat-developer/yaml-language-server
vim.lsp.enable('yamlls')
-- https://github.com/regen100/cmake-language-server
vim.lsp.enable('cmake')
-- https://github.com/redhat-developer/vscode-xml
vim.lsp.enable('lemminx')
-- https://github.com/hrsh7th/vscode-langservers-extracted
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
vim.lsp.enable('html', {
    capabilities = capabilities,
})
-- https://github.com/pappasam/jedi-language-server
vim.lsp.enable('jedi_language_server')
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#qmlls
vim.lsp.enable('qmlls', {
    cmd = { "/usr/lib/qt6/bin/qmlls" },
    root_dir = function(fname)
        return vim.fs.root(fname, {".qmlproject", ".qmlls.ini", ".git"})
    end,
})

vim.lsp.enable('ruff')

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

EOF

" https://github.com/MeanderingProgrammer/render-markdown.nvim
lua << EOF
require('render-markdown').setup({})
EOF

" https://github.com/hrsh7th/nvim-cmp
" https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#super-tab-like-mapping
lua <<EOF

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
      end,
    },
    window = {
      -- completion = cmp.config.windom.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function()
        if cmp.visible() then
          cmp.select_prev_item()
        elseif vim.fn['vsnip#jumpable'](-1) == 1 then
          feedkey('<Plug>(vsnip-jump-prev)', '')
        end
      end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
      { name = 'render-markdown' },
      { name = 'path' },

    })
  })

  -- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
  -- Set configuration for specific filetype.
  --[[ cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' },
    }, {
      { name = 'buffer' },
    })
 })
 require("cmp_git").setup() ]]-- 

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
EOF


" https://github.com/nvim-telescope/telescope.nvim
lua << EOF
require('telescope').load_extension('fzf')
require('telescope').load_extension('ui-select')
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<C-b>', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- do a live_grep for the cword under cursor with F2
vim.keymap.set("n", "<F2>", function()
  builtin.live_grep({ default_text = vim.fn.expand("<cword>") })
end, { desc = "Telescope live grep for cword" })

-- use compile_commands.json to find files if it exists
vim.keymap.set("n", "<leader>cc", function()
  if vim.loop.fs_stat("compile_commands.json") then
    builtin.find_files({
      prompt_title = "compile_commands.json files",
      find_command = { "sh", "-c", [[jq -r '.[].file' compile_commands.json | sort -u]] },
    })
  else
    -- normal Telescope behavior (uses your configured defaults: fd/rg/etc)
    builtin.find_files({})
  end
end, { desc = "Telescope find files (fallback if no compile_commands.json)" })

EOF

" https://copilotc-nvim.github.io/CopilotChat.nvim/

lua << EOF
local copilot_chat = require("CopilotChat")
-- Registers copilot-chat source and enables it for copilot-chat filetype (so copilot chat window)
copilot_chat.setup({
  model = 'claude-sonnet-4',
  build = function()
    vim.notify("Please update remote plugins by running ':UpdateRemotePlugins', then restart Neovim.")
  end,
  event = "VeryLazy",
  mappings = {
    complete = {
      insert = '',
    },
  },
  keys = {
  -- Show help actions with telescope
  {
    "<leader>ah",
    function()
      require("CopilotChat.code_actions").show_help_actions()
    end,
    desc = "CopilotChat - Help actions",
  },
  -- Show prompts actions with telescope
  {
    "<leader>ap",
    function()
      require("CopilotChat.code_actions").show_prompt_actions()
    end,
    desc = "CopilotChat - Prompt actions",
  },
  {
    "<leader>ap",
    ":lua require('CopilotChat.code_actions').show_prompt_actions(true)<CR>",
    mode = "x",
    desc = "CopilotChat - Prompt actions",
  },
  -- Code related commands
  { "<space>ae", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
  { "<leader>at", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
  { "<leader>ar", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
  { "<leader>aR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
  { "<leader>an", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Naming" },
  -- Chat with Copilot in visual mode
  {
    "<leader>av",
    ":CopilotChatVisual",
    mode = "x",
    desc = "CopilotChat - Open in vertical split",
  },
  {
    "<leader>ax",
    ":CopilotChatInPlace<cr>",
    mode = "x",
    desc = "CopilotChat - Run in-place code",
  },
  -- Custom input for CopilotChat
  {
    "<leader>ai",
    function()
      local input = vim.fn.input("Ask Copilot: ")
      if input ~= "" then
        vim.cmd("CopilotChat " .. input)
      end
    end,
    desc = "CopilotChat - Ask input",
  },
  -- Quick chat with Copilot
  {
    "<space>aq",
    function()
      local input = vim.fn.input("Quick Chat: ")
      if input ~= "" then
        vim.cmd("CopilotChatBuffer " .. input)
      end
    end,
    desc = "CopilotChat - Quick chat",
  },
  }
})
EOF

" https://github.com/maxmx03/solarized.nvim
lua << EOF
vim.o.termguicolors = true
vim.o.background = "light"
require('solarized').setup({})
vim.cmd.colorscheme 'solarized'
EOF
autocmd ColorScheme * highlight SpellBad cterm=underline gui=underline


" https://github.com/hrsh7th/vscode-langservers-extracted
lua << EOF
vim.lsp.enable('jsonls')
EOF

" https://github.com/nvim-treesitter/nvim-treesitter
lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
}
EOF

" nvim-jenkinsfile-linter
autocmd VimEnter,BufWritePost *.[jenkins|Jenkinsfile] :lua require("jenkinsfile_linter").validate()

" cmake use 2 spaces
autocmd FileType cmake setlocal shiftwidth=2 tabstop=2 expandtab

" recognice qml files
autocmd BufRead,BufNewFile *.qml set filetype=qml

"ignore unknown chars in terminal
set guicursor=

"case
set ignorecase
set smartcase

set wildignore+=*.exp,*.inf,tags,*.pyc,*.o,*.a,*.ninja,*.png

" AsyncRun
let g:asyncrun_stdin = 1

" grep
if executable("rg")
    set grepprg=rg\ --vimgrep\ --no-heading\ -S\ -g\ !tags
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

if has('win32')
	let g:python_host_prog = 'C:\Python27\python.exe'
	let g:python3_host_prog = 'C:\Python38\python.exe'
else
    let g:python3_host_prog = '/home/lsoest/venv_python312/bin/python'
endif

" gutentags
let g:gutentags_project_root = ['USM_ROOT', 'pytest.ini', '_clang-format']


" disable mouse
set mouse =

" AleFix
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'cmake': ['cmakeformat'],
\   'python': ['remove_trailing_lines', 'trim_whitespace', 'autopep8', 'reorder-python-imports', 'autoimport'],
\   'xml': ['remove_trailing_lines', 'trim_whitespace', 'xmllint'],
\   'cpp': ['remove_trailing_lines', 'trim_whitespace', 'clang-format', 'clangtidy'],
\   'sh': ['remove_trailing_lines', 'trim_whitespace', 'shfmt'],
\   'json': ['jq'],
\}

" ale linters
let g:ale_linters = {
\   'python': ['flake8', 'pylint', 'mypy'],
\   'cpp': ['clangcheck', 'clangtidy', 'clazy', 'cppcheck', 'cpplint', 'cquery', 'flawfinder']
\}

let g:ale_cpp_cc_options = '-stdlib=libc++'
let g:ale_cpp_clangcheck_executable = 'clang-check'
let g:ale_cpp_clangtidy_executable = 'clang-tidy'
let g:ale_dockerfile_hadolint_use_docker = 'always'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_text_changed = "never"
let g:ale_lint_on_save = 1


" Taglist open on start
let g:Tlist_Auto_Open = 1
" Close Taglist when it is the last window
let g:Tlist_Exit_OnlyWindow = 1

" Delete whitespaces trailing
function! TrimWhiteSpace()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" ctags
function! CreateCtagsFile (file_ext)
    if a:file_ext == 'c'
        " check if there is a script to create the tags (e.g. in the kernel
        " source)
        if 1 == system('find . -path "*scripts/tags.sh" | wc -l')
            " :AsyncRun ./scripts/tags.sh tags
            :AsyncRun make tags
        else
            :AsyncRun find . -not \( -path ./ip/metaswitch -prune \) -not \( -path ./cas -prune \) -name "*\.[c|h]" -exec ctags --sort=yes {} +
        endif
    elseif a:file_ext == 'python'
            :AsyncRun ctags --sort=yes -R
    elseif a:file_ext == 'python'
        " get git root directory
        :let l:git_root = system('git rev-parse --show-toplevel')
        " build tags from root of directory instead of current dir
        :execute "AsyncRun ctags -R --languages=Python --sort=yes " . l:git_root
    endif
endfun

"""" AUTOCMD
" create tags
" autocmd VimEnter,BufWritePost *.[c|py] :call CreateCtagsFile(&ft)
" set tabs
autocmd FileType ruby set tabstop=2|set shiftwidth=2
au FileType xml imap </ </<c-x><c-o>

autocmd BufEnter Jenkins.* set ft=Jenkinsfile
autocmd filetype cpp call TrimWhiteSpace()

""""" HOTKEYS

let mapleader = "\<Space>"
let maplocalleader = "\<Space>"

" remap to switch windows in any mode with alt and "h/j/k/l"
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" remap to escape terminal
tnoremap <Esc> <C-\><C-n>

" search whole source code in directory
nnoremap <F2> :grep -t py -t c -t cpp -t cs <cword><CR>:copen<CR>
nnoremap <F3> :grep -t h <cword><CR>:copen<CR>
"nnoremap <F2> :grep -tpy <cword><CR>:copen<CR>
"nnoremap <F3> :AsyncRun rg -t h <cword><CR>:copen<CR>
nnoremap <F4> :grep "<C-R>*"<CR>:copen<CR>

" rename in directory all files
nnoremap <leader>h :! ./convert.sh <cword><CR>

"" format in c
"nnoremap <leader>f :%!astyle --style=k\&r --brackets=linux --indent-preprocessor --break-blocks --pad-oper --pad-header --unpad-paren --align-pointer=name --convert-tabs<CR>

""make
nnoremap <leader>m :AsyncRun make all<CR>:copen<CR>

""copy all to clipboard
nnoremap <leader>c :%y+<CR>

function! ToSnake(Word)
python3 << EOF
import vim
from convert_case import snake_case
snake = snake_case(str(vim.eval('a:Word')))
vim.command("let l:snake_var = '%s'" % snake.replace("'", "''"))
EOF
return l:snake_var
endfunction

" snakess
function! SnakeCase()
    let l:out=system("pylint  -f parseable " . @% . "| grep snake_case | grep -v Module | sed 's/.* name \\\"\\(.*\\)\\\".*/\\1/g'")
    for l:item in split(l:out)
        " let l:command_y="printf " . l:item . " | sed -r 's/([a-z0-9])([A-Z])/\\1_\\L\\2/g'"
        " let l:snake_var=system(command_y)
        let l:snake_var = ToSnake(l:item)
        echo l:item
        :execute '%s/' . l:item . '/' . l:snake_var . '/gc'
    endfor
    "let l:var_name=expand("<cword>")
    "let l:command_y="printf " . var_name . " | sed -r 's/([a-z0-9])([A-Z])/\\1_\\L\\2/g'"
    "let l:snake_var=system(command_y)
    ":call jedi#rename()<CR>
    ":call feedkeys(snake_var)
    ":execute snake_var
    ":put =snake_var    
endfunction

" snakess with sed
function! SnakeCaseSed()
    let l:var_name = expand("<cword>")
    let l:snake_var = ToSnake(l:var_name)
    let l:command_y="find . -name '*.py' -exec sed -i 's/" . l:var_name . "/" . l:snake_var . "/g' {} +;"
    call system(l:command_y)
endfunction

""convert to snake_case with jedi-vim
nnoremap <leader>w :call SnakeCase()
nnoremap <leader>W :call SnakeCaseSed()

" open make errors from subdirs
set path+=$PWD/**

" jump to tag
nnoremap <leader>t <C-]>
nnoremap <leader>z <C-t>

" exit insert mode
inoremap jj <ESC>

"Buffers
set hidden
:nnoremap <C-k> :bnext<CR>
:nnoremap <C-j> :bprevious<CR>
tnoremap <C-k> <C-\><C-n>:bnext<CR>
tnoremap <C-j> <C-\><C-n>:bprevious<CR>

"quickfix list
:nnoremap <leader>j :cp<CR>
:nnoremap <leader>k :cn<CR>

""""" TAGS
set tags=tags

""""" Tabs
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
set list
set listchars=tab:>~,nbsp:_,trail:.

set number

""""" UNDO
set history=200           " remember x changes
set undofile              " save changes in undo files
set undolevels=1024       " remember x changes
set undoreload=65538      " reload up to x changes from files
set undodir=~/.vim/undo/  " undo directory

""""" FOLDING
set foldmethod=indent
"folding with space
"nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
"vnoremap <Space> zf
set foldlevelstart=99 "no folds at opem

let g:airline_theme='solarized'

function! IsWsl()
  if has("unix")
    let lines = readfile("/proc/version")
    if lines[0] =~ "Microsoft"
      return 1
    endif
  endif
  return 0
endfunction

syntax on
filetype plugin indent on
filetype plugin on

set background=dark
set spell spelllang=en_us
set hlsearch

let g:ctags_statusline=0
