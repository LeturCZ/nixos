{
  lib,
  config,
  ...
}:
with lib;
{
  options = {
    home-manager.users = lib.mkOption {
      type = types.attrsOf (
        types.submoduleWith {
          modules = toList (
            { name, ... }:
            let
              cfg = config.home-manager.users.${name};
            in
            {
              options.programs.vscode = {
                startupArguments = mkOption {
                  type = types.attrs;
                  default = {
                    enable-crash-reporter = false;
                  };
                  description = "Set permanent commandline arguments for vscode";
                };
                disableAIFeatures = mkOption {
                  type = types.bool;
                  default = true;
                };
                profiles = mkOption {
                  type = types.attrsOf (
                    types.submoduleWith {
                      shorthandOnlyDefinesConfig = true;
                      modules = toList (
                        { name, ... }:
                        {
                          config.userSettings."chat.disableAIFeatures" = mkIf cfg.programs.vscode.disableAIFeatures false;
                        }
                      );
                    }
                  );
                };
              };
              config = mkIf cfg.programs.vscode.enable {
                home.file.vscodeArgv = {
                  enable = true;
                  force = true;
                  target = ".vscode-oss/argv.json";
                  text = builtins.toJSON cfg.programs.vscode.startupArguments;
                };

              };
            }
          );
        }
      );
    };
  };
}
