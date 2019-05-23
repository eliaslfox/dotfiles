with import <nixpkgs> {};
{ config, pkgs }:
let
  symlink-init = pkgs.writeScriptBin "symlink-init" ''
    #!/bin/sh
    set -e

    ${pkgs.coreutils}/bin/mkdir -vp /home/elf/.local/share/steam-install
    ${pkgs.coreutils}/bin/ln -sfvT /home/elf/.local/share/steam-install /home/elf/.steam

    ${pkgs.coreutils}/bin/mkdir -vp /home/elf/.local/share/mozilla
    ${pkgs.coreutils}/bin/ln -sfvT /home/elf/.local/share/mozilla /home/elf/.mozilla

    ${pkgs.coreutils}/bin/mkdir -vp /home/elf/.local/share/stack
    ${pkgs.coreutils}/bin/ln -sfvT /home/elf/.local/share/stack /home/elf/.stack

    ${pkgs.coreutils}/bin/mkdir -vp /home/elf/.local/share/ghc
    ${pkgs.coreutils}/bin/ln -sfvT /home/elf/.local/share/ghc /home/elf/.ghc

    ${pkgs.coreutils}/bin/mkdir -vp /home/elf/.local/share/cabal
    ${pkgs.coreutils}/bin/ln -sfvT /home/elf/.local/share/cabal /home/elf/.cabal

    ${pkgs.coreutils}/bin/mkdir -vp /home/elf/.config/npmpcpp
    ${pkgs.coreutils}/bin/ln -sfvT /home/elf/.config/npmpcpp /home/elf/.ncmpcpp

    ${pkgs.coreutils}/bin/mkdir -vp /home/elf/.config/ssh
    ${pkgs.coreutils}/bin/ln -sfvT /home/elf/.config/ssh /home/elf/.ssh

    ${pkgs.coreutils}/bin/mkdir -vp /home/elf/.config/nixops
    ${pkgs.coreutils}/bin/ln -sfvT /home/elf/.config/nixops /home/elf/.nixops

    ${pkgs.coreutils}/bin/ln -sfvT /home/elf/.config/npmrc /home/elf/.npmrc

  '';

  ncmpcpp-notify = pkgs.writeScriptBin "ncmpcpp-notify" ''
    #!/bin/sh
    set -e

    MPC=${pkgs.mpc_cli}/bin/mpc
    IFS=$'\t' read album artist title \
      <<< "$($MPC --format="%album%\t%artist%\t%title%")"

    ${pkgs.libnotify}/bin/notify-send --app-name=ncmpcpp --icon=audio-x-generic \
        "$title" "$artist\n$album"
    '';

