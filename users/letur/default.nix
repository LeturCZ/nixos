{
  config,
  home-manager,
  pkgs,
  codium-pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
  ];

  # syncthing allows
  # TODO make module + conditional enable
  networking.firewall = {
    allowedUDPPorts = [22000 21027];
    allowedTCPPorts = [21027];
  };

  home-manager.users.letur = import ./home.nix {
    inherit pkgs codium-pkgs lib inputs;
  };
}
