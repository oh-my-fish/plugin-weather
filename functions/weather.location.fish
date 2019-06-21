function weather.location -d "Get the current geographic location"
  # Attempt to get our external IP address.
  if not set ip (__weather_get_ip)
    echo "No Internet connection or IP service unavailable."
    return 1
  end

  # Fetch location data based on our IP
  if not set geoip_data (weather.fetch "https://ipapi.com/ip_api.php?ip=$ip")
    echo "Unable to query GeoIP data; please try again later."
    return 1
  end

  # Echo coordiantes.
  echo $geoip_data | jq '.latitude'
  echo $geoip_data | jq '.longitude'
  echo $geoip_data | jq -r '.city?'
  echo $geoip_data | jq -r '.country_name'
end

function __weather_get_ip -d "Get the current device's public IP address"
  # Attempt to get our external IP using the OpenDNS resolver.
  if type -q dig
    if set -q __weather_system_dns
      if set ip (dig +short myip.opendns.com 2>/dev/null)
        echo $ip
        return
      end
    else
      if set ip (dig +short myip.opendns.com @resolver1.opendns.com 2>/dev/null)
        echo $ip
        return
      end
    end
  end

  # Attempt to get our external IP using a web service.
  if set ip (weather.fetch "http://ipecho.net/plain")
    echo $ip
  end

end
