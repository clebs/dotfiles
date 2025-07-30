{pkgs, ...}: with pkgs; 
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
]
