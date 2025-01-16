import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';

import 'package:weather_app/class_templates/city.dart';
import 'package:weather_app/class_templates/weather.dart';
import 'package:weather_app/request_handler/reverse_city_finder_handler.dart';

import 'package:weather_app/request_handler/weather_request_handler.dart';

class TodayWeatherScreen extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final String? cityName;

  const TodayWeatherScreen({Key? key, this.latitude, this.longitude, this.cityName}) : super(key: key);

  @override
  _TodayWeatherScreenState createState() => _TodayWeatherScreenState();
}

class _TodayWeatherScreenState extends State<TodayWeatherScreen> {
  String? cityName;
  int? temperature;
  int? feelsLike;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    double lat = widget.latitude ?? 0.0;
    double lon = widget.longitude ?? 0.0;

    if (lat == 0.0 && lon == 0.0) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      lat = position.latitude;
      lon = position.longitude;
    }

    if (widget.cityName == null) {
      ReverseCityFinderHandler cityFinder = ReverseCityFinderHandler();
      City city = await cityFinder.getCityByCoordinates(lat, lon);
      cityName = city.localNames?['ru'] ?? city.name;
    } else {
      cityName = widget.cityName;
    }

    WeatherRequest weatherRequest = WeatherRequest();
    String weatherData = await weatherRequest.getWeatherTimestamp(lat, lon);
    CurrentWeather currentWeather = CurrentWeather.fromJson(jsonDecode(weatherData));
    temperature = currentWeather.main.temp;
    feelsLike = currentWeather.main.feelsLike;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading
          ? CircularProgressIndicator()
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(cityName ?? 'Unknown City', style: TextStyle(fontSize: 24)),
          Text('${temperature?.toString() ?? '--'} °C', style: TextStyle(fontSize: 48)),
          Text('Ощущается как: ${feelsLike?.toString() ?? '--'} °C', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

