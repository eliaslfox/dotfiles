set nocompatible
set termguicolors
colorscheme NeoSolarized

" general settings
set updatetime=100
set hidden
set nowrap
set wildmenu
set wildmode=full
set backspace=indent,eol,start
set cursorline
set encoding=utf8
set hlsearch
set smartcase
set ruler
set showmatch
set scrolloff=2


" Search
set incsearch
set ignorecase
set smartcase
set gdefault


" disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" sane indenting settings
filetype plugin indent on
set autoindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab
set fileformats=unix,dos

" tack undo
set undofile
set undodir=~/.cache/neovim/undo
set writebackup
set backupdir=~/.cache/neovim/backup
set directory=~/.cache/neovim/swap


let g:airline_powerline_fonts = 1
let g:airline_theme = 'solarized'
let g:airline#extensions#ale#enabled = 1

let g:gitgutter_override_sign_column_highlight = 0

let g:deoplete#enable_at_startup = 1
let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ 'javascript': ['/home/elf/.nix-profile/bin/javascript-typescript-stdio'],
    \ 'typescript': ['/home/elf/.nix-profile/bin/javascript-typescript-stdio'],
    \ }

let g:ale_fix_on_save = 1
let g:ale_sign_column_always = 0
let g:ale_change_sign_column_color = 1

let g:ale_sign_error = '⤫'
let g:ale_sign_warning = '⚑'

let g:ale_fixers = {
    \ '*': ['remove_trailing_lines', 'trim_whitespace'],
    \ }

let g:ale_linters = {
    \ 'javascript': [],
    \ 'typescript': [],
    \ }
