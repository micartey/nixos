{
  config,
  lib,
  ...
}:

# @profile lenovo
let
  cfg = config.hardware.lenovoLegionLinux;
  kernelModule = config.boot.kernelPackages.callPackage ../../pkgs/lenovo-legion-linux.nix { };
in
{
  options.hardware.lenovoLegionLinux = {
    enable = lib.mkEnableOption "Lenovo Legion Linux fan controls";

    readOnly = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Prevent LenovoLegionLinux from writing EC settings.";
    };

    force = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Force module loading when DMI matching fails.";
    };

    enablePlatformProfile = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Register LenovoLegionLinux platform-profile provider.";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.extraModulePackages = [ kernelModule ];
    boot.kernelModules = [ "legion_laptop" ];

    boot.extraModprobeConfig = ''
      options legion_laptop ec_readonly=${if cfg.readOnly then "1" else "0"} force=${
        if cfg.force then "1" else "0"
      } enable_platformprofile=${if cfg.enablePlatformProfile then "1" else "0"}
    '';
  };
}
