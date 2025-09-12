# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  home-manager,
  pkgs,
  inputs,
  system,
  ...
}: {
  home-manager.useGlobalPkgs = true;

  imports = [];
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    experimental-features = ["nix-command" "flakes"];
  };

  # # stylix.enable = true;
  # stylix.image = ../../wallpapers/yfdFDwe.png;
  # stylix.polarity = "dark";

  programs = {
    # hyprland.enable = true;
  };

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
  #boot.loader.grub.enable = true;
  #boot.loader.grub.device = "nodev";

  #boot.loader.grub.useOSProber = true;

  networking.hostName = "leturlaptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # boot.initrd.systemd.enable = true;

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

  publicuser.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.letur = {
    isNormalUser = true;
    description = "Letur Berakler";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [alacritty gparted kdePackages.dolphin mpv];
  };

  # Enable automatic login for the user.
  # services.getty.autologinUser = "letur";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
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
  services = {
    openssh.enable = true;
    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    xserver = {
      xkb = {
        variant = "";
        layout = "us";
        # layout = "cz-qwerty,us";
      };
    };
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
  system.stateVersion = "24.05"; # Did you read the comment?
}
