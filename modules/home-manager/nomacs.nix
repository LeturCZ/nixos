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
            options = {
              programs.nomacs = {
                enable = mkEnableOption "enable Nomacs image viewer";
              };
            };
            config = mkIf cfg.programs.nomacs.enable {
              home.packages = [pkgs.nomacs];
            };
          }
        );
      }
    );
  };
  config = {
  };
}
