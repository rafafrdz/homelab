# Locale and internationalization configuration
# Sets timezone, language, and keyboard layout
{ ... }:

{
  ##############################################################################
  # Timezone
  ##############################################################################
  time.timeZone = "Europe/Madrid";

  ##############################################################################
  # Locale Settings
  ##############################################################################
  i18n.defaultLocale = "en_US.UTF-8";

  # Regional locale overrides
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };

  ##############################################################################
  # Console Configuration
  ##############################################################################
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  ##############################################################################
  # X11 Keyboard Configuration
  ##############################################################################
  services.xserver.xkb = {
    layout = "us";
    variant = "altgr-intl";
  };
}
