{pkgs, ...}: with pkgs; 
[
  lutris
  winePackages.stagingFull
  winetricks
  protonup-qt
  mesa
  # retroarchFull # builds from source and takes very long
]
