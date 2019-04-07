{ pkgs, ... }:

let 
  credentials = import ./credentials.nix;
in
{
  services = {
    hoogle = {
      enable = true;
      port = 1248;
      packages = hp: with hp; 
     	 [ base 
           text
           lens
           split
           optparse-generic
      	 ];
    };
    nginx = {
      enable = true;
      statusPage = true;
      virtualHosts = {
        "localhost" = {
          default = true;
          locations."/" = {
            root = "/data/nginx/root";
          };
        };
        "hoogle.owo" = {
           locations."/" = {
             proxyPass = "http://localhost:1248";
           };
        };
      };
    };
    openvpn.servers = {
      pia = {
        config = ''
          cd /home/elf/Documents/vpn
	  auth-nocache
	  config US\ Silicon\ Valley.ovpn
	'';
	autoStart = true;
	authUserPass = {
          username = credentials.vpn.username;
	  password = credentials.vpn.password;
	};
      };
    };
  };
}
