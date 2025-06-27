{config, lib, pkgs, ...}:
{
  boot.kernelModules = [ "kvm-amd" ];

  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["borja"];
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };

  environment.systemPackages = with pkgs; [ virtiofsd ];

}
