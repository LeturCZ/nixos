{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    home-manager.users = mkOption {
      type = types.attrsOf (types.submoduleWith {
        modules = toList (
          {name, ...}: let
            cfg = config.home-manager.users.${name};
          in {
            options.programs.libreoffice = {
              enable = mkEnableOption "enable Libreoffice for user";
            };
            config = {
              home = {
                packages = with pkgs;
                  if config.services.desktopManager.plasma6.enable
                  then [libreoffice-qt]
                  else [libreoffice];
              };
            };
          }
        );
      });
    };
  };
}
