<div align="center">
  <a href="http://github.com/oh-my-fish/oh-my-fish">
  <img width=90px  src="https://cloud.githubusercontent.com/assets/8317250/8510172/f006f0a4-230f-11e5-98b6-5c2e3c87088f.png">
  </a>
</div>
<br>

# weather

Plugin for [Oh My Fish][omf-link].

Uses your IP address to determine your location and find relevant weather data anywhere in the world.

## Install

```fish
$ omf install weather
```


## Usage

```fish
$ weather
Temperature: 14.37 °C (57.86 °F)
Relative humidity: 58%
Cloudiness: sky is clear
Pressure: 1029 hpa
Wind: from NE (60°) at 7.2 m/s gusting to 10.8 m/s
```


## Configuring
You can customize the display of weather data using global variables. By default, both Celsius and Fahrenheit is displayed for the temperature. You can override this by specifying a particular unit to use in `$fahrenheit_units`. Valid options are:

- `celsius`
- `fahrenheit`
- `kelvin`

You can see the results by changing the value and running `weather` again:

```fish
$ set -g fahrenheit_units celsius
$ weather
Temperature: 14.37 °C
Relative humidity: 58%
Cloudiness: sky is clear
Pressure: 1029 hpa
Wind: from NE (60°) at 7.2 m/s gusting to 10.8 m/s
```

You can set this permanently by adding the set command in your `init.fish` file.

You can also configure the weather command to use the system default DNS resolver to fetch your IP address if one is configured.

```fish
$ set -g __weather_system_dns 1
```


# License

[MIT][mit] © [coderstephen][author] et [al][contributors]


[mit]:            http://opensource.org/licenses/MIT
[author]:         http://github.com/coderstephen
[contributors]:   https://github.com/oh-my-fish/plugin-weather/graphs/contributors
[omf-link]:       https://www.github.com/oh-my-fish/oh-my-fish
[license-badge]:  https://img.shields.io/badge/license-MIT-007EC7.svg?style=flat-square
