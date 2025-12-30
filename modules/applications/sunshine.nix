{ pkgs-legacy, ... }:

{
  # I don't need moonlight here on my main desktop as this is often the host
  # environment.systemPackages = with pkgs; [ moonlight-qt ];

  services.sunshine = {
    package = pkgs-legacy.sunshine;
    enable = true;
    autoStart = false;
    capSysAdmin = true;
    openFirewall = true;
  };
}
