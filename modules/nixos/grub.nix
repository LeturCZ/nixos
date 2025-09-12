{
  lib,
  inputs,
  config,
  system,
  ...
}:
with lib; {
  config.boot.loader = {
    timeout = 1;
    grub = {
      enable = mkDefault true;
      theme = mkDefault "${inputs.poly-dark-grub-theme.packages.${system}.poly-dark-grub-theme}";
      splashImage = null; #disable NixOS default splash image
      backgroundColor = "#000000";
      extraConfig = ''
        set timeout_style=hidden
      '';
    };
  };
}
