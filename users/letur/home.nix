{
  pkgs,
  codium-pkgs,
  lib,
  inputs,
  ...
}: let
  username = "Letur";
  usernameLower = lib.strings.toLower username;
  email = "LeturCZ@seznam.cz";
in rec {
  presets.browsers.librewolf = {
    enable = true;
    settings = {
      clearOnShutdown.enable = true;
    };
  };

  xdg = {
    enable = true;
    stateHome = "/home/${usernameLower}/.local/state";
    cacheHome = "/home/${usernameLower}/.cache";
    configHome = "/home/${usernameLower}/.config";
    dataHome = "/home/${usernameLower}/.local/share";
    terminal-exec = {
      enable = true;
      settings.default = [
        "Alacritty.desktop"
      ];
    };
    desktopEntries.codium = {
      name = "VSCodium";
      genericName = "Text Editor";
      comment = "Code Editing. Redefined.";
      exec = "codium --enable-features=UseOzonePlatform --ozone-platform=wayland %F";
      terminal = false;
      categories = [
        "Utility"
        "TextEditor"
        "Development"
        "IDE"
      ];
      icon = "vscodium";
      type = "Application";
      settings = {
        StartupWMClass = "vscodium";
        StartupNotify = "true";
        Keywords = "vscode";
      };
      actions.new-empty-window = {
        name = "New Empty Window";
        exec = "codium --new-window --enable-features=UseOzonePlatform --ozone-platform=wayland %F";
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    autoRotate = true;
    settings = {
      monitor = "eDP-1,preferred,auto,1.25,transform,0";
      input = {
        kb_layout = home.keyboard.layout;
        kb_variant = home.keyboard.variant;
      };
      /*
      l -> locked, will also work when an input inhibitor (e.g. a lockscreen) is active.
      r -> release, will trigger on release of a key.
      c -> click, will trigger on release of a key or button as long as the mouse cursor stays inside binds:drag_threshold.
      g -> drag, will trigger on release of a key or button as long as the mouse cursor moves outside binds:drag_threshold.
      o -> longPress, will trigger on long press of a key.
      e -> repeat, will repeat when held.
      n -> non-consuming, key/mouse events will be passed to the active window in addition to triggering the dispatcher.
      m -> mouse, see below.
      t -> transparent, cannot be shadowed by other binds.
      i -> ignore mods, will ignore modifiers.
      s -> separate, will arbitrarily combine keys between each mod/key, see [Keysym combos](#keysym-combos) above.
      d -> has description, will allow you to write a description for your bind.
      p -> bypasses the app's requests to inhibit keybinds.
      */
      # drag_threshold = 10; # cursor distance where a click is considered a drag

      binds = [
      ];

      bind =
        [
          "CTRL_ALT, T, exec, alacritty"
          "SUPER, E, exec, dolphin --new-window ~/"
          "SUPER, F, fullscreen, 1"
          "SUPER_ALT, F, fullscreen, 0"
          "ALT, F4, killactive"
          "ALT, F2, exec, rofi -show drun"
          "CTRL_ALT, right, workspace, +1"
          "CTRL_ALT, left, workspace, -1"
          "SUPER, left, movefocus, l"
          "SUPER, right, movefocus, r"
          "SUPER, up, movefocus, u"
          "SUPER, down, movefocus, d"
          "SUPER_ALT, right, workspace, +1"
          "SUPER_CTRL, right, movetoworkspace, +1"
          "SUPER_ALT, left, workspace, -1"
          "SUPER_CTRL, left, movetoworkspace, -1"
        ]
        # Workspace number bindings
        ++ lib.lists.concatMap
        (input: [
          "SUPER_ALT, ${input}, workspace, ${input}"
          "SUPER_CTRL, ${input}, movetoworkspacesilent, ${input}"
        ])
        ["1" "2" "3" "4" "5" "6" "7" "8" "9" "0"];

      bindel = [
        ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl --exponent s 5%+"
        ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl --min-value=20 --exponent s 5%-"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume --limit=1 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ];

      bindl = [
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ];

      bindm = [
        "SUPER, mouse:272, movewindow"
      ];

      bindc = [
        "SUPER, mouse:272, togglefloating"
      ];

      xwayland.force_zero_scaling = true;
      input.touchpad.natural_scroll = true;
      env = [
        "XCURSOR_SIZE,16"
        "GDK_SCALE,1.25"
      ];
    };
  };

  home = {
    keyboard = {
      layout = "cz";
      variant = "coder";
    };

    packages = with pkgs;
    with inputs; [
      nix-index-database.outputs.packages.x86_64-linux.comma-with-db
      styluslabs-write
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
    # enable removable drive automount
    udiskie.enable = true;

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
          Logseq = {
            enable = true;
            id = "fd7yt-qguj5";
            path = "~/Documents/Logseq";
            devices = [
              "LeturDesktop"
              "Redmi Note 10"
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
    keepassxc.enable = true;
    fsearch.enable = true;
    libreoffice.enable = true;
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
        languageSnippets = {
          nix = {
            mod = {
              body = [
                "{"
                "  config,"
                "  lib,"
                "  ..."
                "}:"
                "with lib;"
                "{"
                "  options = {"
                "  };"
                "  config = {"
                "  };"
                "}"
              ];
              description = "A NixOS module";
              prefix = [
                "mod"
              ];
            };
            submod = {
              body = [
                "\${1:path} = lib.mkOption {"
                "  type = types.attrsOf ("
                "    types.submoduleWith {"
                "      modules = toList ("
                "        { \${2:name}, ... }:"
                "        let"
                "          cfg = config.\${1:path}.$\{\${2:name}};"
                "        in"
                "        {"
                "          options = {"
                "          };"
                "          config = {"
                "          };"
                "        }"
                "      );"
                "    }"
                "  );"
                "};"
              ];
              description = "A nix submodule";
              prefix = [
                "submod"
              ];
            };
          };
        };
      };
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface".icon-theme = stylix.iconTheme.dark;
  };

  stylix = {
    # image = ../../wallpapers/yfdFDwe.png;
    enable = true;

    # https://tinted-theming.github.io/tinted-gallery/
    base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
    
    polarity = "dark";
    # fonts = {
    #   monospace = {
    #     package = pkgs.jetbrains-mono;
    #     name = "JetBrains Mono";
    #   };
    # };
    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus";
    };
  };
}
