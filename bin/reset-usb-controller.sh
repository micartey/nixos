#!/usr/bin/env bash
set -euo pipefail

driver="/sys/bus/pci/drivers/xhci_hcd"
keyboard_vendor="1038"
keyboard_product="1644"
keyboard_device=""
controller=""

for device in /sys/bus/usb/devices/*; do
    [[ -r "$device/idVendor" && -r "$device/idProduct" ]] || continue

    vendor=$(<"$device/idVendor")
    product=$(<"$device/idProduct")
    [[ "$vendor" == "$keyboard_vendor" && "$product" == "$keyboard_product" ]] || continue

    device_path=$(readlink -f "$device")
    if [[ "$device_path" =~ /([[:xdigit:]]{4}:[[:xdigit:]]{2}:[[:xdigit:]]{2}\.[[:xdigit:]])/usb[0-9]+/ ]]; then
        keyboard_device="$device"
        controller="${BASH_REMATCH[1]}"
        break
    fi
done

if [[ -z "$controller" ]]; then
    printf 'SteelSeries keyboard USB device not found.\n' >&2
    exit 1
fi

if [[ ! -e "$driver/$controller" ]]; then
    printf 'xHCI controller not found: %s\n' "$controller" >&2
    exit 1
fi

printf 'Found keyboard at %s.\n' "$keyboard_device"
printf 'Resetting xHCI controller %s...\n' "$controller"
printf 'USB devices on this controller will disconnect briefly.\n'

sudo sh -c '
    controller="$1"
    driver=/sys/bus/pci/drivers/xhci_hcd

    printf "%s\n" "$controller" > "$driver/unbind"
    sleep 2
    printf "%s\n" "$controller" > "$driver/bind"
' usb-controller-reset "$controller"

printf 'xHCI controller rebound. USB devices should re-enumerate now.\n'
