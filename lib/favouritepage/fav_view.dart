import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/kingdom_controller.dart';

class FavView  extends StatelessWidget {
  final KingdomController controller = Get.find();

  FavView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.favoriteList.isEmpty) {
          return Center(
            child: Text(
              'No favorites added.',
              style: TextStyle(fontSize: 18),
            ),
          );
        } else {
          return ListView.builder(
            itemCount: controller.favoriteList.length,
            itemBuilder: (context, index) {
              final item = controller.favoriteList[index];
              return Card(
                margin: EdgeInsets.all(10),
                elevation: 5,
                child: ListTile(
                  leading: Image.asset(
                    item.photo,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(item.name),
                  subtitle: Text(
                      'Continent: ${item.continentName}, Food: ${item.foodName}, Type: ${item.typeName}'),
                  trailing: IconButton(
                    icon: Icon(Icons.favorite, color: Colors.red),
                    onPressed: () {
                      controller.toggleFavorite(item);
                    },
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
