{pkgs, ...}: with pkgs; 
[
  cage
  pcsx2                  # Playstation 2 standalone
  (retroarch.withCores (
      cores:  with cores; [
        picodrive        # Sega Megadrive
        nestopia         # NES
        snes9x           # SNES
        gambatte         # GameBoy Color
        gpsp             # GameBoy Advance
        mupen64plus      # Nintendo 64
        dolphin          # GameCube / Wii
        pcsx-rearmed     # PlayStation
      ]
    ))
  retroarch-assets
  retroarch-joypad-autoconfig
  (pkgs.callPackage ../drv/emulation-station.nix { })
]
