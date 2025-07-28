
import 'package:encyclopedia/model/bird_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/kingdom_controller.dart';
import '../model/animal_model.dart';
void main() {
  runApp( FirstPageView());
}

class FirstPageView extends StatelessWidget {
  final KingdomController controller = Get.put(KingdomController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animal Encyclopedia"),
        centerTitle: true,
      ),
      body: Obx(() {
        final selectedIndex = controller.selectedTabIndex.value;
        final isAnimal = selectedIndex == 0;
        final items = selectedIndex == 0
            ? controller.animalList
            : controller.birdList;

        if (items.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return GridView.builder(
          padding: EdgeInsets.all(10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: items.length,
            itemBuilder: (context, index) {
              final item = isAnimal
                  ? controller.animalList[index]
                  : controller.birdList[index];

              final name = isAnimal ? (item as AnimalModel).name : (item as BirdModel).name;
              final photo = isAnimal ? (item as AnimalModel).photo : (item as BirdModel).photo;

              return Card(
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/images/$photo',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.broken_image),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              );
            }

        );
      }),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: controller.selectedTabIndex.value,
          onTap: controller.changeTab,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.pets),
              label: 'Animals',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.flight),
              label: 'Birds',
            ),
          ],
        );
      }),
    );
  }
}
