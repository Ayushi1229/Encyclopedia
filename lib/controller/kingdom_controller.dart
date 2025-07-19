import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import '../model/animal_model.dart';
import '../model/bird_model.dart';
import '../db/db_helper.dart';

class KingdomController extends GetxController {
  final DBHelper _dbHelper = DBHelper();

  RxInt selectedTabIndex = 0.obs;

  RxList<AnimalModel> animalList = <AnimalModel>[].obs;
  RxList<BirdModel> birdList = <BirdModel>[].obs;
  Future<List<AnimalModel>> fetchAnimals(Database db) async {
    final List<Map<String, dynamic>> maps =
    await db.rawQuery('SELECT AnimalId, Name, Photo FROM Animal');

    return maps.map((map) => AnimalModel.fromMap(map)).toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadDataForIndex(selectedTabIndex.value);
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
    loadDataForIndex(index);
  }

  void loadDataForIndex(int index) {
    switch (index) {
      case 0:
        loadAnimals();
        break;
      case 1:
        loadBirds();
        break;
    }
  }

  void loadAnimals() async {
    final data = await _dbHelper.getAnimals();
    animalList.assignAll(data); // ✅ .assignAll() for RxList
  }

  void loadBirds() async {
    final data = await _dbHelper.getBirds();
    birdList.assignAll(data);
  }
}
