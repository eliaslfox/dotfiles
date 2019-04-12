set nocompatible
set termguicolors
colorscheme NeoSolarized

set hidden
set nowrap

let g:deoplete#enable_at_startup = 1
let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ }
