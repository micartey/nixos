---
name: build-system
description: Build the NixOS Configuration
compatibility: opencode
---

## What I do

Build the configuration and switch to it:

```bash
just home-switch
```

**You absolutely have to run this command - Not the command behind the justfile**

## When to use me

Use this to apply changes to the configuration you did so that they take effect.
You can also use me when you want to test if something works - if I fail, you need to fix the cause.
