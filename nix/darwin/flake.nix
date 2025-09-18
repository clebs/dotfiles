{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, ... }:
  {
    
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#mbp-m1
 darwinConfigurations."mbp-m3" = nix-darwin.lib.darwinSystem {
      # Use an own autoenv module until it can be added to nix-darwin
      modules = [ ./machines/mbp-m3.nix ./modules/autoenv.nix ];
      specialArgs = { inherit inputs; };
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."mbp-m3".pkgs;
  };
}
