import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dashboard.dart';
import 'chats.dart';
import 'shorts.dart';

class StoriesPage extends StatefulWidget {
  const StoriesPage({super.key});

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  int _currentFooterIndex = 0;

  final List<Map<String, dynamic>> _participants = [
    {
      "name": "Eren Jaeger",
      "profile": "assets/images/buddy1.png",
      "stories": [
        {"video": "assets/videos/story1.mp4", "bio": "Tatakae by passion. Cats by love."},
        {"video": "assets/videos/story3.mp4", "bio": "I know I made your day. You're welcome :)"}
      ]
    },
    {
      "name": "Misa",
      "profile": "assets/images/buddy2.png",
      "stories": [
        {"video": "assets/videos/story2.mp4", "bio": "Travelling is healing"}
      ]
    },
  ];

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _participants.insert(0, {
          "name": "You",
          "profile": "assets/images/profile_placeholder.png",
          "stories": [
            {"video": pickedFile.path, "bio": "My new story"}
          ]
        });
      });
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

  Widget _buildFooterItem(IconData icon, String label, int index, {VoidCallback? onTap}) {
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
              onTap: _pickVideo,
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E0B5C),
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
                color: const Color(0xFF2E0B5C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage(participant["profile"]),
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
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
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
        color: Colors.black.withOpacity(0.6),
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

  @override
  void initState() {
    super.initState();
    _likedStories = List.generate(widget.participant["stories"].length, (_) => false);
    _initializeStory();
  }

  Future<void> _initializeStory() async {
    final story = widget.participant["stories"][_currentStoryIndex];
    _videoController?.dispose();
    final isLocal = File(story["video"]).existsSync();
    _videoController = isLocal ? VideoPlayerController.file(File(story["video"])) : VideoPlayerController.asset(story["video"]);
    await _videoController!.initialize();
    setState(() {});
    _videoController!.play();
    _videoController!.addListener(() {
      if (_videoController!.value.position >= _videoController!.value.duration && !_videoController!.value.isPlaying) {
        _onStoryComplete();
      }
      setState(() {});
    });
  }

  void _onStoryComplete() {
    if (_currentStoryIndex < widget.participant["stories"].length - 1) {
      _nextStory();
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const StoriesPage()),
        (route) => false,
      );
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
    if (_videoController == null || !_videoController!.value.isInitialized) return 0.0;
    if (index < _currentStoryIndex) return 1.0;
    if (index > _currentStoryIndex) return 0.0;
    return _videoController!.value.position.inMilliseconds / _videoController!.value.duration.inMilliseconds;
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video + tap areas
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) {
              final width = MediaQuery.of(context).size.width;
              final bottomLimit = 100;
              if (details.globalPosition.dy > MediaQuery.of(context).size.height - bottomLimit) return;
              if (details.globalPosition.dx < width / 2) {
                _previousStory();
              } else {
                _nextStory();
              }
            },
            child: SizedBox.expand(
              child: _videoController != null && _videoController!.value.isInitialized
                  ? VideoPlayer(_videoController!)
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),

          // Progress bars at very top
          Positioned(
            top: paddingTop + 8,
            left: 16,
            right: 16,
            child: Row(
              children: List.generate(widget.participant["stories"].length, (index) {
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

          // Header row directly BELOW progress bars
          Positioned(
            top: paddingTop + 24, // just below progress
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
                  backgroundImage: AssetImage(widget.participant["profile"]),
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
                      _likedStories[_currentStoryIndex] = !_likedStories[_currentStoryIndex];
                    });
                  },
                  child: Icon(
                    _likedStories[_currentStoryIndex] ? Icons.favorite : Icons.favorite_border,
                    color: _likedStories[_currentStoryIndex] ? Colors.red : Colors.white,
                    size: 26,
                  ),
                ),
              ],
            ),
          ),

          // Story description with blurred background
          Positioned(
            bottom: 50,
            left: 16,
            right: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.black.withOpacity(0.5),
                  child: Text(
                    story["bio"],
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
