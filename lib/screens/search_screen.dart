import 'package:flutter/material.dart';
import 'package:weather_app/class_templates/city.dart';
import 'package:weather_app/request_handler/city_request_handler.dart';

class CityListWidget extends StatelessWidget {
  final List<City> cities;
  final Function(City) onCitySelected;

  const CityListWidget({super.key, required this.cities, required this.onCitySelected});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cities.length,
      itemBuilder: (context, index) {
        final city = cities[index];
        final cityName = city.localNames?['ru'] ?? city.name;
        final noTranslationMessage = city.localNames?['ru'] == null
            ? " (В нашей датабазе нет переведённого названия)"
            : "";
        return ListTile(
          title: Text(
            '$cityName$noTranslationMessage',
            style: TextStyle(
              fontSize: city.localNames?['ru'] == null ? 14 : 16,
            ),
          ),
          subtitle: Text(city.country),
          onTap: () {
            onCitySelected(city); // Trigger the callback with the selected city
          },
        );
      },
    );
  }
}

class CityNotifier extends ChangeNotifier {
  City? _selectedCity;

  City? get city => _selectedCity;

  void updateCity(City? city) {
    _selectedCity = city;
    notifyListeners();
  }

  void resetCity() {
    updateCity(null);
  }
}

class SearchScreen extends StatefulWidget {
  final Function(City) onCitySelected;
  const SearchScreen({super.key, required this.onCitySelected});
  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<City> _foundCities = [];
  bool _isLoading = false;

  void _performSearch() async {
    setState(() {
      _isLoading = true;
    });

    final input = _controller.text;
    CityResponse cityResponse = CityResponse.fromJson(await CityRequest().findCity(input));

    setState(() {
      _foundCities = cityResponse.cities;
      _isLoading = false;
    });

    print('Found data on $input');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Введите город, погоду которого хотите узнать',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _performSearch,
              child: const Text("Искать"),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? CircularProgressIndicator()
                : Expanded(
              child: CityListWidget(cities: _foundCities, onCitySelected: widget.onCitySelected,),
            ),
          ],
        ),
      ),
    );
  }
}