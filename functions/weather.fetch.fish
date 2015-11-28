function weather.fetch -d "Fetches data from a URL backed by a cache"
  set md5 (echo $argv[1] | md5sum | cut -d " " -f 1)

  if not find /tmp/$md5.url -mmin +30 2> /dev/null
    curl -s $argv[1] > /tmp/$md5.url
      or return 1
  end

  cat /tmp/$md5.url
end
