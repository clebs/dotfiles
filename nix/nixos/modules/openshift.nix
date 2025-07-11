{config, lib, pkgs, ...}:
let
  crc-rules = pkgs.writeTextFile {
    name = "99-crc-vsock.rules";
    text = ''
    KERNEL=="vsock", MODE="0660", OWNER="root", GROUP="libvirt"
    '';
    destination = "/etc/udev/rules.d/99-crc-vsock.rules";
  };
in {
  # Add rules for CRC
  services.udev.packages = [ crc-rules ] ;

  # CRC adds these hosts for local networking
  networking.extraHosts =
  ''
  # Added by CRC
  127.0.0.1        canary-openshift-ingress-canary.apps.crc.testing console-openshift-console.apps.crc.testing default-route-openshift-image-registry.apps.crc.testing downloads-openshift-console.apps.crc.testing api.crc.testing canary-openshift-ingress-canary.apps-crc.testing console-openshift-console.apps-crc.testing default-route-openshift-image-registry.apps-crc.testing downloads-openshift-console.apps-crc.testing
  127.0.0.1        oauth-openshift.apps.crc.testing rails-postgresql-example-prep.apps-crc.testing host.crc.testing oauth-openshift.apps-crc.testing
  # End of CRC section
  '';
}
