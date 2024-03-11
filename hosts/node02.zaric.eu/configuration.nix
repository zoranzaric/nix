{ pkgs, ... }:
let
  stateVersion = "23.11";
  hostName = "node02";
  externalInterface = "enp1s0";
  containersHostAddress = "192.168.100.10";
in
{
  imports = [
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
    firewall = {
      allowedTCPPorts = [
        # caddy
        80
        443

        # k3s
        # 6443 # required so that pods can reach the API server (running on port 6443 by default)
        # 2379 # etcd clients: required if using a "High Availability Embedded etcd" configuration
        # 2380 # etcd peers: required if using a "High Availability Embedded etcd" configuration

        # postgres
        5432
        5433
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

    k3s = {
      enable = false;
      role = "server";
      extraFlags = toString [
        "--kubelet-arg=v=4" # Optionally add additional args to k3s
      ];
    };
  };
  environment.systemPackages = with pkgs; [
    htop

    postgresql
  ];

  containers = {
    pg14 = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = containersHostAddress;
      localAddress = "192.168.100.11";
      forwardPorts = [
        {
          containerPort = 5432;
          hostPort = 5432;
          protocol = "tcp";
        }
      ];
      config = { config, pkgs, ... }: {
        services.postgresql = {
          enable = true;
          enableTCPIP = true;
          package = pkgs.postgresql_14;
        };

        system.stateVersion = stateVersion;

        networking = {
          firewall = {
            enable = true;
            allowedTCPPorts = [ 5432 ];
          };
          # Use systemd-resolved inside the container
          # useHostResolvConf = mkForce false;
        };

        # services.resolved.enable = true;
      };
    };
    pg15 = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = containersHostAddress;
      localAddress = "192.168.100.12";
      forwardPorts = [
        {
          containerPort = 5432;
          hostPort = 5433;
          protocol = "tcp";
        }
      ];
      config = { config, pkgs, ... }: {
        services.postgresql = {
          enable = true;
          enableTCPIP = true;
          package = pkgs.postgresql_15;
        };

        system.stateVersion = stateVersion;

        networking = {
          firewall = {
            enable = true;
            allowedTCPPorts = [ 5432 ];
          };
          # Use systemd-resolved inside the container
          # useHostResolvConf = mkForce false;
        };

        # services.resolved.enable = true;
      };
    };
  };
}
