{config, ...}: {
  imports = [
    ./nixpkgs.nix
    ./packages.nix
    ./programs.nix
    # ./user.nix
  ];
}
