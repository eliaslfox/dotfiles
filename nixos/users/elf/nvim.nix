with import <nixpkgs> {};

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
      rev = "v0.7.2";
      sha256 = "0flq6a1yja47hn2h5hvcikmg7ysciscvqm9z1a24vdp890m8zrb3";
    }}/plugins/nvim";
  };
in
pkgs.neovim.override {
  vimAlias = true;
  withPython3 = true;
  configure.vam.knownPlugins = pkgs.vimPlugins // customPackages;
  configure.vam.pluginDictionaries = [
    "NeoSolarized"
    "vim-airline"
    "vim-airline-themes"

    {
      name = "deoplete-nvim";
      command = ":UpdateRemotePlugins";
    }
    "LanguageClient-neovim"
    "ale"

    "ghcid-neovim"
    "vim-nix"
    "vim-javascript"
    "gitgutter"
  ];
  configure.customRC = builtins.readFile ./files/init.vim;
}
