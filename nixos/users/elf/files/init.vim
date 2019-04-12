set nocompatible
set termguicolors
colorscheme NeoSolarized

" general settings
set updatetime=100
set hidden
set nowrap
set wildmenu
set backspace=2
set cursorline
set encoding=utf8
set hlsearch
set smartcase

" disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" sane indenting settings
filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab

" tack undo
set undofile
set undodir=~/.cache/neovim/undodir


let g:airline_powerline_fonts = 1
let g:airline_theme = 'solarized'

let g:gitgutter_override_sign_column_highlight = 0

let g:deoplete#enable_at_startup = 1
let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ }

let g:ale_fix_on_save = 1
let g:ale_sign_column_always = 1
let g:ale_change_sign_column_color = 1

let g:ale_sign_error = '⤫'
let g:ale_sign_warning = '⚑'

let g:ale_fixers = {
    \   '*': ['remove_trailing_lines', 'trim_whitespace'],
    \ }
