function weather.forecast -d "Displays weather forecast lines"
  set -l api_key (config weather --get api-key)

  if not set json (weather.fetch "http://api.openweathermap.org/data/2.5/forecast?lat=$argv[1]&lon=$argv[2]&appid=$api_key")
    echo "Unable to fetch weather data; please try again later."
    return 1
  end

  set items (echo $json | jq -c '.list[]')
  for item in $items
    set day (echo $item | jq -r '.dt | strftime("%d/%m")')
    contains $day $days
      or set days $days $day

    set temp $temp (echo $item | jq -r '.main.temp')
    set rain $rain (echo $item | jq -r '.rain["3h"] // .snow["3h"] // 0')
  end

  printf "  Temperature: %s\n" (spark $temp)
  printf "               %s\n\n" (__print_days_strip $days)

  printf "Precipitation: %s\n" (spark $rain)
  printf "               %s\n" (__print_days_strip $days)
end

function __print_days_strip
  for day in $argv
    printf "%s  " $day
  end
end
