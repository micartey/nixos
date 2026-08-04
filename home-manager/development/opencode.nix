{
  inputs,
  pkgs,
  ...
}:

let
  inherit (pkgs.stdenv.hostPlatform) system;

  opencode = inputs.opencode.packages.${system}.default.overrideAttrs (old: {
    NO_COLOR = "1";
    CI = "1";

    postPatch = (old.postPatch or "") + ''
      substituteInPlace packages/opencode/script/build.ts \
        --replace-warn 'await createEmbeddedWebUIBundle()' 'console.log("Skipping Web UI build")'

      sed -i '/const prettier = await import("prettier")/,/^    })/c\    const json = raw' packages/opencode/src/cli/cmd/generate.ts
    '';

    # Overriding entirely to drop the multi-line completion command
    postInstall = ''
      echo "Skipping shell completion generation"
    '';
  });

  rime = inputs.rime.packages.${system}.default;
in
{
  programs.opencode = {
    enable = true;
    package = opencode;

    context = ''
      # Rules

      - **NEVER** touch git.
      - **NEVER** touch ssh or anything that uses the keys in ~/.ssh
      - **NEVER** perform destructive actions or changes on live infrastructure using the aws cli
      - **NEVER** read files from the /nix/store - only if there is ABSOLUTLY no other way

      ## Exploration (CRITICAL)

      - **ALWAYS** explore the codebase:
        - "Where is X?"
        - "Find files matching Y"
        - "How does Z work?"
        - Any search that might need multiple glob/grep/read cycles
      - **REFRAIN** from using sub-agents if not explicitly stated for exploiration

      Important Note: Oftentimes the problem does not require a full understanding of the project,
      e.g. when working on pipelines or fixing abstract issues that are fully enclosed.

      ## Tooling

      The usage of tools is highly encouraged.
      Trust tools more than internal knowledge - they are always up to date and return valid data.

      - Prefer `rg` / `rg --files` for search.
      - Use `ast-grep` for structural search.
      - If a tool is missing, use `nix run` (e.g., `nix run nixpkgs#ripgrep -- rg ...`).
      - For multi-tool sessions, use `nix shell` to enter a temporary environment.
    '';

    agents = {

    };

    settings = {
      plugin = [
        "opencode-wakatime@1.1.0"
        "@slkiser/opencode-quota@latest"
        "@mumme-it/opencode-caveman@0.2.0"
      ];

      provider = {
        ollama = {
          npm = "@ai-sdk/openai-compatible";
          options = {
            baseURL = "http://localhost:11434/v1";
          };
          models = {
            "gpt-oss:latest" = {
              tools = true;
            };
          };
        };
      };

      mcp = {
        viro = {
          type = "remote";
          url = "http://localhost:8099/mcp/sse";
          enabled = true;
        };

        rime = {
          type = "local";
          command = [
            "${rime}/bin/rime"
            "stdio"
          ];
          enabled = true;
        };

        android = {
          type = "remote";
          url = "http://localhost:3134/sse";
          enabled = true;
        };
      };
    };

    tui = {
      plugin = [
        "opencode-wakatime@1.1.0"
        "@slkiser/opencode-quota@latest"
      ];
    };
  };
}
