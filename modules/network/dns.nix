{ lib, ... }:

{
  networking.networkmanager = {
    enable = lib.mkDefault true;
    dns = "systemd-resolved";
  };

  services.resolved = {
    enable = true;
    extraConfig = ''
      DNS=100.72.132.37
    '';
    fallbackDns = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
      "8.8.4.4"
    ];
  };
}
