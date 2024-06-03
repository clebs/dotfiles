{
  description = "Borja's system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    zigpkgs.url = "github:mitchellh/zig-overlay";
 };

 outputs = { self, nixpkgs, nixos-unstable, zigpkgs, ...}: {
    nixosConfigurations = {
      # Here we can define different configurations for hosts and systems.
      # Then they can be called with nix-os rebuild switch --flake .#configname
      arm-vmware = let system = "aarch64-linux"; in nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit nixos-unstable zigpkgs system; };
        modules = [
          ./machines/arm-vmware.nix
        ];
      };
      white-tower = let system = "x86_64-linux"; in nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit nixos-unstable zigpkgs system; };
        modules = [
          ./machines/white-tower.nix
        ];
      };
      mbp13 = let system = "x86_64-linux"; in nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit nixos-unstable zigpkgs system; };
        modules = [
          ./machines/mbp13.nix
        ];
      };
    };
  };
}
