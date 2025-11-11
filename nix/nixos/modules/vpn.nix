{config, lib, pkgs, ...}:
{
  # GNOME network manager plugin
  networking.networkmanager = {
    plugins = with pkgs; [
      networkmanager-openvpn
    ];
  };

  # Red Hat CA  
  # security.pki.certificateFiles = [ /etc/pki/tls/certs/2022-IT-Root-CA.pem ];
}
