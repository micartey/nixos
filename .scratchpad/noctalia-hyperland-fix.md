# Noctalia-Shell Workspace Clicks Fix After Hyprland Update

## Problem

After updating Hyprland, clicking the workspace pills in `noctalia-shell` did nothing.
Other mouse-driven shell actions (focusing windows from the bar, etc.) were also
unresponsive. Keyboard shortcuts defined in Hyprland itself kept working.

The user explicitly asked **not** to update `noctalia-shell`, because they disliked
the newer version.

## Environment

- **Compositor:** Hyprland 0.55.2
- **Shell:** noctalia-shell 2026-04-20 (commit `ed1fff6`)
- **Config style:** Lua (`wayland.windowManager.hyprland.configType = "lua";`)
- **NixOS channel:** nixos-26.05

## Investigation

### 1. Check running services and recent logs

```bash
systemctl --user status noctalia-shell --no-pager -l
journalctl --user -u noctalia-shell -n 200 --no-pager
```

The shell was running, but the journal contained repeated warnings from
`quickshell.hyprland.ipc`:

```text
WARN quickshell.hyprland.ipc: Dispatch request "workspace 1" failed with error
  "error: [string \"return hl.dispatch(workspace 1)\"]:1: ')' expected near '1'"

WARN quickshell.hyprland.ipc: Dispatch request "focuswindow address:0x..." failed with error
  "error: [string \"return hl.dispatch(focuswindow address:0x...)\"]:1: ')' expected near 'address'"

WARN quickshell.hyprland.ipc: Dispatch request "alterzorder top,address:0x..." failed with error
  "error: [string \"return hl.dispatch(alterzorder top,address:0x...)\"]:1: ')' expected near 'top'"
```

This showed that noctalia-shell was issuing raw Hyprland dispatcher commands,
and Hyprland was rejecting them.

### 2. Understand why the commands were rejected

Hyprland 0.55.2 changed the behaviour of the IPC `dispatch` command when the
config is written in Lua. The dispatcher handler in `src/debug/HyprCtl.cpp`
now does:

```cpp
if (Config::mgr()->type() == Config::CONFIG_LUA) {
    std::string evalStr = std::format("return hl.dispatch({})", in);
    ...
}
```

So a request like `/dispatch workspace 1` becomes:

```lua
return hl.dispatch(workspace 1)
```

`workspace` is no longer a string here — Lua parses it as a variable, and the
whole expression is invalid. In Lua mode, `hl.dispatch` expects a dispatcher
**object** from `hl.dsp.*`, e.g.:

```lua
hl.dsp.focus({ workspace = "1" })
```

### 3. Verify the correct Lua syntax manually

Using `hyprctl` directly confirmed the needed shape of the calls:

```bash
hyprctl dispatch 'hl.dsp.focus({workspace = "3"})'
hyprctl dispatch 'hl.dsp.focus({window = "address:0x613c0fe8a2a0"})'
hyprctl dispatch 'hl.dsp.window.alter_zorder({mode = "top", window = "address:0x613c0fe8a2a0"})'
hyprctl dispatch 'hl.dsp.dpms({action = "on"})'
```

All returned `ok`.

### 4. Find where noctalia-shell emits the legacy commands

The installed QML file is:

```text
/nix/store/...-noctalia-shell-.../share/noctalia-shell/Services/Compositor/HyprlandService.qml
```

It contained the raw commands:

```qml
Hyprland.dispatch(`workspace ${workspace.name}`)
Hyprland.dispatch(`workspace ${workspace.idx}`)
Hyprland.dispatch(`focuswindow address:0x${windowId}`)
Hyprland.dispatch(`alterzorder top,address:0x${windowId}`)
Hyprland.dispatch(`killwindow address:0x${window.id}`)
```

and similar legacy `hyprctl dispatch ...` calls for DPMS, exit, and exec.

## Root Cause

`noctalia-shell` (the current pinned version) was written against Hyprland’s
legacy dispatcher syntax. Hyprland 0.55.2, when configured with the Lua
config manager, now expects dispatcher **objects** (`hl.dsp.*`) instead of raw
strings. The shell was still sending raw strings, so every click-generated
dispatch failed with a Lua parse error.

## Solution

Patch the **current** `noctalia-shell` package to emit Lua dispatcher objects.
This keeps the disliked newer version out of the system while making the old
version compatible with Hyprland 0.55.2 + Lua config.

### Files changed

1. `patches/noctalia-hyprland-lua-dispatch.patch`
   - Patches `Services/Compositor/HyprlandService.qml` in the noctalia-shell
     source.
   - Adds a small `_luaString()` helper to escape `"` and `\` so workspace
     names and window IDs stay safe inside Lua strings.
   - Converts all relevant dispatch calls to `hl.dsp.*` syntax.

2. `home-manager/desktop/noctalia.nix`
   - Applies the patch to the pinned noctalia-shell package via
     `overrideAttrs`.

The important mappings are:

| Old legacy call | New Lua call |
|-----------------|--------------|
| `workspace N` | `hl.dsp.focus({workspace = "N"})` |
| `focuswindow address:0x…` | `hl.dsp.focus({window = "address:0x…"})` |
| `alterzorder top,address:0x…` | `hl.dsp.window.alter_zorder({mode = "top", window = "address:0x…"})` |
| `killwindow address:0x…` | `hl.dsp.window.kill({window = "address:0x…"})` |
| `dpms off` / `dpms on` | `hl.dsp.dpms({action = "off"})` / `hl.dsp.dpms({action = "on"})` |
| `exit` | `hl.dsp.exit()` |
| `exec <cmd>` | `hl.dsp.exec_cmd("<cmd>")` |

### How to apply

```bash
sudo nixos-rebuild switch --flake .#home
```

### How to revert

If you ever switch Hyprland back to a hyprlang/legacy config, this patch will
no longer be correct. Remove the `package` override from
`home-manager/desktop/noctalia.nix` and delete
`patches/noctalia-hyprland-lua-dispatch.patch`, then rebuild.

## Verification

- `nixos-rebuild build --flake .#home` succeeded and produced the patched
  `noctalia-shell` derivation.
- The patched `HyprlandService.qml` in the new store path contains the
  `hl.dsp.*` calls.
- After `nixos-rebuild switch`, clicking workspace pills and focusing windows
  from the bar works again.

## Lessons for Future Issues

1. **Read the journal first.** The error messages from `quickshell.hyprland.ipc`
   pointed directly at the IPC command format.
2. **Check the generated Hyprland config type.** `configType = "lua"` changes
   how `hyprctl dispatch` interprets arguments.
3. **Look at the source of the broken calls.** The QML service in
   `noctalia-shell` was sending raw strings; the C++ backend already had Lua
   handling, but the QML path did not use it.
4. **Patch, don’t upgrade, when asked.** `overrideAttrs` with a small patch
   keeps the user on the version they want while fixing the incompatibility.
