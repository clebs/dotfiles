{config, lib, pkgs, ...}:
{
  services.jellyfin = {
    enable = true;
    dataDir = "/home/borja/jellyfin";
    user = "borja";
  };
  environment.systemPackages = [
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];

  # services.nextcloud = {
    # enable = true;
    # package = pkgs.nextcloud28; # previous versions unsupported
    # home = "/home/borja/nextcloud";
    # https = true;
    # hostName = "nextcloud.example.com";
    # settings = {
      # trusted_domains = [
        # "talk.nextcloud.example.com"
        # "files.nextcloud.example.com"
      # ];
    # };
  # };

  virtualisation.docker = {
    enable = true;
  };

  users.users.borja = {
    # extraGroups = config.users.users.borja.extraGroups or [] ++ [ "docker" ];
    extraGroups = [ "docker" ];
  };
}
