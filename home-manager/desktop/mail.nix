{ ... }:

{
  programs.thunderbird = {
    enable = true;
    profiles.daniel = {
      isDefault = true;
    };
  };
}
