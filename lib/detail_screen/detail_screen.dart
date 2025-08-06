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

class _DetailScreenState extends State<DetailScreen> {
  final KingdomController controller = Get.find();
  late final AudioPlayer player;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
  }

  @override
  void dispose() {
    player.stop(); // 🛑 Stop sound
    player.dispose(); // 🔁 Release resources
    super.dispose();
  }

  Future<Map<String, String>> fetchDetails() async {
    final db = DBHelper();
    String continentName = "Not found";
    String foodName = "Not found";
    String typeName = "Not found";

    // You can implement real DB logic here
    return {
      'continentName': continentName,
      'foodName': foodName,
      'typeName': typeName,
    };
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final String continentName = item.continentName;
    final String foodName = item.foodName;
    final String typeName = item.typeName;
    final String? sound = item.sound;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            ClipPath(
              clipper: WaveClipper(),
              child: SizedBox(
                height: 450,
                width: double.infinity,
                child: Image.asset(
                  item.photo ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.broken_image, size: 50)),
                ),
              ),
            ),

            // Back button
            Positioned(
              top: 16,
              left: 16,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.deepOrange),
                  onPressed: () => Get.back(),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 430),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Column(
                  children: [
                    Text(
                      item.name ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        actionButton(Icons.volume_up, Colors.orange, () async {
                          if (sound != null && sound.isNotEmpty) {
                            await player.stop(); // stop previous sound
                            await player.play(AssetSource('sound/$sound'));
                          } else {
                            Get.snackbar("No Sound", "This animal has no sound.");
                          }
                        }),

                        Obx(() {
                          final isFav = controller.isFavorite(item);
                          return actionButton(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            Colors.pink,
                                () {
                              controller.toggleFavorite(item);
                            },
                          );
                        }),

                        actionButton(Icons.spatial_audio, Colors.blue, () async {
                          if (sound != null && sound.isNotEmpty) {
                            await player.stop();
                            await player.play(AssetSource('sound/$sound'));
                          }
                        }),
                      ],
                    ),

                    const SizedBox(height: 30),

                    FutureBuilder<Map<String, String>>(
                      future: fetchDetails(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        return ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.orangeAccent.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  detailRow(Icons.public, "Continent", continentName),
                                  detailRow(Icons.restaurant, "Food Type", foodName),
                                  detailRow(Icons.landscape, "Mode Type", typeName),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget actionButton(IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: color,
        elevation: 6,
        padding: const EdgeInsets.all(20),
      ),
      child: Icon(icon, size: 28, color: Colors.white),
    );
  }

  Widget detailRow(IconData icon, String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepOrange),
          const SizedBox(width: 12),
          Text(
            "$title: ",
            style: const TextStyle(fontSize: 16),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
        ],
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
