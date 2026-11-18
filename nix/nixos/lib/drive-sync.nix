{ pkgs }: {
  mkDriveSync = name: cfg: {
    systemd.services."gdrive-sync-${name}" = {
      description = "Sync Google Drive (${name})";
      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        ExecStart = "${pkgs.rclone}/bin/rclone sync ${cfg.remote}: ${cfg.path}
        --config=/home/${cfg.user}/.config/rclone/rclone.conf";
      };
    };

    # timer executes service with same name by default
    systemd.timers."gdrive-sync-${name}" = {
      description = "Sync Google Drive (${name}) every day";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        # Systemd timer format is:
        # day(s) of week: Mon,Tue / Mon..Fri  -> words -> dow
        # date: YYYY-MM-DD                    -> dashes -> date
        # HH:mm:ss                            -> colons -> time
        # each section is optional, systemd parses based on words/dashes/colons
        # it has also: hourly, daily, weekly, monthly
        # OnCalendar = "*:0/5"; # every 5 min
        OnCalendar = "daily"; # every 5 min
        Persistent = true;
      };
    };
  };
}
