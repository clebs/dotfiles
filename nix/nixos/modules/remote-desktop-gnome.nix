{config, lib, pkgs, ...}:
{
  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "$gnome-session";
  services.xrdp.openFirewall = true;

  # services.gnome.gnome-remote-desktop.enable = true;
  environment.systemPackages = with pkgs; [
    gnome.gnome-session
  ];

  networking.firewall.allowedTCPPorts = [ 3389 ];
  networking.firewall.allowedUDPPorts = [ 3389 ];

}
