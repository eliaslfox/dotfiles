{ pkgs, ... }: {
  enable = true;
  extraConfig = builtins.readFile ./files/init.vim;
  plugins = with pkgs.vimPlugins; [
    NeoSolarized
    vim-airline
    vim-airline-themes

    coc-nvim
    ale
    ctrlp-vim
    vim-gitgutter
    vim-fugitive

    vim-nix
    vim-javascript
    typescript-vim
    vim-jsx-typescript
    rust-vim
  ];
  withPython = false;
  withRuby = false;
  viAlias = true;
  vimAlias = true;
  vimdiffAlias = true;
}
