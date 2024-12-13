# nixos

![img](preview.png)

### Logical Architecture

```
flake
  │
  └──hosts
       │
       ├──desktop
       │     │
       │     ├──default.nix
       │     │      │
       │     │      └──~/home/desktop
       │     │           │
       │     │           └──default.nix
       │     │                  │
       │     │                  ├──*.nix
       │     │                  │
       │     │                  └──../default.nix
       │     │                          │
       │     │                          ├──editor.nix
       │     │                          │
       │     │                          └──shell.nix
       │     │
       │     ├──*.nix
       │     │
       │     └──~/modules/**.nix
       │            │
       │            └──sobs.nix
       │                 │
       │                 └──~/secrets/secrets.yaml
       │
       └── TODO
             │
             └──default.nix
                    │
                    └──~/home/headless
                         │
                         └──default.nix
                                │
                                ├──*.nix
                                │
                                └──../default.nix
                                        │
                                        ├──editor.nix
                                        │
                                        └──shell.nix
```
