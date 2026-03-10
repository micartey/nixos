{ lib, ... }:

{
  # services.tlp = {
  #   enable = true;
  #   settings = {
  #     CPU_MIN_PERF_ON_AC = 0;
  #     CPU_MAX_PERF_ON_AC = 100;
  #     CPU_MIN_PERF_ON_BAT = 0;
  #     CPU_MAX_PERF_ON_BAT = 20;

  #     # Optional helps save long term battery health
  #     START_CHARGE_THRESH_BAT0 = 20; # 40 and below it starts to charge
  #     STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
  #   };
  # };
  #

  boot.kernelParams = [ "amd_pstate=active" ];

  services.tlp.enable = lib.mkForce false;

  services.auto-cpufreq = lib.mkForce {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        # Limit max frequency in kHz (example: 1.2GHz)
        scaling_max_freq = 1100000;
        # Set energy preference to maximum power saving
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
