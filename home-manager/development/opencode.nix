{
  pkgs,
  pkgs-unstable,
  pkgs-edge,
  ...
}:

let
  # inherit (pkgs.stdenv.hostPlatform) system;
  inherit (pkgs-unstable) github-mcp-server;

  github-mcp-server-wrapped = pkgs.writeShellScriptBin "github-mcp-server" ''
    source /run/secrets/rendered/opencode/env
    exec ${github-mcp-server}/bin/github-mcp-server "$@"
  '';

  gpt-cheap = "openai/gpt-6-luna";
in
{
  profiles = [ "default" ];

  programs.opencode = {
    enable = true;
    package = pkgs-edge.opencode;

    context = ''
      # Rules

      - **NEVER** touch git on your own - only through dedicated sub-agents if they exist.
      - **NEVER** touch ssh or anything that uses the keys in ~/.ssh
      - **NEVER** perform destructive actions or changes on live infrastructure using the aws cli
      - **NEVER** read files from the /nix/store - only if there is ABSOLUTLY no other way

      ## Exploration (CRITICAL)

      - **ALWAYS** explore the codebase:
        - "Where is X?"
        - "Find files matching Y"
        - "How does Z work?"
        - Any search that might need multiple glob/grep/read cycles
      - **DO NOT** use sub-agents for exploiration unless explicitly instructed.

      > Important Note:
      > Oftentimes the problem does not require a full understanding of the project, e.g. when working on pipelines or fixing abstract issues that are fully enclosed.
      > In these cases, **ONLY** explore the relevant pieces.

      ## Tooling

      The usage of tools is highly encouraged.
      Trust tools more than internal knowledge - they are always up to date and return valid data.

      - Prefer `rg` / `rg --files` for search.
      - Use `ast-grep` for structural search.
      - If a tool is missing, use `nix run` (e.g., `nix run nixpkgs#ripgrep -- rg ...`).
      - For multi-tool sessions, use `nix shell` to enter a temporary environment.

      ### Bash Tools

      When using the bash tool, make sure the commands are not returning big amounts of text by combining them with e.g. `grep` unless there is a reason to read the entire output.
      This is especially true for build commands.

      ### Build apps

      When you want to build an application e.g. npm build, gradle build, etc. hand the task to the `@builder` agent.
      This is one of the few agents you are permitted to use manually.

      ### Git

      #### Commit

      After you have implemented a fix, feature, etc. you should commit the changes.
      First you need to make sure that the build works and tests do not fail -> This is part of the `@builder` agent.
      When everything looks fine, use the `@gitcommit` agent to create the commits.

      **IMPORTANT**: make sure the feature is fully implemented. That means do not ask every time if it is implemented, commit once the task changes to another task.

      #### Fix

      When the user or yourself has troubles with git because some more complicated tasks are required, e.g. deleting, squashing, merging, applying stash with merge conflicts and many more issues arrise, use `@gitfix`.
    '';

    settings = {
      plugin = [
        "opencode-wakatime@1.1.0"
        "@slkiser/opencode-quota@latest"
        "@mumme-it/opencode-caveman@0.2.0"
      ];

      # lsp = true;

      agent = {
        builder = {
          description = "Build applications";
          mode = "subagent";
          model = gpt-cheap;
          prompt = ''
            Your task is to build the application(s) in question.
            When building the application, make sure you run commands in combination with e.g. pipes to reduce the amount of text you need to read.
            Only read the entire command output when absolutly necessary - cleverly crafted pipes are often enough.

            ## Troubleshoot

            In case you are facing issues, please follow according to these cases.

            ### Tools are missing

            If a tool is missing, use `nix run` (e.g., `nix run nixpkgs#ripgrep -- rg ...`)

            ### Build failed

            Do not explore the project or fix / identify the root cause.
            Just return the root cause to the main agent and stop
          '';
          tools = {
            write = false;
            edit = false;
            bash = true;
          };
        };

        gitcommit = {
          description = "Git Commits";
          mode = "subagent";
          models = gpt-cheap;
          prompt = ''
            Your task is to create semantic commits.
            You first need to understand though if the changes happend in directories that have their own .git directory or not.
            Make commits in depth first style. Meaning to commit the changes of repositories that are in the file tree before the commits in their parents.
          '';
          tools = {
            write = false;
            edit = false;
            bash = true;
          };
        };

        gitfix = {
          description = "Git Fix";
          mode = "subagent";
          models = gpt-cheap;
          prompt = ''
            Your task is resolve issues with git.
            Make sure you work meticulously to prevent losing data.
            If you are unsure what to keep, what to discard etc. use the question tool to ask the user.
            You can commit fixes, but do not push them!
          '';
          tools = {
            write = false;
            edit = false;
            bash = true;
          };
        };
      };

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
        # viro = {
        #   type = "remote";
        #   url = "http://localhost:8099/mcp/sse";
        #   enabled = true;
        # };

        # This is just a test mcp for me to mess around and learn mcp + oauth integration
        # test = {
        #   type = "remote";
        #   url = "http://localhost:8888/mcp";
        #   enabled = true;
        #   oauth = {
        #     scope = "mcp:read mcp:write";
        #   };
        # };

        # cdn = {
        #   type = "remote";
        #   url = "http://kvm-large:7080/mcp";
        #   enabled = true;
        # };

        # cdn_local = {
        #   type = "remote";
        #   url = "http://localhost:7080/mcp";
        #   enabled = true;
        # };

        github = {
          type = "local";
          command = [
            "${github-mcp-server-wrapped}/bin/github-mcp-server"
            "stdio"
          ];
          enabled = true;
        };

        # android = {
        #   type = "remote";
        #   url = "http://localhost:3134/sse";
        #   enabled = true;
        # };
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
