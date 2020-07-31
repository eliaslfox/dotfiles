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

    ghcid
    vim-nix
    vim-javascript
    typescript-vim
    vim-jsx-typescript
  ];
  withPython = false;
  withRuby = false;
  viAlias = true;
  vimAlias = true;
  vimdiffAlias = true;
}
