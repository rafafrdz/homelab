# Home Manager configuration for 'server' hostname
# This file imports hostname-specific modules
{ ... }:

{
  ##############################################################################
  # Hostname-Specific Module Imports
  ##############################################################################
  # These modules are only imported for the 'server' hostname
  imports = [
    # Import the common configuration
    ./default.nix

    # Hostname-specific application and tool modules
    ./modules/packages.nix
    ./modules/git.nix
    ./modules/shell.nix
    # ./modules/mise.nix

    # Optional modules (uncomment to enable)
    # ./modules/ghostty.nix
    # ./modules/tmux.nix
  ];
}
