{
  description = "Borja's system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
 };

 outputs = { self, nixpkgs, nixos-unstable, ...}: {
    nixosConfigurations = {
      # Here we can define different configurations for hosts and systems.
      # Then they can be called with nix-os rebuild switch --flake .#configname
      default = let system = "aarch64-linux"; in nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit nixos-unstable system; };
        modules = [
          ./configuration.nix
        ];
      };
      white-tower = let system = "x86_64-linux"; in nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit nixos-unstable system; };
        modules = [
          ./machines/white-tower.nix
        ];
      };
    };
  };
}
