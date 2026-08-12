{ ... }:

{
  services.earlyoom = {
    enable = true;
    enableNotifications = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 10;
    extraArgs = [
      "--prefer"
      "^(chrome|chromium|firefox|electron|code|node|python[0-9.]*|java|nix|llama.*|ollama|cc1plus|clang.*|rustc|cargo|zig|ld|ld\\.lld|mold)$"

      "--avoid"
      "^(systemd|sshd|dbus|NetworkManager|nix-daemon)$"
    ];
  };
}
