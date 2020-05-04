{ config, lib, pkgs, ... }:

#
# This file is not currently used. It is left for reference.
#

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.features.vpn;
in {
  options.features.vpn = {
    enable = mkEnableOption "config for vpn";
    credentials = mkOption {
      type = types.submodule {
        options = {
          username = mkOption { type = types.str; };
          password = mkOption { type = types.str; };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.extraCommands = ''
      # Setup
      PATH="$PATH:${pkgs.iptables-nftables-compat}/bin"

      # Block all outgoing traffic
      iptables -P OUTPUT DROP

      # Allow connections through vpn and local loopback
      iptables -A OUTPUT -o lo -j ACCEPT
      iptables -A OUTPUT -o tun0 -p icmp -j ACCEPT

      # Local Nets
      iptables -A OUTPUT -d 192.168.0.0/16 -j ACCEPT
      iptables -A OUTPUT -d 10.0.0.0/8 -j ACCEPT

      # Name Servers for Bootstrapping
      iptables -A OUTPUT -d 8.8.8.8 -j ACCEPT
      iptables -A OUTPUT -d 8.8.4.4 -j ACCEPT

      # Allow connecting to the vpn
      iptables -A OUTPUT -p udp -m udp --dport 1197 -j ACCEPT
      iptables -A OUTPUT -o tun0 -j ACCEPT

      # Block arp requests other than those from routers
      arptables -F
      arptables -P INPUT DROP
      arptables -A INPUT -s 192.168.42.1 -j ACCEPT
      arptables -A INPUT -s 192.168.1.254 -j ACCEPT
      arptables -A INPUT -s 10.0.1.1 -j ACCEPT

      # Allow all arp requests over ethernet for internet sharing
      arptables -A INPUT -i enp4s0 -j ACCEPT
    '';

    systemd.services = {
      openvpn-reconnect = {
        description = "Restart OpenVPN after suspend";
        script = "${pkgs.procps}/bin/pkill --signal SIGHUP --exact openvpn";
        wantedBy = [ "sleep.target" ];
      };
    };

    services.openvpn.servers = {
      pia = {
        config = ''
          config /home/elf/Documents/dotfiles/vpn/US\ Silicon\ Valley.ovpn

          auth-nocache
          user nobody
          group nogroup
          script-security 2

          pull-filter ignore "dhcp-option DNS"
          dhcp-option DNS 127.0.0.1
        '';
        autoStart = true;
        updateResolvConf = true;
        authUserPass = {
          username = cfg.credentials.username;
          password = cfg.credentials.password;
        };
      };
    };
  };
}
