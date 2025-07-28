<<<<<<< HEAD
import '../utils/import_export.dart';
class CategoryGridView extends StatelessWidget {
  dynamic items;
   CategoryGridView({super.key, items}){
     this.items = items;
   }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KingdomController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Categories")),
      body: Obx(() {
        final index = controller.selectedTabIndex.value;

        // final items = switch (index) {
        //   0 => controller.animalList,
        //   1 => controller.birdList,
        //   _ => [],
        // };

        return GridView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10,
          ),
          itemBuilder: (context, i) {
            final item = items[i];
            return Card(
              elevation: 4,
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/${item.photo}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        print('Loading image: ${item.photo}');
                        return const Icon(Icons.broken_image, size: 48, color: Colors.grey);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(item.name),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
=======
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/kingdom_controller.dart';


void main() {
  runApp(const CategoryGridView());
}

class CategoryGridView extends StatelessWidget {
  const CategoryGridView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KingdomController>();

    return Obx(() {
      final index = controller.selectedTabIndex.value;

      final items = switch (index) {
        0 => controller.animalList,
        1 => controller.birdList,
        _ => [],
      };

      return GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10,
        ),
        itemBuilder: (context, i) {
          final item = items[i];
          return Card(
            elevation: 4,
            child: Column(
              children: [
                Expanded(
                  child: Image.asset(
                    'assets/images/${item.photo}', // e.g., "Koala Bear.jpg"
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('Loading image: ${item.photo}');

                      return Icon(Icons.broken_image, size: 48, color: Colors.grey);

                    },
                  ),

                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(item.name),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
>>>>>>> f741e03f73676f655f95f21779de9579bb44816f
