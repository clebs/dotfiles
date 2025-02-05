{config, lib, pkgs, ...}:
{
  # Fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = ["FiraCode"];})
  ];
}
