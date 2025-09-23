{
  config,
  lib,
  ...
}:
with lib; {
  options.home-manager.users = lib.mkOption {
    type = types.attrsOf (
      types.submoduleWith {
        modules = toList (
          {name, ...}: let
            cfg = config.home-manager.users.${name};
          in {
            options = {
            };
            config = mkIf config.programs.steam.enable {
              wayland.windowManager.hyprland.settings.windowrule = mkIf cfg.wayland.windowManager.hyprland.enable [
                "float, class:steam, title:Sign in to Steam"
                "float, class:steam, title:Steam Settings"
                "float, class:steam, title:Special Offers"
                "float, class:steam, title:Friends List"
                "float, class:steam, title:Shutdown"
              ];
            };
          }
        );
      }
    );
  };
  config = {
  };
}
