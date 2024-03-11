{ pkgs, ... }:
let
  hostName = "node02";
  externalInterface = "enp1s0";
in
{
  networking = {
    firewall = {
      allowedUDPPorts = [
        51820
      ];
    };

    wireguard.interfaces = {
      wg0 = {
        ips = [ "192.168.27.10/24" ];
        listenPort = 51820;
        privateKey = (import ../../secrets.nix).wireguard.wg0."node02.zaric.eu".privateKey;
        # peers = [
        #   {
        #     # node01
        #     publicKey = "ZuinYrBpC6FQmDYHZOY3T74MJpK7GZ/Ni7sDF5RaPUg=";
        #     allowedIPs = [ "192.168.27.1/32" ];
        #     endpoint = "node01.zaric.eu:51820"; # TODO: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577
        #     persistentKeepalive = 25;
        #   }
        #   {
        #     # nas01
        #     publicKey = "IXOwdtBGYOEUadX+tJjdoMVF7j+UZjo0M63IASynyRc=";
        #     allowedIPs = [ "192.168.27.113/32" ];
        #     persistentKeepalive = 25;
        #   }
        # ];
        peers = (import ../../lib/wireguard/wg0/peers.nix).mkPeers {
          nixpkgs = pkgs;
          host = hostName;
        };

        # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
        # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
        # postSetup = ''
        #   ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 192.168.27.0/24 -o ${externalInterface} -j MASQUERADE
        # '';

        # This undoes the above command
        # postShutdown = ''
        #   ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 192.168.27.0/24 -o ${externalInterface} -j MASQUERADE
        # '';
      };
    };
  };
}
