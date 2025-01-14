import 'package:flutter/material.dart';

import 'search_screen.dart';
import 'forecast_screen.dart';
import 'today_weather_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const List<Widget> _widgetOptions = <Widget>[
    SearchScreen(),
    TodayWeatherScreen(),
    ForecastScreen(),
  ];
  int _currentIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "Search"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.wb_cloudy),
                label: "Weather"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: "Forecast")
          ]
      ),
    );
  }
}