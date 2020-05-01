{ pkgs, ... }:

pkgs.neovim.override {
  vimAlias = true;
  withPython3 = true;
  withPython = false;
  withRuby = false;
  configure.vam.knownPlugins = pkgs.vimPlugins;
  configure.vam.pluginDictionaries = [
    /* UI */
    "NeoSolarized"
    "vim-airline"
    "vim-airline-themes"
    "supertab"

    /* Language Agnostic Plugins */
    {
      name = "deoplete-nvim";
      command = ":UpdateRemotePlugins";
    }
    "LanguageClient-neovim"
    "neoformat"
    "gitgutter"

    /* Language Plugins */
    "ghcid"
    "vim-nix"
    "vim-javascript"
    "typescript-vim"
  ];
  configure.customRC = builtins.readFile ./files/init.vim;
}
