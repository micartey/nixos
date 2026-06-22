{
  inputs,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  inherit (pkgs.stdenv.hostPlatform) system;
  inherit (pkgs-unstable) github-mcp-server;

  github-mcp-server-wrapped = pkgs.writeShellScriptBin "github-mcp-server" ''
    source /run/secrets/rendered/opencode/env
    exec ${github-mcp-server}/bin/github-mcp-server "$@"
  '';

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

      - **NEVER** perform commits.
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

      ## Domain Agents

      - `nix`: ALL Nix/NixOS work.
      - `viro`: ALL Viro/Drawing related work.
    '';

    agents = {
      viro = ''
        # Viro Agent

        Specialized agent for Viro drawing tool.
        Handle ALL Viro/Drawing-related tasks autonomously.

        ## Workflow

        1. Create the required shape in thought
        2. Check the viro tools at your disposal and their descriptions
        3. Plan how to use the tools in succession
        4. Use the tools
      '';

      nix = ''
        # Nix Agent

        Specialized agent for Nix/NixOS work. Handle ALL Nix-related tasks autonomously.

        ## Scratchpad
        - Read `.scratchpad/*-nix-*.md` before deep exploration
        - Write findings to `.scratchpad/YYYY-MM-DD-nix-<topic>.md` after learning non-obvious patterns
        - Format: `# Title`, `## Summary`, `## Details`, `## References`

        ## Workflow
        1. Check scratchpad for cached knowledge
        2. Use `rime` MCP tools (manix, nixhub, wiki)
        3. Make changes
        4. Validate: `nix flake check` or `nix-instantiate --parse`
        5. Format: `nixfmt`
        6. Cache new knowledge to scratchpad

        ## Return Format
        - What was changed
        - Commands to run (e.g., `nixos-rebuild switch`)
      '';
    };

    settings = {
      plugin = [
        "opencode-wakatime@1.1.0"
        "@thelioo/opencode-balancer@0.2.8"
        "@mumme-it/opencode-caveman@0.2.0"
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
        "@thelioo/opencode-balancer@latest"
      ];
    };
  };
}
