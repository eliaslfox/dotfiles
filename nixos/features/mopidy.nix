{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.features.mopidy;
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };

in {
  options.features.mopidy = {
    enable = mkEnableOption "the mopidy music daemon";
    credentials = mkOption {
      type = types.submodule {
        options = {
          username = mkOption { type = types.str; };
          password = mkOption { type = types.str; };
          client_id = mkOption { type = types.str; };
          client_secret = mkOption { type = types.str; };
        };
      };
    };
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
        #output = tee name=t t. ! queue ! pulsesink server=127.0.0.1 t. ! queue ! audioresample ! audioconvert ! audio/x-raw,rate=44100,channels=2,format=S16LE ! wavenc ! filesink location=/tmp/mpd.fifo
        #output = tee name=t ! queue ! pulsesink server=127.0.0.1 t. ! queue ! audioresample ! audioconvert ! audio/x-raw,rate=44100,channels=2,format=S16LE ! wavenc ! udpsink port=5555
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
