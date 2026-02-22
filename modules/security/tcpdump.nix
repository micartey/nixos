{ pkgs, ... }:

{
  users.groups.pcap = { };

  security.wrappers.tcpdump = {
    source = "${pkgs.tcpdump}/bin/tcpdump";
    capabilities = "cap_net_raw,cap_net_admin+eip";
    owner = "root";
    group = "pcap";
    permissions = "u+rx,g+x,o-rwx";
  };
}
