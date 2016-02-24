function weather.fetch -d "Fetches data from a URL backed by a cache"
  set md5 (__md5 "$argv")
  set cache_age (config weather -g cache-age)

  if test (count $argv) -gt 1
    for param in $argv[2..-1]
      set flags $flags --data-urlencode $param
    end
  end

  if not find /tmp/$md5.url -mmin +$cache_age > /dev/null ^ /dev/null
    curl -Gs $flags $argv[1] > /tmp/$md5.url
      or return 1
  end

  cat /tmp/$md5.url
end

function __md5
  # Use GNU coreutils if available.
  if type -q md5sum
    echo $argv[1] | md5sum | cut -d ' ' -f 1
    return 0
  end

  # Use BSD md5 utility if available.
  if type -q md5
    md5 -q -s "$argv[1]"
    return 0
  end

  # Try using openssl.
  if type -q openssl
    echo $argv[1] | openssl md5 -r | cut -d ' ' -f 1
    return 0
  end

  return 1
end
