" base config
set termguicolors
colorscheme NeoSolarized
highlight CocFloating ctermbg=109 guifg=#83a598

" general settings
set hidden
set updatetime=100
set shortmess+=I
set shortmess+=c
set mouse=a
let mapleader=","

" UI
set nowrap
set scrolloff=2
set cursorline
set showmatch
set wildmode=full

" splitting
set splitright
set splitbelow

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

" disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" indenting settings
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
let g:airline#extensions#nvimlsp#enabled = 0
let g:airline#extensions#branch#enabled = 0

" ctrlp
let g:ctrlp_map = '<C-Space>'
let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
let g:ctrlp_use_caching = 0

" git gutter
let g:gitgutter_map_keys = 0


"
" coc.nvim
"
nnoremap <leader>a :<C-u>CocAction<cr>

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
let g:ale_disable_lsp = 1
let g:ale_fix_on_save = 1

let g:ale_sign_error = '⚑'
let g:ale_sign_warning = '✘'
let g:ale_sign_info = 'ℹ'

let g:ale_fixers = {
    \ '*': ['remove_trailing_lines', 'trim_whitespace'],
    \ 'rust': [],
    \ 'go': ['goimports'],
    \ 'nix': ['nixpkgs-fmt'],
    \ 'json': ['prettier'],
    \ 'javascript': ['eslint', 'prettier'],
    \ 'typescript': ['eslint', 'prettier'],
    \ 'markdown': ['prettier'],
    \ 'c': ['clang-format'],
    \ 'cpp': ['clang-format'],
    \ 'sh': ['shfmt'],
    \ 'haskell': ['hlint'],
    \ 'python': ['black']
    \ }

let g:ale_sh_shellcheck_options = '--external-sources --enable=all'

let g:ale_c_clangtidy_checks = [
    \ '-clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling',
    \ ]
let g:ale_go_golangci_lint_options = '--disable typecheck'

let g:ale_linters = {
    \ 'rust': [],
    \ 'go': ['golangci-lint'],
    \ 'javascript': ['eslint'],
    \ 'typescript': ['eslint'],
    \ 'c': ['clangtidy'],
    \ 'cpp': ['clangtidy'],
    \ 'sh': ['shellcheck'],
    \ 'dockerfile': ['hadolint'],
    \ 'haskell': ['stylish-haskell'],
    \ 'asm': [],
    \ 'markdown': ['proselint'],
    \ 'text': ['proselint'],
    \ 'python': ['flake8']
    \ }
