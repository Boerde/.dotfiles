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
Plug 'kien/ctrlp.vim'
Plug 'scrooloose/syntastic'
Plug 'altercation/vim-colors-solarized'
Plug 'zchee/deoplete-jedi'
Plug 'Shougo/neoinclude.vim'
Plug 'Shougo/neco-vim'
Plug 'Shougo/neco-syntax'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
call plug#end()

" deoplete on startup
let g:deoplete#enable_at_startup = 1
let g:deoplete#tag#cache_limit_size = 500000000
let g:deoplete#auto_complete_delay = 50

" disable mouse
set mouse =

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
        " get git root directory
        :let l:git_root = system('git rev-parse --show-toplevel')
        " build tags from root of directory instead of current dir
        :execute "AsyncRun ctags -R --languages=Python --sort=yes " . l:git_root
    endif
endfun

"""" AUTOCMD
" create tags
autocmd VimEnter,BufWritePost *.[c|py] :call CreateCtagsFile(&ft)

""""" HOTKEYS

let mapleader = "\<Space>"

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
nnoremap <F2> :AsyncRun ag -G "\.c" --ignore unitTests <cword><CR>:copen<CR>
" (?!t) exclude for example html
nnoremap <F3> :AsyncRun ag -G "\.h(?!t)" --ignore unitTests <cword><CR>:copen<CR>
nnoremap <F4> :AsyncRun ag -G "\.c" --ignore unitTests "<C-R>*"<CR>:copen<CR>

""make
nnoremap <leader>m :AsyncRun make all<CR>:copen<CR>
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

""""" Functions
func! Test(timer)
    :AsyncRun ctags -R
endfunc

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
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf
set foldlevelstart=99 "no folds at opem

let g:airline_theme='solarized'

" Syntasthic Default Settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_enable_signs = 1
let g:syntastic_mode_map = { 'mode': 'active', 'active_filetypes': [],'passive_filetypes': ['c'] }
let g:syntastic_loc_list_height = 5
let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0
let g:syntastic_c_no_include_search = 1
let g:syntastic_c_checkers=['splint']
let g:syntastic_c_config_file = 'splint.cfg'

" ignore errors in shell
let g:syntastic_sh_shellcheck_args = "-e SC2086"

syntax on
filetype plugin indent on
filetype plugin on
set background=dark
colorscheme solarized
set spell spelllang=en_us
set hlsearch

let g:ctags_statusline=0

"""""" PCTRL
let g:ctrlp_extensions = ['tag'] "enable search through tags
