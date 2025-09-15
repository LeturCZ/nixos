{
  pkgs,
  codium-pkgs,
  lib,
  ...
}: let
  username = "Letur";
  usernameLower = lib.strings.toLower username;
  email = "LeturCZ@seznam.cz";
in {
  presets.browsers.librewolf = {
    enable = true;
    settings = {
      clearOnShutdown.enable = true;
    };
  };

  home = {
    packages = with pkgs; [
      keepassxc
    ];
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    # inherit username;
    # homeDirectory = "/home/${username}";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    # stateVersion = "24.05";

    # Let Home Manager install and manage itself.
    # programs.home-manager.enable = true;
  };
  services = {
    syncthing = {
      enable = true;
      settings = {
        devices = {
          LeturDesktop.id = "2WC35HT-I5G3NLJ-PCOLDLZ-OAKBV47-3YD2S63-ZH46GZ4-JARYHFK-7DUMPQV";
          "Redmi Note 10".id = "7QH27PV-VIH5K3F-5K4ANMT-VH6GDTN-XSGHTXT-7GQLBIA-KCU2ORK-JTLVTQH";
        };
        folders = {
          KeePass = {
            enable = true;
            id = "yx3fz-gpus9";
            path = "~/Documents/KeePass/";
            devices = [
              "LeturDesktop"
              "Redmi Note 10"
            ];
            type = "sendreceive";
          };
          Music = {
            enable = true;
            id = "ukaqx-rgku7";
            path = "~/Music/";
            devices = [
              "LeturDesktop"
              "Redmi Note 10"
            ];
            type = "receiveonly";
          };
          VUTPersonalDrive = {
            enable = true;
            id = "jdoaw-rh4of";
            path = "~/VUTPersonalDrive";
            devices = [
              "LeturDesktop"
            ];
            type = "sendreceive";
          };
        };
        options = {
          relaysEnabled = false;
          crashreportingenabled = false;
          globalannounceenabled = false;
          natenabled = false;
          urAccepted = -1; # telemetry permission denied
        };
      };
    };
  };
  programs = {
    git = {
      enable = true;
      userEmail = email;
      userName = username;
      extraConfig.init.defaultBranch = "master";
    };
    discord = {
      enable = true;
      extraProfiles = ["VUT"];
    };
    waybar = {
      enable = true;
    };
    rofi = {
      enable = true;
      modes = [
        "drun"
      ];
      extraConfig = {
        drun-show-actions = true;
      };
    };
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default = {
        extensions = with codium-pkgs.open-vsx; [
          aaron-bond.better-comments
          jnoortheen.nix-ide
        ];
        userSettings = {
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "${pkgs.nil}/bin/nil";
          "nix.formatterPath" = "${pkgs.alejandra}/bin/alejandra";
          "git.defaultBranchName" = "master";
        };
      };
    };
  };
  # stylix = {
  #   image = ../../wallpapers/yfdFDwe.png;
  #   # enable = true;
  #   polarity = "dark";
  #   fonts = {
  #     monospace = {
  #       package = pkgs.jetbrains-mono;
  #       name = "JetBrains Mono";
  #     };
  #   };
  #   targets = {
  #     kde.enable = false;
  #   };
  # };
}
