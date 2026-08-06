default:
    @just --list

# Like home-switch but with only one job at a time
# When initially installing nixos you will run in an out-of-memory error

# Idk why nix is stpudid like that
home-init:
    nixos-rebuild switch --flake .#home --max-jobs 1

home-switch:
    nixos-rebuild switch --flake .#home --max-jobs 1 --cores 8

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

flake-update:
    nix flake update
