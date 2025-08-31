import 'dart:ui';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:encyclopedia/responsive_design/responsive_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/kingdom_controller.dart';
import 'package:flutter_tts/flutter_tts.dart';
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
  late FlutterTts flutterTts;
  bool isSpeaking = false;

  // Add state variable to track audio playing
  bool isPlaying = false;
  late StreamSubscription<PlayerState> _playerStateSubscription;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    flutterTts = FlutterTts();
    flutterTts.setLanguage("en-IN");
    flutterTts.setSpeechRate(0.5);
    flutterTts.setPitch(1.0);

    flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() => isSpeaking = false);
      }
    });
    // Adjust pitch

    // Listen to audio player state changes with proper disposal handling
    _playerStateSubscription = player.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      }
    });

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
    _playerStateSubscription.cancel(); // Cancel the subscription
    _animationController.dispose();
    super.dispose();
  }

  // Method to get appropriate icon based on species type
  IconData getSpeciesIcon() {
    final item = widget.item;
    if (controller.animalList.contains(item) || controller.reptileList.contains(item)) {
      return Icons.pets_rounded; // For animals and reptiles
    } else if (controller.birdList.contains(item)) {
      return Icons.flutter_dash_rounded; // For birds
    } else if (controller.insectList.contains(item)) {
      return Icons.bug_report_rounded; // For insects
    }
    return Icons.pets_rounded; // Default fallback
  }

  // Method to get the species title based on its type
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

  // Updated method to handle sound play/stop
  Future<void> _handleSoundButton() async {
    final String? sound = widget.item.sound;

    if (isPlaying) {
      // Stop the sound if it's currently playing
      await player.stop();
    } else {
      // Play the sound if it's not playing
      if (sound != null && sound.isNotEmpty) {
        await player.stop(); // Stop any previous sound
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
    }
  }

  //Updated method to handle voice play/stop
  Future<void> _handleVoiceButton() async {
    final String speciesName = widget.item.name ?? "Unknown creature";

    if (isSpeaking) {
      await flutterTts.stop();
      setState(() => isSpeaking = false);
    } else {
      setState(() => isSpeaking = true);
      await flutterTts.speak(speciesName);
    }
  }

  // Updated method to use controller's getRelatedSpecies
  List<dynamic> getRelatedSpecies() {
    return controller.getRelatedSpecies(widget.item).take(5).toList();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final String continentName = item.continentName;
    final String foodName = item.foodName;
    final String typeName = item.typeName;
    final String? sound = item.sound;
    final String? voice = item.voice;
    final List<dynamic> relatedSpecies = getRelatedSpecies();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          // Custom curved image header instead of SliverAppBar
          SliverToBoxAdapter(
            child: Stack(
              children: [
                // Main curved image container
                ClipPath(
                  clipper: CurvedImageClipper(),
                  child: SizedBox(
                    height: 420,
                    width: double.infinity,
                    child: Hero(
                      tag: 'detail_image_${item.name}',
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            item.photo ?? '',
                            fit: BoxFit.cover,
                          ),
                          // Gradient overlay
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.3),
                                  Colors.black.withOpacity(0.6),
                                ],
                                stops: const [0.3, 0.7, 1.0],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Back button positioned on top left
                Positioned(
                  top: 50,
                  left: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ),
                ),
                // Home button positioned on top right - Fixed to go to ResponsivePage
                Positioned(
                  top: 50,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.home_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        // Stop any playing audio before going home
                        player.stop();
                        // Navigate to ResponsivePage instead of splash screen
                        Get.offAll(() => ResponsivePage());
                      },
                    ),
                  ),
                ),
                // Title positioned at bottom of curved section
                Positioned(
                  bottom: 40,
                  left: 20,
                  right: 20,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 10,
                                  color: Colors.black54,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.deepOrange.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.deepOrange.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              getSpeciesTitle().replaceAll("Other ", ""),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Action Buttons
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Updated sound button with toggle functionality
                  _buildActionButton(
                    isPlaying ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                    isPlaying ? Colors.red : Colors.orange,
                    isPlaying ? "Stop Sound" : "Play Sound",
                    _handleSoundButton,
                  ),
                  Obx(() {
                    final isFav = controller.isFavorite(item);
                    return _buildActionButton(
                      isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      Colors.pink,
                      isFav ? "Remove Favorite" : "Add Favorite",
                          () => controller.toggleFavorite(item),
                    );
                  }),
                  // Added back the third button
                  _buildActionButton(
                    isSpeaking ? Icons.spatial_audio : Icons.spatial_audio_off,
                    isSpeaking ? Colors.red : Colors.orange,
                    isSpeaking ? "Stop Voice" : "Play Voice",
                    _handleVoiceButton,
                  ),

                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
          // Website-style details section
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
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
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
          // Related species - Updated with controller method
          if (relatedSpecies.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(getSpeciesIcon(), color: Colors.lightGreen),
                        const SizedBox(width: 8),
                        Text(
                          getSpeciesTitle(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightGreen,
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
        border: Border.all(
          color: Colors.orange.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.lightGreen, size: 28),
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

  Widget _buildRelatedSpeciesCard(dynamic relatedItem) {
    return GestureDetector(
      onTap: () {
        // Stop current audio before navigating
        player.stop();
        // Updated navigation to use Navigator.push like in the second code
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailScreen(item: relatedItem),
          ),
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
                    // Stop current audio before navigating
                    player.stop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(item: relatedItem),
                      ),
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

// Custom Curved Image Clipper
class CurvedImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // Start from top-left corner
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 80);

    // Create elegant S-curve at bottom
    var firstControlPoint = Offset(size.width * 0.25, size.height - 40);
    var firstEndPoint = Offset(size.width * 0.5, size.height - 60);

    var secondControlPoint = Offset(size.width * 0.75, size.height - 80);
    var secondEndPoint = Offset(size.width, size.height - 40);

    // Draw the curves
    path.quadraticBezierTo(
        firstControlPoint.dx,
        firstControlPoint.dy,
        firstEndPoint.dx,
        firstEndPoint.dy
    );

    path.quadraticBezierTo(
        secondControlPoint.dx,
        secondControlPoint.dy,
        secondEndPoint.dx,
        secondEndPoint.dy
    );

    // Complete the path
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Original Wave Clipper (kept for reference)
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