#!/usr/bin/env bash
set -euo pipefail

driver="/sys/bus/pci/drivers/xhci_hcd"
controller="${1:-}"
target_device=""

if [[ -n "$controller" && ! "$controller" =~ ^[[:xdigit:]]{4}:[[:xdigit:]]{2}:[[:xdigit:]]{2}\.[[:xdigit:]]$ ]]; then
    printf 'Invalid PCI controller address: %s\n' "$controller" >&2
    exit 2
fi

if [[ -z "$controller" ]]; then
    # Find mouse first because keyboard and mouse are on different controllers here.
    # Mad Catz R.A.T. 6+ mouse: 12cf:0c04.
    for target in 12cf:0c04; do
        target_vendor=${target%:*}
        target_product=${target#*:}

        for device in /sys/bus/usb/devices/*; do
            [[ -r "$device/idVendor" && -r "$device/idProduct" ]] || continue

            vendor=$(<"$device/idVendor")
            product=$(<"$device/idProduct")
            [[ "$vendor" == "$target_vendor" && "$product" == "$target_product" ]] || continue

            device_path=$(readlink -f "$device")
            # Resolved path contains .../<PCI address>/usbN/..., e.g. 15:00.0/usb3/.
            if [[ "$device_path" =~ /([[:xdigit:]]{4}:[[:xdigit:]]{2}:[[:xdigit:]]{2}\.[[:xdigit:]])/usb[0-9]+/ ]]; then
                target_device="$device"
                controller="${BASH_REMATCH[1]}"
                break 2
            fi
        done
    done
fi

if [[ -z "$controller" ]] && command -v journalctl >/dev/null 2>&1; then
    # A crashed controller may no longer expose the mouse in sysfs. Use kernel's
    # xHCI failure message to recover its PCI address in that case.
    while IFS= read -r line; do
        if [[ "$line" =~ xhci_hcd[[:space:]]+([[:xdigit:]]{4}:[[:xdigit:]]{2}:[[:xdigit:]]{2}\.[[:xdigit:]]):.*(host\ controller\ not\ responding|HC\ died) ]]; then
            controller="${BASH_REMATCH[1]}"
        fi
    done < <(journalctl -k -b -o cat --no-pager 2>/dev/null || true)

    if [[ -n "$controller" ]]; then
        printf 'Found dead xHCI controller %s in kernel log.\n' "$controller"
    fi
fi

if [[ -z "$controller" ]]; then
    printf 'Target USB device and dead xHCI controller not found. Pass PCI controller address as argument.\n' >&2
    exit 1
fi

if [[ ! -e "$driver/$controller" ]]; then
    printf 'xHCI controller not found: %s\n' "$controller" >&2
    exit 1
fi

if [[ -n "$target_device" ]]; then
    printf 'Found target USB device at %s.\n' "$target_device"
else
    printf 'Using explicitly supplied controller.\n'
fi
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
