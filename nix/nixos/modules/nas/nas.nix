{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:
{

  #---- Packages ----#
  environment.systemPackages = with pkgs; [
    jellyfin-ffmpeg
    jellyfin-web
    mdadm
    rclone
    xfsprogs
    webdav # we need the package in addition to the service for the CLI
  ];

  #---- DATA backup and access ----#

  # SAMBA file sharing
  # Need to add user passwords to Samba.
  # Manually run `smbpasswd -a username`
  # Or automate with activation scripts
  # https://discourse.nixos.org/t/nixos-configuration-for-samba/17079/6
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

  services.webdav = {
    enable = true;
    configFile = "/etc/webdav/config.yaml";
  };

  #---- Photo backup ----#
  services.immich = {
    enable = true;
    package = pkgs-unstable.immich; # 26.05 pkg is marked as unsafe
    port = 5555;
    host = "0.0.0.0"; # or "127.0.0.1" for local only
    mediaLocation = "/nas/immich"; # where photos are stored
    machine-learning.enable = false; # disable img analysis to save power
    openFirewall = true; # open port in firewall
  };

  # FIXME: the auto upload from phone feature is not reliable.
  # NextCloud for phone backups, messaging, calendar, webDAV, etc...
  # environment.etc."default-nextcloud-pwd".text = "Changem3rightaway!";
  # services.nextcloud = {
  # enable = true;
  # package = pkgs.nextcloud32;
  # home = "/nas/nextcloud"; # nextcloud user needs read access to /nas and write to /nas/nextcloud
  # https = false;
  # hostName = "nextcloud.castillo.box";
  # maxUploadSize = "4G";
  # database.createLocally = true;
  # config = {
  # adminpassFile = "/etc/default-nextcloud-pwd";
  # dbtype = "mysql";
  # };
  # settings = {
  # trusted_domains = [
  # "192.168.1.*" # Only reachable from the local network
  # ];
  # };
  # };

  #---- Drive Sync ----#
  imports =
    let
      driveLib = import ../../lib/drive-sync.nix { inherit pkgs; };
    in
    [
      # mkDriveSync returns multiple items.
      # So we use imports for all of them to be added to the config.
      # otherwise we manually need to add every service and timer.
      (driveLib.mkDriveSync "borja" {
        user = "borja";
        remote = "gdrive-borja";
        path = "/nas/borja/gdrive";
      })
      # (driveLib.mkDriveSync "irina" {
      # user = "borja";
      # remote = "gdrive-irina";
      # path = "/nas/irina/gdrive";
      # })
    ];

  # TODO Gmail sync

  #---- Multimedia ----#

  # Jellyfin media server
  services.jellyfin = {
    enable = true;
    dataDir = "/nas/jellyfin";
    user = "borja";
  };

  #---- Containers ----#

  # Enable docker to run some containers
  # virtualisation.docker = {
  # enable = true;
  # };

  # users.users.borja = {
  # # extraGroups = config.users.users.borja.extraGroups or [] ++ [ "docker" ];
  # extraGroups = [ "docker" ];
  # };

  #---- Hibernation ----#

  services.cron = {
    enable = true;
    systemCronJobs = [
      "00 00 * * * root rtcwake --date 08:30 -m disk >/var/log/cron.log 2>&1"
    ];
  };

  #---- Networking ----#

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  networking.firewall.enable = true;
  networking.firewall.allowPing = true;
  # Open ports: 80 -> http, 443 -> https, 5005 -> webdav
  networking.firewall.allowedTCPPorts = [
    80
    443
    5005
  ];
  networking.firewall.allowedUDPPorts = [ ];

  #---- Retroarch ----#

  # systemd.services.retroarch-kiosk = {
  # description = "RetroArch Kiosk";
  # after = [ "seatd.service" ];
  # requires = [ "seatd.service" ];

  # serviceConfig = {
  # Type = "simple"; # does not report status, will appear as running even if failed.
  # User = "borja";
  # Group = "users";
  # PAMName = "login"; # tell systemd to create a logind for the GUI
  # TTYPath = "/dev/tty1";
  # # Reset the TTY on exit
  # TTYReset = true;
  # TTYVHangup = true;
  # TTYVTDisallocate = true;
  # StandardInput = "tty";
  # StandardOutput = "tty";
  # StandardError = "journal";
  # SupplementaryGroups = [ "video" "input" "render" ];

  # # cage = single-window Wayland kiosk compositor
  # ExecStart = "${pkgs.cage}/bin/cage -s -- ${pkgs.retroarch}/bin/retroarch";
  # Restart = "no";
  # # last resort solution for stuck iwlwifi/iwlmvm
  # # ExecStopPost = "+${pkgs.systemd}/bin/systemctl reboot";
  # };

  # environment = {
  # # wlroots does not start if no input devices detected without this.
  # # we likely will plug devices at any time.
  # WLR_LIBINPUT_NO_DEVICES = "1";
  # # Usually detected from login shell, but we are not logged in
  # XDG_RUNTIME_DIR = "/run/user/1000";
  # WLR_LOG = "debug";
  # SEATD_VTBOUND = "0";
  # # If using PipeWire
  # PULSE_SERVER = "unix:/run/user/1000/pulse/native";
  # };
  # };

  #---- Emulation Station ----#
  systemd.services.emulation-kiosk =
    let
      es-de = pkgs.callPackage ../../drv/emulation-station.nix { };
    in
    {
      description = "Emulation Kiosk";
      after = [ "seatd.service" ];
      requires = [ "seatd.service" ];

      serviceConfig = {
        Type = "simple"; # does not report status, will appear as running even if failed.
        User = "borja";
        Group = "users";
        # PAMName = "login"; # tell systemd to create a logind for the GUI
        # TTYPath = "/dev/tty1";
        # Reset the TTY on exit
        # TTYReset = true;
        # TTYVHangup = true;
        # TTYVTDisallocate = true;
        # StandardInput = "tty";
        StandardOutput = "tty";
        StandardError = "journal";
        WorkingDirectory = "/home/borja";
        SupplementaryGroups = [
          "video"
          "input"
          "render"
          "audio"
        ];

        # cage = single-window Wayland kiosk compositor
        ExecStart = "${pkgs.zsh}/bin/zsh -c '${pkgs.cage}/bin/cage -s -- ${es-de}/bin/es-de'";
        Restart = "no";
        # last resort solution for stuck iwlwifi/iwlmvm
        # ExecStopPost = "+${pkgs.systemd}/bin/systemctl reboot";
      };

      environment = {
        # wlroots does not start if no input devices detected without this.
        # we likely will plug devices at any time.
        WLR_LIBINPUT_NO_DEVICES = "1";
        # Usually detected from login shell, but we are not logged in
        XDG_RUNTIME_DIR = "/run/user/1000";
        HOME = "/home/borja";
        WLR_LOG = "debug";
        SEATD_VTBOUND = "0";
        # If using PipeWire
        PULSE_SERVER = "unix:/run/user/1000/pulse/native";
        PIPEWIRE_RUNTIME_DIR = "/run/user/1000";
        # Run appimage without sandbox, it conflicts with cage
        # bwrap capabilities
        # APPIMAGE_EXTRACT_AND_RUN = "1";
      };
    };

  # script to manage ROMs
  system.activationScripts.symlinkDirs = ''
    install -Dm755 ${./link-roms.sh} /nas/Games/ROMs/link-roms.sh
  '';
}