in {
  home.packages =
    with pkgs; [
      signal-desktop
      bridge-utils
      dmg2img
      nixops
      bind
      lzo
      btrbk
      discord
      smartmontools
      pulseeffects
      openssl
      imagemagick
      w3m
      psmisc
      mpc_cli
      feh
      pywal
      mosh
      screen
      irssi
      xclip
      ncpamixer
      vlc mpv
      pavucontrol
      pass
      kitty alacritty
      neofetch ranger cava
      gnupg
      tor-browser-bundle-bin
      tree
      unzip
      unrar
      libnotify
      nix-prefetch-git
      pciutils usbutils acpi
      file
      youtube-dl
      (ncmpcpp.override {
        visualizerSupport = true;
      })
      (import ./nvim.nix)
      efitools

      # NodeJs
      nodejs nodePackages.node2nix nodePackages.prettier
      nodePackages.javascript-typescript-langserver

      ghc haskellPackages.ghcid cabal-install stack cabal2nix # Haskell
      rustup # Rust
      python35Packages.virtualenv # Python
      go gotools # Golang
      gcc

      symlink-init
      ncmpcpp-notify
    ];

    gtk = {
      enable = true;
      iconTheme = {
        name = "Adwaita";
        package = pkgs.gnome3.adwaita-icon-theme;
      };
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome3.gnome_themes_standard;
      };
      gtk3.extraCss = ''
        .titlebar.default-decoration {
          margin: -200px;
          opacity: 0;
        }
      '';
    };

    xresources.extraConfig =
      builtins.readFile (
          pkgs.fetchFromGitHub {
              owner = "solarized";
              repo = "xresources";
              rev = "025ceddbddf55f2eb4ab40b05889148aab9699fc";
              sha256 = "0lxv37gmh38y9d3l8nbnsm1mskcv10g3i83j0kac0a2qmypv1k9f";
          } + "/Xresources.dark"
      );

    services.compton = {
      opacityRule = [
        "80:WM_CLASS@:s = \"term-float\""
      ];
    };

    services.dunst = import ./dunst.nix;

    nixpkgs.config = {
      packageOverrides = pkgs: {
        steam = pkgs.steam.override {
          extraPkgs = pkgs: with pkgs; [
            gnome3.gtk
            zlib
            dbus
            freetype
            glib
            atk
            cairo
            gdk_pixbuf
            pango
            fontconfig
            xorg.libxcb
          ];
        };
        tor-browser-bundle-bin = pkgs.tor-browser-bundle-bin.override {
          audioSupport = true;
          mediaSupport = true;
          pulseaudioSupport = true;
        };
      };
    };

    xsession.windowManager.i3 = import ./i3.nix;

      home.file.".config/alacritty/alacritty.yml".source = ./files/alacritty.yml;
      home.file.".config/kitty/kitty.conf".source = ./files/kitty.conf;
      home.file.".config/npmrc".source = ./files/npmrc;
      home.file.".local/share/stack/config.yaml".source = ./files/stack-config.yaml;
      home.file.".config/i3status/config".source = ./files/i3status-config;
      home.file.".local/share/ghc/ghci.conf".source = ./files/ghci.conf;
      home.file.".config/gnupg/gpg.conf".source = ./files/gpg.conf;
      home.file.".config/ncmpcpp/config".source = ./files/ncmpcpp-config;
      home.file.".config/ssh/config".source = ./files/ssh-config;

      home.file.".local/share/mozilla/firefox/profiles.ini".source = ./files/firefox/profiles.ini;

      home.file.".local/share/mozilla/firefox/default/user.js".source = ./files/firefox/user.js;
      home.file.".local/share/mozilla/firefox/default/chrome/userChrome.css".source = ./files/firefox/userChrome.css;

      home.file.".local/share/mozilla/firefox/clean/user.js".source = ./files/firefox/user.js;
      home.file.".local/share/mozilla/firefox/clean/chrome/userChrome.css".source = ./files/firefox/userChrome-clean.css;


      programs.command-not-found.enable = true;

      programs.urxvt = {
        enable = true;
        package = rxvt_unicode-with-plugins;
        fonts = [ "xft:Fira Code:pixelsize=12:antialias=true:hint=true" ];
        scroll.bar.enable = false;
      };

      programs.zsh = import ./zsh.nix;

      programs.tmux = {
        enable = true;
        extraConfig = import ./files/tmux.nix;
      };

      programs.git = {
        enable = true;
        userName = "Elias Lawson-Fox";
        userEmail = "me@eliaslfox.com";
        ignores = [ "*~" "*.swp" ];
        signing = {
          signByDefault = true;
          key = "0x8890C126C411ED9B";
        };
        aliases = {
          l = "log --decorate --oneline --graph --first-parent";
          s = "status";
          c = "checkout";
          mb = "checkout -b";
        };
        extraConfig = {
          core = {
            editor = "nvim";
            whitespace = "blank-at-eol,blank-at-eof,space-before-tab";
          };
          help = {
            autocorrect = 1;
          };
          status = {
            showStatus = true;
            submoduleSummary = true;
          };
          push = {
            default = "current";
          };
        };
      };

      programs.htop = {
        enable = true;
        colorScheme = 6;
      };

      programs.zathura.enable = true;


      services.gpg-agent = {
        enable = true;
        enableSshSupport = true;
        defaultCacheTtl = 60;
        maxCacheTtl = 120;
      };

      services.screen-locker = {
        enable = true;
        inactiveInterval = 10;
        lockCmd = "/run/wrappers/bin/physlock";
      };


    systemd.user.startServices = true;
    systemd.user.services.home-symlinks = {
      Unit = {
        Description = "Init symlinks in home folder";
      };
      Service = {
        ExecStart = "${symlink-init}/bin/symlink-init";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
}
