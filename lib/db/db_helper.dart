<<<<<<< HEAD
import 'dart:io';
import '../utils/import_export.dart';
class DBHelper {
  static Database? _db;

  /// Get the database instance (singleton)
  Future<Database> get db async {
    return _db ??= await initDb();
  }

  /// Initialize the database (with copy if pre-filled)
  Future<Database> initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'Flutter.db');

    // ✅ Copy from assets if not exists
    final exists = await databaseExists(path);
    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
        print("Loading database from assets/db/Flutter.db");
        ByteData data = await rootBundle.load("assets/db/Flutter.db");
        List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(path).writeAsBytes(bytes, flush: true);
        print("Database copied successfully to: $path");
      } catch (e) {
        print("Error copying pre-filled database: $e");
      }
    } else {
      print("Database already exists at: $path");
    }

    return await openDatabase(path);
  }

  /// ✅ Fetch all animals
  Future<List<AnimalModel>> getAnimals() async {
    final dbClient = await db;
    try {
      final List<Map<String, dynamic>> maps =
      await dbClient.rawQuery('SELECT AnimalId, Name, Photo FROM Animal');
      print('Raw animal data from DB: $maps');
      return maps.map((map) => AnimalModel.fromMap(map)).toList();
    } catch (e) {
      print('Error fetching animals: $e');
      return [];
    }
  }

  Future<List<BirdModel>> getBirds() async {
    final dbClient = await db;
    try {
      final List<Map<String, dynamic>> maps =
      await dbClient.rawQuery('SELECT BirdId, Name, Photo FROM Bird');
      print('Raw bird data from DB: $maps');
      return maps.map((map) => BirdModel.fromMap(map)).toList();
    } catch (e) {
      print('Error fetching birds: $e');
      return [];
    }
  }

  /// ✅ Fetch all insects
  Future<List<InsectModel>> getInsects() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps =
    await dbClient.rawQuery('SELECT AnimalId, Name, Photo FROM Insect');
    return maps.map((map) => InsectModel.fromMap(map)).toList();
  }

  /// ✅ Fetch all reptiles
  Future<List<ReptileModel>> getReptiles() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps =
    await dbClient.rawQuery('SELECT AnimalId, Name, Photo FROM Reptile');
    return maps.map((map) => ReptileModel.fromMap(map)).toList();
  }
}
=======
import 'package:encyclopedia/model/animal_model.dart';
import 'package:encyclopedia/model/bird_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:flutter/services.dart'; // For loading bundled db

class DBHelper {
  static Database? _db;

  /// Get the database instance (singleton)
  Future<Database> get db async {
    return _db ??= await initDb();
  }

  /// Initialize the database (with copy if pre-filled)
  Future<Database> initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'flutter.db');

    // ✅ Copy from assets if not exists
    final exists = await databaseExists(path);
    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
        ByteData data = await rootBundle.load("assets/db/flutter.db");
        List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(path).writeAsBytes(bytes, flush: true);
      } catch (e) {
        print("Error copying pre-filled database: $e");
      }
    }

    return await openDatabase(path);
  }

  /// ✅ Fetch all animals
  Future<List<AnimalModel>> getAnimals() async {
    final dbClient = await db; // ✅ FIXED HERE
    final List<Map<String, dynamic>> maps =
    await dbClient.rawQuery('SELECT AnimalId, Name, Photo FROM Animal');
    return maps.map((map) => AnimalModel.fromMap(map)).toList();
  }

  /// ✅ Fetch all birds
  Future<List<BirdModel>> getBirds() async {
    final dbClient = await db;
    final res = await dbClient.query('Bird');
    return res.map((e) => BirdModel.fromJson(e)).toList();
  }

// 🔄 Future<List<InsectModel>> getInsects()
// 🔄 Future<List<ReptileModel>> getReptiles()
}
>>>>>>> f741e03f73676f655f95f21779de9579bb44816f
