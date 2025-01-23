{ pkgs, inputs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs;
      [ 
            atuin
            autojump
            awscli
            clusterctl
            cmake
            fd
            gettext
            gh
            gnupg
            go
            go-mockery
            gum
            highlight
            htop
            hugo
            jq
            k3d
            k9s
            kind
            kubebuilder
            kubelogin
            kubelogin-oidc
            kustomize
            xorg.libX11
            llvm
            mage
            navi
            neofetch
            neovim
            nodejs
            pinentry-tty # needed for gpg sign
            podman
            qemu
            rbenv
            ripgrep
            SDL2
            SDL2_image
            SDL2_ttf
            shellcheck
            slides
            sshpass
            sshuttle
            stow
            terraform
            silver-searcher
            tilt
            tldr
            tmux
            tree
            watch
            wget
            xquartz
            ytt
            zenity
        ];

      # Homebrew management
      homebrew = {
            # Install Homebrew under the default prefix
            enable = true;
            onActivation = {
                  autoUpdate = true;
                  upgrade = true;
                  cleanup = "zap";
            };

            taps = [
                  "messense/macos-cross-toolchains"
                  "gcenx/wine"
            ];

            casks = [
                  "amethyst"
                  "kegworks"
                  "vagrant"
                  "vagrant-vmware-utility"
            ];

            brews = [
                  "gcc" # can't use nix gcc because of https://github.com/NixOS/nixpkgs/issues/306279
                  "mingw-w64"
                  "messense/macos-cross-toolchains/aarch64-unknown-linux-gnu"
                  "messense/macos-cross-toolchains/x86_64-unknown-linux-gnu"
                  "libyaml" # can't use nix one because rbenv is installed on homebrew and needs this
            ];
      };

      # Fonts
      fonts.packages = with pkgs; [
            nerd-fonts.fira-code
      ];

      # GnuPG
      programs.gnupg.agent = {
            enable = true;
            enableSSHSupport = true;
      };

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      programs.autoenv.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
      nixpkgs.config.allowUnfree = true;
    }
