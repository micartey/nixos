# Corsair XENEON EDGE DDC Controls

Date: 2026-06-24

## Detection

The Corsair XENEON EDGE is connected as `DP-2` and is controllable over DDC/CI:

```bash
I2C_XENEON_ID=$(ddcutil detect | grep -B 4 "XENEON" | grep "I2C" | awk '{ print $3 }' | awk -F- '{print $2}')

# $ ddcutil detect
# Display 2
#    I2C bus:  /dev/i2c-7
#    DRM_connector: card1-DP-2
#    Mfg id: CRX
#    Model: XENEON EDGE
#    VCP version: 2.2
```

Use `--bus $I2C_XENEON_ID` with `ddcutil` to target this display specifically.

## Brightness

Read current brightness:

```bash
ddcutil --bus $I2C_XENEON_ID getvcp 10
```

Set brightness, for example 30%:

```bash
ddcutil --bus $I2C_XENEON_ID setvcp 10 30
```

## Contrast

Read current contrast:

```bash
ddcutil --bus $I2C_XENEON_ID getvcp 12
```

Set contrast, for example 50%:

```bash
ddcutil --bus $I2C_XENEON_ID setvcp 12 50
```

## Color Presets

Supported color preset values:

```text
01: sRGB
02: Display Native
04: 5000 K
05: 6500 K
06: 7500 K
08: 9300 K
0b: User 1
```

Set a warmer 5000 K preset:

```bash
ddcutil --bus $I2C_XENEON_ID setvcp 14 04
```

Set standard 6500 K:

```bash
ddcutil --bus $I2C_XENEON_ID setvcp 14 05
```

## Stronger Blue Reduction

For stronger blue reduction, switch to `User 1`, then reduce blue gain:

```bash
ddcutil --bus $I2C_XENEON_ID setvcp 14 11
ddcutil --bus $I2C_XENEON_ID --noverify setvcp 16 100
ddcutil --bus $I2C_XENEON_ID --noverify setvcp 18 90
ddcutil --bus $I2C_XENEON_ID --noverify setvcp 1A 55
```

`ddcutil` accepts VCP values as decimal numbers or as `x..` hex values. The
capabilities output shows `0b`, but `setvcp` does not accept that spelling as a
value. Use decimal `11` or hex `x0b` for the `User 1` preset.

The XENEON EDGE / Realtek controller may report `DDCRC_VERIFY` while verifying
video gain writes. Use `--noverify` for `16`, `18`, and `1A`, then read values
back separately:

```bash
ddcutil --bus $I2C_XENEON_ID getvcp 14 16 18 1A
```

VCP gain codes:

```text
16: Video gain: Red
18: Video gain: Green
1A: Video gain: Blue
```

## Save Settings

Save current monitor settings:

```bash
ddcutil --bus $I2C_XENEON_ID scs
```

## Useful Inspection Commands

Show display detection:

```bash
ddcutil detect
```

Show supported controls:

```bash
ddcutil --bus $I2C_XENEON_ID capabilities
```

Read important current values:

```bash
ddcutil --bus $I2C_XENEON_ID getvcp 10 12 14 16 18 1A
```

## NixOS Setup

The host config was updated to enable DDC/CI access and install `ddcutil`:

```nix
hardware.i2c.enable = true;

environment.systemPackages = with pkgs; [
  ddcutil
];
```

The `hardware.i2c.enable` option grants `/dev/i2c-*` access to local seat users and users in the `i2c` group.
