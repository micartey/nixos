{ ... }:

{
  # services.displayManager.sddm = {
  #   enable = true;

  #   theme = "catppuccin-mocha";
  #   package = pkgs.kdePackages.sddm;
  # };

  services.displayManager = {
    autoLogin.enable = true;
    autoLogin.user = "daniel";
  };

  services.getty.autologinUser = "daniel";

  # environment.systemPackages = [
  #   (pkgs.catppuccin-sddm.override {
  #     flavor = "mocha";
  #     font = "Noto Sans";
  #     fontSize = "9";
  #     background = "${../wallpapers/default.jpg}";
  #     loginBackground = true;
  #   })
  # ];
}
