{
  mkPeers = { nixpkgs, host, ... }:
    nixpkgs.lib.attrsToList (nixpkgs.lib.attrsets.filterAttrs (n: v: n != host) {
      node01 = {
        publicKey = "ZuinYrBpC6FQmDYHZOY3T74MJpK7GZ/Ni7sDF5RaPUg=";
        allowedIPs = [ "192.168.27.1/32" ];
        endpoint = "node01.zaric.eu:51820"; # TODO: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577
        persistentKeepalive = 25;
      };
      node02 = {
        publicKey = "khcUD/S0HTpxKwqEQ881pBO5jhlNH2Oxr0XsuLVWj3E=";
        allowedIPs = [ "192.168.27.10/32" ];
        endpoint = "node02.zaric.eu:51820"; # TODO: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577
        persistentKeepalive = 25;
      };
      nas01 = {
        publicKey = "IXOwdtBGYOEUadX+tJjdoMVF7j+UZjo0M63IASynyRc=";
        allowedIPs = [ "192.168.27.113/32" ];
        persistentKeepalive = 25;
      };
    });
}
