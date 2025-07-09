{config, lib, pkgs, ...}:
{
  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];
}
