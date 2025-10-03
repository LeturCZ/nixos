{pkgs, ...}:
pkgs.stdenv.mkDerivation {
  name = "Ephemeral.webp";
  version = "1.0.0";
  src = pkgs.fetchurl {
    url = "https://www.dropbox.com/scl/fi/okq2t6paz55x6ovj57zy7/Ephemeral.webp?rlkey=nq47tqv5bzl4awg8rsqahn2u1&st=7664ns3m&dl=1";
    hash = "sha512-eyXqyAZ6rNzb4VHVfS4mvD5TLI+5EemDuYZkdMj8G6Qob4OWJlWwzIMS1C1il03knzoGL5ri7iubZUo6qdSF/g==";
  };

  unpackPhase = "true";

  buildPhase = "true";

  installPhase = "cp $src $out";
}
