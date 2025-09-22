{
  config,
  lib,
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
              options.programs.keepassxc = {
                darkTheme = mkOption {
                  type = types.bool;
                  default = true;
                };
                secretService = mkOption {
                  type = types.bool;
                  default = true;
                  description = "Enable KeepassXC Freedesktop.org Secret Service integration";
                };
              };
              config = mkIf cfg.programs.keepassxc.enable {
                programs.keepassxc = {
                  autostart = true;
                  settings = {
                    General.ConfigVersion = 2;
                    Browser = {
                      Enabled = true;
                      CustomProxyLocation = null;
                    };
                    FdoSecrets.Enabled = cfg.programs.keepassxc.secretService;
                    GUI = {
                      ApplicationTheme =
                        if cfg.programs.keepassxc.darkTheme
                        then "dark"
                        else "light";
                      MinimizeOnClose = true;
                      MinimizeToTray = true;
                      ShowTrayIcon = true;
                      TrayIconAppearance = "monochrome-light";
                    };
                    SSHAgent.enabled = true;
                    Security.LockDatabaseIdle = true;
                  };
                };
                xdg.autostart.enable = mkIf cfg.programs.keepassxc.autostart true;
                wayland.windowManager.hyprland.settings = mkIf cfg.wayland.windowManager.hyprland.enable {
                  exec-once = mkIf cfg.programs.keepassxc.autostart ["keepassxc --minimized"];
                  windowrule = [
                    "float, class:org.keepassxc.KeePassXC, title:Unlock Database - KeePassXC"
                    "pin, class:org.keepassxc.KeePassXC, title:Unlock Database - KeePassXC"
                    "center, class:org.keepassxc.KeePassXC, title:Unlock Database - KeePassXC"
                    "stayfocused, class:org.keepassxc.KeePassXC, title:Unlock Database - KeePassXC"
                    "float, class:org.keepassxc.KeePassXC, title:KeePassXC -  Access Request"
                    "pin, class:org.keepassxc.KeePassXC, title:KeePassXC -  Access Request"
                    "center, class:org.keepassxc.KeePassXC, title:KeePassXC -  Access Request"
                    "stayfocused, class:org.keepassxc.KeePassXC, title:KeePassXC -  Access Request"
                  ];
                };
                programs.vscode.startupArguments =
                  mkIf (cfg.programs.keepassxc.secretService && cfg.programs.vscode.enable)
                  {
                    "password-store" = "gnome-libsecret";
                  };
              };
            }
          );
        }
      );
    };
  };
}
