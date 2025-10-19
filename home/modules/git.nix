# Git configuration
# Version control settings, signing, and global gitignore
{ primaryUser
, gitUserName
, gitUserEmail
, gitHubUser ? primaryUser
, pkgs
, ...
}:

{
  ##############################################################################
  # Git Configuration
  ##############################################################################
  programs.git = {
    enable = true;
    lfs.enable = true;

    # User identity
    userName = gitUserName;
    userEmail = gitUserEmail;

    ##########################################################################
    # Delta - Enhanced diff viewer
    ##########################################################################
    delta = {
      enable = true;
      options = {
        navigate = true;        # Enable navigation shortcuts in diffs
        line-numbers = true;    # Show line numbers
        hyperlinks = true;      # Make file paths clickable
      };
    };

    ##########################################################################
    # Global gitignore patterns
    ##########################################################################
    ignores = [
      "**/.DS_Store"          # macOS
      ".env"                  # Environment files
      ".env.local"
      ".envrc"                # direnv
      "node_modules/"         # Node.js
      ".idea/"                # IDE
      ".direnv/"              # direnv cache
      "target/"               # Rust/Java build
      "dist/"                 # Build output
      ".vscode/"              # VSCode settings
      "*.swp"                 # Vim swap files
      "*.swo"
      ".DS_Store"
    ];

    ##########################################################################
    # Extended Git Configuration
    ##########################################################################
    extraConfig = {
      # GitHub profile
      github.user = gitHubUser;

      # Default branch name
      init.defaultBranch = "main";

      ##################################################################
      # Core Settings
      ##################################################################
      core.autocrlf = "input";          # Normalize CRLF to LF on commit
      core.fileMode = true;             # Respect executable permissions
      core.pager = "less -R";           # Better pager for colored output

      ##################################################################
      # Fetch and Push Behavior
      ##################################################################
      fetch.prune = true;               # Remove deleted remote branches
      push.autoSetupRemote = true;      # Auto-create upstream on push

      ##################################################################
      # Merge and Rebase Strategy
      ##################################################################
      pull.ff = "only";                 # Only fast-forward on pull
      merge.ff = "only";                # Prefer fast-forward merges
      merge.conflictStyle = "zdiff3";   # Better conflict markers
      rebase.autoStash = true;          # Auto-stash before rebase
      rerere.enable = true;             # Remember conflict resolutions

      ##################################################################
      # User Experience
      ##################################################################
      help.autocorrect = "prompt";      # Suggest corrections for typos
      diff.colorMoved = "default";      # Highlight moved lines
      tag.sort = "version:refname";     # Natural sorting for version tags

      ##################################################################
      # Commit Signing with SSH (recommended for simplicity)
      ##################################################################
      gpg.format = "ssh";
      user.signingkey = "~/.ssh/id_ed25519.pub";
      commit.gpgSign = true;

      ##################################################################
      # Alternative: GPG signing (uncomment to use instead of SSH)
      ##################################################################
      # gpg.format = "openpgp";
      # user.signingkey = "XXXXXXXXXXXXXXXX";  # GPG key ID or keygrip
      # commit.gpgSign = true;
    };
  };

  ##############################################################################
  # Global gitattributes
  ##############################################################################
  home.file.".gitattributes".text = ''
    # Auto-detect text files and normalize line endings to LF
    * text=auto eol=lf

    # Binary files
    *.png  binary
    *.jpg  binary
    *.jpeg binary
    *.gif  binary
    *.pdf  binary
    *.zip  binary
    *.jar  binary
    *.wav  binary
    *.mp4  binary
    *.mov  binary
  '';
}
