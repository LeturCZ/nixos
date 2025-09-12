{
  inputs,
  config,
  ...
}: {
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
    ./disko.nix
    ../../commons/nixpkgs.nix
    ../../users
    inputs.home-manager.nixosModules.home-manager
    inputs.stylix.nixosModules.stylix
  ];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "old";
}
