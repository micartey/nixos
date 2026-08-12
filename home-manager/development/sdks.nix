{
  pkgs,
  pkgs-unstable,
  pkgs-edge,
  ...
}:

{
  programs.bun = {
    package = pkgs-edge.bun;
    enable = true;
  };

  programs.go = {
    enable = true;
    package = pkgs-unstable.go_1_25;
  };

  programs.java = {
    enable = true;
    package = (pkgs.jdk17.override { enableJavaFX = true; });
  };

  home.packages = [
    # nix-related
    pkgs.nixd
    pkgs.nixfmt-rfc-style

    pkgs-unstable.gnumake
    pkgs-unstable.gcc

    # go-related
    pkgs.delve
    pkgs.gopls
    pkgs.tinygo

    # erlang-related
    pkgs.erlang
    pkgs.elixir
    # pkgs.gleam

    # java-related
    # pkgs.zulu21
    pkgs.gradle_7
    pkgs.lefthook
    (pkgs.callPackage ../../pkgs/recaf.nix { })

    # scala-related
    pkgs-unstable.scala
    pkgs-unstable.sbt
    pkgs-unstable.metals
    pkgs-unstable.coursier

    # nodejs-related
    pkgs.nodejs

    # python-related
    pkgs.python3
    pkgs.uv
    pkgs.python312Packages.grip

    pkgs.socat

    # zig-related
    pkgs-unstable.zig

    # miscellaneous
    pkgs.d2

    pkgs.glab
  ];
}
