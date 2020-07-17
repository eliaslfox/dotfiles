" base config
syntax enable
syntax sync minlines=1000 "syntax highight based on offscreen lines
set termguicolors
filetype plugin indent on
colorscheme NeoSolarized

" general settings
set hidden
set updatetime=100
set backspace=indent,eol,start
set encoding=utf-8
set autoread
set shortmess+=I
set shortmess+=c
let mapleader=","

" UI
set nowrap
set scrolloff=2
set cursorline
set laststatus=2
set showmatch
set showcmd

" splitting
set splitright
set splitbelow

" fuzzy finding
set wildmenu
set wildmode=full
set wildoptions+=pum
set wildignorecase

" keybindts

" file browser
let g:netrw_banner=0
let g:netrw_altv=1

" spelling
set complete+=kspell
set spelllang=en
augroup spelling
    autocmd!
    autocmd FileType markdown setlocal spell
    autocmd FileType gitcommit setlocal spell
augroup END

" search
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
set autoindent
set smarttab
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" track undo
set undofile
set writebackup
set undodir=~/.local/share/nvim/undo//
set backupdir=~/.local/share/nvim/backup//
set directory=~/.local/share/nvim/swap//

"
" UI
"

" airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#ale#enabled = 1

" ctrlp
let g:ctrlp_map = '<C-Space>'
let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
let g:ctrlp_use_caching = 0

"
" git gutter
"
let g:gitgutter_map_keys = 0


"
" coc.nvim
"

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gD :call CocAction('jumpDefinition', 'vsplit')<cr>
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap <Leader>rn <Plug>(coc-rename)
nnoremap <silent> K :call CocAction('doHover')<CR>

nnoremap <silent> <Leader>e  :<C-u>CocList extensions<cr>
nnoremap <silent> <Leader>o  :<C-u>CocList outline<cr>
nnoremap <silent> <Leader>s  :<C-u>CocList -I symbols<cr>

inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

"
" Ale
"
let g:ale_fix_on_save = 1

let g:ale_fixers = {
    \ '*': ['remove_trailing_lines', 'trim_whitespace'],
    \ 'rust': ['rustfmt'],
    \ 'nix': ['nixpkgs-fmt'],
    \ 'json': ['prettier'],
    \ 'javascript': ['prettier'],
    \ 'typescript': ['prettier'],
    \ 'markdown': ['prettier'],
    \ 'go': ['gofmt', 'goimports'],
    \ 'c': [],
    \ 'cpp': [],
    \ 'sh': ['shfmt'],
    \ }

let g:ale_sh_shellcheck_options = '--external-sources --enable=all'

let g:ale_linters = {
    \ 'rust': [],
    \ 'go': [],
    \ 'typescript': [],
    \ 'c': [],
    \ 'cpp': [],
    \ 'sh': ['shellcheck'],
    \ 'dockerfile': ['hadolint'],
    \ }
