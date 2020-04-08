{ pkgs, ... }:

let
  customPackages.NeoSolarized = pkgs.vimUtils.buildVimPlugin {
    name = "NeoSolarized";
    src = pkgs.fetchFromGitHub {
      owner = "icymind";
      repo = "NeoSolarized";
      rev = "1af4bf6835f0fbf156c6391dc228cae6ea967053";
      sha256 = "1l98yh3438anq33a094p5qrnhcm60nr28crs0v4nfah7lfdy5mc2";
    };
  };
  customPackages.ghcid-neovim = pkgs.vimUtils.buildVimPlugin {
    name = "ghcid-neovim";
    src = "${pkgs.fetchFromGitHub {
      owner = "ndmitchell";
      repo = "ghcid";
      rev = "v0.8.5";
      sha256 = "080496a9wwfxp1jjg4h60ms2f0xd1phh2x8n9alk180hrdx2bywa";
    }}/plugins/nvim";
  };
in
pkgs.neovim.override {
  vimAlias = true;
  withPython3 = true;
  configure.vam.knownPlugins = pkgs.vimPlugins // customPackages;
  configure.vam.pluginDictionaries = [
    /* UI */
    "NeoSolarized"
    "goyo-vim"
    "vim-airline"
    "vim-airline-themes"
    "supertab"

    /* Language Agnostic Plugins */
    {
      name = "deoplete-nvim";
      command = ":UpdateRemotePlugins";
    }
    "LanguageClient-neovim"
    "ale"
    "gitgutter"

    /* Language Plugins */
    "ghcid-neovim"
    "vim-nix"
    "vim-javascript"
    "typescript-vim"
  ];
  configure.customRC = builtins.readFile ./files/init.vim;
}
