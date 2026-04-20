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

    rules = ''
      # Rules

      - **NEVER** perform commits.

      ## Exploration (CRITICAL)

      - **ALWAYS** explore the codebase:
        - "Where is X?"
        - "Find files matching Y"
        - "How does Z work?"
        - Any search that might need multiple glob/grep/read cycles

      ## Tooling

      - Prefer `rg` / `rg --files` for search.
      - Use `ast-grep` for structural search.
      - If a tool is missing, use `nix run` (e.g., `nix run nixpkgs#ripgrep -- rg ...`).
      - For multi-tool sessions, use `nix shell` to enter a temporary environment.

      ## Scratchpad (Knowledge Cache)

      - `.scratchpad/*.md` persists across sessions.
      - Use the format `YYYY-MM-DD-topic.md` for scratchpad files (e.g., `2025-11-03-zig-stdlib_changes.md`).
      - Domain agents (nix, zig) read/write scratchpad directly.
      - Before deep exploration: check scratchpad.
      - After expensive research: write to scratchpad.

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

      nix = # markdown
        ''
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
      ];

      provider = {
        ollama = {
          npm = "@ai-sdk/openai-compatible";
          options = {
            baseURL = "http://localhost:11434/v1";
          };
          models = {
            # ollama run gpt-oss:latest
            # >>> /set parameter num_ctx 65536
            # >>> /save gpt-oss-20b-32k
            # >>> /bye
            "gpt-oss-20b-64k" = {
              options = {
                extraBody = {
                  think = "high";
                };
              };
            };

            # ollama run gemma4
            # >>> /set parameter num_ctx 65536
            # >>> /save gemma4-32k
            # >>> /bye
            "gemma4-64k" = {
              options = {
              };
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
  };
}
