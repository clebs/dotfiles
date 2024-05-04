{config, lib, pkgs, ...}:
{
  services.xserver.windowManager.session = [{
      name  = "Hypr";
      start = ''
        Hypr &
        waitPID=$!
      '';
  }];

  environment.systemPackages = with pkgs; [
    hypr
    # notifications
    mako
    libnotify

    # wallpapers
    feh

    # app launcher
    rofi
  ];
}
