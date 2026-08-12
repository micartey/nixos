{ meta, ... }:

let
  mkSudoCmd = options: command: {
    inherit command options;
  };

  # Helper for specific common options
  noPass = mkSudoCmd [ "NOPASSWD" ];
  withPass = mkSudoCmd [ ];
  # both = mkSudoCmd [
  #   "NOPASSWD"
  #   "NOEXEC"
  # ];
in
{
  security.sudo = {
    enable = true;
    extraRules = [
      {
        users = [ meta.user.username ];
        runAs = "root";
        commands = [
          (withPass "/run/current-system/sw/bin/nixos-rebuild")
          (noPass "/run/current-system/sw/bin/tc")
          (noPass "/etc/profiles/per-user/${meta.user.username}/bin/liquidctl")
        ];
      }
    ];
  };
}
