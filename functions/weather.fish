function weather -d "Displays weather info"
  set -l api_key (config weather --get api-key)

  # Check external dependent programs.
  if not type -q jq
    echo "The jq program is required to parse weather data."
    echo "See https://stedolan.github.io/jq for details."
    return 1
  else
    set -l jq_version (jq --version 2>&1 | tr -dC '[:digit:].')
    if test "$jq_version" -lt 1.5
      echo "jq version $jq_version detected"
      echo "You must have jq version 1.5 or newer installed to parse weather data."
      echo "You can download the latest version of jq from https://stedolan.github.io/jq."
      return 1
    end
  end

  # Display help message.
  if begin; contains -- -h $argv; or contains -- --help $argv; end
    weather.help
    return 0
  end

  # Determine the location to use.
  if test (count $argv) -eq 0
    set location (weather.location)

    # Fetch weather data based on the location.
    if not set json (weather.fetch "http://api.openweathermap.org/data/2.5/weather" lat=$location[1] lon=$location[2] APPID=$api_key)
      echo "Unable to fetch weather data; please try again later."
      return 1
    end
  else
    # Fetch weather based on a search query.
    if not set json (weather.fetch "http://api.openweathermap.org/data/2.5/weather" "q=$argv" APPID=$api_key)
      echo "Unable to fetch weather data; please try again later."
      return 1
    end

    set location (echo $json | jq -r '.coord.lat, .coord.lon, .name, .sys.country')
  end

  printf "Weather for $location[3], $location[4]\n\n"

  set temp (echo $json | jq '.main.temp')
  set wind_speed (echo $json | jq '.wind.speed')
  set wind_gust (echo $json | jq '.wind.gust')
  set wind_deg (echo $json | jq '.wind.deg')

  # convert m/s to km/h
  set wind_speed_kmh ( math -s 1 $wind_speed \* 3.6 )
  if test -n "$wind_gust" -a "$wind_gust" != "null"
    set wind_gust_kmh ( math -s 1 $wind_gust \* 3.6 )
  end

  # If we want miles per hour
  #set wind_speed_mph ( math -s 1 $wind_speed \* 2.23694 )

  # Get the cardinal direction from the heading
  set directions N NE E SE S SW W NW N
  set wind_dir $directions[(math -s 0 "(($wind_deg % 360) / 45) + 1")]

  # Display forecast summary
  echo "Temperature: "(__weather_print_temperature $temp)
  echo "   Humidity: "(echo $json | jq '.main.humidity')"%"
  echo " Cloudiness: "(echo $json | jq -r '.weather[0].description')
  echo "   Pressure: "(echo $json | jq '.main.pressure')" hpa"
  echo -n "       Wind: from $wind_dir ($wind_deg°) at $wind_speed m/s ($wind_speed_kmh km/h)"
  if not test $wind_gust = null
    echo " gusting to $wind_gust m/s ($wind_gust_kmh km/h)"
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
function __weather_print_temperature
  set kelvin $argv[1]

  set -l temperature_units (config weather --get temperature-units)

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
