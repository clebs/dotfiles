{config, lib, pkgs, ...}:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # disable because it conflicts with networkmanager. Not cleat why we need this.
  # networking.wireless.iwd.enable = true;

  environment.sessionVariables =  {
    # Hint electron apps to use Wayland
    NIXOS_OZONE_WL = "1";
    # fix nautilus rendering bug on wayland
    GSK_RENDERER = "gl";
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland";
    GDK_BACKEND = "wayland";
    GDK_GL = "gl";
    GDK_DEBUG = "gl";
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
    #bluetooth
    blueman
    # Control brightness
    brightnessctl
    # lock screen
    hypridle
    hyprlock
    # wallpapers
    hyprpaper
    # Kitty is required for initial setup
    kitty
    # notifications
    libnotify
    swaynotificationcenter
    # choose network
    networkmanagerapplet
    # power menu
    nwg-bar
    # GTK styling
    nwg-look
    # audio settings
    pavucontrol
    # media controls
    playerctl
    # hyprland bar
    waybar
    # app launcher
    wofi
  ];
}
