if &compatible
	set nocompatible
endif

" this needs to be installed before it can be used
" install the plugin manager as stated below:
"
" curl
" https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh
" -o installer.sh
" sh ./installer.sh ~/.config/vim
"
" then use `:call dein#install()`

set runtimepath+=~/.config/vim/repos/github.com/Shougo/dein.vim
let g:neosnippet#disable_runtime_snippets = { '_' : 1 }

if dein#load_state('~/.config/vim')
	call dein#begin('~/.config/vim')

	call dein#add('~/.config/vim/repos/github.com/Shougo/dein.vim')
	"call dein#add('Shougo/neosnippet.vim')
	"call dein#add('Shougo/neosnippet-snippet')
	call dein#add('dense-analysis/ale')
	call dein#add('janet-lang/janet.vim')
	call dein#add('wlangstroth/vim-racket')
	"call dein#add('xuhdev/vim-latex-live-preview')
	call dein#end()
	call dein#save_state()
endif 

colo desert
syntax enable
filetype plugin indent on
set number
set bs=2
set relativenumber
set tabstop=2
set autoindent
set foldmethod=syntax
set foldminlines=10
set clipboard=unnamed
set laststatus=2
set title
set ruler
set shiftwidth=2
set softtabstop=2
set sb
set ttyfast
set cursorline
hi CursorLine cterm=NONE ctermfg=0 ctermbg=3
hi CursorLineNr ctermfg=0 ctermbg=4
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"

"Some more dev-focused options
"Make vim stop treating my *.h files as C++
let c_syntax_for_h = 1

"TODO: add logic for detecting ALE in runtime path before setting these values
"Set some configuration options for ALE
let g:ale_c_clangd_executable='clangd-devel'
let g:ale_c_clang_executable='clang-devel'
"Custom flags for checking with clang/llvm
let g:ale_c_clang_options = '-std=c99 -Wall -Wextra -pedantic -Weverything -Wparentheses -fstrict-return -fstrict-enum -I/usr/local/include'
"Will need to validate some of the GCC flags, but should use mostly the same
"ideas as the clang flags
let g:ale_c_gcc_options = '-std=c99 -Wall -Wextra -pedantic -I/usr/local/include'

"Autocommands for some special file types
aug specials
	au!
	au BufRead,BufNewFile *.rkt,*.rktl set ft=racket
	"au BufRead,BufNewFile *.janet set ft=janet
	au BufRead,BufNewFile *.rkt,*.janet,*.z3,<scheme;janet;lisp> set et | set sts=2 | set sw=2 | set lcs=tab:>- | set list
	au BufRead,BufNewFile *.md,*.html,<markdown;html> set spell | set listchars=tab;>. | set list
	au BufRead,BufNewFile *.tex,<tex> set spell
aug END
