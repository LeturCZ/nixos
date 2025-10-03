{pkgs, ...}:
pkgs.stdenv.mkDerivation {
  name = "Stellarium.webp";
  version = "1.0.0";
  src = pkgs.fetchurl {
    url = "https://www.dropbox.com/scl/fi/3gamz3udy4c5dmsxj7d0m/Stellarium.webp?rlkey=b28hei9swo62y43aezuyk0smj&st=2b4d8pm9&dl=1";
    hash = "sha512-VBS9CRmAbVRVSdzG3ros/WdGgg0M1IqyhHF0GP0qR2tM0U3bRn7GbuHuPtZ7rsTlQ1VAgm/vcC/vkkpsvdz4aQ==";
  };

  unpackPhase = "true";

  buildPhase = "true";

  installPhase = "cp $src $out";
}
