{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.features.mopidy;
in
{
  options.features.mopidy = {
    enable = mkEnableOption "the mopidy music daemon";
    credentials = mkOption {
      type = types.submodule {
        options = {
          username = mkOption {
            type = types.str;
          };
          password = mkOption {
            type = types.str;
          };
          client_id = mkOption {
            type = types.str;
          };
          client_secret = mkOption {
            type = types.str;
          };
        };
      };
    };
  };
  config = mkIf cfg.enable {
    services.mopidy = {
      enable = true;
      extensionPackages = [ pkgs.mopidy-spotify ];
      configuration = ''
        [spotify]
        bitrate = 320
        volume_normalization = false
        username = ${cfg.credentials.username}
        password = ${cfg.credentials.password}
        client_id = ${cfg.credentials.client_id}
        client_secret = ${cfg.credentials.client_secret}

        [audio]
        #output = tee name=t t. ! queue ! pulsesink server=127.0.0.1 t. ! queue ! audioresample ! audioconvert ! audio/x-raw,rate=44100,channels=2,format=S16LE ! wavenc ! filesink location=/tmp/mpd.fifo
        output = pulsesink server=127.0.0.1
      '';
    };

    hardware.pulseaudio.tcp = {
      enable = true;
      anonymousClients.allowedIpRanges = [ "127.0.0.1" ];
    };
  };
}
