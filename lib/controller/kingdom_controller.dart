import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:collection/collection.dart';

import '../model/continent_model.dart';
import '../model/food_type_model.dart';
import '../model/type_model.dart';
import '../utils/import_export.dart';

class KingdomController extends GetxController {
  var selectedTabIndex = 0.obs;
  var favoriteList = <dynamic>[].obs;

  RxList<AnimalModel> animalList = <AnimalModel>[].obs;
  RxList<BirdModel> birdList = <BirdModel>[].obs;
  RxList<InsectModel> insectList = <InsectModel>[].obs;
  RxList<ReptileModel> reptileList = <ReptileModel>[].obs;

  List<dynamic> continentList = [];
  List<dynamic> foodList = [];
  List<dynamic> typeList = [];

  @override
  void onInit() {
    super.onInit();
    loadJsonData().then((_) {
      loadFavorites(); // Load favorites after JSON data is ready
    });
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  void toggleFavorite(dynamic item) {
    if (isFavorite(item)) {
      favoriteList.removeWhere((fav) => fav.name == item.name);
      Get.snackbar(
        "Removed",
        "${item.name} removed from favorites",
        backgroundColor: Colors.black.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    } else {
      favoriteList.add(item);
      Get.snackbar(
        "Added",
        "${item.name} added to favorites",
        backgroundColor: Colors.black.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    }
    saveFavorites(); // Save after every change
  }

  bool isFavorite(dynamic item) {
    return favoriteList.any((element) => element.name == item.name);
  }

  /// Save favorites to SharedPreferences
  Future<void> saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Store as JSON strings
    List<String> favJsonList = favoriteList.map((item) {
      return jsonEncode({
        'name': item.name,
        'photo': item.photo,
        'continentName': item.continentName,
        'foodName': item.foodName,
        'typeName': item.typeName,
        'kingdomId': item.kingdomId,
      });
    }).toList();

    await prefs.setStringList('favorites', favJsonList);
  }

  /// Load favorites from SharedPreferences
  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favJsonList = prefs.getStringList('favorites') ?? [];

    favoriteList.clear();

    for (String jsonStr in favJsonList) {
      var favMap = jsonDecode(jsonStr);

      // Match with existing items from any list
      var match = [
        ...animalList,
        ...birdList,
        ...insectList,
        ...reptileList
      ].cast<dynamic?>().firstWhere(
            (item) => item?.name == favMap['name'],
        orElse: () => null,
      );


      if (match != null) {
        favoriteList.add(match);
      }
    }
  }
  List<dynamic> getRelatedSpecies(dynamic item) {
    final String currentContinent = item.continentName ?? '';

    if (animalList.contains(item)) {
      return animalList
          .where((animal) =>
      animal != item && (animal.continentName ?? '') == currentContinent)
          .toList();
    } else if (birdList.contains(item)) {
      return birdList
          .where((bird) =>
      bird != item && (bird.continentName ?? '') == currentContinent)
          .toList();
    } else if (insectList.contains(item)) {
      return insectList
          .where((insect) =>
      insect != item && (insect.continentName ?? '') == currentContinent)
          .toList();
    } else if (reptileList.contains(item)) {
      return reptileList
          .where((reptile) =>
      reptile != item && (reptile.continentName ?? '') == currentContinent)
          .toList();
    }

    return [];
  }



  Future<void> loadJsonData() async {
    final String response =
    await rootBundle.loadString('assets/json/Flutter.json');
    final Map<String, dynamic> data = json.decode(response);
    final List<dynamic> tables = data['objects'] ?? [];

    List<dynamic>? animalRows, birdRows, insectRows, reptileRows;

    for (var table in tables) {
      switch (table['name']) {
        case 'Animal':
          animalRows = table['rows'];
          break;
        case 'Bird':
          birdRows = table['rows'];
          break;
        case 'Insect':
          insectRows = table['rows'];
          break;
        case 'Reptile':
          reptileRows = table['rows'];
          break;
        case 'Continent':
          continentList = table['rows'];
          break;
        case 'FoodType':
          foodList = table['rows'];
          break;
        case 'Type':
          typeList = table['rows'];
          break;
      }
    }


    String getContinentName(int id) {
      return continentList.firstWhere((e) => e[0] == id,
          orElse: () => [id, 'Unknown'])[1];
    }

    String getFoodName(int id) {
      return foodList.firstWhere((e) => e[0] == id,
          orElse: () => [id, 'Unknown'])[1];
    }

    String getTypeName(int id) {
      return typeList.firstWhere((e) => e[0] == id,
          orElse: () => [id, 'Unknown'])[1];
    }

    animalList.value = (animalRows ?? []).map((row) {
      return AnimalModel(
        kingdomId: row[0],
        animalId: row[1],
        name: row[2],
        continentId: row[3],
        typeId: row[4],
        foodId: row[5],
        sound: row[6],
        voice: row[7],
        photo: row[8],
        continentName: getContinentName(row[3]),
        typeName: getTypeName(row[4]),
        foodName: getFoodName(row[5]),
      );
    }).toList();

    birdList.value = (birdRows ?? []).map((row) {
      return BirdModel(
        kingdomId: row[0],
        birdId: row[1],
        name: row[2],
        continentId: row[3],
        typeId: row[4],
        foodId: row[5],
        sound: row[6],
        voice: row[7],
        photo: row[8],
        continentName: getContinentName(row[3]),
        typeName: getTypeName(row[4]),
        foodName: getFoodName(row[5]),
      );
    }).toList();

    insectList.value = (insectRows ?? []).map((row) {
      return InsectModel(
        kingdomId: row[0],
        insectId: row[1],
        name: row[2],
        continentId: row[3],
        typeId: row[4],
        foodId: row[5],
        sound: row[6],
        voice: row[7],
        photo: row[8],
        continentName: getContinentName(row[3]),
        typeName: getTypeName(row[4]),
        foodName: getFoodName(row[5]),
      );
    }).toList();

    reptileList.value = (reptileRows ?? []).map((row) {
      return ReptileModel(
        kingdomId: row[0],
        reptileId: row[1],
        name: row[2],
        continentId: row[3],
        typeId: row[4],
        foodId: row[5],
        sound: row[6],
        voice: row[7],
        photo: row[8],
        continentName: getContinentName(row[3]),
        typeName: getTypeName(row[4]),
        foodName: getFoodName(row[5]),
      );
    }).toList();
  }
}
