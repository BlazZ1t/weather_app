import 'dart:convert';

class City {
  String name;
  Map<String, String>? localNames;
  double lat;
  double lon;
  String country;
  String? state;

  City({required this.name, this.localNames, required this.lat,
    required this.lon, required this.country, this.state});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'],
      localNames: json['local_names'] != null
          ? Map<String, String>.from(json['local_names'])
          : null,
      lat: json['lat'],
      lon: json['lon'],
      country: json['country'],
      state: json['state'],
    );
  }
}

class CityResponse {
  List<City> cities;

  CityResponse({required this.cities});

  factory CityResponse.fromJson(String jsonStr) {
    List<dynamic> jsonArray = json.decode(jsonStr);
    List<City> cityList = jsonArray.map((json) => City.fromJson(json)).toList();
    return CityResponse(cities: cityList);
  }
}