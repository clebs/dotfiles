{pkgs, zigpkgs, ...}: with pkgs; 
[
  cargo
  cmake
  go
  mage
  gnumake
  nodejs
  # openshift   Currently using a precompiled binary
  tree-sitter
  yq
  vagrant
  zigpkgs.packages.${system}."0.15.2"
]
