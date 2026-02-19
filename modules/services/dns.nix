{ ... }:

{
  # services.coredns = {
  #   enable = true;
  #   config = ''
  #     . {
  #         hosts {
  #           192.168.1.100 myserver.local
  #           fallthrough
  #         }
  #         forward . 1.1.1.1
  #     }
  #   '';
  # };

  networking.nameservers = [
    # "127.0.0.1"
    "1.1.1.1"
    "1.0.0.1"
    "8.8.8.8"
    "8.8.4.4"
  ];
}
