" base config
syntax enable
set termguicolors
filetype plugin indent on
colorscheme NeoSolarized

" general settings
set hidden
set updatetime=100
set backspace=indent,eol,start
set encoding=utf-8
set autoread
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
set path+=**

" file browser
let g:netrw_banner=0
let g:netrw_liststyle=0
let g:netrw_altv=1
let g:netrw_list_hide=netrw_gitignore#Hide()

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
set undodir=~/.local/share/neovim/undo//
set backupdir=~/.local/share/neovim/backup//
set directory=~/.local/share/neovim/swap//

"
" UI
"

" airline
let g:airline_powerline_fonts = 1

" gitgutter
let g:gitgutter_override_sign_column_highlight = 0
let g:gitgutter_map_keys = 0

nmap ]c <Plug>(GitGutterNextHunk)
nmap [c <Plug>(GitGutterPrevHunk)

" gundo
let g:gundo_prefer_python3 = 1
let g:gundo_help = 0

nnoremap <F5> :GundoToggle<CR>

"
" coc.nvim
"
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap <Leader>rn <Plug>(coc-rename)
nnoremap <silent> K :call CocAction('doHover')<CR>

nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>

inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

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
