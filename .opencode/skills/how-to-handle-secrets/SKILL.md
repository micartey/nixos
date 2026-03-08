---
name: how-to-handle-secrets
description: Information on how to handle sops secrets
compatibility: opencode
---

## What I do

Always check `./lib/secrets.nix` and use the functions to set options.

### Templates

To generate a file with secrets of a specific form, use template:

```nix
secrets.mkTemplate <NAME> {
  owner = user;
  path = "path/to/secret.json";
  secrets = [
    "application/email"
    "application/account_id"
    "application/global_api_key"
  ];
  content = placeholder: ''
    {
      "authentication": {
        "accountid": "${placeholder."application/account_id"}",
        "apikey": "${placeholder."application/global_api_key"}",
        "apiuser": "${placeholder."application/email"}"
      }
    }
  '';
};
```

### File

For files that only include the raw secret use:

```nix
services.testservice = {
  enable = true;
  authKeyFile = secrets.path "testservice/auth_key";
};

sops = secrets.mkValue "testservice/auth_key" {
  owner = meta.user.username;
};
```

## When to use me

When you want to handle secrets e.g. read secrets from sops and write them to file.
