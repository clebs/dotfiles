{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, ... }:
  {
    
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#mbp-m1
 darwinConfigurations."mbp-m1" = nix-darwin.lib.darwinSystem {
      # load our local autoenv derivation until PR is merged
      # https://github.com/NixOS/nixpkgs/pull/349058
      modules = [ ./machines/mbp-m1.nix ./modules/autoenv.nix ];
      specialArgs = { inherit inputs; };
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."mbp-m1".pkgs;
  };
}
