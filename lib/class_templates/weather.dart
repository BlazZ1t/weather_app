class WeatherTimestamp {
  double lat;
  double lon;
  String timezone;
  int timezoneOffset;
  WeatherData data;

  WeatherTimestamp({
    required this.lat,
    required this.lon,
    required this.timezone,
    required this.timezoneOffset,
    required this.data,
  });

  factory WeatherTimestamp.fromJson(Map<String, dynamic> json) {
    return WeatherTimestamp(
      lat: json['lat'],
      lon: json['lon'],
      timezone: json['timezone'],
      timezoneOffset: json['timezone_offset'],
      data: (json['data'])
          .map((item) => WeatherData.fromJson(item)),
    );
  }
}

class WeatherData {
  int dt;
  int? sunrise;
  int? sunset;
  double temp;
  double feelsLike;
  int pressure;
  int humidity;
  double dewPoint;
  double uvi;
  int clouds;
  int? visibility;
  double windSpeed;
  int windDeg;
  WeatherCondition  weather;

  WeatherData({
    required this.dt,
    this.sunrise,
    this.sunset,
    required this.temp,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
    required this.dewPoint,
    required this.uvi,
    required this.clouds,
    this.visibility,
    required this.windSpeed,
    required this.windDeg,
    required this.weather,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      dt: json['dt'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
      temp: json['temp'],
      feelsLike: json['feels_like'],
      pressure: json['pressure'],
      humidity: json['humidity'],
      dewPoint: json['dew_point'],
      uvi: json['uvi'],
      clouds: json['clouds'],
      visibility: json['visibility'],
      windSpeed: json['wind_speed'],
      windDeg: json['wind_deg'],
      weather: (json['weather'])
          .map((item) => WeatherCondition.fromJson(item)),
    );
  }
}

class WeatherCondition {
  int id;
  String main;
  String icon;

  WeatherCondition({
    required this.id,
    required this.main,
    required this.icon,
  });

  factory WeatherCondition.fromJson(Map<String, dynamic> json) {
    return WeatherCondition(
      id: json['id'],
      main: json['main'],
      icon: json['icon'],
    );
  }
}