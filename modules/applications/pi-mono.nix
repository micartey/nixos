{
  pkgs,
  inputs,
  system,
  config,
  meta,
  ...
}:

let
  pi-mono = inputs.pi-mono.packages.${system}.coding-agent;
  pi-fff = pkgs.callPackage ../../pkgs/pi-fff.nix { inherit inputs; };
  pi-mcp = pkgs.callPackage ../../pkgs/pi-mcp-adapter.nix { inherit inputs; };
in
{
  imports = [
    inputs.pi-mono.nixosModules.default
  ];

  programs.pi.coding-agent = {
    enable = true;

    # appended to the system prompt
    # rules = ''
    #   # AGENTS.md
    #   Be concise.
    # '';

    # extra skills
    # skills = [ ./skills/my-skill ];

    # extra extensions
    # extensions = [ ./extensions/my-extension.ts ];

    extensions = [
      ../../dots/pi/extensions/wakatime.ts
      "${pi-fff}/packages/pi-fff/src/index.ts"
      "${pi-mcp}/index.ts"
    ];

    # extra themes
    themes = [ ../../dots/pi/catppuccin-mocha.json ];

    # extra prompt templates
    # promptTemplates = [ ./prompts ./prompt-templates/review.md ];

    # ~/.pi/agent/models.json
    models =
      pkgs.runCommand "pi-mono-models.json"
        {
          nativeBuildInputs = [ pkgs.tsx ];
        }
        ''
          tsx ${../../dots/pi/models.mjs} \
            ${pi-mono.src}/packages/ai/src/models.generated.ts \
            opencode-go > $out
        '';

    # environment variables or env file
    environment = {
      OPENCODE_API_KEY = config.sops.secrets."pi-mono/opencode_api_key".path;
    };
  };

  sops.secrets = {
    "pi-mono/opencode_api_key" = {
      owner = meta.user.username;
    };
  };
}
