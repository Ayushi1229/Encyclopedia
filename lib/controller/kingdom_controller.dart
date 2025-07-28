<<<<<<< HEAD
import '../utils/import_export.dart';

class KingdomController extends GetxController {
  var selectedTabIndex = 0.obs;

  RxList<AnimalModel> animalList = <AnimalModel>[].obs;
  RxList<BirdModel> birdList = <BirdModel>[].obs;
  RxList<InsectModel> insectList = <InsectModel>[].obs;
  RxList<ReptileModel> reptileList = <ReptileModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadJsonData();
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }
  Future<void> loadJsonData() async {
    final String response = await rootBundle.loadString('assets/json/Flutter.json');
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
      }
    }

    animalList.value = (animalRows ?? []).map((row) {
      return AnimalModel(
        kingdomId: row[0],
        animalId: row[1],
        name: row[2],
        // continentId: row[3],
        // typeId: row[4],
        // foodId: row[5],
        // sound: row[6],
        // pVoice: row[7],
        photo: row[8],
      );
    }).toList();

    birdList.value = (birdRows ?? []).map((row) {
      return BirdModel(
        kingdomId: row[0],
        birdId: row[1],
        name: row[2],
        // continentId: row[3],
        // typeId: row[4],
        // foodId: row[5],
        // sound: row[6],
        // pVoice: row[7],
        photo: row[8],
      );
    }).toList();

    insectList.value = (insectRows ?? []).map((row) {
      return InsectModel(
        kingdomId: row[0],
        insectId: row[1],
        name: row[2],
        // continentId: row[3],
        // typeId: row[4],
        // foodId: row[5],
        // sound: row[6],
        // pVoice: row[7],
        photo: row[8],
      );
    }).toList();

    reptileList.value = (reptileRows ?? []).map((row) {
      return ReptileModel(
        kingdomId: row[0],
        reptileId: row[1],
        name: row[2],
        // continentId: row[3],
        // typeId: row[4],
        // foodId: row[5],
        // sound: row[6],
        // pVoice: row[7],
        photo: row[8],
      );
    }).toList();
  }

}
=======
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
>>>>>>> f741e03f73676f655f95f21779de9579bb44816f
