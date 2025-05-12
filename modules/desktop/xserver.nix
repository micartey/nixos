{
  services.xserver = {
    enable = true;
    xkb = {
      layout = "de";
      variant = "";
    };

    displayManager = {
      gdm.enable = true;
    };

    desktopManager.gnome.enable = true;
  };

}
