{
  lib,
  config,
  ...
}:
with lib; {
  options.publicuser = {
    enable = mkEnableOption "enable public user";
    username = mkOption {
      type = types.str;
      default = "user";
    };
    fullname = mkOption {
      type = types.str;
      default = config.publicuser.username;
    };
    language = mkOption {
      type = types.str;
      default = "english";
    };
  };

  config = let
    cfg = config.publicuser;
  in
    mkIf cfg.enable {
      services.displayManager.autoLogin = {
        enable = true;
        user = cfg.username;
      };
      users.users.${cfg.username} = {
        isNormalUser = true;
        description = cfg.fullname;
        extraGroups = ["networkmanager"];
      };
      home-manager.users.${cfg.username} = {
        presets.browsers.librewolf = {
          enable = true;
          settings.clearOnShutdown.enable = false;
          averageUserMode = true;
        };
        home = {
          language = let
            langOpts = {
              "english" = {
              };
              "czech" = {
                base = "cs_CZ.UTF-8";
                messages = "cs_CZ.UTF-8";
                collate = "cs_CZ.UTF-8";
                ctype = "cs_CZ.UTF-8";
              };
            };
          in
            langOpts.${cfg.language};
        };
      };
    };
}
