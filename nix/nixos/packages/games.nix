{pkgs, ...}: with pkgs; 
[
  lutris
  wineWowPackages.unstableFull
  mesa
  xboxdrv
  # retroarchFull # builds from source and takes very long
]
