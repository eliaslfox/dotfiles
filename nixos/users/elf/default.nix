with import <nixpkgs> {};
{ config, pkgs }:
let
  symlink-init = pkgs.writeScript "symlink-init" ''
    #!${pkgs.bash}/bin/bash
    set -e -o pipefail

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

    ${pkgs.coreutils}/bin/ln -sfvT /home/elf/.config/npmrc /home/elf/.npmrc
  '';

  horriblesubsd =
    (callPackage "${builtins.fetchGit {
      url = "https://github.com/eliaslfox/horriblesubsd";
      ref = "490a1be19eb3a1d7a7fe04b70c099d41b143bf47";
    }}" {});

in lib.recursiveUpdate (import ./newsboat.nix { pkgs = pkgs; config = config;}) ({
  home.packages =
    with pkgs; [
      dwarf-fortress
      vlc
      transmission-gtk
      firefox
      spotify
      pavucontrol
      pass
      alacritty kitty
      gnupg
      nvtop
      tor-browser-bundle-bin
      steam
      arandr lxappearance
      qemu
      horriblesubsd
      tree
      unzip
      unrar
      wineWowPackages.stable
      libnotify
      (import ./nvim.nix)

      nodejs nodePackages.node2nix nodePackages.prettier  # NodeJS
      ghc haskellPackages.ghcid cabal-install stack cabal2nix # Haskell
      rustup # Rust
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
    };


    services.dunst = {
      enable = true;
      iconTheme = {
        name = "Adwaita";
        package = pkgs.gnome3.adwaita-icon-theme;
      };
      settings = {
        global = {
          font = "FiraCode 9";
          geometry = "300x5-30+30";
          transparency = 20;
          monitor = 0;
          follow = "keyboard";
          sticky_history = "yes";
          line_height = 0;
          seperator_height = 2;
          padding = 10;
          horizontal_padding = 10;
          corner_radius = 10;
          separator_color = "frame";
          icon_position = "left";
          word_wrap = "yes";
          max_icon_size = 32;
          format = "%s:\n%b";
          markup = "full";
        };
        frame = {
          width = 0;
          color = "#000000";
        };
        urgency_low = {
          background = "#333333";
          foreground = "#ffffff";
          timeout = 10;
        };
        urgency_normal = {
          background = "#333333";
          foreground = "#ffffff";
          timeout = 10;
        };
        urgency_critical = {
          background = "#333333";
          foreground = "#ffffff";
          timeout = 10;
        };
      };
    };

    nixpkgs.config = {
      allowUnfree = true;
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


    xsession = {
      enable = true;
      windowManager.i3 = {
        enable = true;
        config = {
          focus.newWindow = "none";
          fonts = [ "FiraCode 8" ];
          window.hideEdgeBorders = "both";
          keybindings =
            let
              cfg = config.home-manager.users.elf.xsession.windowManager.i3.config;
              modifier = cfg.modifier;
            in
            lib.mkOptionDefault {
              "${modifier}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
            };
          };
        };
      };

      home.file.".config/alacritty/alacritty.yml".source = ./files/alacritty.yml;
      home.file.".config/npmrc".source = ./files/npmrc;
      home.file.".local/share/stack/config.yaml".source = ./files/stack-config.yaml;
      home.file.".config/i3status/config".source = ./files/i3status-config;
      home.file.".local/share/ghc/ghci.conf".source = ./files/ghci.conf;
      home.file.".config/gnupg/gpg.conf".source = ./files/gpg.conf;


      programs.chromium = {
        enable = true;
        extensions = [
          "cjpalhdlnbpafiamejdnhcphjbkeiagm" #uBlock Origin
          "pgdnlhfefecpicbbihgmbmffkjpaplco" #uBlock Origin Extra
          "elicpjhcidhpjomhibiffojpinpmmpil" #Video Downloader Professional
          "dbepggeogbaibhgnhhndojpepiihcmeb" #Vimium
          "immpkjjlgappgfkkfieppnmlhakdmaab" #Imagus
          "ommfjecdpepadiafbnidoiggfpbnkfbj" #Privacy Possum
        ];
      };

      programs.zsh = {
        enable = true;
        enableCompletion = true;
        defaultKeymap = "viins";
        dotDir = ".config/zsh";
        sessionVariables = {
          DEFAULT_USER = "elf";
          PASSWORD_STORE_DIR = "$HOME/Documents/password-store";
          GNUPGHOME="$HOME/.config/gnupg";
          EDITOR = "nvim";
        };
        initExtra = ''
          export GPG_TTY="$(tty)"
          export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
        '';
        history = {
          path = ".cache/zsh_history";
        };
        oh-my-zsh = {
          enable = true;
          theme = "agnoster";
          plugins = [];
        };
        shellAliases = {
          movie = "/run/media/elf/stuff/movies/find.sh";
          g = "git";
        };
      };

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

      services.compton.enable = true;
      services.gnome-keyring.enable = true;
      services.unclutter.enable = true;

      services.gpg-agent = {
        enable = true;
        enableSshSupport = true;
      };
      services.screen-locker = {
        inactiveInterval = 5;
        lockCmd = "/run/wrappers/bin/physlock";
      };


      systemd.user.startServices = true;
      systemd.user.services = {
        home-symlinks = {
          Unit = {
            Description = "Init symlinks in home folder";
          };
          Service = {
            ExecStart = symlink-init;
          };
          Install = {
            WantedBy = [ "default.target" ];
          };
        };
        horriblesubsd = {
          Unit = {
            Description = "Download anime from horriblesubs";
            Wants = [ "horriblesubsd.timer" ];
          };
          Service = {
            ExecStart = "${horriblesubsd}/bin/horriblesubsd";
          };
          Install = {
            WantedBy = [ "graphical-session.target" ];
          };
        };
      };
      systemd.user.timers = {
        horriblesubsd = {
          Unit = {
            Description = "Download anime from horriblesubs";
          };
          Timer = {
            OnUnitInactiveSec = "15m";
          };
          Install = {
            WantedBy = [ "timers.target" ];
          };
        };
      };
    })
