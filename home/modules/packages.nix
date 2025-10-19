{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      python3
      gcc
      gnumake
      pkg-config
      zulu24
  ];
};
}
