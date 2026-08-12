{ pkgs, ... }:

# @profile lenovo
{
  environment.systemPackages = [ pkgs.moonlight-qt ];
}
