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
