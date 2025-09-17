import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class AddOwnStoryPage extends StatefulWidget {
  const AddOwnStoryPage({super.key});

  @override
  State<AddOwnStoryPage> createState() => _AddOwnStoryPageState();
}

class _AddOwnStoryPageState extends State<AddOwnStoryPage> {
  File? _mediaFile;
  bool _isVideo = false;
  VideoPlayerController? _videoController;
  Color? _backgroundColor;
  String _caption = "";

  final List<Color> _backgroundOptions = [
    Colors.black,
    Colors.deepPurple,
    Colors.blueGrey,
    Colors.teal,
    Colors.indigo,
    Colors.orange,
  ];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _mediaFile = File(picked.path);
        _isVideo = false;
        _videoController?.dispose();
        _backgroundColor = null;
      });
    }
  }

  Future<void> _pickVideo() async {
    final picked = await _picker.pickVideo(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _mediaFile = File(picked.path);
        _isVideo = true;
        _backgroundColor = null;
      });
      _initializeVideo();
    }
  }

  void _initializeVideo() {
    if (_mediaFile != null && _isVideo) {
      _videoController = VideoPlayerController.file(_mediaFile!)
        ..initialize().then((_) {
          setState(() {});
          _videoController!.play();
          _videoController!.setLooping(true);
        });
    }
  }

  void _selectBackground(Color color) {
    setState(() {
      _mediaFile = null;
      _videoController?.dispose();
      _backgroundColor = color;
    });
  }

  void _postStory() {
    if (_mediaFile == null && _backgroundColor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image, video, or background")),
      );
      return;
    }

    final storyData = {
      "name": "You",
      "profile": "assets/images/your_profile.png", // <-- change to your profile asset
      "stories": [
        {
          "video": _mediaFile?.path,
          "isVideo": _isVideo,
          "background": _backgroundColor?.value,
          "bio": _caption,
        }
      ]
    };

    Navigator.pop(context, storyData); // send back to StoriesPage
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Preview area
          Positioned.fill(
            child: _mediaFile != null
                ? (_isVideo
                    ? (_videoController != null &&
                            _videoController!.value.isInitialized
                        ? VideoPlayer(_videoController!)
                        : const Center(child: CircularProgressIndicator()))
                    : Image.file(_mediaFile!, fit: BoxFit.cover))
                : Container(color: _backgroundColor ?? Colors.black),
          ),

          // Top bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            right: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E0B5C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _postStory,
                  child: const Text("Post", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),

          // Caption box
          Positioned(
            bottom: 100,
            left: 16,
            right: 16,
            child: TextField(
              style: const TextStyle(color: Colors.white, fontSize: 16),
              maxLines: 2,
              decoration: InputDecoration(
                hintText: "Write a caption...",
                hintStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.black45,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) => _caption = val,
            ),
          ),

          // Media + background options
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildOption(Icons.image, "Image", _pickImage),
                  const SizedBox(width: 12),
                  _buildOption(Icons.videocam, "Video", _pickVideo),
                  const SizedBox(width: 12),
                  Row(
                    children: _backgroundOptions.map((color) {
                      return GestureDetector(
                        onTap: () => _selectBackground(color),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFF2E0B5C),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}
