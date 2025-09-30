{
  pkgs,
  lib,
  self,
  ...
}: directory: let
  contents = builtins.readDir directory;
  directories = lib.filterAttrs (name: value: value == "directory") contents;
  nixFiles = lib.filterAttrs (name: value: value == "regular" && lib.strings.hasSuffix ".nix" name && name != "default.nix") contents;
  otherFiles = lib.filterAttrs (name: value: value == "regular" && ! lib.strings.hasSuffix ".nix" name) contents;
  removeSuffix = name: lib.strings.removeSuffix (name |> builtins.match "^.*(\\.[^.]+)$" |> builtins.head) name;
in
  with lib.attrsets;
  # show non-nix files as-is
    mapAttrs' (name: value: nameValuePair (removeSuffix name) (directory + "/${name}")) otherFiles
    # import nix files as packages
    // mapAttrs' (name: value: nameValuePair (removeSuffix name) (pkgs.callPackage directory + "/${name}")) nixFiles
    # recursively import directories
    // builtins.mapAttrs (name: value: self.outputs.lib.importPackagesRecursive (directory + "/${name}")) directories
