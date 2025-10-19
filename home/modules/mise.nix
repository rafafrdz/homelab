# Mise (rtx) - Runtime version manager
# Manages multiple language runtimes and tools
## WARN: EXPERIMENTAL
{ pkgs, lib, ... }:

{
  ##############################################################################
  # Mise Configuration
  ##############################################################################
  programs.mise = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      experimental = true;
      verbose = false;
      auto_install = true;
    };
  };

  ##############################################################################
  # Environment Variables for Development
  ##############################################################################
  home.sessionVariables = {
    # JVM tuning for SBT (Scala Build Tool)
    SBT_OPTS = "-Xms512m -Xmx4g -Xss2m -XX:+UseG1GC -XX:MaxMetaspaceSize=1024m";

    # Java home (set by mise)
    JAVA_HOME = "$(${pkgs.mise}/bin/mise where java)";
  };

  ##############################################################################
  # Mise Initialization Script
  ##############################################################################
  home.activation.setupMise = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # use the virtual environment created by uv
    # ${pkgs.mise}/bin/mise settings set python.uv_venv_auto true
    # Enable Node.js corepack (pnpm, yarn, npm)
    ${pkgs.mise}/bin/mise set MISE_NODE_COREPACK=true

    # Disable warnings about .node-version files
    ${pkgs.mise}/bin/mise settings add idiomatic_version_file_enable_tools "[]"

    # Set global tool versions (auto_install will handle installation)
    # ${pkgs.mise}/bin/mise use --global node@lts
    # ${pkgs.mise}/bin/mise use --global bun@latest
    # ${pkgs.mise}/bin/mise use --global deno@latest
    ${pkgs.mise}/bin/mise use --global uv@latest

    # Scala ecosystem
    ${pkgs.mise}/bin/mise use --global java@corretto-17.0.16.8.1
    # ${pkgs.mise}/bin/mise use --global scala@2.13.15
    # ${pkgs.mise}/bin/mise use --global sbt@latest
    # ${pkgs.mise}/bin/mise use --global maven@latest

    # Rust toolchain
    # ${pkgs.mise}/bin/mise use --global rust@nightly
  '';
}
