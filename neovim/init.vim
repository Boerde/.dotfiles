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
Plug 'hrsh7th/nvim-compe'
Plug 'hrsh7th/vscode-langservers-extracted'
Plug 'ludovicchabant/vim-gutentags'
Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'moll/vim-bbye'
Plug 'nathanalderson/yang.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'paul-nechifor/vim-svn-blame'
Plug 'skywind3000/asyncrun.vim'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/taglist.vim'
Plug 'wannesm/wmgraphviz.vim'
Plug 'wellle/tmux-complete.vim'
Plug 'github/copilot.vim', { 'branch': 'release' }
Plug 'CopilotC-Nvim/CopilotChat.nvim', { 'branch': 'main' }
" PlantUml Plugins
Plug 'aklt/plantuml-syntax'
Plug 'tyru/open-browser.vim'
Plug 'weirongxu/plantuml-previewer.vim'
" Telescope plugins
Plug 'nvim-telescope/telescope.nvim', { 'rev': '0.1.x' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', {'branch': 'main', 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
Plug 'nvim-lua/plenary.nvim'
" jenkins
Plug 'ckipp01/nvim-jenkinsfile-linter', { 'branch': 'main' }
if has('win32')
	Plug 'JulioJu/neovim-qt-colors-solarized-truecolor-only'
else
	Plug 'altercation/vim-colors-solarized'
endif
call plug#end()

"disable jedi completion as this is done by deoplete
let g:jedi#completions_enabled = 0

lua << EOF
local nvim_lsp = require('lspconfig')

nvim_lsp.clangd.setup{}
-- https://github.com/redhat-developer/yaml-language-server
nvim_lsp.yamlls.setup{}
-- https://github.com/regen100/cmake-language-server
nvim_lsp.cmake.setup{}
-- https://github.com/redhat-developer/vscode-xml
nvim_lsp.lemminx.setup{}
-- https://github.com/hrsh7th/vscode-langservers-extracted
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
nvim_lsp.html.setup {
    capabilities = capabilities,
}
-- https://github.com/pappasam/jedi-language-server
nvim_lsp.jedi_language_server.setup{}
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#qmlls
nvim_lsp.qmlls.setup{
    cmd = { "/usr/lib/qt6/bin/qmlls" }
}

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

let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.resolve_timeout = 800
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true

let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.calc = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true
let g:compe.source.vsnip = v:true
let g:compe.source.ultisnips = v:true
let g:compe.source.luasnip = v:true
let g:compe.source.emoji = v:true


" https://github.com/nvim-telescope/telescope.nvim
lua << EOF
require('telescope').load_extension('fzf')
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<C-b>', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
EOF

" https://copilotc-nvim.github.io/CopilotChat.nvim/

lua << EOF
local copilot_chat = require("CopilotChat")
copilot_chat.setup({
  debug = true,
  show_help = "yes",
  prompts = {
    Explain = "Explain how it works.",
    Review = "Review the following code and provide concise suggestions.",
    Tests = "Briefly explain how the selected code works, then generate unit tests.",
    Refactor = "Refactor the code to improve clarity and readability.",
  },
  build = function()
    vim.notify("Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.")
  end,
  event = "VeryLazy",
})

EOF

nnoremap <leader>ccb <cmd>CopilotChatBuffer<cr>
nnoremap <leader>cce <cmd>CopilotChatExplain<cr>
nnoremap <leader>cct <cmd>CopilotChatTests<cr>
xnoremap <leader>ccv :CopilotChatVisual<cr>
xnoremap <leader>ccx :CopilotChatInPlace<cr>

" nvim-jenkinsfile-linter
autocmd VimEnter,BufWritePost *.[jenkins|Jenkinsfile] :lua require("jenkinsfile_linter").validate()

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
    let g:python3_host_prog = '/home/lsoest/venv_python310/bin/python'
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
let g:ale_cpp_clangcheck_executable = 'clang-check-16'
let g:ale_cpp_clangtidy_executable = 'clang-tidy-16'
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
EOF
let l:snake_var = py3eval("snake")
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
if has('win32')
	let $NVIM_TUI_ENABLE_TRUE_COLOR=1
	colorscheme solarized_nvimqt
elseif IsWsl()
	let g:solarized_termcolors = 16
	colorscheme solarized
else
	let g:solarized_termcolors = 256
	colorscheme solarized
endif

set background=dark
set spell spelllang=en_us
set hlsearch

let g:ctags_statusline=0
