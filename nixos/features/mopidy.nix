{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.features.mopidy;
  unstable = import <nixos-unstable> { };

in {
  options.features.mopidy = {
    enable = mkEnableOption "the mopidy music daemon";
  };
  config = mkIf cfg.enable {
    nixpkgs.config = {
      packageOverrides = pkgs: { mopidy = unstable.mopidy; };
    };
    services.mopidy = {
      enable = true;
      extensionPackages = [ unstable.mopidy-mpd ];
      configuration = ''
        [audio]
        output = pulsesink server=127.0.0.1

        [file]
        enabled = true
        media_dirs = /run/media/elf/stuff/music|Music
        show_dotfiles = false
        excluded_file_extensions =
          .jpg
          .jpeg
          .txt
          .url
          .png
          .log
          .cue
          .CUE
          .m3u
          .ini
          .bmp
          .pdf
          .zip
        follow_symlinks = false
        metadata_timeout = 1000

        [mpd]
        enabled = true
        hostname = 127.0.0.1
        port = 6600
        password =
        max_connections = 20
        connection_timeout = 60
        zeroconf =

        [http]
        enabled = false
      '';
    };

    hardware.pulseaudio.tcp = {
      enable = true;
      anonymousClients.allowedIpRanges = [ "127.0.0.1" ];
    };
  };
}
