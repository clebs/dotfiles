{config, lib, pkgs, ...}:
{
  # GNOME network manager plugin
  # When adding a VPN on networkmanager:
  # Check the boxes for: "Use this connection only for resources on its network"
  # For both ipv4 and ipv6 it is disabled by default.
  networking.networkmanager = {
    plugins = with pkgs; [
      networkmanager-openvpn
    ];
  };

  # The CA path needs to be added to the build command: `--option extra-sandbox-paths '/usr/local/certs/2022-IT-Root-CA.pem'`
  # The target folder needs to chown:
  # chown -R root:nixbld
  # exec permission is needed in the folder.
  security.pki.certificateFiles = [ "/usr/local/certs/2022-IT-Root-CA.pem" ];
}
