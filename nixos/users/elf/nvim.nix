{ pkgs, ... }: {
  enable = true;
  extraConfig = builtins.readFile ./files/init.vim;
  plugins = with pkgs.vimPlugins; [
    NeoSolarized
    vim-airline
    vim-airline-themes

    coc-nvim
    ale
    gitgutter
    gundo
    ctrlp-vim
    ghcid
    vim-markdown

    vim-nix
  ];
  withPython = false;
  withRuby = false;
  viAlias = true;
  vimAlias = true;
  vimdiffAlias = true;
}
