{ pkgs, ... }:
{
  networking = {
    firewall = {
      allowedTCPPorts = [
        # caddy
        80
        443
      ];
    };
  };

  services = {
    caddy = {
      # https://nixos.wiki/wiki/Caddy
      enable = true;
      virtualHosts = {
        "node02.zaric.eu" = {
          extraConfig = ''
            respond "Hello, world!"
          '';
        };
        "kay.zaric.eu" = {
          extraConfig = ''
            reverse_proxy 192.168.27.113:80
          '';
        };
      };
    };
  };
}
