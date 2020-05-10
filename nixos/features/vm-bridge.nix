{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.features.vm-bridge;
in {
  options.features.vm-bridge = { enable = mkEnableOption "vm bridge"; };

  config = mkIf cfg.enable {
    systemd.services = {
      vm-bridge = {
        description = "Network bridge and interface for vm";
        after = [ "wireguard-wg0.service" ];
        requires = [ "wireguard-wg0.service" ];
        wantedBy = [ "multi-user.target" ];
        restartIfChanged = false;
        path = [ pkgs.iproute pkgs.iptables ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = pkgs.writeScript "vm-bridge-start" ''
            #!${pkgs.bash}/bin/bash
            set -eou pipefail

            ip tuntap add dev tap0 mode tap user elf
            ip link set dev tap0 up
            ip addr add 0.0.0.0 dev tap0

            ip tuntap add dev tap1 mode tap user elf
            ip link set dev tap1 up
            ip addr add 0.0.0.0 dev tap1

            ip link add br0 type bridge
            ip link set br0 up
            ip link set tap0 master br0
            ip link set tap1 master br0
            ip addr add 10.0.0.1/24 dev br0

            iptables -t nat -A POSTROUTING -o wg0 -j MASQUERADE
            iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
            iptables -A FORWARD -i br0 -o wg0 -j ACCEPT
          '';
          ExecStop = pkgs.writeScript "vm-bridge-stop" ''
            #!${pkgs.bash}/bin/bash
            set -eou pipefail

            ip link delete tap0
            ip link delete tap1
            ip link delete br0

            iptables -t nat -D POSTROUTING -o wg0 -j MASQUERADE
            iptables -D FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
            iptables -D FORWARD -i br0 -o wg0 -j ACCEPT
          '';
        };
      };
    };
  };
}
