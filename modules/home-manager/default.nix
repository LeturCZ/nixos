{lib, ...}: {
  imports = with builtins; let
    remove = list: filter: lib.remove list filter;
  in
    readDir ./.
    |> attrNames
    |> remove "default.nix"
    |> map (name: ./. + "/${name}");
}
