{
  description = "Community / extras modules";
  # Inputs
  inputs.vscode-server.url = "github:nix-community/nixos-vscode-server";

  # Outputs
  outputs = { self, vscode-server, ... }: {
    nixosModules = {

      # VS Code Server habilitado
      vscodeServer = { ... }: {
        imports = [ vscode-server.nixosModules.default ];
        services.vscode-server.enable = true;
      };

      # Other here
      # ...

    };
  };
}
