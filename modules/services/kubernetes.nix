{
  config,
  meta,
  pkgs,
  ...
}:

let
  user = meta.user.username;
in
{
  profiles = [ "home" ];

  services.k3s = {
    enable = true;
    role = "server";
    tokenFile = config.sops.secrets."k3s/token".path;
    extraFlags = [
      "--disable traefik"
      "--resolv-conf /run/systemd/resolve/resolv.conf"
      "--write-kubeconfig /home/${user}/.kube/config"
      "--write-kubeconfig-group k3s"
      "--write-kubeconfig-mode 0640"
    ];
  };

  users.groups.k3s = { };
  users.users.${user}.extraGroups = [ "k3s" ];

  systemd.tmpfiles.rules = [ "d /home/${user}/.kube 0700 ${user} users -" ];

  sops.secrets."k3s/token" = {
    owner = "root";
    mode = "0400";
  };

  networking.firewall.trustedInterfaces = [
    "cni0"
    "flannel.1"
  ];

  environment.systemPackages = with pkgs; [
    kubectl
    kubernetes-helm
  ];
}
