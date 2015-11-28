function weather -d "Displays current local weather info"
  if not available jq
    echo "The jq program is required to parse weather data."
    echo "See https://stedolan.github.io/jq/ for details."
    return 1
  end

  set -l location (weather.location)
  printf "Weather for $location[3], $location[4]\n\n"

  # Fetch weather data based on the location
  if not set weather_data (weather.fetch "http://api.openweathermap.org/data/2.5/weather?lat=$location[1]&lon=$location[2]&APPID=$__weather_api_key")
    echo "Unable to fetch weather data; please try again later."
    return 1
  end

  set temp (echo $weather_data | jq '.main.temp')
  set wind_speed (echo $weather_data | jq '.wind.speed')
  set wind_gust (echo $weather_data | jq '.wind.gust')
  set wind_deg (echo $weather_data | jq '.wind.deg')

  # Get the cardinal direction from the heading
  set directions N NE E SE S SW W NW N
  set wind_dir $directions[(math "(($wind_deg % 360) / 45) + 1")]

  # Display forecast summary
  echo "Temperature: "(__weather_print_temperature $temp)
  echo "   Humidity: "(echo $weather_data | jq '.main.humidity')"%"
  echo " Cloudiness: "(echo $weather_data | jq -r '.weather[0].description')
  echo "   Pressure: "(echo $weather_data | jq '.main.pressure')" hpa"
  echo -n "       Wind: from $wind_dir ($wind_deg°) at $wind_speed m/s"
  if test $wind_gust -eq null
    echo "gusting to $wind_gust m/s"
  else
    echo
  end

  printf "\n5-day forecast\n"
  weather.forecast $location
end


# Prints the given temperature to the console.
#
# Arguments:
#   1: The temperature to display in Kelvin.
#
# The units displayed depend on the global `temperature_units` variable.
function __weather_print_temperature
  set kelvin $argv[1]

  if not set -q temperature_units
    set temperature_units default
  end

  if test "$temperature_units" = "kelvin"
    echo "$kelvin K"
    return 0
  end

  set celsius (math "$kelvin - 273.15")

  if test $temperature_units = "celsius"
    echo "$celsius °C"
    return 0
  end

  set fahrenheit (math "$celsius * 1.8 + 32")

  if test $temperature_units = "fahrenheit"
    echo "$fahrenheit °F"
  else
    echo "$celsius °C ($fahrenheit °F)"
  end
end
