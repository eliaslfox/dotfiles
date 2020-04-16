{ config, pkgs, ... }:
let
  scripts = pkgs.callPackage (import ./scripts.nix) {};
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  xdg = {
    enable = true;
    configFile = {
      "npm/npmrc".source = ./files/npmrc;
      "i3status/config".source = ./files/i3status-config;
      "ncmpcpp/config".source = ./files/ncmpcpp-config;
      "ssh/config".source = ./files/ssh-config;
      "kitty/kitty.conf".source = ./files/kitty.conf;

      "gnupg/gpg-agent.conf".text = config.home-manager.users.elf.home.file.".gnupg/gpg-agent.conf".text;
      "gnupg/gpg.conf".text = config.home-manager.users.elf.home.file.".gnupg/gpg.conf".text;

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

  home.packages =
    with pkgs; [
      zathura
      python38Packages.speedtest-cli
      ascii
      yubikey-manager
      slic3r
      httpie
      pavucontrol
      chromium
      ripgrep
      aircrackng wireshark-qt
      mitscheme
      whois
      ncat
      transmission-gtk
      firefox
      bridge-utils
      nixops
      bind
      lzo
      btrbk
      unstable.discord
      smartmontools
      psmisc
      feh
      xclip
      ncpamixer
      vlc
      mpv
      pass
      neofetch cava
      gnupg
      tor-browser-bundle-bin
      tree
      unzip
      libnotify
      nix-prefetch-git
      pciutils usbutils acpi
      file
      youtube-dl
      ncmpcpp
      (callPackage (import ./nvim.nix) {})
      (callPackage (import ./emacs.nix) {})
      efitools efibootmgr

      # NodeJs
      nodejs nodePackages.prettier
      nodePackages.javascript-typescript-langserver

      ghc haskellPackages.ghcid cabal-install stack cabal2nix # Haskell
      rustup # Rust
      python38Packages.virtualenv # Python
      go gotools # Golang
      gcc

      scripts.symlink-init
      scripts.ncmpcpp-notify
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

    programs.zsh = import ./zsh.nix;

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

    programs.gpg = {
      enable = true;
      settings = {
        default-key = "0x2E9DA81892721D77";
        trusted-key = "0x2E9DA81892721D77";
      };
    };

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
      };
    };
}
