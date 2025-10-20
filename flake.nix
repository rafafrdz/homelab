{
  description = "NixOS and Home Manager configuration - hostname-driven setup";

  inputs = {
    # Main nixpkgs channel (unstable for latest packages)
    nixpkgs.url = "github:NixOS/nixpkgs/25.05";

    # Home Manager for user environment management
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Extra flakes
    extras.url = "path:./modules/extras/";
  };

  outputs = { self, nixpkgs, home-manager, extras, ... }:
  let
    ################################################################################
    # CENTRAL CONFIGURATION - Define hostname here
    ################################################################################
    # This hostname is the single source of truth for all configurations
    # It will automatically reference: hosts/<hostname>/configuration.nix
    # and hosts/<hostname>/hardware-configuration.nix
    hostname = "server";

    ################################################################################
    # SYSTEM CONFIGURATION
    ################################################################################
    system = "x86_64-linux";

    ################################################################################
    # USER CONFIGURATION
    ################################################################################
    primaryUser = "pepino";
    gitUserName = "Rafael Fernandez";
    gitUserEmail = "github@rafaelfernandez.dev";
    gitHubUser = "rafafrdz";

    ################################################################################
    # VERSION MANAGEMENT
    ################################################################################
    # Keep this value from initial installation - do not change after system setup
    systemStateVersion = "25.05";

    ################################################################################
    # ENVIRONMENT DETECTION
    ################################################################################
    # Automatically detect if running on NixOS or Arch with nix
    # Set to true for NixOS, false for standalone Home Manager on Arch
    isNixOs = true;

    ################################################################################
    # HELPER FUNCTION - Build NixOS configuration dynamically
    ################################################################################
    hostConfPath = builtins.toPath "${./hosts}/${hostname}/configuration.nix";
    homeHostPath = builtins.toPath "${./home}/${hostname}.nix";
    mkNixosConfig = { hostname, system, primaryUser, ... }:
    nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit self primaryUser gitUserName gitUserEmail gitHubUser systemStateVersion isNixOs hostname;
          inputs = { inherit home-manager extras; };
        };

        modules = [
          hostConfPath

          # System flakes
          ./modules/system/shell.nix
          ./modules/system/users.nix
          ./modules/system/networking.nix
          ./modules/system/locale.nix
          ./modules/system/packages.nix
          ./modules/system/k3s.nix

          # Extra modules
          extras.nixosModules.vscodeServer

          # Home Manager integration for NixOS
          home-manager.nixosModules.home-manager
          {
            home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                users.${primaryUser} = import homeHostPath;

                extraSpecialArgs = {
                inherit primaryUser gitUserName gitUserEmail gitHubUser systemStateVersion hostname;
                standalone = false;  # Running on NixOS, not standalone
              };
            };
          }
        ];
      };

    ################################################################################
    # HELPER FUNCTION - Build Home Manager configuration dynamically
    ################################################################################
    mkHomeConfig = { hostname, system, primaryUser, ... }:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};

        modules = [
          homeHostPath
        ];

        extraSpecialArgs = {
          inherit primaryUser gitUserName gitUserEmail gitHubUser systemStateVersion hostname;
          standalone = true;  # Running standalone on Arch with nix
        };
      };

  in
  {
    ################################################################################
    # NIXOS SYSTEM CONFIGURATIONS
    ################################################################################
    nixosConfigurations.${hostname} = mkNixosConfig {
      inherit hostname system primaryUser;
    };

    ################################################################################
    # HOME MANAGER STANDALONE CONFIGURATIONS (for Arch Linux with nix)
    ################################################################################
    homeConfigurations.${hostname}   = mkHomeConfig { inherit hostname system primaryUser; };
    homeConfigurations.${primaryUser} = mkHomeConfig { inherit hostname system primaryUser; };

    ################################################################################
    # FLAKE METADATA
    ################################################################################
    # Provides information about this flake for external tools
    meta = {
      description = "Hostname-driven NixOS and Home Manager configuration";
      version = systemStateVersion;
    };
  };
}
