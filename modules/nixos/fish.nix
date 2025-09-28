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
in {
  options = {
  };
  config = {
    programs.fish.enable = mkIf anyUserHasFish true;
  };
}
