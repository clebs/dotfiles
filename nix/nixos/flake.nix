{
  description = "Borja's system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    zigpkgs.url = "github:mitchellh/zig-overlay";
    # requires ssh for now since it is a private repo.
    # On NixOS symlink ssh key to root, sudo is needed to change the system flake at /etc/nixos.
    ghostty.url = "git+ssh://git@github.com/ghostty-org/ghostty";
 };

 outputs = { self, nixpkgs, nixos-unstable, zigpkgs, ghostty, ...}: {
    nixosConfigurations = {
      # Here we can define different configurations for hosts and systems.
      # Then they can be called with nix-os rebuild switch --flake .#configname
      arm-vmware = let system = "aarch64-linux"; in nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit nixos-unstable zigpkgs system ghostty; };
        modules = [
          ./machines/arm-vmware.nix
        ];
      };
      white-tower = let system = "x86_64-linux"; in nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit nixos-unstable zigpkgs system ghostty; };
        modules = [
          ./machines/white-tower.nix
        ];
      };
      mbp13 = let system = "x86_64-linux"; in nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit nixos-unstable zigpkgs system ghostty; };
        modules = [
          ./machines/mbp13.nix
        ];
      };
    };
  };
}
