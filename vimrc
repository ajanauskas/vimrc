call plug#begin('~/.vim/plugged')

Plug 'flowtype/vim-flow', { 'commit': '4acd33aceb3c49c6872ee4f3f717802d4c73efbf' }
Plug 'ctrlpvim/ctrlp.vim', { 'commit': 'bde7a2950adaa82e894d7bdf69e3e7383e40d229' }
Plug 'tomasr/molokai'
Plug 'scrooloose/nerdtree', { 'commit': '35953042fbf5535a7e905b52a6973c3f7f8a5536' }
Plug 'Valloric/YouCompleteMe'
Plug 'mileszs/ack.vim', { 'commit': '36e40f9ec91bdbf6f1adf408522a73a6925c3042' }

" Initialize plugin system
call plug#end()

"Flow config

"Enable omnifunc
filetype plugin on
set omnifunc=syntaxcomplete#Complete

"Use locally installed flow
let local_flow = finddir('node_modules', '.;') . '/.bin/flow'
if matchstr(local_flow, "^\/\\w") == ''
    let local_flow= getcwd() . "/" . local_flow
endif
if executable(local_flow)
  let g:flow#flowpath = local_flow
endif

let g:flow#autoclose = 1

"End of flow config

set nocompatible               "use Vim settings, rather than Vi

filetype off

" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
" Only works all the time.

silent !mkdir ~/.vim/backups > /dev/null 2>&1
set undodir=~/.vim/backups
set undofile

set backspace=indent,eol,start "allow backspacing over everything in insert mode
set number                     " Set line numbers

"indent settings
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent

"line length highlighting
set colorcolumn=100
" syntax highlighting limited to 120 lines
set synmaxcol=120

set ttyfast            "smoother changes
set incsearch          "incremental search on
set hls                "highlight search

let mapleader = ","            "map <Leader> from \ to ,
let maplocalleader = "/"       "map <LocalLeader> to \

" silver search + ack
"
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" easy-align condfigs

vnoremap <silent> <Enter> :EasyAlign<Enter>

syntax on    " Highlight syntax

map <Leader><Leader> <C-^>
map <C-n> :NERDTreeToggle<CR>
nmap <C-v> :set paste<CR>:r !pbpaste<CR>:set nopaste<CR>
imap <C-v> <Esc>:set paste<CR>:r !pbpaste<CR>:set nopaste<CR>
nmap <C-c> :.w !pbcopy<CR><CR>
vmap <C-c> :w !pbcopy<CR><CR>

"map up/down arrow keys to unimpaired commands
nmap <Up> [e
nmap <Down> ]e
vmap <Up> [egv
vmap <Down> ]egv

"map left/right arrow keys to indendation
nmap <Left> <<
nmap <Right> >>
vmap <Left> <gv
vmap <Right> >gv

let &t_Co=256
colorscheme molokai

" ctrlp configuration
let g:ctrlp_custom_ignore = 'node_modules\|\.git$\|\.hg$\|\.svn$\|\.swp$\|\.min\.js$|\.png$|\.jpg$|\.log$\|tmp$\|bin$'
let g:ctrlp_max_height = 15

" ctrlp Mappings
let g:ctrlp_map = ',t'
nnoremap <C-b> :CtrlPBuffer<CR>
nnoremap <Leader>b :CtrlPBufTag<CR>
nnoremap <Leader>c :CtrlPClearCache<CR>

" ================ Completion ========================
set wildchar=<Tab> wildmenu wildmode=full
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif
set tags+=gems.tags " ruby gems ctags

"go to last position when opening a file, but not when writing commit messages
function! SetCursorPosition()
    if &filetype !~ 'commit\c'
        if line("'\"") > 0 && line("'\"") <= line("$")
            exe "normal! g`\""
            normal! zz
        endif
    end
endfunction
autocmd BufReadPost * call SetCursorPosition()

"strip trailing whitespace
function! <SID>StripTrailingWhitespaces()
    "save last search and cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    "do the business
    %s/\s\+$//e
    "restore previous search history and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

