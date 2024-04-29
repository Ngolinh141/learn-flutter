import 'package:country_app/data/remote/api_endpoint.dart';
import 'package:country_app/view/city_detail_screen.dart';
import 'package:country_app/view/database_helper.dart';
import 'package:country_app/view/favorite_country_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/country.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/routes/routes.dart';
import 'widget/ui_text.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CityListScreen extends StatefulWidget {
  const CityListScreen({Key? key}) : super(key: key);

  @override
  _CityListScreenState createState() => _CityListScreenState();
}

class _CityListScreenState extends State<CityListScreen> {
  List<Country> countries = [];
  List<Country> favoriteCities = [];

  @override
  void initState() {
    super.initState();
    fetchCountries().whenComplete(() => displayedCities.addAll(countries));
  }

  Future<void> fetchCountries() async {
    final response = await http.get(Uri.parse(ApiEndPoint.countriesflag));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        countries = List<Country>.from(
            data['data'].map((country) => Country.fromJsonFlag(country)));
      });
    }
  }

  List<Country> displayedCities = [];
  void filterCities(String query) {
    setState(() {
      displayedCities = countries
          .where(
              (city) => city.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> toggleFavorite(Country country) async {
    DatabaseHelper databaseHelper = DatabaseHelper();

    if (favoriteCities.contains(country)) {
      setState(() {
        favoriteCities.remove(country);
      });
      await databaseHelper.database.then((db) {
        db.delete('favorites', where: 'id = ?', whereArgs: [country.id]);
      });
    } else {
      setState(() {
        favoriteCities.add(country);
      });
      await databaseHelper.database.then((db) {
        db.insert('favorites', {
          'id': country.id,
          'name': country.name,
          'flag': country.flag,
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const UIText('Danh sách các quốc gia'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoriteCountryListScreen(),
                ),
              );
            },
          ),
        ],
      ),
      //tìm kiếm country
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: filterCities,
              decoration: InputDecoration(
                labelText: 'Search Nation',
                hintText: 'Enter Nation name',
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
              child: ListView.builder(
                itemCount: displayedCities.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CityDetailsScreen(
                              country: displayedCities[index],
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: SvgPicture.network(
                              displayedCities[index].flag,
                              semanticsLabel: displayedCities[index].name,
                              placeholderBuilder: (BuildContext context) =>
                                  Container(
                                      padding: const EdgeInsets.all(30.0),
                                      child: const CircularProgressIndicator()),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 200,
                            child: UIText(
                              displayedCities[index].name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              favoriteCities.contains(displayedCities[index])
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              toggleFavorite(displayedCities[index]);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 169, 215, 251),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    CircleAvatar(
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: Icon(
                          Icons.person,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // Text('Người dùng ')
                  ]),
            ),
            ListTile(
              contentPadding: const EdgeInsets.only(left: 30),
              title: const Text('Trang chủ'),
              onTap: () async {
                Navigator.pop(context);
              },
            ),
            ListTile(
              contentPadding: const EdgeInsets.only(left: 30),
              title: const Text('Đăng xuất'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                if (!context.mounted) return;
                Routes.goToSignInScreen(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
