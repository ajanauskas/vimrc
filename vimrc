runtime bundle/pathogen/autoload/pathogen.vim
set runtimepath^=~/.vim/bundle/ctrlp.vim

set nocompatible               "use Vim settings, rather than Vi

filetype off

call pathogen#infect()
call pathogen#helptags()

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

set ttyfast            "smoother changes
set incsearch          "incremental search on
set hls                "highlight search

let mapleader = ","            "map <Leader> from \ to ,
let maplocalleader = "/"       "map <LocalLeader> to \

" ctrlp configuration
let g:ctrlp_custom_ignore = 'node_modules\|\.git$\|\.hg$\|\.svn$\|\.swp$\|\.min\.js$|\.png$|\.jpg$|\.log$\|tmp\|log'
let g:ctrlp_max_height = 15

" ctrlp Mappings
let g:ctrlp_map = ',t'
nnoremap <C-b> :CtrlPBuffer<CR>
nnoremap <Leader>b :CtrlPBufTag<CR>
nnoremap <Leader>c :CtrlPClearCache<CR>

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

if has("gui_gnome")
    set guifont=Monospace\ Bold\ 11
elseif has("gui_mac") || has("gui_macvim")
    set guifont=Meslo\ LG\ S\ DZ\ for\ Powerline:h12
elseif has("gui_win32") || has("gui_win32s")
    set guifont=Consolas:h11
    set enc=utf-8
endif

"go to last position when opening a file, but now when writing commit messages
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
