" -------------------------------------------------------------------
"  Color settings
" -------------------------------------------------------------------

syntax on

" -------------------------------------------------------------------
"  Basic settings
" -------------------------------------------------------------------

set expandtab
set tabstop=4
set softtabstop=4
set incsearch
set hlsearch

" -------------------------------------------------------------------
"  Basic autocommands
" -------------------------------------------------------------------

" Ensure tabs don't get converted to spaces in Makefiles
autocmd FileType make setlocal noexpandtab
