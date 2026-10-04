{ lib, ... }:

{
  profiles = [ "lenovo" ];

  boot.kernelParams = [ "amd_pstate=active" ];

  services.tlp.enable = lib.mkForce false;
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        energy_performance_preference = "power";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };
}
