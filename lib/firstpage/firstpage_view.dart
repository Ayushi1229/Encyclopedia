import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../detail_screen/detail_screen.dart';
import '../utils/import_export.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) {
    Get.put(KingdomController());
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final KingdomController controller = Get.find();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: controller.selectedTabIndex.value,
    );

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        controller.selectedTabIndex.value = _tabController.index;
        _animationController.reset();
        _animationController.forward();
      }
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.deepOrange.shade400,
                  Colors.orange.shade600,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
          ),
          title: Text(
            APPBAR_TITLE,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 22,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 8,
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          centerTitle: true,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: () => Get.to(() => FavView()),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Icon(
                      Icons.favorite_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: PopupMenuButton<String>(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(
                    Icons.more_vert_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
                onSelected: (value) {
                  if (value == 'about') {
                    Get.to(() => const Aboutus());
                  } else if (value == 'setting') {
                    // Get.to(() => const Setting());
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'about',
                    child: Row(
                      children: [
                        Icon(Icons.info_outline_rounded,
                            color: Colors.deepOrange.shade400),
                        const SizedBox(width: 12),
                        const Text('About',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'setting',
                    child: Row(
                      children: [
                        Icon(Icons.settings_outlined,
                            color: Colors.deepOrange.shade400),
                        const SizedBox(width: 12),
                        const Text('Settings',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // TabBar Container
            Container(
              margin: const EdgeInsets.all(16),
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [
                      Colors.deepOrange.shade400,
                      Colors.orange.shade500,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: const EdgeInsets.all(4),
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey.shade600,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                ),
                tabs: const [
                  Tab(
                    icon: Icon(Icons.pets, size: 18),
                    text: 'ANIMALS',
                  ),
                  Tab(
                    icon: Icon(Icons.flutter_dash, size: 18),
                    text: 'BIRDS',
                  ),
                  Tab(
                    icon: Icon(Icons.bug_report, size: 18),
                    text: 'INSECTS',
                  ),
                  Tab(
                    icon: Icon(Icons.nature, size: 18),
                    text: 'REPTILES',
                  ),
                ],
                onTap: (index) {
                  controller.changeTab(index);
                },
              ),
            ),
            // TabBarView Container
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.orange.shade50,
                      Colors.white,
                    ],
                  ),
                ),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      Obx(() => buildGrid(controller.animalList)),
                      Obx(() => buildGrid(controller.birdList)),
                      Obx(() => buildGrid(controller.insectList)),
                      Obx(() => buildGrid(controller.reptileList)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGrid(List<dynamic> items) {
    return GridView.builder(
      itemCount: items.length,
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, i) {
        dynamic item = items[i];
        return AnimatedContainer(
          duration: Duration(milliseconds: 300 + (i * 50)),
          curve: Curves.easeOutBack,
          child: Hero(
            tag: 'item_${item.name}_$i',
            child: GestureDetector(
              onTap: () {
                Get.to(
                      () => DetailScreen(item: item),
                  transition: Transition.zoom,
                  duration: const Duration(milliseconds: 400),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Background Image
                      Image.asset(
                        item.photo,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.grey.shade200,
                                  Colors.grey.shade300,
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.broken_image_rounded,
                                size: 48,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                      // Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                      // Content
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontFamily: 'Arial',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 6,
                                      color: Colors.black54,
                                      offset: Offset(0, 2),
                                    )
                                  ],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.visibility_rounded,
                                      size: 12,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'View Details',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Hover Effect (for web/desktop)
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Get.to(
                                  () => DetailScreen(item: item),
                              transition: Transition.zoom,
                              duration: const Duration(milliseconds: 400),
                            );
                          },
                          borderRadius: BorderRadius.circular(20),
                          splashColor: Colors.white.withOpacity(0.2),
                          highlightColor: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}