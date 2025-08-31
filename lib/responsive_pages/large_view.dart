import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../detail_screen/detail_screen.dart';
import '../utils/import_export.dart';
import 'package:google_fonts/google_fonts.dart';

class LargeView extends StatefulWidget {
  LargeView({Key? key}) : super(key: key) {
    Get.put(KingdomController());
  }

  @override
  State<LargeView> createState() => _LargeViewState();
}

class _LargeViewState extends State<LargeView> {
  final KingdomController controller = Get.find();
  final TextEditingController _searchController = TextEditingController();
  int _currentIndex = 0;
  late final PageController _pageController;

  // Single search query for current tab
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);

    // Ensure data is loaded when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Force a rebuild after the frame is built to ensure controller data is available
      if (mounted) {
        setState(() {});
      }
    });

    // Also try to trigger data loading if controller has a method for it
    // Uncomment the line below if your controller has a loadData method
    // controller.loadData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Helper method to get current list based on selected tab
  List<dynamic> _getCurrentListForTab(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return controller.animalList;
      case 1:
        return controller.birdList;
      case 2:
        return controller.insectList;
      case 3:
        return controller.reptileList;
      default:
        return controller.animalList;
    }
  }

  // Get filtered items based on search query for current tab
  List<dynamic> _getFilteredItems() {
    List<dynamic> currentList = _getCurrentListForTab(_currentIndex);

    if (_searchQuery.isEmpty) {
      return currentList;
    }

    final lowerQuery = _searchQuery.toLowerCase().trim();
    return currentList.where((item) {
      final nameMatch = item.name.toLowerCase().contains(lowerQuery);
      final continentMatch = (item.continentName ?? '').toLowerCase().contains(lowerQuery);
      return nameMatch || continentMatch;
    }).toList();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
    });
  }

  void _onTabChanged(int index) {
    if (_currentIndex == index) return; // Prevent unnecessary animations

    setState(() {
      _currentIndex = index;
      // Clear search when changing tabs for better UX
      _searchController.clear();
      _searchQuery = '';
    });

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
    );

    controller.selectedTabIndex.value = index;
  }

  String _getCurrentTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Animals';
      case 1:
        return 'Birds';
      case 2:
        return 'Insects';
      case 3:
        return 'Reptiles';
      default:
        return 'Animals';
    }
  }

  Widget _buildCustomSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.lightGreen.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 2,
          ),
        ],
        border: Border.all(
          color: Colors.lightGreen.shade100,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Icon(
              Icons.search_rounded,
              color: Colors.lightGreen.shade600,
              size: 24,
            ),
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search ${_getCurrentTitle().toLowerCase()}...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 16,
                ),
              ),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          if (_searchQuery.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _clearSearch,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.clear_rounded,
                      color: Colors.grey.shade600,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.lightGreen.shade400,
                  Colors.lightGreen.shade600,
                ],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              _getCurrentTitle(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
          // Clear search when swiping to different tab
          _searchController.clear();
          _searchQuery = '';
        });
        controller.selectedTabIndex.value = index;
      },
      itemCount: 4,
      itemBuilder: (context, index) {
        return Obx(() {
          // Get data for the specific tab
          List<dynamic> tabData = _getCurrentListForTab(index);

          // Apply search filter only for current visible tab
          List<dynamic> displayData = tabData;
          if (index == _currentIndex && _searchQuery.isNotEmpty) {
            final lowerQuery = _searchQuery.toLowerCase().trim();
            displayData = tabData.where((item) {
              final nameMatch = item.name.toLowerCase().contains(lowerQuery);
              final continentMatch = (item.continentName ?? '').toLowerCase().contains(lowerQuery);
              return nameMatch || continentMatch;
            }).toList();
          }

          // Check if data is loading for current tab
          if (displayData.isEmpty && _searchQuery.isEmpty && index == _currentIndex) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen),
              ),
            );
          }

          // Check if search is active but no results found for current tab
          if (_searchQuery.isNotEmpty && displayData.isEmpty && index == _currentIndex) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.lightGreen.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.search_off_rounded,
                      size: 60,
                      color: Colors.lightGreen.shade400,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No ${_getTitleForIndex(index).toLowerCase()} found',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try searching with different keywords',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          }

          // Show the data
          return buildGrid(displayData);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.lightGreen.shade400,
                Colors.lightGreen.shade600,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.lightGreen.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
          ),
        ),
        title: Text(
          APPBAR_TITLE,
          style: GoogleFonts.poppins(
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
        centerTitle: false,
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
                if (value == 'About us') {
                  Get.to(() => const About());
                } else if (value == 'Feedback') {
                  // Handle feedback
                } else if (value == 'Share') {
                  // Handle share
                } else if (value == 'Other Apps') {
                  // Handle other apps
                } else if (value == 'Check for update') {
                  // Handle update check
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'About us',
                  child: Row(
                    children: [
                      Icon(Icons.info_outline_rounded,
                          color: Colors.lightGreen.shade400),
                      const SizedBox(width: 12),
                      const Text('About us',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'Feedback',
                  child: Row(
                    children: [
                      Icon(Icons.feedback_outlined,
                          color: Colors.lightGreen.shade400),
                      const SizedBox(width: 12),
                      const Text('Feedback',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'Share',
                  child: Row(
                    children: [
                      Icon(Icons.share_outlined,
                          color: Colors.lightGreen.shade400),
                      const SizedBox(width: 12),
                      const Text('Share',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'Other Apps',
                  child: Row(
                    children: [
                      Icon(Icons.apps_outlined,
                          color: Colors.lightGreen.shade400),
                      const SizedBox(width: 12),
                      const Text('Other Apps',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'Check for update',
                  child: Row(
                    children: [
                      Icon(Icons.system_update_outlined,
                          color: Colors.lightGreen.shade400),
                      const SizedBox(width: 12),
                      const Text('Check for update',
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
          _buildCustomSearchBar(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.lightGreen.shade50,
                    Colors.white,
                  ],
                ),
              ),
              child: _buildContent(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    final List<IconData> iconList = [
      Icons.pets_rounded,
      Icons.flutter_dash_rounded,
      Icons.bug_report_rounded,
      Icons.nature_rounded,
    ];

    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(iconList.length, (index) {
          return GestureDetector(
            onTap: () => _onTabChanged(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? Colors.lightGreen.shade600
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    boxShadow: _currentIndex == index
                        ? [
                      const BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, -4),
                      ),
                    ]
                        : null,
                  ),
                  transform: Matrix4.identity()
                    ..translate(0.0, _currentIndex == index ? -10.0 : 0.0)
                    ..scale(_currentIndex == index ? 1.2 : 1.0),
                  child: Icon(
                    iconList[index],
                    color: _currentIndex == index
                        ? Colors.white
                        : Colors.lightGreen.shade600,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _getLabelForIndex(index),
                  style: TextStyle(
                    color: _currentIndex == index
                        ? Colors.lightGreen.shade600
                        : Colors.lightGreen.shade400,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  String _getLabelForIndex(int index) {
    switch (index) {
      case 0:
        return 'Animals';
      case 1:
        return 'Birds';
      case 2:
        return 'Insects';
      case 3:
        return 'Reptiles';
      default:
        return '';
    }
  }

  String _getTitleForIndex(int index) {
    switch (index) {
      case 0:
        return 'Animals';
      case 1:
        return 'Birds';
      case 2:
        return 'Insects';
      case 3:
        return 'Reptiles';
      default:
        return 'Animals';
    }
  }

  Widget buildGrid(List<dynamic> items) {
    return GridView.builder(
      itemCount: items.length,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 0.65,
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