{config, lib, pkgs, ...}:
{
  boot.kernelModules = [ "kvm-amd" ];

  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["borja"];
  users.groups.libvirt = {
    members = [ "borja" ];
  };

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
    };
    spiceUSBRedirection.enable = true;
  };

  # Add libvirt for binaries to link it and interact with it.
  environment.systemPackages = with pkgs; [ virtiofsd libvirt ];

  # libvirtd includes all libvirt libraries
  programs.nix-ld.libraries = with pkgs; [ libvirt ];
}
