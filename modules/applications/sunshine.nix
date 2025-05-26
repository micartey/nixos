{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ moonlight-qt ];

  services.sunshine = {
    enable = true;
    autoStart = false;
    capSysAdmin = true;
    openFirewall = true;
  };
}
