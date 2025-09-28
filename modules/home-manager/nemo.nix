{
  config,
  pkgs,
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
            options.programs.nemo = {
              enable = mkEnableOption "enable nemo";
            };
            config = mkIf cfg.programs.nemo.enable {
              home = {
                packages = [pkgs.nemo];
                file = {
                  ".gnome2/accels/nemo".text = ''
                    (gtk_accel_path "<Actions>/DirViewActions/OpenInTerminal" "<Primary><Alt>t")
                  '';
                };
              };
              dconf.settings = {
                "org/cinnamon/desktop/applications/terminal".exec = "alacritty";

                # allow keyboard shortcuts modification
                "org.cinnamon.desktop.interface".can-change-accels = true;
              };
            };
          }
        );
      }
    );
  };
}
