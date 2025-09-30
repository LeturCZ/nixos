{
  pkgs,
  self,
  ...
}: {
  toConf = pkgs.callPackage ./toConf.nix {};
  getAllModules = pkgs.callPackage ./getAllModules.nix {};
  electronWaylandFlags = import ./electronWaylandFlags.nix;
  importPackagesRecursive = pkgs.callPackage ./importPackagesRecursive.nix {inherit self;};
}
