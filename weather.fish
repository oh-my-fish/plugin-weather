function weather -d "Displays local weather info"
    if not available jq
        echo "The jq program is required to parse weather data."
        echo "See https://stedolan.github.io/jq/ for details."
        return 1
    end

    # Get our external IP using DNS
    set ip (dig +short myip.opendns.com @resolver1.opendns.com)

    # Fetch location data based on our IP
    set geoip_data (curl -s "http://geoip.nekudo.com/api/$ip")
    set latitude (echo $geoip_data | jq '.location.latitude')
    set longitude (echo $geoip_data | jq '.location.longitude')

    # Fetch weather data based on the location
    set weather_data (curl -s "http://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude")
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
    echo Relative humidity: (echo $weather_data | jq '.main.humidity')%
    echo Cloudiness: (echo $weather_data | jq -r '.weather[0].description')
    echo Pressure: (echo $weather_data | jq '.main.pressure') hpa
    echo "Wind: from $wind_dir ($wind_deg°) at $wind_speed m/s gusting to $wind_gust m/s"
end
