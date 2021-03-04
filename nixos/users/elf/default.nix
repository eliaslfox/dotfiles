{ config, pkgs, lib, ... }:
let
  scripts = pkgs.callPackage (import ./scripts.nix) { config = config; };
  master = import <nixpkgs-master> { config = { allowUnfree = true; }; };
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{
  xdg = {
    enable = true;
    configFile = {
      "npm/npmrc".source = ./files/npmrc;
      "ssh/config".source = ./files/ssh-config;
      "ripgreprc".source = ./files/ripgreprc;
      "nvim/coc-settings.json".source = ./files/coc-settings.json;
      "emacs.d/init.el".source = ./files/init.el;

      "hadolint.yaml".text = ''
        ignored:
         - DL3008
      '';

      ".clang-format".text = ''
        BasedOnStyle: LLVM
        IndentWidth: 4
        AllowShortFunctionsOnASingleLine: None
        KeepEmptyLinesAtTheStartOfBlocks: false
      '';
    };
    dataFile = {
      "stack/config.yaml".source = ./files/stack-config.yaml;
      "ghc/ghci.conf".source = ./files/ghci.conf;
    };
  };

  home = {
    username = "elf";
    homeDirectory = "/home/elf";
    keyboard.layout = "us";

    file = {
      ".gnupg/gpg-agent.conf".target = ".config/gnupg/gpg-agent.conf";
      ".gnupg/gpg.conf".target = ".config/gnupg/gpg.conf";

      ".mozilla/firefox/profiles.ini".target =
        ".local/share/mozilla/firefox/profiles.ini";
      ".mozilla/firefox/default/user.js".target =
        ".local/share/mozilla/firefox/default/user.js";
      ".mozilla/firefox/default/chrome/userChrome.css".target =
        ".local/share/mozilla/firefox/default/chrome/userChrome.css";
      ".mozilla/firefox/clean/user.js".target =
        ".local/share/mozilla/firefox/clean/user.js";
      ".mozilla/firefox/clean/chrome/userChrome.css".target =
        ".local/share/mozilla/firefox/clean/chrome/userChrome.css";

      ".xinitrc".text = ''
        #!/bin/sh
        set -e

        if [ -f ~/.Xresources ]; then
          xrdb ~/.Xresources
        fi
        systemctl restart --user graphical-session.target
        exec i3
      '';

      ".gdbinit".source = "${pkgs.fetchFromGitHub {
          owner = "cyrus-and";
          repo = "gdb-dashboard";
          rev = "f09356e264121fabdde125aa8838bcfcaf1d13c7";
          sha256 = "1z1y5ac339k303yjfdsrv4ffyn02vzinra9z3klzzimh5snjf0cc";
          }}/.gdbinit";

      ".gdbinit.d/init".text = ''
        set confirm off
        set print thread-events off
        set disassembly-flavor intel
        set history save off

        dashboard -style style_low '1;34'

        define dash-asm
          dashboard -layout assembly breakpoints registers source stack
        end

        define dash-src
          dashboard -layout breakpoints source stack threads
          dashboard source -style height
        end
      '';

      ".haskeline".text = ''
        historyDuplicates: IgnoreAll
        editMode: Vi
        completionType: MenuCompletion
      '';
    };

    extraOutputsToInstall = [ "doc" "info" "devdoc" ];

    packages = with pkgs; [
      # coreutils 2.0
      exa
      ripgrep
      fd
      xh
      hyperfine
      hexyl
      dust
      moreutils

      #
      # programming
      #

      # c
      gdb
      gnumake
      bear
      binutils-unwrapped
      llvmPackages_latest.bintools
      clang-tools
      valgrind
      ltrace
      rr

      # this was required to get clangd working
      # with gcc, hopefully not anymore?
      # gcc-unwrapped
      # (pkgs.lowPrio llvmPackages.clang-unwrapped)

      # rust
      rustup
      rust-analyzer
      cargo-audit # checks rustsec advisory database
      cargo-license
      cargo-edit
      cargo-geiger # checks dependency tree for unsafe code
      cargo-outdated
      cargo-deny

      # node
      nodejs
      nodePackages.prettier
      nodePackages.eslint

      # nix
      nixpkgs-fmt
      nix-prefetch-git
      nix-prefetch-docker
      nixpkgs-review
      # nixops

      # go
      # go
      # gopls
      # goimports
      # golangci-lint

      # haskell
      stack
      ghc
      hlint
      stylish-haskell

      # shell
      shellcheck
      shfmt

      # lisp
      mitscheme

      # dockerfile
      #hadolint

      # python
      black
      python39Packages.flake8

      # text
      proselint

      cava
      ranger
      gnuplot
      cura
      zoom-us
      calibre
      scrot
      blender
      postgresql
      mupdf
      pavucontrol
      scripts.libreoffice
      razergenie
      spotify-tui
      spotify
      transmission-gtk
      btrbk
      master.discord
      feh
      vlc
      mpv
      pass
      neofetch
      tor-browser-bundle-bin
      youtube-dl

      scripts.multimc
    ];
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome-themes-extra;
    };
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk3.extraCss = ''
      .titlebar.default-decoration {
        margin: -200px;
        opacity: 0;
      }
    '';
  };

  xsession.windowManager.i3 = import ./i3.nix { pkgs = pkgs; config = config; lib = lib; };

  programs = {
    emacs = import ./emacs.nix { pkgs = pkgs; };
    firefox = import ./firefox.nix;
    i3status = import ./i3status.nix;
    git = import ./git.nix { pkgs = pkgs; };
    kitty = import ./kitty.nix { pkgs = pkgs; };
    neovim = import ./nvim.nix { pkgs = pkgs; };
    zsh = import ./zsh.nix { pkgs = pkgs; };

    command-not-found.enable = true;

    chromium = {
      enable = true;
      package = unstable.chromium;
      extensions = [
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      ];
    };

    htop = {
      enable = true;
      colorScheme = 6;
      hideThreads = true;
      hideUserlandThreads = true;
      meters = {
        left = [ "LeftCPUs" "Memory" "Swap" ];
        right = [ "RightCPUs" "Tasks" "Uptime" "Hostname" ];
      };
      updateProcessNames = true;
      showThreadNames = true;
    };

    gpg = {
      enable = true;
      settings = {
        default-key = "0x2E9DA81892721D77";
        trusted-key = "0x2E9DA81892721D77";
      };
    };
  };

  services = {
    dunst = import ./dunst.nix;

    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      defaultCacheTtl = 60;
      maxCacheTtl = 120;
    };
    picom = {
      opacityRule = [ ''80:WM_CLASS@:s = "term-float"'' ];
      menuOpacity = "0.8";
    };
  };

  systemd.user = {
    startServices = true;
    services = {
      home-symlinks = {
        Unit = { Description = "Init symlinks in home folder"; };
        Service = {
          ExecStart = "${scripts.symlink-init}/bin/symlink-init";
        };
        Install = { WantedBy = [ "default.target" ]; };
      };

      set-bg = {
        Unit = { Description = "Set background"; };
        Service = {
          ExecStart = "${scripts.set-bg}/bin/set-bg";
          Environment = "DISPLAY=:0";
        };
        Install = { WantedBy = [ "graphical-session.target" ]; };
      };
      picom = {
        Service = { Environment = "DISPLAY=:0"; };
      };
      unclutter = {
        Service = { Environment = "DISPLAY=:0"; };
      };
      xss-lock = {
        Service = { Environment = "DISPLAY=:0"; };
      };
      xautolock-session = {
        Service = { Environment = "DISPLAY=:0"; };
      };
      setxkbmap = {
        Service = { Environment = "DISPLAY=:0"; };
      };
      dunst = {
        Service = { Environment = "DISPLAY=:0"; };
      };
    };
  };

  home.stateVersion = "21.05";
}
