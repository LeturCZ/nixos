{pkgs, ...}:
pkgs.stdenv.mkDerivation {
  name = "Lumine_Falling_Midnight.webp";
  version = "1.0.0";
  src = pkgs.fetchurl {
    url = "https://www.dropbox.com/scl/fi/7svzu97orktwvvdeluhrf/Lumine_Falling_Midnight.webp?rlkey=emxd23nsfda8ggh5djzd8401h&st=98n1hp89&dl=1";
    hash = "sha512-fYNaZQW47DCkqI7AwZsPOb8Ulcq0HnM8oJojqdUxDHAf560Jg09NTYsPgeshptER7jntxpi7giwsirvLvYNf0Q==";
  };

  unpackPhase = "true";

  buildPhase = "true";

  installPhase = "cp $src $out";
}
