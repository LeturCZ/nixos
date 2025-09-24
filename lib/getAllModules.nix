{lib, ...}:
with builtins; let
  remove = list: filter: lib.remove list filter;
in
  path:
    readDir path
    |> attrNames
    |> remove "default.nix"
    |> map (name: path + "/${name}")
