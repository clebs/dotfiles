{config, lib, pkgs, ...}:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.displayManager.gdm.wayland = true;

  networking.wireless.iwd.enable = true;

  environment.sessionVariables =  {
    NIXOS_OZONE_WL = "1";
    # fix nautilus rendering bug on wayland
    GSK_RENDERER = "gl";
    GDK_DEBUG = "gl-prefer-gl";
  };

  xdg.portal = {
    enable = true;
    # presumably already included
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  # Font needed by waybar
  fonts.packages = with pkgs; [
    font-awesome
  ];

  environment.systemPackages = with pkgs; [
    # Kitty is required for initial setup
    kitty
    # hyprland bar
    waybar
    # notifications
    swaynotificationcenter
    libnotify
    # wallpapers
    hyprpaper
    # lock screen
    hyprlock
    # idle lock
    hypridle
    # GTK styling
    nwg-look
    # app launcher
    wofi
    # Control brightness
    brightnessctl
    #bluetooth
    blueberry
    # media controls
    playerctl
  ];
}
