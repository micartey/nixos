{ inputs, ... }:

{
  environment.systemPackages = [
    inputs.librepods.packages.x86_64-linux.default
  ];

  security.wrappers.librepods = {
    source = "${inputs.librepods.packages.x86_64-linux.default}/bin/librepods";
    capabilities = "cap_net_admin+eip";
    owner = "root";
    group = "root";
  };
}