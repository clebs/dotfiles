# NixOS Home Server & NAS setup
The home server has the following features:
- [ ] RAID1 for fault tolerance
- [?] Photo backup
- [ ] Media Server
- [x] Hibernation schedule to sleep at night
- [ ] Git remote mirroring GH
- [x] SMB LAN file share
- [x] Webdav server
- [ ] Management dashboard
- [ ] Google drive backup
- [ ] Gmail backup

## Component setup
Despite many of these things being automatable on NixOS, it feels safer and more deliberate to do this manually once.

### MDADM
The RAID1 is built using mdadm with the following setup:

1. Make sure the 2+ disks to use are wiped:
    ```bash
    sudo wipefs --all --force /dev/sdX# # wipe partitions
    sudo wipefs --all --force /dev/sdX  # wipe disk partition table
    ```
2. Create the redundant array:
    ```bash
    sudo mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 /dev/sdX /dev/sdY
    ```
3. Monitor the mirroring process:
    ```bash
    watch cat /proc/mdstat
    ```
4. Create a filesystem on the array:
    ```bash
    sudo mkfs.xfs -F /dev/md0
    ```
5. Mount the filesystem (make sure the folder exists and is empty):
    ```bash
    sudo mount /dev/md0 /nas
    ```
6. Save the array layout:
    ```bash
    sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
    ```
7. Make the array available at boot:
    ```bash
    sudo update-initramfs -u
    ```
8. Add the mount to fstab:
    ```bash
    echo '/dev/md0 /nas xfs defaults,nofail,discard 0 0' | sudo tee -a /etc/fstab
    ```

### Hibernation schedule
The automated hibernation and wake up is performed comibing cron jobs with `rtcwake`.
System crontab added in NixOS as services.cron.systemCronJobs = [];
Server sleeps daily at midnight and wakes up at 8:00
System cron needs to specify which user runs the command.
See cron defined in nas.nix
```bash
00 00 * * * root rtcwake --date 08:00 -m disk >/dev/null 2>&1
```

### Rclone google drive
Run `rclone config` and follow instructions. Since the server has no GUI, we need to copy token from a laptop with GUI that also has rclone installed.
After that, `rclone sync $src $dst` from remote (src) to a local path (dst). Careful, all files in src that are not in dst will be deleted.
See systemd timers on nas.nix for paths and users.

### Webdav
Managed by nixos + config file we need to define both users and their paths. We can store passwords encrypted in the config with `webdav bcrypt`.
More info: https://github.com/hacdias/webdav

<!--
TODO: find a way to securely set webdav config via nixos with
environment.etc."webdav/config.conf" = {
	text = ''
		tcp SEC30CDA71BCDB2.landcroft.net
	'';
	mode = "640";
};
-->

### Retroarch
To have a living room gaming console retroarch can be started as a service.

#### Troubleshoot
Sometimes when closing retroarch, the wifi restarts and everything slows downa  lot.
Collect diagnostics:
```bash
sudo dmesg | tail -50 > /tmp/after-cage.log
sudo cat /proc/$(pgrep seatd)/stack >> /tmp/after-cage.log 2>&1
systemctl status seatd >> /tmp/after-cage.log 2>&1
journalctl -u systemd-logind --no-pager -n 20 >> /tmp/after-cage.log 2>&1
```
