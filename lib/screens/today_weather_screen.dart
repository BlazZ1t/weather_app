import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';

import 'package:weather_app/class_templates/city.dart';
import 'package:weather_app/class_templates/weather.dart';
import 'package:weather_app/request_handler/reverse_city_finder_handler.dart';

import 'package:weather_app/request_handler/weather_request_handler.dart';

class WeatherWidget extends StatefulWidget {
  final double? lat;
  final double? lon;
  final String? cityName;

  WeatherWidget({super.key, this.lat, this.lon, this.cityName});

  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  late Future<WeatherTimestamp> weatherTimestamp;
  late Future<String> cityName;

  @override
  void initState() async {
    super.initState();
    if (widget.lat != null && widget.lon != null && widget.cityName != null) {
      weatherTimestamp = WeatherTimestamp.fromJson(jsonDecode(WeatherRequest().getWeatherTimestamp(widget.lat!, widget.lon!) as String)) as Future<WeatherTimestamp> ;
      cityName = Future.value(widget.cityName);
    } else {
      List<double> coordinates = await getCurrentLocation();
      weatherTimestamp = getWeatherOnLocation(coordinates[0], coordinates[1]);
      cityName = getCurrentCityName();
    }
  }

  Future<List<double>> getCurrentLocation() async {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.medium,
      timeLimit: Duration(seconds: 2),
      distanceFilter: 1000,
    );
    Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);
    return [position.latitude, position.longitude];
  }

  Future<WeatherTimestamp> getWeatherOnLocation(double lat, double lon) async {
    return WeatherTimestamp.fromJson(jsonDecode(await WeatherRequest().getWeatherTimestamp(lat, lon)));
  }

  Future<String> getCurrentCityName() async {
    List<double> coordinates = await getCurrentLocation();
    City city = await ReverseCityFinderHandler().getCityByCoordinates(coordinates[0], coordinates[1]);
    return city.name;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([weatherTimestamp, cityName]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          WeatherTimestamp weather = snapshot.data![0];
          String city = snapshot.data![1];
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  city,
                  style: TextStyle(fontSize: 32.0),
                ),
                SizedBox(height: 16.0),
                Text(
                  weather.data.temp.toString(),
                  style: TextStyle(fontSize: 34.0),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}


class TodayWeatherScreen extends StatelessWidget {
  const TodayWeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: WeatherWidget(),
    );
  }
}