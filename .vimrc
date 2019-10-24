
call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'

call plug#end()

:set ts=2
:set sw=2
:set sts=2
:set expandtab
:set autoindent
:set nu
:syntax on

:colors darkblue

:nnoremap j gj
:nnoremap k gk

:nnoremap <F1> <ESC>
:inoremap <F1> <ESC>
:vnoremap <F1> <ESC>

:let mapleader=","

:nnoremap <leader>rs :source ~/.vimrc<CR>
:nnoremap <leader>es :vs ~/.vimrc<CR>
