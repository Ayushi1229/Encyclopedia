import 'package:encyclopedia/controller/kingdom_controller.dart';
import 'package:encyclopedia/favouritepage/fav_view.dart';
import 'package:encyclopedia/view/category_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/import_export.dart';

void main() {
  Get.put(KingdomController()); // Register GetX controller
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Animals And Birds Sound',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final KingdomController controller = Get.find();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: controller.selectedTabIndex.value,
    );

    // Sync swipe (index change) with controller
    _tabController.addListener(() {
      if (_tabController.indexIsChanging == false) {
        controller.selectedTabIndex.value = _tabController.index;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(APPBAR_TITLE),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.star_border),
            onPressed: () => Get.to(() => const FavView()),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'about') {
                Get.to(() => const About());
              } else if (value == 'setting') {
                Get.to(() => const Setting());
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'about', child: Text('About')),
              PopupMenuItem(value: 'setting', child: Text('Setting')),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'ANIMAL'),
            Tab(text: 'BIRD'),
            Tab(text: 'INSECT'),
            Tab(text: 'REPTILE'),
          ],
          onTap: (index) {
            controller.changeTab(index); // Optional, keep both in sync
          },
        ),
      ),
        body: Obx(() {
          final index = controller.selectedTabIndex.value;

          // Convert RxList to normal List using .toList()

          late final List items;

          if (index == 0) {
            items = controller.animalList.toList();
          } else if (index == 1) {
            items = controller.birdList.toList();
          } else {
            items = [];
          }


          return GridView.builder(
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, i) {
              final item = items[i];
              return Card(
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
                    Text(item.name),
                  ],
                ),
              );
            },
          );
        })


    );
  }
}
