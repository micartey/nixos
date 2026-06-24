# libvirt win11 UEFI and network fix

Date: 2026-06-24

## Symptoms

- Starting the `win11` VM failed with:

  ```text
  operation failed: Unable to find 'efi' firmware that is compatible with the current configuration
  ```

- After the firmware issue was fixed, the VM started but had no internet connection.
- `virsh -c qemu:///system net-dhcp-leases default` initially showed no lease for the VM MAC.

## Firmware root cause

The `win11` domain XML had stale, generation-specific Nix store firmware paths from an older QEMU package:

```xml
/nix/store/...-qemu-host-cpu-only-9.2.4/share/qemu/edk2-x86_64-secure-code.fd
/nix/store/...-qemu-host-cpu-only-9.2.4/share/qemu/edk2-i386-vars.fd
```

It also had Secure Boot enabled even though the VM was expected to use normal UEFI:

```xml
<feature enabled='yes' name='secure-boot'/>
<loader secure='yes' ...>
```

On current NixOS/nixpkgs, `virtualisation.libvirtd.qemu.ovmf.*` is removed. QEMU firmware is exposed through libvirt using stable runtime paths under:

```text
/run/libvirt/nix-ovmf/
```

## Firmware fix applied

The VM was updated with `virt-xml` so the inactive XML now uses normal UEFI and stable firmware paths:

```xml
<os firmware='efi'>
  <type arch='x86_64' machine='pc-q35-9.2'>hvm</type>
  <firmware>
    <feature enabled='no' name='enrolled-keys'/>
    <feature enabled='no' name='secure-boot'/>
  </firmware>
  <loader readonly='yes' secure='no' type='pflash' format='raw'>/run/libvirt/nix-ovmf/edk2-x86_64-code.fd</loader>
  <nvram template='/run/libvirt/nix-ovmf/edk2-i386-vars.fd' templateFormat='raw' format='raw'>/var/lib/libvirt/qemu/nvram/win11_VARS.fd</nvram>
  <boot dev='hd'/>
</os>
```

Relevant command shape:

```bash
virt-xml -c qemu:///system win11 --edit \
  --boot firmware=efi,firmware.feature0.name=enrolled-keys,firmware.feature0.enabled=no,firmware.feature1.name=secure-boot,firmware.feature1.enabled=no,loader=/run/libvirt/nix-ovmf/edk2-x86_64-code.fd,loader.readonly=yes,loader.secure=no,loader.type=pflash,nvram=/var/lib/libvirt/qemu/nvram/win11_VARS.fd,nvram.template=/run/libvirt/nix-ovmf/edk2-i386-vars.fd,nvram.templateFormat=raw
```

After this, `virsh -c qemu:///system start win11` succeeded.

## Network root cause

The libvirt `default` NAT network was active:

```text
default   active   yes   yes
```

The VM was attached to `default`, and `virbr0` existed with `192.168.122.1/24`, but the guest got no DHCP lease.

The evaluated NixOS firewall config trusted only `lo`:

```json
["lo"]
```

That meant guest traffic on the libvirt bridge was not explicitly trusted by the NixOS firewall.

## Network fix applied

Added this to `modules/vm/vm.nix`:

```nix
networking.firewall.trustedInterfaces = [ "virbr0" ];
```

After `just home-switch`, the evaluated trusted interfaces became:

```json
["virbr0","lo"]
```

The `win11` NIC model was also changed from `e1000e` to `e1000` as a safer Windows fallback:

```xml
<model type='e1000'/>
```

The saved VM config only applied after a full power off/start, not a soft reboot.

Final verified state:

```text
Interface   Type      Source    Model   MAC
------------------------------------------------------------
vnet4       network   default   e1000   52:54:00:4b:e4:d1
```

DHCP lease after the firewall switch and full VM power cycle:

```text
192.168.122.142/24   DESKTOP-328OTMT   52:54:00:4b:e4:d1
```

## Useful checks

```bash
virsh -c qemu:///system dumpxml win11 --inactive | sed -n '/<os/,/<\/os>/p'
virsh -c qemu:///system domiflist win11
virsh -c qemu:///system net-list --all
virsh -c qemu:///system net-dhcp-leases default
virsh -c qemu:///system domcapabilities --virttype kvm --arch x86_64 --machine q35 | sed -n '/<loader/,/<\/loader>/p'
```

If saved XML changes do not appear in the active VM, fully power off and start:

```bash
virsh -c qemu:///system shutdown win11
virsh -c qemu:///system start win11
```
