{ pkgs, ... }:
let
  stateVersion = "23.11";
  containersHostAddress = "192.168.100.10";
in
{
  networking = {
    firewall = {
      allowedTCPPorts = [
        # postgres
        5432
        5433
      ];
    };
  };

  environment.systemPackages = with pkgs; [
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
