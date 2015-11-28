function weather.help
  set query (set_color -u; echo -n query; set_color normal)

  echo "Displays weather conditions and forecasts.

Usage: weather [-h|--help] [query]

  Displays the current conditions and a 5-day forecast. If $query is given,
  weather conditions will be for the the best city that matches the query. If
  $query is not given, the current location will be used based on IP address.

Options:
  -h, --help      Display this help message and exit."
end
