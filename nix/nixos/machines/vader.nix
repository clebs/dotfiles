{ config, system, pkgs, nixos-unstable, zigpkgs, ghostty, agenix, ... }:

{
  imports = [
    ../hardware-configuration.nix
    ../modules/fonts.nix
    ../modules/hyprland.nix
    ../modules/virt-manager.nix
    ../modules/vpn.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # set kernel version
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_18;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant. But cant be used with network manager.
  networking.hostName = "vader"; # Define your hostname.

  # Firmware
  hardware.enableAllFirmware = true;

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
  services = {
    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      # Configure keymap in X11
      xkb.layout = "us";
      xkb.variant = "euro";
      videoDrivers = [ "nvidia" ];
    };
    # Enable the GNOME Desktop Environment.
    desktopManager.gnome.enable = true;
    displayManager = {
      # GNOME login manager
      gdm = {
        enable = true;
        # wayland = false; # on 25.11 GNOME 49 dropped X11 support
      };
    };
  };

  # Enable automatic login for the user.
  #  services.displayManager.autoLogin = {
  #    enable = true;
  #    user = "borja";
  #  };

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  #  systemd.services."getty@tty1".enable = false;
  #  systemd.services."autovt@tty1".enable = false;

  # Configure console keymap
  console.keyMap = "us";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # WARNING: Nvidia driver does not compile on older default kernel.
  # Comment this block out on first rebuild.
  # Enable Nvidia graphics and openGL
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.bluetooth = {
    enable = true; # enables support for Bluetooth
    powerOnBoot = true; # powers up the default Bluetooth controller on boot
    settings = {
      General = {
        Experimental = true; # show battery levels and allow controlls
      };
    };
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
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
    packages = with pkgs;
      [
        #  thunderbird
      ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  #Allow to use the new nix command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # add extra binary caches
  nix.settings = {
    extra-substituters = [ "https://ghostty.cachix.org" ];
    extra-trusted-public-keys =
      [ "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns=" ];
  };

  programs.zsh.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall =
      true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall =
      true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall =
      true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.nix-ld.enable = true;

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
    unstable = import nixos-unstable {
      inherit system;
      config.allowUnfree = true;
    };

    core = import ../packages/core.nix { inherit pkgs unstable ghostty; };
    desktop = import ../packages/desktop.nix { inherit pkgs unstable; };
    dev = import ../packages/dev.nix { inherit system pkgs zigpkgs; };
    k8s = import ../packages/k8s.nix { inherit pkgs; };
    utils = import ../packages/utils.nix { inherit pkgs; };
    games = import ../packages/games.nix { inherit pkgs; };
    wayland = import ../packages/wayland.nix { inherit pkgs; };
    social = import ../packages/social.nix { inherit pkgs; };
    media = import ../packages/media.nix { inherit pkgs; };
    office = import ../packages/office.nix { inherit pkgs; };
    secrets = import ../packages/secrets.nix { inherit system pkgs agenix; };

  in with pkgs;
  core ++ desktop ++ dev ++ k8s ++ utils ++ games ++ wayland ++ social ++ media
  ++ office ++ secrets;

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
  system.stateVersion = "24.11"; # Did you read the comment?

}
