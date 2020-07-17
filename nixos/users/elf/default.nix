{ config, pkgs, lib, ... }:
let
  scripts = pkgs.callPackage (import ./scripts.nix) { config = config; };
  master = import <nixpkgs-master> { config = { allowUnfree = true; }; };
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

      "ncmpcpp/config".text = ''
        display-bitrate = yes
        progressbar_look = "── "

        ncmpcpp_directory="/home/elf/.cache/ncmpcpp"
        lyrics_directory="/home/elf/.cache/ncmpcpp/lyrics"

        execute_on_song_change = "${scripts.ncmpcpp-notify}/bin/ncmpcpp-notify"
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

        if [ -f ~/.Xresources ]; then
          xrdb ~/.Xresources   
        fi
        systemctl restart --user graphical-session.target
        exec i3
      '';

      ".gdbinit".source = "${pkgs.fetchFromGitHub {
          owner = "cyrus-and";
          repo = "gdb-dashboard";
          rev = "2d31a3b391e5d0e032b791e1fb7172338b02cecb";
          sha256 = "05kg4884sic2p5ibrsr6c5rnkj0vkyndwxyg01xccx6gkqgmw34d";
          }}/.gdbinit";

      ".gdbinit.d/init".text = ''
        set confirm off
        set print thread-events off

        dashboard -style style_low '1;34'
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
      httpie

      #
      # programming
      #

      # c
      gdb
      gnumake
      bear
      gcc-unwrapped
      clang-tools
      llvmPackages.clang-unwrapped.python
      (pkgs.lowPrio llvmPackages.clang-unwrapped)
      binutils-unwrapped
      valgrind
      ltrace
      rr

      # rust
      rustup
      rust-analyzer
      cargo-audit

      # node
      nodejs
      nodePackages.prettier

      # nix
      nixpkgs-fmt
      nix-prefetch-git
      nix-prefetch-docker
      nixpkgs-review

      # go
      go
      gopls
      goimports

      # haskell
      stack
      ghc
      hlint
      stylish-haskell

      # shell
      shellcheck
      shfmt

      # dockerfile
      hadolint

      gnuplot
      cura
      zoom-us
      pandoc
      libreoffice
      calibre
      libnotify
      scrot
      inetutils
      blender
      postgresql
      zathura
      pavucontrol
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
      ncmpcpp

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
    };
  };

  home.stateVersion = "20.09";
}
