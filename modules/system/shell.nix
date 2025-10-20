{ pkgs, primaryUser, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestions.enable     = true;
    syntaxHighlighting.enable  = true;

    ohMyZsh = {
      enable  = true;
      # theme   = "agnoster"; # Cambia por tu favorito si quieres
      plugins = [ "git" "docker" "kubectl" "sudo" ];
    };
  };
  environment.shells = [ pkgs.zsh ];
}
