function init --on-event init_weather
  # Set the default temperature units to use. Options are:
  #   default
  #   celsius
  #   fahrenheit
  #   kelvin
  #
  # "default" will cause both Celsius and Fahrenheit units to be displayed, and
  # is the default setting.
  set -q temperature_units
    or set -g temperature_units default

  # Set the default API key to use for OpenWeatherMap. This default key has been
  # approved by OpenWeatherMap to be used for free, open-source software only.
  set -q weather_api_key
    or set -g weather_api_key 34da4a18e8fdacda2ce10061f1cd6340

  # Set the default cache expiry time. Expiry time is in minutes, and is used to
  # invalidate the cache automatically.
  set -q weather_cache_age
    or set -g weather_cache_age 30
end
