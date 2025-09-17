import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dashboard.dart';
import 'chats.dart';
import 'shorts.dart';
import 'addownstory.dart'; // Import new screen

class StoriesPage extends StatefulWidget {
  const StoriesPage({super.key});

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  int _currentFooterIndex = 0;
  final Color _slideColor = const Color(0xFF2E0B5C);

  final List<Map<String, dynamic>> _participants = [
    {
      "name": "Eren Jaeger",
      "profile": "assets/images/buddy1.png",
      "stories": [
        {
          "video": "assets/videos/story1.mp4",
          "bio": "Tatakae by passion. Cats by love.",
          "isVideo": true,
          "captionOffset": {"dx": 50.0, "dy": 200.0}, // Example saved offset
        },
        {
          "video": "assets/videos/story3.mp4",
          "bio": "I know I made your day. You're welcome :)",
          "isVideo": true,
          "captionOffset": {"dx": 100.0, "dy": 300.0},
        }
      ]
    },
    {
      "name": "Misa",
      "profile": "assets/images/buddy2.png",
      "stories": [
        {
          "video": "assets/videos/story2.mp4",
          "bio": "Travelling is healing",
          "isVideo": true,
          "captionOffset": {"dx": 20.0, "dy": 150.0},
        }
      ]
    },
  ];

