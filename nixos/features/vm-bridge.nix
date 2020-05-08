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
          ExecStart = pkgs.writeScript "vm-bridge-start" ''
            #!${pkgs.bash}/bin/bash
            set -eou pipefail

            ip tuntap add dev tap0 mode tap user elf
            ip link set dev tap0 up
            ip addr add 0.0.0.0 dev tap0

            ip link add br0 type bridge
            ip link set br0 up
            ip link set tap0 master br0
            ip addr add 10.0.0.1/24 dev br0

            iptables -t nat -A POSTROUTING -o wg0 -j MASQUERADE
            iptables -A FORWARD -m cstate --ctstate RELATED,ESTABLISHED -j ACCEPT
            iptables -A FORWARD -i br0 -o wg0 -j ACCEPT
          '';
        };
      };
    };
  };
}
