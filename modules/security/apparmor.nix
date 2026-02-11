{
  pkgs,
  pkgs-unstable,
  meta,
  config,
  inputs,
  system,
  ...
}:

let
  firefox = pkgs-unstable.firefox;
  opencode = inputs.opencode.packages.${system}.default;

  inherit (config) sops;
in
{
  security.apparmor.enable = true;

  #
  # Firefox
  #
  security.apparmor.policies.firefox = {
    state = "enforce";
    profile = ''
      	      abi <abi/4.0>,
      	      include <tunables/global>

      	      profile firefox "/{usr/bin/firefox,etc/profiles/per-user/*/bin/firefox,nix/store/*/bin/firefox,nix/store/*/lib/firefox/firefox}" {
      	        include <abstractions/base>

      	        allow all,

      	        audit deny "${pkgs-unstable.sops}/bin/sops" x,
      	        audit deny "${pkgs.sops}/bin/sops" x,

      	        audit deny "${sops.age.keyFile}" rwklm,
      	        audit deny "/etc/sops/age/**" rwklm,
      	        audit deny "/etc/sops/**" rwklm,

      	        audit deny "/home/${meta.user.username}/nixos/dns/creds.json" rwklm,
      	        audit deny "/run/secrets/" r,
      	        audit deny "/run/secrets/**" r,
      	        audit deny "/home/${meta.user.username}/nixos/secrets/**" rwklm,
      	        audit deny "/home/${meta.user.username}/nixos/sops/**" rwklm,
      	        audit deny "/home/${meta.user.username}/.config/sops/**" rwklm,
      	        audit deny "/home/${meta.user.username}/.ssh/**" rwklm,
      	      }
      	    '';
  };

  #
  # Opencode
  #
  security.apparmor.policies.opencode = {
    state = "enforce";
    profile = ''
      	      abi <abi/4.0>,
      	      include <tunables/global>

      	      profile opencode "/{etc/profiles/per-user/*/bin/opencode,nix/store/*/bin/opencode}" {
      	        include <abstractions/base>

      	        allow all,

      	        audit deny "${pkgs-unstable.sops}/bin/sops" x,
      	        audit deny "${pkgs.sops}/bin/sops" x,

      	        audit deny "${sops.age.keyFile}" rwklm,
      	        audit deny "/etc/sops/age/**" rwklm,
      	        audit deny "/etc/sops/**" rwklm,

      	        audit deny "/home/${meta.user.username}/nixos/dns/creds.json" rwklm,
      	        audit deny "/run/secrets/" r,
      	        audit deny "/run/secrets/**" r,
      	        audit deny "/home/${meta.user.username}/nixos/secrets/**" rwklm,
      	        audit deny "/home/${meta.user.username}/nixos/sops/**" rwklm,
      	        audit deny "/home/${meta.user.username}/.config/sops/**" rwklm,
      	        audit deny "/home/${meta.user.username}/.ssh/**" rwklm,
      	      }
      	    '';
  };
}
