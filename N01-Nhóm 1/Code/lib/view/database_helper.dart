import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    if (_instance == null) {
      _instance = DatabaseHelper._internal();
    }
    return _instance!;
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'favorites.db');
    return await openDatabase(path, version: 4, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
    CREATE TABLE favorites(
      id TEXT PRIMARY KEY,
      name TEXT,
      flag TEXT
    )
  ''');
  }

  Future<int> insertFavorite(Map<String, dynamic> favorite) async {
    Database db = await database;
    favorite['id'] = favorite['id'].toString();
    return await db.insert('favorites', favorite);
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    Database db = await database;
    return await db.query('favorites');
  }
}
