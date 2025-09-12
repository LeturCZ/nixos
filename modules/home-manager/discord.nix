{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    home-manager.users = lib.mkOption {
      type = types.attrsOf (types.submoduleWith {
        modules = toList ({name, ...}: let
          cfg = config.home-manager.users.${name};
        in {
          options.programs.discord = {
            enable = mkEnableOption "enable Discord for user";
            extraProfiles = mkOption {
              type = types.listOf types.str;
              default = [];
            };
          };
          config = mkIf cfg.programs.discord.enable {
            home.packages = [pkgs.discord];
            home.file.discordConfig = {
              enable = true;
              target = ".config/discord/settings.json";
              text = builtins.toJSON {
                SKIP_HOST_UPDATE = true;
              };
            };
            xdg.desktopEntries.discord = {
              name = "Discord";
              genericName = "All-in-one cross-platform voice and text chat for gamers";
              exec = "Discord --multi-instance";
              terminal = false;
              categories = [
                "Network"
                "InstantMessaging"
              ];
              mimeType = ["x-scheme-handler/discord"];
              icon = "discord";
              type = "Application";
              settings = {
                StartupWMClass = "discord";
              };
              actions = builtins.listToAttrs (builtins.map (profileName: {
                  name = profileName;
                  value = {
                    name = "Discord (" + profileName + ")";
                    exec = "env HOME=${cfg.xdg.dataHome}/discord/profiles/" + profileName + " TMPDIR=${cfg.xdg.dataHome}/discord/profiles/" + profileName + " Discord --multi-instance";
                  };
                })
                cfg.programs.discord.extraProfiles);
            };
          };
        });
      });
    };
  };
}
