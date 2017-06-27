function weather.location -d "Get the current geographic location"
  # Attempt to get our external IP address.
  if not set ip (__weather_get_ip)
    echo "No Internet connection or IP service unavailable."
    return 1
  end

  # Fetch location data based on our IP
  if not set geoip_data (weather.fetch "http://geoip.nekudo.com/api/$ip")
    echo "Unable to query GeoIP data; please try again later."
    return 1
  end

  # Echo coordiantes.
  echo $geoip_data | jq '.location.latitude'
  echo $geoip_data | jq '.location.longitude'
  echo $geoip_data | jq -r '.city?'
  echo $geoip_data | jq -r '.country.name'
end

function __weather_get_ip -d "Get the current device's public IP address"
  # Attempt to get our external IP using the OpenDNS resolver.
  if set -q __weather_system_dns
    if not set ip (dig +short myip.opendns.com)
      return 1
    end
  else
    if not set ip (dig +short myip.opendns.com @resolver1.opendns.com)
      return 1
    end
  end

  # Attempt to get our external IP using a web service.
  if test -z $ip
    if not set ip (weather.fetch "http://ipecho.net/plain")
      return 1
    end
  end

  echo $ip
end
