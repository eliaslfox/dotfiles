" base config
set nocompatible
filetype plugin indent on
set termguicolors
colorscheme NeoSolarized

" general settings
set updatetime=100
set nowrap
set backspace=indent,eol,start
set encoding=utf8
set scrolloff=2
set fileformats=unix,dos

" ui
set cursorline
set ruler

" fuzzy finding
set wildmenu
set wildmode=full
set path+=**

" file browser
let g:netrw_banner=0
let g:netrw_liststyle=3
let g:netrw_altv=1
let g:netrw_list_hide=netrw_gitignore#Hide()

" search
set showmatch
set hlsearch
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
set autoindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab

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
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'typescript': ['javascript-typescript-stdio'],
    \ 'go': ['gopls']
    \ }
autocmd BufWritePre *.go :call LanguageClient#textDocument_formatting_sync()

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
    \ 'haskell': []
    \ }
