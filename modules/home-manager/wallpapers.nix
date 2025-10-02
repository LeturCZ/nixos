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
                  sourceFiles = mkOption {
                    type = types.listOf types.path;
                    description = "A list of paths to the wallpaper files";
                    default = [];
                  };
                };
              };
              config = let
                execCommand = {swww = [swwwRandomizeScript];};
                cfgHyprland = cfg.wayland.windowManager.hyprland;
                swwwRandomizeScript = pkgs.writeShellScript "swwwLoadRandom.sh" ''
                  wallpapers=( ${cfg.wallpaper.sourceFiles
                    |> builtins.map (value: "\"${value}\"")
                    |> lib.concatStringsSep "\n"} )

                  selectedWallpaper=''${wallpapers[ $RANDOM % ''${#wallpapers[@]} ]}

                  [[ "$selectedWallpaper" =~ ^.*\.\([^.]+\)$ ]]

                  filter="Lanczos3"

                  if [[ "$(realpath "$selectedWallpaper")" == *"/pixelart/"* ]]; then
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
