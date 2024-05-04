{config, lib, pkgs, ...}:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.sessionVariables =  {
    NIXOS_OZONE_WL = "1";
  };

  xdg.portal = {
    enable = true;
    # presumably already included
    # extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  environment.systemPackages = with pkgs; [
    # hyprland bar
    waybar

    # notifications
    mako
    libnotify

    # wallpapers
    swww

    # app launcher
    rofi-wayland
  ];
}
