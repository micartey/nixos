{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nautilus

    ffmpeg-headless
    ffmpegthumbnailer
  ];

  environment.pathsToLink = [
    "share/thumbnailers"
  ];
}
