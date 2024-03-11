{ pkgs, ... }:
{
  networking = {
    firewall = {
      allowedTCPPorts = [
        # k3s
        # 6443 # required so that pods can reach the API server (running on port 6443 by default)
        # 2379 # etcd clients: required if using a "High Availability Embedded etcd" configuration
        # 2380 # etcd peers: required if using a "High Availability Embedded etcd" configuration
      ];
    };
  };

  services = {
    k3s = {
      enable = false;
      role = "server";
      extraFlags = toString [
        "--kubelet-arg=v=4" # Optionally add additional args to k3s
      ];
    };
  };
}
