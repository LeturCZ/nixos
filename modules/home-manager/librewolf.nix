{
  lib,
  config,
  pkgs,
  ...
}:
with lib; {
  options = {
    home-manager.users = lib.mkOption {
      type = types.attrsOf (
        types.submoduleWith {
          modules = toList ({name, ...}: let
            cfg = config.home-manager.users.${name}.presets.browsers.librewolf;
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
              home = {
                username = name;
                homeDirectory = "/home/${name}";
                stateVersion = "24.05";
              };
              programs = {
                firefox = {
                  enable = mkDefault cfg.enable;
                  vendorPath = null;
                  configPath = ".librewolf";

                  # I can't believe this actually works
                  package = pkgs.librewolf.override {
                    extraPoliciesFiles = [];
                  };

                  profiles.${cfg.defaultProfileName} = {
                    isDefault = true;
                    id = 0;
                    extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
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
                    search = {
                      force = true;
                      default = "StartPage search";
                      privateDefault = "StartPage search";
                      engines = let
                        icons = {
                          nix = "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB2aWV3Qm94PSIwIDAgNTUwLjQxNiA0ODQuMzE3IiBoZWlnaHQ9IjUxNi42MDQiIHdpZHRoPSI1ODcuMTEiPjxkZWZzPjxsaW5lYXJHcmFkaWVudCBpZD0iYSI+PHN0b3Agb2Zmc2V0PSIwIiBzdHlsZT0ic3RvcC1jb2xvcjojNjk5YWQ3O3N0b3Atb3BhY2l0eToxIi8+PHN0b3Agc3R5bGU9InN0b3AtY29sb3I6IzdlYjFkZDtzdG9wLW9wYWNpdHk6MSIgb2Zmc2V0PSIuMjQzIi8+PHN0b3Agb2Zmc2V0PSIxIiBzdHlsZT0ic3RvcC1jb2xvcjojN2ViYWU0O3N0b3Atb3BhY2l0eToxIi8+PC9saW5lYXJHcmFkaWVudD48bGluZWFyR3JhZGllbnQgaWQ9ImIiPjxzdG9wIG9mZnNldD0iMCIgc3R5bGU9InN0b3AtY29sb3I6IzQxNWU5YTtzdG9wLW9wYWNpdHk6MSIvPjxzdG9wIHN0eWxlPSJzdG9wLWNvbG9yOiM0YTZiYWY7c3RvcC1vcGFjaXR5OjEiIG9mZnNldD0iLjIzMiIvPjxzdG9wIG9mZnNldD0iMSIgc3R5bGU9InN0b3AtY29sb3I6IzUyNzdjMztzdG9wLW9wYWNpdHk6MSIvPjwvbGluZWFyR3JhZGllbnQ+PGxpbmVhckdyYWRpZW50IHkyPSI1MDYuMTg4IiB4Mj0iMjkwLjA4NyIgeTE9IjM1MS40MTEiIHgxPSIyMDAuNTk3IiBncmFkaWVudFRyYW5zZm9ybT0idHJhbnNsYXRlKDcwLjY1IC0xMDU1LjE1MSkiIGdyYWRpZW50VW5pdHM9InVzZXJTcGFjZU9uVXNlIiBpZD0iYyIgeGxpbms6aHJlZj0iI2EiLz48bGluZWFyR3JhZGllbnQgeTI9IjkzNy43MTQiIHgyPSItNDk2LjI5NyIgeTE9Ijc4Mi4zMzYiIHgxPSItNTg0LjE5OSIgZ3JhZGllbnRUcmFuc2Zvcm09InRyYW5zbGF0ZSg4NjQuNjk2IC0xNDkxLjM0KSIgZ3JhZGllbnRVbml0cz0idXNlclNwYWNlT25Vc2UiIGlkPSJlIiB4bGluazpocmVmPSIjYiIvPjwvZGVmcz48ZyB0cmFuc2Zvcm09InRyYW5zbGF0ZSgtMTMyLjY1MSA5NTguMDQpIiBzdHlsZT0iZGlzcGxheTppbmxpbmU7b3BhY2l0eToxIj48cGF0aCBzdHlsZT0ib3BhY2l0eToxO2ZpbGw6dXJsKCNjKTtmaWxsLW9wYWNpdHk6MTtmaWxsLXJ1bGU6ZXZlbm9kZDtzdHJva2U6bm9uZTtzdHJva2Utd2lkdGg6MztzdHJva2UtbGluZWNhcDpidXR0O3N0cm9rZS1saW5lam9pbjpyb3VuZDtzdHJva2UtbWl0ZXJsaW1pdDo0O3N0cm9rZS1kYXNoYXJyYXk6bm9uZTtzdHJva2Utb3BhY2l0eToxIiBkPSJtMzA5LjU0OS03MTAuMzg4IDEyMi4xOTcgMjExLjY3NS01Ni4xNTcuNTI3LTMyLjYyNC01Ni44Ny0zMi44NTYgNTYuNTY2LTI3LjkwMy0uMDExLTE0LjI5LTI0LjY5IDQ2LjgxLTgwLjQ5LTMzLjIzLTU3LjgyNnoiIGlkPSJkIi8+PHVzZSB4bGluazpocmVmPSIjZCIgdHJhbnNmb3JtPSJyb3RhdGUoNjAgNDA3LjExMiAtNzE1Ljc4NykiIHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjEwMCUiLz48dXNlIHhsaW5rOmhyZWY9IiNkIiB0cmFuc2Zvcm09InJvdGF0ZSgtNjAgNDA3LjMxMiAtNzE1LjcpIiB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIi8+PHVzZSB4bGluazpocmVmPSIjZCIgdHJhbnNmb3JtPSJyb3RhdGUoMTgwIDQwNy40MTkgLTcxNS43NTYpIiB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIi8+PHBhdGggaWQ9ImYiIGQ9Im0zMDkuNTQ5LTcxMC4zODggMTIyLjE5NyAyMTEuNjc1LTU2LjE1Ny41MjctMzIuNjI0LTU2Ljg3LTMyLjg1NiA1Ni41NjYtMjcuOTAzLS4wMTEtMTQuMjktMjQuNjkgNDYuODEtODAuNDktMzMuMjMtNTcuODI2eiIgc3R5bGU9ImNvbG9yOiMwMDA7Y2xpcC1ydWxlOm5vbnplcm87ZGlzcGxheTppbmxpbmU7b3ZlcmZsb3c6dmlzaWJsZTt2aXNpYmlsaXR5OnZpc2libGU7b3BhY2l0eToxO2lzb2xhdGlvbjphdXRvO21peC1ibGVuZC1tb2RlOm5vcm1hbDtjb2xvci1pbnRlcnBvbGF0aW9uOnNSR0I7Y29sb3ItaW50ZXJwb2xhdGlvbi1maWx0ZXJzOmxpbmVhclJHQjtzb2xpZC1jb2xvcjojMDAwO3NvbGlkLW9wYWNpdHk6MTtmaWxsOnVybCgjZSk7ZmlsbC1vcGFjaXR5OjE7ZmlsbC1ydWxlOmV2ZW5vZGQ7c3Ryb2tlOm5vbmU7c3Ryb2tlLXdpZHRoOjM7c3Ryb2tlLWxpbmVjYXA6YnV0dDtzdHJva2UtbGluZWpvaW46cm91bmQ7c3Ryb2tlLW1pdGVybGltaXQ6NDtzdHJva2UtZGFzaGFycmF5Om5vbmU7c3Ryb2tlLWRhc2hvZmZzZXQ6MDtzdHJva2Utb3BhY2l0eToxO2NvbG9yLXJlbmRlcmluZzphdXRvO2ltYWdlLXJlbmRlcmluZzphdXRvO3NoYXBlLXJlbmRlcmluZzphdXRvO3RleHQtcmVuZGVyaW5nOmF1dG87ZW5hYmxlLWJhY2tncm91bmQ6YWNjdW11bGF0ZSIvPjx1c2Ugc3R5bGU9ImRpc3BsYXk6aW5saW5lIiB4bGluazpocmVmPSIjZiIgdHJhbnNmb3JtPSJyb3RhdGUoMTIwIDQwNy4zNCAtNzE2LjA4NCkiIHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjEwMCUiLz48dXNlIHN0eWxlPSJkaXNwbGF5OmlubGluZSIgeGxpbms6aHJlZj0iI2YiIHRyYW5zZm9ybT0icm90YXRlKC0xMjAgNDA3LjI4OCAtNzE1Ljg3KSIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIvPjwvZz48L3N2Zz4=";
                          youtube = "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIGNsYXNzPSJleHRlcm5hbC1pY29uIiB2aWV3Qm94PSIwIDAgMjguNTcgIDIwIiBmb2N1c2FibGU9ImZhbHNlIiBzdHlsZT0icG9pbnRlci1ldmVudHM6IG5vbmU7IGRpc3BsYXk6IGJsb2NrOyB3aWR0aDogMTAwJTsgaGVpZ2h0OiAxMDAlOyI+DQogIDxzdmcgdmlld0JveD0iMCAwIDI4LjU3IDIwIiBwcmVzZXJ2ZUFzcGVjdFJhdGlvPSJ4TWlkWU1pZCBtZWV0IiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPg0KICAgIDxnPg0KICAgICAgPHBhdGggZD0iTTI3Ljk3MjcgMy4xMjMyNEMyNy42NDM1IDEuODkzMjMgMjYuNjc2OCAwLjkyNjYyMyAyNS40NDY4IDAuNTk3MzY2QzIzLjIxOTcgMi4yNDI4OGUtMDcgMTQuMjg1IDAgMTQuMjg1IDBDMTQuMjg1IDAgNS4zNTA0MiAyLjI0Mjg4ZS0wNyAzLjEyMzIzIDAuNTk3MzY2QzEuODkzMjMgMC45MjY2MjMgMC45MjY2MjMgMS44OTMyMyAwLjU5NzM2NiAzLjEyMzI0QzIuMjQyODhlLTA3IDUuMzUwNDIgMCAxMCAwIDEwQzAgMTAgMi4yNDI4OGUtMDcgMTQuNjQ5NiAwLjU5NzM2NiAxNi44NzY4QzAuOTI2NjIzIDE4LjEwNjggMS44OTMyMyAxOS4wNzM0IDMuMTIzMjMgMTkuNDAyNkM1LjM1MDQyIDIwIDE0LjI4NSAyMCAxNC4yODUgMjBDMTQuMjg1IDIwIDIzLjIxOTcgMjAgMjUuNDQ2OCAxOS40MDI2QzI2LjY3NjggMTkuMDczNCAyNy42NDM1IDE4LjEwNjggMjcuOTcyNyAxNi44NzY4QzI4LjU3MDEgMTQuNjQ5NiAyOC41NzAxIDEwIDI4LjU3MDEgMTBDMjguNTcwMSAxMCAyOC41Njc3IDUuMzUwNDIgMjcuOTcyNyAzLjEyMzI0WiIgZmlsbD0iI0ZGMDAwMCIvPg0KICAgICAgPHBhdGggZD0iTTExLjQyNTMgMTQuMjg1NEwxOC44NDc3IDEwLjAwMDRMMTEuNDI1MyA1LjcxNTMzVjE0LjI4NTRaIiBmaWxsPSJ3aGl0ZSIvPg0KICAgIDwvZz4NCiAgPC9zdmc+DQo8L3N2Zz4=";
                          steam = "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB2aWV3Qm94PSIwIDAgNjUgNjUiIGZpbGw9IiNmZmYiPjx1c2UgeGxpbms6aHJlZj0iI0IiIHg9Ii41IiB5PSIuNSIvPjxkZWZzPjxsaW5lYXJHcmFkaWVudCBpZD0iQSIgeDI9IjUwJSIgeDE9IjUwJSIgeTI9IjEwMCUiIHkxPSIwJSI+PHN0b3Agc3RvcC1jb2xvcj0iIzExMWQyZSIgb2Zmc2V0PSIwJSIvPjxzdG9wIHN0b3AtY29sb3I9IiMwNTE4MzkiIG9mZnNldD0iMjEuMiUiLz48c3RvcCBzdG9wLWNvbG9yPSIjMGExYjQ4IiBvZmZzZXQ9IjQwLjclIi8+PHN0b3Agc3RvcC1jb2xvcj0iIzEzMmU2MiIgb2Zmc2V0PSI1OC4xJSIvPjxzdG9wIHN0b3AtY29sb3I9IiMxNDRiN2UiIG9mZnNldD0iNzMuOCUiLz48c3RvcCBzdG9wLWNvbG9yPSIjMTM2NDk3IiBvZmZzZXQ9Ijg3LjMlIi8+PHN0b3Agc3RvcC1jb2xvcj0iIzEzODdiOCIgb2Zmc2V0PSIxMDAlIi8+PC9saW5lYXJHcmFkaWVudD48L2RlZnM+PHN5bWJvbCBpZD0iQiI+PGc+PHBhdGggZD0iTTEuMzA1IDQxLjIwMkM1LjI1OSA1NC4zODYgMTcuNDg4IDY0IDMxLjk1OSA2NGMxNy42NzMgMCAzMi0xNC4zMjcgMzItMzJzLTE0LjMyNy0zMi0zMi0zMkMxNS4wMDEgMCAxLjEyNCAxMy4xOTMuMDI4IDI5Ljg3NGMyLjA3NCAzLjQ3NyAyLjg3OSA1LjYyOCAxLjI3NSAxMS4zMjh6IiBmaWxsPSJ1cmwoI0EpIi8+PHBhdGggZD0iTTMwLjMxIDIzLjk4NWwuMDAzLjE1OC03LjgzIDExLjM3NWMtMS4yNjgtLjA1OC0yLjU0LjE2NS0zLjc0OC42NjJhOC4xNCA4LjE0IDAgMCAwLTEuNDk4LjhMLjA0MiAyOS44OTNzLS4zOTggNi41NDYgMS4yNiAxMS40MjRsMTIuMTU2IDUuMDE2Yy42IDIuNzI4IDIuNDggNS4xMiA1LjI0MiA2LjI3YTguODggOC44OCAwIDAgMCAxMS42MDMtNC43ODIgOC44OSA4Ljg5IDAgMCAwIC42ODQtMy42NTZMNDIuMTggMzYuMTZsLjI3NS4wMDVjNi43MDUgMCAxMi4xNTUtNS40NjYgMTIuMTU1LTEyLjE4cy01LjQ0LTEyLjE2LTEyLjE1NS0xMi4xNzRjLTYuNzAyIDAtMTIuMTU1IDUuNDYtMTIuMTU1IDEyLjE3NHptLTEuODggMjMuMDVjLTEuNDU0IDMuNS01LjQ2NiA1LjE0Ny04Ljk1MyAzLjY5NGE2Ljg0IDYuODQgMCAwIDEtMy41MjQtMy4zNjJsMy45NTcgMS42NGE1LjA0IDUuMDQgMCAwIDAgNi41OTEtMi43MTkgNS4wNSA1LjA1IDAgMCAwLTIuNzE1LTYuNjAxbC00LjEtMS42OTVjMS41NzgtLjYgMy4zNzItLjYyIDUuMDUuMDc3IDEuNy43MDMgMyAyLjAyNyAzLjY5NiAzLjcycy42OTIgMy41Ni0uMDEgNS4yNDZNNDIuNDY2IDMyLjFhOC4xMiA4LjEyIDAgMCAxLTguMDk4LTguMTEzIDguMTIgOC4xMiAwIDAgMSA4LjA5OC04LjExMSA4LjEyIDguMTIgMCAwIDEgOC4xIDguMTExIDguMTIgOC4xMiAwIDAgMS04LjEgOC4xMTNtLTYuMDY4LTguMTI2YTYuMDkgNi4wOSAwIDAgMSA2LjA4LTYuMDk1YzMuMzU1IDAgNi4wODQgMi43MyA2LjA4NCA2LjA5NWE2LjA5IDYuMDkgMCAwIDEtNi4wODQgNi4wOTMgNi4wOSA2LjA5IDAgMCAxLTYuMDgxLTYuMDkzeiIvPjwvZz48L3N5bWJvbD48L3N2Zz4=";
                          steamdb = "data:image/svg+xml;base64,PHN2ZyByb2xlPSJpbWciIHN0eWxlPSJiYWNrZ3JvdW5kLWNvbG9yOiBibGFjazsiIGZpbGw9IiNmZmZmZmYiIHZpZXdCb3g9IjAgMCAyNCAyNCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+U3RlYW1EQjwvdGl0bGU+PHBhdGggZD0iTTExLjk4MSAwQzUuNzIgMCAuNTgxIDIuMjMxLjAyIDUuMDgxbDYuNjc1IDEuMjU3Yy41NDQtLjE3IDEuMTYyLS4yNDQgMS44LS4yNDRsMy4xMzEtMS44NzVjLS4wMzctLjQ2OS4yNDQtLjk1Ni44ODEtMS4zNS45LS41ODEgMi4zMDctLjkgMy43MzItLjlhOC41ODIgOC41ODIgMCAwMTIuODEyLjQxMmMyLjEuNzEzIDIuNTY5IDIuMDgyIDEuMDY5IDMuMDU3LS45NTYuNjE4LTIuNDk0LjkzNy00LjAxMy45bC00LjEyNSAxLjQ4Yy0uMDM3LjMtLjI0My41ODItLjYzNy44NDUtMS4xMDYuNzEyLTMuMjYzLjg4LTQuOC4zNTYtLjY3NS0uMjI1LTEuMTI1LS41NjMtMS4zMTMtLjlMLjQ3IDcuMmMuNDMxLjY3NSAxLjEyNSAxLjI5NCAyLjAyNSAxLjgzOEMuOTM4IDkuOTM4IDAgMTEuMDYyIDAgMTIuMjhjMCAxLjIuOSAyLjMwNyAyLjQxOSAzLjIwNkMuOSAxNi4zNyAwIDE3LjQ3NiAwIDE4LjY3NSAwIDIxLjYxOSA1LjM2MyAyNCAxMiAyNGM2LjYxOSAwIDEyLTIuMzgxIDEyLTUuMzI1IDAtMS4yLS45LTIuMzA2LTIuNDE5LTMuMTg4QzIzLjEgMTQuNTg4IDI0IDEzLjQ4MiAyNCAxMi4yODJjMC0xLjIxOS0uOTM4LTIuMzYyLTIuNTEyLTMuMjYyIDEuNTU2LS45NTYgMi40OTMtMi4xMzggMi40OTMtMy40MTMgMC0zLjA5My01LjM4MS01LjYwNi0xMi01LjYwNnptNC4yNzUgMi42NjNjLS45NzUuMDE4LTEuOTEyLjIyNS0yLjUxMi42MTgtMS4wMzEuNjc1LS43MTMgMS41OTQuNzEyIDIuMDgyIDEuNDI1LjQ4NyAzLjM5NC4zMzcgNC40MjUtLjMzOCAxLjAzMi0uNjc1LjcxMy0xLjU5NC0uNzEyLTIuMDYyYTYuMzc2IDYuMzc2IDAgMDAtMS45MTMtLjI4MnptLjA1Ny4zMThjMS4zODcgMCAyLjQ5My41MjUgMi40OTMgMS4xNjMgMCAuNjM3LTEuMTA2IDEuMTYyLTIuNDkzIDEuMTYyLTEuMzg4IDAtMi40OTQtLjUyNS0yLjQ5NC0xLjE2MiAwLS42MzggMS4xMDYtMS4xNjMgMi40OTQtMS4xNjN6TTguNDkzIDYuNDVjLS4zLjAxOS0uNTguMDM4LS44NjIuMDc1bDEuNzA3LjMxOWEyLjAzLjk0IDAgMTEtMS41MiAxLjc0NGwtMS42NjgtLjMyYy4xODguMTcuNDUuMzIuODA2LjQ1IDEuMi40MTMgMi44ODguMjgyIDMuNzUtLjI4Ljg2My0uNTYzLjYtMS4zNS0uNi0xLjc0NC0uNDg3LS4xNjktMS4wNjgtLjI0NC0xLjYxMi0uMjQ0em0xMS45NDQgMy4xMTN2MS43NDNjMCAyLjA2My0zLjc4NyAzLjczMi04LjQzNyAzLjczMi00LjY2OSAwLTguNDM3LTEuNjctOC40MzctMy43MzJWOS41ODFjMi4xNTYuOTk0IDUuMTM3IDEuNjEzIDguNDE4IDEuNjEzIDMuMyAwIDYuMy0uNjE5IDguNDc1LTEuNjMxem0wIDYuNDg3djEuNjVjMCAyLjA2My0zLjc4NyAzLjczMS04LjQzNyAzLjczMS00LjY2OSAwLTguNDM3LTEuNjY4LTguNDM3LTMuNzMxdi0xLjY1YzIuMTc1Ljk1NiA1LjEzNyAxLjUzOCA4LjQzNyAxLjUzOHM2LjI4MS0uNTgyIDguNDM4LTEuNTM4eiIvPjwvc3ZnPg==";
                          wikipedia = "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+CjwhLS0gQ3JlYXRlZCB3aXRoIElua3NjYXBlIChodHRwOi8vd3d3Lmlua3NjYXBlLm9yZy8pIC0tPgo8c3ZnCiAgIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIKICAgeG1sbnM6Y2M9Imh0dHA6Ly93ZWIucmVzb3VyY2Uub3JnL2NjLyIKICAgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIgogICB4bWxuczpzdmc9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIgogICB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciCiAgIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIgogICB4bWxuczpzb2RpcG9kaT0iaHR0cDovL2lua3NjYXBlLnNvdXJjZWZvcmdlLm5ldC9EVEQvc29kaXBvZGktMC5kdGQiCiAgIHhtbG5zOmlua3NjYXBlPSJodHRwOi8vd3d3Lmlua3NjYXBlLm9yZy9uYW1lc3BhY2VzL2lua3NjYXBlIgogICB2ZXJzaW9uPSIxLjAiCiAgIHdpZHRoPSIxMjgiCiAgIGhlaWdodD0iMTI4IgogICBpZD0ic3ZnMTQ2NjIiCiAgIHNvZGlwb2RpOnZlcnNpb249IjAuMzIiCiAgIGlua3NjYXBlOnZlcnNpb249IjAuNDMiCiAgIHNvZGlwb2RpOmRvY25hbWU9Ildpa2lwZWRpYSdzIFcuc3ZnIgogICBzb2RpcG9kaTpkb2NiYXNlPSJEOlx2YXJcbWVkaWF3aWtpXHN2Z1xJbmtzY2FwZSI+CiAgPG1ldGFkYXRhCiAgICAgaWQ9Im1ldGFkYXRhODciPgogICAgPHJkZjpSREY+CiAgICAgIDxjYzpXb3JrCiAgICAgICAgIHJkZjphYm91dD0iIj4KICAgICAgICA8ZGM6Zm9ybWF0PmltYWdlL3N2Zyt4bWw8L2RjOmZvcm1hdD4KICAgICAgICA8ZGM6dHlwZQogICAgICAgICAgIHJkZjpyZXNvdXJjZT0iaHR0cDovL3B1cmwub3JnL2RjL2RjbWl0eXBlL1N0aWxsSW1hZ2UiIC8+CiAgICAgICAgPGNjOmxpY2Vuc2UKICAgICAgICAgICByZGY6cmVzb3VyY2U9Imh0dHA6Ly9jcmVhdGl2ZWNvbW1vbnMub3JnL2xpY2Vuc2VzL0dQTC8yLjAvIiAvPgogICAgICAgIDxkYzp0aXRsZT5XaWtpcGVkaWEncyBXPC9kYzp0aXRsZT4KICAgICAgICA8ZGM6Y3JlYXRvcj4KICAgICAgICAgIDxjYzpBZ2VudD4KICAgICAgICAgICAgPGRjOnRpdGxlPlNUeXg8L2RjOnRpdGxlPgogICAgICAgICAgPC9jYzpBZ2VudD4KICAgICAgICA8L2RjOmNyZWF0b3I+CiAgICAgICAgPGRjOnNvdXJjZT5ub25lPC9kYzpzb3VyY2U+CiAgICAgICAgPGRjOnN1YmplY3Q+CiAgICAgICAgICA8cmRmOkJhZz4KICAgICAgICAgICAgPHJkZjpsaT5XaWtpcGVkaWE8L3JkZjpsaT4KICAgICAgICAgICAgPHJkZjpsaT5mYXZpY29uPC9yZGY6bGk+CiAgICAgICAgICA8L3JkZjpCYWc+CiAgICAgICAgPC9kYzpzdWJqZWN0PgogICAgICAgIDxkYzpkYXRlPjIwMDctMDYtMjY8L2RjOmRhdGU+CiAgICAgICAgPGRjOnJpZ2h0cz4KICAgICAgICAgIDxjYzpBZ2VudD4KICAgICAgICAgICAgPGRjOnRpdGxlPkdGREw8L2RjOnRpdGxlPgogICAgICAgICAgPC9jYzpBZ2VudD4KICAgICAgICA8L2RjOnJpZ2h0cz4KICAgICAgICA8ZGM6ZGVzY3JpcHRpb24+VyBkZSBXaWtpcMOpZGlhPC9kYzpkZXNjcmlwdGlvbj4KICAgICAgICA8ZGM6cHVibGlzaGVyPgogICAgICAgICAgPGNjOkFnZW50PgogICAgICAgICAgICA8ZGM6dGl0bGU+SW5rc2NhcGU8L2RjOnRpdGxlPgogICAgICAgICAgPC9jYzpBZ2VudD4KICAgICAgICA8L2RjOnB1Ymxpc2hlcj4KICAgICAgPC9jYzpXb3JrPgogICAgICA8Y2M6TGljZW5zZQogICAgICAgICByZGY6YWJvdXQ9Imh0dHA6Ly9jcmVhdGl2ZWNvbW1vbnMub3JnL2xpY2Vuc2VzL0dQTC8yLjAvIj4KICAgICAgICA8Y2M6cGVybWl0cwogICAgICAgICAgIHJkZjpyZXNvdXJjZT0iaHR0cDovL3dlYi5yZXNvdXJjZS5vcmcvY2MvUmVwcm9kdWN0aW9uIiAvPgogICAgICAgIDxjYzpwZXJtaXRzCiAgICAgICAgICAgcmRmOnJlc291cmNlPSJodHRwOi8vd2ViLnJlc291cmNlLm9yZy9jYy9EaXN0cmlidXRpb24iIC8+CiAgICAgICAgPGNjOnJlcXVpcmVzCiAgICAgICAgICAgcmRmOnJlc291cmNlPSJodHRwOi8vd2ViLnJlc291cmNlLm9yZy9jYy9Ob3RpY2UiIC8+CiAgICAgICAgPGNjOnBlcm1pdHMKICAgICAgICAgICByZGY6cmVzb3VyY2U9Imh0dHA6Ly93ZWIucmVzb3VyY2Uub3JnL2NjL0Rlcml2YXRpdmVXb3JrcyIgLz4KICAgICAgICA8Y2M6cmVxdWlyZXMKICAgICAgICAgICByZGY6cmVzb3VyY2U9Imh0dHA6Ly93ZWIucmVzb3VyY2Uub3JnL2NjL1NoYXJlQWxpa2UiIC8+CiAgICAgICAgPGNjOnJlcXVpcmVzCiAgICAgICAgICAgcmRmOnJlc291cmNlPSJodHRwOi8vd2ViLnJlc291cmNlLm9yZy9jYy9Tb3VyY2VDb2RlIiAvPgogICAgICA8L2NjOkxpY2Vuc2U+CiAgICA8L3JkZjpSREY+CiAgPC9tZXRhZGF0YT4KICA8c29kaXBvZGk6bmFtZWR2aWV3CiAgICAgaW5rc2NhcGU6d2luZG93LWhlaWdodD0iOTc4IgogICAgIGlua3NjYXBlOndpbmRvdy13aWR0aD0iMTA0NSIKICAgICBpbmtzY2FwZTpwYWdlc2hhZG93PSIyIgogICAgIGlua3NjYXBlOnBhZ2VvcGFjaXR5PSIwLjAiCiAgICAgYm9yZGVyb3BhY2l0eT0iMS4wIgogICAgIGJvcmRlcmNvbG9yPSIjNjY2NjY2IgogICAgIHBhZ2Vjb2xvcj0iI2ZmZmZmZiIKICAgICBpZD0iYmFzZSIKICAgICBpbmtzY2FwZTp6b29tPSI3LjQ1MzEyNSIKICAgICBpbmtzY2FwZTpjeD0iNjQuNjM2OTQ4IgogICAgIGlua3NjYXBlOmN5PSI3NS42Nzc5NDIiCiAgICAgaW5rc2NhcGU6d2luZG93LXg9IjU3IgogICAgIGlua3NjYXBlOndpbmRvdy15PSIwIgogICAgIGlua3NjYXBlOmN1cnJlbnQtbGF5ZXI9InN2ZzE0NjYyIiAvPgogIDxkZWZzCiAgICAgaWQ9ImRlZnMxNDY2NCI+CiAgICA8bGluZWFyR3JhZGllbnQKICAgICAgIGlkPSJsaW5lYXJHcmFkaWVudDMyNjEiPgogICAgICA8c3RvcAogICAgICAgICBzdHlsZT0ic3RvcC1jb2xvcjojZmZmZmZmO3N0b3Atb3BhY2l0eTowIgogICAgICAgICBvZmZzZXQ9IjAiCiAgICAgICAgIGlkPSJzdG9wMzI2MyIgLz4KICAgICAgPHN0b3AKICAgICAgICAgc3R5bGU9InN0b3AtY29sb3I6I2ZmZmZmZjtzdG9wLW9wYWNpdHk6MCIKICAgICAgICAgb2Zmc2V0PSIwLjUiCiAgICAgICAgIGlkPSJzdG9wMzI2OSIgLz4KICAgICAgPHN0b3AKICAgICAgICAgc3R5bGU9InN0b3AtY29sb3I6I2ZmZmZmZjtzdG9wLW9wYWNpdHk6MSIKICAgICAgICAgb2Zmc2V0PSIxIgogICAgICAgICBpZD0ic3RvcDMyNjUiIC8+CiAgICA8L2xpbmVhckdyYWRpZW50PgogICAgPGxpbmVhckdyYWRpZW50CiAgICAgICBpZD0ibGluZWFyR3JhZGllbnQzMjE5Ij4KICAgICAgPHN0b3AKICAgICAgICAgc3R5bGU9InN0b3AtY29sb3I6IzBlNzMwOTtzdG9wLW9wYWNpdHk6MSIKICAgICAgICAgb2Zmc2V0PSIwIgogICAgICAgICBpZD0ic3RvcDMyMjEiIC8+CiAgICAgIDxzdG9wCiAgICAgICAgIHN0eWxlPSJzdG9wLWNvbG9yOiM3MGQxM2U7c3RvcC1vcGFjaXR5OjEiCiAgICAgICAgIG9mZnNldD0iMSIKICAgICAgICAgaWQ9InN0b3AzMjIzIiAvPgogICAgPC9saW5lYXJHcmFkaWVudD4KICAgIDxsaW5lYXJHcmFkaWVudAogICAgICAgaWQ9ImxpbmVhckdyYWRpZW50MzIwNSI+CiAgICAgIDxzdG9wCiAgICAgICAgIHN0eWxlPSJzdG9wLWNvbG9yOiMyYzgzMDA7c3RvcC1vcGFjaXR5OjEiCiAgICAgICAgIG9mZnNldD0iMCIKICAgICAgICAgaWQ9InN0b3AzMjA3IiAvPgogICAgICA8c3RvcAogICAgICAgICBzdHlsZT0ic3RvcC1jb2xvcjojM2RiODAwO3N0b3Atb3BhY2l0eToxIgogICAgICAgICBvZmZzZXQ9IjAuMjUiCiAgICAgICAgIGlkPSJzdG9wMzIxNSIgLz4KICAgICAgPHN0b3AKICAgICAgICAgc3R5bGU9InN0b3AtY29sb3I6I2ZmZmZmZjtzdG9wLW9wYWNpdHk6MSIKICAgICAgICAgb2Zmc2V0PSIwLjUiCiAgICAgICAgIGlkPSJzdG9wMzIxMyIgLz4KICAgICAgPHN0b3AKICAgICAgICAgc3R5bGU9InN0b3AtY29sb3I6IzY5Y2YzNTtzdG9wLW9wYWNpdHk6MSIKICAgICAgICAgb2Zmc2V0PSIxIgogICAgICAgICBpZD0ic3RvcDMyMDkiIC8+CiAgICA8L2xpbmVhckdyYWRpZW50PgogICAgPGxpbmVhckdyYWRpZW50CiAgICAgICBpZD0ibGluZWFyR3JhZGllbnQzMTk3Ij4KICAgICAgPHN0b3AKICAgICAgICAgc3R5bGU9InN0b3AtY29sb3I6IzAwMmYzMjtzdG9wLW9wYWNpdHk6MSIKICAgICAgICAgb2Zmc2V0PSIwIgogICAgICAgICBpZD0ic3RvcDMxOTkiIC8+CiAgICAgIDxzdG9wCiAgICAgICAgIHN0eWxlPSJzdG9wLWNvbG9yOiMwNDViMDQ7c3RvcC1vcGFjaXR5OjEiCiAgICAgICAgIG9mZnNldD0iMSIKICAgICAgICAgaWQ9InN0b3AzMjAxIiAvPgogICAgPC9saW5lYXJHcmFkaWVudD4KICAgIDxsaW5lYXJHcmFkaWVudAogICAgICAgaWQ9ImxpbmVhckdyYWRpZW50MzMzOSI+CiAgICAgIDxzdG9wCiAgICAgICAgIHN0eWxlPSJzdG9wLWNvbG9yOiNlOGU4ZTg7c3RvcC1vcGFjaXR5OjEiCiAgICAgICAgIG9mZnNldD0iMCIKICAgICAgICAgaWQ9InN0b3AzMzQxIiAvPgogICAgICA8c3RvcAogICAgICAgICBzdHlsZT0ic3RvcC1jb2xvcjojZmZmZmZmO3N0b3Atb3BhY2l0eToxIgogICAgICAgICBvZmZzZXQ9IjAuNSIKICAgICAgICAgaWQ9InN0b3AzMzQ3IiAvPgogICAgICA8c3RvcAogICAgICAgICBzdHlsZT0ic3RvcC1jb2xvcjojZThlOGU4O3N0b3Atb3BhY2l0eToxIgogICAgICAgICBvZmZzZXQ9IjEiCiAgICAgICAgIGlkPSJzdG9wMzM0MyIgLz4KICAgIDwvbGluZWFyR3JhZGllbnQ+CiAgICA8bGluZWFyR3JhZGllbnQKICAgICAgIGlkPSJsaW5lYXJHcmFkaWVudDMzMjciPgogICAgICA8c3RvcAogICAgICAgICBzdHlsZT0ic3RvcC1jb2xvcjojZmZmZmZmO3N0b3Atb3BhY2l0eToxIgogICAgICAgICBvZmZzZXQ9IjAiCiAgICAgICAgIGlkPSJzdG9wMzMyOSIgLz4KICAgICAgPHN0b3AKICAgICAgICAgc3R5bGU9InN0b3AtY29sb3I6I2ZkZDk5YTtzdG9wLW9wYWNpdHk6MSIKICAgICAgICAgb2Zmc2V0PSIwLjUiCiAgICAgICAgIGlkPSJzdG9wMzMzNSIgLz4KICAgICAgPHN0b3AKICAgICAgICAgc3R5bGU9InN0b3AtY29sb3I6I2MzOTUzOTtzdG9wLW9wYWNpdHk6MSIKICAgICAgICAgb2Zmc2V0PSIxIgogICAgICAgICBpZD0ic3RvcDMzMzEiIC8+CiAgICA8L2xpbmVhckdyYWRpZW50PgogICAgPGxpbmVhckdyYWRpZW50CiAgICAgICBpZD0ibGluZWFyR3JhZGllbnQzMzE5Ij4KICAgICAgPHN0b3AKICAgICAgICAgc3R5bGU9InN0b3AtY29sb3I6IzdkNDkxZjtzdG9wLW9wYWNpdHk6MSIKICAgICAgICAgb2Zmc2V0PSIwIgogICAgICAgICBpZD0ic3RvcDMzMjEiIC8+CiAgICAgIDxzdG9wCiAgICAgICAgIHN0eWxlPSJzdG9wLWNvbG9yOiM5MjY2MDA7c3RvcC1vcGFjaXR5OjEiCiAgICAgICAgIG9mZnNldD0iMSIKICAgICAgICAgaWQ9InN0b3AzMzIzIiAvPgogICAgPC9saW5lYXJHcmFkaWVudD4KICAgIDxsaW5lYXJHcmFkaWVudAogICAgICAgaWQ9ImxpbmVhckdyYWRpZW50MzI4MiI+CiAgICAgIDxzdG9wCiAgICAgICAgIHN0eWxlPSJzdG9wLWNvbG9yOiNmZmZmZmY7c3RvcC1vcGFjaXR5OjAiCiAgICAgICAgIG9mZnNldD0iMCIKICAgICAgICAgaWQ9InN0b3AzMjg0IiAvPgogICAgICA8c3RvcAogICAgICAgICBzdHlsZT0ic3RvcC1jb2xvcjojZmZmZmZmO3N0b3Atb3BhY2l0eToxIgogICAgICAgICBvZmZzZXQ9IjEiCiAgICAgICAgIGlkPSJzdG9wMzI4NiIgLz4KICAgIDwvbGluZWFyR3JhZGllbnQ+CiAgICA8bGluZWFyR3JhZGllbnQKICAgICAgIGlkPSJsaW5lYXJHcmFkaWVudDE0NzA5Ij4KICAgICAgPHN0b3AKICAgICAgICAgc3R5bGU9InN0b3AtY29sb3I6I2ZmZmZmZjtzdG9wLW9wYWNpdHk6MSIKICAgICAgICAgb2Zmc2V0PSIwIgogICAgICAgICBpZD0ic3RvcDE0NzExIiAvPgogICAgICA8c3RvcAogICAgICAgICBzdHlsZT0ic3RvcC1jb2xvcjojNWViMmZmO3N0b3Atb3BhY2l0eToxIgogICAgICAgICBvZmZzZXQ9IjEiCiAgICAgICAgIGlkPSJzdG9wMTQ3MTMiIC8+CiAgICA8L2xpbmVhckdyYWRpZW50PgogICAgPGxpbmVhckdyYWRpZW50CiAgICAgICBpZD0ibGluZWFyR3JhZGllbnQxNDY4NSI+CiAgICAgIDxzdG9wCiAgICAgICAgIHN0eWxlPSJzdG9wLWNvbG9yOiMwOTE3YTA7c3RvcC1vcGFjaXR5OjEiCiAgICAgICAgIG9mZnNldD0iMCIKICAgICAgICAgaWQ9InN0b3AxNDY4NyIgLz4KICAgICAgPHN0b3AKICAgICAgICAgc3R5bGU9InN0b3AtY29sb3I6IzAzNDVmNDtzdG9wLW9wYWNpdHk6MSIKICAgICAgICAgb2Zmc2V0PSIxIgogICAgICAgICBpZD0ic3RvcDE0Njg5IiAvPgogICAgPC9saW5lYXJHcmFkaWVudD4KICAgIDxsaW5lYXJHcmFkaWVudAogICAgICAgeDE9Ijk2LjEyNSIKICAgICAgIHkxPSIxMS4xODc1IgogICAgICAgeDI9Ijk2LjEyNSIKICAgICAgIHkyPSI1Mi4xMDEzMzQiCiAgICAgICBpZD0ibGluZWFyR3JhZGllbnQxNDY5MSIKICAgICAgIHhsaW5rOmhyZWY9IiNsaW5lYXJHcmFkaWVudDE0Njg1IgogICAgICAgZ3JhZGllbnRVbml0cz0idXNlclNwYWNlT25Vc2UiIC8+CiAgICA8bGluZWFyR3JhZGllbnQKICAgICAgIHgxPSI5Ni4xMjUiCiAgICAgICB5MT0iMTEuMTg3NSIKICAgICAgIHgyPSI5Ni4xMjUiCiAgICAgICB5Mj0iNTIuMTAxMzM0IgogICAgICAgaWQ9ImxpbmVhckdyYWRpZW50MTQ2OTkiCiAgICAgICB4bGluazpocmVmPSIjbGluZWFyR3JhZGllbnQxNDY4NSIKICAgICAgIGdyYWRpZW50VW5pdHM9InVzZXJTcGFjZU9uVXNlIgogICAgICAgZ3JhZGllbnRUcmFuc2Zvcm09InRyYW5zbGF0ZSg0NDcuNDI4NTYsNjM2LjkzMzU5KSIgLz4KICAgIDxyYWRpYWxHcmFkaWVudAogICAgICAgY3g9IjU0Ni4zMTE2NSIKICAgICAgIGN5PSI3MDUuNDg0ODYiCiAgICAgICByPSIyNS4yODEyNSIKICAgICAgIGZ4PSI1NDYuMzExNjUiCiAgICAgICBmeT0iNzA1LjQ4NDg2IgogICAgICAgaWQ9InJhZGlhbEdyYWRpZW50MTQ3MTUiCiAgICAgICB4bGluazpocmVmPSIjbGluZWFyR3JhZGllbnQxNDcwOSIKICAgICAgIGdyYWRpZW50VW5pdHM9InVzZXJTcGFjZU9uVXNlIgogICAgICAgZ3JhZGllbnRUcmFuc2Zvcm09Im1hdHJpeCgyLjAzMjgyMSwwLC0zLjI4OTA2MmUtOCwxLjcxNzMzOCwtNTY1LjcxODMsLTUxOC40OTkxKSIgLz4KICAgIDxsaW5lYXJHcmFkaWVudAogICAgICAgeDE9Ijk2LjEyNSIKICAgICAgIHkxPSIxMS4xODc1IgogICAgICAgeDI9Ijk2LjEyNSIKICAgICAgIHkyPSI1Mi4xMDEzMzQiCiAgICAgICBpZD0ibGluZWFyR3JhZGllbnQxNDcyMyIKICAgICAgIHhsaW5rOmhyZWY9IiNsaW5lYXJHcmFkaWVudDE0Njg1IgogICAgICAgZ3JhZGllbnRVbml0cz0idXNlclNwYWNlT25Vc2UiCiAgICAgICBncmFkaWVudFRyYW5zZm9ybT0idHJhbnNsYXRlKDQ0Ny40Mjg1Niw2MzYuOTMzNTkpIiAvPgogICAgPGZpbHRlcgogICAgICAgaWQ9ImZpbHRlcjE0ODI0Ij4KICAgICAgPGZlR2F1c3NpYW5CbHVyCiAgICAgICAgIGlkPSJmZUdhdXNzaWFuQmx1cjE0ODI2IgogICAgICAgICBzdGREZXZpYXRpb249IjAuMzczMzIwNDciCiAgICAgICAgIGlua3NjYXBlOmNvbGxlY3Q9ImFsd2F5cyIgLz4KICAgIDwvZmlsdGVyPgogICAgPGxpbmVhckdyYWRpZW50CiAgICAgICB4MT0iOTYuMTI1IgogICAgICAgeTE9IjExLjE4NzUiCiAgICAgICB4Mj0iOTYuMTI1IgogICAgICAgeTI9IjUyLjEwMTMzNCIKICAgICAgIGlkPSJsaW5lYXJHcmFkaWVudDE0ODMzIgogICAgICAgeGxpbms6aHJlZj0iI2xpbmVhckdyYWRpZW50MTQ2ODUiCiAgICAgICBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIKICAgICAgIGdyYWRpZW50VHJhbnNmb3JtPSJ0cmFuc2xhdGUoNDU4LjE2MTk4LDY0NC42MjMyKSIgLz4KICAgIDxsaW5lYXJHcmFkaWVudAogICAgICAgeDE9Ijk2LjEyNSIKICAgICAgIHkxPSIxMS4xODc1IgogICAgICAgeDI9Ijk2LjEyNSIKICAgICAgIHkyPSI1Mi4xMDEzMzQiCiAgICAgICBpZD0ibGluZWFyR3JhZGllbnQxNDg0MiIKICAgICAgIHhsaW5rOmhyZWY9IiNsaW5lYXJHcmFkaWVudDE0Njg1IgogICAgICAgZ3JhZGllbnRVbml0cz0idXNlclNwYWNlT25Vc2UiCiAgICAgICBncmFkaWVudFRyYW5zZm9ybT0idHJhbnNsYXRlKDQ1OC4xNjE5OCw2NDQuNjIzMikiIC8+CiAgICA8cmFkaWFsR3JhZGllbnQKICAgICAgIGN4PSI1NDYuMzExNjUiCiAgICAgICBjeT0iNzA1LjQ4NDg2IgogICAgICAgcj0iMjUuMjgxMjUiCiAgICAgICBmeD0iNTQ2LjMxMTY1IgogICAgICAgZnk9IjcwNS40ODQ4NiIKICAgICAgIGlkPSJyYWRpYWxHcmFkaWVudDMyODgiCiAgICAgICB4bGluazpocmVmPSIjbGluZWFyR3JhZGllbnQzMjgyIgogICAgICAgZ3JhZGllbnRVbml0cz0idXNlclNwYWNlT25Vc2UiCiAgICAgICBncmFkaWVudFRyYW5zZm9ybT0ibWF0cml4KDIuMDMyODIwNiwwLC0zLjI4OTA2MThlLTgsMS43MTczMzgxLC01NjUuNzE4MzUsLTUxOC40OTkxMSkiIC8+CiAgICA8bGluZWFyR3JhZGllbnQKICAgICAgIHgxPSI5Ni4xMjUiCiAgICAgICB5MT0iMTEuMTg3NSIKICAgICAgIHgyPSI5Ni4xMjUiCiAgICAgICB5Mj0iNTIuMTAxMzM0IgogICAgICAgaWQ9ImxpbmVhckdyYWRpZW50MzI5NiIKICAgICAgIHhsaW5rOmhyZWY9IiNsaW5lYXJHcmFkaWVudDE0Njg1IgogICAgICAgZ3JhZGllbnRVbml0cz0idXNlclNwYWNlT25Vc2UiCiAgICAgICBncmFkaWVudFRyYW5zZm9ybT0idHJhbnNsYXRlKDQ0Ny40Mjg1Niw2MzYuOTMzNTkpIiAvPgogICAgPGxpbmVhckdyYWRpZW50CiAgICAgICB4MT0iOTYuMzgxODEzIgogICAgICAgeTE9IjMwLjY2NjY5MSIKICAgICAgIHgyPSI5Ni4zODE4MTMiCiAgICAgICB5Mj0iMTMuMTg3NDk0IgogICAgICAgaWQ9ImxpbmVhckdyYWRpZW50MzMwMiIKICAgICAgIHhsaW5rOmhyZWY9IiNsaW5lYXJHcmFkaWVudDMyODIiCiAgICAgICBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIKICAgICAgIGdyYWRpZW50VHJhbnNmb3JtPSJtYXRyaXgoMC45MzQ4NTEsMCwwLDAuOTM0ODUxLDQ1My42OTEsNjM4Ljk5MzEpIiAvPgogICAgPGxpbmVhckdyYWRpZW50CiAgICAgICB4MT0iNDEuOTQ1NTM4IgogICAgICAgeTE9IjQ2LjY2NTEyNyIKICAgICAgIHgyPSI0MS45NDU1MzgiCiAgICAgICB5Mj0iODIuMzMzMjQ0IgogICAgICAgaWQ9ImxpbmVhckdyYWRpZW50MzMyNSIKICAgICAgIHhsaW5rOmhyZWY9IiNsaW5lYXJHcmFkaWVudDMzMTkiCiAgICAgICBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgLz4KICAgIDxyYWRpYWxHcmFkaWVudAogICAgICAgY3g9IjUzLjYwMjIzIgogICAgICAgY3k9IjU5LjcyODg4MiIKICAgICAgIHI9IjE3LjgzNDA1NyIKICAgICAgIGZ4PSI1My42MDIyMyIKICAgICAgIGZ5PSI1OS43Mjg4ODIiCiAgICAgICBpZD0icmFkaWFsR3JhZGllbnQzMzMzIgogICAgICAgeGxpbms6aHJlZj0iI2xpbmVhckdyYWRpZW50MzMyNyIKICAgICAgIGdyYWRpZW50VW5pdHM9InVzZXJTcGFjZU9uVXNlIgogICAgICAgZ3JhZGllbnRUcmFuc2Zvcm09Im1hdHJpeCgwLDEuNjU1ODQ5LC0xLjYzOTE4OCwwLDE1Mi4xNTAxLC0zMi45MjM3MykiIC8+CiAgICA8bGluZWFyR3JhZGllbnQKICAgICAgIHgxPSIyOC40Mjk0ODMiCiAgICAgICB5MT0iNjEuNzk4Mjk4IgogICAgICAgeDI9IjU4Ljk1OTE2IgogICAgICAgeTI9IjYxLjc5ODI5OCIKICAgICAgIGlkPSJsaW5lYXJHcmFkaWVudDMzNDUiCiAgICAgICB4bGluazpocmVmPSIjbGluZWFyR3JhZGllbnQzMzM5IgogICAgICAgZ3JhZGllbnRVbml0cz0idXNlclNwYWNlT25Vc2UiIC8+CiAgICA8ZmlsdGVyCiAgICAgICBpZD0iZmlsdGVyMzM4NSI+CiAgICAgIDxmZUdhdXNzaWFuQmx1cgogICAgICAgICBpZD0iZmVHYXVzc2lhbkJsdXIzMzg3IgogICAgICAgICBzdGREZXZpYXRpb249IjAuMTQ2MDc2OTEiCiAgICAgICAgIGlua3NjYXBlOmNvbGxlY3Q9ImFsd2F5cyIgLz4KICAgIDwvZmlsdGVyPgogICAgPGxpbmVhckdyYWRpZW50CiAgICAgICB4MT0iODMuMjgxMjUiCiAgICAgICB5MT0iMTIzLjA5Nzk1IgogICAgICAgeDI9IjgzLjI4MTI1IgogICAgICAgeTI9IjY2LjMxMDk4OSIKICAgICAgIGlkPSJsaW5lYXJHcmFkaWVudDMyMDMiCiAgICAgICB4bGluazpocmVmPSIjbGluZWFyR3JhZGllbnQzMTk3IgogICAgICAgZ3JhZGllbnRVbml0cz0idXNlclNwYWNlT25Vc2UiIC8+CiAgICA8cmFkaWFsR3JhZGllbnQKICAgICAgIGN4PSI0OTEuNTIyMzEiCiAgICAgICBjeT0iNjcwLjkyNTIzIgogICAgICAgcj0iMzYuNDI2NjAxIgogICAgICAgZng9IjQ5MS41MjIzMSIKICAgICAgIGZ5PSI2NzAuOTI1MjMiCiAgICAgICBpZD0icmFkaWFsR3JhZGllbnQzMjExIgogICAgICAgeGxpbms6aHJlZj0iI2xpbmVhckdyYWRpZW50MzIwNSIKICAgICAgIGdyYWRpZW50VW5pdHM9InVzZXJTcGFjZU9uVXNlIgogICAgICAgZ3JhZGllbnRUcmFuc2Zvcm09Im1hdHJpeCgwLDIuMDIzNzgzLC0xLjk1ODA1NCwwLDE4MDUuMjMsLTMxMi40OTQ4KSIgLz4KICAgIDxsaW5lYXJHcmFkaWVudAogICAgICAgeDE9IjUxNy4wMjE2NyIKICAgICAgIHkxPSI3MDUuNDg0MzgiCiAgICAgICB4Mj0iNTE3LjAyMTY3IgogICAgICAgeTI9Ijc0NS4zMDA4NCIKICAgICAgIGlkPSJsaW5lYXJHcmFkaWVudDMyNDAiCiAgICAgICB4bGluazpocmVmPSIjbGluZWFyR3JhZGllbnQzMjE5IgogICAgICAgZ3JhZGllbnRVbml0cz0idXNlclNwYWNlT25Vc2UiCiAgICAgICBncmFkaWVudFRyYW5zZm9ybT0ibWF0cml4KC0xLDAsMCwxLDk4My4zMjYxLDApIiAvPgogICAgPGxpbmVhckdyYWRpZW50CiAgICAgICB4MT0iNTE3LjAyMTY3IgogICAgICAgeTE9IjcwNS40ODQzOCIKICAgICAgIHgyPSI1MTcuMDIxNjciCiAgICAgICB5Mj0iNzQ1LjMwMDg0IgogICAgICAgaWQ9ImxpbmVhckdyYWRpZW50MzI0MyIKICAgICAgIHhsaW5rOmhyZWY9IiNsaW5lYXJHcmFkaWVudDMyMTkiCiAgICAgICBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIKICAgICAgIGdyYWRpZW50VHJhbnNmb3JtPSJ0cmFuc2xhdGUoLTAuMTIwMDQ3LDApIiAvPgogICAgPHJhZGlhbEdyYWRpZW50CiAgICAgICBjeD0iNDc5LjY4MzExIgogICAgICAgY3k9IjcwOS42NTc5IgogICAgICAgcj0iNS4wMDU4ODUxIgogICAgICAgZng9IjQ3OS42ODMxMSIKICAgICAgIGZ5PSI3MDkuNjU3OSIKICAgICAgIGlkPSJyYWRpYWxHcmFkaWVudDMyNjciCiAgICAgICB4bGluazpocmVmPSIjbGluZWFyR3JhZGllbnQzMjYxIgogICAgICAgZ3JhZGllbnRVbml0cz0idXNlclNwYWNlT25Vc2UiCiAgICAgICBncmFkaWVudFRyYW5zZm9ybT0ibWF0cml4KDEuMjMzOTc2LC0wLjE1MTYwMywwLjE5MDc5NywxLjU1Mjk5MywtMjQ3LjYzNDksLTMyMC4xNTIpIiAvPgogICAgPGZpbHRlcgogICAgICAgaWQ9ImZpbHRlcjMzMzEiPgogICAgICA8ZmVHYXVzc2lhbkJsdXIKICAgICAgICAgaWQ9ImZlR2F1c3NpYW5CbHVyMzMzMyIKICAgICAgICAgc3RkRGV2aWF0aW9uPSIwLjM1NSIKICAgICAgICAgaW5rc2NhcGU6Y29sbGVjdD0iYWx3YXlzIiAvPgogICAgPC9maWx0ZXI+CiAgICA8ZmlsdGVyCiAgICAgICBpZD0iZmlsdGVyMzMzNSI+CiAgICAgIDxmZUdhdXNzaWFuQmx1cgogICAgICAgICBpZD0iZmVHYXVzc2lhbkJsdXIzMzM3IgogICAgICAgICBzdGREZXZpYXRpb249IjAuMjY2OTQ5NzciCiAgICAgICAgIGlua3NjYXBlOmNvbGxlY3Q9ImFsd2F5cyIgLz4KICAgIDwvZmlsdGVyPgogICAgPGZpbHRlcgogICAgICAgaWQ9ImZpbHRlcjMzMzkiPgogICAgICA8ZmVHYXVzc2lhbkJsdXIKICAgICAgICAgaWQ9ImZlR2F1c3NpYW5CbHVyMzM0MSIKICAgICAgICAgc3RkRGV2aWF0aW9uPSIwLjIzODcwMDM4IgogICAgICAgICBpbmtzY2FwZTpjb2xsZWN0PSJhbHdheXMiIC8+CiAgICA8L2ZpbHRlcj4KICA8L2RlZnM+CiAgPGcKICAgICBpZD0iZzIwMzYiCiAgICAgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoMC45OTk5OTgsMCkiPgogICAgPHBhdGgKICAgICAgIHNvZGlwb2RpOm5vZGV0eXBlcz0iY2NjY2NjY2NzY2NjY3NzY2Njc3NjY2NjIgogICAgICAgaWQ9IlYxIgogICAgICAgZD0iTSA5NS44Njg3MDYsMjMuOTA5MTA0IEwgOTUuODY4NzA2LDI2LjA0ODA1NiBDIDkzLjA0NzM2MSwyNi41NDkxNDcgOTAuOTExODI2LDI3LjQzNTU1OSA4OS40NjIwOTcsMjguNzA3MjkzIEMgODcuMzg1MjUxLDMwLjU5NTgwOCA4NC45MzY1MzksMzMuNDg2MjgxIDgzLjMzMDA2MiwzNy4zNzg3MTkgTCA1MC42NDQ1ODksMTA0LjA5MDg5IEwgNDguNDY5ODc0LDEwNC4wOTA4OSBMIDE1LjY1Njk0LDM2LjUxMTU3NiBDIDE0LjEyODc0MiwzMy4wNDMwNzUgMTIuMDUxMTc2LDMwLjkyMzM5NSAxMS40MjQyNDQsMzAuMTUyNTMxIEMgMTAuNDQ0NjMsMjguOTU3ODc0IDkuMjM5NzExOSwyOC4wMjMyODggNy44MDk1MDI5LDI3LjM0ODc3IEMgNi4zNzkyNjg2LDI2LjY3NDQwMSA0LjQ0OTQ0OCwyNi4yNDA4MyAyLjAyMDAzNDcsMjYuMDQ4MDU2IEwgMi4wMjAwMzQ3LDIzLjkwOTEwNCBMIDMzLjk0NzkxNiwyMy45MDkxMDQgTCAzMy45NDc5MTYsMjYuMDQ4MDU2IEMgMzAuMjY0NTYyLDI2LjM5NDk4OSAyOC41MDg1MjMsMjcuMDExNjIzIDI3LjQxMTM5OSwyNy44OTc5NiBDIDI2LjMxNDIxMiwyOC43ODQ0NDYgMjUuNzY1NjM0LDI5LjkyMTM2NSAyNS43NjU2NiwzMS4zMDg3MjEgQyAyNS43NjU2MzQsMzMuMjM1NzczIDI2LjY2Njg2OCwzNi4yNDE4NjUgMjguNDY5MzY4LDQwLjMyNzAwNCBMIDUyLjcwMTc2Miw4Ni4yODU1NTkgTCA3Ni4zOTQ0NTMsNDAuOTA1MDk5IEMgNzguMjM2MDQ1LDM2LjQzNDU2MiA3OS43NjM5MzksMzMuMzMyMTIyIDc5Ljc2NDAwMiwzMS41OTc3NjggQyA3OS43NjM5MzksMzAuNDgwMTkgNzkuMTk1NzY0LDI5LjQxMDcxNSA3OC4wNTk0OTgsMjguMzg5MzQxIEMgNzYuOTIzMDgsMjcuMzY4MTE0IDc1LjYzNzI1MSwyNi42NDU0OTYgNzIuOTMzNjA2LDI2LjIyMTQ4NCBDIDcyLjczNzYyMSwyNi4xODMwMjEgNzIuNDA0NTY4LDI2LjEyNTIxMSA3MS45MzQ0MDgsMjYuMDQ4MDU2IEwgNzEuOTM0NDA4LDIzLjkwOTEwNCBMIDk1Ljg2ODcwNiwyMy45MDkxMDQgeiAiCiAgICAgICBzdHlsZT0iZm9udC1zaXplOjE3OC4yMjQ5OTA4NHB4O2ZvbnQtc3R5bGU6bm9ybWFsO2ZvbnQtd2VpZ2h0Om5vcm1hbDtmaWxsOiMwMDAwMDA7ZmlsbC1vcGFjaXR5OjE7c3Ryb2tlOm5vbmU7c3Ryb2tlLXdpZHRoOjFweDtzdHJva2UtbGluZWNhcDpidXR0O3N0cm9rZS1saW5lam9pbjptaXRlcjtzdHJva2Utb3BhY2l0eToxO2ZvbnQtZmFtaWx5OlRpbWVzIE5ldyBSb21hbiIgLz4KICAgIDxwYXRoCiAgICAgICBzb2RpcG9kaTpub2RldHlwZXM9ImNjY2NjY2Njc2NjY2Nzc2NjY3NzY2NjYyIKICAgICAgIGlkPSJWMiIKICAgICAgIGQ9Ik0gMTIzLjk3OTk3LDIzLjkwOTEwNCBMIDEyMy45Nzk5NywyNi4wNDgwNTYgQyAxMjEuMTU4NjMsMjYuNTQ5MTQ3IDExOS4wMjMxLDI3LjQzNTU1OSAxMTcuNTczMzcsMjguNzA3MjkzIEMgMTE1LjQ5NjUyLDMwLjU5NTgwOCAxMTMuMDQ3ODEsMzMuNDg2MjgxIDExMS40NDEzMywzNy4zNzg3MTkgTCA4Mi43NTU4NTcsMTA0LjA5MDg5IEwgODAuNTgxMTQzLDEwNC4wOTA4OSBMIDUwLjI2ODIwOSwzNi41MTE1NzYgQyA0OC43NDAwMSwzMy4wNDMwNzUgNDYuNjYyNDQ1LDMwLjkyMzM5NSA0Ni4wMzU1MTMsMzAuMTUyNTMxIEMgNDUuMDU1ODk4LDI4Ljk1Nzg3NCA0My44NTA5ODEsMjguMDIzMjg4IDQyLjQyMDc3MiwyNy4zNDg3NyBDIDQwLjk5MDUzNywyNi42NzQ0MDEgMzkuNjk0OTExLDI2LjI0MDgzIDM3LjI2NTQ5NywyNi4wNDgwNTYgTCAzNy4yNjU0OTcsMjMuOTA5MTA0IEwgNjguNTU5MTg1LDIzLjkwOTEwNCBMIDY4LjU1OTE4NSwyNi4wNDgwNTYgQyA2NC44NzU4MzEsMjYuMzk0OTg5IDYzLjExOTc5MiwyNy4wMTE2MjMgNjIuMDIyNjY4LDI3Ljg5Nzk2IEMgNjAuOTI1NDgxLDI4Ljc4NDQ0NiA2MC4zNzY5MDMsMjkuOTIxMzY1IDYwLjM3NjkyOCwzMS4zMDg3MjEgQyA2MC4zNzY5MDMsMzMuMjM1NzczIDYxLjI3ODEzNywzNi4yNDE4NjUgNjMuMDgwNjM3LDQwLjMyNzAwNCBMIDg0LjgxMzAzMSw4Ni4yODU1NTkgTCAxMDQuNTA1NzIsNDAuOTA1MDk5IEMgMTA2LjM0NzMxLDM2LjQzNDU2MiAxMDcuODc1MjEsMzMuMzMyMTIyIDEwNy44NzUyNywzMS41OTc3NjggQyAxMDcuODc1MjEsMzAuNDgwMTkgMTA3LjMwNzAzLDI5LjQxMDcxNSAxMDYuMTcwNzcsMjguMzg5MzQxIEMgMTA1LjAzNDM1LDI3LjM2ODExNCAxMDMuMTE0MzMsMjYuNjQ1NDk2IDEwMC40MTA2OCwyNi4yMjE0ODQgQyAxMDAuMjE0NywyNi4xODMwMjEgOTkuODgxNjQsMjYuMTI1MjExIDk5LjQxMTQ4LDI2LjA0ODA1NiBMIDk5LjQxMTQ4LDIzLjkwOTEwNCBMIDEyMy45Nzk5NywyMy45MDkxMDQgeiAiCiAgICAgICBzdHlsZT0iZm9udC1zaXplOjE3OC4yMjQ5OTA4NHB4O2ZvbnQtc3R5bGU6bm9ybWFsO2ZvbnQtd2VpZ2h0Om5vcm1hbDtmaWxsOiMwMDAwMDA7ZmlsbC1vcGFjaXR5OjE7c3Ryb2tlOm5vbmU7c3Ryb2tlLXdpZHRoOjFweDtzdHJva2UtbGluZWNhcDpidXR0O3N0cm9rZS1saW5lam9pbjptaXRlcjtzdHJva2Utb3BhY2l0eToxO2ZvbnQtZmFtaWx5OlRpbWVzIE5ldyBSb21hbiIgLz4KICA8L2c+Cjwvc3ZnPgo=";
                          twitch = "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPjxwYXRoIGQ9Ik01LjcgMEwxLjQgMTAuOTg1VjU1Ljg4aDE1LjI4NFY2NGg4LjU5N2w4LjEyLTguMTJoMTIuNDE4bDE2LjcxNi0xNi43MTZWMEg1Ljd6bTUxLjEwNCAzNi4zTDQ3LjI1IDQ1Ljg1SDMxLjk2N2wtOC4xMiA4LjEydi04LjEySDEwLjk1MlY1LjczaDQ1Ljg1VjM2LjN6TTQ3LjI1IDE2LjcxNnYxNi43MTZoLTUuNzNWMTYuNzE2aDUuNzN6bS0xNS4yODQgMHYxNi43MTZoLTUuNzNWMTYuNzE2aDUuNzN6IiBmaWxsPSIjOTE0NmZmIi8+PHBhdGggc3R5bGU9ImZpbGw6I2ZmZmZmZjtzdHJva2U6I2ZmZmZmZjtzdHJva2Utd2lkdGg6MC4wODc1MTA2IiBkPSJNIDIzLjg0NjE1NCw0OS44NjUxMSBWIDQ1Ljg0NjE1NCBIIDE3LjQyMzA3NyAxMSBWIDI1LjgwNzY5MiA1Ljc2OTIzMDggaCAyMi44ODQ2MTUgMjIuODg0NjE2IHYgMTUuMjUwMjMxMiAxNS4yNTAyMyBsIC00Ljc4ODY5MSw0Ljc4ODIzMSAtNC43ODg2OSw0Ljc4ODIzMSBIIDM5LjUzODUwNSAzMS44ODUxNiBsIC00LjAxOTUwMyw0LjAxODk1NiAtNC4wMTk1MDMsNC4wMTg5NTYgeiBNIDMyLDI1LjA3NjkyMyB2IC04LjM4NDYxNSBoIC0yLjg4NDYxNSAtMi44ODQ2MTYgdiA4LjM4NDYxNSA4LjM4NDYxNSBIIDI5LjExNTM4NSAzMiBaIG0gMTUuMzA3NjkyLDAgdiAtOC4zODQ2MTUgaCAtMi45MjMwNzcgLTIuOTIzMDc3IHYgOC4zODQ2MTUgOC4zODQ2MTUgaCAyLjkyMzA3NyAyLjkyMzA3NyB6Ii8+PC9zdmc+Cg==";
                        };
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
                      (mkIf cfg.settings.clearOnShutdown.enable {
                        # What data gets cleared on shutdown
                        "privacy.clearOnShutdown.cache" = mkDefault cfg.settings.clearOnShutdown.cache;
                        "privacy.clearOnShutdown.cookies" = mkDefault cfg.settings.clearOnShutdown.cookies;
                        "privacy.clearOnShutdown.formdata" = mkDefault cfg.settings.clearOnShutdown.forms;
                        "privacy.clearOnShutdown.offlineApps" = mkDefault cfg.settings.clearOnShutdown.offlineApps;
                        "privacy.clearOnShutdown.sessions" = mkDefault cfg.settings.clearOnShutdown.sessions;
                        "privacy.clearOnShutdown_v2.cache" = mkDefault cfg.settings.clearOnShutdown.cache;
                        "privacy.clearOnShutdown_v2.cookiesAndStorage" = mkDefault cfg.settings.clearOnShutdown.cookies;
                        "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = mkDefault cfg.settings.clearOnShutdown.forms;

                        "privacy.clearOnShutdown.downloads" = mkDefault cfg.settings.clearOnShutdown.downloads;
                        "privacy.clearOnShutdown.history" = mkDefault cfg.settings.clearOnShutdown.history;
                        "privacy.clearOnShutdown.openWindows" = mkDefault cfg.settings.clearOnShutdown.openWindows;
                        "privacy.clearOnShutdown.siteSettings" = mkDefault cfg.settings.clearOnShutdown.siteSettings;
                        "privacy.clearOnShutdown_v2.siteSettings" = mkDefault cfg.settings.clearOnShutdown.siteSettings;
                      })

                      (mkIf cfg.settings.security.httpsOnly {
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
                      (mkIf cfg.settings.disableFullscreenWarning {
                        "full-screen-api.warning.timeout" = mkDefault 0;
                        "full-screen-api.warning.delay" = mkDefault "-1";
                      })

                      # disable warning popup on entering fullscreen
                      (mkIf cfg.settings.disableFullscreenTransitionAnimation {
                        "full-screen-api.transition-duration.enter" = mkDefault "0 0";
                        "full-screen-api.transition-duration.leave" = mkDefault "0 0";
                        "full-screen-api.transition.timeout" = mkDefault 0;
                      })

                      # Block autoplay until tab is in focus
                      (mkIf cfg.settings.blockAutoplayInBackground {
                        "media.block-autoplay-until-in-foreground" = mkDefault true;
                        "media.block-play-until-document-interaction" = mkDefault true;
                        "media.block-play-until-visible" = mkDefault true;
                      })

                      {
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
                        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
                        "lightweightThemes.selectedThemeID" = "firefox-compact-dark@mozilla.org";
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

                    (mkIf cfg.averageUserMode {
                      # BlockAboutAddons = true;
                      # BlockAboutConfig = true;
                      BlockAboutProfiles = true;
                      BlockAboutSupport = true;
                    })
                  ];
                };
              };
            };
          });
        }
      );
    };
  };
}
