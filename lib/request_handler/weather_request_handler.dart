import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherRequest {
  final key = dotenv.get('APIKEY');

  Future<String> getWeatherTimestamp(double lat, double lon) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/3.0/onecall/timemachine?lat=$lat&lon=$lon&units=metric&dt=${DateTime.now().toUtc()}&appid=$key'));

    String responseStr = utf8.decode(response.bodyBytes);

    return responseStr;
  }

}