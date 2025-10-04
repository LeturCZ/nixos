{
  config,
  lib,
  pkgs,
  system,
  ...
}:
with lib; {
  options = {
    home-manager.users = lib.mkOption {
      type = types.attrsOf (
        types.submoduleWith {
          modules = toList (
            {name, ...}: let
              cfg = config.home-manager.users.${name};
            in {
              options = {
                wallpaper = {
                  enable = mkEnableOption "enable wallpaperManagement";
                  provider = mkOption {
                    type = types.enum ["swww"];
                    default = "swww";
                    description = "The application providing wallpaper functionality";
                  };
                  sourceFiles = lib.mkOption {
                    type = types.listOf (
                      types.submoduleWith {
                        modules = toList (
                          {wallpaper, ...}: let
                            cfg = config.sourceFiles.${name};
                          in {
                            options = {
                              path = mkOption {
                                type = types.path;
                              };
                              type = mkOption {
                                type = types.enum [
                                  "regular"
                                  "pixelart"
                                ];
                                description = "used to determine the scaling method";
                              };
                              animated = mkOption {
                                type = types.bool;
                              };
                            };
                          }
                        );
                      }
                    );
                  };
                  # sourceFiles = mkOption {
                  #   type = types.listOf types.path;
                  #   description = "A list of paths to the wallpaper files";
                  #   default = [];
                  # };
                };
              };
              config = let
                execCommand = {swww = [swwwRandomizeScript];};
                cfgHyprland = cfg.wayland.windowManager.hyprland;
                swwwRandomizeScript = pkgs.writeShellScript "swwwLoadRandom.sh" ''

                  numFiles=${cfg.wallpaper.sourceFiles |> builtins.length |> builtins.toString}

                  files=(
                    ${cfg.wallpaper.sourceFiles
                    |> builtins.map (value: "\"${value.path}\"")
                    |> lib.concatStringsSep "\n"}
                  )

                  fileTypes=(
                    ${cfg.wallpaper.sourceFiles
                    |> builtins.map (value: "\"${value.type}\"")
                    |> lib.concatStringsSep "\n"}
                  )

                  flagAnimated=(
                    ${cfg.wallpaper.sourceFiles
                    |> builtins.map (value:
                      if value.animated
                      then "true"
                      else "false")
                    |> lib.concatStringsSep "\n"}
                  )

                  selectedIndex=$((RANDOM % numFiles))

                  while true; do

                    selectedType="''${fileTypes[$selectedIndex]}"
                    selectedAnimation="''${flagAnimated[$selectedIndex]}"

                    if [[ $# -gt 0 ]] && [[ "$selectedType" != "$1" ]] \
                    && ! { { [[ "$1" == "animated" ]] && [[ $selectedAnimation == true ]]; } \
                    || { [[ "$1" == "static" ]] && [[ $selectedAnimation == false ]]; } } then \

                      selectedIndex=$((RANDOM % numFiles))

                      continue

                    fi

                    break

                  done


                  selectedWallpaper=''${files[$selectedIndex]}

                  filter="Lanczos3"

                  if [[ "$selectedType" == "pixelart" ]]; then
                    filter="Nearest"
                  fi

                  ${pkgs.swww}/bin/swww img --filter="$filter" "$selectedWallpaper"
                '';
              in
                mkIf cfg.wallpaper.enable {
                  assertions = [
                    {
                      assertion = builtins.length cfg.wallpaper.sourceFiles > 0;
                      message = "At least one wallpaper file must be specified";
                    }
                  ];
                  services.swww.enable = mkIf (cfg.wallpaper.provider == "swww") true;
                  wayland.windowManager.hyprland.settings = mkIf cfgHyprland.enable {
                    exec-once = execCommand.${cfg.wallpaper.provider};
                    misc = {
                      disable_splash_rendering = true;
                      disable_hyprland_logo = true;
                    };
                  };
                };
            }
          );
        }
      );
    };
  };
}
