{
  inputs,
  pkgs-unstable,
  meta,
  ...
}:

# @profile default
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  environment.systemPackages = with pkgs-unstable; [ sops ];

  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/${meta.user.username}/.config/sops/age/keys.txt";
}
