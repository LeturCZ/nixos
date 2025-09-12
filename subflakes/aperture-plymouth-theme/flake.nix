{
  description = "An Aperture Science themed spinner theme for Plymouth";

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
        aperture-plymouth-theme = legacyPackages.${name}.stdenv.mkDerivation {
          pname = "aperture-plymouth-theme";
          version = "1.0.0";

          src = ./src;

          dontBuild = true;

          installPhase = ''
            runHook preInstall
            mkdir -p $out/share/plymouth/themes/aperture
            cp * $out/share/plymouth/themes/aperture
            find $out/share/plymouth/themes/ -name \*.plymouth -exec sed -i "s@\/usr\/@$out\/@" {} \;
            runHook postInstall
          '';
        };
      });
    };
}
