{ pkgs, ... }: {
  enable = true;
  extraConfig = builtins.readFile ./files/init.vim;
  plugins = with pkgs.vimPlugins; [
    NeoSolarized
    vim-airline
    vim-airline-themes
    supertab

    deoplete-nvim
    LanguageClient-neovim
    neoformat
    gitgutter

    ghcid
    vim-nix
    vim-javascript
    typescript-vim
  ];
  withPython = false;
  withRuby = false;
  viAlias = true;
  vimAlias = true;
  vimdiffAlias = true;
}
