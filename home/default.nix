# Home Manager configuration - Common modules
# This file imports only the common modules shared across all hostnames
{ lib
, primaryUser
, systemStateVersion
, standalone ? false
, ...
}:

let
  inherit (lib) mkIf;
in
{
  ##############################################################################
  # Common Module Imports
  ##############################################################################
  # These modules are imported for all hostnames
  imports = [
    ./common/base.nix
    ./common/users.nix
    ./common/locale.nix
    ./common/networking.nix
  ];

  ##############################################################################
  # Home Manager State Version
  ##############################################################################
  # Keep this value from the initial Home Manager setup
  home.stateVersion = systemStateVersion;

  ##############################################################################
  # User Configuration (Standalone Mode)
  ##############################################################################
  # These settings are only applied when running Home Manager standalone on Arch
  home.username = mkIf standalone primaryUser;
  home.homeDirectory = mkIf standalone "/home/${primaryUser}";
  programs.home-manager.enable = mkIf standalone true;

  ##############################################################################
  # Session Variables
  ##############################################################################
  home.sessionVariables = {
    # Add custom environment variables here
    # EXAMPLE_VAR = "value";
  };
}
