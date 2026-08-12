{ pkgs, ... }:

{
  systemd.user.services.twenty-twenty-twenty = {
    description = "20-20-20 Rule reminder";

    path = with pkgs; [ libnotify ];

    serviceConfig = {
      ExecStart = "${pkgs.libnotify}/bin/notify-send '20-20-20 Rule' 'Take a break and look outside for 20 seconds' -u critical -i face-glasses";
      Type = "oneshot";
      # RemainAfterExit = "yes";
    };

    wantedBy = [ "twenty-twenty-twenty.timer" ];
  };

  systemd.user.timers.twenty-twenty-twenty = {
    description = "Timer for 20-20-20 Rule reminders";

    timerConfig = {
      OnCalendar = "*:0/20";
      Persistent = true;
      RandomizedDelaySec = "20min";
    };

    wantedBy = [ "timers.target" ];
  };
}
