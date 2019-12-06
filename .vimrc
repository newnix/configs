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

set runtimepath+=/home/newnix/.config/vim/repos/github.com/Shougo/dein.vim
let g:neosnippet#disable_runtime_snippets = { '_' : 1 }

if dein#load_state('/home/newnix/.config/vim')
	call dein#begin('/home/newnix/.config/vim')

	call dein#add('/home/newnix/.config/vim/repos/github.com/Shougo/dein.vim')
	"call dein#add('Shougo/neosnippet.vim')
	"call dein#add('Shougo/neosnippet-snippet')
	call dein#add('w0rp/ale')
	"call dein#add('xuhdev/vim-latex-live-preview')
	call dein#end()
	call dein#save_state()
endif 

:set number
:set bs=2
:set relativenumber
:syntax enable
:set tabstop=2
:set autoindent
"Make vim stop treating my *.h files as C++
:let c_syntax_for_h = 1
":let c_no_comment_fold = 1
:filetype plugin indent on
:set foldmethod=syntax
":set foldnestmax=3
:set foldminlines=10
:set clipboard=unnamed
:set laststatus=2
:set title
:set ruler
:set shiftwidth=2
:set softtabstop=2
:set sb
" This setting doesn't seem to be as useful as the tmux manual
" made it sound
:set ttyfast
":set termguicolors
":set lazyredraw
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
" Add provisions for LaTeX live previews
"let g:livepreview_previewer = '/usr/local/bin/mupdf'
"let g:updatetime = 1000

"TODO: add logic for detecting ALE in runtime path before setting these values
"Set some configuration options for ALE
"Custom flags for checking with clang/llvm
let g:ale_c_clang_options = '-std=c99 -Wall -Wextra -pedantic -Weverything -Wparentheses -fstrict-return -fstrict-enum -I/usr/local/include'
"Will need to validate some of the GCC flags, but should use mostly the same
"ideas as the clang flags
let g:ale_c_gcc_options = '-std=c99 -Wall -Wextra -pedantic -I/usr/local/include'
