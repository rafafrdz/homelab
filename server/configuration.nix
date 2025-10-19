# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, systemStateVersion ? "25.05", ... }:

{
  ##############################################################################
  # Imports
  ##############################################################################
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  ##############################################################################
  # This configuration is the same as home/common/base but it is required because of the first nix instalation

  nix = {
    package = pkgs.nixFlakes;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  nixpkgs.config.allowUnfree = true;

  # Boot básico
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  services.getty.autologinUser = primaryUser;

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "nomodeset" ]; # Solo para server

  # Hostname desde meta
  networking.hostName = meta.hostname;

  # SSH
  services.openssh.enable = true;

  # Tailscale
  services.tailscale.enable = true;

  # Docker si lo necesitas
  virtualisation.docker.enable = true;

  ##############################################################################
  # Fonts
  ##############################################################################
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    # nerd-fonts.meslo-lg  # Alternativa si prefieres Meslo
  ];

  # Variables de entorno útiles para compilar con OpenSSL / Python
  environment.variables = {
    OPENSSL_LIB_DIR     = "${pkgs.openssl.out}/lib";
    OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
    PKG_CONFIG_PATH     = "${pkgs.openssl.dev}/lib/pkgconfig";
    EDITOR              = "vim";
  };


  ##############################################################################
  # System State
  ##############################################################################
  # Mantén este valor en el de la primera instalación del sistema.
  system.stateVersion = systemStateVersion;
}
