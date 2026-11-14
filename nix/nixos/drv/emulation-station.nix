{ appimageTools, fetchurl }:

   appimageTools.wrapType2 {
     pname = "es-de";
     version = "3.5.0";

     src = fetchurl {
       url = "https://gitlab.com/es-de/emulationstation-de/-/package_files/357718352/download";
       hash = "sha256-q8KZmhI4X4V3W9P5hvqJHHa2nfN5H3wS5MeDzzw2MPU="; # nix-prefetch-url to get this
     };

     extraPkgs = pkgs: with pkgs; [
       SDL2
       ffmpeg
     ];

     # create .desktop file, we need gnome for es-de to work properly
     extraInstallCommands = ''
     mkdir -p $out/share/applications
     cat > $out/share/applications/es-de.desktop << EOF
 [Desktop Entry]
 Type=Application
 Name=ES-DE
 Comment=EmulationStation Desktop Edition
 Exec=es-de
 Icon=es-de
 Terminal=false
 Categories=Game;Emulator;
 EOF
   '';
   }
