# nixos

<div align="center">
    <img src="https://github.com/micartey/nixos/actions/workflows/flake-check.yml/badge.svg" alt="badge">
    <img src="https://github.com/micartey/nixos/actions/workflows/dead-code.yml/badge.svg" alt="badge">
</div>

> [!IMPORTANT]
> I do not recommend anyone to use it since it is heavily personalised to my needs.
> I share this repository to simplify tracking, sharing of errors and config parts, as well of ease of access on new setups.

![img](preview.png)

## Synopsis

```
.
├── dots
│   └── dotfiles, e.g. mpv, oh-my-posh, ...
├── home-manager
│   ├── desktop
│   │   └── home-manager config for all hosts
│   ├── home
│   │   └── additional config for my home desktop host
│   └── shared config for both desktop and headless hosts
├── hosts
│   ├── desktops
│   │   ├── home
│   │   │   └── NixOS config for my home desktop host
│   │   └── shared config for all desktop hosts
│   └── shared config for both desktop and server hosts
├── modules
│   └── NixOS modules for various services and apps
├── secrets
│   └── sops secret files
```
