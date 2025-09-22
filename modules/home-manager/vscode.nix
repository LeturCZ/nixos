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
                  default = { };
                  description = "Set permanent commandline arguments for vscode";
                };
                disableAIFeatures = mkOption {
                  type = types.bool;
                  default = true;
                };
                crashReporting = {
                  enable = mkEnableOption "Enable VSCode crash reporter";
                  id = mkOption {
                    type = types.strMatching "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}";
                    description = "The crash reporter identifier";
                    example = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
                  };
                };
                profiles = mkOption {
                  type = types.attrsOf (
                    types.submoduleWith {
                      shorthandOnlyDefinesConfig = true;
                      modules = toList (
                        { name, ... }:
                        {
                          config.userSettings."chat.disableAIFeatures" = mkIf cfg.programs.vscode.disableAIFeatures true;
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
                  text = builtins.toJSON (
                    lib.attrsets.optionalAttrs cfg.programs.vscode.crashReporting.enable {
                      crash-reporter-id = cfg.programs.vscode.crashReporting.id;
                    }
                    // cfg.programs.vscode.startupArguments
                    // {
                      enable-crash-reporter = cfg.programs.vscode.crashReporting.enable;
                    }
                  );
                };
              };
            }
          );
        }
      );
    };
  };
}
