{ config, system, pkgs, nixos-unstable, ghostty, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../hardware-configuration.nix
      ../modules/fonts.nix
      ../modules/nas.nix
    ];

  # Bootloader.
  boot.loader = { 
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # set kernel version
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_11;
  # Load AMD drivers early
  boot.initrd.kernelModules = [ "amdgpu" ];

  # NAS should never sleep
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = "castillobox"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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

  
  specialisation = {
    # extra stuff in desktop mode
    desktop.configuration =
      { system.nixos.tags = [ "desktop" ];
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
              wayland = false;
            };
          };
          videoDrivers = ["amdgpu"];
        };

        # on desktop mode enble sleep
        systemd.targets.sleep.enable = false;
        systemd.targets.suspend.enable = false;
        systemd.targets.hybrid-sleep.enable = false;
      };
  };

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  # Configure console keymap
  console.keyMap = "us";

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
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  #Allow to use the new nix command
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; 

  programs.zsh.enable = true;

  environment.systemPackages = let 
    unstable = import nixos-unstable { inherit system; config.allowUnfree = true; };

    core = import ../packages/core.nix { inherit pkgs unstable ghostty; };
    x11 = import ../packages/x11.nix { inherit pkgs; };
 in with pkgs; core ++ x11;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

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
  system.stateVersion = "24.11"; # Did you read the comment?

}
