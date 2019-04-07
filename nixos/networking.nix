{ config, pkgs, ... }:

{
  networking = {
    nameservers = ["1.1.1.1" "1.0.0.1"];
    enableIPv6 = false;
    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
      allowPing = false;
      extraCommands = ''
        # Block all outgoing traffic
        iptables -P OUTPUT DROP

	# Allow connections through vpn and local loopback
        iptables -A OUTPUT -o lo -j ACCEPT
        iptables -A OUTPUT -o tun0 -p icmp -j ACCEPT

        # Local Nets
        iptables -A OUTPUT -d 192.168.0.0/16 -j ACCEPT
        iptables -A OUTPUT -d 10.0.0.0/8 -j ACCEPT

        # Name Servers
        iptables -A OUTPUT -d 209.222.18.222 -j ACCEPT
        iptables -A OUTPUT -d 209.222.18.218 -j ACCEPT

        # Allow connecting to the vpn
        iptables -A OUTPUT -p udp -m udp --dport 1197 -j ACCEPT
        iptables -A OUTPUT -o tun0 -j ACCEPT
      '';
    };
    hosts = {
      "127.0.0.1" = ["hoogle.owo"];
    };
  };
}
