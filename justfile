default:
    @just --list

home-switch:
    sudo nixos-rebuild switch --flake .#home

lenovo-switch:
    sudo nixos-rebuild switch --flake .#lenovo-yoga-7x-pro

host-switch host:
    sudo nixos-rebuild switch --flake .#{{host}}

bluetooth-start:
    rfkill unblock bluetooth
    bluetoothctl power on

bluetooth-stop:
    bluetoothctl power off
    rfkill block bluetooth

# Apply custom Lenovo Legion fan curve.
lenovo-fan-curve:
    #!/usr/bin/env bash
    sudo sh -c '
    set -eu

    hwmon=
    for path in /sys/class/hwmon/hwmon*; do
        if [ "$(cat "$path/name" 2>/dev/null)" = legion_hwmon ]; then
            hwmon="$path"
            break
        fi
    done

    [ -n "$hwmon" ] || {
        echo "legion_hwmon not found" >&2
        exit 1
    }

    echo 0 > "$hwmon/minifancurve"

    for pwm in 1 2; do
        echo 26  > "$hwmon/pwm${pwm}_auto_point1_pwm"
        echo 50  > "$hwmon/pwm${pwm}_auto_point2_pwm"
        echo 100 > "$hwmon/pwm${pwm}_auto_point3_pwm"
        echo 150 > "$hwmon/pwm${pwm}_auto_point4_pwm"
        echo 200 > "$hwmon/pwm${pwm}_auto_point5_pwm"
        echo 255 > "$hwmon/pwm${pwm}_auto_point6_pwm"

        echo 40 > "$hwmon/pwm${pwm}_auto_point1_temp"
        echo 50 > "$hwmon/pwm${pwm}_auto_point2_temp"
        echo 60 > "$hwmon/pwm${pwm}_auto_point3_temp"
        echo 70 > "$hwmon/pwm${pwm}_auto_point4_temp"
        echo 80 > "$hwmon/pwm${pwm}_auto_point5_temp"
        echo 90 > "$hwmon/pwm${pwm}_auto_point6_temp"
    done
    '

# Set every fan-curve point to maximum PWM.
lenovo-fan-max:
    #!/usr/bin/env bash
    sudo sh -c '
    set -eu

    hwmon=
    for path in /sys/class/hwmon/hwmon*; do
        if [ "$(cat "$path/name" 2>/dev/null)" = legion_hwmon ]; then
            hwmon="$path"
            break
        fi
    done

    [ -n "$hwmon" ] || {
        echo "legion_hwmon not found" >&2
        exit 1
    }

    for pwm in 1 2; do
        for point in 1 2 3 4 5 6; do
            echo 255 > "$hwmon/pwm${pwm}_auto_point${point}_pwm"
        done
    done
    '

home-iso:
    NIX_BUILD_CORES=25 nix build \
        .#nixosConfigurations.homeImg.config.system.build.isoImage \
        --impure

    sudo cp result/iso/nixos-26.05.20260608.bd0ff2d-x86_64-linux.iso nixos.iso

home-vm:
    ./bin/nixos-vm.sh

flake-update:
    nix flake update

flake-update-unstable:
    nix flake update nixpkgs-unstable

flake-update-edge:
    nix flake update nixpkgs-edge

flake-update-development:
    nix flake update nix-vim
    nix flake update opencode

# Run 'nix run nixpkgs#gdrive3 account add' before you can use this command!
iso-upload:
    nix run nixpkgs#gdrive3 files upload nixos-$(date +%d.%m.%Y).iso

# Since 26.05 I have issues with my USB hub and keyboard. Running this will restart the usb controller instead of needing to reboot
# Finds mouse controller from sysfs or dead-controller message in kernel log. Pass PCI controller to override.
fix-usb-controller controller="":
    sudo ./bin/reset-usb-controller.sh {{controller}}

# Runtime check: TracerPid stays 0 while a process is actively straced.
# Only meaningful after rebuild+reboot with the patch applied.
verify-tracer-pid-hidden:
    ./bin/tracer-pid-test.sh
