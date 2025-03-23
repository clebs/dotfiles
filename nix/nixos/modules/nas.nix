{config, lib, pkgs, ...}:
{

  #---- Packages ----#
  environment.systemPackages = with pkgs; [
    drive
    jellyfin-web
    jellyfin-ffmpeg
  ];

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


  # NextCloud for phone backups, messaging, calendar, webDAV, etc...
  environment.etc."default-nextcloud-pwd".text = "Changem3rightaway!";
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud30;
    home = "/nas/nextcloud"; # nextcloud user needs read access to /nas and write to /nas/nextcloud
    https = false;
    hostName = "nextcloud.castillo.box";
    maxUploadSize = "4G";
    database.createLocally = true;
    config = {
      adminpassFile = "/etc/default-nextcloud-pwd";
      dbtype = "mysql";
    };
    settings = {
      trusted_domains = [
        "192.168.1.*" # Only reachable from the local network
      ];
    };
  };

  # TODO Google drive sync
  # TODO Email sync

  #---- Multimedia ----#

  # Jellyfin media server
  services.jellyfin = {
    enable = true;
    dataDir = "/home/borja/jellyfin";
    user = "borja";
  };

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
  # Open ports: 80 -> nextcloud http, 443 -> https
  networking.firewall.allowedTCPPorts = [ 80 443 445 139 ];
  networking.firewall.allowedUDPPorts = [ 137 138 ];
}
