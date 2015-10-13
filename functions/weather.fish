function weather -d "Displays local weather info"
  if not available jq
    echo "The jq program is required to parse weather data."
    echo "See https://stedolan.github.io/jq/ for details."
    return 1
  end

  # Attempt to get our external IP using the default DNS resolver
  if not set ip (dig +short myip.opendns.com @resolver1.opendns.com)
    echo "No Internet connection unavailable."
    return 1
  end

  # Attempt to get our external IP using a web service
  if test -z $ip
    if not set ip (curl -s ipecho.net/plain)
      echo "No Internet connection or IP service unavailable."
      return 1
    end
  end

  # Fetch location data based on our IP
  if not set geoip_data (curl -s "http://geoip.nekudo.com/api/$ip")
    echo "Unable to query GeoIP data; please try again later."
    return 1
  end
  set latitude (echo $geoip_data | jq '.location.latitude')
  set longitude (echo $geoip_data | jq '.location.longitude')

  # Fetch weather data based on the location
  if not set weather_data (curl -s "http://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude")
    echo "Unable to fetch weather data; please try again later."
    return 1
  end
  set temp_K (echo $weather_data | jq '.main.temp')
  set temp_C (math "$temp_K - 273.15")
  set temp_F (math "$temp_C * 1.8 + 32")
  set wind_speed (echo $weather_data | jq '.wind.speed')
  set wind_gust (echo $weather_data | jq '.wind.gust')
  set wind_deg (echo $weather_data | jq '.wind.deg')

  # Get the cardinal direction from the heading
  set directions N NE E SE S SW W NW N
  set wind_dir $directions[(math "(($wind_deg % 360) / 45) + 1")]

  # Display forecast summary
  echo "Temperature: $temp_C °C ($temp_F °F)"
  echo "Relative humidity: "(echo $weather_data | jq '.main.humidity')"%"
  echo "Cloudiness: "(echo $weather_data | jq -r '.weather[0].description')
  echo "Pressure: "(echo $weather_data | jq '.main.pressure')" hpa"
  echo -n "Wind: from $wind_dir ($wind_deg°) at $wind_speed m/s"
  if test $wind_gust -eq null
    echo "gusting to $wind_gust m/s"
  else
    echo
  end
end
