{ meta, ... }:

{
  programs.thunderbird = {
    enable = true;
    profiles.${meta.user.username} = {
      isDefault = true;
    };
  };
}
