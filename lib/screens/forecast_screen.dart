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
  late List<WeatherDay> _forecast;
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

    _timezoneShift = weatherForecast.city.timezone;
    _forecast = sortWeatherDataIntoDays(weatherForecast.list, _timezoneShift);

    setState(() {
      _isLoading = false;
    });
  }

  List<WeatherDay> sortWeatherDataIntoDays(List<WeatherData> weatherDataList, int timezoneShift) {
    Map<String, List<WeatherData>> daysMap = {};

    for (var weatherData in weatherDataList) {
      // Adjust the timestamp with the timezone shift
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(weatherData.dt * 1000, isUtc: true)
          .add(Duration(seconds: timezoneShift));

      // Format the date to extract day, month, and year
      String dayKey = DateFormat('yyyyMMdd').format(dateTime);

      if (!daysMap.containsKey(dayKey)) {
        daysMap[dayKey] = [];
      }
      daysMap[dayKey]!.add(weatherData);
    }

    List<WeatherDay> weatherDays = [];
    daysMap.forEach((dayKey, weatherDataList) {
      DateTime date = DateTime.parse(dayKey);
      weatherDays.add(WeatherDay(
        day: date.day,
        month: date.month,
        year: date.year,
        hours: weatherDataList,
      ));
    });

    return weatherDays;
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
             Expanded(
               child: ListView.builder(
                      itemCount: _forecast.length,
               itemBuilder: (context, index) {
                 final day = _forecast[index];
                 DateTime dateTime = DateTime(day.year, day.month, day.day);
                 final dateTimeString = DateFormat('dd.MM.yyyy').format(dateTime);
                 final temperature = day.averageTemperature;
                 return ListTile(
                   title: Text(dateTimeString,
                   style: TextStyle(fontSize: 16)
                   ),
                   subtitle: Text('Средняя температура: $temperature'),
                 );
               }
                    ),
             ),
           ],
         )
   );
  }
}