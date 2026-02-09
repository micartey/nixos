{ meta, ... }:

{
  time.timeZone = meta.timeZone;

  i18n = {
    defaultLocale = meta.locale;
    extraLocaleSettings = {
      LC_ADDRESS = meta.locale;
      LC_IDENTIFICATION = meta.locale;
      LC_MEASUREMENT = meta.locale;
      LC_MONETARY = meta.locale;
      LC_NAME = meta.locale;
      LC_NUMERIC = meta.locale;
      LC_PAPER = meta.locale;
      LC_TELEPHONE = meta.locale;
      LC_TIME = meta.locale;
    };
  };

  console = {
    useXkbConfig = true;
  };
}
