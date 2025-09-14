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
  services.syncthing = {
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
    # firefox = {
    #   enable = true;
    #   package = pkgs.librewolf;
    # };
    # librewolf = {
    #   enable = true;
    #   settings = {
    #     # Restore previous session on startup
    #     "browser.startup.page" = 3;

    #     # What data gets cleared on shutdown
    #     "privacy.clearOnShutdown.cache" = true;
    #     "privacy.clearOnShutdown.cookies" = true;
    #     "privacy.clearOnShutdown.formdata" = true;
    #     "privacy.clearOnShutdown.offlineApps" = true;
    #     "privacy.clearOnShutdown.sessions" = true;
    #     "privacy.clearOnShutdown_v2.cache" = true;
    #     "privacy.clearOnShutdown_v2.cookiesAndStorage" = true;
    #     "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = true;

    #     "privacy.clearOnShutdown.downloads" = false;
    #     "privacy.clearOnShutdown.history" = false;
    #     "privacy.clearOnShutdown.openWindows" = false;
    #     "privacy.clearOnShutdown.siteSettings" = false;
    #     "privacy.clearOnShutdown_v2.siteSettings" = false;

    #     # Only active tab has clone button
    #     "browser.tabs.tabClipWidth" = 999;

    #     # Less intrusive scrollbar
    #     "widget.non-native-theme.scrollbar.style" = 3;

    #     # Block autoplay until tab is in focus
    #     "media.block-autoplay-until-in-foreground" = true;

    #     # HTTPS only mode
    #     "dom.security.https_only_mode" = true;

    #     # Do not send background http requests
    #     "dom.security.https_only_mode_send_http_background_request" = false;

    #     # disable insecure active content on https pages (mixed content)
    #     "security.mixed_content.block_active_content" = true;

    #     # disable insecure passive content (such as images) on https pages
    #     "security.mixed_content.block_display_content" = true;

    #     # Try to load HTTP content as HTTPS (in mixed content pages)
    #     "security.mixed_content.upgrade_display_content" = true;

    #     # limit (or disable) HTTP authentication credentials dialogs triggered by sub-resources. Hardens against potential credentials phishing
    #     "network.auth.subresource-http-auth-allow" = 1;

    #     # display advanced information on Insecure Connection warning pages
    #     "browser.xul.error_pages.expert_bad_cert" = true;

    #     # enforce a security delay on some confirmation dialogs such as install, open/save
    #     "security.dialog_enable_delay" = 700;

    #     # Show in-content login form warning UI for insecure login fields
    #     "security.insecure_field_warning.contextual.enabled" = true;

    #     # show a warning that a login form is delivered via HTTP (a security risk)
    #     "security.insecure_password.ui.enabled" = true;

    #     # Blocks connections to servers that don't support RFC 5746 as they're potentially vulnerable to a MiTM attack
    #     "security.ssl.require_safe_negotiation" = true;

    #     # switching from OCSP to CRLite for checking sites certificates which has compression, is faster, and more private.
    #     # 2="CRLite will enforce revocations in the CRLite filter, but still use OCSP if the CRLite filter does not indicate a revocation"
    #     # (https://www.reddit.com/r/firefox/comments/wesya4/danger_of_disabling_query_ocsp_option_in_firefox/,
    #     # https://blog.mozilla.org/security/2020/01/09/crlite-part-2-end-to-end-design/)
    #     "security.pki.crlite_mode" = 2;

    #     # 2=strict. Public key pinning prevents man-in-the-middle attacks due to rogue CAs [certificate authorities] not on the site's list
    #     "security.cert_pinning.enforcement_level" = 2;

    #     # Scroll with middle mouse
    #     "general.autoScroll" = true;
    #   };
    # };
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
