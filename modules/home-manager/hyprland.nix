{
  config,
  lib,
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
                wayland.windowManager.hyprland.presets.smartGaps = mkOption {
                  type = types.bool;
                  default = true;
                  description = "Automatically set outer window gaps to 0 if the window is the only one on screen";
                };
              };
              config.wayland.windowManager.hyprland.settings = mkIf (cfg.wayland.windowManager.hyprland.enable && cfg.wayland.windowManager.hyprland.presets.smartGaps) {
                workspace = [
                  "w[tv1]s[false], gapsout:0, gapsin:0"
                  "f[1]s[false], gapsout:0, gapsin:0"
                ];
                windowrule = [
                  "bordersize 0, floating:0, onworkspace:w[tv1]s[false]"
                  "rounding 0, floating:0, onworkspace:w[tv1]s[false]"
                  "bordersize 0, floating:0, onworkspace:f[1]s[false]"
                  "rounding 0, floating:0, onworkspace:f[1]s[false]"
                ];
              };
            }
          );
        }
      );
    };
  };
}
