{ config, pkgs, ... }:
let
  scripts = pkgs.callPackage (import ./scripts.nix) {};
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  xdg = {
    enable = true;
    configFile = {
      "alacritty/alacritty.yml".source = ./files/alacritty.yml;
      "npm/npmrc".source = ./files/npmrc;
      "i3status/config".source = ./files/i3status-config;
      "gnupg/gpg.conf".source = ./files/gpg.conf;
      "gnupg/gpg-agent.conf".text = config.home-manager.users.elf.home.file.".gnupg/gpg-agent.conf".text; /* write the config file to the XDG config directory */
      "ncmpcpp/config".source = ./files/ncmpcpp-config;
      "ncmpcpp/config-viz".source = ./files/ncmpcpp-viz-config;
      "ssh/config".source = ./files/ssh-config;
      "readline/inputrc".source = ./files/inputrc;
      "kitty/kitty.conf".source = ./files/kitty.conf;
    };
    dataFile = {
      "stack/config.yaml".source = ./files/stack-config.yaml;
      "ghc/ghci.conf".source = ./files/ghci.conf;

      /* Firefox */
      "mozilla/firefox/profiles.ini".source = ./files/firefox/profiles.ini;
      "mozilla/firefox/default/user.js".source = ./files/firefox/user.js;
      "mozilla/firefox/default/chrome/userChrome.css".source = ./files/firefox/userChrome.css; "mozilla/firefox/clean/user.js".source = ./files/firefox/user.js;
      "mozilla/firefox/clean/chrome/userChrome.css".source = ./files/firefox/userChrome-clean.css;
    };
  };


  /* xresources.extraConfig = builtins.readFile ./files/Xresources; */

  home.packages =
    with pkgs; [
      yubikey-manager
      slic3r
      slack
      httpie
      pavucontrol
      arduino
      openscad
      chromium
      ripgrep
      aircrackng wireshark-qt
      steam
      ripgrep
      mitscheme
      whois
      ncat
      powertop
      transmission-gtk
      unstable.firefox
      bridge-utils
      /* dmg2img */
      nixops
      bind
      lzo
      btrbk
      unstable.discord
      smartmontools
      pulseeffects
      imagemagick
      psmisc
      mpc_cli
      feh
      pywal
      mosh
      screen
      irssi
      xclip
      ncpamixer
      vlc
      mpv
      pavucontrol
      pass
      alacritty
      neofetch cava
      gnupg
      unstable.tor-browser-bundle-bin
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
      (callPackage (import ./nvim.nix) {})
      (callPackage (import ./emacs.nix) {})
      efitools efibootmgr

      # NodeJs
      nodejs nodePackages.node2nix nodePackages.prettier
      nodePackages.javascript-typescript-langserver

      ghc haskellPackages.ghcid cabal-install stack cabal2nix # Haskell
      rustup # Rust
      python35Packages.virtualenv # Python
      go gotools # Golang
      gcc

      scripts.symlink-init
      scripts.ncmpcpp-notify
      scripts.mopidy-audio-pipe
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

    services.picom = {
      opacityRule = [
        "80:WM_CLASS@:s = \"term-float\""
      ];
    };

    services.dunst = import ./dunst.nix;


    xsession.windowManager.i3 = import ./i3.nix;

    programs.urxvt = {
      enable = true;
      fonts = [ "xft:FiraCodeLight:autohint=true" ];
      keybindings = {
        "Shift-Control-C" = "eval:selection_to_clipboard";
        "Shift-Control-V" = "eval:paste_clipboard";
      };
      scroll = {
        bar.enable = false;
      };
    };

    programs.command-not-found.enable = true;

    programs.rofi = {
      enable = true;
      terminal = "${pkgs.kitty}/bin/kitty";
      extraConfig = ''
        modi: drun,window,ssh
      '';
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
        key = "0x2E9DA81892721D77";
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
      hideThreads = true;
      hideUserlandThreads = true;
      meters = {
        left = [ "AllCPUs" "Memory" "Swap" ];
        right = [ "Tasks" "LoadAverage" "Uptime" "Hostname" ];
      };
      updateProcessNames = true;
    };

    programs.zathura.enable = true;


    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      defaultCacheTtl = 60;
      maxCacheTtl = 120;
    };


    systemd.user.startServices = true;
    systemd.user.services.home-symlinks = {
      Unit = {
        Description = "Init symlinks in home folder";
      };
      Service = {
        ExecStart = "${scripts.symlink-init}/bin/symlink-init";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
    systemd.user.services.mopidy-audio-pipe = {
      Unit = {
        Description = "Pipe audio for ncmpcpp vizualizer";
      };
      Service = {
        ExecStart = "${scripts.mopidy-audio-pipe}/bin/mopidy-audio-pipe";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };

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
}
