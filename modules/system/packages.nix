{ pkgs, ... }:
{
  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    # ── Editores / Desarrollo ──────────────────────────────────────────────────
    meld
    neovim
    vim

    # ── Control de versiones / Git tooling ─────────────────────────────────────
    delta            # diffs bonitos en terminal
    gh               # GitHub CLI
    git
    git-absorb
    git-branchless
    lazygit

    # ── Contenedores ───────────────────────────────────────────────────────────
    docker
    lazydocker

    # ── Toolchain / Build ──────────────────────────────────────────────────────
    gcc
    lldb
    pkg-config
    protobuf
    gnupg1
    rustc
    cargo
    rustup
    rust-analyzer
    unzip
    zip

    # ── Nix tooling / Formato ─────────────────────────────────────────────────
    nil
    nixfmt-rfc-style

    # ── Kubernetes ────────────────────────────────────────────────────────────
    k3s
    k9s
    kubectl
    (wrapHelm kubernetes-helm {
      plugins = with kubernetes-helmPlugins; [
        helm-diff
        helm-git
        helm-s3
        helm-secrets
      ];
    })

    # ── Redes / Sistema ───────────────────────────────────────────────────────
    curl
    tailscale
    wget

    # ── CLI moderna / Productividad ───────────────────────────────────────────
    bat
    btop
    dua             # 'dua-cli' (análisis de disco rápido)
    eza
    fd
    fzf
    htop
    httpie
    nitch           # info del sistema
    ripgrep
    tmux
    tree
    xh
    zoxide

    # ── Gestores de runtimes ──────────────────────────────────────────────────
    mise

    # ── Multimedia / Miscelánea ───────────────────────────────────────────────
    ffmpeg
    ollama
    yt-dlp

    # ── SSL / CA ──────────────────────────────────────────────────────────────
    cacert
    openssl
  ];
}
