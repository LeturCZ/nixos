{pkgs, ...}:
pkgs.stdenv.mkDerivation {
  name = "Emily_Dream_in_a_Moment.webp";
  version = "1.0.0";
  src = pkgs.fetchurl {
    url = "https://www.dropbox.com/scl/fi/6v5w00ndocekxc0vysauw/Emily_Dream_in_a_Moment.webp?rlkey=gx97tqn91t6536f7l51on2rdp&st=7wiugwke&dl=1";
    hash = "sha512-Ie4jvBUlX1W08cWhmswtwufKEnXtdif7HEvmRu5KEKMJCVz/pfb52s9WE7HkQ91/CuRK2BQ7j7m97dry49IKSA==";
  };

  unpackPhase = "true";

  buildPhase = "true";

  installPhase = "cp $src $out";
}
