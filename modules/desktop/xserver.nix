{
  services.xserver = {
    enable = true;
    xkb = {
      layout = "de";
      variant = "";
    };

    displayManager = {
      lightdm.enable = false;
      startx.enable = true;
    };
  };
}
