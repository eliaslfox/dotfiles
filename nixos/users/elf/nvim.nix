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
  customPackages.universal-text-linking = pkgs.vimUtils.buildVimPlugin {
    name = "universal-text-linking";
    src = pkgs.fetchFromGitHub {
      owner = "vim-scripts";
      repo = "utl.vim";
      rev = "67a6506a7a8a3847d00d3af3e2ed9707460d5ce5";
      sha256 = "0ax68nmzlka9193n2h82qzvhzv4dv6lm7rg3b1vhj2pn1r6ci6p4";
    };
  };
  customPackages.SyntaxRange = pkgs.vimUtils.buildVimPlugin {
    name = "SyntaxRange";
    src = pkgs.fetchFromGitHub {
      owner = "vim-scripts";
      repo = "SyntaxRange";
      rev = "74894260c0d1c281b5141df492495aa9c43fd620";
      sha256 = "057z919dfh7v05zwamzmyj0x2cjfqr6p7s3l8i84wz1hkd77ib40";
    };
  };
  customPackages.vim-orgmode = pkgs.vimUtils.buildVimPlugin {
    name = "vim-orgmode";
    src = pkgs.fetchFromGitHub {
      owner = "jceb";
      repo = "vim-orgmode";
      rev = "35e94218c12a0c063b4b3a9b48e7867578e1e13c";
      sha256 = "0j6zfqqysnky4z54413l87q7wxbskg0zb221zbz48ry4l1anilhx";
    };
  };
in
pkgs.neovim.override {
  vimAlias = true;
  withPython3 = true;
  configure.vam.knownPlugins = pkgs.vimPlugins // customPackages;
  configure.vam.pluginDictionaries = [
    /* UI */
    "NeoSolarized"
    "vim-airline"
    "vim-airline-themes"

    /* Language Agnostic Plugins */
    {
      name = "deoplete-nvim";
      command = ":UpdateRemotePlugins";
    }
    "LanguageClient-neovim"
    "ale"

    /* Org Mode */
    "universal-text-linking"
    "SyntaxRange"
    "vim-orgmode"

    /* Language Plugins */
    "ghcid-neovim"
    "vim-nix"
    "vim-javascript"
    "gitgutter"
  ];
  configure.customRC = builtins.readFile ./files/init.vim;
}
