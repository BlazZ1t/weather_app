import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import 'package:weather_app/class_templates/city.dart';
import 'package:weather_app/class_templates/current_weather.dart';
import 'package:weather_app/request_handler/reverse_city_finder_handler.dart';

import 'package:weather_app/request_handler/weather_request_handler.dart';
import 'package:weather_app/screens/search_screen.dart';

class TodayWeatherScreen extends StatefulWidget {

  const TodayWeatherScreen({super.key});

  @override
  _TodayWeatherScreenState createState() => _TodayWeatherScreenState();
}

class _TodayWeatherScreenState extends State<TodayWeatherScreen> {
  String? cityName;
  int? temperature;
  int? feelsLike;
  late String weatherDescription;
  bool isLoading = true;
  late City? city;
  CityNotifier? cityNotifier;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cityNotifier = Provider.of<CityNotifier>(context);
    cityNotifier?.addListener(_fetchWeatherData);
  }

  @override
  void dispose() {
    cityNotifier?.removeListener(_fetchWeatherData);
    super.dispose();
  }


  Future<void> _fetchWeatherData() async {
    final cityNotifier = Provider.of<CityNotifier>(context, listen: false);
    double lat = cityNotifier.city?.lat ?? 0.0;
    double lon = cityNotifier.city?.lon ?? 0.0;

    if (lat == 0.0 && lon == 0.0) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      lat = position.latitude;
      lon = position.longitude;
    }

    if (cityNotifier.city == null) {
      ReverseCityFinderHandler cityFinder = ReverseCityFinderHandler();
      cityNotifier.updateCity(await cityFinder.getCityByCoordinates(lat, lon));
    }

    cityName = cityNotifier.city?.localNames?['ru'] ?? cityNotifier.city?.name;

    WeatherRequest weatherRequest = WeatherRequest();
    String weatherData = await weatherRequest.getWeatherTimestamp(lat, lon);
    CurrentWeather currentWeather = CurrentWeather.fromJson(jsonDecode(weatherData));
    temperature = currentWeather.main.temp;
    feelsLike = currentWeather.main.feelsLike;
    weatherDescription = currentWeather.weather[0].description[0].toUpperCase() + currentWeather.weather[0].description.substring(1);

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cityNotifier = Provider.of<CityNotifier>(context);
    return Center(
      child: isLoading
          ? CircularProgressIndicator()
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(cityName ?? 'Разрешите геопозицию чтобы увидеть погоду на вашей локации', style: TextStyle(fontSize: 24)),
          Text(weatherDescription, style: TextStyle(fontSize: 20)),
          Text('${temperature?.toString() ?? '--'} °C', style: TextStyle(fontSize: 48)),
          Text('Ощущается как: ${feelsLike?.toString() ?? '--'} °C', style: TextStyle(fontSize: 16)),
          SizedBox(height: 20),
          IconButton(
            onPressed: () {
              cityNotifier.resetCity();
            },
            icon: Icon(Icons.location_on),
          ),
        ],
      ),
    );
  }
}

