# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, system, pkgs, nixos-unstable, zigpkgs, ghostty, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../hardware-configuration.nix
      ../modules/vmware-guest-tools.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # set kernel version
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_11;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Desktop
  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    # Configure keymap in X11
    xkb.layout = "us";
    xkb.variant = "euro";
    # Enable the GNOME Desktop Environment.
    desktopManager.gnome.enable = true;
    displayManager = {
      # GNOME login manager
      gdm = {
        enable = true;
        wayland = true;
      };
    };
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin = {
    enable = true;
    user = "borja";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.borja = {
    isNormalUser = true;
    description = "Borja Clemente";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      firefox
    #  thunderbird
    ];
  };

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  #Allow to use the new nix command
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; 
  # add extra binary caches
  nix.settings = {
    extra-substituters = ["https://ghostty.cachix.org"];
    extra-trusted-public-keys = ["ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="];
  };

  # VMware tools
  # Disable the default module and import Mitchell's override. It has
  # customizations to make this work on aarch64.
  disabledModules = [ "virtualisation/vmware-guest.nix" ];

  virtualisation.vmware.guest = {
    headless = false;
    enable = true; 
  };

  programs.zsh.enable = true;
  programs.fuse.userAllowOther = true;

  environment.sessionVariables = {
    # Prevent invisible cursor
    WLR_NO_HARDWARE_CURSORS = "1"; 
    # Hint electron apps to use Wayland
    NIXOS_OZONE_WL = "1";
    PATH = "$PATH:$HOME/.local/bin";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = let 
    unstable = import nixos-unstable { inherit system; config.allowUnfree = true; };

    core = import ../packages/core.nix { inherit system pkgs unstable ghostty; };
    desktop = import ../packages/desktop.nix { inherit pkgs unstable; };
    dev = import ../packages/dev.nix { inherit pkgs; };
    utils = import ../packages/utils.nix { inherit pkgs; };
    wayland = import ../packages/wayland.nix { inherit pkgs; };
	
  in core ++ desktop ++ dev ++ utils ++ wayland ++ [zigpkgs.packages.${system}."0.12.0"];

  # Fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = ["FiraCode"];})
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
