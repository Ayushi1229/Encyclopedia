
import '../detail_screen/detail_screen.dart';
import '../utils/import_export.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) {
    Get.put(KingdomController());
  }

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

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
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
    return GetMaterialApp(
      home: Scaffold(
        backgroundColor: Colors.orange.shade50,
        appBar: AppBar(
          title: const Text(APPBAR_TITLE),
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
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
            unselectedLabelColor: Colors.white54,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            tabs: const [
              Tab(text: 'ANIMAL'),
              Tab(text: 'BIRD'),
              Tab(text: 'INSECT'),
              Tab(text: 'REPTILE'),
            ],
            onTap: (index) {
              controller.changeTab(index);
            },
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Obx(() => buildGrid(controller.animalList)),
            Obx(() => buildGrid(controller.birdList)),
            Obx(() => buildGrid(controller.insectList)),
            Obx(() => buildGrid(controller.reptileList)),
          ],
        ),
      ),
    );
  }

  Widget buildGrid(List<dynamic> items) {
    return GridView.builder(
      itemCount: items.length,
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, i) {
        final item = items[i];
        return GestureDetector(
            onTap: () {
              Get.to(() => DetailScreen(name: item.name, photo: item.photo));
            },
        child:  Card(
          elevation: 5,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  item.photo,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
                    );
                  },
                ),
                Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.center,
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Text(
                    item.name,
                    style: const TextStyle(
                      fontFamily: 'Arial',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black45,
                          offset: Offset(0, 1),
                        )
                      ],
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ));
      },
    );
  }
}
