# sops

> And everything I need to know

```bash
# Default is nano
export EDITOR=vim
sops secrets/secrets.yaml
```

## Setup

### Generate age key

```bash
# generate new key
nix shell nixpkgs#age -c age-keygen -o ~/.config/sops/age/keys.txt

# generate new key from private ssh key
# NOTE: This can be used to re-generate the age key from the private key
nix run nixpkgs#ssh-to-age -- -private-key -i ~/.ssh/some_key > ~/.config/sops/age/keys.txt
```

```bash
# get a public key of ~/.config/sops/age/keys.txt
nix shell nixpkgs#age -c age-keygen -y ~/.config/sops/age/keys.txt
```

### Create `.sops.yaml`

```yaml
keys:
  - &primary {{YOUR KEY HERE}}
creation_rules:
  - path_regex: secrets/secrets.yaml$
    key_groups:
    - age:
      - *primary
```
