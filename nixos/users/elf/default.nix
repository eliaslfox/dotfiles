{ config, pkgs, ... }:
let scripts = pkgs.callPackage (import ./scripts.nix) { };
in {
  xdg = {
    enable = true;
    configFile = {
      "npm/npmrc".source = ./files/npmrc;
      "ncmpcpp/config".source = ./files/ncmpcpp-config;
      "ssh/config".source = ./files/ssh-config;
      "ripgreprc".source = ./files/ripgreprc;
    };
    dataFile = {
      "stack/config.yaml".source = ./files/stack-config.yaml;
      "ghc/ghci.conf".source = ./files/ghci.conf;
    };
  };

  home.file.".gnupg/gpg-agent.conf".target = ".config/gnupg/gpg-agent.conf";
  home.file.".gnupg/gpg.conf".target = ".config/gnupg/gpg.conf";

  home.file.".mozilla/firefox/profiles.ini".target =
    ".local/share/mozilla/firefox/profiles.ini";
  home.file.".mozilla/firefox/default/user.js".target =
    ".local/share/mozilla/firefox/default/user.js";
  home.file.".mozilla/firefox/default/chrome/userChrome.css".target =
    ".local/share/mozilla/firefox/default/chrome/userChrome.css";
  home.file.".mozilla/firefox/clean/user.js".target =
    ".local/share/mozilla/firefox/clean/user.js";
  home.file.".mozilla/firefox/clean/chrome/userChrome.css".target =
    ".local/share/mozilla/firefox/clean/chrome/userChrome.css";

  home.extraOutputsToInstall = [ "doc" "info" "devdoc" ];

  home.packages = with pkgs; [
    # coreutils 2.0
    exa
    ripgrep
    fd

    pavucontrol
    transmission-gtk
    nixops
    btrbk
    discord
    feh
    vlc
    mpv
    pass
    neofetch
    tor-browser-bundle-bin
    libnotify
    nix-prefetch-git
    youtube-dl
    ncmpcpp

    scripts.ncmpcpp-notify
    scripts.multimc
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

  xsession.windowManager.i3 = import ./i3.nix;

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
        Service = { ExecStart = "${scripts.symlink-init}/bin/symlink-init"; };
        Install = { WantedBy = [ "default.target" ]; };
      };

      set-bg = {
        Unit = { Description = "Set background"; };
        Service = { ExecStart = "${scripts.set-bg}/bin/set-bg"; };
        Install = { WantedBy = [ "graphical-session.target" ]; };
      };

      nixos-vm = {
        Unit = { Description = "Start vm"; };
        Service = { ExecStart = "${scripts.nixos-vm}/bin/nixos-vm"; };
      };
      nixos-vm-graphic = {
        Unit = { Description = "Start vm"; };
        Service = {
          ExecStart = "${scripts.nixos-vm-graphic}/bin/nixos-vm-graphic";
        };
      };
      nixos-vm-iso = {
        Unit = { Description = "Start vm with iso boot"; };
        Service = { ExecStart = "${scripts.nixos-vm-iso}/bin/nixos-vm-iso"; };
      };
    };
  };

  home.stateVersion = "20.03";
}
