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
  late List<ForecastDay> _forecast;

  List<ForecastDay> sortForecastStamps(List<Forecast> forecasts, int timeShift) {
    Map<String, List<Forecast>> groupedForecasts = {};

    for (var forecast in forecasts) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch((forecast.dt + timeShift) * 1000, isUtc: true);
      String dayKey = DateFormat('yyyy-MM-dd').format(dateTime);

      if (!groupedForecasts.containsKey(dayKey)) {
        groupedForecasts[dayKey] = [];
      }
      groupedForecasts[dayKey]!.add(forecast);
    }

    List<ForecastDay> forecastDays = groupedForecasts.entries.map((entry) {
      return ForecastDay(hours: entry.value);
    }).toList();

    return forecastDays;
  }

  Future<void> _fetchWeather() async {
    final notifier = Provider.of<CityNotifier>(context, listen: false);
    double lat = notifier.city?.lat ?? 0.0;
    double lon = notifier.city?.lon ?? 0.0;
    String cityName = notifier.city?.name ?? '';

    if (cityName == '') {
      return;
    }

    WeatherForecast weatherForecast = WeatherForecast.fromJson(
        jsonDecode(await WeatherRequest().getForecast(lat, lon)));

    _forecast = sortForecastStamps(weatherForecast.list, weatherForecast.city.timezone);

  }

  @override
  Widget build(BuildContext context) {
   final notifier = Provider.of<CityNotifier>(context);

   return Center(
     child: _isLoading
         ? CircularProgressIndicator()
         : Column(
       mainAxisAlignment: MainAxisAlignment.center,

     ) ,
   );
  }
}