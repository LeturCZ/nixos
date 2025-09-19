{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    codium-exts = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aperture-plymouth-theme = {
      url = "path:./subflakes/aperture-plymouth-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    poly-dark-grub-theme = {
      url = "path:./subflakes/poly-dark-grub-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      # follows = "nixpkgs"; #! Does not have the home manager module if follow is set
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nur,
    ...
  } @ inputs: let
    codium-pkgs-universal = inputs.codium-exts.extensions;
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
  in rec {
    lib = import ./lib {inherit pkgs;};
    nixosConfigurations = {
      # leturlaptop =
      # let
      #   system = "x86_64-linux";
      #   codium-pkgs = codium-pkgs-universal.${system};
      # in
      # nixpkgs.lib.nixosSystem {
      #   inherit system;
      #   specialArgs = {inherit inputs codium-pkgs system;};
      #   modules = [
      #     ./commons
      #     ./modules
      #     ./hosts/leturlaptop
      #     inputs.disko.nixosModules.disko
      #     nur.modules.nixos.default
      #   ];
      # };
      leturlaptop2 = let
        system = "x86_64-linux";
        codium-pkgs = codium-pkgs-universal.${system};
      in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs codium-pkgs system;
            customUtils = lib;
          };
          modules = [
            ./commons
            ./modules
            ./hosts/leturlaptop2
            nur.modules.nixos.default
          ];
        };
    };
  };
}
