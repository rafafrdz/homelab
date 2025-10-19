# Shell configuration
# Zsh, fzf, and starship prompt setup
{ ... }:

{
  ##############################################################################
  # Fuzzy Finder (fzf)
  ##############################################################################
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  ##############################################################################
  # Zsh Shell Configuration
  ##############################################################################
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    ##########################################################################
    # Shell Aliases
    ##########################################################################
    shellAliases = {
      # Directory listing
      la = "ls -la";
      ll = "ls -l";

      # Editor shortcuts
      vi = "nvim";
      vim = "nvim";

      # Better cat with syntax highlighting
      cat = "bat -p";

      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";

      # NixOS management
      "nix-switch" = "sudo nixos-rebuild switch --flake ~/.config/nix";
      "nix-update" = "nix flake update ~/.config/nix && nix-switch";
    };

    ##########################################################################
    # Oh My Zsh Configuration
    ##########################################################################
    ohMyZsh = {
      enable = true;
      # theme = "agnoster";  # Uncomment to change theme
      plugins = [
        "git"       # Git shortcuts
        "docker"    # Docker shortcuts
        "kubectl"   # Kubernetes shortcuts
        "sudo"      # Sudo toggle with ESC-ESC
      ];
    };
  };

  ##############################################################################
  # Starship Prompt
  ##############################################################################
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$character ";

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vicmd_symbol = "[❮](bold yellow)";
      };
    };
  };
}
