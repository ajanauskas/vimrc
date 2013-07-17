runtime bundle/pathogen/autoload/pathogen.vim

set nocompatible               "use Vim settings, rather than Vi
filetype off

call pathogen#infect()
call pathogen#helptags()

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
