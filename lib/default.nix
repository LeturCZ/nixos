{pkgs, ...}: {
  toConf = pkgs.callPackage ./toConf.nix {};
}
