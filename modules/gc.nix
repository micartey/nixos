{ ... }:

{
  profiles = [ "default" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 24d";
  };
}
