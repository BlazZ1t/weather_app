import 'package:weather_app/class_templates/city.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ReverseCityFinderHandler {

  final key = dotenv.get('APIKEY');

  Future<City> getCityByCoordinates(double lat, double lon) async{
    final response = await http.get(Uri.parse('http://api.openweathermap.org/geo/1.0/reverse?lat=$lat&lon=$lon&limit=1&appid=$key'));

    String responseStr = utf8.decode(response.bodyBytes);

    City city = City.fromJson(jsonDecode(responseStr));

    return city;
  }
}