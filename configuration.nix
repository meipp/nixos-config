{ config, pkgs, ... }:

let
  traceVal = x: builtins.trace "${x}" x;
  installGrubTheme = import ./grub-themes/install-grub-theme.nix {pkgs = pkgs;};
in
{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  boot = {
    # quiet boot
    kernelParams = [ "quiet" "loglevel=3" "udev.log-priority=3" "splash" ];
    consoleLogLevel = 0;
    initrd.verbose = false;
    plymouth = {
      enable = true;
    };

    supportedFilesystems = [ "ntfs" ];
    tmpOnTmpfs = true;

    
    loader = {
      timeout = 2;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
    
    loader.grub = {
      enable = true;
      efiSupport = true;
      devices = ["nodev"];
      useOSProber = true;

      splashImage = ./wallpapers/nixos.png;

      theme = installGrubTheme {
        src = ./grub-themes/whitesur;
        background = ./grub-themes/backgrounds/nixos-prompt-1.png;
      };
    };
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Berlin";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
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
  };

  services = {
    xserver = {
      enable = true;
      layout = "us";
      xkbVariant = "";

      desktopManager = {
        plasma5.enable = true;
        xterm.enable = true; # enable xterm as a fallback desktop manager
      };
      displayManager = {
        sddm = {
          enable = true;
          theme = "${pkgs.stdenv.mkDerivation {
            name = "custom-sddm-theme";
            src = ./sddm-themes/breeze;
            installPhase = "mkdir \$out; cp -r * $out";
          }}";
        };
      };
      
      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;
    };

    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable SSD trim
    fstrim.enable = true;
  };

  hardware.bluetooth.enable = true;

  programs.bash.enableCompletion = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.david = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "docker" "vboxusers" ];
    packages = with pkgs; [
      firefox
      chromium
      thunderbird
      tdesktop
      flameshot
      rofi
      bat
      neofetch
      libreoffice-qt

      discord
      rocketchat-desktop
      texlive.combined.scheme-full
      praat
      blender
      todoist-electron

      vlc
      mpv
      gimp
      inkscape
      kdenlive
      obs-studio
      feh
      zathura

      imagemagick

      arandr
      baobab

      coq
      coqPackages.coqide

      jetbrains.idea-ultimate

      # vscode
      (vscode-with-extensions.override {
        vscodeExtensions = with vscode-extensions; [
          bbenoist.nix
          justusadam.language-haskell
          haskell.haskell
          github.copilot
          ms-azuretools.vscode-docker
          scala-lang.scala
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
           name = "github-markdown-preview";
           publisher = "bierner";
           version = "0.3.0";
           sha256 = "sha256-7pbl5OgvJ6S0mtZWsEyUzlg+lkUhdq3rkCCpLsvTm4g=";
          }
          {
           name = "smt-lib-syntax";
           publisher = "martinring";
           version = "0.0.1";
           sha256 = "sha256-Vmt1gFRai52WmmrqHZKxR0VbV4AdT0VtEX3p8eV7CNo=";
          }
        ];
      })
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  virtualisation = {
    # Docker
    docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };

    # VirtualBox
    virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
    };
  };
  
  environment.systemPackages = with pkgs; with libsForQt5; [
    vim
    wget
    tmux
    git
    htop
    file
    tree
    xdg-utils
    gparted
    docker-compose

    whitesur-gtk-theme
    whitesur-icon-theme

    # KDE
    ark # unzip
    bismuth # tiling
    bluedevil # bluetooth

    spotify

    kate

    gnumake
    gcc
    python3
    cargo
    sbt
    nodejs_20

    # Haskell
    stack
    haskell.packages.ghc902.haskell-language-server
    haskell.packages.ghc902.ghcide
    haskell.packages.ghc943.haskell-language-server
    haskell.packages.ghc943.ghcide
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    dejavu_fonts
  ];
}
