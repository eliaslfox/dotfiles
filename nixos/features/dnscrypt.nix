{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.features.dnscrypt;

  configFile = pkgs.writeText "dnscrypt.toml" ''
    server_names = []

    fallback_resolvers = ['8.8.8.8:53', '8.8.4.4:53']

    ipv4_servers = true
    ipv6_servers = false

    dnscrypt_servers = true
    doh_servers = true

    require_dnssec = true
    require_nolog = true
    require_nofilter = true

    ignore_system_dns = true

    block_ipv6 = true
    block_unqualified = true
    block_undelegated = true
    reject_ttl = 600

    cache = true
    cache_size = 4096
    cache_min_ttl = 2400
    cache_max_ttl = 86400
    cache_neg_min_ttl = 60
    cache_neg_max_ttl = 600

    [local_doh]
    listen_addresses = ['127.0.0.1:3000']
    path = "/dns-query"
    cert_file = "/etc/dnscrypt.pem"
    cert_key_file = "/etc/dnscrypt.pem"

    [sources]
      [sources.'public-resolvers']
      urls = ['https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v2/public-resolvers.md', 'https://download.dnscrypt.info/resolvers-list/v2/public-resolvers.md']
      cache_file = '/tmp/public-resolvers.md'
      minisign_key = 'RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3'
      refresh_delay = 72
  '';

in {
  options.features.dnscrypt = { enable = mkEnableOption "dnscrypt proxy"; };
  config = mkIf cfg.enable {
    services.dnscrypt-proxy2 = {
      enable = true;
      configFile = configFile;
    };

    environment.etc."dnscrypt.pem".source = ../dnscrypt.pem;
  };
}
