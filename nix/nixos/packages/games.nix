{pkgs, ...}: with pkgs; 
[
  lutris
  wineWowPackages.unstableFull
  winetricks
  mesa
  # retroarchFull # builds from source and takes very long
]
