class DailyForecast {
  final DateTime time;
  final WeatherCode weathercode;
  final double temperature_2m_max;
  final double temperature_2m_min;
  final double windspeed_10m_max;

  DailyForecast(
      {required this.time,
      required this.weathercode,
      required this.temperature_2m_max,
      required this.temperature_2m_min, required this.windspeed_10m_max});

  String getWeekday() {
    switch (time.weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return '';
    }
  }

  static List<DailyForecast> fromJson(Map<String, dynamic> daily) {
    final times = daily['time'] as List<dynamic>;
    final weathercodes = daily['weathercode'] as List<dynamic>;
    final temperature_2m_max = daily['temperature_2m_max'] as List<dynamic>;
    final temperature_2m_min = daily['temperature_2m_min'] as List<dynamic>;
    final windspeed_10m_max = daily['windspeed_10m_max'] as List<dynamic>;
    return List.generate(
        times.length,
        (index) => DailyForecast(
            time: DateTime.parse(times[index]),
            weathercode: WeatherCode.fromNumeric(weathercodes[index]),
            temperature_2m_max: temperature_2m_max[index],
            temperature_2m_min: temperature_2m_min[index],
            windspeed_10m_max: windspeed_10m_max[index]
        ));
  }
}

class HourlyForecast {
  final DateTime time;
  final double temperature_2m;
  final double apparent_temperature;
  final double precipitation;
  final int precipitation_probability;
  final double wind;

  HourlyForecast(
      {required this.time,
      required this.temperature_2m,
      required this.apparent_temperature,
      required this.precipitation,
      required this.precipitation_probability,
      required this.wind});

  static List<HourlyForecast> fromJson(Map<String, dynamic> hourly) {
    final times = hourly['time'] as List<dynamic>;
    final temperature_2m = hourly['temperature_2m'] as List<dynamic>;
    final apparent_temperature =
        hourly['apparent_temperature'] as List<dynamic>;
    final precipitation_probability =
        hourly['precipitation_probability'] as List<dynamic>;
    final precipitation = hourly['precipitation'] as List<dynamic>;
    final wind = hourly['windspeed_10m'] as List<dynamic>;

    return List.generate(
        times.length,
        (index) => HourlyForecast(
            time: DateTime.parse(times[index]),
            temperature_2m: temperature_2m[index],
            apparent_temperature: apparent_temperature[index],
            precipitation: precipitation[index],
            precipitation_probability: precipitation_probability[index],
            wind: wind[index]));
  }
}

enum WeatherCode {
  ClearSky(0, 'Clear sky', 'other.jpg'),
  MainlyClear(1, 'Mainly clear', 'Image.asset(("assets/back.jpg'),
  PartlyCloudy(2, 'Partly cloudy', 'cloud.jpg'),
  Overcast(3, 'Overcast', 'overcast.jpg'),
  Fog(45, 'Fog', 'Image.asset(("assets/back.jpg'),
  DepositingRimeFog(48, 'Depositing rime fog', 'clearSky.jpg'),
  DrizzleLight(51, 'Drizzle: Light intensity', 'rain.jpg'),
  DrizzleModerate(53, 'Drizzle: Moderate intensity', 'rain.jpg'),
  DrizzleDense(55, 'Drizzle: Dense intensity', 'rain.jpg'),
  FreezingDrizzleLight(56, 'Freezing Drizzle: Light intensity', 'rain.jpg'),
  FreezingDrizzleDense(57, 'Freezing Drizzle: dense intensity', 'rain.jpg'),
  RainSlight(61, 'Rain: Slight intensity', 'rain.jpg'),
  RainModerate(63, 'Rain: Moderate intensity', 'rain.jpg'),
  RainHeavy(65, 'Rain: Heavy intensity', 'clearSky.jpg'),
  FreezingRainLight(66, 'Freezing Rain: Light intensity', 'rain.jpg'),
  FreezingRainHeavy(66, 'Freezing Rain: Heavy intensity', 'rain.jpg'),
  SnowFallSlight(71, 'Snow fall: Slight intensity', 'snowing.jpg'),
  SnowFallModerate(73, 'Snow fall: Moderate intensity', 'other.jpg'),
  SnowFallHeavy(75, 'Snow fall: Heavy intensity', 'clearSky.jpg'),
  SnowGrains(77, 'Snow grains', 'snow.jpg'),
  RainShowersSlight(80, 'Rain showers: Slight', 'rain.jpg'),
  RainShowersModerate(81, 'Rain showers: Moderate', 'rain.jpg'),
  RainShowersVoilent(82, 'Rain showers: Violent', 'rain.jpg'),
  SnowShowersSlight(85, 'Snow showers: Slight', 'snowing.jpg'),
  SnowShowersHeavy(86, 'Snow showers: Heavy', 'snow2.jpg'),
  Thunerstorm(95, 'Thunderstorm: Slight or moderate', 'clearSky.jpg'),
  ThunderstormSlightHail(96, 'Thunderstorm with slight hail', 'clearSky.jpg'),
  ThunderstormHeavyHail(99, 'Thunderstorm with heavy hail', 'clearSky.jpg'),
  ;

  final String image;
  final int numeric;
  final String description;

  const WeatherCode(this.numeric, this.description, this.image);

  static final _map =
      Map.fromEntries(WeatherCode.values.map((e) => MapEntry(e.numeric, e)));

  factory WeatherCode.fromNumeric(int numeric) {
    return WeatherCode._map[numeric]!;
  }
}
