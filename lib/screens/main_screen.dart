import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../class_templates/city.dart';
import 'search_screen.dart';
import 'forecast_screen.dart';
import 'today_weather_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  void _onCitySelected(City city) {
    setState(() {
      Provider.of<CityNotifier>(context, listen: false).updateCity(city);
      _selectedIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      SearchScreen(onCitySelected: _onCitySelected),
      TodayWeatherScreen(),
      ForecastScreen()
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Погода'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xdd48dafe),
          unselectedItemColor: Color(0xffc2f2fe),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "Поиск"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.wb_cloudy),
                label: "Погода"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: "Прогноз")
          ]
      ),
    );
  }
}