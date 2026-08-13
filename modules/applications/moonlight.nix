{ pkgs, ... }:

{
  profiles = [ "lenovo" ];

  environment.systemPackages = [ pkgs.moonlight-qt ];
}
