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
      go-2fa
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
      steam
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

      nodejs nodePackages.node2nix nodePackages.prettier  # NodeJS
      ghc haskellPackages.ghcid cabal-install stack cabal2nix # Haskell
      rustup # Rust
      python35Packages.virtualenv # Python
      go # Golang
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
          separator_color = "frame";
          icon_position = "left";
          word_wrap = "yes";
          max_icon_size = 32;
          format = "<b>%s</b><br />\\n%b";
          markup = "full";
          show_indicators = "no";
          browser = "${pkgs.firefox}/bin/firefox -new-tab";
          dmenu = "${pkgs.dmenu}/bin/dmenu -p dunst";
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
      windowManager.i3 =
        let
          borderColor = "#002b36";
        in
        {
        enable = true;
        config = {
          focus.newWindow = "none";
          fonts = [ "FiraCode 8" ];
          window.hideEdgeBorders = "both";
          keybindings = lib.mkOptionDefault {
            /* Spawn terminals */
            "Mod1+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
            "Mod1+Shift+Return" = "exec ${pkgs.alacritty}/bin/alacritty --class term-float --title term-float";

            /* Commands missing from the default */
            "Mod1+a" = "focus parent";
            "Mod1+e" = "layout toggle split";

            /* Vim Mode */
            "Mod1+c" = "split h";

            "Mod1+h" = "focus left";
            "Mod1+Shift+h" = "move left";

            "Mod1+j" = "focus down";
            "Mod1+Shift+j" = "move down";

            "Mod1+k" = "focus up";
            "Mod1+Shift+k" = "move up";

            "Mod1+l" = "focus right";
            "Mod1+Shift+l" = "move right";

            /* Manage bars */
            "Mod1+m" = "bar mode toggle";
          };
          colors.focused = {
			background = "#285577";
			border = "#4c7899";
			childBorder = borderColor;
			indicator = "#2e9ef4";
			text = "#ffffff";
		  };
          colors.unfocused = {
            background = "#222222";
            border = "#333333";
            childBorder = borderColor;
            indicator = "#292d2e";
            text = "#888888";
          };
		  colors.focusedInactive = {
			background = "#5f676a";
			border = "#333333";
			childBorder = borderColor;
			indicator = "#484e50";
			text = "#ffffff";
		  };
		  colors.placeholder = {
			background = "#0c0c0c";
			border = "#000000";
			childBorder = borderColor;
			indicator = "#000000";
			text = "#ffffff";
          };
          bars = [
            {
              trayOutput = "none";
            }
          ];
		};
        extraConfig = ''
          default_border none

          for_window [class="term-float"] border pixel 20, floating enable
          for_window [title="term-float"] border pixel 20, floating enable
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

          function venv() {
            . ~/Documents/software/$1/venv/bin/activate
          }
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
          mixer = "ncpamixer";
          music = "ncmpcpp";
          open = "xdg-open";
          pbcopy = "xclip -selection clipboard";
          pbpaste = "xclip -selection clipboard -o";
          pubkey = "cat ~/.ssh/id_rsa.pub | xclip -selection clipboard";
          cp = "cp -i";
          mv = "mv -i";
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
