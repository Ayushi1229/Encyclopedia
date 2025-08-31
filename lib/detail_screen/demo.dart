import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/kingdom_controller.dart';
import '../db/db_helper.dart';

class DetailScreen extends StatefulWidget {
  final dynamic item;

  const DetailScreen({super.key, required this.item});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> with TickerProviderStateMixin {
  final KingdomController controller = Get.find();
  late final AudioPlayer player;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    player.stop();
    player.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<Map<String, String>> fetchDetails() async {
    final db = DBHelper();
    String continentName = "Not found";
    String foodName = "Not found";
    String typeName = "Not found";

    return {
      'continentName': continentName,
      'foodName': foodName,
      'typeName': typeName,
    };
  }

  List<dynamic> getRelatedSpecies() {
    final item = widget.item;

    // Determine the category of current item
    if (controller.animalList.contains(item)) {
      return controller.animalList.where((animal) => animal != item).toList();
    } else if (controller.birdList.contains(item)) {
      return controller.birdList.where((bird) => bird != item).toList();
    } else if (controller.insectList.contains(item)) {
      return controller.insectList.where((insect) => insect != item).toList();
    } else if (controller.reptileList.contains(item)) {
      return controller.reptileList.where((reptile) => reptile != item).toList();
    }

    return [];
  }

  String getSpeciesTitle() {
    final item = widget.item;

    if (controller.animalList.contains(item)) {
      return "Other Animals";
    } else if (controller.birdList.contains(item)) {
      return "Other Birds";
    } else if (controller.insectList.contains(item)) {
      return "Other Insects";
    } else if (controller.reptileList.contains(item)) {
      return "Other Reptiles";
    }

    return "Related Species";
  }

  @override
  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final String continentName = item.continentName;
    final String foodName = item.foodName;
    final String typeName = item.typeName;
    final String? sound = item.sound;
    final List<dynamic> relatedSpecies = getRelatedSpecies();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 400,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'detail_image_${item.name}',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      item.photo ?? '',
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.4),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Title Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  item.name ?? 'Unknown',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
              ),
            ),
          ),

          // Buttons
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(Icons.volume_up_rounded, Colors.orange, "Play Sound", () async {
                  if (sound != null && sound.isNotEmpty) {
                    await player.stop();
                    await player.play(AssetSource('sound/$sound'));
                  } else {
                    Get.snackbar(
                      "No Sound",
                      "This species has no sound.",
                      backgroundColor: Colors.orange.withOpacity(0.8),
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                }),
                Obx(() {
                  final isFav = controller.isFavorite(item);
                  return _buildActionButton(
                    isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    Colors.pink,
                    isFav ? "Remove Favorite" : "Add Favorite",
                        () => controller.toggleFavorite(item),
                  );
                }),
                _buildActionButton(Icons.spatial_audio_rounded, Colors.blue, "Audio Effect", () async {
                  if (sound != null && sound.isNotEmpty) {
                    await player.stop();
                    await player.play(AssetSource('sound/$sound'));
                  }
                }),
              ],
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // Website-style details section
          SliverToBoxAdapter(
            child: FutureBuilder<Map<String, String>>(
              future: fetchDetails(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(color: Colors.deepOrange),
                    ),
                  );
                }

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    runSpacing: 16,
                    children: [
                      _buildDetailBox(Icons.public_rounded, "Continent", continentName),
                      _buildDetailBox(Icons.restaurant_rounded, "Food Type", foodName),
                      _buildDetailBox(Icons.landscape_rounded, "Mode Type", typeName),
                    ],
                  ),
                );
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),

          // Related species
          if (relatedSpecies.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.pets_rounded, color: Colors.deepOrange),
                        SizedBox(width: 8),
                        Text(
                          "Related Species",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: relatedSpecies.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 150,
                            margin: EdgeInsets.only(right: index == relatedSpecies.length - 1 ? 0 : 12),
                            child: _buildRelatedSpeciesCard(relatedSpecies[index]),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildDetailBox(IconData icon, String title, String value) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.deepOrange, size: 28),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }


  Widget _buildActionButton(IconData icon, Color color, String tooltip, VoidCallback onPressed) {
    return Tooltip(
      message: tooltip,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: color,
            elevation: 0,
            padding: const EdgeInsets.all(20),
          ),
          child: Icon(icon, size: 28, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.deepOrange, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value ?? 'N/A',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedSpeciesCard(dynamic relatedItem) {
    return GestureDetector(
      onTap: () {
        // Recursive navigation to another DetailScreen
        Get.to(
              () => DetailScreen(item: relatedItem),
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 300),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image
              Image.asset(
                relatedItem.photo ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.grey.shade200,
                        Colors.grey.shade400,
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.broken_image_rounded,
                      size: 32,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              // Content
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        relatedItem.name ?? 'Unknown',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          shadows: [
                            Shadow(
                              blurRadius: 4,
                              color: Colors.black54,
                              offset: Offset(0, 1),
                            ),
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
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "Tap to explore",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Tap effect
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Get.to(
                          () => DetailScreen(item: relatedItem),
                      transition: Transition.rightToLeft,
                      duration: const Duration(milliseconds: 300),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  splashColor: Colors.white.withOpacity(0.2),
                  highlightColor: Colors.white.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 🌊 Wave Clipper
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 60);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 60);
    var secondControlPoint = Offset(3 * size.width / 4, size.height - 120);
    var secondEndPoint = Offset(size.width, size.height - 60);
    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(
        secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}