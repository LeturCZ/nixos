{
  config,
  lib,
  pkgs,
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
              config = mkIf cfg.programs.waybar.enable {
                wayland.windowManager.hyprland.settings.exec-once = ["waybar"];
                home.packages = with pkgs; [nerd-fonts.meslo-lg jetbrains-mono];
              };
            }
          );
        }
      );
    };
  };
}
