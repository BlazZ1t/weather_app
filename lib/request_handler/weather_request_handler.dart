import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherRequest {
  final key = dotenv.get('APIKEY');

  Future<String> getWeatherTimestamp(double lat, double lon) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&lang=ru&appid=$key'));

    String responseStr = utf8.decode(response.bodyBytes);

    return responseStr;
  }
  
  Future<String> getForecast(double lat, double lon) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&units=metric&lang=ru&cnt=5&appid=$key'));

    String responseStr = utf8.decode(response.bodyBytes);

    return responseStr;
  }

}