{pkgs, unstable, ...}: with pkgs; 
[
    gnomeExtensions.dash-to-dock
    gnomeExtensions.blur-my-shell
    gnomeExtensions.vitals
    # Change border color: dconf write /org/gnome/shell/extensions/pop-shell/hint-color-rgba "'rgba(0, 171, 146, 0.8)'"
    unstable.gnomeExtensions.pop-shell
    unstable.pop-launcher
]
