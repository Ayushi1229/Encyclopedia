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
