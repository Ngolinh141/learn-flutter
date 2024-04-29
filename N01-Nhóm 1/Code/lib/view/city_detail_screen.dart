import 'dart:convert';
import 'package:country_app/models/population.dart';
import 'package:country_app/models/position.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../data/remote/api_endpoint.dart';
import '../models/country.dart';
import 'widget/ui_text.dart';

class CityDetailsScreen extends StatefulWidget {
  final Country country;

  const CityDetailsScreen({Key? key, required this.country}) : super(key: key);

  @override
  _CityDetailsScreenState createState() => _CityDetailsScreenState();
}

class _CityDetailsScreenState extends State<CityDetailsScreen> {
  Country cities1 = Country(id: "", name: "", flag: "", cities: []);
  Position position1 = Position(name: "", lat: "", long: "");
  Population population1 =
      Population(city: "", country: "", populationCounts: []);
  @override
  void initState() {
    super.initState();
    fetchCitiesByCountry(widget.country.name)
        .whenComplete(() => displayedCities.addAll(cities1.cities));
  }

  List<String> displayedCities = [];
  Future<void> fetchCitiesByCountry(String country) async {
    final response = await http.get(Uri.parse(ApiEndPoint.countriesnow));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      setState(() {
        List<Country> cities = List<Country>.from(
            data['data'].map((country) => Country.fromJson(country)));
        cities1 = cities.firstWhere((element) => element.name == country);
      });
    }
  }

  Future<Map<String, dynamic>?> getCityPosition(String cityName) async {
    final response = await http.get(Uri.parse(ApiEndPoint.countriesposition));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        List<Position> position = List<Position>.from(
            data['data'].map((position) => Position.fromJson(position)));
        position1 = position.firstWhere((element) => element.name == cityName);
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.country.name),
      ),
      //tìm kiếm city
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: filterCities,
              decoration: InputDecoration(
                labelText: 'Search City',
                hintText: 'Enter City name',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          if (displayedCities.isEmpty)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns in the grid
                  crossAxisSpacing: 8.0, // Spacing between columns
                  mainAxisSpacing: 8.0, // Spacing between rows
                ),
                itemCount: displayedCities.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      await getCityPosition(widget.country.name);
                      if (!context.mounted) return;
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              UIText(
                                textAlign: TextAlign.center,
                                "City Name: ${displayedCities[index]}",
                              ),
                              UIText(
                                'Năm: 2021 \nDân số: 12000 \nDiện tích: 10360 km² \nGDP: 1200000\nKinh độ: ${position1.long ?? "10"} \nVĩ độ: ${position1.lat ?? "10"}',
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: buildCityCard(
                        displayedCities[index], widget.country.name),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget buildCityCard(String cityName, String countryName) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(cityName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            Text(
              countryName,
            ),
          ],
        ),
      ),
    );
  }

  void filterCities(String query) {
    setState(() {
      displayedCities = cities1.cities
          .where((city) => city.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }
}
