{
  config,
  lib,
  meta,
  ...
}:

let
  secrets = import ../../lib/secrets.nix { inherit config lib; };
  user = meta.user.username;
in

{
  profiles = [ "default" ];

  sops = secrets.mkTemplate "opencode/env" {
    owner = user;
    path = "/run/secrets/rendered/opencode/env";
    secrets = [ "opencode/github-pat" ];
    content = placeholder: ''
      export GITHUB_PERSONAL_ACCESS_TOKEN="${placeholder."opencode/github-pat"}"
    '';
  };
}
