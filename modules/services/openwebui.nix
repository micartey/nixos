{ ... }:

# Database is stored in:
# /var/lib/private/open-webui/webui.db
{
  profiles = [ "default" ];
  services.open-webui = {
    enable = false;
  };
}
