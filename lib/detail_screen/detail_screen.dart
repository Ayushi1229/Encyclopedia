import 'dart:ui';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:encyclopedia/responsive_design/responsive_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Add this import
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import '../controller/kingdom_controller.dart';
import '../responsive_pages/large_view.dart';
// import '../utils/import_export.dart';

class DetailScreen extends StatefulWidget {
  final dynamic item;
  const DetailScreen({super.key, required this.item});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
  final KingdomController controller = Get.find();
  final AudioManager _audioManager = AudioManager();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isPlaying = false;
  bool _isSpeaking = false;
  Timer? _statusTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAudio();
    _initializeAnimations();
    _startStatusTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _audioManager.stopAll();
    }
  }

  void _initializeAudio() async {
    try {
      await _audioManager.initialize();
    } catch (e) {
      debugPrint('Error initializing audio: $e');
    }
  }

  void _initializeAnimations() {
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

  void _startStatusTimer() {
    _statusTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
        final isPlaying = _audioManager.isPlaying;
        final isSpeaking = _audioManager.isSpeaking;

        if (_isPlaying != isPlaying || _isSpeaking != isSpeaking) {
          setState(() {
            _isPlaying = isPlaying;
            _isSpeaking = isSpeaking;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _statusTimer?.cancel();
    _animationController.dispose();
    _audioManager.stopAll();
    super.dispose();
  }

  // NEW METHOD: Navigate to reel view instead of full screen image
  void _navigateToReelView() {
    // Stop any playing audio before navigation
    _audioManager.stopAll();

    // Get the appropriate list and find the current item's index
    List<dynamic> items = _getItemList();
    int currentIndex = items.indexWhere((item) => item.name == widget.item.name);
    if (currentIndex == -1) currentIndex = 0; // Fallback to first item if not found

    // Navigate to ReelView with proper parameters
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReelView(
          items: items,
          initialIndex: currentIndex,
          categoryTitle: getSpeciesTitle(),
        ),
      ),
    );
  }

  // Helper method to get the appropriate item list based on species type
  List<dynamic> _getItemList() {
    final item = widget.item;
    if (controller.animalList.contains(item)) {
      return controller.animalList;
    } else if (controller.birdList.contains(item)) {
      return controller.birdList;
    } else if (controller.insectList.contains(item)) {
      return controller.insectList;
    } else if (controller.reptileList.contains(item)) {
      return controller.reptileList;
    }
    // If not found in any specific category, return all items or related species
    return controller.getRelatedSpecies(widget.item);
  }

  IconData getSpeciesIcon() {
    final item = widget.item;
    if (controller.animalList.contains(item) || controller.reptileList.contains(item)) {
      return Icons.pets_rounded;
    } else if (controller.birdList.contains(item)) {
      return Icons.flutter_dash_rounded;
    } else if (controller.insectList.contains(item)) {
      return Icons.bug_report_rounded;
    }
    return Icons.pets_rounded;
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

  Future<void> _handleHomeNavigation() async {
    try {
      await _audioManager.stopAll();

      if (Navigator.canPop(context)) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const ResponsivePage()),
              (route) => false,
        );
      }
    } catch (e) {
      debugPrint('Error navigating to home: $e');
      try {
        Get.offAllNamed('/');
      } catch (getError) {
        debugPrint('GetX navigation also failed: $getError');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ResponsivePage()),
        );
      }
    }
  }

  Future<void> _handleSoundButton() async {
    try {
      if (_isPlaying) {
        await _audioManager.stopSound();
      } else {
        final String? sound = widget.item.sound;
        if (sound != null && sound.isNotEmpty) {
          await _audioManager.playSound(sound);
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
    } catch (e) {
      debugPrint('Error handling sound: $e');
      Get.snackbar(
        "Error",
        "Could not play sound",
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _handleVoiceButton() async {
    try {
      if (_isSpeaking) {
        await _audioManager.stopSpeaking();
      } else {
        final String speciesName = widget.item.name ?? "Unknown creature";
        await _audioManager.speak(speciesName);
      }
    } catch (e) {
      debugPrint('Error handling voice: $e');
      Get.snackbar(
        "Error",
        "Could not play voice",
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  List<dynamic> getRelatedSpecies() {
    return controller.getRelatedSpecies(widget.item).take(5).toList();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final String continentName = item.continentName;
    final String foodName = item.foodName;
    final String typeName = item.typeName;
    final List<dynamic> relatedSpecies = getRelatedSpecies();

    return WillPopScope(
      onWillPop: () async {
        await _audioManager.stopAll();
        return true; // Allow the pop
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  ClipPath(
                    clipper: CurvedImageClipper(),
                    child: SizedBox(
                      height: 420,
                      width: double.infinity,
                      child: Hero(
                        tag: 'detail_image_${item.name}',
                        child: GestureDetector(
                          // CHANGED: Now calls _navigateToReelView instead of _showFullScreenImage
                          onTap: _navigateToReelView,
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
                                      Colors.black.withOpacity(0.3),
                                      Colors.black.withOpacity(0.6),
                                    ],
                                    stops: const [0.3, 0.7, 1.0],
                                  ),
                                ),
                              ),
                              // ADDED: Visual indicator that image is tappable for reel view
                              Positioned(
                                top: 20,
                                right: 20,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.play_circle_outline,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "Reel View",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
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
                        onPressed: () async {
                          await _audioManager.stopAll();
                          Get.back();
                        },
                      ),
                    ),
                  ),
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
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: _handleHomeNavigation,
                          splashColor: Colors.white.withOpacity(0.2),
                          highlightColor: Colors.white.withOpacity(0.1),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.home_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Title
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
                    _buildActionButton(
                      _isPlaying ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                      _isPlaying ? Colors.red : Colors.orange,
                      _isPlaying ? "Stop Sound" : "Play Sound",
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
                    _buildActionButton(
                      _isSpeaking ? Icons.spatial_audio : Icons.spatial_audio_off,
                      _isSpeaking ? Colors.red : Colors.green,
                      _isSpeaking ? "Stop Voice" : "Play Voice",
                      _handleVoiceButton,
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 30)),
            // Details section
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
            // Related species
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
      onTap: () async {
        await _audioManager.stopAll();
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
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    await _audioManager.stopAll();
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

// AudioManager class (include this in the same file or create a separate file)
class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();


  FlutterTts? _flutterTts;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  bool _isPlaying = false;
  bool _isSpeaking = false;
  // late AudioPlayer player;
  AudioPlayer? _player;

  bool get isPlaying => _isPlaying;
  bool get isSpeaking => _isSpeaking;

  Future<void> initialize() async {
    try {
      if (_player != null && _flutterTts != null) {
        return; // already initialized
      }
      _player ??= AudioPlayer();
      _flutterTts ??= FlutterTts();

      await _flutterTts?.setLanguage("en-IN");
      await _flutterTts?.setSpeechRate(0.5);
      await _flutterTts?.setPitch(1.0);

      _flutterTts?.setCompletionHandler(() {
        _isSpeaking = false;
      });

      _playerStateSubscription?.cancel();
      _playerStateSubscription =
          _player?.onPlayerStateChanged.listen((PlayerState state) {
            _isPlaying = state == PlayerState.playing;
          });

    } catch (e) {
      debugPrint('Error initializing AudioManager: $e');
    }
  }

  Future<void> playAudio(String url) async {
    if (_isSpeaking) await stopTts();
    await _player?.play(UrlSource(url));
    _isPlaying = true;
  }

  Future<void> stopAudio() async {
    await _player?.stop();
    _isPlaying = false;
  }

  Future<void> speak(String text) async {
    if (_isPlaying) await stopAudio();
    await _flutterTts?.speak(text);
    _isSpeaking = true;
  }

  Future<void> stopTts() async {
    await _flutterTts?.stop();
    _isSpeaking = false;
  }

  Future<void> playSound(String soundPath) async {
    try {
      if (_player == null) await initialize();
      await _player?.stop();
      await _player?.play(AssetSource('sound/$soundPath'));
    } catch (e) {
      debugPrint('Error playing sound: $e');
      rethrow;
    }
  }

  Future<void> stopSound() async {
    try {
      await _player?.stop();
    } catch (e) {
      debugPrint('Error stopping sound: $e');
    }
  }


  Future<void> stopSpeaking() async {
    try {
      await _flutterTts?.stop();
      _isSpeaking = false;
    } catch (e) {
      debugPrint('Error stopping speech: $e');
    }
  }

  Future<void> stopAll() async {
    try {
      await stopSound();
      await stopSpeaking();
    } catch (e) {
      debugPrint('Error stopping all audio: $e');
    }
  }

  void dispose() {
    try {
      _playerStateSubscription?.cancel();
      _player?.dispose();
      _flutterTts?.stop();
      _isPlaying = false;
      _isSpeaking = false;
    } catch (e) {
      debugPrint('Error disposing AudioManager: $e');
    }
  }
}

// Custom Curved Image Clipper
class CurvedImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 80);

    var firstControlPoint = Offset(size.width * 0.25, size.height - 40);
    var firstEndPoint = Offset(size.width * 0.5, size.height - 60);

    var secondControlPoint = Offset(size.width * 0.75, size.height - 80);
    var secondEndPoint = Offset(size.width, size.height - 40);

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

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}