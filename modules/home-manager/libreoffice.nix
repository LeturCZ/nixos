{ config, lib, pkgs }:

{
  options = {
    home-manager.users = lib.mkOption {
      type = types.attrsOf (types.submoduleWith { modules = toList ({ name, isKde = config.desktopManager.plasma6.enable;, ... }: let cfg = config.home-manager.users.${name}.presets.browsers.librewolf; in {
        options.programs.libreoffice = with lib; {
          enable = mkEnableOption
        };
        config.home-manager.users.${name} = {
          home = {
            packages = if isKde then [ libreoffice-qt ] else [ libreoffice ];
          }
        };
      });});
  };
}
}