{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkMerge;

  cfg = config.features.mopidy;

  credentials = import ../credentials.nix { };
in
{
  options.features.mopidy = {
    enable = mkEnableOption "the mopidy music daemon";
  };
  config = mkIf cfg.enable (
    let
      wgConfig = mkIf config.features.wireguard.enable {
        systemd.services.mopidy = {
          after = [ "wireguard-wg0.service" ];
          requires = [ "wireguard-wg0.service" ];
        };
      };
    in
    mkMerge [
      {
        services.mopidy = {
          enable = true;
          extensionPackages = [ pkgs.mopidy-mpd pkgs.mopidy-spotify ];
          configuration = ''
            [audio]
            output = pulsesink server=127.0.0.1

            [spotify]
            username = ${credentials.spotify.username}
            password = ${credentials.spotify.password}
            client_id = ${credentials.spotify.client_id}
            client_secret = ${credentials.spotify.client_secret}
            bitrate = 320
            volume_normalization = false

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
      }
      wgConfig
    ]
  );
}
