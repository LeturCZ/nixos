{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  anyUserHasFish =
    (config.users.users
      |> filterAttrs (name: value: value.shell == pkgs.fish)
      |> builtins.attrNames
      |> builtins.length)
    > 0;
  hmUsersFishEnabled =
    config.home-manager.users
    |> filterAttrs (name: value: value.programs.fish.enable == true)
    |> mapAttrs (name: value: {shell = mkDefault pkgs.fish;});
in {
  options = {
    home-manager.users = lib.mkOption {
      type = types.attrsOf (
        types.submoduleWith {
          modules = toList (
            {name, ...}: let
              cfg = config.home-manager.users.${name};
            in {
              options.programs.fish = {
                enableZoxide = mkEnableOption "use zoxide instead of the regular cd command";
                enableStarship = mkEnableOption "enable Starship prompt for the fish shell";
              };
              config = {
                programs.zoxide = mkIf cfg.programs.fish.enableZoxide {
                  enable = true;
                  enableFishIntegration = true;
                  options = ["--cmd cd"];
                };
                programs.fish.shellInitLast = mkIf cfg.programs.fish.enableStarship ''
                  ${pkgs.starship}/bin/starship init fish | source
                '';
              };
            }
          );
        }
      );
    };
  };
  config = {
    programs.fish.enable = mkIf anyUserHasFish true;

    # set fish shell as login shell for each user who has it enabled in home manager
    users.users = hmUsersFishEnabled;
  };
}
