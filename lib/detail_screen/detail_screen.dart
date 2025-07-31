import 'package:encyclopedia/model/animal_model.dart';
import 'package:encyclopedia/model/bird_model.dart';
import 'package:encyclopedia/model/reptile_model.dart';
import 'package:flutter/material.dart';
import '../controller/kingdom_controller.dart';
import '../db/db_helper.dart';
import 'package:get/get.dart';

import '../model/insect_model.dart';

class DetailScreen extends StatelessWidget {
  final dynamic item; // AnimalModel, BirdModel, etc.

  DetailScreen({super.key, required this.item});

  KingdomController kingdomController = Get.find();

  Future<Map<String, String>> fetchDetails() async {
    final db = DBHelper();
    print('Continent ID: ${item.continentId}');
    print('Food ID: ${item.foodId}');
    print('Type ID: ${item.typeId}');

    // print('Continent name: ${item.continentName}');
    String continentName = "Not found";
    String foodName = "Not found";
    String TypeName = "Not found";

    try {
      List<AnimalModel> animalList = kingdomController.animalList;
      print(animalList);

      List<BirdModel> birdList = kingdomController.birdList;
      print(birdList);

      List<InsectModel> insectList = kingdomController.insectList;
      print(insectList);

      List<ReptileModel> reptileList = kingdomController.reptileList;
      print(reptileList);

      // if (item.continentId != null) {
      //   continentName = await db.getContinentNameById(item.continentId) ?? "Not found";
      //   print("Continent name: $continentName");
      // }
      // if (item.foodId != null) {
      //   foodName = await db.getFoodTypeNameById(item.foodId) ?? "Not found";
      //   print("Food name: $foodName");
      // }
      // if (item.typeId != null) {
      //   TypeName = await db.getModeTypeNameById(item.typeId) ?? "Not found";
      //   print("Type name: $TypeName");
      // }
    } catch (e) {
      print("Error fetching details: $e");
    }

    return {
      'continentName': continentName,
      'foodName': foodName,
      'typeName': TypeName,
    };
  }

  @override
  Widget build(BuildContext context) {
    final String continentName = item.continentName;
    final String foodName = item.foodName;
    final String typeName = item.typeName;
    return Scaffold(
      appBar: AppBar(
        title: Text(item?.name ?? 'Unknown'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Photo Section
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: Image.asset(
                item?.photo ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                actionButton(Icons.volume_up_rounded, Colors.deepOrange),
                actionButton(Icons.favorite_border, Colors.redAccent),
                actionButton(Icons.spatial_audio, Colors.blueAccent),
              ],
            ),
            const SizedBox(height: 20),
            // Async Details
            FutureBuilder<Map<String, String>>(
              future: fetchDetails(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError || !snapshot.hasData) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("Error loading details"),
                  );
                } else {
                  final data = snapshot.data!;
                  print("data : $data");
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // detailRow("Continent", data['continentName']),
                          Text("Continent: $continentName"),
                          Text("Food: $foodName"),
                          Text("Type: $typeName"),
                          // detailRow("Continent, $continentName"),
                          // detailRow("Food Type", data['foodName']),
                          // detailRow("Mode Type", data['typeName']),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget actionButton(IconData icon, Color color) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
        backgroundColor: color,
      ),
      child: Icon(icon, size: 30, color: Colors.white),
    );
  }

  Widget detailRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        "$title: ${value ?? 'N/A'}",
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
