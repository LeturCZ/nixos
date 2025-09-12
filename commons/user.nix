{
  lib,
  config,
  ...
}:
with lib; {
  options = {
    home-manager.users = lib.mkOption {
      type = types.attrsOf (types.submoduleWith {
        modules = toList ({name, ...}: let
          cfg = config.home-manager.users.${name};
        in {
          options.presets = {
            browsers.librewolf = {
              enable = mkEnableOption "enable librewolf browser";
              settings = {
                clearOnShutdown = {
                  enable = mkEnableOption "enable clear on shutdown preset";
                  cache = mkOption {
                    type = "bool";
                    default = "true";
                  };
                  cookies = mkOption {
                    type = "bool";
                    default = "true";
                  };
                  forms = mkOption {
                    type = "bool";
                    default = "true";
                  };
                  OfflineApps = mkOption {
                    type = "bool";
                    default = "true";
                  };
                  sessions = mkOption {
                    type = "bool";
                    default = "true";
                  };
                  downloads = mkOption {
                    type = "bool";
                    default = "false";
                  };
                };
              };
            };
          };

          config = {
            home = {
              username = name;
              homeDirectory = "/home/${name}";
              stateVersion = "24.05";
            };
            programs = {
              librewolf = let
                lw_cfg = cfg.presets.browsers.librewolf;
              in {
                enable = cfg.presets.browsers.librewolf.enable;
                # enable = true;
                settings = mkMerge [
                  {
                    # Restore previous session on startup
                    "browser.startup.page" = 3;
                  }

                  # ( mkIf lw_cfg.settings.clearOnShutdown.enable {
                  #   # What data gets cleared on shutdown
                  #   "privacy.clearOnShutdown.cache" = mkDefault lw_cfg.settings.clearOnShutdown.cache;
                  #   "privacy.clearOnShutdown.cookies" = true;
                  #   "privacy.clearOnShutdown.formdata" = true;
                  #   "privacy.clearOnShutdown.offlineApps" = true;
                  #   "privacy.clearOnShutdown.sessions" = true;
                  #   "privacy.clearOnShutdown_v2.cache" = true;
                  #   "privacy.clearOnShutdown_v2.cookiesAndStorage" = true;
                  #   "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = true;

                  #   "privacy.clearOnShutdown.downloads" = false;
                  #   "privacy.clearOnShutdown.history" = false;
                  #   "privacy.clearOnShutdown.openWindows" = false;
                  #   "privacy.clearOnShutdown.siteSettings" = false;
                  #   "privacy.clearOnShutdown_v2.siteSettings" = false;
                  # })

                  {
                    # Only active tab has clone button
                    "browser.tabs.tabClipWidth" = 999;

                    # Less intrusive scrollbar
                    "widget.non-native-theme.scrollbar.style" = 3;

                    # Block autoplay until tab is in focus
                    "media.block-autoplay-until-in-foreground" = true;

                    # HTTPS only mode
                    "dom.security.https_only_mode" = true;

                    # Do not send background http requests
                    "dom.security.https_only_mode_send_http_background_request" = false;

                    # disable insecure active content on https pages (mixed content)
                    "security.mixed_content.block_active_content" = true;

                    # disable insecure passive content (such as images) on https pages
                    "security.mixed_content.block_display_content" = true;

                    # Try to load HTTP content as HTTPS (in mixed content pages)
                    "security.mixed_content.upgrade_display_content" = true;

                    # limit (or disable) HTTP authentication credentials dialogs triggered by sub-resources. Hardens against potential credentials phishing
                    "network.auth.subresource-http-auth-allow" = 1;

                    # display advanced information on Insecure Connection warning pages
                    "browser.xul.error_pages.expert_bad_cert" = true;

                    # enforce a security delay on some confirmation dialogs such as install, open/save
                    "security.dialog_enable_delay" = 700;

                    # Show in-content login form warning UI for insecure login fields
                    "security.insecure_field_warning.contextual.enabled" = true;

                    # show a warning that a login form is delivered via HTTP (a security risk)
                    "security.insecure_password.ui.enabled" = true;

                    # Blocks connections to servers that don't support RFC 5746 as they're potentially vulnerable to a MiTM attack
                    "security.ssl.require_safe_negotiation" = true;

                    # switching from OCSP to CRLite for checking sites certificates which has compression, is faster, and more private.
                    # 2="CRLite will enforce revocations in the CRLite filter, but still use OCSP if the CRLite filter does not indicate a revocation"
                    # (https://www.reddit.com/r/firefox/comments/wesya4/danger_of_disabling_query_ocsp_option_in_firefox/,
                    # https://blog.mozilla.org/security/2020/01/09/crlite-part-2-end-to-end-design/)
                    "security.pki.crlite_mode" = 2;

                    # 2=strict. Public key pinning prevents man-in-the-middle attacks due to rogue CAs [certificate authorities] not on the site's list
                    "security.cert_pinning.enforcement_level" = 2;

                    # Scroll with middle mouse
                    "general.autoScroll" = true;
                  }
                ];
              };
            };
          };
        });
      });
    };
  };

  # config = {
  #   users.users = mapAttrs (name: value: {
  #     # config.stylix.enable = mkIf value.common.enable true;
  #   }) config.users.users;
  # };
}
