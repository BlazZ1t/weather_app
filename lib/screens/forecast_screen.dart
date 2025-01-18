import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:weather_app/class_templates/forecast_weather.dart';
import 'package:weather_app/request_handler/weather_request_handler.dart';

import 'package:weather_app/screens/search_screen.dart';

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  bool _isLoading = true;
  late List<WeatherData> _forecast;
  late int _timezoneShift;
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
    final notifier = Provider.of<CityNotifier>(context, listen: false);
    double lat = notifier.city?.lat ?? 0.0;
    double lon = notifier.city?.lon ?? 0.0;
    String cityName = notifier.city?.name ?? '';

    if (cityName == '') {
      return;
    }

    WeatherForecast weatherForecast = WeatherForecast.fromJson(
        jsonDecode(await WeatherRequest().getForecast(lat, lon)));

    _forecast = weatherForecast.list;
    _timezoneShift = weatherForecast.city.timezone;

    setState(() {
      _isLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
   final notifier = Provider.of<CityNotifier>(context);

   return Center(
     child: _isLoading
         ? CircularProgressIndicator()
         : Column(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
         Text("Fetched ${_forecast.length} days")
       ],
     ) ,
   );
  }
}