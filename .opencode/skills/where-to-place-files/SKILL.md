---
name: where-to-place-files
description: Information on where to place .nix files
compatibility: opencode
---

## What I do

Give rules and best practices on where to place files that are either imported via:

- Home Manager: `/home-manager`
- Normal: `/modules`

Inside of these paths, you need to explore the folder structure and decide on your own where the file fits.

You do not need to manually import any file you place there, as they are automatically imported.
Therefore, it is important that you follow that rule.

But you always need to run `git add <file>` so that when building the system, it won't fail!

## When to use me

When you want to create a file.
