# Kubernetes (k3s) lightweight cluster configuration
# Dynamically configured based on hostname and node role
{ config, lib, pkgs, hostname, ... }:

let
  ##############################################################################
  # Node Configuration - Define per hostname
  ##############################################################################
  # Map hostnames to their k3s roles and settings
  nodeConfig = {
    # Primary server node - initializes the cluster
    server = {
      role = "server";
      isPrimary = true;
      serverURL = null;  # Primary node doesn't need to join
      nodeName  = "k3s-server-${hostname}-0";
      description = "Primary k3s server node";
    };

    # Secondary server node - joins the primary cluster
    server-secondary = {
      role = "server";
      isPrimary = false;
      serverURL = "https://${hostname}:6443";
      nodeName  = "k3s-server-${hostname}-1";
      description = "Secondary k3s server node";
    };

    # Agent node - worker node only
    agent = {
      role = "agent";
      isPrimary = false;
      serverURL = "https://${hostname}:6443";
      nodeName  = "k3s-agent-${hostname}-0";
      description = "k3s worker agent node";
    };
  };

  # Get configuration for current hostname, default to server if not found
  currentNode = nodeConfig.${hostname} or nodeConfig.server;

  ##############################################################################
  # Common k3s flags for all nodes
  ##############################################################################
  commonFlags = [
    "--write-kubeconfig-mode 0644"  # Make kubeconfig readable by non-root
    "--disable servicelb"           # Disable built-in load balancer (use external)
    "--disable traefik"             # Disable built-in ingress (use external)
    "--disable local-storage"       # Disable local storage provisioner
  ];

  ##############################################################################
  # Role-specific flags
  ##############################################################################
  roleSpecificFlags =
    if (currentNode.role == "server" && currentNode.isPrimary) then
      [ "--cluster-init" ]
    else
      [ ];


  ##############################################################################
  # Join flags for secondary nodes
  ##############################################################################
  joinFlags =
    if currentNode.isPrimary || currentNode.serverURL == null then
      [ ]
    else
      [ "--server ${currentNode.serverURL}" ];

in
{
  ##############################################################################
  # k3s Service Configuration
  ##############################################################################
  services.k3s = {
    enable = true;
    role = currentNode.role;

    # Token file for cluster authentication
    tokenFile = "/var/lib/rancher/k3s/server/token";

    # Initialize cluster on primary node only
    clusterInit = currentNode.isPrimary;

    ##########################################################################
    # Combine all flags
    ##########################################################################
    extraFlags = commonFlags ++ roleSpecificFlags ++ joinFlags
      ++ lib.optionals (currentNode.nodeName != null) [ "--node-name ${currentNode.nodeName}" ];
  };

  ##############################################################################
  # iSCSI Configuration (for Longhorn storage backend)
  ##############################################################################
  services.openiscsi = {
    enable = true;
    name = "iqn.2016-04.com.open-iscsi:${currentNode.nodeName}";
  };

  ##############################################################################
  # Systemd Tmpfiles Rules
  ##############################################################################
  # Create symlink for Longhorn compatibility
  systemd.tmpfiles.rules = [
    "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
  ];

  ##############################################################################
  # Environment Variables for k3s
  ##############################################################################
  environment.variables = {
    K3S_NODE_NAME = currentNode.nodeName;
    K3S_KUBECONFIG_MODE = "0644";
  };

  ##############################################################################
  # Logging and Monitoring
  ##############################################################################
  # Optional: Enable k3s logging for debugging
  systemd.services.k3s = {
    serviceConfig = {
      StandardOutput = "journal";
      StandardError = "journal";
    };
  };
}
