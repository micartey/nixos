{ inputs, ... }:

{
  environment.systemPackages = [
    inputs.librepods.packages.x86_64-linux.default
  ];
}