# Base Home Manager configuration
# Common settings for all environments
{ config, pkgs, ... }:

{
  ##############################################################################
  # Nix Configuration
  ##############################################################################
  nix = {
    package = pkgs.nixFlakes;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  ##############################################################################
  # Home Directory Structure
  ##############################################################################
  home.file = {
    # Create common directories
    ".config/nix".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix";
  };
}
