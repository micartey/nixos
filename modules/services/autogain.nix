{ pkgs, ... }:

{
  systemd.user.services.disable-autogain = {
    description = "Disable autogain workaround";

    # Adds the binaries from these packages to the service's PATH
    path = with pkgs; [
      procps
      pipewire
    ];

    serviceConfig = {
      # Use the command directly since it's now in the PATH
      ExecStart = "${pkgs.unixtools.watch}/bin/watch -n 1 wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 60%";
      Restart = "on-failure";
      RestartSec = "5s";
    };

    # Use the correct target for a user service
    wantedBy = [ "default.target" ];
  };
}
