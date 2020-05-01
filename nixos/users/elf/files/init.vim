" base config
set termguicolors
colorscheme NeoSolarized

" general settings
set updatetime=100
set nowrap
set scrolloff=2
set cursorline

" fuzzy finding
set wildmode=full
set wildoptions+=pum
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
set smartcase
set gdefault

" disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" indenting settings
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" track undo
set undofile
set undodir=~/.local/share/neovim/undo
set writebackup
set backupdir=~/.local/share/neovim/backup
set directory=~/.local/share/neovim/swap

" airline
let g:airline_powerline_fonts = 1
let g:airline_theme = 'solarized'
let g:airline#extensions#ale#enabled = 1

" gitgutter
let g:gitgutter_override_sign_column_highlight = 0
let g:gitgutter_map_keys = 0

"
" Deoplete
"
let g:deoplete#enable_at_startup = 1
set completeopt-=preview

"
" Language Client
"
let g:LanguageClient_diagnosticsDisplay = {
    \ 2: {
        \ 'signText':'⚑'
        \ }
    \ }

let g:LanguageClient_serverCommands = {
    \ 'rust': ['rust-analyzer'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'typescript': ['javascript-typescript-stdio'],
    \ 'go': ['gopls']
    \ }

autocmd BufWritePre *.go :call LanguageClient#textDocument_formatting_sync()
autocmd BufWritePre *.rs :call LanguageClient#textDocument_formatting_sync()

nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> K :call LanguageClient_contextMenu()<CR>

command Noh :sign unplace * " This clears sign errors for when they get stuck

"
" Neoformat
"
let g:neoformat_basic_format_trim = 1
let g:neoformat_run_all_formatters = 1

let g:neoformat_enabled_rust = ['rustfmt']
let g:neoformat_enabled_go = ['gofmt', 'goimports']
let g:neoformat_enabled_javascript = ['prettier']
let g:neoformat_enabled_nix = ['nixfmt']

augroup fmt
    autocmd!
    autocmd BufWritePre * undojoin | Neoformat
augroup end
