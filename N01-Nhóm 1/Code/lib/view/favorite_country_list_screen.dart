import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/country.dart';
import 'city_detail_screen.dart';
import 'database_helper.dart';

class FavoriteCountryListScreen extends StatefulWidget {
  const FavoriteCountryListScreen({Key? key}) : super(key: key);

  @override
  _FavoriteCountryListScreenState createState() =>
      _FavoriteCountryListScreenState();
}

class _FavoriteCountryListScreenState extends State<FavoriteCountryListScreen> {
  List<Country> favoriteCities = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    List<Map<String, dynamic>> favorites = await databaseHelper.getFavorites();
    setState(() {
      favoriteCities = favorites
          .map((favorite) => Country(
                id: favorite['id'],
                name: favorite['name'],
                flag: favorite['flag'],
                cities: [],
              ))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách quốc gia yêu thích'),
      ),
      body: favoriteCities.isEmpty
          ? const Center(
              child: Text('Không có quốc gia yêu thích.'),
            )
          : ListView.builder(
              itemCount: favoriteCities.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CityDetailsScreen(
                            country: favoriteCities[index],
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
                          height: 40,
                          width: 40,
                          child: SvgPicture.network(
                            favoriteCities[index].flag,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(
                            favoriteCities[index].name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            //toggleFavorite(favoriteCities[index]);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
