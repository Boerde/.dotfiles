call plug#begin('~/.local/share/nvim/plugged')
Plug 'Boerde/vim-addon-linux-coding-style'
Plug 'Matt-Deacalion/vim-systemd-syntax'
Plug 'Shougo/deoplete-clangx'
Plug 'Shougo/neco-syntax'
Plug 'Shougo/neco-vim'
Plug 'Shougo/neoinclude.vim'
Plug 'bogado/file-line'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'davidhalter/jedi-vim'
Plug 'dense-analysis/ale'
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'dietsche/vim-lastplace'
Plug 'fishbullet/deoplete-ruby'
Plug 'hrsh7th/nvim-compe'
Plug 'ludovicchabant/vim-gutentags'
Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'moll/vim-bbye'
Plug 'nathanalderson/yang.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'skywind3000/asyncrun.vim'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/taglist.vim'
Plug 'wannesm/wmgraphviz.vim'
Plug 'wellle/tmux-complete.vim'
if has('win32')
	Plug 'JulioJu/neovim-qt-colors-solarized-truecolor-only'
else
	Plug 'altercation/vim-colors-solarized'
endif
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
call plug#end()

"disable jedi completion as this is done by deoplete
let g:jedi#completions_enabled = 0

autocmd FileType c,cpp,h,hpp
	\ call deoplete#custom#buffer_option('auto_complete', v:false) |
	\ let g:ctrlp_user_command = 'rg %s --files --color=never --glob "*.cpp" --glob "*.h"'

lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  -- buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'clangd' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
-- https://github.com/redhat-developer/yaml-language-server
nvim_lsp.yamlls.setup{}
-- https://github.com/regen100/cmake-language-server
nvim_lsp.cmake.setup{}
-- https://github.com/redhat-developer/vscode-xml
nvim_lsp.lemminx.setup{}
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

"ignore unknown chars in terminal
set guicursor=

"case
set ignorecase
set smartcase

set wildignore+=*.exp,*.inf,tags,*.pyc,*.o,*.a,*.ninja,*.png,GeneratedProjects/**

" AsyncRun
let g:asyncrun_stdin = 1

" grep
if executable("rg")
    set grepprg=rg\ --vimgrep\ --no-heading\ -S\ -g\ !tags
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" deoplete on startup
let g:deoplete#enable_at_startup = 1
let g:deoplete#tag#cache_limit_size = 50000000

call deoplete#custom#option('sources', {
            \'c': ['buffer', 'tag', 'file'],
            \'h': ['buffer', 'tag', 'file'],
        \})
let g:deoplete#sources#jedi#enable_short_types = 1
let g:deoplete#sources#jedi#show_docstring = 1
call deoplete#custom#option('auto_complete_delay', 5)

call deoplete#custom#var('buffer', 'require_same_filetype', v:false)

if has('win32')
	let g:python_host_prog = 'C:\Python27\python.exe'
	let g:python3_host_prog = 'C:\Python38\python.exe'
else
    let g:python3_host_prog = '/home/lsoest/venv_python310/bin/python'
endif

" gutentags
let g:gutentags_project_root = ['USM_ROOT', 'pytest.ini', '_clang-format']

"ctrlp
let g:ctrlp_root_markers = ['USM_ROOT', 'pytest.ini', '_clang-format', 'compile_commands.json']
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_extensions = ['tag'] "enable search through tags
let g:ctrlp_working_path_mode = 'r' "disable search through whole svn/git directory


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
\}

" ale linters
let g:ale_linters = {
\   'python': ['flake8', 'pylint', 'mypy'],
\   'cpp': ['clangcheck', 'clangtidy', 'clazy', 'cppcheck', 'cpplint', 'cquery', 'flawfinder']
\}

let g:ale_cpp_cc_options = '-stdlib=libc++'
let g:ale_cpp_clangcheck_executable = 'clang-check-14'
let g:ale_dockerfile_hadolint_use_docker = 'always'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_text_changed = "never"
let g:ale_lint_on_save = 1


" Taglist open on start
let g:Tlist_Auto_Open = 1
" Close Taglist when it is the last window
let g:Tlist_Exit_OnlyWindow = 1

" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" Delete whitespaces trailing
function! TrimWhiteSpace()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

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

"" format in c
nnoremap <leader>f :%!astyle --style=k\&r --brackets=linux --indent-preprocessor --break-blocks --pad-oper --pad-header --unpad-paren --align-pointer=name --convert-tabs<CR>

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

""convert to snake_case with jedi-vim
nnoremap <leader>w :call SnakeCase()

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

