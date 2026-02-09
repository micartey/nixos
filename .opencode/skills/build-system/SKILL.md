---
name: build-system
description: Build the NixOS Configuration
compatibility: opencode
---

## What I do

Build the configuration and switch to it:

```bash
sudo just home-switch
```

## When to use me

Use this to apply changes to the configuration you did so that they take effect.
You can also use me when you want to test if something works - if I fail, you need to fix the cause.
