# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  home-manager,
  pkgs,
  ...
}: {
  home-manager.useGlobalPkgs = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  imports = [
    ./hardware-configuration.nix
    # home-manager.nixosModules.home-manager.default
  ];
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # stylix.enable = true;
  # stylix.image = ../../wallpapers/yfdFDwe.png;
  # stylix.polarity = "dark";

  programs = {
    hyprland.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
  };

  # virtualisation.virtualbox.guest = {
  #  enable = true;
  #  x11 = true;
  # };

  # Bootloader
  # boot.loader.grub.device = "/dev/sda";
  # boot.loader.grub.useOSProber = true;

  boot = {
    loader = {
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;
      # timeout = 0;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        # extraConfig = ''
        #   GRUB_HIDDEN_TIMEOUT_QUIET=true
        # '';
      };
    };
  };

  # # Setup keyfile
  # boot.initrd.secrets = {
  #   "/crypto_keyfile.bin" = null;
  # };

  # Enable sound with pipewire.
  # services.pulseaudio.enable = false;
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

  boot.loader.grub.enableCryptodisk = true;

  boot.initrd.luks.devices."luks-cb22329a-228b-4764-a7fc-46c8ac6eef06".device = "/dev/disk/by-uuid/cb22329a-228b-4764-a7fc-46c8ac6eef06";
  networking.hostName = "leturlaptop2"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # boot.initrd.systemd.enable = true;

  boot.initrd.verbose = false;

  boot.consoleLogLevel = 0;

  boot.kernelParams = [
    "quiet"
    "udev.log_level=0"
  ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Prague";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "cs_CZ.UTF-8";
    LC_IDENTIFICATION = "cs_CZ.UTF-8";
    LC_MEASUREMENT = "cs_CZ.UTF-8";
    LC_MONETARY = "cs_CZ.UTF-8";
    LC_NAME = "cs_CZ.UTF-8";
    LC_NUMERIC = "cs_CZ.UTF-8";
    LC_PAPER = "cs_CZ.UTF-8";
    LC_TELEPHONE = "cs_CZ.UTF-8";
    LC_TIME = "cs_CZ.UTF-8";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.letur = {
    isNormalUser = true;
    description = "Letur Berakler";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      alacritty
      gparted
      exfatprogs
      kdePackages.dolphin
      mpv
      nil
      nixd
    ];
  };

  home-manager.users.letur = {
    fonts.fontconfig.enable = true;
    home = {
      sessionVariables.TERMINAL = "alacritty";
      packages = with pkgs; [
        font-awesome # req. by waybar
        signal-desktop
      ];
    };
  };
  # Enable automatic login for the user.
  # services.getty.autologinUser = "letur";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    sessionVariables = {
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_STATE_HOME = "$HOME/.local/state";
      XDG_CONFIG_HOME = "$HOME/.config";
    };
    systemPackages = with pkgs; [
      #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      #  wget
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services = {
    openssh.enable = true;
    # desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    xserver = {
      xkb = {
        variant = "";
        layout = "us";
      };
    };

    # enable removable drive automount
    udisks2.enable = true;
  };

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
  system.stateVersion = "25.05"; # Did you read the comment?
}
