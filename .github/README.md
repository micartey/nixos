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
│   ├── apps
│   │   └── some applications
│   ├── desktop
│   │   └── desktop related things
│   ├── develpment
│   │   └── sdks, ideas and everything related to development
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


## Lenovo Hardware Controls

Lenovo can be shit - sadly my device is one of the "shitty" ones.
Lets see how the hinge holds up...

### Fan controls

Controling the fans on lenovo yoga 7x pro is actually possible with lenovo legion linux.

#### Dust Cleaning Mode

These fan options are built in, but not very partical to regulate temprature.

```bash
# Silent mode
sudo su -c "echo 0 > /sys/devices/pci0000:00/0000:00:14.3/PNP0C09:00/VPC2004:00/fan_mode"

# Dust cleaning mode
sudo su -c "echo 1 > /sys/devices/pci0000:00/0000:00:14.3/PNP0C09:00/VPC2004:00/fan_mode"
```

#### Lenovo Legion Linux Fan Curve

Jobs resolve `legion_hwmon` by name, so they do not depend on unstable `hwmon`
indexes.

##### Custom Temperature Graph

```bash
# This sets values that represent the RPM per temprature
just lenovo-fan-curve
```

##### Maximum Curve Speed

```bash
# Set every curve point to maximum PWM.
# This device reaches roughly 55% of its 10,000 RPM sensor range.
just lenovo-fan-max
```

Fan curves are stored in laptop firmware and may reset after reboot, suspend,
or power-mode changes. Reapply curve when needed. The `fan_fullspeed` control
is exposed by the module but does not work on this device.

### Battery controls

Enable this if your laptop should've been a desktop all along.

```
# Disable battery conservation (load to 100%)
sudo su -c "echo 0 > /sys/devices/pci0000:00/0000:00:14.3/PNP0C09:00/VPC2004:00/conservation_mode"

# Enable battery conservation (stop at 80%)
sudo su -c "echo 1 > /sys/devices/pci0000:00/0000:00:14.3/PNP0C09:00/VPC2004:00/conservation_mode"
```

### Bluetooth

Enabling and disabling bluetooth can be a struggle, this is probably due to the setup and not hardware related.
To enable or disable it, use the just commands below:

```bash
# Enable bluetooth
just bluetooth-start

# Disable bluetooth
just bluetooth-stop
```
