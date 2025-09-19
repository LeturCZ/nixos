{
  inputs,
  config,
  ...
}: {
  imports = [
    ./configuration.nix
    ../../commons/nixpkgs.nix
    ../../users/letur
    inputs.home-manager.nixosModules.home-manager
    inputs.stylix.nixosModules.stylix
  ];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "old";
}
