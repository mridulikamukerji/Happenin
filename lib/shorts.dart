import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dashboard.dart'; // ✅ Import Dashboard page

class ShortsPage extends StatefulWidget {
  const ShortsPage({super.key});

  @override
  State<ShortsPage> createState() => _ShortsPageState();
}

class _ShortsPageState extends State<ShortsPage> {
  final PageController _pageController = PageController();
  final List<Map<String, String>> _shorts = [
    {
      "video": "assets/videos/story1.mp4",
      "name": "Eren Jaeger",
      "description": "Enjoying the freedom!",
    },
    {
      "video": "assets/videos/story2.mp4",
      "name": "Misa",
      "description": "Living my self-love era",
    },
  ];

  final List<VideoPlayerController> _videoControllers = [];
  final Set<int> _likedShorts = {};

  @override
  void initState() {
    super.initState();
    for (var short in _shorts) {
      final controller = VideoPlayerController.asset(short['video']!)
        ..initialize().then((_) {
          setState(() {});
        })
        ..setLooping(true)
        ..play();
      _videoControllers.add(controller);
    }
  }

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  void _toggleLike(int index) {
    setState(() {
      if (_likedShorts.contains(index)) {
        _likedShorts.remove(index);
      } else {
        _likedShorts.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            scrollDirection: Axis.vertical,
            controller: _pageController,
            itemCount: _shorts.length,
            itemBuilder: (context, index) {
              final short = _shorts[index];
              final controller = _videoControllers[index];

              return controller.value.isInitialized
                  ? Stack(
                      children: [
                        SizedBox.expand(
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: controller.value.size.width,
                              height: controller.value.size.height,
                              child: VideoPlayer(controller),
                            ),
                          ),
                        ),
                        // Overlay gradient for text visibility
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        // Poster name and description
                        Positioned(
                          left: 16,
                          bottom: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                short['name']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                short['description']!,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Like button
                        Positioned(
                          right: 16,
                          bottom: 80,
                          child: IconButton(
                            iconSize: 32,
                            icon: Icon(
                              Icons.favorite,
                              color: _likedShorts.contains(index)
                                  ? Colors.redAccent
                                  : Colors.white70,
                            ),
                            onPressed: () => _toggleLike(index),
                          ),
                        ),
                      ],
                    )
                  : const Center(child: CircularProgressIndicator());
            },
          ),

          // ---------- BACK BUTTON ----------
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const DashboardPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
