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

    ${pkgs.coreutils}/bin/mkdir -vp /home/elf/.config/ssh
    ${pkgs.coreutils}/bin/ln -sfvT /home/elf/.config/ssh /home/elf/.ssh

    ${pkgs.coreutils}/bin/ln -sfvT /home/elf/.config/npmrc /home/elf/.npmrc

  '';

in lib.recursiveUpdate (import ./newsboat.nix { pkgs = pkgs; config = config;}) ({
  home.packages =
    with pkgs; [
      steam
      vlc mpv
      firefox
      spotify
      pavucontrol
      pass
      alacritty kitty
      neofetch ranger cava
      gnupg
      tor-browser-bundle-bin
      tree
      unzip
      unrar
      libnotify
      nix-prefetch-git
      pciutils usbutils acpi
      ncmpcpp
      (import ./nvim.nix)

      nodejs nodePackages.node2nix nodePackages.prettier  # NodeJS
      ghc haskellPackages.ghcid cabal-install stack cabal2nix # Haskell
      rustup # Rust
      python35Packages.virtualenv # Python
      gcc

      symlink-init
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

    xdg = {
      enable = true;
      configFile = {
        "nixpkgs/config.nix".source = ./nixpkgs.nix;
      };
    };

    services.compton = {
      opacityRule = [
        "80:I3_FLOATING_WINDOW@:c && WM_CLASS@:s = \"kitty-float\""
      ];
    };
    services.polybar = {
      config = {
        "bar/top" = {
          width = "100%";
          height = "2.5%";
          radius = 0;
          modules-center = "mpd";
        };
       "module/mpd" = {
         type = "internal/mpd";
         host = "127.0.0.1";
       };
    };
    script = "polybar top &";
    package = pkgs.polybar.override {
      mpdSupport = true;
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
      windowManager.i3 = {
        enable = true;
        config = {
          focus.newWindow = "none";
          fonts = [ "FiraCode 8" ];
          window.hideEdgeBorders = "both";
          keybindings = lib.mkOptionDefault {
            "Mod1+Return" = "exec ${pkgs.kitty}/bin/kitty";
            "Mod1+Shift+Return" = "exec ${pkgs.kitty}/bin/kitty --class kitty-float";
            "Mod1+a" = "focus parent";
            "Mod1+m" = "bar mode toggle";
            "Mod1+Shift+space" = "mark toggle f, floating toggle";
          };
          colors.focused = {
			background = "#285577";
			border = "#4c7899";
			childBorder = "#002b36";
			indicator = "#2e9ef4";
			text = "#ffffff";
		  };
		  colors.unfocused = {
			background = "#222222";
			border = "#333333";
			childBorder = "#002b36";
			indicator = "#292d2e";
			text = "#888888";
		  };
		  colors.focusedInactive = {
			background = "#5f676a";
			border = "#333333";
			childBorder = "#002b36";
			indicator = "#484e50";
			text = "#ffffff";
		  };
		  colors.placeholder = {
			background = "#0c0c0c";
			border = "#000000";
			childBorder = "#002b36";
			indicator = "#000000";
			text = "#ffffff";
		  };
		};
        extraConfig = ''
          default_border none

          for_window [class="kitty-float"] border pixel 15, floating enable
        '';
      };
    };

      home.file.".config/alacritty/alacritty.yml".source = ./files/alacritty.yml;
      home.file.".config/kitty/kitty.conf".source = ./files/kitty.conf;
      home.file.".config/npmrc".source = ./files/npmrc;
      home.file.".local/share/stack/config.yaml".source = ./files/stack-config.yaml;
      home.file.".config/i3status/config".source = ./files/i3status-config;
      home.file.".local/share/ghc/ghci.conf".source = ./files/ghci.conf;
      home.file.".config/gnupg/gpg.conf".source = ./files/gpg.conf;


      programs.command-not-found.enable = true;

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

      programs.ssh = {
        enable = true;
        hashKnownHosts = true;
        serverAliveInterval = 300;
        extraOptionOverrides = {
          UseRoaming = "no";
          VisualHostKey = "yes";
          PasswordAuthentication = "no";
          ChallengeResponseAuthentication = "no";
          StrictHostKeyChecking = "ask";
          VerifyHostKeyDNS = "yes";
          ServerAliveCountMax = "2";
          IdentitiesOnly = "yes";
        };
      };

      programs.zathura.enable = true;

      services.unclutter.enable = true;

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
          })
