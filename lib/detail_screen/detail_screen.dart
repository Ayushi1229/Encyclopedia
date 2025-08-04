import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/kingdom_controller.dart';
import '../db/db_helper.dart';

class DetailScreen extends StatelessWidget {
  final dynamic item;
  final KingdomController kingdomController = Get.find();

  DetailScreen({super.key, required this.item});

  Future<Map<String, String>> fetchDetails() async {
    final db = DBHelper();
    String continentName = "Not found";
    String foodName = "Not found";
    String typeName = "Not found";

    try {
      // DB logic can be added here
    } catch (e) {
      print("Error: $e");
    }

    return {
      'continentName': continentName,
      'foodName': foodName,
      'typeName': typeName,
    };
  }

  @override
  Widget build(BuildContext context) {
    final String continentName = item.continentName;
    final String foodName = item.foodName;
    final String typeName = item.typeName;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // 📸 Background Image + Clipper
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

            // 🔙 Back Button
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

            // 📋 Scrollable Content with top padding
            Padding(
              padding: const EdgeInsets.only(top: 430),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Column(
                  children: [
                    // 🐾 Name
                    Text(
                      item.name ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 🎧 Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        actionButton(Icons.volume_up, Colors.orange),
                        actionButton(Icons.favorite_border, Colors.pink),
                        actionButton(Icons.spatial_audio, Colors.blue),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // 📄 Details Card
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


  Widget actionButton(IconData icon, Color color) {
    return ElevatedButton(
      onPressed: () {},
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
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

// 🌊 Custom Wave Clipper
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
