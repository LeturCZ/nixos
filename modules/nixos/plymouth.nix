{
  lib,
  config,
  inputs,
  system,
  ...
}:
with lib; {
  config = let
    cfg = config.boot.plymouth;
  in {
    boot = {
      plymouth = {
        enable = mkDefault true;
        theme = mkIf cfg.enable (mkDefault "aperture");
        themePackages = mkIf cfg.enable (mkDefault [inputs.aperture-plymouth-theme.packages.${system}.aperture-plymouth-theme]);
      };
      initrd.verbose = mkIf cfg.enable false;
      consoleLogLevel = mkIf cfg.enable 0;
      kernelParams = mkIf cfg.enable ["quiet" "splash" "udev.log_level=0"];
    };
  };
}
