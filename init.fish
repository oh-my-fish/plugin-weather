function init --on-event init_weather
    # Set the default API key to use for OpenWeatherMap. This default key has been
    # approved by OpenWeatherMap to be used for free, open-source software only.
    set -g __weather_api_key 34da4a18e8fdacda2ce10061f1cd6340

    # Set the default temperature units to use. Options are:
    #   default
    #   celsius
    #   fahrenheit
    #   kelvin
    #
    # "default" will cause both Celsius and Fahrenheit units to be displayed, and
    # is the default setting.
    set -g temperature_units default
end
