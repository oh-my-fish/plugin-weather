function init --on-event init_weather
  # Set the default temperature units to use. Options are:
  #   default
  #   celsius
  #   fahrenheit
  #   kelvin
  #
  # "default" will cause both Celsius and Fahrenheit units to be displayed, and
  # is the default setting.
  config weather -q temperature-units
    or config weather -s temperature-units default

  # Set the default API key to use for OpenWeatherMap. This default key has been
  # approved by OpenWeatherMap to be used for free, open-source software only.
  config weather -q api-key
    or config weather -s api-key 34da4a18e8fdacda2ce10061f1cd6340

  # Set the default cache expiry time. Expiry time is in minutes, and is used to
  # invalidate the cache automatically.
  config weather -q cache-age
    or config weather -s cache-age 30
end