  Future<void> _addOwnStory() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddOwnStoryPage()),
    );

    if (result != null) {
      // Check if user already exists
      final existingIndex =
          _participants.indexWhere((p) => p["name"] == "You");

      if (existingIndex >= 0) {
        // Append new story to existing user's stories
        List existingStories = _participants[existingIndex]["stories"];
        existingStories.addAll(result["stories"]);
        _participants[existingIndex]["stories"] = existingStories;
      } else {
        // Add new user at top
        _participants.insert(0, result);
      }

      setState(() {});
    }
  }

  void _openParticipantStories(Map<String, dynamic> participant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ParticipantStoriesView(participant: participant),
      ),
    );
  }

  Widget _buildFooterItem(IconData icon, String label, int index,
      {VoidCallback? onTap}) {
    final bool isActive = _currentFooterIndex == index;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? Colors.purpleAccent : Colors.white70),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.purpleAccent : Colors.white70,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _slideColor,
      appBar: AppBar(
        backgroundColor: _slideColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const DashboardPage()),
            );
          },
        ),
        title: const Text(
          "Stories",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _participants.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return GestureDetector(
              onTap: _addOwnStory,
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _slideColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.add, color: Colors.white, size: 32),
                    SizedBox(width: 12),
                    Text(
                      "Add Your Own Story",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          }

          final participant = _participants[index - 1];
          return GestureDetector(
            onTap: () => _openParticipantStories(participant),
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _slideColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: participant["profile"].toString().startsWith("assets/")
                        ? AssetImage(participant["profile"])
                        : FileImage(File(participant["profile"])) as ImageProvider,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          participant["name"],
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${participant["stories"].length} story${participant["stories"].length > 1 ? "ies" : ""}",
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        color: _slideColor.withOpacity(0.6),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildFooterItem(Icons.auto_stories, "Stories", 0, onTap: () {
                setState(() => _currentFooterIndex = 0);
              }),
              _buildFooterItem(Icons.chat_bubble, "Chats", 1, onTap: () {
                setState(() => _currentFooterIndex = 1);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const ChatsPage()),
                );
              }),
              _buildFooterItem(Icons.video_collection, "Shorts", 2, onTap: () {
                setState(() => _currentFooterIndex = 2);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const ShortsPage()),
                );
              }),
              _buildFooterItem(Icons.home, "Home", 3, onTap: () {
                setState(() => _currentFooterIndex = 3);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const DashboardPage()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------- Participant Stories -----------------
class ParticipantStoriesView extends StatefulWidget {
  final Map<String, dynamic> participant;
  const ParticipantStoriesView({super.key, required this.participant});

  @override
  State<ParticipantStoriesView> createState() => _ParticipantStoriesViewState();
}

class _ParticipantStoriesViewState extends State<ParticipantStoriesView> {
  int _currentStoryIndex = 0;
  VideoPlayerController? _videoController;
  List<bool> _likedStories = [];
  final Color _slideColor = const Color(0xFF2E0B5C);

  @override
  void initState() {
    super.initState();
    _likedStories =
        List.generate(widget.participant["stories"].length, (_) => false);
    _initializeStory();
  }

  Future<void> _initializeStory() async {
    final story = widget.participant["stories"][_currentStoryIndex];
    _videoController?.dispose();

    if (story["isVideo"] == true && story["video"] != null) {
      final file = File(story["video"]);
      _videoController =
          file.existsSync() ? VideoPlayerController.file(file) : VideoPlayerController.asset(story["video"]);
      await _videoController!.initialize();
      setState(() {});
      _videoController!.play();
      _videoController!.setLooping(false);
      _videoController!.addListener(() {
        if (_videoController!.value.position >=
                _videoController!.value.duration &&
            !_videoController!.value.isPlaying) {
          _onStoryComplete();
        }
        setState(() {});
      });
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) _onStoryComplete();
      });
    }
  }

  void _onStoryComplete() {
    if (_currentStoryIndex < widget.participant["stories"].length - 1) {
      _nextStory();
    } else {
      Navigator.pop(context);
    }
  }

  void _nextStory() {
    if (_currentStoryIndex < widget.participant["stories"].length - 1) {
      setState(() => _currentStoryIndex++);
      _initializeStory();
    }
  }

  void _previousStory() {
    if (_currentStoryIndex > 0) {
      setState(() => _currentStoryIndex--);
      _initializeStory();
    } else {
      Navigator.pop(context);
    }
  }

  double _getProgress(int index) {
    final story = widget.participant["stories"][index];
    if (story["isVideo"] == true && _videoController != null && _videoController!.value.isInitialized) {
      if (index < _currentStoryIndex) return 1.0;
      if (index > _currentStoryIndex) return 0.0;
      return _videoController!.value.position.inMilliseconds /
          _videoController!.value.duration.inMilliseconds;
    } else {
      if (index < _currentStoryIndex) return 1.0;
      if (index > _currentStoryIndex) return 0.0;
      return 1.0;
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.participant["stories"][_currentStoryIndex];
    final paddingTop = MediaQuery.of(context).padding.top;
    final screenSize = MediaQuery.of(context).size;

    Widget storyContent;
    if (story["isVideo"] == true && _videoController != null && _videoController!.value.isInitialized) {
      storyContent = VideoPlayer(_videoController!);
    } else if (story["video"] != null && File(story["video"]).existsSync()) {
      storyContent = Image.file(File(story["video"]), fit: BoxFit.cover);
    } else if (story["background"] != null) {
      storyContent = Container(color: Color(story["background"])); 
    } else {
      storyContent = Center(
        child: Text("Story unavailable",
            style: TextStyle(color: Colors.white70)),
      );
    }

    // Get saved caption position or default
    Offset captionOffset = Offset(16, screenSize.height - 150);
    if (story.containsKey("captionOffset")) {
      final offsetMap = story["captionOffset"];
      if (offsetMap != null) {
        captionOffset = Offset(offsetMap["dx"], offsetMap["dy"]);
      }
    }

    return Scaffold(
      backgroundColor: _slideColor,
      body: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) {
              final width = MediaQuery.of(context).size.width;
              if (details.globalPosition.dx < width / 2) {
                _previousStory();
              } else {
                _nextStory();
              }
            },
            child: SizedBox.expand(child: storyContent),
          ),
          Positioned(
            top: paddingTop + 8,
            left: 16,
            right: 16,
            child: Row(
              children: List.generate(widget.participant["stories"].length,
                  (index) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      widthFactor: _getProgress(index),
                      alignment: Alignment.centerLeft,
                      child: Container(color: Colors.white),
                    ),
                  ),
                );
              }),
            ),
          ),
          Positioned(
            top: paddingTop + 24,
            left: 8,
            right: 8,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                CircleAvatar(
                  radius: 18,
                  backgroundImage: widget.participant["profile"].toString().startsWith("assets/")
                      ? AssetImage(widget.participant["profile"])
                      : FileImage(File(widget.participant["profile"])) as ImageProvider,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.participant["name"],
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _likedStories[_currentStoryIndex] =
                          !_likedStories[_currentStoryIndex];
                    });
                  },
                  child: Icon(
                    _likedStories[_currentStoryIndex]
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: _likedStories[_currentStoryIndex]
                        ? Colors.red
                        : Colors.white,
                    size: 26,
                  ),
                ),
              ],
            ),
          ),
          // Caption at saved position
          if (story["bio"] != null && story["bio"].toString().isNotEmpty)
            Positioned(
              left: captionOffset.dx,
              top: captionOffset.dy,
              child: Container(
                width: 250,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  story["bio"],
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
