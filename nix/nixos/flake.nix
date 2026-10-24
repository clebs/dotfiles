{
  description = "Borja's system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixos-unstable, agenix, ... }: {
    nixosConfigurations = {
      # Here we can define different configurations for hosts and systems.
      # Then they can be called with nix-os rebuild switch --flake .#configname
      arm-vmware = let 
        system = "aarch64-linux";
        pkgs-unstable = import nixos-unstable { inherit system; config.allowUnfree = true; };
      in nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit pkgs-unstable; };
        modules = [ ./machines/arm-vmware.nix ];
      };
      white-tower = let 
        system = "x86_64-linux";
        pkgs-unstable = import nixos-unstable { inherit system; config.allowUnfree = true; };
      in nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit pkgs-unstable; };
        modules = [ ./machines/white-tower.nix ];
      };
      vader = let 
        system = "x86_64-linux";
        pkgs-unstable = import nixos-unstable { inherit system; config.allowUnfree = true; };
      in nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit pkgs-unstable agenix; };
        modules = [ ./machines/vader.nix agenix.nixosModules.default ];
      };
      mbp13 = let 
        system = "x86_64-linux";
        pkgs-unstable = import nixos-unstable { inherit system; config.allowUnfree = true; };
      in nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit pkgs-unstable; };
        modules = [ ./machines/mbp13.nix ];
      };
      aoostar-r7 = let 
        system = "x86_64-linux";
        pkgs-unstable = import nixos-unstable { inherit system; config.allowUnfree = true; };
      in nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit pkgs-unstable; };
        modules = [ ./machines/aoostar-r7.nix ];
      };
    };
  };
}
