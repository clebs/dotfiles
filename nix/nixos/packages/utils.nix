{pkgs, ...}: with pkgs; 
[
  # Marked as insecure
  # ventoy
  exfat         # exFAT drivers and tools
  exfatprogs
  ntfs3g        # NTFS drivers
  gparted
]
