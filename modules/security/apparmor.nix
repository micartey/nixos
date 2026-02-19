{
  pkgs,
  pkgs-unstable,
  meta,
  config,
  ...
}:

let
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
      		#include <tunables/global>

      		# Attach to the binary, handling wrappers and store paths
      		profile firefox /{usr/bin/firefox,nix/store/*/bin/firefox,nix/store/*/lib/firefox/firefox} {
        		#include <abstractions/base>
        		#include <abstractions/nameservice>
        		#include <abstractions/fonts>

        		# ------------------------------------------------
        		# 1. Broad Access (Mimicking Firejail's base)
        		# ------------------------------------------------
        		# 'allow all' is generally insecure, but required to mimic
        		# a "blacklist-only" approach without breaking Firefox.
        		# Ideally, you would replace this with explicit includes later.
        		file,
        		network,
        		dbus,

        		# ------------------------------------------------
        		# 2. Strict Blocks (The "Firejail" restrictions)
        		# ------------------------------------------------

        		# DENY rules always override ALLOW rules in AppArmor.
        		# 'audit' ensures these attempts are logged to dmesg/journal.

        		# Block SOPS binaries (Execution)
        		audit deny ${pkgs-unstable.sops}/bin/sops x,
        		audit deny ${pkgs.sops}/bin/sops x,
        		audit deny /run/current-system/sw/bin/sops x,

        		# Block SSH Keys and Config (Read/Write/Lock/Link/Execute)
        		# Corresponds to: --blacklist="$HOME/.ssh"
        		audit deny @{HOME}/.ssh/ r,
        		audit deny @{HOME}/.ssh/** mrwklx,

        		# Block Secrets (Files/Dirs)
        		# Corresponds to: --blacklist={sops keys}
        		audit deny ${sops.age.keyFile} mrwklx,
        		audit deny /run/secrets/ r,
        		audit deny /run/secrets/** mrwklx,

        		# Block User Configuration Secrets
        		audit deny @{HOME}/.config/sops/ r,
        		audit deny @{HOME}/.config/sops/** mrwklx,
        		audit deny /etc/sops/** mrwklx,

        		# Specific User Paths from your config
        		audit deny @{HOME}/nixos/dns/creds.json mrwklx,
        		audit deny @{HOME}/nixos/secrets/** mrwklx,
        		audit deny @{HOME}/nixos/sops/** mrwklx,

        		# Enforce Read-Only Nix Store
        		# Corresponds to: --read-only=/nix/store
        		# We allow 'r' (read) and 'x' (exec) via 'file' allow above,
        		# but explicitly DENY 'w' (write) here.
        		audit deny /nix/store/** w,
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
