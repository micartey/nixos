{
  ...
}:

{
  profiles = [ "default" ];

  # Always report TracerPid as 0 in /proc/<pid>/status
  # Applies patches/hide-tracer-pid.patch to the kernel build
  # boot.kernelPatches = [
  #   {
  #     name = "hide-tracer-pid";
  #     patch = ../../patches/hide-tracer-pid.patch;
  #   }
  # ];
}
