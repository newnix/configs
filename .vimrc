:set number
" OpenBSD compat
" this is not guranteed to be on by default
:set bs=2
:set relativenumber
:syntax on
:set tabstop=2
:set autoindent
:filetype plugin on
:set clipboard=unnamed
:set laststatus=2
:set title
:set ruler
:set shiftwidth=2
:set sb
" This setting doesn't seem to be as useful as the tmux manual
" made it sound
:set ttyfast
":set termguicolors
:set lazyredraw
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
