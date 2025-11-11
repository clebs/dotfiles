{pkgs, agenix, ...}: with pkgs;
[
  # use with ../secrets/
  agenix.packages.${system}.default
]
