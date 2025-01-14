import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CityRequest {

  final key = dotenv.get('APIKEY');

  Future<String> findCity(String cityName) async {
    final response = await http.get(Uri.parse('http://api.openweathermap.org/geo/1.0/direct?q=$cityName&limit=5&appid=$key'));

    String responseStr = utf8.decode(response.bodyBytes);

    print(responseStr);

    return responseStr;
  }
}