{
  lib,
  config,
  pkgs,
  miscFiles,
  ...
}:
with lib; {
  options = {
    home-manager.users = lib.mkOption {
      type = types.attrsOf (
        types.submoduleWith {
          modules = toList ({name, ...}: let
            cfg = config.home-manager.users.${name};
            cfgLibrewolf = cfg.presets.browsers.librewolf;
          in {
            options.presets = with types; {
              browsers.librewolf = {
                enable = mkEnableOption "enable librewolf browser";
                defaultProfileName = mkOption {
                  type = str;
                  default = "default";
                };
                averageUserMode = mkOption {
                  type = bool;
                  default = false;
                };
                settings = {
                  startupPageRestore = mkOption {
                    type = bool;
                    default = true;
                  };
                  resistFingerprinting = mkOption {
                    type = bool;
                    default = false;
                  };
                  hideTabCloseButtons = mkOption {
                    type = bool;
                    default = true;
                  };
                  smallScrollBar = mkOption {
                    type = bool;
                    default = true;
                  };
                  searchSuggestions = {
                    enable = mkOption {
                      type = bool;
                      default = false;
                    };
                    enablePrivateWindows = mkOption {
                      type = bool;
                      default = false;
                    };
                    addons = mkOption {
                      type = bool;
                      default = false;
                    };
                    bookmarks = mkOption {
                      type = bool;
                      default = false;
                    };
                    calculator = mkOption {
                      type = bool;
                      default = true;
                    };
                    clipboard = mkOption {
                      type = bool;
                      default = false;
                    };
                    engines = mkOption {
                      type = bool;
                      default = false;
                    };
                    history = mkOption {
                      type = bool;
                      default = false;
                    };
                    openpage = mkOption {
                      type = bool;
                      default = false;
                    };
                    pocket = mkOption {
                      type = bool;
                      default = false;
                    };
                    disableSpamSuggestions = mkOption {
                      type = bool;
                      default = true;
                    };
                    unitConversions = mkOption {
                      type = bool;
                      default = true;
                    };
                  };
                  security = {
                    httpsOnly = mkOption {
                      type = bool;
                      default = true;
                    };
                    advancedBadCertMenu = mkOption {
                      type = bool;
                      default = true;
                    };
                    confirmationDelay = mkOption {
                      type = int;
                      default = 700;
                    };
                    additionalInsecureLoginWarnings = mkOption {
                      type = bool;
                      default = true;
                    };
                    requireSslSafeNegotiation = mkOption {
                      type = bool;
                      default = true;
                    };
                    preferCrliteToOscp = mkOption {
                      type = bool;
                      default = true;
                    };
                    strictCertificatePinning = mkOption {
                      type = bool;
                      default = true;
                    };
                  };
                  blockAutoplayInBackground = mkOption {
                    type = bool;
                    default = true;
                  };
                  middleMouseScroll = mkOption {
                    type = bool;
                    default = true;
                  };
                  openUrlBarInNewTab = mkOption {
                    type = bool;
                    default = false;
                  };
                  disableFullscreenWarning = mkOption {
                    type = bool;
                    default = true;
                  };
                  disableFullscreenTransitionAnimation = mkOption {
                    type = bool;
                    default = true;
                  };
                  selectLastSpaceOnWordSelect = mkOption {
                    type = bool;
                    default = false;
                  };
                  warnOnClose = mkOption {
                    type = bool;
                    default = false;
                  };
                  enableJpegxl = mkOption {
                    type = bool;
                    default = true;
                  };
                  clearOnShutdown = {
                    enable = mkEnableOption "enable clear on shutdown preset";
                    cache = mkOption {
                      type = bool;
                      default = true;
                    };
                    cookies = mkOption {
                      type = bool;
                      default = true;
                    };
                    forms = mkOption {
                      type = bool;
                      default = true;
                    };
                    offlineApps = mkOption {
                      type = bool;
                      default = true;
                    };
                    sessions = mkOption {
                      type = bool;
                      default = true;
                    };
                    downloads = mkOption {
                      type = bool;
                      default = false;
                    };
                    history = mkOption {
                      type = bool;
                      default = false;
                    };
                    openWindows = mkOption {
                      type = bool;
                      default = false;
                    };
                    siteSettings = mkOption {
                      type = bool;
                      default = false;
                    };
                  };
                };
              };
            };

            config = {
              xdg.mimeApps.associations.added = {
                "application/pdf" = ["librewolf.desktop"];
              };

              home = {
                username = name;
                homeDirectory = "/home/${name}";
                stateVersion = "24.05";
              };
              programs = {
                firefox = {
                  enable = mkDefault cfgLibrewolf.enable;
                  vendorPath = null;
                  configPath = ".librewolf";

                  # I can't believe this actually works
                  package = pkgs.librewolf.override {
                    extraPoliciesFiles = [];
                  };

                  profiles.${cfgLibrewolf.defaultProfileName} = {
                    isDefault = true;
                    id = 0;
                    extensions = {
                      force = true; # req. by stylix
                      packages = with pkgs.nur.repos.rycee.firefox-addons; [
                        betterttv
                        canvasblocker
                        darkreader
                        firemonkey
                        floccus
                        keepassxc-browser
                        offline-qr-code-generator
                        redirector
                        return-youtube-dislikes
                        sponsorblock
                        terms-of-service-didnt-read
                        ublock-origin
                      ];
                    };
                    search = {
                      force = true;
                      default = "StartPage search";
                      privateDefault = "StartPage search";
                      engines = let
                        icons = miscFiles.images.searchEngineFavicons;
                      in {
                        "StartPage search" = {
                          urls = [
                            {
                              template = "https://www.startpage.com/sp/search";
                              params = [
                                {
                                  name = "query";
                                  value = "{searchTerms}";
                                }
                                {
                                  name = "prfe";
                                  value = "bc9ac18d42c87d59fd9437c8c46cf1c059018caae730e9f0f98a24e0a78d0eb4cbf198c27a4b2110905fb3c56a35045b4878808077752b63177f5742459c99f853a82afefa4a1d00b4e7f40794aa22";
                                }
                              ];
                            }
                          ];
                          icon = "https://www.startpage.com/favicon.ico";
                          updateInterval = 24 * 60 * 60 * 1000;
                          definedAliases = ["sp" "@startpage"];
                        };
                        "Youtube" = {
                          urls = [
                            {
                              template = "https://www.youtube.com/results";
                              params = [
                                {
                                  name = "search_query";
                                  value = "{searchTerms}";
                                }
                              ];
                            }
                          ];
                          icon = icons.youtube;
                          definedAliases = ["yt" "@youtube"];
                        };
                        "Youtube channel" = {
                          urls = [{template = "https://youtube.com/@{searchTerms}";}];
                          icon = icons.youtube;
                          definedAliases = ["ytc" "@youtubechannel"];
                        };
                        "Youtube live" = {
                          urls = [{template = "https://www.youtube.com/@{searchTerms}/live";}];
                          icon = icons.youtube;
                          definedAliases = ["ytl" "ytlive" "@youtubelive"];
                        };
                        "Youtube video" = {
                          urls = [
                            {
                              template = "https://www.youtube.com/watch";
                              params = [
                                {
                                  name = "v";
                                  value = "{searchTerms}";
                                }
                              ];
                            }
                          ];
                          icon = icons.youtube;
                          definedAliases = ["ytv" "@youtubevideo"];
                        };
                        "Steam" = {
                          urls = [
                            {
                              template = "https://store.steampowered.com/search/";
                              params = [
                                {
                                  name = "term";
                                  value = "{searchTerms}";
                                }
                              ];
                            }
                          ];
                          icon = icons.steam;
                          definedAliases = ["st" "@steam"];
                        };
                        "SteamDB" = {
                          urls = [
                            {
                              template = "https://steamdb.info/search/";
                              params = [
                                {
                                  name = "a";
                                  value = "all";
                                }
                                {
                                  name = "q";
                                  value = "{searchTerms}";
                                }
                              ];
                            }
                          ];
                          icon = icons.steamdb;
                          definedAliases = ["stdb" "@steamdb"];
                        };
                        "Wikipedia" = {
                          urls = [
                            {
                              template = "https://en.wikipedia.org/w/index.php";
                              params = [
                                {
                                  name = "search";
                                  value = "{searchTerms}";
                                }
                              ];
                            }
                          ];
                          icon = icons.wikipedia;
                          definedAliases = ["wiki" "@wikipedia"];
                        };
                        "Wikipedia (cs)" = {
                          urls = [
                            {
                              template = "https://cs.wikipedia.org/w/index.php";
                              params = [
                                {
                                  name = "search";
                                  value = "{searchTerms}";
                                }
                              ];
                            }
                          ];
                          icon = icons.wikipedia;
                          definedAliases = ["cswiki" "@cswikipedia"];
                        };
                        "Twitch" = {
                          urls = [{template = "https://www.twitch.tv/{searchTerms}";}];
                          icon = icons.twitch;
                          definedAliases = ["tw" "@twitch"];
                        };
                        "Alza" = {
                          urls = [
                            {
                              template = "https://www.alza.cz/search.htm";
                              params = [
                                {
                                  name = "exps";
                                  value = "{searchTerms}";
                                }
                              ];
                            }
                          ];
                          icon = "https://alza.cz/favicon.ico";
                          updateInterval = 24 * 60 * 60 * 1000;
                          definedAliases = ["alza" "@alza"];
                        };
                        "IMDb" = {
                          urls = [
                            {
                              template = "https://www.imdb.com/find/";
                              params = [
                                {
                                  name = "q";
                                  value = "{searchTerms}";
                                }
                              ];
                            }
                          ];
                          icon = "https://imdb.com/favicon.ico";
                          updateInterval = 24 * 60 * 60 * 1000;
                          definedAliases = ["imdb" "@imdb"];
                        };
                        "Know Your Meme" = {
                          urls = [
                            {
                              template = "https://knowyourmeme.com/search";
                              params = [
                                {
                                  name = "q";
                                  value = "{searchTerms}";
                                }
                              ];
                            }
                          ];
                          icon = "https://knowyourmeme.com/favicon.ico";
                          updateInterval = 24 * 60 * 60 * 1000;
                          definedAliases = ["meme" "@knowyourmeme"];
                        };
                        "Nix Packages" = {
                          urls = [
                            {
                              template = "https://search.nixos.org/packages";
                              params = [
                                {
                                  name = "channel";
                                  value = "unstable";
                                }
                                {
                                  name = "size";
                                  value = "50";
                                }
                                {
                                  name = "type";
                                  value = "packages";
                                }
                                {
                                  name = "sort";
                                  value = "relevance";
                                }
                                {
                                  name = "query";
                                  value = "{searchTerms}";
                                }
                              ];
                            }
                          ];
                          icon = icons.nix;
                          definedAliases = ["nixpkgs" "@nixpkgs"];
                        };
                        "Nix Options" = {
                          urls = [
                            {
                              template = "https://search.nixos.org/options";
                              params = [
                                {
                                  name = "channel";
                                  value = "unstable";
                                }
                                {
                                  name = "size";
                                  value = "50";
                                }
                                {
                                  name = "type";
                                  value = "packages";
                                }
                                {
                                  name = "sort";
                                  value = "relevance";
                                }
                                {
                                  name = "query";
                                  value = "{searchTerms}";
                                }
                              ];
                            }
                          ];
                          icon = icons.nix;
                          definedAliases = ["nixopts" "@nixopts"];
                        };
                        "Home Manager options" = {
                          urls = [
                            {
                              template = "https://home-manager-options.extranix.com/";
                              params = [
                                {
                                  name = "query";
                                  value = "{searchTerms}";
                                }
                                {
                                  name = "release";
                                  value = "master";
                                }
                              ];
                            }
                          ];
                          icon = icons.nix;
                          definedAliases = ["hmopts" "@hmopts"];
                        };
                        "google".metaData.hidden = true;
                        "bing".metaData.hidden = true;
                        "wikipedia".metaData.hidden = true;
                      };
                    };
                    settings = mkMerge [
                      (mkIf cfgLibrewolf.settings.clearOnShutdown.enable {
                        # What data gets cleared on shutdown
                        "privacy.clearOnShutdown.cache" = mkDefault cfgLibrewolf.settings.clearOnShutdown.cache;
                        "privacy.clearOnShutdown.cookies" = mkDefault cfgLibrewolf.settings.clearOnShutdown.cookies;
                        "privacy.clearOnShutdown.formdata" = mkDefault cfgLibrewolf.settings.clearOnShutdown.forms;
                        "privacy.clearOnShutdown.offlineApps" = mkDefault cfgLibrewolf.settings.clearOnShutdown.offlineApps;
                        "privacy.clearOnShutdown.sessions" = mkDefault cfgLibrewolf.settings.clearOnShutdown.sessions;
                        "privacy.clearOnShutdown_v2.cache" = mkDefault cfgLibrewolf.settings.clearOnShutdown.cache;
                        "privacy.clearOnShutdown_v2.cookiesAndStorage" = mkDefault cfgLibrewolf.settings.clearOnShutdown.cookies;
                        "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = mkDefault cfgLibrewolf.settings.clearOnShutdown.forms;

                        "privacy.clearOnShutdown.downloads" = mkDefault cfgLibrewolf.settings.clearOnShutdown.downloads;
                        "privacy.clearOnShutdown.history" = mkDefault cfgLibrewolf.settings.clearOnShutdown.history;
                        "privacy.clearOnShutdown.openWindows" = mkDefault cfgLibrewolf.settings.clearOnShutdown.openWindows;
                        "privacy.clearOnShutdown.siteSettings" = mkDefault cfgLibrewolf.settings.clearOnShutdown.siteSettings;
                        "privacy.clearOnShutdown_v2.siteSettings" = mkDefault cfgLibrewolf.settings.clearOnShutdown.siteSettings;
                      })

                      (mkIf cfgLibrewolf.settings.security.httpsOnly {
                        # HTTPS only mode
                        "dom.security.https_only_mode" = mkDefault true;
                        # Do not send background http requests
                        "dom.security.https_only_mode_send_http_background_request" = mkDefault false;

                        # disable insecure active content on https pages (mixed content)
                        "security.mixed_content.block_active_content" = mkDefault true;

                        # disable insecure passive content (such as images) on https pages
                        "security.mixed_content.block_display_content" = mkDefault true;

                        # Try to load HTTP content as HTTPS (in mixed content pages)
                        "security.mixed_content.upgrade_display_content" = mkDefault true;

                        # limit (or disable) HTTP authentication credentials dialogs triggered by sub-resources. Hardens against potential credentials phishing
                        "network.auth.subresource-http-auth-allow" = mkDefault 1;
                      })

                      # disable warning popup on entering fullscreen
                      (mkIf cfgLibrewolf.settings.disableFullscreenWarning {
                        "full-screen-api.warning.timeout" = mkDefault 0;
                        "full-screen-api.warning.delay" = mkDefault "-1";
                      })

                      # disable warning popup on entering fullscreen
                      (mkIf cfgLibrewolf.settings.disableFullscreenTransitionAnimation {
                        "full-screen-api.transition-duration.enter" = mkDefault "0 0";
                        "full-screen-api.transition-duration.leave" = mkDefault "0 0";
                        "full-screen-api.transition.timeout" = mkDefault 0;
                      })

                      # Block autoplay until tab is in focus
                      (mkIf cfgLibrewolf.settings.blockAutoplayInBackground {
                        "media.block-autoplay-until-in-foreground" = mkDefault true;
                        "media.block-play-until-document-interaction" = mkDefault true;
                        "media.block-play-until-visible" = mkDefault true;
                      })

                      {
                        # disable resistFingerprinting (blocks dark theme for some reason)
                        "privacy.resistFingerprinting" = cfg.settings.resistFingerprinting;

                        # auto enable extensions
                        "extensions.autoDisableScopes" = 0;

                        # Open urlbar results in new tabs
                        "browser.urlbar.openintab" = mkDefault cfg.settings.openUrlBarInNewTab;

                        # Restore previous session on startup
                        "browser.startup.page" = mkIf cfg.settings.startupPageRestore (mkDefault 3);

                        # Only active tab has clone button
                        "browser.tabs.tabClipWidth" = mkIf cfg.settings.hideTabCloseButtons (mkDefault 999);

                        # Less intrusive scrollbar
                        "widget.non-native-theme.scrollbar.style" = mkIf cfg.settings.smallScrollBar (mkDefault 3);

                        # display advanced information on Insecure Connection warning pages
                        "browser.xul.error_pages.expert_bad_cert" = mkDefault cfg.settings.security.advancedBadCertMenu;

                        # enforce a security delay on some confirmation dialogs such as install, open/save
                        "security.dialog_enable_delay" = mkDefault cfg.settings.security.confirmationDelay;

                        # Show in-content login form warning UI for insecure login fields
                        "security.insecure_field_warning.contextual.enabled" = mkDefault cfg.settings.security.additionalInsecureLoginWarnings;

                        # show a warning that a login form is delivered via HTTP (a security risk)
                        "security.insecure_password.ui.enabled" = mkDefault cfg.settings.security.additionalInsecureLoginWarnings;

                        # Blocks connections to servers that don't support RFC 5746 as they're potentially vulnerable to a MiTM attack
                        "security.ssl.require_safe_negotiation" = mkDefault cfg.settings.security.requireSslSafeNegotiation;

                        # switching from OCSP to CRLite for checking sites certificates which has compression, is faster, and more private.
                        # 2="CRLite will enforce revocations in the CRLite filter, but still use OCSP if the CRLite filter does not indicate a revocation"
                        # (https://www.reddit.com/r/firefox/comments/wesya4/danger_of_disabling_query_ocsp_option_in_firefox/,
                        # https://blog.mozilla.org/security/2020/01/09/crlite-part-2-end-to-end-design/)
                        "security.pki.crlite_mode" = mkIf cfg.settings.security.preferCrliteToOscp (mkDefault 2);

                        # 2=strict. Public key pinning prevents man-in-the-middle attacks due to rogue CAs [certificate authorities] not on the site's list
                        "security.cert_pinning.enforcement_level" = mkIf cfg.settings.security.strictCertificatePinning (mkDefault 2);

                        # Scroll with middle mouse
                        "general.autoScroll" = mkDefault cfg.settings.middleMouseScroll;

                        # Select the space after the last word when double-click selecting
                        "layout.word_select.eat_space_to_next_word" = mkDefault cfg.settings.selectLastSpaceOnWordSelect;

                        # Display warning when closing a window
                        "browser.tabs.warnOnClose" = mkDefault cfg.settings.warnOnClose;

                        # Enable JpegXL support
                        "image.jxl.enabled" = mkDefault cfg.settings.enableJpegxl;

                        # Urlbar suggestions
                        "browser.search.suggest.enabled" = mkDefault cfg.settings.searchSuggestions.enable;
                        "browser.search.suggest.enabled.private" = mkDefault cfg.settings.searchSuggestions.enablePrivateWindows;
                        "browser.urlbar.suggest.bookmark" = mkDefault cfg.settings.searchSuggestions.bookmarks;
                        "browser.urlbar.suggest.calculator" = mkDefault cfg.settings.searchSuggestions.calculator;
                        "browser.urlbar.suggest.clipboard" = mkDefault cfg.settings.searchSuggestions.clipboard;
                        "browser.urlbar.suggest.engines" = mkDefault cfg.settings.searchSuggestions.engines;
                        "browser.urlbar.suggest.history" = mkDefault cfg.settings.searchSuggestions.history;
                        "browser.urlbar.suggest.openpage" = mkDefault cfg.settings.searchSuggestions.openpage;
                        "browser.urlbar.suggest.pocket" = mkDefault cfg.settings.searchSuggestions.pocket;
                        "browser.urlbar.unitConversion.enabled" = mkDefault cfg.settings.searchSuggestions.unitConversions;
                        "browser.urlbar.suggest.addons" = mkDefault cfg.settings.searchSuggestions.addons;

                        # Dark theme
                        "extensions.activeThemeID" = mkIf (! cfg.stylix.targets.firefox.enable) "firefox-compact-dark@mozilla.org";
                        "lightweightThemes.selectedThemeID" = mkIf (! cfg.stylix.targets.firefox.enable) "firefox-compact-dark@mozilla.org";
                        "browser.theme.content-theme" = 0;
                        "browser.theme.toolbar-theme" = 0;
                      }
                    ];
                  };
                  policies = mkMerge [
                    {
                      "3rdparty".Extensions = {
                        # extension settings
                        "uBlock0@raymondhill.net".adminSettings = {
                          disableDashboard = false;
                          toOverwrite = {
                            filters = [
                              "www.tumblr.com##.gdpr-banner"
                              "www.instagram.com##.xzkaem6.x1n2onr6"
                            ];
                            filterLists = [
                              # https://github.com/gorhill/uBlock/blob/master/assets/assets.json
                              "user-filters"

                              # uBlock filters
                              "ublock-filters" # uBlock filters – Ads
                              "ublock-badware" # uBlock filters – Badware risks
                              "ublock-privacy" # uBlock filters – Privacy
                              "ublock-quick-fixes" # uBlock filters – Quick fixes
                              "ublock-unbreak" # uBlock filters – Unbreak

                              # Ads
                              "easylist" # EasyList
                              "adguard-generic" # AdGuard – Ads
                              "adguard-mobile" # AdGuard – Mobile Ads

                              # Privacy
                              "easyprivacy" # EasyPrivacy
                              "LegitimateURLShortener" # ➗ Actually Legitimate URL Shortener Tool
                              "adguard-spyware" # AdGuard Tracking Protection
                              "adguard-spyware-url" # AdGuard URL Tracking Protection
                              "block-lan" # Block Outsider Intrusion into LAN

                              # Malware protection, security
                              "urlhaus-1" # Online Malicious URL Blocklist
                              "curben-phishing" # Phishing URL Blocklist

                              # Multipurpose
                              "plowe-0" # Peter Lowe’s Ad and tracking server list
                              "dpollock-0" # Dan Pollock’s hosts file

                              # Cookie notices
                              "adguard-cookies" # AdGuard – Cookie Notices
                              "ublock-cookies-adguard" # uBlock filters – Cookie Notices

                              # Social widgets
                              # "fanboy-social" # EasyList – Social Widgets
                              "adguard-social" # AdGuard – Social Widgets
                              "fanboy-thirdparty_social" # Fanboy – Anti-Facebook

                              # Annoyances
                              "adguard-mobile-app-banners" # AdGuard – Mobile App Banners
                              "adguard-other-annoyances" # AdGuard – Other Annoyances
                              "adguard-popup-overlays" # AdGuard – Popup Overlays
                              "adguard-widgets" # AdGuard – Widgets
                              "ublock-annoyances" # uBlock filters – Annoyances

                              # Regions, languages
                              "CZE-0" #  [cz]  cz [sk]  sk: EasyList Czech and Slovak
                            ];
                          };
                        };
                      };
                      ExtensionUpdate = false; # don't allow extensions autoupdate
                      AppUpdateURL = "https://localhost";
                      DisableAppUpdate = true;
                      OverrideFirstRunPage = "";
                      OverridePostUpdatePage = "";
                      DisableSystemAddonUpdate = true;
                      DisableProfileImport = false;
                      DisableFeedbackCommands = true;
                      DisableDeveloperTools = false;
                      AutofillAddressEnabled = false;
                      AutofillCreditCardEnabled = false;
                      DisableEncryptedClientHello = false;
                      DisableMasterPasswordCreation = true;
                      DisableFirefoxAccounts = true;
                      DisableFirefoxStudies = true;
                      DisablePocket = true;
                      NoDefaultBookmarks = true;
                      DisableSetDesktopBackground = true;
                      DisableTelemetry = true;
                      DNSOverHTTPS = {
                        Enabled = true;
                        ProviderURL = "https://dns.quad9.net/dns-query";
                        Locked = true;
                        Fallback = false;
                      };
                      DontCheckDefaultBrowser = true;
                      ExtensionSettings = with pkgs.nur.repos.rycee.firefox-addons; let
                        listToExtensionAttrs = list: mode:
                          builtins.listToAttrs (lib.map (key: {
                              "name" = key;
                              "value" = {"installation_mode" = mode;};
                            })
                            list);
                      in
                        {
                          "*" = {
                            blocked_install_message = "Manual extension installs are disabled";
                            installation_mode = "blocked";
                          };
                          "firefox@betterttv.net" = {
                            installation_mode = "force_installed";
                            install_url = "file:///${betterttv}";
                            default_area = "menupanel";
                          };
                          "CanvasBlocker@kkapsner.de" = {
                            installation_mode = "force_installed";
                            install_url = "file:///${canvasblocker}";
                            default_area = "menupanel";
                            private_browsing = true;
                          };
                          "addon@darkreader.org" = {
                            installation_mode = "force_installed";
                            install_url = "file:///${darkreader}";
                            default_area = "menupanel";
                            private_browsing = true;
                          };
                          "firemonkey@eros.man" = {
                            installation_mode = "force_installed";
                            install_url = "file:///${firemonkey}";
                            default_area = "menupanel";
                            private_browsing = true;
                          };
                          "floccus@handmadeideas.org" = {
                            installation_mode = "force_installed";
                            install_url = "file:///${floccus}";
                            default_area = "menupanel";
                          };
                          "keepassxc-browser@keepassxc.org" = {
                            installation_mode = "force_installed";
                            install_url = "file:///${keepassxc-browser}";
                            default_area = "menupanel";
                            private_browsing = true;
                          };
                          "offline-qr-code@rugk.github.io" = {
                            installation_mode = "force_installed";
                            install_url = "file:///${offline-qr-code-generator}";
                            default_area = "navbar";
                            private_browsing = true;
                          };
                          "redirector@einaregilsson.com" = {
                            installation_mode = "force_installed";
                            install_url = "file:///${redirector}";
                            default_area = "menupanel";
                            private_browsing = true;
                          };
                          "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = {
                            installation_mode = "force_installed";
                            install_url = "file:///${return-youtube-dislikes}";
                            default_area = "menupanel";
                          };
                          "sponsorBlocker@ajay.app" = {
                            installation_mode = "force_installed";
                            install_url = "file:///${sponsorblock}";
                            default_area = "menupanel";
                          };
                          "jid0-3GUEt1r69sQNSrca5p8kx9Ezc3U@jetpack" = {
                            installation_mode = "force_installed";
                            install_url = "file:///${terms-of-service-didnt-read}";
                            default_area = "navbar";
                          };
                          "uBlock0@raymondhill.net" = {
                            installation_mode = "force_installed";
                            install_url = "file:///${ublock-origin}";
                            default_area = "navbar";
                            private_browsing = true;
                          };
                        } # // (listToExtensionAttrs ["uBlock0@raymondhill.net"]) "force_installed"
                        // (listToExtensionAttrs [
                          "google@search.mozilla.org"
                          "bing@search.mozilla.org"
                          "amazondotcom@search.mozilla.org"
                          "ebay@search.mozilla.org"
                          "twitter@search.mozilla.org"
                        ]) "blocked";

                      SearchEngines.Remove = ["Google" "Bing" "Wikipedia (en)" "MetaGer" "DuckDuckGo Lite" "DuckDuckGo"];
                    }

                    (mkIf cfgLibrewolf.averageUserMode {
                      # BlockAboutAddons = true;
                      # BlockAboutConfig = true;
                      BlockAboutProfiles = true;
                      BlockAboutSupport = true;
                    })
                  ];
                };
              };
              wayland.windowManager.hyprland.settings.windowrule = mkIf cfg.wayland.windowManager.hyprland.enable [
                "float, class:librewolf, title:Picture-in-Picture"
                "pin, class:librewolf, title:Picture-in-Picture"
              ];
            };
          });
        }
      );
    };
  };
}
