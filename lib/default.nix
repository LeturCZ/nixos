{pkgs, ...}: {
  toConf = pkgs.callPackage ./toConf.nix {};
  getAllModules = pkgs.callPackage ./getAllModules.nix {};
  electronWaylandFlags = import ./electronWaylandFlags.nix;
}
