{
  pkgs-unstable,
  pkgs,
  ...
}:

let
  tcpPorts = [
    7000
    7001
    7002
  ];
  udpPorts = [
    6000
    6001
    6002
  ];

  fwTool = "${pkgs.nixos-firewall-tool}/bin/nixos-firewall-tool";

  uxplay-wrapped = pkgs.writeShellScriptBin "uxplay" ''
    cleanup() {
      sudo ${fwTool} reset
    }
    trap cleanup EXIT

    ${builtins.concatStringsSep "\n" (map (p: "sudo ${fwTool} open tcp ${toString p}") tcpPorts)}
    ${builtins.concatStringsSep "\n" (map (p: "sudo ${fwTool} open udp ${toString p}") udpPorts)}

    ${pkgs-unstable.uxplay}/bin/uxplay -p tcp 7000 -p udp 6000 -nh -n home "$@"
  '';
in
{
  environment.systemPackages = [ uxplay-wrapped ];

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
      userServices = true;
    };
  };
}
