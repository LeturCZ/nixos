{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
with lib;
{
  options = {
    home-manager.users = lib.mkOption {
      type = types.attrsOf (
        types.submoduleWith {
          modules = toList (
            { name, ... }:
            let
              cfg = config.home-manager.users.${name};
            in
            {
              options.wayland.windowManager.hyprland.autoRotate = lib.mkEnableOption "Enable Hyprland autorotate";
              config = mkIf cfg.wayland.windowManager.hyprland.autoRotate {
                assertions = [
                  {
                    assertion = builtins.hasAttr "monitor" cfg.wayland.windowManager.hyprland.settings;
                    message = ''
                      iio-hyprland requires the hyprland.settings.monitor string to be set.
                      Please refer to https://wiki.hypr.land/Configuring/Monitors/'';
                  }
                ];
                wayland.windowManager.hyprland.settings.exec-once = [ "iio-hyprland" ];
                home.packages = [
                  inputs.iio-hyprland.packages.${pkgs.system}.default
                  pkgs.jq
                ];
              };
            }
          );
        }
      );
    };
  };
  config =
    mkIf
      # enable iio if any HM user enabled hyprland autoRotate
      (builtins.any (name: config.home-manager.users.${name}.wayland.windowManager.hyprland.autoRotate) (
        builtins.attrNames config.home-manager.users
      ))
      {
        hardware.sensor.iio.enable = true;
      };
}
