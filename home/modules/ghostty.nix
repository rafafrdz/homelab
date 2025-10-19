{ pkgs, lib, primaryUser, ... }:
{
  # --- Ghostty configuration ---
  home.file = {
    "/home/${primaryUser}/.config/ghostty/config".text = ''
        theme = Banana Blueberry
        title = " "
        background = #000000
        background-opacity = 0.75
        selection-background= #c82458
        window-decoration = none
        # command = tmux new-session
        # Margen interno en píxeles
        # window-padding-x = 5
        # window-padding-y = 5
    '';
  };
}
