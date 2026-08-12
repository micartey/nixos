{ lib, meta, ... }:

# This is not an actual SDDM but rather the opposite of it
# It will automatically log you into your default non-root user account without login password
{
  services.displayManager = {
    autoLogin.enable = true;
    autoLogin.user = meta.user.username;
  };

  services.getty.autologinUser = lib.mkForce meta.user.username;
}
