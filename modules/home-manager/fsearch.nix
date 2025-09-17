{
  config,
  lib,
  pkgs,
  customUtils,
  ...
}:
with lib; {
  options = {
    home-manager.users = lib.mkOption {
      type = types.attrsOf (types.submoduleWith {
        modules = toList ({name, ...}: let
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
              target = ".config/fsearch/fsearch.conf";
              text = customUtils.toConf {
                Interface.enable_dark_theme = true;
                Database = {
                  location_1 = "/";
                  location_enabled_1 = true;
                  location_one_filesysyem = false;
                  exclude_location_1 = "/proc";
                  exclude_location_enabled_1 = true;
                };
              };
            };
          };
        });
      });
    };
  };
}
