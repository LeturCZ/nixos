{
  description = "A customized Poly Dark theme for grub";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }:
    with nixpkgs; {
      packages = lib.genAttrs ["x86_64-linux"] (name: {
        poly-dark-grub-theme = legacyPackages.${name}.stdenv.mkDerivation {
          pname = "poly-dark-grub-theme";
          version = "1.0.0";

          src = ./src;

          dontBuild = true;

          installPhase = ''
            runHook preInstall
            mkdir -p "$out/"
            cp -r * "$out/"
            runHook postInstall
          '';
        };
      });
    };
}
