{ pkgs, pkgs-stable, inputs, ccusage, ... }:
{
      nixpkgs.hostPlatform = "aarch64-darwin";
      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs;
      [ 
            android-tools
            atuin
            autojump
            awscli2
            pkgs-stable.azure-cli
            btop
            ccusage.packages.${stdenv.hostPlatform.system}.default
            claude-code
            clusterctl
            cmake
            docker
            fastfetch
            fd
            fzf
            gettext
            gh
            git-lfs
            gnupg
            go
            go-mockery
            google-cloud-sdk
            govc
            gum
            heimdall
            highlight
            hugo
            jdk
            jq
            jre
            k3d
            k9s
            kind
            krew
            kubebuilder
            kubectl
            kubelogin
            kubelogin-oidc
            kustomize
            libyaml
            # to be able to use docker when podman has issues
            # run limactl start template:docker and follow instructions
            lima 
            llvm
            mage
            navi
            neovim
            nodejs
            ollama
            opencode
            pi-coding-agent
            pinentry-tty # needed for gpg sign
            podman
            python313Packages.pip
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
            tilt
            tldr
            tmux
            tree
            tree-sitter
            watch
            wget
            libX11
            # xquartz currently not building again
            yq
            zig
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
                  "sikarugir-app/sikarugir"
            ];

            casks = [
                  "amethyst"
                  "vagrant"
                  "sikarugir"
                  "vagrant-vmware-utility"
            ];

            brews = [
                  "gcc" # can't use nix gcc because of https://github.com/NixOS/nixpkgs/issues/306279
                  "gnu-sed"
                  "mingw-w64"
                  "mlx-lm"
                  "messense/macos-cross-toolchains/aarch64-unknown-linux-gnu"
                  "messense/macos-cross-toolchains/x86_64-unknown-linux-gnu"
              #    "libyaml" # can't use nix one because rbenv is installed on homebrew and needs this
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
      nix.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      programs.autoenv.enable = true;

      # nix-darwin now uses root and the user for non system wide options needs to be specified
      # e.g. for homebrew
      system.primaryUser = "borja";

      # Set Git commit hash for darwin-version.
      system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
    }
