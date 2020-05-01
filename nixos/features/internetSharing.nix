{ ... }:

{
  kernel.sysctl = {
    # Enable packet forwarding on these interfaces for internet sharing
    "net.ipv4.conf.enp4s0.forwarding" = 1;
    "net.ipv4.conf.tun0.forwarding" = 1;
  };
  firewall.extraCommands = ''
    # NAT forward enp4s0 to tun0
    iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE
    iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    iptables -A FORWARD -i enp4s0 -o tun0 -j ACCEPT

    # Allow DHCP and DNS requests over ethernet
    iptables -I INPUT -p udp --dport 67 -i enp4s0 -j ACCEPT
    iptables -I INPUT -p udp --dport 53 -i enp4s0 -j ACCEPT
    iptables -I INPUT -p tcp --dport 53 -i enp4s0 -j ACCEPT
  '';
  interfaces."enp4s0".ipv4.addresses = [{
    address = "192.168.100.1";
    prefixLength = 24;
  }];
  services.dhcpd4 = {
    enable = true;
    extraConfig = ''
      option subnet-mask 255.255.255.0;
      option broadcast-address 192.168.100.255;
      option routers 192.168.100.1;
      option domain-name-servers 192.168.100.1;

      subnet 192.168.100.0 netmask 255.255.255.0 {
        range 192.168.100.100 192.168.100.200;
      }
    '';
    interfaces = [ "enp4s0" ];
  };

}
