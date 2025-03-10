{
  description = "Borja's system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    zigpkgs.url = "github:mitchellh/zig-overlay";
    ghostty.url = "github:ghostty-org/ghostty";
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
      vader = let system = "x86_64-linux"; in nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit nixos-unstable zigpkgs system ghostty; };
        modules = [
          ./machines/vader.nix
        ];
      };
      mbp13 = let system = "x86_64-linux"; in nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit nixos-unstable zigpkgs system ghostty; };
        modules = [
          ./machines/mbp13.nix
        ];
      };
      aoostar-r7 = let system = "x86_64-linux"; in nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit nixos-unstable system ghostty; };
        modules = [
          ./machines/aoostar-r7.nix
        ];
      };
    };
  };
}
