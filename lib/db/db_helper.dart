import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/animal_model.dart';
import '../model/bird_model.dart';
import '../model/insect_model.dart';
import '../model/reptile_model.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'Flutter.db');

    final exists = await databaseExists(path);
    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
        ByteData data = await rootBundle.load("assets/db/Flutter.db");
        final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(path).writeAsBytes(bytes, flush: true);
        print("✅ Database copied to: $path");
      } catch (e) {
        print("❌ Error copying DB: $e");
        rethrow;
      }
    } else {
      print("📦 Database already exists at: $path");
    }

    return openDatabase(path);
  }

  // ------------------ Fetch Lists with Foreign Key JOINs ------------------

  Future<List<AnimalModel>> getAnimals() async {
    final db = await database;
    try {
      final maps = await db.rawQuery('''
        SELECT a.AnimalId, a.Name, a.Photo,
               c.Name AS ContinentName,
               f.Name AS FoodTypeName,
               t.Name AS TypeName
        FROM Animal a
        INNER JOIN Continent c ON a.ContinentId = c.ContinentId
        INNER JOIN FoodType f ON a.FoodTypeId = f.FoodTypeId
        INNER JOIN Type t ON a.TypeId = t.TypeId
      ''');
      return maps.map((e) => AnimalModel.fromMap(e)).toList();
    } catch (e) {
      print('❌ Error fetching animals: $e');
      return [];
    }
  }

  Future<List<BirdModel>> getBirds() async {
    final db = await database;
    try {
      print("Get into birds::::::::::");
      final maps = await db.rawQuery('''
        SELECT b.BirdId, b.Name, b.Photo,
               c.Name AS ContinentName,
               f.Name AS FoodTypeName,
               t.Name AS TypeName
        FROM Bird b
        INNER JOIN Continent c ON b.ContinentId = c.ContinentId
        INNER JOIN FoodType f ON b.FoodId = f.FoodTypeId
        INNER JOIN Type t ON b.TypeId = t.TypeId
      ''');
      print("Birdds : $maps");
      return maps.map((e) => BirdModel.fromMap(e)).toList();
    } catch (e) {
      print('❌ Error fetching birds: $e');
      return [];
    }
  }

  Future<List<InsectModel>> getInsects() async {
    final db = await database;
    try {
      final maps = await db.rawQuery('''
        SELECT i.InsectId, i.Name, i.Photo,
               c.Name AS ContinentName,
               f.Name AS FoodTypeName,
               t.Name AS TypeName
        FROM Insect i
        INNER JOIN Continent c ON i.ContinentId = c.ContinentId
        INNER JOIN FoodType f ON i.FoodId = f.FoodTypeId
        INNER JOIN Type t ON i.TypeId = t.TypeId
      ''');
      return maps.map((e) => InsectModel.fromMap(e)).toList();
    } catch (e) {
      print('❌ Error fetching insects: $e');
      return [];
    }
  }

  Future<List<ReptileModel>> getReptiles() async {
    final db = await database;
    try {
      final maps = await db.rawQuery('''
        SELECT r.ReptileId, r.Name, r.Photo,
               c.Name AS ContinentName,
               f.Name AS FoodTypeName,
               t.Name AS TypeName
        FROM Reptile r
        INNER JOIN Continent c ON r.ContinentId = c.ContinentId
        INNER JOIN FoodType f ON r.FoodId = f.FoodTypeId
        INNER JOIN Type t ON r.TypeId = t.TypeId
      ''');
      return maps.map((e) => ReptileModel.fromMap(e)).toList();
    } catch (e) {
      print('❌ Error fetching reptiles: $e');
      return [];
    }
  }


// ------------------ Foreign Key Lookups ------------------

  Future<String?> getContinentNameById(int id) async {
    final db = await database;
    print("$db::::::::::::::::");
    final result = await db.query('Continent', where: 'ContinentId = ?', whereArgs: [id]);
    print("Continent lookup for ID $id: $result");  // Debug: See what comes back
    if (result.isNotEmpty) {
      return result.first['Name']?.toString();
    }
    print("No continent found for ID $id");  // Log if not found
    return null;
  }

  Future<String?> getFoodTypeNameById(int id) async {
    final db = await database;
    final result = await db.query('FoodType', where: 'FoodTypeId = ?', whereArgs: [id]);
    print("FoodType lookup for ID $id: $result");  // Debug
    if (result.isNotEmpty) {
      return result.first['Name']?.toString();
    }
    print("No food type found for ID $id");  // Log if not found
    return null;
  }

  Future<String?> getModeTypeNameById(int id) async {
    final db = await database;
    final result = await db.query('Type', where: 'TypeId = ?', whereArgs: [id]);
    print("Type lookup for ID $id: $result");  // Debug
    if (result.isNotEmpty) {
      return result.first['Name']?.toString();
    }
    print("No mode type found for ID $id");  // Log if not found
    return null;
  }
}
