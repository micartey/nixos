{
  inputs,
  pkgs,
  pkgs-unstable,
  pkgs-edge,
  ...
}:

let
  inherit (pkgs.stdenv.hostPlatform) system;
  inherit (pkgs-unstable) github-mcp-server;

  github-mcp-server-wrapped = pkgs.writeShellScriptBin "github-mcp-server" ''
    source /run/secrets/rendered/opencode/env
    exec ${github-mcp-server}/bin/github-mcp-server "$@"
  '';

  rime = inputs.rime.packages.${system}.default;
  kicad-mcp = pkgs.callPackage ../../pkgs/kicad-mcp.nix { };
in
{
  profiles = [ "default" ];

  programs.opencode = {
    enable = true;
    package = pkgs-edge.opencode;

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

    settings = {
      plugin = [
        "opencode-wakatime@1.1.0"
        "@slkiser/opencode-quota@latest"
        "@mumme-it/opencode-caveman@0.2.0"
        # "@thelioo/opencode-balancer@latest"
      ];

      # lsp = true;

      provider = {
        lmstudio = {
          npm = "@ai-sdk/openai-compatible";
          name = "LM Studio (local)";
          options = {
            baseURL = "http://127.0.0.1:1234/v1";
          };
          models = {
            "openai/gpt-oss-20b" = {
              name = "gpt-oss";
            };

            "qwen/qwen3.5" = {
              name = "qwen3.5";
            };

            "google/gemma-4-12b-qat" = {
              name = "gemma-4-12b-qat";
            };

            "qwen/qwen3.6-35b-a3b" = {
              name = "qwen3.6-35b-a3b";
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

        # This is just a test mcp for me to mess around and learn mcp + oauth integration
        test = {
          type = "remote";
          url = "http://localhost:8888/mcp";
          enabled = true;
          oauth = {
            scope = "mcp:read mcp:write";
          };
        };

        cdn = {
          type = "remote";
          url = "http://kvm-large:7080/mcp";
          enabled = true;
        };

        # cdn_local = {
        #   type = "remote";
        #   url = "http://localhost:7080/mcp";
        #   enabled = true;
        # };

        rime = {
          type = "local";
          command = [
            "${rime}/bin/rime"
            "stdio"
          ];
          enabled = true;
        };

        github = {
          type = "local";
          command = [
            "${github-mcp-server-wrapped}/bin/github-mcp-server"
            "stdio"
          ];
          enabled = true;
        };

        kicad = {
          type = "local";
          command = [ "${kicad-mcp}/bin/kicad-mcp" ];
          enabled = true;
          timeout = 60000;
          environment.KICAD_IPC_CONNECT_TIMEOUT = "30";
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
        # "@thelioo/opencode-balancer@latest"
      ];
    };
  };

  xdg.configFile."opencode/opencode.json".force = true;
}
