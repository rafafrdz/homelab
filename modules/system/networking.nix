# Networking configuration
# Firewall rules and network services
{ hostname, ... }:

{
  ##############################################################################
  # Network Manager
  ##############################################################################
  networking.networkmanager.enable = true;

  ##############################################################################
  # Firewall Configuration
  ##############################################################################
    # Hostname
  networking.hostName = hostname;
  networking.firewall = {
    enable = true;

    # TCP ports to allow
    allowedTCPPorts = [
      22              # SSH
      80              # HTTP
      443             # HTTPS
      6443            # Kubernetes API (k3s)
      10250           # Kubelet metrics
      2379 2380       # etcd
    ];

    # UDP ports to allow
    allowedUDPPorts = [
      8472            # Flannel VXLAN (k3s)
    ];

    # Kubernetes NodePort range
    allowedTCPPortRanges = [
      { from = 30000; to = 32767; }
    ];
  };

  ##############################################################################
  # SSH Service
  ##############################################################################
    # Tailscale
  services.tailscale.enable = true;

  # Docker si lo necesitas
  virtualisation.docker.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
    };
  };
}
