{ pkgs, ... }:
let
  stateVersion = "23.11";
  hostName = "node02";
  externalInterface = "enp1s0";
  containersHostAddress = "192.168.100.10";
in
{
  imports = [
    ./caddy.nix
    ./k3s.nix
    ./postgres.nix
    ./wireguard.nix
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  system.stateVersion = stateVersion;

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = (import ../../lib/ssh-keys.nix).root;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  networking = {
    hostName = hostName;
    domain = "";
    extraHosts =
      ''
        192.168.27.1 node01
        192.168.27.113 nas01
      '';
    nat = {
      enable = true;
      internalInterfaces = [
        "ve-+" # containers
        # "wg0" # wireguard
      ];
      externalInterface = externalInterface;
    };
  };

  environment.systemPackages = with pkgs; [
    htop
  ];
}
