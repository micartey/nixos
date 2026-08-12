{ ... }:

{
  # Copy walpapers to location
  home.file = {
    wallpapers = {
      source = ../../dots/wallpapers;
      target = ".local/wallpapers";
    };
  };

  services.hyprpaper = {
    enable = true;

    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2;

      preload = [ "~/.local/wallpapers/default.jpg" ];
      wallpaper = [
        {
          monitor = "";
          path = "~/.local/wallpapers/default.jpg";
        }
      ];
    };
  };
}
