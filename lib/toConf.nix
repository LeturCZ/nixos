{lib, ...}: let
  inner = input: lib.strings.concatLines (lib.attrsets.mapAttrsToList (key: value: "${key}=${builtins.toString value}") input);
in
  input:
    lib.strings.concatLines (lib.attrsets.mapAttrsToList (key: value: "[${key}]\n${inner value}") input)
