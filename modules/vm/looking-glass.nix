{ pkgs-unstable, ... }:

# @profile home
{
  environment.systemPackages = [ pkgs-unstable.looking-glass-client ];
}

# looking-glass-client -m KEY_F1
