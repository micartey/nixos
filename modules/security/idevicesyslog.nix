{ pkgs, pkgs-legacy, ... }:
{
  services.usbmuxd = {
    enable = true;
    package = pkgs.usbmuxd2; # Recommended for newer hardware
  };

  # idevicepair pair
  # idevicesyslog > iphone_logs.txt
  # idevicebackup2 backup --full /path/to/your/backup/folder
  # mvt-ios check-backup --output ./reports /path/to/backup/
  environment.systemPackages = [
    pkgs.libimobiledevice
    pkgs-legacy.mvt
  ];
}
