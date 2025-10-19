# home/modules/dotfiles.nix  (Home Manager)
{ config, lib, primaryUser ? null, ... }:
{
  # Si tienes los archivos en tu repo (dentro del flake)
  # y quieres enlazarlos al home:
  home.file.".config/nix" = {
    source = ./dotfiles.nix;   # <— ruta en tu repo; usa recursive si es carpeta
    recursive = true;
  };

  # Si quieres enlazar a una ruta cualquiera FUERA del nix store
  # (por ejemplo a otro repo en ~/dotfiles):
  # home.file.".config/nix".source = config.lib.file.mkOutOfStoreSymlink "/home/${primaryUser}/dotfiles/nix";
}
