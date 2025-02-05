{config, lib, pkgs, ...}:
{

  #---- DATA backup and access ----#

  # TODO Disko RAID1 setup

  # SAMBA for file sharing
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        workgroup = "WORKGROUP";
        "server string" = "aoostar";
        "netbios name" = "aoostar";
        security = "user";
        #"use sendfile" = "yes";
        #"max protocol" = "smb2";
        # note: localhost is the ipv6 localhost ::1
        "hosts allow" = "192.168.1. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
        # "guest account" = "nobody";
        # "map to guest" = "bad user";
      };
      private = {
        path = "/nas/";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        # "force user" = "ALLOWEDUSER";
        # "force group" = "ALLOWEDGROUP";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  # Need to add user passwords to Samba.
  # Manually run `smbpasswd -a username`
  # Or automate with activation scripts 
  # https://discourse.nixos.org/t/nixos-configuration-for-samba/17079/6


  #TODO WebDav for SafeInCloud sync

  # NextCloud for phone backups, messaging, calendar, etc...
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

  # TODO Google drive sync
  # TODO Email sync

  #---- Multimedia ----#

  # Jellyfin media server
  services.jellyfin = {
    enable = true;
    dataDir = "/home/borja/jellyfin";
    user = "borja";
  };
  environment.systemPackages = [
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];

  # Enable docker to run some containers
  # virtualisation.docker = {
    # enable = true;
  # };

  # users.users.borja = {
    # # extraGroups = config.users.users.borja.extraGroups or [] ++ [ "docker" ];
    # extraGroups = [ "docker" ];
  # };

  # TODO Hibernation schedule
  # TODO Git server


  #---- Networking ----#

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  networking.firewall.enable = true;
  networking.firewall.allowPing = true;
  networking.firewall.allowedTCPPorts = [ 445 139 ];
  networking.firewall.allowedUDPPorts = [ 137 138 ];
}
