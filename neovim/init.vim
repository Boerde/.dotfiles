call plug#begin('~/.local/share/nvim/plugged')
Plug 'nathanalderson/yang.vim'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-airline/vim-airline'
Plug 'dietsche/vim-lastplace'
Plug 'skywind3000/asyncrun.vim'
Plug 'bogado/file-line'
Plug 'Boerde/vim-addon-linux-coding-style'
Plug 'vim-scripts/taglist.vim'
Plug 'moll/vim-bbye'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'w0rp/ale'
if has('win32')
	Plug 'JulioJu/neovim-qt-colors-solarized-truecolor-only'
else
	Plug 'altercation/vim-colors-solarized'
endif
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'davidhalter/jedi-vim'
Plug 'fishbullet/deoplete-ruby'
Plug 'Matt-Deacalion/vim-systemd-syntax'
Plug 'wannesm/wmgraphviz.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'wellle/tmux-complete.vim'
Plug 'Shougo/deoplete-clangx'
Plug 'Shougo/neoinclude.vim'
Plug 'Shougo/neco-vim'
Plug 'Shougo/neco-syntax'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
call plug#end()

"disable jedi completion as this is done by deoplete
let g:jedi#completions_enabled = 0

"ignore unknown chars in terminal
set guicursor=

"case
set ignorecase
set smartcase

"AsyncRun
let g:asyncrun_stdin = 1

"grep
if executable("rg")
    set grepprg=rg\ --vimgrep\ --no-heading
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
endif

" gutentags
let g:gutentags_project_root = ['USM_ROOT', 'pytest.ini', 'conftest.py']

" disable mouse
set mouse =

" AleFix
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'cmake': ['cmakeformat'],
\   'python': ['remove_trailing_lines', 'trim_whitespace', 'autopep8', 'reorder-python-imports'],
\   'xml': ['remove_trailing_lines', 'trim_whitespace', 'xmllint'],
\   'cpp': ['remove_trailing_lines', 'trim_whitespace', 'clang-format', 'clangtidy'],
\}

" ale linters
let g:ale_linters = {
\   'python': ['flake8', 'pylint', 'mypy'],
\   'cpp': ['cc', 'ccls', 'clangcheck', 'clangd', 'clangtidy', 'clazy', 'cppcheck', 'cpplint', 'cquery', 'flawfinder']
\}

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
set list
set listchars=tab:\ \ ,nbsp:_,trail:.

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

"""""" PCTRL
let g:ctrlp_extensions = ['tag'] "enable search through tags
let g:ctrlp_working_path_mode = '' "disable search through whole svn/git directory
