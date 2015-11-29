function weather.fetch -d "Fetches data from a URL backed by a cache"
  set md5 (__md5 "$argv")

  if test (count $argv) -gt 1
    for param in $argv[2..-1]
      set flags $flags --data-urlencode $param
    end
  end

  if not find /tmp/$md5.url -mmin +$weather_cache_age > /dev/null ^ /dev/null
    curl -Gs $flags $argv[1] > /tmp/$md5.url
      or return 1
  end

  cat /tmp/$md5.url
end

function __md5
  # Use GNU coreutils if available.
  if available md5sum
    echo $argv[1] | md5sum | cut -d ' ' -f 1
    return 0
  end

  # Use builtin md5 tool in OS X.
  if available md5
    echo $argv[1] | md5 | cut -d '=' -f 2 | tr -d '[:space:]'
    return 0
  end

  # Try using openssl.
  if available openssl
    echo $argv[1] | openssl md5 | cut -d '=' -f 2 | tr -d '[:space:]'
    return 0
  end

  return 1
end
