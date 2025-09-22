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
              options.programs.fsearch = {
                enable = mkEnableOption "enable Fsearch for user";
                darkTheme = mkOption {
                  type = types.bool;
                  default = true;
                };
              };
              config = mkIf cfg.programs.fsearch.enable {
                home.packages = [pkgs.fsearch];
                home.file.fsearchConfig = {
                  enable = true;
                  force = true;
                  target = ".config/fsearch/fsearch.conf";
                  text = lib.generators.toINI {} {
                    Interface.enable_dark_theme = true;
                    Database = {
                      update_database_on_launch = true;
                      update_database_every_hours = 0;
                      update_database_every_minutes = 15;
                      location_1 = "/";
                      location_update_1 = true;
                      location_enabled_1 = true;
                      location_one_filesysyem_1 = false;
                      exclude_location_1 = "/proc";
                      exclude_location_enabled_1 = true;
                    };
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
