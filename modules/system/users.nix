# User account configuration
# Defines user properties, groups, and SSH keys
{ pkgs, lib, primaryUser, ... }:

{
  ##############################################################################
  # User Assertions
  ##############################################################################
  assertions = [
    {
      assertion = primaryUser != "";
      message = "primaryUser cannot be empty";
    }
  ];

  ##############################################################################
  # Primary User Configuration
  ##############################################################################
  users.users.${primaryUser} = {
    isNormalUser = true;

    # User groups for permissions
    extraGroups = [
      "wheel"           # Sudo access
      "networkmanager"  # Network management
      "docker"          # Docker access
    ];

    # Default shell
    shell = pkgs.zsh;

    # SSH authorized keys (add your public keys here)
    openssh.authorizedKeys.keys = [
      # Example: "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... user@host"
    ];

    # Password options (choose one):
    # Option 1: Set initial password in plaintext (development only)
    # initialPassword = "change-me";

    # Option 2: Load password from file (more secure)
    # passwordFile = "/etc/secret-password-${primaryUser}";
  };

  ##############################################################################
  # System-wide Shell Configuration
  ##############################################################################
  users.defaultUserShell = pkgs.zsh;
  users.users.root.shell = pkgs.zsh;

  environment.shells = with pkgs; [ zsh ];
}
