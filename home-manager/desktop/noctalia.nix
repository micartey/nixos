{
  inputs,
  lib,
  ...
}:

{
  imports = [ inputs.diutalia.homeModules.default ];

  programs.diutalia-shell = {
    enable = true;
    systemd.enable = true;

    settings = builtins.fromJSON (builtins.readFile ../../dots/noctalia/settings.json);

    # colors = {
    #   mPrimary = "#cba6f7";
    #   mOnPrimary = "#1e1e2e";
    #   mSecondary = "#f5c2e7";
    #   mOnSecondary = "#1e1e2e";
    #   mTertiary = "#89dceb";
    #   mOnTertiary = "#1e1e2e";
    #   mError = "#f38ba8";
    #   mOnError = "#1e1e2e";
    #   mSurface = "#1e1e2e";
    #   mOnSurface = "#cdd6f4";
    #   mSurfaceVariant = "#181825";
    #   mOnSurfaceVariant = "#bac2de";
    #   mOutline = "#6c7086";
    #   mShadow = "#11111b";
    #   mHover = "#313244";
    #   mOnHover = "#cdd6f4";
    # };
  };

  systemd.user.services.diutalia-shell.warnings = lib.mkForce { };

  # xdg.configFile."diutalia/colors.json".force = true;
}
