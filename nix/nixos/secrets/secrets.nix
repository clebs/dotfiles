let
  borja = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBPI5Pkbf0EsoF3BIMAkb1gYvOrDP+OoHZG1gb+ttTim";
in
{
  "rh-ca.age".publicKeys = [ borja ];
}
